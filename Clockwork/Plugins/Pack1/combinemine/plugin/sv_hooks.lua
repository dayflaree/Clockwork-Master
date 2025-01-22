local PLUGIN = PLUGIN;

-- Replace all default mines with the new one.
function PLUGIN:OnEntityCreated(entity)
	if (entity:GetClass() == "combine_mine" or entity:GetClass() == "Combine Mine") then
		timer.Simple(0.5, function()
			if (IsValid(entity)) then
				local physObj = entity:GetPhysicsObject();
				local storedVel = physObj:GetVelocity();
				local hopper = ents.Create("cw_hopper");

				hopper:SetPos(entity:GetPos());
				hopper:SetAngles(entity:GetAngles());

				SafeRemoveEntity(entity);

				hopper:Spawn();
				hopper:SetVelocity(storedVel);
			end;
		end);
	end;
end;

function PLUGIN:KeyPress(player, key)
	if (Schema.scanners[player] and Schema:IsPlayerCombineRank(player, "SYNTH")) then
		if (key == IN_ATTACK2) then
			if (player.nextMineDrop or 0 < CurTime()) then
				local scanner = Schema.scanners[player][1];

				if (IsValid(scanner)) then
					player.nextMineDrop = CurTime() + 4;
					scanner:Fire("EquipMine");
					scanner:Fire("DeployMine", "", 1);

					timer.Simple(2.8, function()
						if (IsValid(scanner)) then
							scanner:SetSaveValue("m_bIsOpen", false)
						end;
					end);
				end;
			end;
		end;
	end;
end;