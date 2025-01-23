--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New();
ITEM.batch = 1;
ITEM.name = "Breach";
ITEM.cost = 200;
ITEM.model = "models/props_wasteland/prison_padlock001a.mdl";
ITEM.weight = 0.3;
ITEM.classes = {CLASS_MPF_EPU, CLASS_MPF_OFC, CLASS_MPF_DVL, CLASS_MPF_SEC};
ITEM.useText = "Place";
ITEM.business = true;
ITEM.batch = 1;

ITEM.description = "A small device which looks similiar to a padlock.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local traceLine = player:GetEyeTraceNoCursor();
	local entity = traceLine.Entity;
	
	if (IsValid(entity)) then
		if (entity:GetPos():Distance(player:GetShootPos()) <= 192) then
			if (Clockwork.plugin:Call("PlayerCanBreachEntity", player, entity)) then
				local breach = ents.Create("cw_breach");
				breach:Spawn();
				
				if (IsValid(entity.cwBreachEnt)) then
					entity.cwBreachEnt:Explode();
					entity.cwBreachEnt:Remove();
				end;
				
				breach:SetBreachEntity(entity, traceLine);
			else
				Clockwork.player:Notify(player, "This entity cannot be breached!");
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