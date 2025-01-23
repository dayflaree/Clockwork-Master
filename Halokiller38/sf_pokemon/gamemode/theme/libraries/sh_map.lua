--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]

SF.map = {};
SF.map.tiles = {};
SF.map.stored = {};

function SF.map:Add(map, name)
	local m = {};
	m.width = map.width;
	m.height = map.height;
	m.properties = map.properties;
	for k, v in ipairs(map.tilesets) do
		self:AddTileset(v);
	end;
	m.layers = {}
	for k, v in ipairs(map.layers) do
		if (v.name == "collision") then
			m.layers.collision = v.data;
		end;
		if (v.name == "visible") then
			m.layers.visible = v.data;
		end;
	end;

	self.stored[name] = m;
end;

function SF.map:AddTileset(tileset)
	local i = tileset.firstgid;
	local itile = 0;
	local mat = Material("sf_pokemon/"..tileset.image);
	for yTile = 0, (tileset.imageheight/tileset.tileheight)-1 do
		for xTile = 0, (tileset.imagewidth/tileset.tilewidth)-1 do	
			local x = xTile * tileset.tilewidth;
			local y = yTile * tileset.tileheight;
			self.tiles[i] = {};
			self.tiles[i].sheet = tileset.image;
			self.tiles[i].msheet = mat;
			self.tiles[i].x = x;
			self.tiles[i].y = y;

			if (tileset.tiles[itile]) then
				self.tiles[i].properties = tileset.tiles[itile].properties;
			end;

			i = i + 1;
			itile = itile + 1;
		end;
	end;
end;

print("F");