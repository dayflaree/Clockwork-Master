--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

Clockwork.infoBox = Clockwork:NewLibrary("InfoBox");
Clockwork.infoBox.classes = {};
Clockwork.infoBox.messages = {};
Clockwork.infoBox.spaceWidths = {};
Clockwork.infoBox.historyPosition = 0;
Clockwork.infoBox.historyMessages = {};

-- A function to register a chat box class.
function Clockwork.infoBox:RegisterClass(class, filter, Callback)
	self.classes[class] = {
		Callback = Callback,
		filter = filter
	};
end;

-- A function to set the chat box's custom position.
function Clockwork.infoBox:SetCustomPosition(x, y)
	self.position = {
		x = x,
		y = y
	};
end;

-- A function to get the chat box's custom position.
function Clockwork.infoBox:GetCustomPosition()
	return self.position;
end;

-- A function to reset the chat box's custom position.
function Clockwork.infoBox:ResetCustomPosition()
	self.position = nil;
end;

-- A function to get the position of the chat area.
function Clockwork.infoBox:GetPosition(addX, addY)
	local customPosition = Clockwork.infoBox:GetCustomPosition();
	local x, y = 8, 0;
	
	if (customPosition) then
		x = customPosition.x;
		y = customPosition.y;
	end;
	
	return x + (addX or 0), y + (addY or 0);
end;

-- A function to get the x position of the chat area.
function Clockwork.infoBox:GetX()
	local x, y = Clockwork.infoBox:GetPosition();
	
	return x;
end;

-- A function to get the y position of the chat area.
function Clockwork.infoBox:GetY()
	local x, y = Clockwork.infoBox:GetPosition();
	
	return y;
end;

-- A function to get the current text.
function Clockwork.infoBox:GetCurrentText()
	return "";
end;

-- A function to get the spacing between messages.
function Clockwork.infoBox:GetSpacing()
	local infoBoxTextFont = Clockwork.option:GetFont("chat_box_text");
	local textWidth, textHeight = Clockwork:GetCachedTextSize(infoBoxTextFont, "U");
	
	if (textWidth and textHeight) then
		return textHeight + 4;
	end;
end;

