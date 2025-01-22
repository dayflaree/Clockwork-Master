
local PLUGIN = PLUGIN;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity()
	if (string.lower(game.GetMap()) == "rp_city8_district9") then
		local lockedDoors = {
			[1603] = true,
			[1620] = true,
			[1632] = true,
			[2493] = true
		};

		for k, v in ipairs(ents.FindByClass("prop_door_rotating")) do
			if (IsValid(v) and lockedDoors[v:MapCreationID()]) then
				v:Fire("Unlock", "", 0);
			end;
		end;
	elseif (string.lower(game.GetMap()) == "rp_city17_build210") then
		local killEnts = {
			[5709] = true, -- "HL3 Confirmed" button
			[5711] = true, -- "HL3 Confirmed" text entity
			[5205] = true, -- Pointless secret door thing
			[5207] = true, -- Other pointless secret door
			[1709] = true, -- "C" from unused CWU sign
			[1710] = true, -- "W" from unused CWU sign
			[1711] = true, -- "U" from unused CWU sign
			[3774] = true, -- Interrogation camera 1
			[3775] = true, -- Interrogation camera 2
			[3787] = true, -- Trainstation camera
			[4905] = true, -- Combine prop in garage
			[4906] = true, -- Combine button in garage
			[5646] = true, -- Malfunctioning headcrab canister in Nexus
			[5649] = true, -- Malfunctioning headcrab canister in Nexus
			[5650] = true, -- Malfunctioning headcrab canister in Nexus
			[5676] = true, -- Malfunctioning headcrab canister in Nexus
			[5675] = true, -- Malfunctioning headcrab canister in Nexus
			[5678] = true, -- Malfunctioning headcrab canister in Nexus
			[5677] = true, -- Malfunctioning headcrab canister in Nexus
			[5680] = true, -- Malfunctioning headcrab canister in Nexus
			[5679] = true  -- Malfunctioning headcrab canister in Nexus
		};
		
		for entId, shouldRemove in ipairs(killEnts) do
			local ent = ents.GetMapCreatedEntity(entId)
			if (IsValid(ent) and shouldRemove) then
				ent:Remove();
			end;
		end;
	end;
end;

-- Called when a player uses a door.
function PLUGIN:PlayerUseDoor(player, door)
	if (string.lower(game.GetMap()) == "rp_city8_district9") then
		local name = string.lower(door:GetName());

		if (IsValid(door) and string.find(name, "lever")) then
			door:Fire("Close", "", 0.5);
		end;
	end;
end;
