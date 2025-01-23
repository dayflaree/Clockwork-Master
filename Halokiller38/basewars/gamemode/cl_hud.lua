/*
	Property of Spencer Sharkey & Jake Wall
	Copyright 2012 ~ Do Not Distribute!
*/

surface.CreateFont("Arial", 22, 700, true, false, "rpHurtFont");
surface.CreateFont("Arial", 24, 700, true, false, "rpButtonFont");

RP.hud = {};
RP.hud.minNotify = 0;
RP.hud.maxNotify = 0;
RP.hud.maxNotifyY = 0;
RP.hud.unread = 0;
//Called when the HUD should be drawn
function RP:DrawHUD()
	if (!LocalPlayer():Alive()) then
		draw.SimpleTextOutlined("You are dead.", "rpButtonFont", ScrW()/2, (ScrH()/2)-24, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, Color(0, 0, 0, 255));
		draw.SimpleTextOutlined("Click to Respawn", "rpButtonFont", ScrW()/2, (ScrH()/2)+24, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, Color(0, 0, 0, 255));
		return;
	end;
	
	if (self.hud.numbers) then
		for k, numObj in pairs(self.hud.numbers) do
			numObj.delta = (SysTime() - numObj.startTime)/(numObj.endTime - numObj.startTime);
			numObj.alpha = 255 - (numObj.delta*255);
			numObj.yPos = numObj.delta*150;
			numObj.xPos = numObj.xPos + (math.sin(SysTime()) * 0.15);
			
			draw.SimpleTextOutlined(numObj.text, "rpHurtFont", numObj.xPos, numObj.yPos, self:ModAlpha(numObj.color, numObj.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, self:ModAlpha(Color(0, 0, 0), numObj.alpha));
			if (SysTime() > numObj.endTime) then
				self.hud.numbers[k] = nil;
			end;
		end;
	end;
	
	surface.SetDrawColor(0, 0, 0, 220);
	draw.RoundedBoxEx(4, 0, 0, 229, 25, Color(0, 0, 0, 220), false, false, false, true)
	for i=1, 25 do
		local currentX = ((i*9)-9)+2;
		draw.RoundedBox(4, currentX, 1, 8, 22, Color(100, 100, 100));
	end;
	
	for i=1, math.floor(math.Clamp(LocalPlayer():Health(), 0, 100)/4) do
		local currentX = ((i*9)-9)+2;
		draw.RoundedBox(4, currentX, 1, 8, 22, Color(190, 50, 75));
	end;

	for i=1, math.floor(math.Clamp(LocalPlayer():Armor(), 0, 100)/4) do
		local currentX = ((i*9)-9)+2;
		draw.RoundedBoxEx(4, currentX, 1, 8, 11, Color(0, 242, 255, 255), true, true, true, true);
	end;	
	
	if (self.hud.barFades) then
		for k, barObj in pairs(self.hud.barFades) do
			barObj.delta = (SysTime() - barObj.startTime)/(barObj.endTime - barObj.startTime);
			barObj.alpha = 255 - (barObj.delta*255);
			for i=barObj.startBar, barObj.endBar do
				local currentX = ((i*9)-9)+2;
				draw.RoundedBox(4, currentX, 1, 8, 22, Color(255, 225, 225, barObj.alpha));
			end;
			if (SysTime() > barObj.endTime) then
				self.hud.barFades[k] = nil;
			end;
		end;
	end;
	
	//Do everything else not related to health
	local useX = 229+4;
	local font = "UiBold";
	local tY = 5;
	
		//Moneh
		surface.SetFont(font);
		local mW, mH = surface.GetTextSize("$"..AddComma(MyMoney));
		
		draw.RoundedBoxEx(4, useX, 0, mW+8, 25, Color(0, 0, 0, 220), false, false, true, true)
		draw.SimpleText("$"..AddComma(MyMoney), font, useX+4, tY, Color(255, 255, 255, 255));
		
		useX = useX+(mW+8)+4;
		
	
		//Ok, time to do notifications.
		if (#HUDNotesm > 0) then
			local lastN = table.GetFirstValue(HUDNotesm);
			local mW, mH = surface.GetTextSize(lastN.text);
			
			if (!lastN.unread) then
				lastN.unread = true;
				self.hud.unread = self.hud.unread + 1;
				lastN.recv = SysTime();
			end;
			
			local textcolor = Color(0,250,0,255)
			if lastN.type==1 then
				textcolor = Color(250,0,0,255)
			elseif lastN.type==2 then
				textcolor = Color(0,200,0,255)
			elseif lastN.type==3 then
				textcolor = Color(250,250,0,255)
			elseif lastN.type==4 then
				textcolor = Color(250,0,0,255)
			end
			self.hud.minNotify = useX;
			
			local boxColor = Color(200, 0, 0);
			if (self.hud.unread == 0) then
				boxColor = Color(160, 160, 160);
			end;
			
			draw.RoundedBoxEx(4, useX, 0, mW+8+20+4, 25, Color(0, 0, 0, 220), false, false, true, true);
			
			if ((SysTime() - lastN.recv) <= 1.5) then
				local alpha = 255-((SysTime() - lastN.recv)*(255/1.5));
				draw.RoundedBoxEx(4, useX, 0, mW+8+20+4, 25, Color(255, 255, 0, alpha), false, false, true, true);
			end;
			
			draw.RoundedBox(4, useX+4, 4, 16, 16, boxColor);
			
			local unreadText = tostring(math.Clamp(self.hud.unread, 0, 99));
			if (self.hud.unread >= 100) then
				unreadText = unreadText.."+";
			end;
			
			draw.SimpleText(unreadText, font, useX+12, 11, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			draw.SimpleText(lastN.text, font, useX+24, tY, textcolor);
			useX = useX+(mW+20)+4;
			self.hud.maxNotify = useX;
		end;
		
		local max = math.max(10, #HUDNotesm);
				
		self.hud.maxNotifyY = 22;
	
		if (self.hud.notifyBar) then
			self.hud.unread = 0;
			nW, nH = surface.GetTextSize("W");
			draw.RoundedBox(4, self.hud.minNotify, 28, 350, (max)*(nH+4), Color(0, 0, 0, 150));
			local i = 0;
			for k, v in pairs(HUDNotesm) do
				i = i + 1;
				if (i > 10) then
					break;
				end;
				
				local textBlot = v;
				
				local textcolor = Color(0,250,0,255)
				if textBlot.type==1 then
					textcolor = Color(250,0,0,255)
				elseif textBlot.type==2 then
					textcolor = Color(0,200,0,255)
				elseif textBlot.type==3 then
					textcolor = Color(250,250,0,255)
				elseif textBlot.type==4 then
					textcolor = Color(250,0,0,255)
				end
				
				local timeDiffText = "["..TimeDiff(textBlot.recv).."]";
				timeW, timeH = surface.GetTextSize(timeDiffText);
				draw.SimpleText(timeDiffText, font, self.hud.minNotify + 4, 22 + (i)*(nH+4) - nH+4, Color(200, 200, 200));
				
				draw.SimpleText(textBlot.text, font, self.hud.minNotify + 4 + timeW + 4, 22 + (i)*(nH+4) - nH+4, textcolor);
			end;
			
			self.hud.maxNotifyY = 22 + (max)*(nH+4);
			self.hud.maxNotify = useX + 350;
		end;
		
		while (#HUDNotesm > 10) do
			table.remove(HUDNotesm, 10)
		end;	
end;

function RP:ThinkHUD()
	if (self.hud.previousDamage) then
		if (self.hud.previousDamage > LocalPlayer():Health()) then
			self.hud:AddHealthNumber("-"..math.Clamp(self.hud.previousDamage-LocalPlayer():Health(), 0, 100), self.hud.previousDamage);
		elseif (self.hud.previousDamage < LocalPlayer():Health()) then
			self.hud:AddHealthNumber("+"..math.Clamp(LocalPlayer():Health()-self.hud.previousDamage, 0, 100), self.hud.previousDamage);
		end;
	end;
	self.hud.previousDamage = LocalPlayer():Health();
	
	if (self.hud.previousArmor) then
		if (self.hud.previousArmor > LocalPlayer():Armor()) then
			self.hud:AddHealthNumber("-"..math.Clamp(self.hud.previousArmor-LocalPlayer():Armor(), 0, 100), self.hud.previousArmor, Color(100, 0, 83));
		elseif (self.hud.previousArmor < LocalPlayer():Armor()) then
			self.hud:AddHealthNumber("+"..math.Clamp(LocalPlayer():Armor()-self.hud.previousArmor, 0, 100), self.hud.previousArmor, Color(100, 143, 212));
		end;
	end;
	self.hud.previousArmor = LocalPlayer():Armor();
	
	//Mouse Crap
	local mX, mY = gui.MousePos();
	if (mX == 0 or mY == 0) then
		self.hud.notifyBar = false;
		return;
	end;
	
	if (!mX or !mY) then
		self.hud.notifyBar = false;
		return;
	end;
	
	if (mX >= self.hud.minNotify and mX <= self.hud.maxNotify and mY <= self.hud.maxNotifyY) then
		self.hud.notifyBar = true;
	else
		self.hud.notifyBar = false;
	end;
end;

function RP.hud:AddHealthNumber(number, prevHealth, color)
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
	
	local numBars = math.floor(math.Clamp(LocalPlayer():Health(), 0, 100)/4);
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
	
	if (LocalPlayer():Armor() > 0) then
		local numBars = math.floor(math.Clamp(LocalPlayer():Armor(), 0, 100)/4);
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

//Screenspace effects
hook.Add("RenderScreenspaceEffects", "RPScreenSpace", function()
	
	-- if (type(RP.Client.NextSpawn) == "number" and CurTime() <= RP.Client.NextSpawn) then
	
		-- local difference = RP.Client.NextSpawn - CurTime();

		-- local tab = {};
			-- tab["$pp_colour_addr"] = difference/550;
			-- tab["$pp_colour_addg"] = difference/550;
			-- tab["$pp_colour_addb"] = difference/550;
			-- tab["$pp_colour_brightness"] = difference/550;
			-- tab["$pp_colour_contrast"] = difference/1;
			-- tab["$pp_colour_colour"] = 0;
			-- tab["$pp_colour_mulr"] = 1;
			-- tab["$pp_colour_mulg"] = 1;
			-- tab["$pp_colour_mulb"] = 1;
	 
		-- DrawColorModify( tab );
	-- end;
 
    -- DrawBloom( 0, 0.75, 3, 3, 2, 3, 255, 255, 255 );
    -- DrawMaterialOverlay( "effects/combine_binocoverlay.vmt", 0.1 );
    -- DrawMotionBlur( 0.1, 0.79, 0.05 );
    -- DrawSharpen( 1.991, 5 );
    -- DrawSunbeams( 0.5 , 2, 5, 0, 0 );
	
end);

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

hook.Add("HUDPaint", "bwHudPaint", function()
	RP:DrawHUD();
end);

hook.Add("Think", "bwThink", function()
	RP:ThinkHUD();
end);
	
//Base SharkeyRP Methods
function RP:ModAlpha(color, alpha)
	local r = color.r;
	local g = color.g;
	local b = color.b;
	local a = math.Clamp(alpha, 0, 255);
	return Color(r, g, b, a);
end;	