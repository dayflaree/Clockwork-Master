local ITEM = {};

ITEM.name = "Cram";
ITEM.cost = 15;
ITEM.batch = 1;
ITEM.model = "models/Fallout 3/cram.mdl";
ITEM.weight = 0.2;
ITEM.access = "T";
ITEM.useText = "Eat";
ITEM.business = true;
ITEM.category = "Consumables"
ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
ITEM.uniqueID = "cram";
ITEM.description = "Mistress May is a fucker.";
ITEM.customFunctions = {"Give"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + DESIGN:GetHealAmount(player, 1.5), 0, player:GetMaxHealth() ) );
	
	blueprint.plugin.Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

blueprint.item.Register(ITEM);