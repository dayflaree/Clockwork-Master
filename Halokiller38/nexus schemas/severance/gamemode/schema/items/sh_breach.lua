--[[
Name: "sh_breach.lua".
Product: "Severance".
--]]

local ITEM = {};

ITEM.name = "Breach";
ITEM.model = "models/props_wasteland/prison_padlock001a.mdl";
ITEM.plural = "Breaches";
ITEM.weight = 0.5;
ITEM.useText = "Place";
ITEM.description = "A small device which looks similiar to a padlock.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local trace = player:GetEyeTraceNoCursor();
	local entity = trace.Entity;
	
	if ( IsValid(entity) ) then
		if (entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
			if ( !IsValid(entity.breach) ) then
				if ( nexus.mount.Call("PlayerCanBreachEntity", player, entity) ) then
					local breach = ents.Create("nx_breach"); breach:Spawn();
					
					breach:SetBreachEntity(entity, trace);
				else
					nexus.player.Notify(player, "This entity cannot be breached!");
					
					return false;
				end;
			else
				nexus.player.Notify(player, "This entity already has a breach!");
				
				return false;
			end;
		else
			nexus.player.Notify(player, "You are not close enough to the entity!");
			
			return false;
		end;
	else
		nexus.player.Notify(player, "That is not a valid entity!");
		
		return false;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

nexus.item.Register(ITEM);