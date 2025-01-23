--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]

SF.editor = {};

local PANEL = {};
function PANEL:Init()
	self.pOffset = {x = 0, y = 0};
	self.pSize = {x = 255, y = 255};
end;

function PANEL:Think()
	if (self.nextThink and CurTime() >= self.nextThink) then
		if (input.IsKeyDown(KEY_W)) then
			self.pOffset.y = self.pOffset.y - 1;
		end;
		if (input.IsKeyDown(KEY_S)) then
			self.pOffset.y = self.pOffset.y + 1;
		end;
		if (input.IsKeyDown(KEY_A)) then
			self.pOffset.x = self.pOffset.x - 1;
		end;
		if (input.IsKeyDown(KEY_D)) then
			self.pOffset.x = self.pOffset.x + 1;
		end;

		self.nextThink = CurTime() + 0.03;

	end;
	if (!self.nextThink) then
		self.nextThink = CurTime() + 0.3;
	end;
end;

function PANEL:Paint()
	surface.SetDrawColor(Color(25, 25, 25, 255));
	surface.DrawRect(0, 0, ScrW(), ScrH());

	surface.SetDrawColor(Color(255, 0, 0));
	surface.DrawRect(self.pOffset.x, self.pOffset.y, 3, 3);

	surface.SetDrawColor(Color(150, 150, 150));

	local sX = (ScrW()/32);
	local sY = (ScrH()/32);

	local xOffset = ((self.pOffset.x/32)-math.floor(self.pOffset.x/32))*32;
	local yOffset = ((self.pOffset.y/32)-math.floor(self.pOffset.y/32))*32;

	local oX = math.floor(self.pOffset.x/32);
	local oY = math.floor(self.pOffset.y/32);



	for x = 0, sX do
		for y = 0, sY do
			local tX = math.floor((self.pOffset.x + x*32)/32)+1;
			local tY = math.floor((self.pOffset.y + y*32)/32)+1;
			if (tX > 0 and tY > 0) then
				//-1 + ((tX-1)*32 - self.pOffset.x)
				//-1 + ((tY-1)*32 - self.pOffset.y)

				local xOffset = self.pOffset.x - (tX*32);

				surface.DrawOutlinedRect(x*32 + xOffset, y*32, 32, 32);
			end;
		end;
	end;

	/*for x = 0, 128 do
		for y = 0, 128 do
			local sX = ((x*32)-1)+self.pOffset.x;
			local sY = ((y*32)-1)+self.pOffset.y;

			if (sX > -100 and sX < ScrW() + 100 and sY > -100 and sY < ScrH() + 100) then
				
			end;
		end;
	end;*/

	local mX, mY = gui.MousePos();

	local tX = math.floor((self.pOffset.x + mX)/32)+1;
	local tY = math.floor((self.pOffset.y + mY)/32)+1;

	draw.SimpleText(tX..", "..tY, "MenuLarge", mX, mY, Color(255, 255, 255), 0, 4);
end;


function PANEL:PerformLayout()
	self:SetSize(ScrW(), ScrH());
end;

derma.DefineControl("SFeditor", "World Editor", PANEL, "DPanel");



local PANEL = {};

function PANEL:Init()
	self:SetMouseInputEnabled(true);
end;

function PANEL:GetLevel()
	return self:GetParent().level;
end;

function PANEL:Think()
	if (!self.bgScroll) then
		self.bgScroll = CurTime();
	end;

	if (CurTime() >= self.bgScroll) then
		self.backgroundMaterial = SF.world:GetRandomSpace();
		self.bgScroll = CurTime() + math.Rand(1, 60);
	end;
end;

function PANEL:Paint()
	if (self.backgroundMaterial) then
		surface.SetMaterial(self.backgroundMaterial);
		surface.SetDrawColor(Color(255, 255, 255));
		surface.DrawTexturedRect(0, 0, 48, 48);
	end;

	if (self:GetLevel() == "UTIL") then
		local floor = SF.world:GetTile("FLOOR", self.tilePos.x, self.tilePos.y);
		floor = floor[table.Count(floor)]
		if (floor and floor.uniqueID) then
			local tileData = SF.tile:Get(floor.uniqueID);
			surface.SetMaterial(tileData.material);
			surface.SetDrawColor(Color(255, 255, 255, 125));
			
			surface.DrawTexturedRectRotated(24, 24, 48, 48, SF.world:Rot(floor.rot));
		end;
	end;

	if (self:GetLevel() == "OBJS") then
		local floors = SF.world:GetTile("FLOOR", self.tilePos.x, self.tilePos.y);
		for i, floor in pairs(floors) do
			if (floor and floor.uniqueID) then
				local tileData = SF.tile:Get(floor.uniqueID);
				surface.SetMaterial(tileData.material);
				surface.SetDrawColor(Color(255, 255, 255));
				
				surface.DrawTexturedRectRotated(24, 24, 48, 48, SF.world:Rot(floor.rot));
			end;
		end;

		local floor = SF.world:GetTile("UTIL", self.tilePos.x, self.tilePos.y);
		floor = floor[table.Count(floor)]
		if (floor and floor.uniqueID) then
			local tileData = SF.tile:Get(floor.uniqueID);
			surface.SetMaterial(tileData.material);
			surface.SetDrawColor(Color(255, 255, 255, 125));
			
			surface.DrawTexturedRectRotated(24, 24, 48, 48, SF.world:Rot(floor.rot));
		end;
	end;

	if (self:GetLevel() == "VIEW") then
		local floor = SF.world:GetTile("FLOOR", self.tilePos.x, self.tilePos.y);
		floor = floor[table.Count(floor)]
		if (floor and floor.uniqueID) then
			local tileData = SF.tile:Get(floor.uniqueID);
			surface.SetMaterial(tileData.material);
			surface.SetDrawColor(Color(255, 255, 255));
			
			surface.DrawTexturedRectRotated(24, 24, 48, 48, SF.world:Rot(floor.rot));
		end;

		local floor = SF.world:GetTile("OBJS", self.tilePos.x, self.tilePos.y);
		for i, tileInfo in pairs(floor) do
			local tileData = SF.tile:Get(tileInfo.uniqueID);
			surface.SetMaterial(tileData.material);
			surface.SetDrawColor(Color(255, 255, 255));
			
			surface.DrawTexturedRectRotated(24, 24, 48, 48, SF.world:Rot(tileInfo.rot));
		end;
	else 
		if (self.tileData) then
			for i, tileInfo in pairs(self.tileData) do
				local tileData = SF.tile:Get(tileInfo.uniqueID);
				surface.SetMaterial(tileData.material);
				surface.SetDrawColor(Color(255, 255, 255));
				
				surface.DrawTexturedRectRotated(24, 24, 48, 48, SF.world:Rot(tileInfo.rot));
			end;
		else
			surface.SetDrawColor(Color(255, 0, 0, 25));
			surface.DrawLine(0, 0, 48, 48);
		end;
	end;

	if (self.drawColor) then
		self.drawColor.a = 20;
		surface.SetDrawColor(self.drawColor);
		surface.DrawRect(0, 0, 48, 48);
	end;
