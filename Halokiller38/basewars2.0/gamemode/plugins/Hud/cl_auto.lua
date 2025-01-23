--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

local PLUGIN = PLUGIN;

surface.CreateFont("Arial", 22, 700, true, false, "rpHurtFont");
surface.CreateFont("Arial", 24, 700, true, false, "rpButtonFont");

RP.Hud = {};
RP.Hud.minNotify = 0;
RP.Hud.maxNotify = 0;
RP.Hud.maxNotifyY = 0;
RP.Hud.unread = 0;
RP.Hud.cashFalls = {};

PLUGIN.playerIcon = surface.GetTextureID("gui/silkicons/user");
PLUGIN.adminIcon = surface.GetTextureID("gui/silkicons/shield");
-- PLUGIN.gradient = surface.GetTextureID("gui/center_gradient");
surface.CreateFont("Arial", 16, 600, true, false, "nameText", false, false, 0);

function PLUGIN:DrawPlayerNames()
	for _,ply in pairs(player.GetAll()) do
		if (ply != LocalPlayer() and ply:Alive() and ply:GetMoveType() != MOVETYPE_NOCLIP) then
			local icon = self.playerIcon;
			local plyPos = ply:EyePos() + Vector(0, 0, 16);
			local pos = plyPos:ToScreen();
			local alpha = 255 - 255 * math.TimeFraction(0, 512, plyPos:Distance(LocalPlayer():EyePos()));
			local colour = Color(150, 150, 150, alpha * 0.6);
			local outline = Color(10, 10, 10, alpha * 0.8);
			local text = ply:GetName();
			
			if (pos.visible) then
				local shouldDisplay = false;
				
				local traceData = {
					start = plyPos,
					endpos = LocalPlayer():EyePos(),
					filter = {ply, LocalPlayer()}
				};
				local trace = util.TraceLine(traceData);
				
				if (!trace.Hit) then
					shouldDisplay = true;
				end;
				
				if (RP.party and RP.party.curParty and table.HasValue(RP.party.curParty, ply)) then
					local mul = math.TimeFraction(0, 100, ply:Health());
					
					colour = Color(150 - 150 * mul, 150 * mul, 0, alpha * 0.6);
					outline = Color(40, 40, 40, alpha * 0.8);
					
					shouldDisplay = true;
				end;
				
				if (shouldDisplay) then
					surface.SetFont("nameText");
					local textWidth, textHeight = surface.GetTextSize(text);
					
					if (ply:IsSuperAdmin()) then
						icon = self.adminIcon;
					end;
					
					local width = textWidth + 28;
					local height = textHeight + 8;
					local drawPos = {x = pos.x - width / 2, y = pos.y};
					
					draw.RoundedBox(4, drawPos.x, drawPos.y, width, height, outline)
					draw.RoundedBox(4, drawPos.x + 2, drawPos.y + 2, width - 4, height - 4, colour);
					
					-- surface.SetDrawColor(colour);
					-- surface.SetTexture(self.gradient);
					-- surface.DrawTexturedRect(drawPos.x + 2, drawPos.y + 2, width - 4, height - 4);
					
					surface.SetDrawColor(255, 255, 255, alpha);
					surface.SetTexture(icon);
					surface.DrawTexturedRect(drawPos.x + 4, drawPos.y + 4, 16, 16);
					
					RP.menu:DrawSimpleText(text, "nameText", drawPos.x + 24, drawPos.y + 4, Color(255, 255, 255, alpha), 0, 0, false);
				end;
			end;
		end;
	end;
end;

function PLUGIN:DrawEntityInfo()
	local trace = LocalPlayer():GetEyeTraceNoCursor();
	local entity = trace.Entity;
	
	if (ValidEntity(entity)) then
		
	end;
end;

PLUGIN.crosshairAngle = 120; -- Degrees
PLUGIN.crosshairMul = 0;
function PLUGIN:DrawCrosshair()
	if (LocalPlayer():Alive()) then
		local weapon = LocalPlayer():GetActiveWeapon();
		
		if (IsValid(weapon)) then
			if (string.find(weapon:GetClass(), "weapon_mad")) then
				return;
			end;
			
			local activity = weapon:GetActivity();
			local origin = LocalPlayer():GetEyeTraceNoCursor().HitPos:ToScreen();
			local distance = 15;
			
			if (activity and activity == ACT_VM_RELOAD) then
				self.crosshairMul = self.crosshairMul + FrameTime() * 150;
				if (self.crosshairMul >= 120) then
					self.crosshairMul = 0;
				end;
			else
				self.crosshairMul = math.Approach(self.crosshairMul, 120, FrameTime() * 150);
			end;
			
			for i = self.crosshairAngle / 2, 360 - self.crosshairAngle / 2, self.crosshairAngle do
				local addX = math.sin(math.rad(i + self.crosshairMul)) * distance;
				local addY = math.cos(math.rad(i + self.crosshairMul)) * distance;
				
				surface.SetDrawColor(0, 0, 0, 255);
				surface.DrawRect(origin.x + addX - 3, origin.y + addY - 3, 6, 6);
				surface.SetDrawColor(255, 255, 255, 255);
				surface.DrawRect(origin.x + addX - 2, origin.y + addY - 2, 4, 4);
			end;
		end;
	end;
