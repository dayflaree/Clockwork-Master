--[[
	Free Clockwork!
--]]

Clockwork.quickmenu = Clockwork:NewLibrary("QuickMenu");
Clockwork.quickmenu.stored = {};
Clockwork.quickmenu.categories = {};

-- A function to add a quick menu callback.
function Clockwork.quickmenu:AddCallback(name, category, GetInfo, OnCreateMenu)
	if (category) then
		if (!self.categories[category]) then
			self.categories[category] = {};
		end;
		
		self.categories[category][name] = {
			OnCreateMenu = OnCreateMenu,
			GetInfo = GetInfo,
			name = name
		};
	else
		self.stored[name] = {
			OnCreateMenu = OnCreateMenu,
			GetInfo = GetInfo,
			name = name
		};
	end;
	
	return name;
end;

-- A function to add a command quick menu callback.
function Clockwork.quickmenu:AddCommand(name, category, command, options)
	return self:AddCallback(name, category, function()
		local commandTable = Clockwork.command:Get(command);
		
		if (commandTable) then
			return {
				toolTip = commandTable.tip,
				Callback = function(option)
					Clockwork:RunCommand(command, option);
				end,
				options = options
			};
		else
			return false;
		end;
	end);
end;

Clockwork.quickmenu:AddCallback("Fall Over", nil, function()
	local commandTable = Clockwork.command:Get("CharFallOver");
	
	if (commandTable) then
		return {
			toolTip = commandTable.tip,
			Callback = function(option)
				Clockwork:RunCommand("CharFallOver");
			end
		};
	else
		return false;
	end;
end);

Clockwork.quickmenu:AddCallback("Description", nil, function()
	local commandTable = Clockwork.command:Get("CharPhysDesc");
	
	if (commandTable) then
		return {
			toolTip = commandTable.tip,
			Callback = function(option)
				Clockwork:RunCommand("CharPhysDesc");
			end
		};
	else
		return false;
	end;
end);