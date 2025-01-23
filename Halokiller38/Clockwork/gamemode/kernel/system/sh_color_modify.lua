--[[
	Free Clockwork!
--]]

local ACCESS_FLAG = "a";

if (CLIENT) then
	SYSTEM = Clockwork.system:New();
	SYSTEM.name = "Color Modify";
	SYSTEM.access = ACCESS_FLAG;
	SYSTEM.toolTip = "Edit the schema's global color to suit your needs.";
	SYSTEM.doesCreateForm = false;
	Clockwork.OverrideColorMod = Clockwork:RestoreSchemaData("color", false);
	
	-- A function to get the key info.
	function SYSTEM:GetKeyInfo(key)
		if (key == "brightness") then
			return {name = "Brightness", minimum = -2, maximum = 2, decimals = 2};
		elseif (key == "contrast") then
			return {name = "Contrast", minimum = 0, maximum = 10, decimals = 2};
		elseif (key == "color") then
			return {name = "Color", minimum = 0, maximum = 5, decimals = 2};
		elseif (key == "addr") then
			return {name = "Add Red", minimum = 0, maximum = 255, decimals = 0};
		elseif (key == "addg") then
			return {name = "Add Green", minimum = 0, maximum = 255, decimals = 0};
		elseif (key == "addb") then
			return {name = "Add Blue", minimum = 0, maximum = 255, decimals = 0};
		elseif (key == "mulr") then
			return {name = "Multiply Red", minimum = 0, maximum = 255, decimals = 0};
		elseif (key == "mulg") then
			return {name = "Multiply Green", minimum = 0, maximum = 255, decimals = 0};
		elseif (key == "mulb") then
			return {name = "Multiply Blue", minimum = 0, maximum = 255, decimals = 0};
		end;
	end;
	
	-- Called when the system should be displayed.
	function SYSTEM:OnDisplay(systemPanel, systemForm)
		local infoText = vgui.Create("cwInfoText", systemPanel);
			infoText:SetText("Changing these values will affect the color for all players.");
			infoText:SetInfoColor("blue");
		systemPanel.panelList:AddItem(infoText);
		
		local infoText = vgui.Create("cwInfoText", systemPanel);
			infoText:SetText("Please note that this is for advanced users only.");
			infoText:SetInfoColor("orange");
		systemPanel.panelList:AddItem(infoText);
		
		self.colorModForm = vgui.Create("DForm", systemPanel);
			self.colorModForm:SetName("Color");
			self.colorModForm:SetPadding(4);
		systemPanel.panelList:AddItem(self.colorModForm);
		
		local checkBox = self.colorModForm:CheckBox("Enabled");
		checkBox.OnChange = function(checkBox, value)
			if (value != Clockwork.OverrideColorMod.enabled) then
				Clockwork:StartDataStream("SystemColSet", {key = "enabled", value = value});
			end;
		end;
		checkBox:SetValue(Clockwork.OverrideColorMod.enabled);
		
		for k, v in pairs(Clockwork.OverrideColorMod) do
			if (k != "enabled") then
				local info = self:GetKeyInfo(k);
				local numSlider = self.colorModForm:NumSlider(info.name, nil, info.minimum, info.maximum, info.decimals);
				numSlider.OnValueChanged = function(numSlider, value)
					if (value != Clockwork.OverrideColorMod[k]) then
						local timerName = "Color Set: "..k;
						
						Clockwork:CreateTimer(timerName, 1, 0, function()
							if (!input.IsMouseDown(MOUSE_LEFT)) then
								Clockwork:StartDataStream("SystemColSet", {key = k, value = value});
								Clockwork:DestroyTimer(timerName);
							end;
						end);
					end;
				end;
				numSlider:SetValue(v);
			end;
		end;
	end;

	Clockwork.system:Register(SYSTEM);
	
	Clockwork:HookDataStream("SystemColSet", function(data)
		Clockwork.OverrideColorMod[data.key] = tonumber(data.value);
		Clockwork:SaveSchemaData("color", Clockwork.OverrideColorMod);
		
		local systemTable = Clockwork.system:Get("Color Modify");
		
		if (systemTable) then
			systemTable:Rebuild();
		end;
	end);
	
	Clockwork:HookDataStream("SystemColGet", function(data)
		Clockwork.OverrideColorMod = data;
		Clockwork:SaveSchemaData("color", Clockwork.OverrideColorMod);
	end);
else
	Clockwork:HookDataStream("SystemColSet", function(player, data)
		if (Clockwork.player:HasFlags(player, "a")) then
			Clockwork.OverrideColorMod[data.key] = tonumber(data.value);
			Clockwork:SaveSchemaData("color", Clockwork.OverrideColorMod);
			Clockwork:StartDataStream(nil, "SystemColSet", data);
		end;
	end);
end;

if (!Clockwork.OverrideColorMod) then
	Clockwork.OverrideColorMod = {
		brightness = 0,
		contrast = 1,
		enabled = false,
		color = 1,
		mulr = 0,
		mulg = 0,
		mulb = 0,
		addr = 0,
		addg = 0,
		addb = 0,
	};
end;