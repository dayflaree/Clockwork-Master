--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New();
ITEM.batch = 1;
ITEM.name = "Combine Lock";
ITEM.cost = 20;
ITEM.model = "models/props_combine/combine_lock01.mdl";
ITEM.weight = 5;
ITEM.classes = {CLASS_MPF_EPU, CLASS_MPF_OFC, CLASS_MPF_DVL, CLASS_MPF_SEC};
ITEM.useText = "Place";
ITEM.business = true;
ITEM.batch = 1;
ITEM.description = "A Combine device to effectively lock a door.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local trace = player:GetEyeTraceNoCursor();
	local entity = trace.Entity;
	
	if ( IsValid(entity) ) then
		if (entity:GetPos():Distance( player:GetPos() ) <= 192) then
			if ( !IsValid(entity.combineLock) ) then
				if ( !Clockwork.entity:IsDoorFalse(entity) ) then
					local angles = trace.HitNormal:Angle() + Angle(0, 270, 0);
					local position;
					
					if (string.lower( entity:GetClass() ) == "prop_door_rotating") then
						position = trace;
					else
						position = trace.HitPos + (trace.HitNormal * 4);
					end;
					
					if ( !IsValid( Clockwork.schema:ApplyCombineLock(entity, position, angles) ) ) then
						return false;
					elseif ( IsValid(entity.breach) ) then
						entity.breach:CreateDummyBreach();
						entity.breach:Explode();
						entity.breach:Remove();
					end;
				else
					Clockwork.player:Notify(player, "This door cannot have a Combine lock!");
					
					return false;
				end;
			else
				Clockwork.player:Notify(player, "This entity already has a Combine lock!");
				
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

Clockwork.item:Register(ITEM);