-- A function to decode a message.
function Clockwork.infoBox:Decode(speaker, name, text, data, class)
	local filtered = nil;
	local filter = nil;
	local icon = nil;
	
	if (Clockwork.chatBox.classes[class]) then
		filter = Clockwork.chatBox.classes[class].filter;
	elseif (class == "pm" or class == "ooc"
	or class == "roll" or class == "looc") then
		filtered = (CW_CONVAR_SHOWOOC:GetInt() == 0);
		filter = "ooc";
	else
		filtered = (CW_CONVAR_SHOWIC:GetInt() == 0);
		filter = "ic";
	end;
	
	text = Clockwork:Replace(text, " ' ", "'");

	if (filter == "ooc" or class == "notify" or class == "notify_all" or class == "looc" or class == "connect" or class == "chat") then
		if (IsValid(speaker)) then
			if (!Clockwork:IsChoosingCharacter()) then
				if (speaker:Name() != "") then
					local unrecognised = false;
					local classIndex = speaker:Team();
					local classColor = _team.GetColor(classIndex);
					local focusedOn = false;
					
					if (speaker:IsSuperAdmin()) then
						icon = "gui/silkicons/shield";
					elseif (speaker:IsAdmin()) then
						icon = "gui/silkicons/star";
					elseif (speaker:IsUserGroup("operator")) then
						icon = "gui/silkicons/emoticon_smile";
					else
						local faction = speaker:GetFaction();
						
						if (faction and Clockwork.faction.stored[faction]) then
							if (Clockwork.faction.stored[faction].whitelist) then
								icon = "gui/silkicons/add";
							end;
						end;
						
						if (!icon) then
							icon = "gui/silkicons/user";
						end;
					end;
					
					if (!Clockwork.player:DoesRecognise(speaker, RECOGNISE_TOTAL) and filter == "ic") then
						unrecognised = true;
					end;
					
					if (Clockwork.player:GetRealTrace(Clockwork.Client).Entity == speaker) then
						focusedOn = true;
					end;
					
					local info = {
						unrecognised = unrecognised,
						shouldHear = Clockwork.player:CanHearPlayer(Clockwork.Client, speaker),
						focusedOn = focusedOn,
						filtered = filtered,
						speaker = speaker,
						visible = true;
						filter = filter,
						class = class,
						icon = icon,
						name = name,
						text = text,
						data = data
					};
					
					Clockwork.plugin:Call("InfoBoxAdjustInfo", info);
					
					if (info.visible) then					
						if (Clockwork.chatBox.classes[info.class]) then
							Clockwork.chatBox.classes[info.class].Callback(info);
						elseif (info.class == "looc") then
							Clockwork.chatBox:Add(info.filtered, nil, Color(225, 50, 50, 255), "[LOOC] ", Color(255, 255, 150, 255), info.name..": "..info.text);	
						elseif (info.class == "chat") then
							Clockwork.infoBox:Add(info.filtered, nil, classColor, info.name, ": ", info.text, nil, info.filtered);
						elseif (info.class == "ooc") then
							Clockwork.infoBox:Add(info.filtered, info.icon, Color(225, 50, 50, 255), "[OOC] ", classColor, info.name, ": ", info.text);
						elseif (info.class == "pm") then
							Clockwork.infoBox:Add(info.filtered, nil, "[PM] ", Color(125, 150, 75, 255), info.name..": "..info.text);
						end;
					end;
				end;
			end;
		else
			if (name == "Console" and class == "chat") then
				icon = "gui/silkicons/shield";
			end;
			
			local info = {
				filtered = filtered,
				visible = true;
				filter = filter,
				class = class,
				icon = icon,
				name = name,
				text = text,
				data = data
			};
			
			Clockwork.plugin:Call("InfoBoxAdjustInfo", info);
			
			if (!info.visible) then return; end;
			
			if (self.classes[info.class]) then
				self.classes[info.class].Callback(info);
			elseif (info.class == "notify_all") then
				if (Clockwork:GetNoticePanel()) then
					Clockwork:AddCinematicText(info.text, Color(255, 255, 255, 255), 32, 6, Clockwork.option:GetFont("menu_text_tiny"), true);
				end;
				
				local filtered = (CW_CONVAR_SHOWAURA:GetInt() == 0) or info.filtered;
				
				if (string.sub(info.text, -1) == "!") then
					Clockwork.infoBox:Add(filtered, "gui/silkicons/error", Color(200, 175, 200, 255), info.text);
				else
					Clockwork.infoBox:Add(filtered, "gui/silkicons/comment", Color(125, 150, 175, 255), info.text);
				end;
			elseif (info.class == "disconnect") then
				local filtered = (CW_CONVAR_SHOWAURA:GetInt() == 0) or info.filtered;
				
				Clockwork.infoBox:Add(filtered, "gui/silkicons/user_delete", Color(200, 150, 200, 255), info.text);
			elseif (info.class == "notify") then
				if (Clockwork:GetNoticePanel()) then
					Clockwork:AddCinematicText(info.text, Color(255, 255, 255, 255), 32, 6, Clockwork.option:GetFont("menu_text_tiny"), true);
				end;
				
				local filtered = (CW_CONVAR_SHOWAURA:GetInt() == 0) or info.filtered;
				
				if (string.sub(info.text, -1) == "!") then
					Clockwork.infoBox:Add(filtered, "gui/silkicons/error", Color(200, 175, 200, 255), info.text);
				else
					Clockwork.infoBox:Add(filtered, "gui/silkicons/comment", Color(175, 200, 255, 255), info.text);
				end;
			elseif (info.class == "connect") then
				local filtered = (CW_CONVAR_SHOWAURA:GetInt() == 0) or info.filtered;
				Clockwork.infoBox:Add(filtered, "gui/silkicons/user_add", Color(150, 150, 200, 255), info.text);
			elseif (info.class == "chat") then
				Clockwork.infoBox:Add(info.filtered, info.icon, Color(225, 50, 50, 255), "[OOC] ", Color(150, 150, 150, 255), name, ": ", info.text);
			else
				local yellowColor = Color(255, 255, 150, 255);
				local blueColor = Color(125, 150, 175, 255);
				local redColor = Color(200, 25, 25, 255);
				local filtered = (CW_CONVAR_SHOWSERVER:GetInt() == 0) or info.filtered;
				local prefix;
				
				Clockwork.infoBox:Add(filtered, nil, yellowColor, info.text);
			end;
		end;
	end;
end;

