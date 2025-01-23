--[[
Name: "sh_combine_lock.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.name = "Combine Lock";
ITEM.cost = 40;
ITEM.model = "models/props_combine/combine_lock01.mdl";
ITEM.weight = 4;
ITEM.classes = {CLASS_EMP, CLASS_EOW};
ITEM.useText = "Place";
ITEM.business = true;
ITEM.description = "A Combine device to effectively lock a door.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local trace = player:GetEyeTraceNoCursor();
	local entity = trace.Entity;
	
	if ( IsValid(entity) ) then
		if (entity:GetPos():Distance( player:GetPos() ) <= 192) then
			if ( !IsValid(entity.combineLock) ) then
				if ( !resistance.entity.IsDoorFalse(entity) ) then
					local angles = trace.HitNormal:Angle() + Angle(0, 270, 0);
					local position;
					
					if (string.lower( entity:GetClass() ) == "prop_door_rotating") then
						position = trace;
					else
						position = trace.HitPos + (trace.HitNormal * 4);
					end;
					
					if ( !IsValid( MODULE:ApplyCombineLock(entity, position, angles) ) ) then
						return false;
					elseif ( IsValid(entity.breach) ) then
						entity.breach:CreateDummyBreach();
						entity.breach:Explode();
						entity.breach:Remove();
					end;
				else
					resistance.player.Notify(player, "This door cannot have a Combine lock!");
					
					return false;
				end;
			else
				resistance.player.Notify(player, "This entity already has a Combine lock!");
				
				return false;
			end;
		else
			resistance.player.Notify(player, "You are not close enough to the entity!");
			
			return false;
		end;
	else
		resistance.player.Notify(player, "That is not a valid entity!");
		
		return false;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

resistance.item.Register(ITEM);