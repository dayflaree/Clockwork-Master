--[[
	Free Clockwork!
--]]

Clockwork.system = Clockwork:NewLibrary("System");
Clockwork.system.stored = {};

-- A function to get all systems.
function Clockwork.system:GetAll()
	return self.stored;
end;

-- A function to get a new system.
function Clockwork.system:New()
	return {};
end;

-- A function to get an system.
function Clockwork.system:Get(name)
	return self.stored[name];
end;

-- A function to get the system panel.
function Clockwork.system:GetPanel()
	if (IsValid(self.panel)) then
		return self.panel;
	end;
end;

-- A function to rebuild an system.
function Clockwork.system:Rebuild(name)
	local panel = self:GetPanel();
	
	if (panel and self:GetActive() == name) then
		panel:Rebuild();
	end;
end;

-- A function to get the active system.
function Clockwork.system:GetActive()
	local panel = self:GetPanel();
	
	if (panel) then
		return panel.system;
	end;
end;

-- A function to set the active system.
function Clockwork.system:SetActive(name)
	local panel = self:GetPanel();
	
	if (panel) then
		panel.system = name;
		panel:Rebuild();
	end;
end;

-- A function to register a new system.
function Clockwork.system:Register(system)
	self.stored[system.name] = system;
	
	if (!system.HasAccess) then
		system.HasAccess = function(systemTable)
			return Clockwork.player:HasFlags(Clockwork.Client, systemTable.access);
		end;
	end;
	
	-- A function to get whether the system is active.
	system.IsActive = function(systemTable)
		local activeAdmin = self:GetActive();
		
		if (activeAdmin == systemTable.name) then
			return true;
		else
			return false;
		end;
	end;
	
	-- A function to rebuild the system.
	system.Rebuild = function(systemTable)
		self:Rebuild(systemTable.name);
	end;
end;