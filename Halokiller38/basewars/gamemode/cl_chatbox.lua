surface.CreateFont("Arial", 18, 700, true, false, "chatFont1");
RP.chatbox = {};
RP.chatbox.history = {};

function chat.AddText(...)
	local chatTable = {...};
	local icon = nil;
	

	if (type(chatTable[1]) == "Player") then
		//Standard Chat Message
		
		local player = chatTable[1];
		
		local factionPrefix = "<";
		if (player:GetNWBool("FactionLeader")) then
			factionPrefix = "<*";
		end;
		
		local chatStruct = {
			Color(255, 255, 255),
			factionPrefix,
			Color(175, 175, 175),
			team.GetName(player:Team()),
			Color(255, 255, 255),
			">",
			team.GetColor(player:Team()),
			player:Name(),
			Color(255, 255, 255),
			chatTable[3]
		};
		chatTable = chatStruct;
		
		if (player:IsAdmin()) then
			icon = "gui/silkicons/star";
		end;
		if (player:IsSuperAdmin()) then
			icon = "gui/silkicons/shield";
		end;
	end;
	
	RP.chatbox:AddLine(chatTable, icon, nil);
end;

usermessage.Hook("messageAdd", function(data)
	local icon = "gui/silkicons/wrench";
	local color = Color(150, 205, 255);
	local text = data:ReadString();
	if (string.sub(text, -1) == "!") then
		icon = "gui/silkicons/exclamation";
		color = Color(255, 140, 140);
	end;

	RP.chatbox:AddLine({color, text}, icon, "npc/turret_floor/ping.wav")
end);

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
	surface.SetFont("chatFont1");
	local w, h = surface.GetTextSize(text);
	return w+2;
end;

function RP.chatbox:TextHeight(text)
	surface.SetFont("chatFont1");
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
hook.Add("HUDPaint", "ChatPaint", function()
	local self = RP.chatbox;
	local chatboxHeight = self.height;
	
	if (self.isOpen) then
		//draw.TexturedQuad(quadObj);
	end;
	
	local x, y = 22, ScrH()-25-(self:TextHeight("W"));
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
					draw.SimpleTextOutlined(lineStep, "chatFont1", x+lastX+v.xAdd, y, RP:ModAlpha(setColor, alpha), 0, 0, 1, Color(0, 0, 0, alpha));
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
end);

hook.Add("StartChat", "ChatStart", function()
	local self = RP.chatbox;
	self.isOpen = true;
	self.inputBox = vgui.Create("DTextEntry");
	self.inputBox:SetWide(800);
	self.inputBox:SetValue("");
	self.inputBox:SetCursorColor(Color(0, 0, 0, 255))
	self.inputBox:SetPos(2, ScrH()-self.inputBox:GetTall()-2);
	self.inputBox:RequestFocus();
	return true;
end);

hook.Add("FinishChat", "ChatStop", function()
	local self = RP.chatbox;
	self.isOpen = false;
	if (self.inputBox) then
		self.inputBox:Remove();
	end;
end);

hook.Add("ChatTextChanged", "ChatModify", function(text)
	local self = RP.chatbox;
	self.inputBox:SetText(text);
end);
	
//Base SharkeyRP Methods
function RP:ModAlpha(color, alpha)
	local r = color.r;
	local g = color.g;
	local b = color.b;
	local a = math.Clamp(alpha, 0, 255);
	return Color(r, g, b, a);
end;	