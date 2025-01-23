local ITEM = {}

ITEM.Name = "Beer" // Name of the item.
ITEM.UniqueName = "beer" // Unique name of the item.
ITEM.Icon = "drink" // Items Icon.
ITEM.Description = "Down a few to get lary." // Short description. (SHORT!)
ITEM.Author = "_Undefined" // Who made it.
ITEM.Date = "16th August 2009" // When.
ITEM.Model = "models/props_junk/garbage_glassbottle001a.mdl" // Model of the item. Doesn't need setting if using the line below.
ITEM.Skin = 0 // Should this model use a different skin?
ITEM.ClassName = "" // Set this to the entity name if this is not just a prop, for example, 'weapon_crowbar'.
ITEM.Price = 3 // How much the item costs.
ITEM.RemoveOnUse = true // Whether to remove the item when it is used.
ITEM.Modes = {TEAM_RP, TEAM_BUILD} // Set where this item can be used.

if SERVER then
	function Drunk(ply)
		ply:ConCommand("pp_motionblur 1")
		ply:ConCommand("pp_motionblur_addalpha " .. 0.05)
		ply:ConCommand("pp_motionblur_delay " .. 0.035)
		ply:ConCommand("pp_motionblur_drawalpha 1.00")
		ply:ConCommand("pp_dof 1")
		ply:ConCommand("pp_dof_initlength 9")
		ply:ConCommand("pp_dof_spacing 8")
		timer.Simple(10, function() ply:ConCommand("pp_motionblur 0") ply:ConCommand("pp_dof 0") end)
	end
	
	function ITEM:Use(ply)
		GAMEMODE:BarmanSpeak("How about another?", ply)
		Drunk(ply)
	end	
end

INVENTORY:RegisterItem(ITEM) // Register the Item.