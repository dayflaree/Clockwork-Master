local TILE = SF.tile:New("Floor");
TILE.path = "turf/floors/floor.png";
TILE.type = "turf";
TILE.folder = "Floors";
TILE.isFloor = true;

TILE.collide = {
	SF_PLAYER = false,
	SF_ATMOS = false
}
SF.tile:Add(TILE);


local TILE = SF.tile:New("White");
TILE.path = "turf/floors/white.png";
TILE.type = "turf";
TILE.folder = "Floors";
TILE.isFloor = true;

TILE.collide = {
	SF_PLAYER = false,
	SF_ATMOS = false
}
SF.tile:Add(TILE);


local TILE = SF.tile:New("Dark");
TILE.path = "turf/floors/dark.png";
TILE.type = "turf";
TILE.folder = "Floors";
TILE.isFloor = true;

TILE.collide = {
	SF_PLAYER = false,
	SF_ATMOS = false
}
SF.tile:Add(TILE);

local TILE = SF.tile:New("Plating");
TILE.path = "turf/floors/plating.png";
TILE.type = "turf";
TILE.folder = "Floors";
TILE.isFloor = true;

TILE.collide = {
	SF_PLAYER = false,
	SF_ATMOS = false
}
SF.tile:Add(TILE);
