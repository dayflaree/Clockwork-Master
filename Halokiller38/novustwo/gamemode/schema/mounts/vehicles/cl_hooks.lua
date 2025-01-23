--[[
Name: "cl_hooks.lua".
Product: "Novus Two".
--]]

local MOUNT = MOUNT;

-- Called when the calc view table should be adjusted.
function MOUNT:CalcViewAdjustTable(view)
	if ( g_LocalPlayer:InVehicle() ) then
		local vehicle = g_LocalPlayer:GetVehicle();
		local index = vehicle:GetNetworkedInt("sh_Index");

		if (index != 0) then
			local itemTable = nexus.item.Get(index);

			if (itemTable and itemTable.calcView) then
				view.origin = view.origin + itemTable.calcView;
			end;
		end;
	end;
end;

-- Called when a player presses a bind.
function MOUNT:PlayerBindPress(player, bind, pressed)
	if ( player:InVehicle() ) then
		if ( string.find(bind, "+attack2") ) then
			NEXUS:StartDataStream("ManageCar", "unlock");
		elseif ( string.find(bind, "+attack") ) then
			NEXUS:StartDataStream("ManageCar", "lock");
		elseif ( string.find(bind, "+reload") ) then
			NEXUS:StartDataStream("ManageCar", "horn");
		end;
	end;
end;

-- Called when an entity's target ID HUD should be painted.
function MOUNT:HUDPaintEntityTargetID(entity, info)
	local colorTargetID = nexus.schema.GetColor("target_id");
	local colorWhite = nexus.schema.GetColor("white");
	local index = entity:GetNetworkedInt("sh_Index");
	
	if (!g_LocalPlayer:InVehicle() and entity:GetClass() == "prop_vehicle_jeep") then
		local wrappedTable = {};
		local itemTable = nexus.item.Get(index);
		
		if (itemTable) then
			info.y = NEXUS:DrawInfo( itemTable.name, info.x, info.y, colorTargetID, info.alpha);

			if (itemTable.vehiclePhysDesc) then
				local physDesc = NEXUS:ModifyPhysDesc(itemTable.vehiclePhysDesc);
				
				NEXUS:WrapText(physDesc, nexus.schema.GetFont("target_id_text"), math.max(ScrW() / 8, 384), wrappedTable);
				
				for k, v in ipairs(wrappedTable) do
					info.y = NEXUS:DrawInfo(v, info.x, info.y, colorWhite, info.alpha);
				end;
			end;
		end;
	end;
end;