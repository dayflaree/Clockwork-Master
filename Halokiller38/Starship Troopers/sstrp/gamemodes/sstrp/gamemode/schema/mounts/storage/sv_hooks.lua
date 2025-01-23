--[[
Name: "sv_hooks.lua".
Product: "Novus Two".
--]]

local MOUNT = MOUNT;

-- Called when nexus has loaded all of the entities.
function MOUNT:NexusInitPostEntity()
	self:LoadStorage();
	self.randomItems = {};
	
	for k, v in pairs( nexus.item.GetAll() ) do
		if (!v.isRareItem and !v.isBaseItem) then
			self.randomItems[#self.randomItems + 1] = {
				v.uniqueID,
				v.weight
			};
		end;
	end;
end;

-- Called when data should be saved.
function MOUNT:SaveData()
	self:SaveStorage();
end;

-- Called when an entity attempts to be auto-removed.
function MOUNT:EntityCanAutoRemove(entity)
	if (self.storage[entity] or entity:GetNetworkedString("sh_Name") != "") then
		return false;
	end;
end;

-- Called when an entity's menu option should be handled.
function MOUNT:EntityHandleMenuOption(player, entity, option, arguments)
	local class = entity:GetClass();
	
	if (arguments == "nx_containerOpen") then
		if ( nexus.entity.IsPhysicsEntity(entity) ) then
			local model = string.lower( entity:GetModel() );
			
			if ( self.containers[model] ) then
				local containerWeight = self.containers[model][1];
				
				if (entity.password) then
					umsg.Start("nx_ContainerPassword", player);
						umsg.Entity(entity);
					umsg.End();
				else
					self:OpenContainer(player, entity, containerWeight);
				end;
			end;
		end;
	end;
end;

-- Called when an entity is removed.
function MOUNT:EntityRemoved(entity)
	if (IsValid(entity) and !entity.areBelongings) then
		nexus.entity.DropItemsAndCash(entity.inventory, entity.cash, entity:GetPos(), entity);
			
		entity.inventory = nil;
		entity.cash = nil;
	end;
end;

-- Called when a player's prop cost info should be adjusted.
function MOUNT:PlayerAdjustPropCostInfo(player, entity, info)
	local model = string.lower( entity:GetModel() );
	
	if ( self.containers[model] ) then
		info.name = self.containers[model][2];
	end;
end;