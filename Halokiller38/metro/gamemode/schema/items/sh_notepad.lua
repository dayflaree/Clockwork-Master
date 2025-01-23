--[[
Name: "sh_notepad.lua".
Product: "Cider Two".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.name = "Notepad";
ITEM.cost = 10;
ITEM.model = "models/props_lab/clipboard.mdl";
ITEM.weight = 0.2;
ITEM.useText = "Edit";
ITEM.business = true;
ITEM.category = "Reusables";
ITEM.description = "A clean and professional notepad with a cardboard backing.";
ITEM.access = "y";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	openAura:StartDataStream(player, "Notepad", player:GetCharacterData("notepad") or "");
	
	openAura.player:SetMenuOpen(player, false);
	
	return false;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

openAura.item:Register(ITEM);