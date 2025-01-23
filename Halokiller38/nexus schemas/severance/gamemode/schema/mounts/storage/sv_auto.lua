--[[
Name: "sv_auto.lua".
Product: "Severance".
--]]

local MOUNT = MOUNT;

NEXUS:IncludePrefixed("sh_auto.lua");

NEXUS:HookDataStream("ContainerPassword", function(player, data)
	local password = data[1];
	local entity = data[2];
	
	if ( IsValid(entity) ) then
		if ( nexus.entity.IsPhysicsEntity(entity) ) then
			local model = string.lower( entity:GetModel() );
			
			if ( MOUNT.containers[model] ) then
				local containerWeight = MOUNT.containers[model][1];
				
				if (entity.password == password) then
					MOUNT:OpenContainer(player, entity, containerWeight);
				else
					nexus.player.Notify(player, "You have entered an incorrect password!");
				end;
			end;
		end;
	end;
end);

-- A function to get a random item.
function MOUNT:GetRandomItem(class)
	if (class) then
		class = string.lower(class);
	end;
	
	if (#self.randomItems > 0) then
		local item = self.randomItems[ math.random(1, #self.randomItems) ];
		
		if (item) then
			local itemTable = nexus.item.Get( item[1] );
			
			if ( !class or string.find(string.lower(itemTable.category), class) ) then
				return item;
			end;
		end;
		
		return self:GetRandomItem(class);
	end;
end;

-- A function to save the storage.
function MOUNT:SaveStorage()
	local storage = {};
	
	for k, v in pairs(self.storage) do
		if ( v.inventory and v.cash and (v.message or v.password
		or table.Count(v.inventory) > 0 or v.cash > 0
		or v:GetNetworkedString("sh_Name") != "") ) then
			local startPosition = v:GetStartPosition();
			local physicsObject = v:GetPhysicsObject();
			local moveable = nil;
			local model = v:GetModel();
			
			if (v:IsMapEntity() and startPosition) then
				model = nil;
			end;
			
			if ( IsValid(physicsObject) ) then
				moveable = physicsObject:IsMoveable();
			end;
			
			storage[#storage + 1] = {
				name = v:GetNetworkedString("sh_Name"),
				cash = v.cash,
				model = model,
				color = { v:GetColor() },
				angles = v:GetAngles(),
				position = v:GetPos(),
				message = v.message,
				moveable = moveable,
				password = v.password,
				inventory = v.inventory,
				startPosition = startPosition
			};
		end;
	end;
	
	NEXUS:SaveSchemaData("mounts/storage/"..game.GetMap(), storage);
end;

-- A function to load the storage.
function MOUNT:LoadStorage()
	self.storage = {};
	
	local storage = NEXUS:RestoreSchemaData( "mounts/storage/"..game.GetMap() );
	
	for k, v in pairs(storage) do
		for k2, v2 in pairs(v.inventory) do
			local itemTable = nexus.item.Get(k2);
			
			if (!itemTable) then
				v.inventory[k2] = nil;
			end;
		end;
		
		if (!v.model) then
			local entity = ents.FindInSphere(v.startPosition or v.position, 16)[1];
			
			if ( IsValid(entity) and entity:IsMapEntity() ) then
				self.storage[entity] = entity;
				
				entity.inventory = v.inventory;
				entity.password = v.password;
				entity.message = v.message;
				entity.cash = v.cash;
				
				if ( IsValid( entity:GetPhysicsObject() ) ) then
					if (!v.moveable) then
						entity:GetPhysicsObject():EnableMotion(false);
					else
						entity:GetPhysicsObject():EnableMotion(true);
					end;
				end;
				
				if (v.angles) then
					entity:SetAngles(v.angles);
					entity:SetPos(v.position);
				end;
				
				if (v.color) then
					entity:SetColor( unpack(v.color) );
				end;
				
				if (v.name and v.name != "") then
					entity:SetNetworkedString("sh_Name", v.name);
				end;
			end;
		else
			local entity = ents.Create("prop_physics");
			
			entity:SetAngles(v.angles);
			entity:SetModel(v.model);
			entity:SetPos(v.position);
			entity:Spawn();
			
			if ( IsValid( entity:GetPhysicsObject() ) ) then
				if (!v.moveable) then
					entity:GetPhysicsObject():EnableMotion(false);
				end;
			end;
			
			if (v.color) then
				entity:SetColor( unpack(v.color) );
			end;
			
			if (v.name and v.name != "") then
				entity:SetNetworkedString("sh_Name", v.name);
			end;
			
			self.storage[entity] = entity;
			
			entity.inventory = v.inventory;
			entity.password = v.password;
			entity.message = v.message;
			entity.cash = v.cash;
		end;
	end;
end;

-- A function to open a container for a player.
function MOUNT:OpenContainer(player, entity, weight)
	local inventory;
	local cash = 0;
	local model = string.lower( entity:GetModel() );
	local name = "";
	
	if (!entity.inventory) then
		self.storage[entity] = entity;
		
		entity.inventory = {};
	end;
	
	if (!entity.cash) then
		entity.cash = 0;
	end;
	
	if ( self.containers[model] ) then
		name = self.containers[model][2];
	else
		name = "Container";
	end;
	
	inventory = entity.inventory;
	cash = entity.cash;
	
	if (!weight) then
		weight = 8;
	end;
	
	if (entity:GetNetworkedString("sh_Name") != "") then
		name = entity:GetNetworkedString("sh_Name");
	end;
	
	if (entity.message) then
		umsg.Start("nx_StorageMessage", player);
			umsg.Entity(entity);
			umsg.String(entity.message);
		umsg.End();
	end;
	
	nexus.player.OpenStorage( player, {
		name = name,
		weight = weight,
		entity = entity,
		distance = 192,
		cash = cash,
		inventory = inventory,
		OnGiveCash = function(player, storageTable, cash)
			storageTable.entity.cash = storageTable.cash;
		end,
		OnTakeCash = function(player, storageTable, cash)
			storageTable.entity.cash = storageTable.cash;
		end
	} );
end;