local ITEM = Clockwork.item:New();
ITEM.name = "Charcoal";
ITEM.spawnValue = 26;
ITEM.spawnType = "crafting";
ITEM.model = "models/props_debris/concrete_chunk05g.mdl";
ITEM.weight = 0.1;
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "An old bag with refined Charcoal.";

function ITEM:OnDrop(player, position) end;

	-- Called when the item entity has spawned.
	function ITEM:OnEntitySpawned(entity)
		entity:SetMaterial("models/props_foliage/tree_deciduous_01a_trunk");
	end;

ITEM:Register();