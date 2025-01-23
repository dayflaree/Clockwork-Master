--[[
Name: "sv_hooks.lua".
Product: "Half-Life 2".
--]]

local PLUGIN = PLUGIN;

-- Called when resistance has loaded all of the entities.
function PLUGIN:ResistanceInitPostEntity()
	self:LoadStorage();
	self.randomItems = {};
	
	for k, v in pairs( resistance.item.GetAll() ) do
		if (!v.isRareItem and !v.isBaseItem) then
			self.randomItems[#self.randomItems + 1] = {
				v.uniqueID,
				v.weight
			};
		end;
	end;
end;

-- Called when data should be saved.
function PLUGIN:SaveData()
	self:SaveStorage();
end;

-- Called when a player attempts to breach an entity.
function PLUGIN:PlayerCanBreachEntity(player, entity)
	if (entity.inventory and entity.password) then
		return true;
	end;
end;

-- Called when an entity attempts to be auto-removed.
function PLUGIN:EntityCanAutoRemove(entity)
	if (self.storage[entity] or entity:GetNetworkedString("sh_Name") != "") then
		return false;
	end;
end;

-- Called when an entity's menu option should be handled.
function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
	local class = entity:GetClass();
	
	if (class == "roleplay_locker" and arguments == "roleplay_containerOpen") then
		self:OpenContainer(player, entity);
	elseif (arguments == "roleplay_containerOpen") then
		if ( resistance.entity.IsPhysicsEntity(entity) ) then
			local model = string.lower( entity:GetModel() );
			
			if ( self.containers[model] ) then
				local containerWeight = self.containers[model][1];
				
				if (!entity.password or entity.breached) then
					self:OpenContainer(player, entity, containerWeight);
				else
					umsg.Start("roleplay_ContainerPassword", player);
						umsg.Entity(entity);
					umsg.End();
				end;
			end;
		end;
	end;
end;

-- Called when an entity has been breached.
function PLUGIN:EntityBreached(entity, activator)
	if (entity.inventory and entity.password) then
		entity.breached = true;
		
		RESISTANCE:CreateTimer("Reset Breached: "..entity:EntIndex(), 120, 1, function()
			if ( IsValid(entity) ) then
				entity.breached = nil;
			end;
		end);
	end;
end;

-- Called when an entity is removed.
function PLUGIN:EntityRemoved(entity)
	if (IsValid(entity) and !entity.areBelongings) then
		if (entity.inventory and table.Count(entity.inventory) > 0) then
			for k, v in pairs(entity.inventory) do
				if (v > 0) then
					for i = 1, v do
						local item = resistance.entity.CreateItem( nil, k, entity:GetPos() + Vector( 0, 0, math.random(1, 48) ), entity:GetAngles() );
						
						resistance.entity.CopyOwner(entity, item);
					end;
				end;
			end;
		end;
			
		if (entity.cash and entity.cash > 0) then
			resistance.entity.CreateCash( nil, entity.cash, entity:GetPos() + Vector( 0, 0, math.random(1, 48) ) );
		end;
			
		entity.inventory = nil;
		entity.cash = nil;
	end;
end;

-- Called when a player's perma-kill info should be adjusted.
function PLUGIN:PlayerAdjustPermaKillInfo(player, info)
	
	info.cash = info.cash + player:GetCharacterData("lockercash");
	
	for k, v in pairs( player:GetCharacterData("lockerstorage") ) do
		info.inventory[k] = (info.inventory[k] or 0) + v;
	end;
	
	player:SetCharacterData( "lockerstorage", {} );
	player:SetCharacterData("lockercash", 0);
end;

-- Called when a player's prop cost info should be adjusted.
function PLUGIN:PlayerAdjustPropCostInfo(player, entity, info)
	local model = string.lower( entity:GetModel() );
	
	if ( self.containers[model] ) then
		info.name = self.containers[model][2];
	end;
end;