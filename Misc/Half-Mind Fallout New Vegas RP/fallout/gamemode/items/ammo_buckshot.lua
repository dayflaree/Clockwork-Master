ITEM.Name = "12x70 Buckshot";
ITEM.Desc = "Ammunition for tube-fed firearms.";
ITEM.Model = "models/maxibammo/buckshot.mdl";

ITEM.W = 1;
ITEM.H = 1;
ITEM.Stackable = true;
ITEM.StackLimit = 200;
ITEM.Category = CATEGORY_AMMO;
ITEM.BasePrice = 999;
ITEM.Vars.Ammo = 12;

function ITEM:GetDesc( item )
	
	local str = "Ammunition for tube-fed firearms.\n\n";
	str = str .. "There are " .. item.Vars.Ammo .. " rounds left.";
	
	return str;
	
end