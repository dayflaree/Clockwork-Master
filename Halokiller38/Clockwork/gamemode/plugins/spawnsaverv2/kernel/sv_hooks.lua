--[[
	Free Clockwork!
--]]

local PLUGIN = PLUGIN;

-- Called when a player's character has unloaded.
function PLUGIN:SavePlayerPositions()
	for _, player in pairs(_player.GetAll()) do
		if (player:Alive()) then
			local position = player:GetPos();
			local posTable = {
				x = position.x,
				y = position.y,
				z = position.z
			};
			
			player:SetCharacterData("SpawnPoint", posTable);
		end;
	end;
end;

-- Called just after a player spawns.
function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (!lightSpawn) then
		local spawnPos = player:GetCharacterData("SpawnPoint");
		
		if (spawnPos) then
			player:SetCharacterData("SpawnPoint", nil);
			player:SetPos(Vector(spawnPos.x, spawnPos.y, spawnPos.z));
		end;
	end;
end;