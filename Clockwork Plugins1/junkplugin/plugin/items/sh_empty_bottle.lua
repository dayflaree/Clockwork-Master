local ITEM = Clockwork.item:New();
ITEM.name = "Empty Glass Bottle";
ITEM.uniqueID = "empty_bottle";
ITEM.cost = 8;
ITEM.spawnType = "junk";
ITEM.spawnValue = 30;
ITEM.model = "models/props_junk/garbage_glassbottle002a.mdl";
ITEM.weight = 0.5;
ITEM.access = "jM";
ITEM.category = "Junk";
ITEM.business = false;
ITEM.description = "An empty glass bottle.";
ITEM.useText = "Fill";
ITEM.useSound = "player/footsteps/slosh3.wav";

function ITEM:OnUse(player, name)
	if (player:WaterLevel() >= 1) then
		player:GiveItem(Clockwork.item:CreateInstance("water_dirty"), true);
       	player:TakeItem(self);
    else
        Clockwork.player:Notify(player, "You must be standing in water to fill a bottle!");

        return true;
    end;
end;

function ITEM:OnDrop(player, position) end;

ITEM:Register();