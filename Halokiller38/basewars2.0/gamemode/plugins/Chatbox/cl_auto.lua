--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

local PLUGIN = PLUGIN;

surface.CreateFont("Arial", 18, 700, true, false, "rpChatFont");
//This is a very ugly file. I'll fix it

RP.chatbox = {};
RP.chatbox.history = {};

function PLUGIN:Init()
	RP.chatbox:CreateChatbox();
end;

function RP.chatbox:AddLine(text, icon, sound)
	if (type(text) == "string") then
		text = {Color(255, 255, 255), text};
	end;

	local fadeinObj = {
		startTime = SysTime(),
		endTime = SysTime() + 0.25,
		delta = 0,
		finished = false,
		xAdd = ScrW()
	}
	
	/* Do text-wrapping hack here... :( */
	local splitPart = 0;
	local length = 0;
	for k, v in pairs(text) do
		if (type(v) == "string") then
			length = length + self:TextWidth(v);
			if (length >= 800) then
				splitPart = k;
				break;
			end;
		end;
	end;
	
	local firstLineText = {};
	local secondLineText = nil;
	
	if (splitPart > 0) then //Oh by we get to word-wrap now :D
	
		local length = length - self:TextWidth(text[splitPart]);
		local splitChar = 0;
		for k, v in pairs(string.ToTable(text[splitPart])) do
			if (type(v) == "string") then
				length = length + self:TextWidth(v);
				if (length >= 800) then
					splitChar = k;
					break;
				end;
			end;
		end;
		
		local firstLineAdd = string.sub(text[splitPart], 1, splitChar);
		local secondLineAdd = string.sub(text[splitPart], splitChar);
		
		local lastColor = Color(255, 255, 255);
		for k, v in pairs(text) do
			if (k < splitPart) then
				firstLineText[k] = v;
				if (type(v) == "table") then
					lastColor = v;
				end;
			elseif (k > splitPart) then
				secondLineText[k] = v;
			end;
		end;
		secondLineText = {};
		table.insert(firstLineText, firstLineAdd);
		table.insert(secondLineText, 1, secondLineAdd);
		table.insert(secondLineText, 1, lastColor);
		text = nil;
	end;
	
	if (text != nil) then
		firstLineText = text;
	end;
	
	local firstLine = {
		data = firstLineText,
		color = Color(255, 255, 0),
		icon = icon or nil,
		fadeinData = fadeinObj,
		alpha = 0,
		time = SysTime() + 10,
		sound = sound
	}
	table.insert(self.history, 1, firstLine);
	
	if (secondLineText) then
		local secondLine = {
			data = secondLineText,
			color = Color(255, 255, 0),
			icon = nil,
			fadeinData = fadeinObj,
			alpha = 0,
			time = SysTime() + 10,
			isMultiLine = true;
		}
		table.insert(self.history, 1, secondLine);
	end;
end;

function RP.chatbox:BuildString(data)
	local text = "";
	text = table.concat(data, "");
	return text;
end;

function RP.chatbox:TextWidth(text)
	surface.SetFont("rpChatFont");
	local w, h = surface.GetTextSize(text);
	return w+2;
end;

function RP.chatbox:TextHeight(text)
	surface.SetFont("rpChatFont");
	local w, h = surface.GetTextSize(text);
	return h+2;
end;

//HUDPaint Hook
local gradientUp = surface.GetTextureID("VGUI/gradient_up");
RP.chatbox.height = RP.chatbox:TextHeight("W")*10;
local quadObj = {
	texture = gradientUp,
	color = Color(0, 0, 0, 200),
	x = 0,
	y = ScrH()-RP.chatbox.height,
	w = ScrW(),
	h = RP.chatbox.height+25
};


