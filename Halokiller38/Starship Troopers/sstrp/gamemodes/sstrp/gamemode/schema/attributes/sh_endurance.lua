--[[
Name: "sh_endurance.lua".
Product: "Skeleton".
--]]

--[[
	There are so many more options to choose from to customise your attribute to the maximum.
	But I cannot really document it fully, so make sure to check the entire nexus framework
	for cool little tricks and variables you can use with your attributes.
--]]

-- Create a table to store the attribute in.
local ATTRIBUTE = {};

ATTRIBUTE.name = "Endurance"; -- The name of the attribute, obviously.
ATTRIBUTE.maximum = 75; -- The maximum points on this attribute that a player can have.
ATTRIBUTE.uniqueID = "end"; -- A unique ID to identify the attribute internally, usually a shorter version of the name.
ATTRIBUTE.description = "Affects your overall endurance, e.g: how much pain you can take."; -- A small description of the attribute.
ATTRIBUTE.characterScreen = true; -- Can players set this attribute when they make their character?

--[[
	Register the attribute and save the unique ID into a variable called ATB_ENDURANCE.
	The schema will use the ATB_ENDURANCE variable later (see sv_auto.lua).
--]]
ATB_ENDURANCE = nexus.attribute.Register(ATTRIBUTE);