end;

function RP.Hud:AddCashFall(amount)
	if (amount < 0) then
		table.insert(self.cashFalls, {colour = Color(150, 50, 50, 255), addX = math.random(0, 20), addY = math.random(80, 120), amount = amount, createTime = CurTime(), endTime = CurTime() + 3});
	else
		table.insert(self.cashFalls, {colour = Color(50, 150, 50, 255), addX = math.random(0, 20), addY = math.random(80, 120), amount = amount, createTime = CurTime(), endTime = CurTime() + 3});
	end;
end;

-- Called to check if a HUD element should be drawn or not
function PLUGIN:HUDShouldDraw(name)
	local blockedElements = {
		"CHudVoiceStatus",
		"CHudSuitPower",
		"CHudBattery",
		"CHudHealth"
	};
	if (table.HasValue(blockedElements, name)) then
		return false;
	end;
	return true;
end;

//Called when the HUD should be drawn
function PLUGIN:HUDPaint()
	if (!RP.Client:Alive()) then
		draw.SimpleTextOutlined("You are dead.", "rpButtonFont", ScrW()/2, (ScrH()/2)-24, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, Color(0, 0, 0, 255));
		draw.SimpleTextOutlined("Click to Respawn", "rpButtonFont", ScrW()/2, (ScrH()/2)+24, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, Color(0, 0, 0, 255));
		return;
	end;
	
	self:DrawPlayerNames();
	
	self:DrawCrosshair();
	
	if (RP.Hud.numbers) then
		for k, numObj in pairs(RP.Hud.numbers) do
			numObj.delta = (SysTime() - numObj.startTime)/(numObj.endTime - numObj.startTime);
			numObj.alpha = 255 - (numObj.delta*255);
			numObj.yPos = numObj.delta*150;
			numObj.xPos = numObj.xPos + (math.sin(SysTime()) * 0.15);
			
			draw.SimpleTextOutlined(numObj.text, "rpHurtFont", numObj.xPos, numObj.yPos, RP:ModAlpha(numObj.color, numObj.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, RP:ModAlpha(Color(0, 0, 0), numObj.alpha));
			if (SysTime() > numObj.endTime) then
				RP.Hud.numbers[k] = nil;
			end;
		end;
	end;
	
	surface.SetDrawColor(0, 0, 0, 220);
	draw.RoundedBoxEx(4, 0, 0, 229, 25, Color(0, 0, 0, 220), false, false, false, true)
	for i=1, 25 do
		local currentX = ((i*9)-9)+2;
		draw.RoundedBox(4, currentX, 1, 8, 22, Color(100, 100, 100));
	end;
	
	for i=1, math.floor(math.Clamp(RP.Client:Health(), 0, 100)/4) do
		local currentX = ((i*9)-9)+2;
		draw.RoundedBox(4, currentX, 1, 8, 22, Color(190, 50, 75));
	end;

	for i=1, math.floor(math.Clamp(RP.Client:Armor(), 0, 100)/4) do
		local currentX = ((i*9)-9)+2;
		draw.RoundedBoxEx(4, currentX, 1, 8, 11, Color(0, 242, 255, 255), true, true, true, true);
	end;	
	
	if (RP.Hud.barFades) then
		for k, barObj in pairs(RP.Hud.barFades) do
			barObj.delta = (SysTime() - barObj.startTime)/(barObj.endTime - barObj.startTime);
			barObj.alpha = 255 - (barObj.delta*255);
			for i=barObj.startBar, barObj.endBar do
				local currentX = ((i*9)-9)+2;
				draw.RoundedBox(4, currentX, 1, 8, 22, Color(255, 225, 225, barObj.alpha));
			end;
			if (SysTime() > barObj.endTime) then
				RP.Hud.barFades[k] = nil;
			end;
		end;
	end;
	
	//Do everything else not related to health
	local useX = 229+4;
	local font = "UiBold";
	local tY = 5;
	
		//Moneh
		surface.SetFont(font);
		local mW, mH = surface.GetTextSize("Shards: "..AddComma(RP.Client:GetCash()));
		
		draw.RoundedBoxEx(4, useX, 0, mW+8, 25, Color(0, 0, 0, 220), false, false, true, true)
		draw.SimpleText("Shards: "..AddComma(RP.Client:GetCash()), font, useX+4, tY, Color(255, 255, 255, 255));
		
		for k,v in ipairs(RP.Hud.cashFalls) do
			local mul = math.TimeFraction(v.createTime, v.endTime, CurTime());
			local colour = RP:ModAlpha(v.colour, 255 - 255 * mul);
			local yy = 10 + v.addY * mul * 2;
			local prefix = (v.amount > 0) and "+" or "-";
			
			draw.SimpleTextOutlined(prefix..v.amount.." shards", "rpHurtFont", useX + v.addX, yy, colour, 0, 0, 1, Color(0, 0, 0, colour.a));
			
			if (colour.a <= 0 or v.endTime <= CurTime()) then
				table.remove(RP.Hud.cashFalls, k);
			end;
		end;
		
		useX = useX+(mW+8)+4;
		
	
		-- //Ok, time to do notifications.
		-- if (#HUDNotesm > 0) then
			-- local lastN = table.GetFirstValue(HUDNotesm);
			-- local mW, mH = surface.GetTextSize(lastN.text);
			
			-- if (!lastN.unread) then
				-- lastN.unread = true;
				-- RP.Hud.unread = RP.Hud.unread + 1;
				-- lastN.recv = SysTime();
			-- end;
			
			-- local textcolor = Color(0,250,0,255)
			-- if lastN.type==1 then
				-- textcolor = Color(250,0,0,255)
			-- elseif lastN.type==2 then
				-- textcolor = Color(0,200,0,255)
			-- elseif lastN.type==3 then
				-- textcolor = Color(250,250,0,255)
			-- elseif lastN.type==4 then
				-- textcolor = Color(250,0,0,255)
			-- end
			-- RP.Hud.minNotify = useX;
			
			-- local boxColor = Color(200, 0, 0);
			-- if (RP.Hud.unread == 0) then
				-- boxColor = Color(160, 160, 160);
			-- end;
			
			-- draw.RoundedBoxEx(4, useX, 0, mW+8+20+4, 25, Color(0, 0, 0, 220), false, false, true, true);
			
			-- if ((SysTime() - lastN.recv) <= 1.5) then
				-- local alpha = 255-((SysTime() - lastN.recv)*(255/1.5));
				-- draw.RoundedBoxEx(4, useX, 0, mW+8+20+4, 25, Color(255, 255, 0, alpha), false, false, true, true);
			-- end;
			
			-- draw.RoundedBox(4, useX+4, 4, 16, 16, boxColor);
			
			-- local unreadText = tostring(math.Clamp(RP.Hud.unread, 0, 99));
			-- if (RP.Hud.unread >= 100) then
				-- unreadText = unreadText.."+";
			-- end;
			
			-- draw.SimpleText(unreadText, font, useX+12, 11, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			-- draw.SimpleText(lastN.text, font, useX+24, tY, textcolor);
			-- useX = useX+(mW+20)+4;
			-- RP.Hud.maxNotify = useX;
		-- end;
		
		-- local max = math.max(10, #HUDNotesm);
				
		-- RP.Hud.maxNotifyY = 22;
	
		-- if (RP.Hud.notifyBar) then
			-- RP.Hud.unread = 0;
			-- nW, nH = surface.GetTextSize("W");
			-- draw.RoundedBox(4, RP.Hud.minNotify, 28, 350, (max)*(nH+4), Color(0, 0, 0, 150));
			-- local i = 0;
			-- for k, v in pairs(HUDNotesm) do
				-- i = i + 1;
				-- if (i > 10) then
					-- break;
				-- end;
				
				-- local textBlot = v;
				
				-- local textcolor = Color(0,250,0,255)
				-- if textBlot.type==1 then
					-- textcolor = Color(250,0,0,255)
				-- elseif textBlot.type==2 then
					-- textcolor = Color(0,200,0,255)
				-- elseif textBlot.type==3 then
					-- textcolor = Color(250,250,0,255)
				-- elseif textBlot.type==4 then
					-- textcolor = Color(250,0,0,255)
				-- end
				
				-- local timeDiffText = "["..TimeDiff(textBlot.recv).."]";
				-- timeW, timeH = surface.GetTextSize(timeDiffText);
				-- draw.SimpleText(timeDiffText, font, RP.Hud.minNotify + 4, 22 + (i)*(nH+4) - nH+4, Color(200, 200, 200));
				
				-- draw.SimpleText(textBlot.text, font, RP.Hud.minNotify + 4 + timeW + 4, 22 + (i)*(nH+4) - nH+4, textcolor);
			-- end;
			
			-- RP.Hud.maxNotifyY = 22 + (max)*(nH+4);
			-- RP.Hud.maxNotify = useX + 350;
		-- end;
		
		-- while (#HUDNotesm > 10) do
			-- table.remove(HUDNotesm, 10)
		-- end;	
end;

function PLUGIN:Think()
	if (RP.Hud.previousDamage) then
		if (RP.Hud.previousDamage > RP.Client:Health()) then
			RP.Hud:AddHealthNumber("-"..math.Clamp(RP.Hud.previousDamage-RP.Client:Health(), 0, 100), RP.Hud.previousDamage);
		elseif (RP.Hud.previousDamage < RP.Client:Health()) then
			RP.Hud:AddHealthNumber("+"..math.Clamp(RP.Client:Health()-RP.Hud.previousDamage, 0, 100), RP.Hud.previousDamage);
		end;
	end;
	RP.Hud.previousDamage = RP.Client:Health();
	
	if (RP.Hud.previousArmor) then
		if (RP.Hud.previousArmor > RP.Client:Armor()) then
			RP.Hud:AddHealthNumber("-"..math.Clamp(RP.Hud.previousArmor-RP.Client:Armor(), 0, 100), RP.Hud.previousArmor, Color(100, 0, 83));
		elseif (RP.Hud.previousArmor < RP.Client:Armor()) then
			RP.Hud:AddHealthNumber("+"..math.Clamp(RP.Client:Armor()-RP.Hud.previousArmor, 0, 100), RP.Hud.previousArmor, Color(100, 143, 212));
		end;
	end;
	RP.Hud.previousArmor = RP.Client:Armor();
	
	//Mouse Crap
	local mX, mY = gui.MousePos();
	if (mX == 0 or mY == 0) then
		RP.Hud.notifyBar = false;
		return;
	end;
	
	if (!mX or !mY) then
		RP.Hud.notifyBar = false;
		return;
	end;
	
	if (mX >= RP.Hud.minNotify and mX <= RP.Hud.maxNotify and mY <= RP.Hud.maxNotifyY) then
		RP.Hud.notifyBar = true;
	else
		RP.Hud.notifyBar = false;
	end;
end;

function RP.Hud:AddHealthNumber(number, prevHealth, color)
	local numColor = Color(255, 255, 255);
	local id = string.sub(number, 1, 1);
	if (id == "-") then
		numColor = Color(150, 0, 0);
	elseif (id == "+") then
		numColor = Color(0, 150, 0);
	end;
	
	if (color) then
		numColor = color;
	end;
	
	if (!self.numbers) then
		self.numbers = {};
	end;
	
	local numObj = {
		//Text Stuff
		text = number,
		color = numColor,
		//Animation Stuff
		startTime = SysTime(),
		endTime = SysTime()+2,
		xPos = math.random(10, 230),
		yPos = 28,
		alpha = 255,
		delta = 0
	}
	
	table.insert(self.numbers, numObj);
	
	if (!self.barFades) then
		self.barFades = {};
	end;
	
	local numBars = math.floor(math.Clamp(RP.Client:Health(), 0, 100)/4);
	local prevBars = math.floor(math.Clamp(prevHealth, 0, 100)/4);
	
	local diffBars = prevBars - numBars;
	if (diffBars >= 0) then
		local startBar = numBars+1;
		local endBar = prevBars;
		
		local barObj = {
			startBar = startBar,
			endBar = endBar,
			//Animation Stuff
			startTime = SysTime(),
			endTime = SysTime()+1,
			alpha = 255,
			delta = 0
		}
		
		table.insert(self.barFades, barObj);		
	end;
	
	if (RP.Client:Armor() > 0) then
		local numBars = math.floor(math.Clamp(RP.Client:Armor(), 0, 100)/4);
		local prevBars = math.floor(math.Clamp(prevHealth, 0, 100)/4);
		
		local diffBars = prevBars - numBars;
		if (diffBars >= 0) then
			local startBar = numBars+1;
			local endBar = prevBars;
			
			local barObj = {
				startBar = startBar,
				endBar = endBar,
				//Animation Stuff
				startTime = SysTime(),
				endTime = SysTime()+1,
				alpha = 255,
				delta = 0
			}
			
			table.insert(self.barFades, barObj);		
		end;	
	end;
end;

--Drawing The Commas
function AddComma(n)
	local sn = tostring(n)
	sn = string.ToTable(sn)		
	local tab = {}
	for i=0,#sn-1 do

		if i%3 == #sn%3 and !(i==0) then
			table.insert(tab, ",")
		end
		table.insert(tab, sn[i+1])
	end
	return string.Implode("",tab)
end

--Shits
function TimeDiff(time)
	local retString = "";
	local secDiff = math.floor(SysTime() - time);
	local minDiff = 0;
	if (secDiff >= 60) then
		minDiff = math.floor(secDiff/60);
		retString = retString..math.floor(secDiff/60).." min";
		if (minDiff > 1) then
			retString = retString.."s";
		end;
		retString = retString.." ";
	end;
	
	local secDiff = secDiff - (minDiff*60);
	
	retString = retString..secDiff.." sec";
	
	return retString;
end;
