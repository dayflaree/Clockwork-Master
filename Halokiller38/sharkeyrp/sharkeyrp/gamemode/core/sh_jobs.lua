--[[
	Citizen Job
]]--
local JOB = {};
JOB.name = "Citizen";
JOB.models = {
	"models/player/Group01/Female_01.mdl",
	"models/player/Group01/Female_02.mdl",
	"models/player/Group01/Female_03.mdl",
	"models/player/Group01/Female_04.mdl",
	"models/player/Group01/Female_05.mdl",
	"models/player/Group01/Female_06.mdl",
	"models/player/Group01/Female_07.mdl",
	"models/player/Group01/Male_01.mdl",
	"models/player/Group01/male_02.mdl",
	"models/player/Group01/male_03.mdl",
	"models/player/Group01/Male_04.mdl",
	"models/player/Group01/Male_05.mdl",
	"models/player/Group01/male_06.mdl",
	"models/player/Group01/male_07.mdl",
	"models/player/Group01/male_08.mdl",
	"models/player/Group01/male_09.mdl",
	};
JOB.MaxCount = 32;
JOB.Color = Color(0, 190, 5);

function JOB:Description(descMeta)
	descMeta:Text("Fag");
	return descMeta;
end;

function JOB:OnSwitch(player)
end;
RP.job:New(JOB);

--[[
	Gun Dealer
]]--
local JOB = {};
JOB.name = "Gun Dealer";
JOB.models = {
	"models/player/monk.mdl"
	};
JOB.MaxCount = 4;
JOB.Color = Color(255, 140, 0);

function JOB:Description(descMeta)
	descMeta:Text("Fag");
	return descMeta;
end;

function JOB:OnSwitch(player)
end;
RP.job:New(JOB);

--[[
	Police
]]--
local JOB = {};
JOB.name = "Police";
JOB.mustVote = true;
JOB.models = {
	"models/player/police.mdl"
	};
JOB.MaxCount = 8;
JOB.Color = Color(0, 70, 255);

function JOB:Description(descMeta)
	descMeta:Text("Fag");
	return descMeta;
end;

function JOB:OnSwitch(player)
end;
RP.job:New(JOB);

--[[
	Mobster
]]--
local JOB = {};
JOB.name = "Mobster";
JOB.models = {
	"models/player/Group03/Female_01.mdl",
	"models/player/Group03/Female_02.mdl",
	"models/player/Group03/Female_03.mdl",
	"models/player/Group03/Female_04.mdl",
	"models/player/Group03/Female_05.mdl",
	"models/player/Group03/Female_06.mdl",
	"models/player/Group03/Female_07.mdl",
	"models/player/Group03/Male_01.mdl",
	"models/player/Group03/male_02.mdl",
	"models/player/Group03/male_03.mdl",
	"models/player/Group03/Male_04.mdl",
	"models/player/Group03/Male_05.mdl",
	"models/player/Group03/male_06.mdl",
	"models/player/Group03/male_07.mdl",
	"models/player/Group03/male_08.mdl",
	"models/player/Group03/male_09.mdl",
	};
JOB.MaxCount = 6;
JOB.Color = Color(190, 190, 190);

function JOB:Description(descMeta)
	descMeta:Text("Fag");
	return descMeta;
end;

function JOB:OnSwitch(player)
end;
RP.job:New(JOB);

--[[
	Mob Boss
]]--
local JOB = {};
JOB.name = "Mob Boss";
JOB.models = {
	"models/player/gman_high.mdl"
	};
JOB.mustVote = true;
JOB.MaxCount = 1;
JOB.Color = Color(100, 100, 100);

function JOB:Description(descMeta)
	descMeta:Text("Fag");
	return descMeta;
end;

function JOB:OnSwitch(player)
	RP.vote:Announce({player:Name().." is the new ", self.Color, self.name})
end;
RP.job:New(JOB);

--[[
	Medic
]]--
local JOB = {};
JOB.name = "Medic";
JOB.models = {"models/player/Kleiner.mdl"};
JOB.MaxCount = 6;
JOB.Color = Color(255, 199, 250);
function JOB:Description(descMeta)
	descMeta:Text("Fag");
	return descMeta;
end;
function JOB:OnSwitch(player)
end;
RP.job:New(JOB);

--[[
	Cook
]]--
local JOB = {};
JOB.name = "Cook";
JOB.models = {
	"models/player/mossman.mdl"
	};
JOB.MaxCount = 6;
JOB.Color = Color(85, 60, 0);

function JOB:Description(descMeta)
	descMeta:Text("Fag");
	return descMeta;
end;

function JOB:OnSwitch(player)
end;
RP.job:New(JOB);

--[[
	Police Cheif
]]--
local JOB = {};
JOB.name = "Police Chief";
JOB.models = {
	"models/player/combine_soldier.mdl"
	};
JOB.mustVote = true;
JOB.MaxCount = 1;
JOB.Color = Color(0, 95, 150);

function JOB:Description(descMeta)
	descMeta:Text("Fag");
	return descMeta;
end;

function JOB:OnSwitch(player)
	RP.vote:Announce({player:Name().." is the new ", self.Color, self.name})
end;
RP.job:New(JOB);

--[[
	Mayor
]]--
local JOB = {};
JOB.name = "Mayor";
JOB.models = {
	"models/player/breen.mdl"
	};
JOB.mustVote = true;
JOB.MaxCount = 1;
JOB.Color = Color(255, 0, 0);

function JOB:Description(descMeta)
	descMeta:Text("Fag");
	return descMeta;
end;

function JOB:OnSwitch(player)
	RP.vote:Announce({player:Name().." is the new ", self.Color, self.name})
end;
RP.job:New(JOB);