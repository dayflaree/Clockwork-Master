--[[
Name: "sh_auto.lua".
Product: "Novus Two".
--]]

local groups = {34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 98};

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

for k, v in pairs( g_File.Find("../models/pmc/pmc_3/*.*") ) do
	nexus.animation.AddMaleHumanModel("models/pmc/pmc_3/"..v);
end;

nexus.schema.SetOption( "default_date", {month = 8, year = 2032, day = 22} );
nexus.schema.SetOption( "default_time", {minute = 0, hour = 12, day = 1} );
nexus.schema.SetOption("description_inventory", "Manage the items amongst your belongings.");
nexus.schema.SetOption("description_business", "Trade scraps for items with your outside contacts.");
nexus.schema.SetOption("format_singular_cash", "%a");
nexus.schema.SetOption("html_background", "http://roleplayunion.com/bg.gif");
nexus.schema.SetOption("model_shipment", "models/props_junk/cardboard_box003b.mdl");
nexus.schema.SetOption("name_inventory", "Belongings");
nexus.schema.SetOption("name_business", "Trading");
nexus.schema.SetOption("intro_image", "novustwo/intro");
nexus.schema.SetOption("model_cash", "models/props_lab/box01a.mdl");
nexus.schema.SetOption("format_cash", "%a %n");
nexus.schema.SetOption("name_cash", "Scraps");

nexus.schema.SetColor( "information", Color(165, 155, 95, 255) );

nexus.schema.SetFont("bar_text", "nov_TargetIDText");
nexus.schema.SetFont("main_text", "nov_MainText");
nexus.schema.SetFont("hints_text", "nov_IntroTextTiny");
nexus.schema.SetFont("large_3d_2d", "nov_Large3D2D");
nexus.schema.SetFont("chat_box_text", "nov_ChatBoxText");
nexus.schema.SetFont("target_id_text", "nov_TargetIDText");
nexus.schema.SetFont("cinematic_text", "nov_CinematicText");
nexus.schema.SetFont("date_time_text", "nov_IntroTextSmall");
nexus.schema.SetFont("menu_text_big", "nov_MenuTextBig");
nexus.schema.SetFont("menu_text_tiny", "nov_IntroTextTiny");
nexus.schema.SetFont("intro_text_big", "nov_IntroTextBig");
nexus.schema.SetFont("menu_text_small", "nov_IntroTextSmall");
nexus.schema.SetFont("intro_text_tiny", "nov_IntroTextTiny");
nexus.schema.SetFont("intro_text_small", "nov_IntroTextSmall");
nexus.schema.SetFont("player_info_text", "nov_ChatBoxText");

nexus.player.RegisterSharedVar("sh_PermaKilled", NWTYPE_BOOL, true);
nexus.player.RegisterSharedVar("sh_TempKilled", NWTYPE_BOOL, true);
nexus.player.RegisterSharedVar("sh_Tied", NWTYPE_NUMBER);

NEXUS:IncludePrefixed("sh_coms.lua");
NEXUS:IncludePrefixed("sv_hooks.lua");
NEXUS:IncludePrefixed("cl_hooks.lua");

nexus.config.ShareKey("intro_text_small");
nexus.config.ShareKey("intro_text_big");

nexus.flag.Add("T", "Trader", "Access to buy and sell scraps.");

-- A function to modify a physical description.
function NEXUS:ModifyPhysDesc(description)
	if ( string.find(description, "|") ) then
		description = string.gsub(description, "|", "/");
	end;
	
	if (string.len(description) <= 128) then
		if ( !string.find(string.sub(description, -2), "%p") ) then
			return description..".";
		else
			return description;
		end;
	else
		return string.sub(description, 1, 125).."...";
	end;
end;