end;

function PANEL:SetWorld(x, y)
	self.tilePos = {x = x, y = y};
end;

function PANEL:SetTile(tileData)
	self.tileData = tileData;
end;

function PANEL:PerformLayout()
	self:SetSize(48, 48);
end;

function PANEL:OnCursorEntered()
	self.drawColor = Color(0, 255, 0);
	if (input.IsMouseDown(MOUSE_LEFT)) then
		if (SF.editor.current) then
			SF.world:Append(self:GetLevel(), self.tilePos.x, self.tilePos.y, SF.editor.current);
			if (lastRot) then
				SF.world:SetRot(self:GetLevel(), self.tilePos.x, self.tilePos.y, id, lastRot);
			end;
		end;
	end;

	if (input.IsMouseDown(MOUSE_MIDDLE)) then
		if (SF.editor.current) then
			SF.world:Remove(self:GetLevel(), {x = self.tilePos.x, y = self.tilePos.y, uniqueID = SF.editor.current});
		end;
	end;
end;

function PANEL:OnCursorExited()
	self.drawColor = nil;
end;
	
function PANEL:OnMousePressed(mc)
	if (mc == MOUSE_RIGHT) then
		local context = DermaMenu(SF.editorPanel);
		context:AddOption(self:GetLevel());
		context:AddOption("X: "..self.tilePos.x.." Y:"..self.tilePos.y);

		local children = 1;
		if (self.tileData) then
			for i, tile in ipairs(self.tileData) do
				local tileData = SF.tile:Get(tile.uniqueID);
				local sub = context:AddSubMenu(tileData.name);
				children = children + 1;

				local childs = context:GetChildren();

				local iconImage = vgui.Create("DPanel", context);
				iconImage:SetSize(16, 16);
				iconImage:SetPos(3, (children*22)+3);

				function iconImage:Paint(w, h)
					surface.SetDrawColor(Color(255, 255, 255));
					surface.SetMaterial(tileData.material);
					surface.DrawTexturedRectRotated(8, 8, 16, 16, SF.world:Rot(tile.rot));
				end;

					sub:AddOption("Rotation: "..(tile.rot or "0"));

					sub:AddSpacer();

					sub:AddOption("Rotate CCW", function() lastRot = SF.world:Rotate(self:GetLevel(), tile.x, tile.y, i, -90) end);
					sub:AddOption("Rotate CW", function() lastRot = SF.world:Rotate(self:GetLevel(), tile.x, tile.y, i, 90) end);

					sub:AddSpacer();

					sub:AddOption("Remove", function() SF.world:Remove(self:GetLevel(), tile) end);
					
					sub:AddSpacer();

					sub:AddOption("Move Up", function() SF.world:MoveUp(self:GetLevel(), tile.x, tile.y, i) end);
					sub:AddOption("Move Down", function() SF.world:MoveDown(self:GetLevel(), tile.x, tile.y, i) end);

					sub:AddSpacer();

					sub:AddOption("To Top", function() SF.world:ToTop(self:GetLevel(), tile.x, tile.y, i) end);
					sub:AddOption("To Bottom", function() SF.world:ToBottom(self:GetLevel(), tile.x, tile.y, i) end);

			end;
		end;
		context:Open();
	end;

	if (mc == MOUSE_LEFT) then
		if (SF.editor.current) then
			local id = SF.world:Append(self:GetLevel(), self.tilePos.x, self.tilePos.y, SF.editor.current);
			if (lastRot) then
				SF.world:SetRot(self:GetLevel(), self.tilePos.x, self.tilePos.y, id, lastRot);
			end;
		end;
	end;

	if (mc == MOUSE_MIDDLE) then
		if (SF.editor.current) then
			SF.world:Remove(self:GetLevel(), {x = self.tilePos.x, y = self.tilePos.y, uniqueID = SF.editor.current});
		end;
	end;

end;

derma.DefineControl("SFeditor_worldTile", "WorldIcon", PANEL, "DPanel");