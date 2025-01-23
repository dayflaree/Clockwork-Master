--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]

function SF.theme:Init()
	self.pos = {x = 10, y = 10};
	self.offset = {x = 0, y = 0};
end;

function SF.theme:HUDShouldDraw(name)
	if (name == "CHudAmmo") then
		return false;
	end;
	//return nil;
end;

function SF.theme:HUDPaint()
	surface.SetDrawColor(Color(0, 0, 0));
	surface.DrawRect(0, 0, ScrW(), ScrH());

	local map = SF.map.stored["LITTLEROOT"];
	//print();
	surface.SetDrawColor(Color(255, 255, 255));
	
	local i = 1;
	for y = 1, map.height do
		for x = 1, map.width do
			local sx = x;
			local sy = y;

			sx = math.Round(ScrW()/2) - self.pos.x*32;
			sy = math.Round(ScrH()/2) - self.pos.y*32;

			local tileid = map.layers.visible[i];
			local tile = SF.map.tiles[tileid];
			surface.SetMaterial(tile.msheet);
			render.SetScissorRect(x*32 + sx, y*32 + sy, x*32 + 32 + sx, y*32 + 32 + sy, true);
			surface.DrawTexturedRect(x*32 - tile.x + sx, y*32 - tile.y + sy, tile.msheet:Width(), tile.msheet:Height());
			//surface.SetDrawColor(Color(255, 0, 0, 100));
			//surface.DrawRect(x*32, y*32, 32, 32);
			draw.SimpleText(tileid)
			render.SetScissorRect(x*32 + sx, y*32 + sy, x*32 + 32 + sx, y*32 + 32 + sy, false);
			//surface.DrawRect(x * 32, y * 32, 32, 32);
			i = i + 1;
		end;
	end;
end;