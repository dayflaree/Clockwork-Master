
local ITEM = {};

ITEM.name = "Rifle Ammunition - 7.62x39mm"; -- The name of the item, obviously.
ITEM.cost = 20; -- How much does this item cost for people with business access to it?
ITEM.model = "models/items/boxsrounds.mdl"; -- What model does the item use.
ITEM.weight = 1; -- How much does it weigh in kg?
ITEM.access = "b"; -- What flags do you need to have access to this item in your business menu (you only need one of them)?
ITEM.useText = "Equip"; -- What does the text say instead of Use, remove this line to keep it as Use.
ITEM.category = "Ammunition"; -- What category does the item belong in?
ITEM.uniqueID = "ammo_rifle";  -- Optionally, you can manually set a unique ID for an item, but usually you don't need to.
ITEM.business = true;  -- Is this item available on the business menu (if the player has access to it)?
ITEM.description = "A box containing five general purpose morita magazines. Or it can contain one large HMG ammo box. Your call.";
  -- Give a small description of the item.
function ITEM:OnDrop(player, position)
	-- If the item doesn't have this function, it cannot be dropped.
end;


function ITEM:OnUse(player, itemEntity)
player:GiveAmmo( 150, "smg1") -- honestly fuck kuro's system of doing ammo this is a bitch
end;

function ITEM:OnDestroy(player)
	-- If the item doesn't have this function, it cannot be destroyed.
end;
-- Register the item to the nexus framework.
nexus.item.Register(ITEM);