function Clockwork.infoBox:MouseWheeled(delta)
	local maximumLines = math.Clamp(CW_CONVAR_MAXCHATLINES:GetInt(), 1, 10);
	
	if (delta > 0) then
		delta = math.Clamp(delta, 1, maximumLines);
		
		if (self.historyMessages[self.historyPosition - maximumLines]) then
			self.historyPosition = self.historyPosition - delta;
		end;
	else
		if (!self.historyMessages[self.historyPosition - delta]) then
			delta = -1;
		end;
		
		if (self.historyMessages[self.historyPosition - delta]) then
			self.historyPosition = self.historyPosition - delta;
		end;
	end;
end;

-- A function to add and wrap text to a message.
function Clockwork.infoBox:WrappedText(newLine, message, color, text, OnHover)
	local infoBoxTextFont = Clockwork.option:GetFont("chat_box_text");
	local width, height = Clockwork:GetTextSize(infoBoxTextFont, text);
	local maximumWidth = ScrW() * 0.75;
	local singleWidth = Clockwork:GetTextSize(infoBoxTextFont, "U");
	
	if (message.currentWidth + width > maximumWidth) then
		local characters = math.ceil((maximumWidth - message.currentWidth) / singleWidth) + 1;
		local secondText = string.sub(text, characters + 1);
		local firstText = string.sub(text, 0, characters);
		
		if (firstText and firstText != "") then
			Clockwork.infoBox:WrappedText(true, message, color, firstText, OnHover);
		end;
		
		if (secondText and secondText != "") then
			Clockwork.infoBox:WrappedText(nil, message, color, secondText, OnHover);
		end;
	else
		message.text[#message.text + 1] = {
			newLine = newLine,
			OnHover = OnHover,
			height = height,
			width = width,
			color = color,
			text = text
		};
		
		if (newLine) then
			message.currentWidth = 0;
			message.lines = message.lines + 1;
		else
			message.currentWidth = message.currentWidth + width;
		end;
	end;
end;

