
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local table = table;
local string = string;
local os = os;
local pairs = pairs;
local cwDB = Clockwork.database;
local cwJSON = Clockwork.json;
local cwOption = Clockwork.option;

PLUGIN.selectTypesLoyalist = {
	[PLUGIN.types.note] = true,
	[PLUGIN.types.commendation] = true,
	[PLUGIN.types.loyalistTier] = true,
	[PLUGIN.types.civilStatus] = true
};

PLUGIN.selectTypesFull = {
	[PLUGIN.types.note] = true,
	[PLUGIN.types.commendation] = true,
	[PLUGIN.types.loyalistTier] = true,
	[PLUGIN.types.civilStatus] = true,
	[PLUGIN.types.violation] = true,
	[PLUGIN.types.socEndStatus] = true
};

function PLUGIN:AddLoyalistTierChangedNote(createdBy, targetKey, tier)
	self:AddEntryToRecords(targetKey, createdBy, self.types.loyalistTier, false, "Loyalist tier changed to:\n"..string.upper(tier));
end;

function PLUGIN:AddLoyalistTierRevokedNote(createdBy, targetKey, tier)
	self:AddEntryToRecords(targetKey, createdBy, self.types.loyalistTier, false, "Loyalist status:\nREVOKED");
end;

function PLUGIN:AddCivilStatusChangedNote(createdBy, targetKey, status)
	self:AddEntryToRecords(targetKey, createdBy, self.types.civilStatus, false, "Civil status changed to:\n"..string.upper(status));
end;

function PLUGIN:GetCharacterDataFile(targetKey, callback, ...)
	local vararg = ...;
	local queryObj = cwDB:Select(cwOption:GetKey("DataFileTable"));
		queryObj:AddWhere("_CharacterKey = ?", targetKey);
		queryObj:SetCallback(function(result)
			if (cwDB:IsResult(result)) then
				local returnTable = {
					civilStatus = result[1]._Status1,
					socEndStatus = result[1]._Status2,
					data = Clockwork.player:ConvertDataString(nil, result[1]._Data or {lt = 0})
				};

				callback(returnTable, vararg);
			else
				self:CreateNewDataFile(targetKey, callback, vararg);
			end;
		end);
	queryObj:Pull();
end;

function PLUGIN:CreateNewDataFile(targetKey, callback, ...)
	local queryObj = cwDB:Insert(cwOption:GetKey("DataFileTable"));
		queryObj:SetValue("_CharacterKey", targetKey);
		queryObj:SetValue("_Status2", "");
		queryObj:SetValue("_Status1", "");
	queryObj:Push();

	if (callback) then
		callback({civilStatus = "", socEndStatus = "", data = {lt = 0}}, ...);
	end;
end;

function PLUGIN:UpdateDataFilePoints(target, vp, lt)
	if (!target:HasInitialized()) then
		return;
	end;

	if (vp and type(vp) == "number" and vp >= 0) then
		target.dataFile.vp = vp;
	end;

	if (lt and type(lt) == "number" and lt >= 0) then
		target.dataFile.data.lt = lt;
		self:UpdateDataFileData(target:GetCharacter().key, target.dataFile.data);
	end;
end;

function PLUGIN:AddDataFilePoints(target, vp, lt)
	if (!target:HasInitialized()) then
		return;
	end;

	if (vp and type(vp) == "number") then
		target.dataFile.vp = math.max(target.dataFile.vp + vp, 0);
	end;

	if (lt and type(lt) == "number") then
		target.dataFile.data.lt = math.max(target.dataFile.lt + lt, 0);
		self:UpdateDataFileData(target:GetCharacter().key, target.dataFile.data);
	end;
end;

function PLUGIN:UpdateDataFileStatus(targetKey, socEndStatus, civStatus)
	local queryObj = cwDB:Update(cwOption:GetKey("DataFileTable"));
		queryObj:AddWhere("_CharacterKey = ?", targetKey);
		if (civStatus) then
			queryObj:SetValue("_Status1", civStatus);
		end;
		if (socEndStatus) then
			queryObj:SetValue("_Status2", socEndStatus);
		end;
	queryObj:Push();
end;

function PLUGIN:UpdateDataFileData(targetKey, data)
	if (data) then
		local queryObj = cwDB:Update(cwOption:GetKey("DataFileTable"));
			queryObj:AddWhere("_CharacterKey = ?", targetKey);
			queryObj:SetValue("_Data", Clockwork.json:Encode(data));
		queryObj:Push();
	end;
