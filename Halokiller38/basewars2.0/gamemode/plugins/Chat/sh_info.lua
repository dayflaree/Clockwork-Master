local PLUGIN = PLUGIN;

PLUGIN.name = "Chat";

local COMMAND = {};
COMMAND.description = "Global Chat";
COMMAND.arguments = {{"String", "Chat"}};
function COMMAND:OnRun(player, args)
	local chatTable;
	local text = args["Chat"];
	local icon = "gui/silkicons/user";
	if (player:HasFlag("a")) then
		icon = "gui/silkicons/shield";
	end;
	if (player:Alive()) then
		chatTable = {Color(175, 100, 100), " [GLOBAL] ", team.GetColor(player:Team()), player:Name(), Color(255, 255, 225), ": "..text};
	else
		chatTable = {Color(175, 100, 100), " [GLOBAL] ", Color(175, 0, 0), " DEAD ", team.GetColor(player:Team()), player:Name(), Color(255, 255, 225), ": "..text};
	end;
	RP.chat:Add(_player.GetAll(), chatTable, icon);
end;

RP.Command:New("/", COMMAND);

local COMMAND = {};
COMMAND.description = "Private Message";
COMMAND.arguments = {{"Player", "Target"}, {"String", "Chat"}};
function COMMAND:OnRun(player, args)
	local target = args["Target"];
	RP.chat:Add(player, {Color(0, 200, 20), "To "..target:Name(), "\""..args["Chat"].."\""}, "gui/silkicons/group");
	RP.chat:Add(target, {Color(0, 200, 20), "From "..player:Name(), "\""..args["Chat"].."\""}, "gui/silkicons/group");
end;

RP.Command:New("pm", COMMAND);


local COMMAND = {};
COMMAND.description = "Annoucement";
COMMAND.arguments = {{"String", "Chat"}};
COMMAND.flag = "a"
function COMMAND:OnRun(player, args)
	local chatTable;
	local text = args["Chat"];
	local icon = "gui/silkicons/world";
	chatTable = {Color(100, 100, 255), text};
	RP.chat:Add(_player.GetAll(), chatTable, icon);
end;

RP.Command:New("a", COMMAND);