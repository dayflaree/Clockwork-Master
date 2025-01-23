--============================
--	Weapon Selection (Client)
--============================
local PLUGIN = PLUGIN;
PLUGIN.displaySlot = 0;
PLUGIN.displayFade = 0;
PLUGIN.displayAlpha = 0;
PLUGIN.displayDelay = 0;
PLUGIN.weaponPrintNames = {};

PLUGIN.MainTextColour = Color(165, 155, 95, 255);

function ScaleToWideScreen(size)
	return math.min(math.max( ScreenScale(size / 2.62467192), math.min(size, 16) ), size);
end;

surface.CreateFont("Arial", ScaleToWideScreen(15), 600, true, false, "ws_mainText");

-- Draw some information.
function PLUGIN:DrawInformation(text, font, x, y, colour, align, alpha, alpha2, callback)
	surface.SetFont(font)
	
	local width, height = surface.GetTextSize(text)
	-- x = x + Width / 2
	if align == 1 then
		x = x - width/2
	elseif align == 2 then
		x = x - width;
	end;
	
	if (callback) then x, y = callback(x, y, width, height); end;
	
	x = math.Round(x)
	draw.SimpleTextOutlined(text, font, x, y, Color(colour.r, colour.g, colour.b, alpha or colour.a), 0, 0, 1, Color(0,0,0,alpha2 or alpha or colour.a))
	
	return y + height + 1
end

-- Draw the weapons information.
function PLUGIN:DrawWeaponInformation(itemTable, weapon, x, y, alpha)
	local informationColour = self.MainTextColour;
	local titleColor = Color(165, 155, 95, 255)
	local foregroundColour = Color(100, 100, 100, 25);
	local backgroundColour = Color(0, 0, 0, 75);
	local clipTwoAmount = LocalPlayer():GetAmmoCount(weapon:GetSecondaryAmmoType());
	local clipOneAmount = LocalPlayer():GetAmmoCount(weapon:GetPrimaryAmmoType());
	local mainTextFont = "ws_mainText";
	local secondaryAmmo;
	local primaryAmmo;
	local clipTwo = weapon:Clip2() or 0;
	local clipOne = weapon:Clip1() or 0;
	
	if (!weapon.Primary or !weapon.Primary.ClipSize or weapon.Primary.ClipSize > 0) then
		if (clipOne >= 0) then
			primaryAmmo = "Primary: "..clipOne.."/"..clipOneAmount..".";
		end;
	end;
	
	if (!weapon.Secondary or !weapon.Secondary.ClipSize or weapon.Secondary.ClipSize > 0) then
		if (clipTwo >= 0) then
			secondaryAmmo = "Secondary: "..clipTwo.."/"..clipTwoAmount..".";
		end;
	end;
	
	if (!weapon.Instructions) then weapon.Instructions = ""; end;
	if (!weapon.Purpose) then weapon.Purpose = ""; end;
	if (!weapon.Contact) then weapon.Contact = ""; end;
	if (!weapon.Author) then weapon.Author = ""; end;

	-- if weapon:GetClass() == "gmod_tool" then
		-- weapon.Instructions = "Primary Fire: Use tool. \nSecondary Fire: Use tool secondary fire.";
		-- weapon.Purpose = "Using various tools.";
	-- end;
	
	if (itemTable or primaryAmmo or secondaryAmmo or weapon.Instructions) then
		local text = "<font="..mainTextFont..">";
		local textColour = "<color=255,255,255,255>";
		local titleColour = "<color="..titleColor.r..","..titleColor.g..","..titleColor.b..",255>";
		
		if (informationColour) then
			titleColour = "<color="..informationColour.r..","..informationColour.g..","..informationColour.b..",255>";
		end;
		
		if (itemTable and itemTable.description != "") then
			text = text..titleColour.."Description</color>\n"..textColour..itemTable.description.."</color>\n";
		end
		
		if (primaryAmmo or secondaryAmmo) then
			text = text..titleColour.."Ammunition</color>\n";
			
			if (secondaryAmmo) then
				text = text..textColour..secondaryAmmo.."</color>\n";
			end;
			
			if (primaryAmmo) then
				text = text..textColour..primaryAmmo.."</color>\n";
			end;
		end
		
		if (weapon.Instructions != "") then
			text = text..titleColour.."Instructions</color>\n"..textColour..weapon.Instructions.."</color>\n";
		end;
		
		-- if (weapon.Purpose != "") then
			-- text = text..titleColour.."Purpose</color>\n"..textColour..weapon.Purpose.."</color>\n";
		-- end;
		
		-- if (weapon.Contact != "") then
			-- text = text..titleColour.."Contact</color>\n"..textColour..weapon.Contact.."</color>\n";
		-- end;
		
		-- if (weapon.Author != "") then
			-- text = text..titleColour.."Author</color>\n"..textColour..weapon.Author.."</color>\n";
		-- end;
		
		if (text != "<font="..mainTextFont..">") then
			weapon.InfoMarkup = markup.Parse(text.."</font>", 248);
			
			local weaponMarkupHeight = weapon.InfoMarkup:GetHeight();
			local realY = y - (weaponMarkupHeight / 2);
			
			draw.RoundedBox(4, x - 16, realY, 260, weaponMarkupHeight + 8, Color(backgroundColour.r, backgroundColour.g, backgroundColour.b, math.min(backgroundColour.a, alpha)));
			
			if (weapon.InfoMarkup) then
				weapon.InfoMarkup:Draw(x - 8, realY + 4, nil, nil, alpha);
			end;
		end;
	end;
