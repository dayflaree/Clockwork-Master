--[[
Name: "sh_auto.lua".
Product: "Severance".
--]]

for k, v in pairs( g_File.Find("../models/pmc/pmc_4/*.mdl") ) do
	nexus.animation.AddMaleHumanModel("models/pmc/pmc_4/"..v);
end;

local groups = {34, 35, 36, 37, 38, 39, 40, 41};

for k, v in pairs(groups) do
	local groupName = "group"..v;
	
	for k2, v2 in pairs( g_File.Find("../models/humans/"..groupName.."/*.*") ) do
		local fileName = string.lower(v2);
		
		if ( string.find(fileName, "female") ) then
			nexus.animation.AddFemaleHumanModel("models/humans/"..groupName.."/"..fileName);
		else
			nexus.animation.AddMaleHumanModel("models/humans/"..groupName.."/"..fileName);
		end;
	end;
end;

nexus.schema.SetOption( "default_date", {month = 1, year = 2013, day = 1} );
nexus.schema.SetOption( "default_time", {minute = 0, hour = 0, day = 1} );
nexus.schema.SetOption("description_attributes", "Check on your character's stats.");
nexus.schema.SetOption("description_inventory", "Manage the items in your satchel.");
nexus.schema.SetOption("description_business", "Distribute a variety of items.");
nexus.schema.SetOption("model_shipment", "models/props_junk/cardboard_box003b.mdl");
nexus.schema.SetOption("html_background", "http://roleplayunion.com/bg.gif");
nexus.schema.SetOption("intro_image", "severance/logo");
nexus.schema.SetOption("name_attributes", "Stats");
nexus.schema.SetOption("name_attribute", "Stat");
nexus.schema.SetOption("name_inventory", "Satchel");
nexus.schema.SetOption("name_business", "Distribution");

nexus.schema.SetColor( "information", Color(100, 150, 100, 255) );

nexus.schema.SetFont("bar_text", "sev_TargetIDText");
nexus.schema.SetFont("main_text", "sev_MainTextTiny");
nexus.schema.SetFont("hints_text", "sev_IntroTextTiny");
nexus.schema.SetFont("large_3d_2d", "sev_Large3D2D");
nexus.schema.SetFont("chat_box_text", "sev_ChatBoxText");
nexus.schema.SetFont("target_id_text", "sev_TargetIDText");
nexus.schema.SetFont("cinematic_text", "sev_CinematicText");
nexus.schema.SetFont("date_time_text", "sev_IntroTextSmall");
nexus.schema.SetFont("menu_text_big", "sev_MenuTextBig");
nexus.schema.SetFont("menu_text_tiny", "sev_IntroTextTiny");
nexus.schema.SetFont("intro_text_big", "sev_IntroTextBig");
nexus.schema.SetFont("menu_text_small", "sev_IntroTextSmall");
nexus.schema.SetFont("intro_text_tiny", "sev_IntroTextTiny");
nexus.schema.SetFont("intro_text_small", "sev_IntroTextSmall");
nexus.schema.SetFont("player_info_text", "sev_ChatBoxText");

nexus.player.RegisterSharedVar("sh_PermaKilled", NWTYPE_BOOL, true);
nexus.player.RegisterSharedVar("sh_Clothes", NWTYPE_NUMBER, true);
nexus.player.RegisterSharedVar("sh_Tied", NWTYPE_NUMBER);

NEXUS:IncludePrefixed("sh_coms.lua");
NEXUS:IncludePrefixed("sv_hooks.lua");
NEXUS:IncludePrefixed("cl_hooks.lua");

nexus.config.ShareKey("intro_text_small");
nexus.config.ShareKey("intro_text_big");

nexus.quiz.SetEnabled(true);
nexus.quiz.AddQuestion("Do you understand that roleplaying is slow paced and relaxed?", 1, "Yes.", "No.");
nexus.quiz.AddQuestion("Can you type properly, using capital letters and full-stops?", 2, "yes i can", "Yes, I can.");
nexus.quiz.AddQuestion("You do not need weapons to roleplay, do you understand?", 1, "Yes.", "No.");
nexus.quiz.AddQuestion("You do not need items to roleplay, do you understand?", 1, "Yes.", "No.");
nexus.quiz.AddQuestion("What do you think serious roleplaying is about?", 2, "Collecting items and upgrades.", "Developing your character.");
nexus.quiz.AddQuestion("What universe is this roleplaying game set in?", 2, "Real Life.", "Apocalypse.");

nexus.flag.Add("y", "Distribution", "Access to distribute items around the map.");