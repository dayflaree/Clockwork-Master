--[[
Name: "sh_junk_base.lua".
Product: "New Vegas".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.name = "Junk Base";
ITEM.worth = 1;
ITEM.model = "models/props_junk/garbage_plasticbottle001a.mdl";
ITEM.weight = 0.1;
--ITEM.useText = "Caps";
ITEM.useSound = {"buttons/button5.wav", "buttons/button4.wav"};
ITEM.category = "Junk";
ITEM.isBaseItem = true;
ITEM.description = "A bottle with a white liquid inside.";

--[[ Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	openAura.player:GiveCash(player, self.worth, "scrapped some junk");
end;]]

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

openAura.item:Register(ITEM);