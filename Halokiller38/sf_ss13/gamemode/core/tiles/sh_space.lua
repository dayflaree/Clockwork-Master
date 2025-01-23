local TILE = SF.tile:New("Space");
TILE.path = "turf/space/0.png";
TILE.type = "turf";
TILE.folder = "Space";

TILE.collide = {
	SF_PLAYER = false,
	SF_ATMOS = false
}

SF.tile:Add(TILE);

for i = 1, 9 do
	local TILE = SF.tile:New("Space"..i);
	TILE.path = "turf/space/"..i..".png";
	TILE.type = "turf";
	TILE.folder = "Space";

	TILE.collide = {
		SF_PLAYER = false,
		SF_ATMOS = false
	}

	SF.tile:Add(TILE);
end;