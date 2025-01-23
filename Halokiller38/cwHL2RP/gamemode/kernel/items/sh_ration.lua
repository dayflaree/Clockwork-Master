--[[
	Free Clockwork!
--]]

ITEM = Clockwork.item:New();
ITEM.batch = 1;
ITEM.name = "Ration";
ITEM.model = "models/weapons/w_package.mdl";
ITEM.weight = 2;
ITEM.useText = "Open";
ITEM.description = "A purple container with a cap sealed tight. It has an identification sticker with a barcode on it.";

ITEM:AddData("Name", "", true);
ITEM:AddQueryProxy("name", "Name", true);

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (Clockwork.schema:PlayerIsCombine(player)) then
		Clockwork.player:Notify(player, "You cannot open this ration!");
		
		return false;
	elseif (player:QueryCharacter("faction") == FACTION_CITYADMIN) then
		Clockwork.player:Notify(player, "You cannot open this ration!");
		return false;
	else
		Clockwork.player:GiveCash(player, 150, "ration packet");
		player:GiveItem(Clockwork.item:CreateInstance("citizen_supplements"), true);
		player:GiveItem(Clockwork.item:CreateInstance("breens_reserve"), true);
		player:GiveItem(Clockwork.item:CreateInstance("bandage"), true);
		player:GiveItem(Clockwork.item:CreateInstance("bandage"), true);
		player:GiveItem(Clockwork.item:CreateInstance("bandage"), true);
		Clockwork.plugin:Call("PlayerUseRation", player);
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

Clockwork.item:Register(ITEM);