--[[
Name: "sv_auto.lua".
Product: "Day One".
--]]

local PLUGIN = PLUGIN;

BLUEPRINT:IncludePrefixed("sh_auto.lua");

resource.AddFile("scripts/sounds/game_sounds_vehiclepack.txt");
resource.AddFile("sound/vehicles/honk.wav");
resource.AddFile("models/tacoma6.mdl");
resource.AddFile("models/tacoma7.mdl");

for k, v in pairs( g_File.Find("../materials/models/ill_hanger/vehicles/*.*") ) do
	resource.AddFile("materials/models/ill_hanger/vehicles/"..v);
end;

for k, v in pairs( g_File.Find("../scripts/vehicles/*.*") ) do
	resource.AddFile("scripts/vehicles/"..v);
end;

BLUEPRINT:HookDataStream("ManageCar", function(player, data)
	local vehicle = player:GetVehicle();

	if ( IsValid(vehicle) ) then
		local parentVehicle = vehicle:GetParent();
		
		if ( !IsValid(parentVehicle) ) then
			if (vehicle.ItemTable) then
				parentVehicle = vehicle;
			end;
		end;
		
		if (player:InVehicle() and IsValid(parentVehicle) and parentVehicle.ItemTable) then
			if (parentVehicle:GetDriver() == player) then
				if (data == "unlock") then
					parentVehicle.IsLocked = false;
					parentVehicle:EmitSound("doors/door_latch3.wav");
					parentVehicle:Fire("unlock", "", 0);
				elseif (data == "lock") then
					parentVehicle.IsLocked = true;
					parentVehicle:EmitSound("doors/door_latch3.wav");
					parentVehicle:Fire("lock", "", 0);
				elseif (data == "horn") then
					if (parentVehicle.ItemTable.PlayHornSound) then
						parentVehicle.ItemTable:PlayHornSound(player, parentVehicle);
					elseif (parentVehicle.ItemTable.hornSound) then
						parentVehicle:EmitSound(parentVehicle.ItemTable.hornSound);
					end;
				end;
			end;
		end;
	end;
end);

