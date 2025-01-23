local ITEM = {}

ITEM.Name = "Vodka"
ITEM.UniqueName = "vodka"
ITEM.Icon = "drink"
ITEM.Description = "Gets you trashed."
ITEM.Author = "_Undefined"
ITEM.Date = "16th August 2009"
ITEM.Model = "models/props_junk/garbage_glassbottle002a.mdl"
ITEM.ClassName = ""
ITEM.Price = 10
ITEM.RemoveOnUse = true
ITEM.Modes = {TEAM_RP, TEAM_BUILD}

if SERVER then
	function Drunk(ply)
		ply:ConCommand("pp_motionblur 1")
		ply:ConCommand("pp_motionblur_addalpha " .. 0.05)
		ply:ConCommand("pp_motionblur_delay " .. 0.035)
		ply:ConCommand("pp_motionblur_drawalpha 1.00")
		ply:ConCommand("pp_dof 1")
		ply:ConCommand("pp_dof_initlength 9")
		ply:ConCommand("pp_dof_spacing 8")
		timer.Simple(40, function() ply:ConCommand("pp_motionblur 0") ply:ConCommand("pp_dof 0") end)
	end
	
	function ITEM:Use(ply)
		GAMEMODE:BarmanSpeak("You downed a bottle of Vodka? Dipshit.", ply)
		Drunk(ply)
	end
end

INVENTORY:RegisterItem(ITEM)