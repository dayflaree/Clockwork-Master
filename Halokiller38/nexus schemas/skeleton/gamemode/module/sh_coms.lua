--[[
Name: "sh_coms.lua".
Product: "Skeleton".
--]]

--[[
	There are so many more options to choose from to customise your command to the maximum.
	But I cannot really document it fully, so make sure to check the entire resistance framework
	for cool little tricks and variables you can use with your commands.
--]]

-- Create a table to store our command.
local COMMAND = {};
 
COMMAND.tip = "A lovely command to top yourself!"; -- Describe the command in short.
--[[
	Some text to help with the syntax of the command (not necessary)
	Usually use <> for required arguments and [] for optional ones.
--]]
COMMAND.text = "[bool Silent]";
--[[
	Command flags to define when the command can be used.
	For more information check it out at:
		resistance/gamemode/core/libraries/sh_command.lua
--]]
COMMAND.flags = CMD_DEFAULT | CMD_FALLENOVER;
COMMAND.arguments = 0; -- How many arguments does the command require (not necessary).
COMMAND.optionalArguments 1; -- How many optional arguments are there?

--[[
	Called when the command has been run.
	This is for people who know what they're doing, check out
	the resistance framework for a complete list of libraries and functions.
--]]
function COMMAND:OnRun(player, arguments)
	if ( RESISTANCE:ToBool( arguments[1] ) ) then
		player:KillSilent(); -- They wanna die quietly.
	else
		player:Kill(); -- They wanna die in pain!
	end;
end;

-- Register our new command to the resistance framework.
resistance.command.Register(COMMAND, "Kill");