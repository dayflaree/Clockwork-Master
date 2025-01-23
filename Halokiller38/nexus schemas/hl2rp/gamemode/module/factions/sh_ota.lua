--[[
Name: "sh_ota.lua".
Product: "Half-Life 2".
--]]

local FACTION = {};

FACTION.whitelist = true;
FACTION.models = {
	female = {"models/combine_soldier.mdl"},
	male = {"models/combine_soldier.mdl"}
};

-- Called when a player's name should be assigned for the faction.
function FACTION:GetName(player, character)
	local unitID = math.random(1, 99999);
	
	return "OTA-ECHO.OWS-"..RESISTANCE:ZeroNumberToDigits(unitID, 5);
end;

-- Called when a player's model should be assigned for the faction.
function FACTION:GetModel(player, character)
	if (character.gender == GENDER_MALE) then
		return self.models.male[1];
	else
		return self.models.female[1];
	end;
end;

-- Called when a player is transferred to the faction.
function FACTION:OnTransferred(player, faction, name)
	if (faction.name == FACTION_MPF) then
		resistance.player.SetName(player, string.gsub(player:QueryCharacter("name"), ".+(%d%d%d%d%d)", "OTA-ECHO.OWS-%1"), true);
	else
		resistance.player.SetName(player, self:GetName( player, player:GetCharacter() ), true);
	end;
	
	if (player:QueryCharacter("gender") == GENDER_MALE) then
		player:SetCharacterData("model", self.models.male[1], true);
	else
		player:SetCharacterData("model", self.models.female[1], true);
	end;
end;

FACTION_OTA = resistance.faction.Register(FACTION, "Overwatch Transhuman Arm");