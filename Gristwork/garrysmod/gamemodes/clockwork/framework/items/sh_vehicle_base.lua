--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local Clockwork = Clockwork;

local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "Vehicle Base";
ITEM.batch = 1;
ITEM.weight = 0;
ITEM.useText = "Drive";
ITEM.category = "Vehicles";
ITEM.business = false;
ITEM.hornSound = "vehicles/honk.wav";
ITEM.isRareItem = true;
ITEM.weightText = "Garage";
ITEM.allowStorage = false;

ITEM:AddData("Name", "", true);
ITEM:AddData("Desc", "", true);
ITEM:AddData("Fuel", 100, true);
ITEM:AddQueryProxy("description", "Desc", true);
ITEM:AddQueryProxy("name", "Name", true);
ITEM:AddQueryProxy("fuel", "Fuel", true);

-- Called when the item has been ordered.
function ITEM:OnOrder(player, entity)
	if (IsValid(entity)) then entity:Remove(); end;
	
	player:GiveItem(
		Clockwork.item:CreateInstance(self("uniqueID")), true
	);
end;

-- Called when a player destroys the item.
function ITEM:OnDestroy(player) end;

-- A function to make a vehicle.
function ITEM:MakeVehicle(player, position, angles)
	local vehicleEntity = ents.Create(self("class"));

	if (!IsValid(vehicleEntity)) then
		ErrorNoHalt("[Clockwork] The '"..self("class").."' entity does not exist!\n");
		return false, "There was an error spawning this vehicle!";
	end;

	local itemKeyValues = self("keyValues");
	
	vehicleEntity:SetModel(self("model"));

	if (itemKeyValues) then
		for k, v in pairs(itemKeyValues) do
			vehicleEntity:SetKeyValue(k, v);
		end		
	end;

	if (self.GetSpawnPosition) then
		position = self:GetSpawnPosition(vehicleEntity, position);
	end;

	vehicleEntity:SetAngles(angles);
		vehicleEntity:SetPos(position);
		vehicleEntity:Spawn();
		vehicleEntity:Activate();
		vehicleEntity:SetUseType(SIMPLE_USE);
	vehicleEntity:SetNetworkedInt("Index", self("index"));

	local physicsObject = vehicleEntity:GetPhysicsObject();

	if (!IsValid(physicsObject)) then
		return false, "The physics object for this vehicle is not valid!";
	end;

	if (self.bCheckPenetration != false) then
		if (physicsObject:IsPenetrating()) then
			vehicleEntity:Remove();
			return false, "A vehicle cannot be spawned at this location!";
		end;
	end;

	vehicleEntity.cwItemTable = self;
	vehicleEntity.VehicleName = self("name");
	vehicleEntity.ClassOverride = self("class");
	
	-- A function to get the vehicle's item table.
	function vehicleEntity:GetItemTable()
		return self.cwItemTable;
	end;

	local localPosition = vehicleEntity:GetPos();
	local localAngles = vehicleEntity:GetAngles();

	if (self("passengers")) then		
		local seatType = self("seatType", "Seat_Jeep");
		local seatData = list.Get("Vehicles")[seatType];

		for k, v in ipairs(self("passengers")) do
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
			
			if (self("useLocalPositioning")) then
				seatEntity:SetLocalPos(v.position);
				seatEntity:SetLocalAngles(v.angles);
			end;

			if (self("hideSeats")) then
				seatEntity:SetColor(Color(255, 255, 255, 0));
				seatEntity:SetRenderMode(RENDERMODE_TRANSALPHA);
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

			if (!vehicleEntity.cwPassengers) then
				vehicleEntity.cwPassengers = {};
			end;

			vehicleEntity.cwPassengers[k] = seatEntity;
		end;
	end;
	
	Clockwork.item:AddItemEntity(vehicleEntity, self);
	return vehicleEntity;
end;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local eyeTrace = player:GetEyeTraceNoCursor();

	if (player:GetPos():Distance(eyeTrace.HitPos) <= 512) then
		local trace = util.QuickTrace(eyeTrace.HitPos, eyeTrace.HitNormal * 100000);

		if (!trace.HitSky) then
			Clockwork.player:Notify(player, "You can only spawn a vehicle outside!");
			return false;
		end;

		local vehicleEntity, fault = self:MakeVehicle(player, eyeTrace.HitPos + Vector(0, 0, 32), Angle(0, player:GetAngles().yaw + 180, 0));

		if (!IsValid(vehicleEntity)) then
			if (fault) then
				Clockwork.player:Notify(player, fault);
			end;

			return false;
		end;

		if (self("skin")) then
			vehicleEntity:SetSkin(self("skin"));
		end;

		vehicleEntity.m_tblToolsAllowed = {"remover"};
		
		-- Called when a player attempts to use a tool.
		function vehicleEntity:CanTool(player, trace, tool)
			return (mode == "remover" and player:IsAdmin());
		end;

		Clockwork.player:GiveProperty(player, vehicleEntity, true);

		player.cwVehicleList = player.cwVehicleList or {};
		player.cwVehicleList[vehicleEntity] = self;
	else
		Clockwork.player:Notify(player, "You cannot spawn a vehicle that far away!");
		return false;
	end;
end;

ITEM:Register();