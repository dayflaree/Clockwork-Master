--=============
--	Head Bob
--============
local PLUGIN = PLUGIN;

PLUGIN.weaponPositions = {};

function PLUGIN:AddNewWepPos(data)
	self.weaponPositions[data.class] = data;
end;

function PLUGIN:GetWeaponInfo(data)
	return self.weaponPositions[data];
end;

local WEAPON = {};
WEAPON.class = "gmod_tool";
WEAPON.aimPos = Vector(-1.9199999570847, -2, 2);
WEAPON.aimAng = Angle(0, 0, 0);
WEAPON.runPos = Vector(2.8299999237061, 2.5299999713898, -20);
WEAPON.runAng = Angle(-70, 4.3400001525879, 0);
PLUGIN:AddNewWepPos(WEAPON);

local WEAPON = {};
WEAPON.class = "weapon_physcannon";
WEAPON.aimPos = Vector(-7.0599999427795, -9.0200004577637, 2.9800000190735);
WEAPON.aimAng = Angle(-0.38999998569489, -0.23000000417233, 0);
WEAPON.runPos = Vector(-8.5699996948242, -5.0900001525879, 8.9399995803833);
WEAPON.runAng = Angle(17.170000076294, -21.700000762939, 0);
PLUGIN:AddNewWepPos(WEAPON);

local WEAPON = {};
WEAPON.class = "weapon_physgun";
WEAPON.aimPos = Vector(-7.0599999427795, -9.0200004577637, 2.9800000190735);
WEAPON.aimAng = Angle(-0.38999998569489, -0.23000000417233, 0);
WEAPON.runPos = Vector(-8.5699996948242, -5.0900001525879, 8.9399995803833);
WEAPON.runAng = Angle(17.170000076294, -21.700000762939, 0);
PLUGIN:AddNewWepPos(WEAPON);

/*
local WEAPON = {};
WEAPON.class = "weapon_physgun";
WEAPON.aimPos = Vector(NUM, NUM, NUM);
WEAPON.aimAng = Angle(NUM, NUM, NUM);
WEAPON.runPos = Vector(NUM, NUM, NUM);
WEAPON.runAng = Angle(NUM, NUM, NUM);
PLUGIN:AddNewWepPos(WEAPON);
*/
