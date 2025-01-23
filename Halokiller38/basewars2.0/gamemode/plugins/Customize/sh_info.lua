local PLUGIN = PLUGIN;

PLUGIN.name = "Customize";

RP:IncludeFile("cl_derma.lua");

PLUGIN.Models = {
	"models/Player/Group01/Male_01.mdl",
	"models/Player/Group01/male_02.mdl",
	"models/Player/Group01/male_03.mdl",
	"models/Player/Group01/Male_04.mdl",
	"models/Player/Group01/Male_05.mdl",
	"models/Player/Group01/male_06.mdl",
	"models/Player/Group01/male_07.mdl",
	"models/Player/Group01/male_08.mdl",
	"models/Player/Group01/Female_01.mdl",
	"models/Player/Group01/Female_02.mdl",
	"models/Player/Group01/Female_03.mdl",
	"models/Player/Group01/Female_04.mdl",
	"models/Player/Group01/Female_06.mdl",
	"models/Player/Group01/Female_07.mdl"
}

local COMMAND = {};
COMMAND.description = "Sets your model";
COMMAND.arguments = {{"String", "Model Path"}};
function COMMAND:OnRun(player, args)
	if (table.HasValue(PLUGIN.Models, args["Model Path"])) then
		player:SetData("model", args["Model Path"]);
		player:Notify("You've changed your model to "..args["Model Path"].." for next spawn.");
	else
		player:Notify("Invalid Model!");
	end;
end;

RP.Command:New("CustomizeModel", COMMAND);
