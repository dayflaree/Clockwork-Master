but tommy how do i use ur plugin?

First, open it up. You will see five folders.

If you don't know what you're doing, don't touch any folders except for "mixtures" and "items."

I've already created some mixtures for your server, feel free to delete them or keep them. It requires the items that I have already created. I actually recreated the items just for you guys, I didn't initially have the folder.

tommy how do i make new things!!!!!!!!!!!!!!
Spoiler
Simple.

The easiest way is to open an already created mixture, and edit the key features. For example:

Code:
local PLUGIN = PLUGIN;

local MIXTURE = {};

MIXTURE.ID = 'mixture_ziptie';
MIXTURE.Name = 'Zip Tie';
MIXTURE.Requires = {["Plastic Piece"] = 3};
MIXTURE.Produces = 'Zip Tie';
MIXTURE.Produces_Text = 'A man made plastic zip-tie.';
MIXTURE.RequiredEntity = "Forge"


function MIXTURE.CanMix ( Player )
    return true;
end

PLUGIN:RegisterMixture(MIXTURE);
Let's say you wanted to make a huge, purple dildo. To make it, you need one baby.

Change the key lines.

Code:
local PLUGIN = PLUGIN;

local MIXTURE = {};

MIXTURE.ID = 'mixture_purpledildo';
MIXTURE.Name = 'Purple Dildo';
MIXTURE.Requires = {["Baby"] = 1};
MIXTURE.Produces = 'Purple Dildo';
MIXTURE.Produces_Text = 'A huge, purple dildo.';


function MIXTURE.CanMix ( Player )
    return true;
end

PLUGIN:RegisterMixture(MIXTURE);

Now, of course with this, you now need to make a "Baby" item. The line in the mixture:

Code:
MIXTURE.Requires = {["Baby"] = 1};
Where it states, "Baby", that needs to be the same as what's in the quotes for this line in the item:
Code:
ITEM.name = "Baby";
Now, let's make our baby item.

Take a simple item:

Code:
local ITEM = Clockwork.item:New();
ITEM.name = "Cloth Piece";
ITEM.cost = 6;
ITEM.model = "models/props_junk/garbage_newspaper001a.mdl";
ITEM.weight = 0.1;
ITEM.business = false;
ITEM.description = "A light piece of cloth.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();
Now change the key features.

Code:
local ITEM = Clockwork.item:New();
ITEM.name = "Baby";
ITEM.cost = 6;
ITEM.model = "models/props_c17/doll01.mdl";
ITEM.weight = 9;
ITEM.business = false;
ITEM.description = "A fatass baby. Why is this in your backpack?";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();
Now, your large purple dildo can be created.
tommy how do i use ur crafting menu!!!!!!!!!!!!!!
Spoiler
For items to appear in the crafting menu, you first need the required items.

For example, your large purple dildo will not appear in the crafting menu until you have a baby.
tommy wtf is a forge or crafting table lol
Spoiler
A forge and a crafting table are entities that can be spawned in a map via /craftingtableadd and /forgeadd. Some items require a crafting table or a forge to create the item. This can be classified by this line in the mixture:

Code:
MIXTURE.RequiredEntity = "Forge"
Code:
MIXTURE.RequiredEntity = "Crafting Table"