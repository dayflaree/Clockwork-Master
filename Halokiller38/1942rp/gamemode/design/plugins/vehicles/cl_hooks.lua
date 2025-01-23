--[[
Name: "cl_hooks.lua".
Product: "Day One".
--]]

local PLUGIN = PLUGIN;

-- Called when the calc view table should be adjusted.
function PLUGIN:CalcViewAdjustTable(view)
	if ( g_LocalPlayer:InVehicle() ) then
		local vehicle = g_LocalPlayer:GetVehicle();
		local index = vehicle:GetNetworkedInt("sh_Index");

		if (index != 0) then
			local itemTable = blueprint.item.Get(index);

			if (itemTable and itemTable.calcView) then
				view.origin = view.origin + itemTable.calcView;
			end;
		end;
	end;
end;

-- Called when a player presses a bind.
function PLUGIN:PlayerBindPress(player, bind, pressed)
	if ( player:InVehicle() ) then
		if ( string.find(bind, "+attack2") ) then
			BLUEPRINT:StartDataStream("ManageCar", "unlock");
		elseif ( string.find(bind, "+attack") ) then
			BLUEPRINT:StartDataStream("ManageCar", "lock");
		elseif ( string.find(bind, "+reload") ) then
			BLUEPRINT:StartDataStream("ManageCar", "horn");
		end;
	end;
end;

-- Called when an entity's target ID HUD should be painted.
function PLUGIN:HUDPaintEntityTargetID(entity, info)
	local colorTargetID = blueprint.design.GetColor("target_id");
	local colorWhite = blueprint.design.GetColor("white");
	local index = entity:GetNetworkedInt("sh_Index");
	
	if (!g_LocalPlayer:InVehicle() and entity:GetClass() == "prop_vehicle_jeep") then
		local wrappedTable = {};
		local itemTable = blueprint.item.Get(index);
		
		if (itemTable) then
			info.y = BLUEPRINT:DrawInfo( itemTable.name, info.x, info.y, colorTargetID, info.alpha);

			if (itemTable.vehiclePhysDesc) then
				local physDesc = BLUEPRINT:ModifyPhysDesc(itemTable.vehiclePhysDesc);
				
				BLUEPRINT:WrapText(physDesc, blueprint.design.GetFont("target_id_text"), math.max(ScrW() / 8, 384), wrappedTable);
				
				for k, v in ipairs(wrappedTable) do
					info.y = BLUEPRINT:DrawInfo(v, info.x, info.y, colorWhite, info.alpha);
				end;
			end;
		end;
	end;
end;