-- A function to paint the chat box.
function Clockwork.infoBox:Paint()
	local menuTextTinyFont = Clockwork.option:GetFont("menu_text_tiny");
	local infoBoxTextFont = Clockwork.option:GetFont("chat_box_text");
	local isOpen = Clockwork.chatBox:IsOpen();
	
	Clockwork:OverrideMainFont(infoBoxTextFont);
		if (!self.spaceWidths[infoBoxTextFont]) then
			self.spaceWidths[infoBoxTextFont] = Clockwork:GetTextSize(infoBoxTextFont, " ");
		end;
		
		local isTypingCommand = Clockwork.chatBox:IsTypingCommand();
		local infoBoxSpacing = Clockwork.infoBox:GetSpacing();
		local maximumLines = math.Clamp(CW_CONVAR_MAXCHATLINES:GetInt(), 1, 10);
		local origX, origY = Clockwork.infoBox:GetPosition(0, Clockwork.y);
		local onHoverData = nil;
		local spaceWidth = self.spaceWidths[infoBoxTextFont];
		local fontHeight = infoBoxSpacing - 4;
		local messages = self.messages;
		local x, y = origX, origY;
		local box = {width = 0, height = 0};

		if (!isOpen) then
			if (#self.historyMessages > 100) then
				local amount = #self.historyMessages - 100;
				
				for i = 1, amount do
					table.remove(self.historyMessages, 1);
				end;
			end;
		else
			messages = {};
			
			for i = 0, (maximumLines - 1) do
				messages[#messages + 1] = self.historyMessages[self.historyPosition - i];
			end;
		end;
		
		for k, v in pairs(messages) do
			if (messages[k - 1]) then
				y = y + messages[k - 1].spacing;
			end;

			y = y + ((infoBoxSpacing + v.spacing) * v.lines);
			
			if (k == 1) then
				y = y - 2;
			end;
			
			local messageX = x;
			local messageY = y;
			local alpha = v.alpha;
			
			if (isTypingCommand) then
				alpha = 255;
			elseif (isOpen) then
				alpha = 255;
			end;
			
			if (v.icon) then
				surface.SetTexture(surface.GetTextureID(v.icon));
				surface.SetDrawColor(255, 255, 255, alpha);
				surface.DrawTexturedRect(messageX, messageY + (fontHeight / 2) - 8, 16, 16);
				messageX = messageX + 16 + spaceWidth;
			end;
			
			local mouseX = gui.MouseX();
			local mouseY = gui.MouseY();
			
			for k2, v2 in pairs(v.text) do
				local textColor = Color(v2.color.r, v2.color.g, v2.color.b, alpha);
				local newLine = false;
				
				if (mouseX > messageX and mouseY > messageY
				and mouseX < messageX + v2.width
				and mouseY < messageY + v2.height) then
					if (v2.OnHover) then
						onHoverData = v2;
					end;
				end;
				
				Clockwork:DrawSimpleText(v2.text, messageX, messageY, textColor);
				messageX = messageX + v2.width;
				
				if (origY - y > box.height) then
					box.height = origY - y;
				end;
				
				if (messageX - 8 > box.width) then
					box.width = messageX - 8;
				end;
				
				if (v2.newLine) then
					messageY = messageY + infoBoxSpacing + v.spacing;
					messageX = origX;
				end;
			end;
		end;
	Clockwork:OverrideMainFont(false);

	if (onHoverData) then
		onHoverData.OnHover(onHoverData);
	end;
end;

-- A function to add a message to the chat box.
function Clockwork.infoBox:Add(filtered, icon, ...)
	if (ScrW() == 160 or ScrH() == 27) then
		return;
	end;
	
	if (!filtered) then
		local maximumLines = math.Clamp(CW_CONVAR_MAXCHATLINES:GetInt(), 1, 10);
		local colorWhite = Clockwork.option:GetColor("white");
		local curTime = UnPredictedCurTime();
		local message = {
			timeFinish = curTime + 11,
			timeStart = curTime,
			timeFade = curTime + 10,
			spacing = 0,
			alpha = 255,
			lines = 1,
			icon = icon
		};
		
		local currentOnHover = nil;
		local currentColor = nil;
		local text = {...};
		
		//if (CW_CONVAR_SHOWTIMESTAMPS:GetInt() == 1) then
			local timeInfo = "["..os.date("%M:%S").."] ";
			local color = Color(150, 150, 150, 255);
			
			if (CW_CONVAR_TWELVEHOURCLOCK:GetInt() == 1) then
				timeInfo = "["..string.lower(os.date("%M:%S%p")).."] ";
			end;
			
			if (text) then
				table.insert(text, 1, color);
				table.insert(text, 2, timeInfo);
			else
				text = {timeInfo, color};
			end;
		//end;
		
		if (text) then
			message.currentWidth = 0;
			message.text = {};
			
			for k, v in ipairs(text) do
				if (type(v) == "string" or type(v) == "number" or type(v) == "boolean") then
					Clockwork.infoBox:WrappedText(
						nil, message, currentColor or colorWhite, tostring(v), currentOnHover
					);
					currentColor = nil;
					currentOnHover = nil;
				elseif (type(v) == "function") then
					currentOnHover = v;
				elseif (type(v) == "Player") then
					Clockwork.infoBox:WrappedText(
						nil, message, _team.GetColor(v:Team()), v:Name(), currentOnHover
					);
					currentColor = nil;
					currentOnHover = nil;
				elseif (type(v) == "table") then
					currentColor = Color(v.r or 255, v.g or 255, v.b or 255);
				end;
			end;
		end;
		
		if (self.historyPosition == #self.historyMessages) then
			self.historyPosition = #self.historyMessages + 1;
		end;
		
		self.historyMessages[#self.historyMessages + 1] = message;
		
		if (#self.messages == maximumLines) then
			table.remove(self.messages, maximumLines);
		end;
		
		table.insert(self.messages, 1, message);
		surface.PlaySound("common/talk.wav");
		surface.PlaySound("common/talk.wav");
		Clockwork:PrintColoredText(...);
	end;
end;

hook.Add("Think", "Clockwork.infoBox:Think", function()
	local curTime = UnPredictedCurTime();
	
	for k, v in ipairs(Clockwork.infoBox.messages) do
		if (curTime >= v.timeFade) then
			local fadeTime = v.timeFinish - v.timeFade;
			local timeLeft = v.timeFinish - curTime;
			local alpha = math.Clamp((255 / fadeTime) * timeLeft, 0, 255);
			
			if (alpha == 0) then
				table.remove(Clockwork.infoBox.messages, k);
			else
				v.alpha = alpha;
			end;
		end;
	end;
end);