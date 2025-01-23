--[[
Name: "sh_auto.lua".
Product: "Skeleton".
--]]

-- Include our commands file (it isn't necessary to have a commands file).
RESISTANCE:IncludePrefixed("sh_coms.lua");

--[[
	We'd usually add some animations to NPC models here.
	As we're not using any for this script, I won't bother
	but check out the list of functions you can use at:
		resistance/gamemode/core/libraries/sh_animation.lua
		
	resistance.animation.AddCivilProtectionModel("models/eliteghostcp.mdl");
--]]

--[[
	Lets set some module settings here to customise it a bit.
	You can find all the possible module settings at:
		resistance/gamemode/core/libraries/sh_module.lua
--]]
resistance.module.SetOption( "default_date", {month = 12, year = 2012, day = 21} ); -- Set the default date.
resistance.module.SetOption( "default_time", {minute = 0, hour = 0, day = 1} ); -- Set the default time.
resistance.module.SetOption("name_cash", "Jellybabies"); -- Set the name of the cash in this module.
resistance.module.SetOption("model_cash", "models/props_lab/box01a.mdl"); -- Set the model of the cash in this module.
resistance.module.SetOption("format_cash", "%a %n"); -- Format cash, more complex. %a represents the amount and %n the name of the cash.
resistance.module.SetOption("model_shipment", "models/items/item_item_crate.mdl"); -- Set the model of shipments in this module.
resistance.module.SetOption("intro_image", "skeleton/logo"); -- Set the path to the module's intro image (not necessary).
--[[
	Format cash that is supposed to be on its own.
	%a represents the amount and %n the name of the cash.
-]]
resistance.module.SetOption("format_singular_cash", "%a");

-- Hmm, let's change the background color of any custom UI we use in our module.
resistance.module.SetColor( "background", Color(0, 0, 0, 192) );

--[[
	Lets enable the quiz in our module, and set some questions and answers.
	You can find all the possible quiz functions at:
		resistance/gamemode/core/libraries/sh_quiz.lua
--]]
resistance.quiz.SetEnabled(true);
resistance.quiz.AddQuestion("Do you like to roleplay?", 1, "Yes.", "No.");
resistance.quiz.AddQuestion("Is resistance a good framework?", 1, "Yes.", "No.");

--[[
	If you noticed, we set a few of our items to use M access. That meant that
	only players with M access can see that item in their business menu. Let's define
	our new M flag so the script can tell it exists.
--]]
resistance.flag.Add("M", "Merchanteer", "This flag gives players access to some basic items.");