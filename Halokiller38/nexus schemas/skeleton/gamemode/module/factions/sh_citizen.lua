--[[
Name: "sh_citizen.lua".
Product: "Skeleton".
--]]

--[[
	There are so many more options to choose from to customise your faction to the maximum.
	But I cannot really document it fully, so make sure to check the entire resistance framework
	for cool little tricks and variables you can use with your factions.
--]]

-- Create a table to store our faction in.
local FACTION = {};

--[[
	When a player is creating the character, do they enter a full name?
	If this is false, they are forced to use a first and last name.
--]]
FACTION.useFullName = true;
FACTION.whitelist = false; -- Is our faction whitelist only? If true players must be whitelisted first.
FACTION.maximum = 2; -- This sets it so players can only have two characters with this faction (remove line for no limit).
--[[
	This is a server limit based on a 128 player server.
	Imagine your server slots was 128, and the limit for
	this faction is 16, that means only 16 of this faction
	can be online at once. The limit must always be in relation
	to 128 slots. If this limit is 16 and your player slots is 32
	the limit would be 4. This is because 16 goes into 128 eight times
	and 4 goes into 32 eight times. So it's relative (remove line for no limit).
--]]
FACTION.limit = 16;

-- Register the faction and store it into FACTION_CITIZEN which we'll use later.
FACTION_CITIZEN = resistance.faction.Register(FACTION, "Citizen");