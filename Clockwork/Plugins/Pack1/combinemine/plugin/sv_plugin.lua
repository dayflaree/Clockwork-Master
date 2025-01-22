
local PLUGIN = PLUGIN;

-- Normal Deploying
function PLUGIN:DeployHopper(player)

	-- Animate the player
	local playerFaction = player:GetFaction()
	
	-- CPs have no better animations, so just use the manhack deploy
	if (playerFaction == FACTION_MPF) then
		player:SetForcedAnimation("deploy", 2);
	-- Combine Soldiers have an unused "turret deploy" anim that looks really good with this
	elseif (playerFaction == FACTION_OTA) then
		player:SetForcedAnimation("Turret_Drop", 1.2);
	-- If they aren't either of these two factions, just assume they're using standard civ anims
	else
		player:SetForcedAnimation("ThrowItem", 1);
	end;
	
	local entity = ents.Create("cw_hopper"); -- Create the entity
		entity:SetPos(player:EyePos()+player:EyeAngles():Forward()*32); -- Spawn it in front of the player so it doesn't crash this time (oops)
		entity:Spawn();

	Schema:AddCombineDisplayLine( "Updating Deployable Data...", Color(255, 100, 255, 255) ); -- Fancy flavor text
end;