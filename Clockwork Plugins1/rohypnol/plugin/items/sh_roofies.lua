local ITEM = Clockwork.item:New();
ITEM.name = "Rohypnol";
ITEM.cost = 30;
ITEM.model = "models/props_lab/jar01b.mdl";
ITEM.weight = 0.2;
ITEM.access = "q";
ITEM.useText = "Spike Drink";
ITEM.category = "Drugs";
ITEM.business = true;
ITEM.description = "A small jar containing Flunitrazepam in the form of pills.  Capable of spiking a drink when dioluted.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)				
	if (player:FindItemByID("beer")) then
		local itemTable = player:FindItemByID("beer");
		player:ProgressAttribute(ATB_DEXTERITY, 15, true);
		player:GiveItem(Clockwork.item:CreateInstance("roofie_beer"));
		Clockwork.player:Notify(player, "You have spiked the Beer with Rohypnol!");
		player:TakeItem(itemTable);
		player:TakeItem(self);
		return true
	elseif (player:FindItemByID("normal_coffee")) then
		local itemTable = player:FindItemByID("normal_coffee");
		player:ProgressAttribute(ATB_DEXTERITY, 15, true);
		player:GiveItem(Clockwork.item:CreateInstance("roofie_coffee"));
		Clockwork.player:Notify(player, "You have spiked the Coffee with Rohypnol!");
		player:TakeItem(itemTable);
		player:TakeItem(self);
		return true
	elseif (player:FindItemByID("canned_water")) then
		local itemTable = player:FindItemByID("canned_water");
		player:ProgressAttribute(ATB_DEXTERITY, 15, true);
		player:GiveItem(Clockwork.item:CreateInstance("roofie_water"));
		Clockwork.player:Notify(player, "You have spiked the Water with Rohypnol!");
		player:TakeItem(itemTable);
		player:TakeItem(self);
		return true
	else
		Clockwork.player:Notify(player, "You don't have a drink that you can spike!");
		return false
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();