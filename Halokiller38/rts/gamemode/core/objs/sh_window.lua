local TILE = SF.tile:New("Window");
TILE.path = "obj/window/window.png";
TILE.type = "obj";
TILE.folder = "Windows";

TILE.isBorder = true;

TILE.collide = {
	SF_PLAYER = true,
	SF_ATMOS = true
}

SF.tile:Add(TILE, true);


local TILE = SF.tile:New("Reinforced Windows");
TILE.path = "obj/window/rwindow.png";
TILE.type = "obj";
TILE.folder = "Windows";

TILE.isBorder = true;

TILE.collide = {
	SF_PLAYER = true,
	SF_ATMOS = true
}

SF.tile:Add(TILE, true);


local TILE = SF.tile:New("Grille");
TILE.path = "obj/window/grille.png";
TILE.type = "obj";
TILE.folder = "Windows";

TILE.isBorder = true;

TILE.collide = {
	SF_PLAYER = true,
	SF_ATMOS = true
}

SF.tile:Add(TILE, true);