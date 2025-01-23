local TILE = SF.tile:New("Wall");
TILE.path = "turf/walls/wall.png";
TILE.type = "turf";
TILE.folder = "Walls";

TILE.collide = {
	SF_PLAYER = true,
	SF_ATMOS = true
}

SF.tile:Add(TILE);