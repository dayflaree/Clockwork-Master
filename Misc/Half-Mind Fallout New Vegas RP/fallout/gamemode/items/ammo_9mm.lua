ITEM.Name = "9x19mm Rounds";
ITEM.Desc = "Ammunition for firearms chambered in 9x19mm.";
ITEM.Model = "models/maxibammo/9mm.mdl";

ITEM.W = 1;
ITEM.H = 1;
ITEM.Stackable = true;
ITEM.StackLimit = 200;
ITEM.Category = CATEGORY_AMMO;
ITEM.BasePrice = 999;
ITEM.Vars.Ammo = 30;

function ITEM:GetDesc( item )
	
	local str = "Ammunition for firearms chambered in 9x19mm.\n\n";
	str = str .. "There are " .. item.Vars.Ammo .. " rounds left.";
	
	return str;
	
end