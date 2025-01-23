--[[
	Free Clockwork!
--]]

Clockwork.hint = Clockwork:NewLibrary("Hint");
Clockwork.hint.stored = {};

-- A function to add a new hint.
function Clockwork.hint:Add(name, text, Callback)
	self.stored[name] = {
		Callback = Callback,
		text = text
	};
end;

-- A function to remove a hint.
function Clockwork.hint:Remove(name)
	self.stored[name] = nil;
end;

-- A function to find a hint.
function Clockwork.hint:Find(name)
	return self.stored[name];
end;

-- A function to distribute a hint.
function Clockwork.hint:Distribute()
	local hintText, Callback = self:Get();
	local hintInterval = Clockwork.config:Get("hint_interval"):Get();
	
	if (hintText) then
		for k, v in ipairs(_player.GetAll()) do
			if (v:HasInitialized() and v:GetInfoNum("cwShowHints", 1) == 1) then
				if (!v:IsViewingStarterHints()) then
					if (!Callback or Callback(v) != false) then
						self:Send(v, hintText, 4, nil, true);
					end;
				end;
			end;
		end;
	end;
end;

-- A function to send a hint to a player.
function Clockwork.hint:Send(player, text, delay, color, noSound)
	Clockwork:StartDataStream(player, "Hint", {text = Clockwork:ParseData(text), delay = delay, color = color, noSound = noSound});
end;

-- A function to send a hint to each player.
function Clockwork.hint:SendAll(text, delay, color)
	for k, v in ipairs(_player.GetAll()) do
		if (v:HasInitialized()) then
			self:Send(v, text, delay, color);
		end;
	end;
end;

-- A function to get a hint.
function Clockwork.hint:Get()
	local hints = {};
	
	for k, v in pairs(self.stored) do
		if (!v.Callback or v.Callback() != false) then
			hints[#hints + 1] = v;
		end;
	end;
	
	if (#hints > 0) then
		local hint = hints[math.random(1, #hints)];
		
		if (hint) then
			return hint.text, hint.Callback;
		end;
	end;
end;

Clockwork.hint:Add("OOC", "Type // before your message to talk out-of-character.");
Clockwork.hint:Add("LOOC", "Type .// or [[before your message to talk out-of-character locally.");
Clockwork.hint:Add("Ducking", "Toggle ducking by holding :+speed: and pressing :+walk: while standing still.");
Clockwork.hint:Add("Jogging", "Toggle jogging by pressing :+walk: while moving.");
Clockwork.hint:Add("Directory", "Hold down :+showscores: and click *name_directory* to get help.");
Clockwork.hint:Add("F1 Hotkey", "Hold :gm_showhelp: to view your character and roleplay information.");
Clockwork.hint:Add("F2 Hotkey", "Press :gm_showteam: while looking at a door to view the door menu.");
Clockwork.hint:Add("Tab Hotkey", "Press :+showscores: to view the main menu, or hold :+showscores: to temporarily view it.");

Clockwork.hint:Add("Context Menu", "Hold :+menu_context: and click on an entity to open its menu.", function(player)
	return !Clockwork.config:Get("use_opens_entity_menus"):Get();
end);
Clockwork.hint:Add("Entity Menu", "Press :+use: on an entity to open its menu.", function(player)
	return Clockwork.config:Get("use_opens_entity_menus"):Get();
end);
Clockwork.hint:Add("Phys Desc", "Change your character's physical description by typing $command_prefix$CharPhysDesc.", function(player)
	return Clockwork.command:Get("CharPhysDesc") != nil;
end);
Clockwork.hint:Add("Give Name", "Press :gm_showteam: to allow characters within a specific range to recognise you.", function(player)
	return Clockwork.config:Get("recognise_system"):Get();
end);
Clockwork.hint:Add("Raise Weapon", "Hold :+reload: to raise or lower your weapon.", function(player)
	return Clockwork.config:Get("raised_weapon_system"):Get();
end);
Clockwork.hint:Add("Target Recognises", "A character's name will flash white if they do not recognise you.", function(player)
	return Clockwork.config:Get("recognise_system"):Get();
end);