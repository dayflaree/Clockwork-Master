local ITEM = Clockwork.item:New("consumable_base");
ITEM.name = "UU-Branded Cookie";
ITEM.uniqueID = "uu_cookie";
ITEM.cost = 20;
ITEM.model = "models/freeman/cookie.mdl";
ITEM.weight = 0.2;
ITEM.health = 2;
ITEM.hunger = 10;
ITEM.access = "u";
ITEM.business = true;
ITEM.category = "UU-Branded Items";
ITEM.description = "A small cookie, packaged and adorned with the UU Brand, the label reading 'Pryce's Cookies'. There is absolutely no crunch to them as they are soft, with the chocolate having a strange aftertaste (lead maybe?). Either way, they do smell of delicious Union bias.";

ITEM:Register();