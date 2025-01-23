--[[
Name: "sh_coms.lua".
Product: "eXperim3nt".
--]]

local MOUNT = MOUNT;
local COMMAND = {};


COMMAND = {};
COMMAND.tip = "Toggle ThirdPerson.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)

	player:ConCommand("ws_thirdperson");
	player:ConCommand("play hgn/crussaria/ui/ui_message.wav");
end;

nexus.command.Register(COMMAND, "WS_ThirdPerson");

COMMAND = {};
COMMAND.tip = "Access Third Person Menu.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)

	player:ConCommand("ws_ThirdPersonMenu");
	player:ConCommand("play hgn/crussaria/ui/ui_message.wav");
end;

nexus.command.Register(COMMAND, "WS_ThirdPersonMenu");