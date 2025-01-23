--[[
Name: "sh_citizen.lua".
Product: "Half-Life 2".
--]]

local FACTION = {useFullName = true};

-- Called when a player is transferred to the faction.
function FACTION:OnTransferred(player, faction, name)
	if ( MODULE:PlayerIsCombine(player) ) then
		if (name) then
			local models = self.models[ string.lower( player:QueryCharacter("gender") ) ];
			
			if (models) then
				player:SetCharacterData("model", models[ math.random(#models) ], true);
				
				resistance.player.SetName(player, name, true);
			end;
		else
			return false, "You need to specify a name as the third argument!";
		end;
	end;
end;

FACTION_CITIZEN = resistance.faction.Register(FACTION, "Citizen");