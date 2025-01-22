-- (c) Khub 2012-2013.
-- Data storage handlers
-- Functions that load and alter datafile records from the database.

Datafiles.Database = {};

Datafiles.Database.EmptyDatafileData = {
	Citizenship = true,
	Warrant = false,
	LoyaltyTier = 0,
	LastSpottedTimestamp = 0,
	LastSpottedLocation = "-",
	Location = "unknown"
};

Datafiles.Database.EmptyDatafileRecords = {
	LoyaltyPoints = 0,
	Notes = {
		Medical = {},
		Loyalty = {},
		Other = {}
	}
};

function Datafiles.Database:FetchDatafileData(characterKey, callback)
	local selectObject = Clockwork.database:Select("datafiles_data");
	selectObject:AddWhere("CharacterKey = ?", characterKey);

	selectObject:SetCallback(function(result, state, queryError)
		if (!state) then
			Datafiles.Database.QueryFailHandler(queryError, "FetchDatafileData", characterKey);
			callback(false);
			return;
		end;

		if (!Clockwork.database:IsResult(result) or result == 0) then
			-- The result is either invalid or none exists yet - let's create a new one with default data and then pass those default data to the callback.
			Datafiles.Database:CreateNewDatafileDataRecord(characterKey, function()
				callback(table.Copy(Datafiles.Database.EmptyDatafileData));
			end);
		else
			local characterData = result[1];
			local characterDataTable = table.Copy(Datafiles.Database.EmptyDatafileData);

			for k, v in pairs(characterData) do
				if (characterDataTable[k] ~= nil) then
					if (type(characterDataTable[k]) == "boolean") then
						characterDataTable[k] = tonumber(v) == 1 and true or false;
					elseif (type(characterDataTable[k]) == "number") then
						characterDataTable[k] = tonumber(v);
					else
						characterDataTable[k] = v;
					end;
				end;
			end;

			callback(characterDataTable);			
		end;
	end);

	selectObject:Pull();
end;

function Datafiles.Database:CreateNewDatafileDataRecord(ck, callback)
	local insertObject = Clockwork.database:Insert("datafiles_data");

	insertObject:SetValue("CharacterKey", tonumber(ck));
	insertObject:SetValue("Citizenship", 1);
	insertObject:SetValue("Warrant", 0);
	insertObject:SetValue("LoyaltyTier", 0);
	insertObject:SetValue("LastSpottedLocation", "-");
	insertObject:SetValue("LastSpottedTimestamp", 0);
	insertObject:SetValue("Location", "City 17; Industrial Sector");

	insertObject:SetCallback(function(result, state, queryError)
		if (!state) then
			Datafiles.Database.QueryFailHandler(queryError, "CreateNewDatafileDataRecord", ck);
			callback(false);
			return;
		end;

		callback(true);
	end);

	insertObject:Push();
end;

function Datafiles.Database:FetchDatafileRecords(characterKey, callback)
	local selectObject = Clockwork.database:Select("datafiles_records");
	selectObject:AddWhere("CharacterKey = ?", characterKey);

	selectObject:SetCallback(function(result, state, queryError)
		if (!state) then
			Datafiles.Database.QueryFailHandler(queryError, "FetchDatafileRecords", characterKey);
			callback(false);
			return;
		end;

		if (!Clockwork.database:IsResult(result) or #result == 0) then
			-- No datafile records for this character - no need to make new record here, let's just toss an empty table back.
			callback(table.Copy(Datafiles.Database.EmptyDatafileRecords));
		else
			local characterNotes = table.Copy(Datafiles.Database.EmptyDatafileRecords);

			for i, record in pairs(result) do
				if (record.RecordType == "MedicalRecord") then
					table.insert(characterNotes.Notes.Medical, {
						author = record.Performer,
						time = record._Timestamp,
						content = record._Data,
						notetype = "MedicalRecord"
					});
				elseif (record.RecordType == "LoyaltyRecord") then
					local data = util.JSONToTable(record._Data);

					table.insert(characterNotes.Notes.Loyalty, {
						author = record.Performer,
						time = record._Timestamp,
						content = data,
						notetype = "LoyaltyRecord"
					});

					characterNotes.LoyaltyPoints = characterNotes.LoyaltyPoints + tonumber(data.points);
				elseif (record.RecordType == "NoteRecord") then
					table.insert(characterNotes.Notes.Other, {
						author = record.Performer,
						time = record._Timestamp,
						content = record._Data,
						notetype = "NoteRecord"
					});
				elseif (record.RecordType == "HistoryRecord") then
					table.insert(characterNotes.Notes.Other, {
						author = nil,
						time = record._Timestamp,
						content = record._Data,
						notetype = "HistoryRecord"
					});
				end;
			end;

			callback(characterNotes);			
		end;
	end);

	selectObject:Pull();
end;

function Datafiles.Database:UpdateDatafileData(characterKey, changes, callback)

	local updateObject = Clockwork.database:Update("datafiles_data");
	updateObject:AddWhere("CharacterKey = ?", characterKey);

	for k, v in pairs(changes) do
		updateObject:SetValue(k, v);
	end;

	updateObject:SetCallback(function(result, state, queryError)
		if (!state) then
			Datafiles.Database.QueryFailHandler(queryError, "UpdateDatafileData", characterKey, column, value);

			if (callback) then
				callback(false);
			end;

			return;
		end;

		if (callback) then
			callback(true);
		end;
	end);

	updateObject:Push();
end;

function Datafiles.Database:CreateRecord(characterKey, recordType, performer, datastr, callback)
	local insertObject = Clockwork.database:Insert("datafiles_records");

	insertObject:SetValue("CharacterKey", characterKey);
	insertObject:SetValue("RecordType", recordType);
	insertObject:SetValue("Performer", performer);
	insertObject:SetValue("_Data", datastr);
	insertObject:SetValue("_Timestamp", os.time());

	insertObject:SetCallback(function(result, state, queryError)
		if (!state) then
			Datafiles.Database.QueryFailHandler(queryError, "CreateRecord", characterKey, recordType, performer, datastr);

			if (callback) then
				callback(false);
			end;

			return;
		end;

		callback(true);
	end);

	insertObject:Push();
end;

-- Called when a character of some player is initialized, their information are gathered from the database and cached into the player's entity.
function Datafiles.Database:LoadPlayerCharacter(ply, callback)

	-- Since this is called whenever a character is loaded, we'll set ply.Datafile to false.
	-- This way, we remove any possibility of data of character A being in ply.Datafile, while the player is on character B whose data aren't loaded yet/failed to load.
	ply:DatafilesUnload();

	local characterKey = ply:GetCharacter().key;
	self:FetchDatafileData(characterKey, function(dataResult)
		ply.Datafile = {};
		for k, v in pairs(dataResult) do
			ply.Datafile[k] = v;
		end;

		self:FetchDatafileRecords(characterKey, function(recordsResult)
			for k, v in pairs(recordsResult) do
				ply.Datafile[k] = v;
			end;

			ply:SetSharedVar("LoyaltyTier", tonumber(ply.Datafile.LoyaltyTier));

			if (callback) then
				callback(true);
			end;
		end);
	end);
end;

-- Called when a database error occurs.
function Datafiles.Database.QueryFailHandler(sqlError, whereCalled, ...)
	local arguments = {...};
	local argString = "";

	if (arguments) then
		argString = table.concat(arguments, ", ");
	end;

	Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, "[Datafiles] Query of the Database:" .. whereCalled .. "(" .. argString .. ") function failed with the following error:");
	Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, sqlError);

	Error("[Datafiles] Query of the Database:" .. whereCalled .. "(" .. argString .. ") function failed!");
	Error(sqlError);
