--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]
--[[
for k, v in pairs( _file.Find("models/pmc/pmc_4/*.mdl",true) ) do
	openAura.animation:AddMaleHumanModel("models/pmc/pmc_4/"..v);
end;
--]]
local groups = {34, 35, 36, 37, 38, 39, 40, 41};

for k, v in pairs(groups) do
	local groupName = "group"..v;
	
	for k2, v2 in pairs( _file.Find("models/humans/"..groupName.."/*.*",true) ) do
		local fileName = string.lower(v2);
		
		if ( string.find(fileName, "female") ) then
			openAura.animation:AddFemaleHumanModel("models/humans/"..groupName.."/"..fileName);
		else
			openAura.animation:AddMaleHumanModel("models/humans/"..groupName.."/"..fileName);
		end;
	end;
end;

--[[
openAura.animation:AddMaleHumanModel("models/ghoul/slow.mdl");
openAura.animation:AddMaleHumanModel("models/tactical_rebel.mdl");
openAura.animation:AddMaleHumanModel("models/power_armor/slow.mdl");
openAura.animation:AddMaleHumanModel("models/quake4pm/quakencr.mdl");
--]]

openAura.option:SetKey( "default_date", {month = 8, year = 2034, day = 16} );
openAura.option:SetKey( "default_time", {minute = 0, hour = 0, day = 16} );
openAura.option:SetKey("description_attributes", "Check on your character's stats.");
openAura.option:SetKey("description_inventory", "Manage the items in your Inventory.");
openAura.option:SetKey("description_business", "Trade a variety of items.");
openAura.option:SetKey("model_shipment", "models/props_junk/cardboard_box003b.mdl");
openAura.option:SetKey("intro_image", "severance/avox_intro2");
openAura.option:SetKey("name_attributes", "Stats");
openAura.option:SetKey("name_attribute", "Stat");
openAura.option:SetKey("name_inventory", "Inventory");
openAura.option:SetKey("menu_music", "/avoxgaming/intro4.mp3");
openAura.option:SetKey("name_business", "Trade");
openAura.option:SetKey("gradient", "severance/bg_gradient");
openAura.option:SetKey("top_bars", true);

openAura.option:SetKey("format_singular_cash", "%a");
openAura.option:SetKey("model_cash", "models/avoxgaming/mrp/jake/props/ak_magazine.mdl");
openAura.option:SetKey("format_cash", "%a %n");
openAura.option:SetKey("name_cash", "Bullets");

openAura.config:ShareKey("intro_text_small");
openAura.config:ShareKey("intro_text_big");

openAura.option:SetSound("click_release", "/avoxgaming/interface/inv_properties.wav");
openAura.option:SetSound("rollover", "ui/buttonrollover.wav");
openAura.option:SetSound("click", "buttons/lightswitch2.wav");

openAura.player:RegisterSharedVar("permaKilled", NWTYPE_BOOL, true);
openAura.player:RegisterSharedVar("clothes", NWTYPE_NUMBER, true);
openAura.player:RegisterSharedVar("hunger", NWTYPE_NUMBER, true);
openAura.player:RegisterSharedVar("customClass", NWTYPE_STRING);
openAura.player:RegisterSharedVar("tied", NWTYPE_NUMBER);

openAura:IncludePrefixed("sh_coms.lua");
openAura:IncludePrefixed("sv_hooks.lua");
openAura:IncludePrefixed("cl_hooks.lua");
openAura:IncludePrefixed("cl_theme.lua");

openAura.config:ShareKey("intro_text_small");
openAura.config:ShareKey("intro_text_big");

openAura.quiz:SetEnabled(true);
openAura.quiz:AddQuestion("I know that because of the logs, I will never get away with rule-breaking.", 1, "Yes.", "No.");
openAura.quiz:AddQuestion("I understand that the script has vast logs that are checked often.", 1, "Yes.", "No.");
openAura.quiz:AddQuestion("Do you understand that roleplaying is slow paced and relaxed?", 1, "Yes.", "No.");
openAura.quiz:AddQuestion("Can you type properly, using capital letters and full-stops?", 2, "yes i can!!", "Yes, I can.");
openAura.quiz:AddQuestion("When creating a character, I will use a full and appropriate name.", 1, "Yes.", "No.");
openAura.quiz:AddQuestion("Do you understand that you will have to FearRP alot in this roleplay universe?", 2, "No.", "Yes.");
openAura.quiz:AddQuestion("I will read the directory in the main menu for help and guides.", 1, "Yes.", "No.");
openAura.quiz:AddQuestion("What do you think serious roleplaying is about?", 2, "Collecting items and upgrades.", "Developing your character.");
openAura.quiz:AddQuestion("What universe is this roleplaying game set in?", 2, "Real Life.", "Metro 2033.");

openAura.flag:Add("T", "Common Trader", "Access to trade equipment for Bullets.");
openAura.flag:Add("y", "Distribution", "Access to distribute items around the map.");
openAura.flag:Add("M", "Medical Trader", "Access to trade Medical items.");
openAura.flag:Add("L", "Light Weapon Trader", "Access to trade Light Weapons.");
openAura.flag:Add("H", "Heavy Weapon Trader", "Access to trade Heavy Weapons.");
openAura.flag:Add("4", "Heavy Weapon Trader2", "Access to trade rare Heavy Weapons.");
openAura.flag:Add("A", "Ammo Trader", "Access to trade ammo.");
openAura.flag:Add("5", "Communist Leader", "Communist Leader");
openAura.flag:Add("6", "Stalker Leader", "Stalker Leader");
openAura.flag:Add("8", "Bandit Leader", "Bandit Leader");
openAura.flag:Add("9", "4th Reich Leader", "4th Reich Leader");
openAura.flag:Add("7", "Ranger Leader", "Ranger Leader");
openAura.flag:Add("3", "Book Trader", "Access to buy Books.");
openAura.flag:Add("U", "Suit Trader", "Trading Uniforms.");
openAura.flag:Add("2", "Extra / Event", "Extra / Event");