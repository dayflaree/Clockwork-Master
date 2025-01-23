--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]

local PANEL = {};
local title1 = Material("sf_ss13/title1.png");
local title2 = Material("sf_ss13/title2.png");
local spaces = {};
for i = 0, 9 do
	spaces[i+1] = Material("sf_ss13/turf/space/"..i..".png");
end;

local tiles = {};

function PANEL:Init()
	self.fade = SF:NewFade(0.5, 0, 255, 0);
	self.spacefade = SF:NewFade(3, 0, 255, 0);


	self.btn_charSetup = vgui.Create("DButton", self);
	self.btn_charSetup:SetText("Character Setup");

	self.btn_joinGame = vgui.Create("DButton", self);
	self.btn_joinGame:SetText("Join Game");

	self.btn_editor = vgui.Create("DButton", self);
	self.btn_editor.DoClick = function(p)
		RunConsoleCommand("editor");
	end;
	self.btn_editor:SetText("World Editor");

	self:MakePopup();
end;

function PANEL:PerformLayout()
	self:SetSize(ScrW(), ScrH());
	self:SetPos(0, 0);

	self.btn_charSetup:SetSize(200, 64);
	self.btn_charSetup:SetPos(ScrW()/2 - 228, ScrH()/2 + 128);

	self.btn_joinGame:SetSize(200, 64);
	self.btn_joinGame:SetPos(ScrW()/2 + 28, ScrH()/2 + 128);

	self.btn_editor:SetSize(456, 32);
	self.btn_editor:SetPos(ScrW()/2 - 228, ScrH()/2 + 224);
end;

function PANEL:Think()
	if (self.fade:Active()) then
		self:SetAlpha(self.fade:Value());
	end;
end;

function PANEL:Paint(w, h)

	local mX = math.ceil(ScrW()/48);
	local mY = math.ceil(ScrH()/48);

	surface.SetDrawColor(Color(255, 255, 255, self.spacefade:Value()));
	for x = 0, mX do
		for y = 0, mY do
			if (!tiles[x] or !tiles[x][y]) then
				if (!tiles[x]) then
					tiles[x] = {};
				end;
				tiles[x][y] = table.Random(spaces);
			end;
			local space = tiles[x][y];

			surface.SetMaterial(space);		
			surface.DrawTexturedRect(x*48, y*48, 48, 48);
		end;
	end;

	surface.SetDrawColor(Color(0, 0, 0, 200));
	surface.DrawRect(0, 0, ScrW(), ScrH());

	surface.SetMaterial(title1);
	surface.SetDrawColor(Color(255, 255, 255));
	surface.DrawTexturedRect((ScrW()/2) - 256, (ScrH()/2) - 64, 512, 128);
	
	surface.SetMaterial(title2);
	surface.SetDrawColor(Color(255, 255, 255));
	surface.DrawTexturedRect((ScrW()/2) - 256, (ScrH()/2) - 64, 512, 128);
end;

derma.DefineControl("SFMainMenu", "SFMainMenu", PANEL, "DPanel");

local PANEL = {};

function PANEL:Init()

end;

function PANEL:PerformLayout()
	self:SetSize(600)
end;