-- (c) Khub 2012-2013.
-- Shared skeleton of the datafiles system.

local PLUGIN = PLUGIN;

Datafiles = {};
Clockwork.kernel:IncludePrefixed("sh_privileges.lua");

-- Called when the Clockwork shared variables are added.
function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Number("LoyaltyTier");
end;

function Datafiles:GetDateFromTimestamp(ts)
	local year = tonumber(os.date("%Y", ts)) + 4;
	if (year < 2000) then
		-- If the record is older than ten years then it's timestamp is probably zero, and something went wrong.
		-- We'll display ####-##-## ##:## instead of 1970-01-01 00:00.
		return "####-##-## ##:##";
	end;

	local monthDay = os.date("%m-%d", ts);
	local clock = os.date("%H:%M", ts);

	return year .. "-" .. monthDay .. " " .. clock;
end;

Datafiles.LoyalistTiers = {
	[1] = {
		tierName = "Brown",
		tierColor = Color(110, 80, 0),
		canGivePoints = 1,
		canManipulate = Datafiles.Privileges:GetRankFromLabel("MPF"),
		pointsRequirement = 15
	},
	[2] = {
		tierName = "Red",
		tierColor = Color(255, 70, 70),
		canGivePoints = 1,
		canManipulate = Datafiles.Privileges:GetRankFromLabel("MPF"),
		pointsRequirement = 20
	},
	[3] = {
		tierName = "Blue",
		tierColor = Color(70, 70, 255),
		canGivePoints = 1,
		canManipulate = Datafiles.Privileges:GetRankFromLabel("MPF"),
		pointsRequirement = 30
	},
	[4] = {
		tierName = "Green",
		tierColor = Color(0, 100, 0),
		canGivePoints = 1,
		canManipulate = Datafiles.Privileges:GetRankFromLabel("MPF"),
		pointsRequirement = 50
	},
	[5] = {
		tierName = "White",
		tierColor = Color(255, 255, 255),
		canGivePoints = 1,
		canManipulate = Datafiles.Privileges:GetRankFromLabel("MPF"),
		pointsRequirement = 65
	},
	[6] = {
		tierName = "Gold",
		tierColor = Color(255, 215, 0),
		canGivePoints = 1,
		canManipulate = Datafiles.Privileges:GetRankFromLabel("MPF"),
		pointsRequirement = 80
	},
	[7] = {
		tierName = "Platinum",
		tierColor = Color(230, 230, 230),
		canGivePoints = 1,
		canManipulate = Datafiles.Privileges:GetRankFromLabel("MPF"),
		pointsRequirement = 100
	}
};

Clockwork.kernel:IncludePrefixed("client/cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("client/cl_network.lua");

Clockwork.kernel:IncludePrefixed("server/sv_player.lua");
Clockwork.kernel:IncludePrefixed("server/sv_database.lua");
Clockwork.kernel:IncludePrefixed("server/sv_network.lua");
Clockwork.kernel:IncludePrefixed("server/sv_hooks.lua");

if (SERVER) then
	resource.AddFile("materials/cg/datafile.png");
end;