-- A function to get a vehicle exit for a player.
function PLUGIN:GetVehicleExit(player, vehicle)
	local available = {};
	local closest = {};
	
	if (vehicle.ItemTable and vehicle.ItemTable.customExits) then
		for k, v in ipairs(vehicle.ItemTable.customExits) do
			local position = vehicle:LocalToWorld(v);
			local entities = ents.FindInSphere(position, 1);
			local unsafe = nil;
			
			for k2, v2 in ipairs(entities) do
				if ( player != v2 and v2:IsPlayer() ) then
					unsafe = true;
					
					break;
				end;
			end;
			
			if (util.IsInWorld(position) and !unsafe) then
				available[#available + 1] = position;
			end;
		end;
	end;
	
	for k, v in ipairs(self.normalExits) do
		local attachment = vehicle:GetAttachment( vehicle:LookupAttachment(v) );
		
		if (attachment) then
			local position = attachment.Pos;
			local entities = ents.FindInSphere(position, 1);
			local unsafe = nil;
			
			for k2, v2 in ipairs(entities) do
				if ( player != v2 and v2:IsPlayer() ) then
					unsafe = true;
					
					break;
				end;
			end;
			
			if ( !unsafe and util.IsInWorld(position) ) then
				available[#available + 1] = position;
			end;
		end;
	end;
	
	for k, v in ipairs(available) do
		local distance = player:GetPos():Distance(v);
		
		if ( !closest[1] or distance < closest[1] ) then
			closest[1] = distance;
			closest[2] = v;
		end;
	end;

	if ( closest[2] ) then
		blueprint.player.SetSafePosition( player, closest[2] );
	end;
end;

-- A function to make a player exit a vehicle.
function PLUGIN:MakeExitVehicle(player, vehicle)
	player:SetVelocity( Vector(0, 0, 0) );

	if ( !player:InVehicle() ) then
		local parentVehicle = vehicle:GetParent();
		
		if ( IsValid(parentVehicle) ) then
			self:GetVehicleExit(player, parentVehicle);
		else
			self:GetVehicleExit(player, vehicle);
		end;
	end;
end;

-- A function to spawn a vehicle.
function PLUGIN:SpawnVehicle(player, itemTable)
	local currentlyUsed = 0;
	
	for k, v in ipairs( g_Player.GetAll() ) do
		if (v:HasInitialized() and v.vehicles) then
			if ( table.HasValue(v.vehicles, itemTable) ) then
				currentlyUsed = currentlyUsed + 1;
				
				if (currentlyUsed == 2) then
					break;
				end;
			end;
		end;
	end;
	
	if (currentlyUsed == 2) then
		blueprint.player.Notify(player, "Two of these faction-based vehicles are already on the map!");

		return false;
	end;
	
	if ( table.HasValue(player.vehicles, itemTable) ) then
		blueprint.player.Notify(player, "You have already spawned a "..itemTable.name..", go and look for it!");

		return false;
	else
		local eyeTrace = player:GetEyeTraceNoCursor();

		if (player:GetPos():Distance(eyeTrace.HitPos) <= 512) then
			local trace = util.QuickTrace(eyeTrace.HitPos, eyeTrace.HitNormal * 100000);

			if (!trace.HitSky) then
				blueprint.player.Notify(player, "You can only spawn a vehicle outside!");

				return false;
			end;

			local vehicleEntity, fault = self:MakeVehicle( player, itemTable, eyeTrace.HitPos + Vector(0, 0, 32), Angle(0, player:GetAngles().yaw + 180, 0) );

			if ( !IsValid(vehicleEntity) ) then
				if (fault) then
					blueprint.player.Notify(player, fault);
				end;

				return false;
			end;

			if (itemTable.skin) then
				vehicleEntity:SetSkin(itemTable.skin);
			end;

			vehicleEntity.m_tblToolsAllowed = {"remover"};
			
			-- Called when a player attempts to use a tool.
			function vehicleEntity:CanTool(player, trace, tool)
				return ( mode == "remover" and player:IsAdmin() );
			end;

			blueprint.player.GiveProperty(player, vehicleEntity, true);

			player.vehicles[vehicleEntity] = itemTable;

			return vehicleEntity;
		else
			blueprint.player.Notify(player, "You cannot spawn a vehicle that far away!");

			return false;
		end;
	end;
end;

-- A function to make a vehicle.
function PLUGIN:MakeVehicle(player, itemTable, position, angles)
	local vehicleEntity = ents.Create(itemTable.class);

	vehicleEntity:SetModel(itemTable.model);

	if (itemTable.keyValues) then
		for k, v in pairs(itemTable.keyValues) do
			vehicleEntity:SetKeyValue(k, v);
		end		
	end;

	vehicleEntity:SetAngles(angles);
	vehicleEntity:SetPos(position);
	vehicleEntity:Spawn();

	vehicleEntity:Activate();
	vehicleEntity:SetUseType(SIMPLE_USE)
	vehicleEntity:SetNetworkedInt("sh_Index", itemTable.index);

	local physicsObject = vehicleEntity:GetPhysicsObject();

	if ( !IsValid(physicsObject) ) then
		return false, "The physics object for this vehicle is not valid!";
	end

	if ( physicsObject:IsPenetrating() ) then
		vehicleEntity:Remove();

		return false, "A vehicle cannot be spawned at this location!";
	end

	vehicleEntity.ItemTable = itemTable;
	vehicleEntity.VehicleName = itemTable.name;
	vehicleEntity.ClassOverride = itemTable.class;

	local localPosition = vehicleEntity:GetPos();
	local localAngles = vehicleEntity:GetAngles();

	if (itemTable.passengers) then		
		local seatName = itemTable.seatType;
		local seatData = list.Get( "Vehicles" )[seatName];

		for k, v in pairs(itemTable.passengers) do
			local seatPosition = localPosition + (localAngles:Forward() * v.position.x) + (localAngles:Right() * v.position.y) + (localAngles:Up() * v.position.z);
			local seatEntity = ents.Create("prop_vehicle_prisoner_pod");

			seatEntity:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt");
			seatEntity:SetAngles(localAngles + v.angles);
			seatEntity:SetModel(seatData.Model);
			seatEntity:SetPos(seatPosition);
			seatEntity:Spawn();

			seatEntity:Activate();
			seatEntity:Fire("lock", "", 0);

			seatEntity:SetCollisionGroup(COLLISION_GROUP_WORLD);
			seatEntity:SetParent(vehicleEntity);
			
			if (itemTable.useLocalPositioning) then
				seatEntity:SetLocalPos(v.position);
				seatEntity:SetLocalAngles(v.angles);
			end;

			if (itemTable.hideSeats) then
				seatEntity:SetColor(255, 255, 255, 0);
			end;

			if (seatData.Members) then
				table.Merge(seatEntity, seatData.Members);
			end;

			if (seatData.KeyValues) then
				for k2, v2 in pairs(seatData.KeyValues) do
					seatEntity:SetKeyValue(k2, v2);
				end;
			end;

			seatEntity:DeleteOnRemove(vehicleEntity);
			seatEntity.ClassOverride = "prop_vehicle_prisoner_pod";
			seatEntity.VehicleTable = seatData
			seatEntity.VehicleName = "Jeep Seat";

			if (!vehicleEntity.Passengers) then
				vehicleEntity.Passengers = {};
			end;

			vehicleEntity.Passengers[k] = seatEntity;
		end;
	end;

	return vehicleEntity;
end;