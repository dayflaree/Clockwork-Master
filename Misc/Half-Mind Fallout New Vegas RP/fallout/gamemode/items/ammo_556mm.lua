ITEM.Name = "5.56x45mm Rounds";
ITEM.Desc = "Ammunition for firearms chambered in 5.56x45mm.";
ITEM.Model = "models/maxibammo/556.mdl";

ITEM.W = 1;
ITEM.H = 1;
ITEM.Stackable = true;
ITEM.StackLimit = 200;
ITEM.Category = CATEGORY_AMMO;
ITEM.BasePrice = 999;
ITEM.Vars.Ammo = 60;

function ITEM:GetDesc( item )
	
	local str = "Ammunition for firearms chambered in 5.56x45mm.\n\n";
	str = str .. "There are " .. item.Vars.Ammo .. " rounds left.";
	
	return str;
	
end