end;

-- Gets the weapons print name.
function PLUGIN:GetWeaponPrintName(weapon)
	local printName = weapon:GetPrintName();
	local class = string.lower(weapon:GetClass());

	if class == "weapon_physgun" then printName = "Physics Gun"; end;
	
	if (printName and printName != "") then
		self.weaponPrintNames[class] = printName;
	end
	
	return self.weaponPrintNames[class] or printName;
end;

-- Called when the HUD should be drawn.
function PLUGIN:HUDShouldDraw(name)
	if (name == "CHudWeaponSelection") then
		return false;
	elseif (name == "CHudCrosshair") then
		if (self.displayAlpha > 0) then
			return false;
		end;
	end;
end;

-- Draws the HUD.
function PLUGIN:HUDPaint()
	local informationColour = self.MainTextColour;
	local activeWeapon = LocalPlayer():GetActiveWeapon();
	local newWeapons = {};
	local colourWhite = Color(255,255,255,255);
	local frameTime = FrameTime();
	local weapons = LocalPlayer():GetWeapons();
	local curTime = UnPredictedCurTime();
	local x = 100;
	local y = ScrH() / 3;
	
	if (IsValid(activeWeapon) and self.displayAlpha > 0) then
		for k,v in pairs(weapons) do
			local secondaryAmmo = LocalPlayer():GetAmmoCount(v:GetSecondaryAmmoType());
			local primaryAmmo = LocalPlayer():GetAmmoCount(v:GetPrimaryAmmoType());
			local clipOne = v:Clip1()
			local clipTwo = v:Clip2()
			
			if (clipOne > 0 or clipTwo > 0 or (clipOne == -1 and clipTwo == -1)
			or (clipOne == -1 and clipTwo > 0 and secondaryAmmo > 0)
			or (clipTwo == -1 and clipOne > 0 and primaryAmmo > 0)
			or (clipOne != -1 and primaryAmmo > 0)
			or (clipTwo != -1 and secondaryAmmo > 0)) then
				table.insert(newWeapons, v);
			end;
		end;
		
		if (self.displaySlot < 1) then
			self.displaySlot = #newWeapons;
		elseif (self.displaySlot > #newWeapons) then
			self.displaySlot = 1;
		end;
		
		local currentWeapon = newWeapons[self.displaySlot];
		local beforeWeapons = {};
		local afterWeapons = {};
		local weaponLimit = math.Clamp(#newWeapons, 2, 4);
		
		if (#newWeapons > 1) then
			for k,v in ipairs(newWeapons) do
				if (k < PLUGIN.displaySlot) then
					table.insert(beforeWeapons, v);
				elseif (k > PLUGIN.displaySlot) then
					table.insert(afterWeapons, v)
				end
			end;
			
			if (#beforeWeapons < weaponLimit) then
				local i = 0;
				
				while (#beforeWeapons < weaponLimit) do
					local possibleWeapon = newWeapons[#newWeapons - i];
					
					if (possibleWeapon) then
						table.insert(beforeWeapons, 1, possibleWeapon);
						
						i = i + 1;
					else
						i = 0;
					end;
				end;
			end;
			
			if (#afterWeapons < weaponLimit) then
				local i = 0;
				
				while (#afterWeapons < weaponLimit) do
					local possibleWeapon = newWeapons[1 + i];
					
					if (possibleWeapon) then
						table.insert(afterWeapons, possibleWeapon);
						
						i = i + 1;
					else
						i = 0;
					end;
				end;
			end;
			
			while (#beforeWeapons > weaponLimit) do
				table.remove(beforeWeapons, 1);
			end;
			
			while (#afterWeapons > weaponLimit) do
				table.remove(afterWeapons, #afterWeapons);
			end;
			
			for k,v in ipairs(beforeWeapons) do
				y = PLUGIN:DrawInformation(self:GetWeaponPrintName(v), "ws_mainText", x - 50, y, colourWhite, 0, math.min((255 / weaponLimit) * k, self.displayAlpha));
			end;
		end;
		
		if (IsValid(currentWeapon)) then
			local currentWeaponName = self:GetWeaponPrintName(currentWeapon);
			local weaponInfoY = y;
			local weaponInfoX = x + 100;
			
			y = PLUGIN:DrawInformation(currentWeaponName, "ws_mainText", x, y, informationColour, 1, self.displayAlpha);
			
			self:DrawWeaponInformation(RP.Item:Get(currentWeapon), currentWeapon, weaponInfoX, weaponInfoY, self.displayAlpha);
			
			if (#newWeapons == 1) then
				y = PLUGIN:DrawInformation("There are no other weapons.", "ws_mainText", x, y, colourWhite, 1, self.displayAlpha);
			end;
		end;
		
		if (#newWeapons > 1) then
			for k,v in ipairs(afterWeapons) do
				y = PLUGIN:DrawInformation(self:GetWeaponPrintName(v), "ws_mainText", x, y, colourWhite, 0, math.min(255 - ((255 / weaponLimit) * k), self.displayAlpha));
			end;
		end;
	end;
	
	if (self.displayAlpha > 0 and curTime >= self.displayFade) then
		self.displayAlpha = math.max(self.displayAlpha - (frameTime * 64), 0);
	end;
end;

-- Called when a player presses a bind.
function PLUGIN:PlayerBindPress(ply, bind, press)
	local activeWeapon = LocalPlayer():GetActiveWeapon();
	local newWeapons = {};
	local curTime = UnPredictedCurTime();
	local weapons = LocalPlayer():GetWeapons();
	
	if (!IsValid(activeWeapon)) then
		return;
	end;
	
	if (LocalPlayer():InVehicle()) then
		return;
	end;
	
	if (activeWeapon:GetClass() == "weapon_physgun") then
		if (ply:KeyDown(IN_ATTACK) ) then
			return;
		end;
	end;
	
	for k,v in pairs(weapons) do
		local secondaryAmmo = LocalPlayer():GetAmmoCount(v:GetSecondaryAmmoType());
		local primaryAmmo = LocalPlayer():GetAmmoCount(v:GetPrimaryAmmoType());
		local clipOne = v:Clip1();
		local clipTwo = v:Clip2();
		
		if ( clipOne > 0 or clipTwo > 0 or (clipOne == -1 and clipTwo == -1)
		or (clipOne == -1 and clipTwo > 0 and secondaryAmmo > 0)
		or (clipTwo == -1 and clipOne > 0 and primaryAmmo > 0)
		or (clipOne != -1 and primaryAmmo > 0)
		or (clipTwo != -1 and secondaryAmmo > 0) ) then
			table.insert(newWeapons, v);
		end;
	end;
	
	if (string.find(bind, "invnext") or string.find(bind, "slot2") ) then
		if (curTime >= self.displayDelay and !press) then
			if (#newWeapons > 1) then
				surface.PlaySound("common/talk.wav");
			end;
			
			self.displayDelay = curTime + 0.05;
			self.displayAlpha = 255;
			self.displayFade = curTime + 2;
			self.displaySlot = self.displaySlot + 1;
			
			if (self.displaySlot > #newWeapons) then
				self.displaySlot = 1;
			end;
		end;
		
		return true;
	elseif (string.find(bind, "invprev") or string.find(bind, "slot1")) then
		if (curTime >= self.displayDelay and !press) then
			if (#newWeapons > 1) then
				surface.PlaySound("common/talk.wav");
			end;
			
			self.displayDelay = curTime + 0.05;
			self.displayAlpha = 255;
			self.displayFade = curTime + 2;
			self.displaySlot = self.displaySlot - 1;
			
			if (self.displaySlot < 1) then
				self.displaySlot = #newWeapons;
			end
		end;
		
		return true;
	elseif (string.find(bind, "+attack")) then
		if (#newWeapons > 1) then
			if (self.displayAlpha >= 128 and IsValid(newWeapons[self.displaySlot])) then
				RunConsoleCommand("_selectweapon", newWeapons[self.displaySlot]:GetClass());
				
				surface.PlaySound("ui/buttonclickrelease.wav");
				
				self.displayAlpha = 0;
				
				return true;
			end;
		end;
	end;
end;

-- hook.Add("HUDShouldDraw", "WeaponSelectionHUDShouldDraw", function(name)
	-- PLUGIN:HUDShouldDraw(name);
-- end);

hook.Add("HUDPaint", "WeaponSelectionHUDPaint", function() 
	PLUGIN:HUDPaint()
end);

-- hook.Add("PlayerBindPress", "WeaponSelectionBindPress",	function(ply, bind, press) 
	-- PLUGIN:BindPress(ply, bind, press)
-- end);