end;

function Datafiles.Database:GetPlayerByCharacterKey(charkey)
	for k, ply in pairs(player.GetAll()) do
		if (IsValid(ply) and ply:GetCharacter() and ply:GetCharacter().key == tonumber(charkey)) then
			return ply;
		end;
	end;

	return false;
end;

function Datafiles.Database:AddHistoryRecord(charkey, txt)
	self:CreateRecord(charkey, "HistoryRecord", "", Clockwork.database:Escape(txt), function() return end);
end;

function Datafiles.Database:ReloadDatafileAndSendToInvoker(charkey, invoker)
	local subject = Datafiles.Database:GetPlayerByCharacterKey(charkey);

	if (subject) then
		-- A note was added to the subject's character's datafile - so we reload the data.
		Datafiles.Database:LoadPlayerCharacter(subject, function()
			-- Once reloaded, we are going to send the data back to whoever added this note - so their /Datafile screen is reloaded.
			Datafiles.Network:SendCharacterData(invoker, subject:GetFullDatafile());
		end);
	end;
end;

-- Network handlers:

function Datafiles.Database:AddNote(invoker, charkey, notetext, ismedical)
	self:CreateRecord(charkey, ismedical and "MedicalRecord" or "NoteRecord", Clockwork.database:Escape(invoker:Name()), Clockwork.database:Escape(notetext), function()
		Datafiles.Database:ReloadDatafileAndSendToInvoker(charkey, invoker);
	end);
end;

function Datafiles.Database:AddLoyaltyAct(invoker, charkey, pointsChange, note)
	self:CreateRecord(
		charkey,
		"LoyaltyRecord",
		Clockwork.database:Escape(invoker:Name()),

		util.TableToJSON({
			["note"] = Clockwork.database:Escape(note),
			["points"] = tonumber(pointsChange)
		}),

		function()
			Datafiles.Database:ReloadDatafileAndSendToInvoker(charkey, invoker);
		end
	);
end;

function Datafiles.Database:UpdateLastSeen(invoker, charkey)
	self:UpdateDatafileData(charkey, {
		LastSpottedTimestamp = os.time(),
		LastSpottedLocation = invoker:Name()
	}, function()
		Datafiles.Database:ReloadDatafileAndSendToInvoker(charkey, invoker);
	end);
end;

function Datafiles.Database:SetLoyaltyTier(invoker, charkey, tierID)
	self:UpdateDatafileData(charkey, {
		LoyaltyTier = tierID
	}, function()
		local txt = "";
		local tierData = Datafiles.LoyalistTiers[tierID];

		if (tierData) then
			txt = "set loyalty tier to " .. string.lower(tierData.tierName) .. ".";
		else
			txt = "revoked loyalty tier.";
		end;

		Datafiles.Database:AddHistoryRecord(charkey, invoker:Name() .. " " .. txt);
		Datafiles.Database:ReloadDatafileAndSendToInvoker(charkey, invoker);
	end);
end;

function Datafiles.Database:SetCitizenship(invoker, charkey, active)
	self:UpdateDatafileData(charkey, {
		Citizenship = active and 1 or 0
	}, function()
		Datafiles.Database:AddHistoryRecord(charkey, invoker:Name() .. (active and " issued" or " revoked") .. " citizenship.");
		Datafiles.Database:ReloadDatafileAndSendToInvoker(charkey, invoker);
	end);
end;

function Datafiles.Database:SetWarrantStatus(invoker, charkey, active)
	self:UpdateDatafileData(charkey, {
		Warrant = active and 1 or 0
	}, function()
		Datafiles.Database:AddHistoryRecord(charkey, invoker:Name() .. (active and " activated" or " revoked") .. " BOL warrant.");
		Datafiles.Database:ReloadDatafileAndSendToInvoker(charkey, invoker);
	end);
end;
