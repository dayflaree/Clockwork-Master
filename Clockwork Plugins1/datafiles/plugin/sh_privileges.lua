-- (c) Khub 2012-2013.
-- Shared privileges functions and configuration.

Datafiles.Privileges = {};
Datafiles.Privileges.Config = {
	["Read"] = 1,
	["ReadMedicalRecord"] = 2,
	["AddMedicalRecord"] = 4,
	["AddLoyaltyRecord"] = 8,
	["AddNote"] = 16,
	["RemoveRecords"] = 32,
	["ManipulateCitizenship"] = 64,
	["ManipulateBOL"] = 128,
	["RevokeLoyaltyStatus"] = 256,
	["Full"] = 511
};

local privilegesConfig = Datafiles.Privileges.Config
local ReadOnly = bit.bor(privilegesConfig.Read, privilegesConfig.ReadMedicalRecord);
local BasicPrivileges = bit.bor(privilegesConfig.Read, privilegesConfig.ReadMedicalRecord, privilegesConfig.AddMedicalRecord, privilegesConfig.AddLoyaltyRecord, privilegesConfig.AddNote);
local FullPrivileges = bit.bor(BasicPrivileges, privilegesConfig.RemoveRecords, privilegesConfig.ManipulateCitizenship, privilegesConfig.ManipulateBOL, privilegesConfig.RevokeLoyaltyStatus);

Datafiles.Privileges.Ranks = {
	{
		label = "PROSELYTE",
		check = function(ply) return ply:GetFaction() == FACTION_PROSELYTE; end,
		flags = bit.bxor(ReadOnly)
	},
	{
		label = "CWU",
		check = function(ply) return ply:GetFaction() == FACTION_CWU; end,
		flags = bit.bxor(BasicPrivileges)
	},
	{
		label = "WI",
		check = function(ply) return ply:GetFaction() == FACTION_WI; end,
		flags = bit.bxor(BasicPrivileges)
	},
	{
		label = "AEGIS",
		check = function(ply) return ply:GetFaction() == FACTION_HEZE; end,
		flags = bit.bxor(FullPrivileges)
	},
	{
		label = "MPF",
		check = function(ply) return ply:GetFaction() == FACTION_MPF; end,
		flags = bit.bxor(FullPrivileges)
	},
	{
		label = "UP",
		check = function(ply) return ply:GetFaction() == FACTION_UP; end,
		flags = bit.bxor(BasicPrivileges)
	},
	{
		label = "OTA",
		check = function(ply) return ply:GetFaction() == FACTION_OTA; end,
		flags = bit.bxor(FullPrivileges)
	},
	{
		label = "Overwatch",
		check = function(ply) return ply:GetFaction() == FACTION_OVERWATCH; end,
		flags = bit.bxor(FullPrivileges)
	},
	{
		label = "CA",
		check = function(ply) return ply:GetFaction() == FACTION_ADMIN; end,
		flags = bit.bxor(FullPrivileges)
	},
	{
		label = "SRVADMIN",
		check = function(ply) return ply:GetFaction() == FACTION_SRVADMIN; end,
		flags = bit.bxor(FullPrivileges)
	}
};

function Datafiles.Privileges:GetPlayerRank(ply)
	for k, v in pairs(self.Ranks) do
		if (v.check(ply)) then
			return k;
		end;
	end;

	return 1;
end;

function Datafiles.Privileges:GetRankFromLabel(label)
	for k, v in pairs(self.Ranks) do
		if (v.label == label) then
			return k;
		elseif (v.abbreviations) then
			for abbrK, abbrV in pairs(v.abbreviations) do
				if (abbrV == label) then
					return k;
				end;
			end;
		end;
	end;

	return 1;
end;

function Datafiles.Privileges:GetPlayerPrivileges(ply)
	if (!IsValid(ply)) then
		return 0;
	end;
	
	local rankNumber = 0;

	for k, v in pairs(self.Ranks) do
		if (v.check(ply)) then
			rankNumber = k;
			break;
		end;
	end;
	
	if (rankNumber == 0) then
		return 0;
	else
		return self.Ranks[rankNumber].flags;
	end;
end;

function Datafiles.Privileges:Verify(subject, flag)
	if (!IsValid(subject)) then
		return false;
	end;

	return bit.band(self:GetPlayerPrivileges(subject), flag) > 0;
end;