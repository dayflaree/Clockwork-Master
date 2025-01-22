local ITEM = Clockwork.item:New();
ITEM.name = "Empty Thermos";
ITEM.uniqueID = "wi_thermos_empty";
ITEM.cost = 30;
ITEM.model = "models/props_canteen/vacuumflask01b.mdl";
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.useText = "Pour";
ITEM.category = "UU-Branded Items";
ITEM.description = "A vacuum flask containing warm, fresh-brewedcoffee.";

function ITEM:OnDrop(player, position) end;

ITEM:Register();