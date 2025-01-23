surface.CreateFont("Arial", 22, 700, true, false, "rpHurtFont");

RP.hud = {};
//Called when the HUD should be drawn
function RP:DrawHUD()
	if (RP.Client.NextSpawn and CurTime() <= RP.Client.NextSpawn) then 
		local timeLeft = RP.Client.NextSpawn - CurTime();
		
		draw.SimpleTextOutlined("You are dead.", "rpButtonFont", ScrW()/2, (ScrH()/2)-24, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, Color(0, 0, 0, 255));
		
		draw.SimpleTextOutlined("You will respawn in "..tostring(math.Round(timeLeft)).." seconds.", "rpButtonFont", ScrW()/2, (ScrH()/2)+24, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, Color(0, 0, 0, 255));
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
	
	for i=1, math.floor(math.Clamp(RP.Client:Health(), 0, 100)/4) do
		local currentX = ((i*9)-9)+2;
		draw.RoundedBox(4, currentX, 1, 8, 22, Color(190, 50, 75));
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
	
end;

function RP:ThinkHUD()
	if (self.hud.previousDamage) then
		if (self.hud.previousDamage > self.Client:Health()) then
			self.hud:AddHealthNumber("-"..math.Clamp(self.hud.previousDamage-self.Client:Health(), 0, 100), self.hud.previousDamage);
		elseif (self.hud.previousDamage < self.Client:Health()) then
			self.hud:AddHealthNumber("+"..math.Clamp(self.Client:Health()-self.hud.previousDamage, 0, 100), self.hud.previousDamage);
		end;
	end;
	self.hud.previousDamage = self.Client:Health();
end;

function RP.hud:AddHealthNumber(number, prevHealth)
	local numColor = Color(255, 255, 255);
	local id = string.sub(number, 1, 1);
	if (id == "-") then
		numColor = Color(150, 0, 0);
	elseif (id == "+") then
		numColor = Color(0, 150, 0);
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
end;

//Screenspace effects
hook.Add("RenderScreenspaceEffects", "RPScreenSpace", function()
	
	if (type(RP.Client.NextSpawn) == "number" and CurTime() <= RP.Client.NextSpawn) then
	
		local difference = RP.Client.NextSpawn - CurTime();

		local tab = {};
			tab["$pp_colour_addr"] = difference/550;
			tab["$pp_colour_addg"] = difference/550;
			tab["$pp_colour_addb"] = difference/550;
			tab["$pp_colour_brightness"] = difference/550;
			tab["$pp_colour_contrast"] = difference/1;
			tab["$pp_colour_colour"] = 0;
			tab["$pp_colour_mulr"] = 1;
			tab["$pp_colour_mulg"] = 1;
			tab["$pp_colour_mulb"] = 1;
	 
		DrawColorModify( tab );
	end;
 
    -- DrawBloom( 0, 0.75, 3, 3, 2, 3, 255, 255, 255 );
    -- DrawMaterialOverlay( "effects/combine_binocoverlay.vmt", 0.1 );
    -- DrawMotionBlur( 0.1, 0.79, 0.05 );
    -- DrawSharpen( 1.991, 5 );
    -- DrawSunbeams( 0.5 , 2, 5, 0, 0 );
	
end);