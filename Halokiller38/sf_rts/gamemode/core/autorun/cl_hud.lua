--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]


local MAT_HEADER = Material("sf_ss13/header.png")

local title1 = Material("sf_ss13/title1.png");
local title2 = Material("sf_ss13/title2.png");

local MAT_STARS = Material("sf_ss13/stars1.png");

function SF:DrawBackground()
	local wide = math.ceil(ScrW()/512);
	local tall = math.ceil(ScrH()/512);

	surface.SetMaterial(MAT_STARS);
	surface.SetDrawColor(color_white);
	for x = 0, wide+1 do
		for y = 0, tall+1 do
			surface.DrawTexturedRect(x*512, y*512, 512, 512);
		end;
	end;
end;

function SF:ShowIntro()
	if (!self.introFade) then
		self.networking = self:NewFade(2.5, 0, 0, 0);
		self.introFade = self:NewFade(3.5, 255, 0, 0);

		self.title1 = self:NewFade(0.33, -125, 0, 3);
		self.title2 = self:NewFade(0.25, 0, 124, 3.2);
	end;

	if (self.networking:Active()) then
		self:StatusMessage("Networking Data...");
	else
		if (self.statusMessage == "Networking Data...") then
			self:StatusMessage(false);
		end;
	end;

	if (self.introFade:Active()) then
		local alpha = self.introFade:Value();
		surface.SetDrawColor(Color(0, 0, 0, alpha));
		surface.DrawRect(0, 0, ScrW(), ScrH());

		/*surface.SetMaterial(MAT_HEADER);
		surface.SetDrawColor(Color(255, 255, 255, alpha));
		surface.DrawTexturedRect((ScrW()/2) - 256, (ScrH()/2) - 64, 512, 128);*/
	else
		surface.SetDrawColor(Color(0, 0, 0));
		surface.DrawRect(0, 0, ScrW(), ScrH());
		if (!self.introComplete) then
			self.introComplete = true;
			SF:Call("IntroComplete");
		end;
	end;

	if (self.title1:Active()) then
		local pos = self.title1:Value();
		local alpha = (pos * -2) - 255;

		surface.SetMaterial(title1);
		surface.SetDrawColor(Color(255, 255, 255, alpha));
		surface.DrawTexturedRect((ScrW()/2) - 256, (ScrH()/2) - 64 - pos - 125, 512, 128);
	else 
		surface.SetMaterial(title1);
		surface.SetDrawColor(Color(255, 255, 255));
		surface.DrawTexturedRect((ScrW()/2) - 256, (ScrH()/2) - 64, 512, 128);
	end;

	if (self.title2:Active()) then
		local pos = self.title2:Value();
		local alpha = pos * 2;

		local cX = ScrW()/2 - 256;
		local cY = ScrH()/2 - 64;
		render.SetScissorRect(cX + 374, cY + 70, cX + 374 + pos, cY + 94, true);

		surface.SetMaterial(title2);
		surface.SetDrawColor(Color(255, 255, 255, alpha));
		surface.DrawTexturedRect((ScrW()/2) - 256, (ScrH()/2) - 64, 512, 128);

		render.SetScissorRect(cX + 374, cY + 70, cX + 374 + pos, cY + 94, false);
	else
		surface.SetMaterial(title2);
		surface.SetDrawColor(Color(255, 255, 255));
		surface.DrawTexturedRect((ScrW()/2) - 256, (ScrH()/2) - 64, 512, 128);
	end;
end;

function SF:DrawStatusMessage()
	if (self.statusMessage) then
		draw.SimpleTextOutlined(self.statusMessage, "Trebuchet24", ScrW()/2, ScrH()/3, Color(255, 255, 255), 1, 1, 5, Color(0, 0, 0));
	end;
end;