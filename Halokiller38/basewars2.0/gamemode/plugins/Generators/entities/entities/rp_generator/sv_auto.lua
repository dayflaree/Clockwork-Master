-- This is called when the entity initializes.
function ENT:Initialize()
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	
	local physicsObject = self:GetPhysicsObject();
	
	if ( ValidEntity(physicsObject) ) then
		physicsObject:Wake();
		physicsObject:EnableMotion(true);
	end;
end;

function ENT:UpdateTransmitState()
	return	TRANSMIT_ALWAYS;
end;

-- Called when the entity is used.
function ENT:Use(activator, caller)
	if (activator:IsPlayer()) then
		local collectCallback = function(ply, entity)
			RP.generator:GiveCash(ply, entity);
		end;
		local upgradeCallback = function(ply, entity)
			local entity = self.Entity;
			
			if (entity) then
				if (entity.generator) then
					if (entity.generator.owner == ply) then
						if (!entity.upgrading) then
							if (ply:CanAfford(RP.generator.upgradeCost)) then
								if (entity.generator.type == "gen_master") then
									ply:Notify("You generator is already upgraded to the maximum!");
									return false;
								end;
								
								ply:TakeCash(RP.generator.upgradeCost);
								
								entity.upgrading = true;
								
								RP:DataStream(ply, "addUpgradeBar", {entity, RP.generator.upgradeTime});
								
								timer.Simple(RP.generator.upgradeTime, function()
									local succ, err = RP.generator:Upgrade(entity);
									
									entity.upgrading = false;
									
									if (!succ) then
										ply:Notify(err)
									end;
								end);
							else
								ply:Notify("You do not have enough shards for that!");
							end;
						else
							ply:Notify("That generator is already being upgraded!");
						end;
					else
						ply:Notify("That is not your generator!");
					end;
				else
					ply:Notify("That is not a valid generator!");
				end;
			else
				ply:Notify("You must be looking at and close to a generator!");
			end;
		end;
		local options = {
			{text = "Collect", callback = collectCallback},
			{text = "Upgrade", callback = upgradeCallback},
		};

		RP.popup:Create(activator, self.Entity, "Generator", options, 70);
	end;
end;

-- Called each frame.
function ENT:Think()
end;
