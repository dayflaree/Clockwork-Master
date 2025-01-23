--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

for k, v in pairs( _file.Find("../models/pmc/pmc_4/*.mdl") ) do
	openAura.animation:AddMaleHumanModel("models/pmc/pmc_4/"..v);
end;

local groups = {34, 35, 36, 37, 38, 39, 40, 41};

for k, v in pairs(groups) do
	local groupName = "group"..v;
	
	for k2, v2 in pairs( _file.Find("../models/humans/"..groupName.."/*.*") ) do
		local fileName = string.lower(v2);
		
		if ( string.find(fileName, "female") ) then
			openAura.animation:AddFemaleHumanModel("models/humans/"..groupName.."/"..fileName);
		else
			openAura.animation:AddMaleHumanModel("models/humans/"..groupName.."/"..fileName);
		end;
	end;
end;

openAura.option:SetKey( "default_date", {month = 4, year = 1991, day = 26} );
openAura.option:SetKey( "default_time", {minute = 0, hour = 1, day = 0} );
openAura.option:SetKey("description_attributes", "Check on your character's stats.");
openAura.option:SetKey("description_inventory", "Manage the items in your inventory.");
openAura.option:SetKey("description_business", "Sell items to Civilians.");
openAura.option:SetKey("model_shipment", "models/props_junk/cardboard_box003b.mdl");
openAura.option:SetKey("intro_image", "genesis/genesis");
openAura.option:SetKey("name_attributes", "Stats");
openAura.option:SetKey("name_attribute", "Stat");
openAura.option:SetKey("name_inventory", "Inventory");
openAura.option:SetKey("menu_music", "/92inf_genesis/genesis_alone.mp3");
openAura.option:SetKey("name_business", "Trading");
openAura.option:SetKey("gradient", "severance/bg_gradient");


--Beginning of currency.
openAura.option:SetKey("format_singular_cash", "%a");
openAura.option:SetKey("model_cash", "models/avoxgaming/mrp/jake/props/ak_magazine.mdl");
openAura.option:SetKey("format_cash", "%a %n");
openAura.option:SetKey("name_cash", "Firing Pins");
--End


openAura.config:ShareKey("intro_text_small");
openAura.config:ShareKey("intro_text_big");

openAura.player:RegisterSharedVar("permaKilled", NWTYPE_BOOL, true);
openAura.player:RegisterSharedVar("clothes", NWTYPE_NUMBER, true);
openAura.player:RegisterSharedVar("hunger", NWTYPE_NUMBER, true);
openAura.player:RegisterSharedVar("tied", NWTYPE_NUMBER);

openAura:IncludePrefixed("sh_coms.lua");
openAura:IncludePrefixed("sv_hooks.lua");
openAura:IncludePrefixed("cl_hooks.lua");
openAura:IncludePrefixed("cl_theme.lua");

openAura.config:ShareKey("intro_text_small");
openAura.config:ShareKey("intro_text_big");

openAura.quiz:SetEnabled(true);
openAura.quiz:AddQuestion("Do you understand that roleplaying is slow paced and relaxed?", 1, "Yes.", "No.");
openAura.quiz:AddQuestion("Can you type properly, using capital letters and full-stops?", 2, "yes i can", "Yes, I can.");
openAura.quiz:AddQuestion("You do not need weapons to roleplay, do you understand?", 1, "Yes.", "No.");
openAura.quiz:AddQuestion("You do not need items to roleplay, do you understand?", 1, "Yes.", "No.");
openAura.quiz:AddQuestion("Do you understand that weapons will be rare and that this gamemode is focused on survival in the Zone?", 2, "wtf are you talking about i want to shoot shit", "Of course.");
openAura.quiz:AddQuestion("What do you think serious roleplaying is about?", 2, "Collecting items and upgrades.", "Developing your character.");
openAura.quiz:AddQuestion("Do you understand you require the content?", 2, "wat.", "Yes, I have it.");
openAura.quiz:AddQuestion("What universe is this roleplaying game set in?", 2, "Real Life.", "Chernobyl's exclusion Zone.");

openAura.flag:Add("T", "Trading", "Give civilians items.");