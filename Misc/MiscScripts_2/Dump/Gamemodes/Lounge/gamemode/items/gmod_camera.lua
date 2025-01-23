local ITEM = {}

ITEM.Name = "Camera" // Name of the item.
ITEM.UniqueName = "gmod_camera" // Unique name of the item.
ITEM.Icon = "camera" // Items Icon.
ITEM.Description = "Take pictures." // Short description. (SHORT!)
ITEM.Author = "_Undefined" // Who made it.
ITEM.Date = "16th August 2009" // When.
ITEM.Model = "models/weapons/w_camphone.mdl" // Model of the item.
ITEM.Skin = 0
ITEM.ClassName = "" // Set this to the entity name if this is not just a prop, for example, 'weapon_crowbar'.
ITEM.Price = 20 // How much the item costs.
ITEM.RemoveOnUse = true // Whether to remove the item when it is used.
ITEM.Modes = {TEAM_RP, TEAM_BUILD}

if SERVER then
	function ITEM:Use(ply)
		ply:Give("gmod_camera")
	end
end

INVENTORY:RegisterItem(ITEM) // Register the Item.