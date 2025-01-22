
-----------------------------------------------------
local PLUGIN = PLUGIN;

local ITEM = Clockwork.item:New();
ITEM.name = "Keycard Lock";
ITEM.cost = 40;
ITEM.model = "models/props_combine/combine_lock01.mdl";
ITEM.weight = 4;
ITEM.classes = {CLASS_EMP, CLASS_EOW};
ITEM.useText = "Place";
ITEM.business = true;
ITEM.description = "A keycard reader, reads keycards and opens the door depending on the level of keycard used.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local trace = player:GetEyeTraceNoCursor();
	local entity = trace.Entity;
	
	if (IsValid(entity)) then
		if (entity:GetPos():Distance( player:GetPos() ) <= 192) then
			if (!IsValid(entity.keycardLock)) then
				if (!Clockwork.entity:IsDoorFalse(entity)) then
					local angles = trace.HitNormal:Angle() + Angle(0, 270, 0);
					local position;
					
					if (string.lower( entity:GetClass() ) == "prop_door_rotating") then
						position = trace;
					else
						position = trace.HitPos + (trace.HitNormal * 4);
					end;
					
					if (!IsValid( PLUGIN:ApplyKeycardLock(entity, position, angles) )) then
						return false;
					elseif (IsValid(entity.breach)) then
						entity.breach:CreateDummyBreach();
						entity.breach:Explode();
						entity.breach:Remove();
					end;
				else
					Clockwork.player:Notify(player, "This door cannot have a Keycard lock!");
					
					return false;
				end;
			else
				Clockwork.player:Notify(player, "This entity already has a Keycard lock!");
				
				return false;
			end;
		else
			Clockwork.player:Notify(player, "You are not close enough to the entity!");
			
			return false;
		end;
	else
		Clockwork.player:Notify(player, "That is not a valid entity!");
		
		return false;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();