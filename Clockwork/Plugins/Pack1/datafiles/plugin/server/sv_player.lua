-- (c) Khub 2012-2013.
-- Extensions for the "Player" metatable.

local ply = FindMetaTable("Player");

function ply:DatafilesIsLoaded()
	return self.Datafile and true or false;
end;

function ply:DatafilesUnload()
	self.Datafile = false;
	return true;
end;

function ply:DatafilesSet(datafileTable)
	self.Datafile = datafileTable;
end;

function ply:DatafilesIsLoyalist()
	if (!self.Datafile) then
		return false;
	end;

	return self.Datafile.LoyaltyTier > 0;
end;

function ply:DatafilesIsCriminal()
	if (!self.Datafile) then
		return false;
	end;

	return self.Datafile.LoyaltyPoints < 0;
end;

function ply:DatafilesGetLoyaltyTier()
	if (!self.Datafile) then
		return 0;
	end;

	return self.Datafile.LoyaltyTier;
end;

function ply:DatafilesIsWanted()
	if (!self.Datafile) then
		return false;
	end;

	return self.Datafile.Warrant;
end;

function ply:DatafilesIsCitizen()
	if (!self.Datafile) then
		return true;
	end;

	return self.Datafile.Citizenship;
end;

function ply:GetFullDatafile()
	local data = table.Copy(self.Datafile);
	data.Name = self:Name();
	data.CharacterKey = self:GetCharacter().key;
	data.ServerTime = os.time();
	
	if (self:GetCharacterData("citizenid")) then
		data.CitizenID = "#" .. self:GetCharacterData("citizenid");
	elseif (self:GetFaction() == FACTION_MPF) then
		data.CitizenID = "i17::" .. string.sub(self:Name(), self:Name():len() - 2);
	elseif (self:GetFaction() == FACTION_OTA) then
		data.CitizenID = "i17::" .. string.sub(self:Name(), self:Name():len() - 4);
	elseif (self:GetFaction() == FACTION_ADMIN) then
		data.CitizenID = "CAB::N/A";
	else
		data.CitizenID = "CID_N/A";
	end;

	data.LoyaltyPoints = 0;
	data.SubjectFaction = self:GetFaction();
	data.SubjectClassID = self:Team();

	if (#data.Notes.Loyalty > 0) then
		for k, v in pairs(data.Notes.Loyalty) do
			data.LoyaltyPoints = data.LoyaltyPoints + tonumber(v.content.points);
		end;
	end;

	return data;
end;