function PLUGIN:HUDPaint()
	local self = RP.chatbox;
	local chatboxHeight = self.height;
	
	if (self.isOpen) then
		//draw.TexturedQuad(quadObj);
	end;
	
	local x, y = 22, ScrH()-25-20-(self:TextHeight("W"));
	for k, v in pairs(self.history) do
		if (!v.fadeinData.finished) then
			v.fadeinData.delta = (SysTime() - v.fadeinData.startTime)/0.25;
			v.alpha = v.fadeinData.delta * 255;
			v.xAdd = math.Clamp(ScrW()/4 - (v.fadeinData.delta * (ScrW()/4)), 0, ScrW());
		end;
		
		if (SysTime() > v.fadeinData.endTime and !v.fadeinData.finished) then 
			v.fadeinData.finished = true;
			if (v.sound) then
				surface.PlaySound(v.sound)
			else
				chat.PlaySound();
			end;
		end;
	
		if (self.isOpen or k < 10) then
			local alpha;
			if (self.isOpen) then alpha = 255 else alpha = v.alpha end;

			local backY, backH = y, 18;
			
			local setColor = Color(255, 255, 255);
			if (v.isMultiLine) then
				backY, backH = y-1, 20;
			end;
			
			surface.SetTexture(gradientUp);
			surface.SetDrawColor(0, 0, 0, math.Clamp(alpha, 0, 200));
			surface.DrawTexturedRectRotated(200, backY+9, backH, 800, 270);
			
			if (v.icon) then
				local iconObj = {
					texture = surface.GetTextureID(v.icon),
					color = Color(255, 255, 255, alpha),
					x = 3+v.xAdd,
					y = y+1,
					w = 16,
					h = 16
				};
				draw.TexturedQuad(iconObj);
			end;
			
			local lastX = 0;			
			for _, lineStep in pairs(v.data) do
				
				if (type(lineStep) == "string") then
				
					local textWidth = self:TextWidth("W");
					draw.SimpleTextOutlined(lineStep, "rpChatFont", x+lastX+v.xAdd, y, RP:ModAlpha(setColor, alpha), 0, 0, 1, Color(0, 0, 0, alpha));
					lastX = lastX + self:TextWidth(lineStep)
					
				elseif (type(lineStep) == "table") then
					setColor = lineStep;
				end;
				
			end;
			y = y - self:TextHeight("W");
		end;
		
		if (SysTime() > v.time) then
			if (!v.fadeoutData) then
				v.fadeoutData = {
					startTime = SysTime(),
					endTime = SysTime() + 3,
					delta = 0,
					finished = false
				}
			end;
			if (!v.fadeoutData.finished) then
				v.fadeoutData.delta = (SysTime() - v.fadeoutData.startTime)/3;
				v.alpha = (255 - (v.fadeoutData.delta * 255))
			end;
		end;
		if (k > 10) then
			table.remove(self.history, k);
		end;
	end;
end;


function RP.chatbox:CreateChatbox()
	self.inputBox = vgui.Create("EditablePanel");
	self.inputBox:SetPos(10, ScrH()-self.inputBox:GetTall()-10);
	self.inputBox:SetSize(800, 30);
	self.inputBox:SetKeyBoardInputEnabled(false);
	self.inputBox:SetMouseInputEnabled(false);
	self.inputBox:SetVisible(false);
	self.inputBox:MakePopup();
	
	self.inputBox.textInput = vgui.Create("DTextEntry", self.inputBox);
	self.inputBox.textInput:SetWide(800);
	self.inputBox.textInput:SetPos(0, 0);
	self.inputBox.textInput:RequestFocus();
	
	
	-- A function to set the text entry's real value.
	self.inputBox.textInput.SetRealValue = function(textEntry, text, limit)
		textEntry:SetValue(text);
		
		if (limit) then
			if ( textEntry:GetCaretPos() > string.len(text) ) then
				textEntry:SetCaretPos( string.len(text) );
			end;
		else
			textEntry:SetCaretPos( string.len(text) );
		end;
	end;
	
	self.inputBox.ShowBox = function(editablePanel)
		self.isOpen = true;
		editablePanel:SetKeyBoardInputEnabled(true);
		editablePanel:SetMouseInputEnabled(true);
		editablePanel:SetVisible(true);
		editablePanel.textInput:SetRealValue("");
		editablePanel.textInput:RequestFocus();
	end;
	
	
	
	self.inputBox.HideBox = function(editablePanel)
		self.isOpen = false;
		editablePanel:SetKeyBoardInputEnabled(false);
		editablePanel:SetMouseInputEnabled(false);
		editablePanel:SetVisible(false);
		editablePanel.textInput:SetRealValue("");
	end;
	
	self.inputBox.textInput.OnEnter = function()
		local text = self.inputBox.textInput:GetValue();
			
		if (text and text != "") then	
			local replaceText = text;
			if (self.printTeam) then
				RunConsoleCommand("say_team", replaceText);
			else
				RunConsoleCommand("say", replaceText);
			end;
		end;

		self.inputBox:HideBox();
	end;
	
	self.inputBox.textInput.OnKeyCodeTyped = function(textEntry, code)
		if ( code == KEY_ENTER and !textEntry:IsMultiline() and textEntry:GetEnterAllowed() ) then
			textEntry:FocusNext();
			textEntry:OnEnter();
		end;
	end;
	
end;
	
hook.Add("PlayerBindPress", "OpenChatbox", function(player, bind, press)
	if ( ( string.find(bind, "messagemode") or string.find(bind, "messagemode2") ) and press ) then
		if (string.find(bind, "messagemode2")) then
			RP.chatbox.printTeam = true;
		else
			RP.chatbox.printTeam = false;
		end;
		RP.chatbox.inputBox:ShowBox();
		return true;
	end;
end);