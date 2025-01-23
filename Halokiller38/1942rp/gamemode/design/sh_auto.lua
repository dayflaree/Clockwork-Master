--[[
Name: "sh_auto.lua".
Product: "Day One".
--]]

for k, v in pairs( {34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 97} ) do
	local groupName = "group"..v;
	
	for k2, v2 in pairs( g_File.Find("../models/humans/"..groupName.."/*.*") ) do
		local fileName = string.lower(v2);
		
		if ( string.find(fileName, "female") ) then
			blueprint.animation.AddFemaleHumanModel("models/humans/"..groupName.."/"..fileName);
		else
			blueprint.animation.AddMaleHumanModel("models/humans/"..groupName.."/"..fileName);
		end;
	end;
end;

blueprint.design.SetOption( "default_date", {month = 4, year = 1942, day = 1} );
blueprint.design.SetOption( "default_time", {minute = 0, hour = 6, day = 1} );
blueprint.design.SetOption("description_inventory", "Manage the items amongst your belongings.");
blueprint.design.SetOption("description_business", "Buy and sell scraps with your outside contacts.");
blueprint.design.SetOption("format_singular_cash", "%a");
blueprint.design.SetOption("html_background", "http://i.imgur.com/tywaO.gif");
blueprint.design.SetOption("model_shipment", "models/props_junk/cardboard_box003b.mdl");
blueprint.design.SetOption("name_inventory", "Belongings");
blueprint.design.SetOption("name_business", "Trading");
blueprint.design.SetOption("intro_image", "1942rp_intro/1942rp_intro");
blueprint.design.SetOption("model_cash", "models/reichsmarks/50 reichsmarks note bundle.mdl");
blueprint.design.SetOption("menu_music", "1942rp/1942rp_intro.wav");
blueprint.design.SetOption("format_cash", "%a %n");
blueprint.design.SetOption("name_cash", "Reichsmarks");
blueprint.design.SetOption("gradient", "1942rp_intro/background");

blueprint.config.ShareKey("intro_text_small");
blueprint.config.ShareKey("intro_text_big");

blueprint.design.SetColor( "information", Color(165, 155, 95, 255) );

blueprint.design.SetFont("bar_text", "nov_TargetIDText");
blueprint.design.SetFont("main_text", "nov_MainText");
blueprint.design.SetFont("hints_text", "nov_IntroTextTiny");
blueprint.design.SetFont("large_3d_2d", "nov_Large3D2D");
blueprint.design.SetFont("chat_box_text", "nov_ChatBoxText");
blueprint.design.SetFont("target_id_text", "nov_TargetIDText");
blueprint.design.SetFont("cinematic_text", "nov_CinematicText");
blueprint.design.SetFont("date_time_text", "nov_IntroTextSmall");
blueprint.design.SetFont("menu_text_big", "nov_MenuTextBig");
blueprint.design.SetFont("menu_text_huge", "nov_MenuTextHuge");
blueprint.design.SetFont("menu_text_tiny", "nov_IntroTextTiny");
blueprint.design.SetFont("intro_text_big", "nov_IntroTextBig");
blueprint.design.SetFont("menu_text_small", "nov_IntroTextSmall");
blueprint.design.SetFont("intro_text_tiny", "nov_IntroTextTiny");
blueprint.design.SetFont("intro_text_small", "nov_IntroTextSmall");
blueprint.design.SetFont("player_info_text", "nov_ChatBoxText");

blueprint.player.RegisterSharedVar("sh_PermaKilled", NWTYPE_BOOL, true);
blueprint.player.RegisterSharedVar("sh_Tied", NWTYPE_NUMBER);

BLUEPRINT:IncludePrefixed("sh_coms.lua");
BLUEPRINT:IncludePrefixed("sv_hooks.lua");
BLUEPRINT:IncludePrefixed("cl_hooks.lua");

blueprint.config.ShareKey("intro_text_small");
blueprint.config.ShareKey("intro_text_big");

blueprint.flag.Add("T", "Trader", "Access to buy and sell scraps.");

-- A function to modify a physical description.
function BLUEPRINT:ModifyPhysDesc(description)
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