--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]

function SF.theme:HUDShouldDraw(name)
	if (name == "CHudAmmo") then
		return false;
	end;
	//return nil;
end;

function SF.theme:HUDPaint()
	if (SF.Client:GetActiveWeapon():GetClass() == "sf_tool") then
		self:DrawToolMenu();
	end;
end;

local mTOOLWHEEL = Material("sf_stranded/wheel.png")
function SF.theme:DrawToolMenu()
	if (input.IsKeyDown(KEY_Q)) then
		SF:ShowMouse(true);
		local cX = ScrW()/2;
		local cY = ScrH()/2;
		


		local mX, mY = gui.MousePos();

		local ang = math.Rad2Deg(math.atan2(cY-mY, mX-cX));
		surface.SetDrawColor(Color(255, 255, 255, 150));
		surface.SetMaterial(mTOOLWHEEL);
		surface.DrawTexturedRectRotated(cX, cY, 128, 128, ang);


		local bX, bY = cX - 256, cY + 128;
		local ang1 = math.Rad2Deg(math.atan2(cY-bY, bX-cX));
		if (math.abs(ang1-ang) < 30 and math.abs(ang1-ang) > 0) then
			surface.SetDrawColor(255, 0, 0);
		end;

		surface.DrawRect(bX-50, bY-50, 100, 100);
		surface.SetDrawColor(Color(255, 255, 255, 150));
		local bX, bY = cX + 256, cY + 128;
		local ang2 = math.Rad2Deg(math.atan2(cY-bY, bX-cX));
		if (math.abs(ang2-ang) < 30 and math.abs(ang1-ang) > 0) then
			surface.SetDrawColor(255, 0, 0);
		end;

		surface.DrawRect(bX-50, bY-50, 100, 100);
	surface.SetDrawColor(Color(255, 255, 255, 150));
			local bX, bY = cX - 256, cY - 128;
		local ang2 = math.Rad2Deg(math.atan2(cY-bY, bX-cX));
		if (math.abs(ang2-ang) < 30 and math.abs(ang1-ang) > 0) then
			surface.SetDrawColor(255, 0, 0);
		end;

		surface.DrawRect(bX-50, bY-50, 100, 100);
	else
		SF:ShowMouse(false);
	end;
end;