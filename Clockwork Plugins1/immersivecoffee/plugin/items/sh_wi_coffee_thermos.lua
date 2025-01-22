local ITEM = Clockwork.item:New();
ITEM.name = "Coffee Thermos";
ITEM.uniqueID = "wi_coffee_thermos";
ITEM.cost = 30;
ITEM.model = "models/props_canteen/vacuumflask01b.mdl";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.useText = "Pour";
ITEM.category = "UU-Branded Items";
ITEM.description = "A vacuum flask containing warm, fresh-brewed coffee.";

function ITEM:OnUse(player)
	player:GiveItem(Clockwork.item:CreateInstance("wi_coffee_black"));
	player:GiveItem(Clockwork.item:CreateInstance("wi_thermos_empty"));
end;

function ITEM:OnDrop(player, position) end;

ITEM:Register();