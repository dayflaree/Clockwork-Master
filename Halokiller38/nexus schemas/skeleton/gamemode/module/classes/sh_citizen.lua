--[[
Name: "sh_citizen.lua".
Product: "Skeleton".
--]]

--[[
	There are so many more options to choose from to customise your class to the maximum.
	But I cannot really document it fully, so make sure to check the entire resistance framework
	for cool little tricks and variables you can use with your classes.
--]]

-- Create a table to store our class in.
local CLASS = {};

CLASS.color = Color(150, 125, 100, 255); -- The color of the class: red, green, blue, alpha.
--[[
	This is a server limit based on a 128 player server.
	Imagine your server slots was 128, and the limit for
	this class is 16, that means only 16 of this class
	can be online at once. The limit must always be in relation
	to 128 slots. If this limit is 16 and your player slots is 32
	the limit would be 4. This is because 16 goes into 128 eight times
	and 4 goes into 32 eight times. So it's relative (remove line for no limit).
--]]
CLASS.limit = 16;
--[[
	A table of ammo that the player will start with when they spawn as this class.
	The format of the table being typeofammo = amount. For example:
		CLASS.ammo = {
			pistol = 99,
			smg1 = 12
		};
	(you can remove the line to make them start with default ammo).
--]]
CLASS.ammo = {pistol = 12};
CLASS.wages = 32; -- How much cash players with this class get every interval (set to 0 or remove line for no wages).
--[[
	A table of weapons that the player will start with when they spawn as this class.
	Each entry in the table is a new weapon, usually it will be a string representing the
	unique ID of a weapon item. But it will work for regular SWEP class names too! For example:
		CLASS.weapons = {"weapon_glock", "weapon_shotgun", "gmod_tool"};
	(you can remove the line to make them start with default weapons).
--]]
CLASS.weapons = {"weapon_pistol"};
CLASS.factions = {FACTION_CITIZEN}; -- Which factions can use this class, a table of factions that can.
CLASS.isDefault = true; -- Is this the default class for factions that have access to it (true or false).
CLASS.wagesName = "Supplies"; -- If this class has wages, what shall we call them?
CLASS.description = "A regular human citizen enslaved by the Universal Union."; -- A small description of the class.
CLASS.defaultPhysDesc = "Wearing dirty clothes."; -- What is their default physical description?

-- Register the class and save it into the CLASS_CITIZEN variable which we'll use later.
CLASS_CITIZEN = resistance.class.Register(CLASS, "Citizen");