--[[
Name: "sh_stationary_radio.lua".
Product: "Novus Two".
--]]

local ITEM = {};

ITEM.name = "Stationary Radio";
ITEM.cost = 150;
ITEM.model = "models/props_lab/citizenradio.mdl";
ITEM.batch = 1;
ITEM.weight = 3;
ITEM.access = "T";
ITEM.business = true;
ITEM.category = "Communication"
ITEM.description = "An antique radio, do you think this'll still work?";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local trace = player:GetEyeTraceNoCursor();
	
	if (trace.HitPos:Distance( player:GetShootPos() ) <= 192) then
		local entity = ents.Create("nx_radio");
		
		nexus.player.GiveProperty(player, entity);
		
		entity:SetModel(self.model);
		entity:SetPos(trace.HitPos);
		entity:Spawn();
		
		if ( IsValid(itemEntity) ) then
			local physicsObject = itemEntity:GetPhysicsObject();
			
			entity:SetPos( itemEntity:GetPos() );
			entity:SetAngles( itemEntity:GetAngles() );
			
			if ( IsValid(physicsObject) ) then
				if ( !physicsObject:IsMoveable() ) then
					physicsObject = entity:GetPhysicsObject();
					
					if ( IsValid(physicsObject) ) then
						physicsObject:EnableMotion(false);
					end;
				end;
			end;
		else
			nexus.entity.MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
		end;
	else
		nexus.player.Notify(player, "You cannot drop a radio that far away!");
		
		return false;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

nexus.item.Register(ITEM);