end;

function PLUGIN:GetCharacterRecords(targetKey, includeHidden, selectTypes, callback, ...)
	local vararg = ...;
	local queryObj = cwDB:Select(cwOption:GetKey("RecordsTable"));
		queryObj:AddWhere("_CharacterKey = ?", targetKey);
		queryObj:SetCallback(function(result)
			if (cwDB:IsResult(result)) then
				local returnTable = {};
				if (!includeHidden) then
					for k, v in pairs(result) do
						if (v._Hidden != 1 and selectTypes[v._Type]) then
							returnTable[#returnTable + 1] = {
								key = v._Key,
								characterKey = targetKey,
								createdByKey = v._CreatedByKey,
								createdBy = v._CreatedBy,
								hidden = v._Hidden == 1,
								points = v._Points,
								timeStamp = v._TimeStamp,
								type = v._Type,
								text = v._Text
							};
						end;
					end;
				else
					for k, v in pairs(result) do
						if (selectTypes[v._Type]) then
							returnTable[#returnTable + 1] = {
								key = v._Key,
								characterKey = targetKey,
								createdByKey = v._CreatedByKey,
								createdBy = v._CreatedBy,
								hidden = v._Hidden == 1,
								points = v._Points,
								timeStamp = v._TimeStamp,
								type = v._Type,
								text = v._Text
							};
						end;
					end;
				end;

				table.sort(returnTable, function(a, b) return a.timeStamp > b.timeStamp end);

				callback(returnTable, vararg);
			else
				callback({}, vararg);
			end;
		end);
	queryObj:Pull();
end;

function PLUGIN:AddEntryToRecords(targetKey, createdBy, type, hidden, text)
	local createdByCharacter = createdBy:GetCharacter();
	if (!createdByCharacter) then
		return;
	end;

	local createdByName = createdBy:Name()
	if (string.len(createdByName) > 60) then
		createdByName = string.sub(createdByName, 1, 60);
	end;

	local queryObj = cwDB:Insert(cwOption:GetKey("RecordsTable"));
		queryObj:SetValue("_CharacterKey", targetKey);
		queryObj:SetValue("_CreatedByKey", createdByCharacter.key);
		queryObj:SetValue("_CreatedBy", createdByName);
		queryObj:SetValue("_Hidden", hidden);
		queryObj:SetValue("_TimeStamp", os.time());
		queryObj:SetValue("_Type", type);
		queryObj:SetValue("_Text", text);
		queryObj:SetCallback(function(_, _, key)
			Clockwork.datastream:Start(createdBy, "AddEntryToRecords", {
				key = key,
				characterKey = targetKey,
				createdByKey = createdByCharacter.key,
				createdBy = createdByName,
				hidden = hidden,
				timeStamp = os.time(),
				type = type,
				text = text
			});
		end);
	queryObj:Push();
end;

function PLUGIN:SetEntryHidden(key, hidden)
	local queryObj = cwDB:Update(cwOption:GetKey("RecordsTable"));
		queryObj:AddWhere("_Key = ?", key);
		queryObj:SetValue("_Hidden", hidden and 1 or 0);
	queryObj:Push();

	queryObj = cwDB:Select(cwOption:GetKey("RecordsTable"));
		queryObj:AddWhere("_Key = ?", key);
		queryObj:AddColumn("_CharacterKey");
		queryObj:AddColumn("_Points");
		queryObj:AddColumn("_Type");
		queryObj:SetCallback(function(result)
			if (Clockwork.database:IsResult(result)) then
				local characterKey = result[1]._CharacterKey;
				if (result[1]._Type == self.types.violation) then
					for k, v in ipairs(player.GetAll()) do
						if (v:HasInitialized() and v:GetCharacter().key == characterKey) then
							local modifier = (hidden and -1) or 1;
							self:UpdateDataFilePoints(v, modifier * result[1]._Points);
							return;
						end;
					end;
				end;
			end;
		end);
	queryObj:Pull();
end;

--[[function PLUGIN:ClearEntries(targetKey)
	local queryObj = cwDB:Update(cwOption:GetKey("RecordsTable"));
		queryObj:AddWhere("_CharacterKey = ?", targetKey);
		queryObj:SetValue("_Hidden", true);
	queryObj:Push();
end;

function PLUGIN:DeleteEntries(targetKey)
	local queryObj = cwDB:Delete(cwOption:GetKey("RecordsTable"));
		queryObj:AddWhere("_CharacterKey = ?", targetKey);
	queryObj:Push();
end;]]