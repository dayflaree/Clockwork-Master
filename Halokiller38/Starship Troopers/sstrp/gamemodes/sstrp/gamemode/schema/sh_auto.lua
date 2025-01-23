--[[
Name: "sh_auto.lua".
Product: "Starship Troopers".
--]]

-- Include our commands file (it isn't necessary to have a commands file).
NEXUS:IncludePrefixed("sh_coms.lua");
NEXUS:IncludePrefixed("sv_hooks.lua");
NEXUS:IncludePrefixed("cl_hooks.lua");


--nexus/gamemode/core/libraries/sh_schema.lua

nexus.schema.SetOption("default_date", {month = 12, year = 2012, day = 21}); -- Set the default date.
nexus.schema.SetOption("default_time", {minute = 0, hour = 0, day = 1}); -- Set the default time.
nexus.schema.SetOption("name_cash", "Credits"); -- Set the name of the cash in this schema.
nexus.schema.SetOption("model_cash", "models/props_lab/box01a.mdl"); -- Set the model of the cash in this schema.
nexus.schema.SetOption("format_cash", "%a %n"); -- Format cash, more complex. %a represents the amount and %n the name of the cash.
nexus.schema.SetOption("model_shipment", "models/items/item_item_crate.mdl"); -- Set the model of shipments in this schema.

-- Set the fonts.
nexus.schema.SetFont("chat_box_text", "sstrp_ChatBoxText");
nexus.schema.SetFont("target_id_text", "sstrp_TargetIDText");
nexus.schema.SetFont("menu_text_tiny", "sstrp_TargetIDText");
nexus.schema.SetFont("menu_text_small", "sstrp_TextSmall");

--	Format cash that is supposed to be on its own.
--	%a represents the amount and %n the name of the cash.

nexus.schema.SetOption("format_singular_cash", "%a"); 



-- Hmm, let's change the background color of any custom UI we use in our schema.
nexus.schema.SetColor( "background", Color(0, 0, 0, 192) );

-- Some donator weapon flags.
nexus.flag.Add("h", "HMG Weapon", "Access to 'Federation HMG' weapon.");
nexus.flag.Add("j", "Prototype BR2 Weapon", "Access to 'Federation Prototype BR2' weapon.");
nexus.flag.Add("v", "900k Weapon", "Access to 'Federation FW 900k' weapon.");
nexus.flag.Add("f", "Grenades", "Access to grenades.");
nexus.flag.Add("M", "Medical Equipment", "Access to standard medical equipment.");
nexus.flag.Add("R", "Regenerative Stimulants", "Access to precombat injections that increase overall health.");
nexus.flag.Add("K", "Medical Equipment", "Access to an additional layer of armor to provide increased protection.");
nexus.flag.Add("T", "KVK Sniper Weapon", "Access to 'KVK Sniper' Weapon.");


--	nexus/gamemode/core/libraries/sh_animation.lua

-- Add the special operations team model.
nexus.animation.AddCombineOverwatchModel("models/thespectatah/od.mdl");
local CombineModels = {
"models/mobinfi_soldier.mdl",
"models/mobinfi_soldier_prisonguar1.mdl",
"models/mobinfi_soldier_prisonguard.mdl",
"models/mobinfi_soldier_special_ops.mdl",
"models/mobinfi_spcops2.mdl",
"models/mobinfi_super_soldier.mdl",
"models/combine_sniperdp.mdl",
"models/Combine_digital.mdl",
"models/ia/ia.mdl",
"models/sundown.mdl",
}
for k, v in pairs(CombineModels) do
nexus.animation.AddCombineOverwatchModel(v)
end

-- Add the Mobile Police model.
nexus.animation.AddCivilProtectionModel("models/modile.mdl");

-- Default mobile infantry models.
nexus.animation.AddFemaleHumanModel("models/mobileinfantry/fmi_01.mdl");
nexus.animation.AddFemaleHumanModel("models/mobileinfantry/fmi_02.mdl");
nexus.animation.AddFemaleHumanModel("models/mobileinfantry/fmi_03.mdl");
nexus.animation.AddFemaleHumanModel("models/mobileinfantry/fmi_04.mdl");
nexus.animation.AddFemaleHumanModel("models/mobileinfantry/fmi_06.mdl");
nexus.animation.AddFemaleHumanModel("models/mobileinfantry/fmi_07.mdl");

nexus.animation.AddMaleHumanModel("models/mobileinfantry/mi_01.mdl");
nexus.animation.AddMaleHumanModel("models/mobileinfantry/mi_02.mdl");
nexus.animation.AddMaleHumanModel("models/mobileinfantry/mi_03.mdl");
nexus.animation.AddMaleHumanModel("models/mobileinfantry/mi_04.mdl");
nexus.animation.AddMaleHumanModel("models/mobileinfantry/mi_06.mdl");
nexus.animation.AddMaleHumanModel("models/mobileinfantry/mi_07.mdl");
nexus.animation.AddMaleHumanModel("models/mobileinfantry/mi_08.mdl");
nexus.animation.AddMaleHumanModel("models/mobileinfantry/mi_09.mdl");
nexus.animation.AddMaleHumanModel("models/mi_marine.mdl")

-- Mobile infantry medic models.
nexus.animation.AddFemaleHumanModel("models/mobileinfantry/fmi_m_01.mdl");
nexus.animation.AddFemaleHumanModel("models/mobileinfantry/fmi_m_02.mdl");
nexus.animation.AddFemaleHumanModel("models/mobileinfantry/fmi_m_03.mdl");
nexus.animation.AddFemaleHumanModel("models/mobileinfantry/fmi_m_04.mdl");
nexus.animation.AddFemaleHumanModel("models/mobileinfantry/fmi_m_06.mdl");
nexus.animation.AddFemaleHumanModel("models/mobileinfantry/fmi_m_07.mdl");

nexus.animation.AddMaleHumanModel("models/mobileinfantry/mi_m_01.mdl");
nexus.animation.AddMaleHumanModel("models/mobileinfantry/mi_m_02.mdl");
nexus.animation.AddMaleHumanModel("models/mobileinfantry/mi_m_03.mdl");
nexus.animation.AddMaleHumanModel("models/mobileinfantry/mi_m_04.mdl");
nexus.animation.AddMaleHumanModel("models/mobileinfantry/mi_m_06.mdl");
nexus.animation.AddMaleHumanModel("models/mobileinfantry/mi_m_07.mdl");
nexus.animation.AddMaleHumanModel("models/mobileinfantry/mi_m_08.mdl");
nexus.animation.AddMaleHumanModel("models/mobileinfantry/mi_m_09.mdl");