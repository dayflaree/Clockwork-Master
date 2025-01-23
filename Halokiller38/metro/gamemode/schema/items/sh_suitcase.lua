--[[
Name: "sh_suitcase.lua".
Product: "Cider Two".
--]]

ITEM = openAura.item:New();
ITEM.batch = 1;
ITEM.base = "weapon_base";
ITEM.name = "Suitcase";
ITEM.cost = 6;
ITEM.model = "models/weapons/w_suitcase_passenger.mdl";
ITEM.weight = 1;
ITEM.category = "Reusables";
ITEM.uniqueID = "aura_suitcase";
ITEM.business = true;
ITEM.access = "U";
ITEM.meleeWeapon = true;
ITEM.description = "It doesn't do anything, but it looks cool, right?";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_R_Hand";
ITEM.attachmentOffsetAngles = Angle(0, 90, -10);
ITEM.attachmentOffsetVector = Vector(0, 0, 4);

-- A function to get whether the attachment is visible.
function ITEM:GetAttachmentVisible(player, entity)
	return (openAura.player:GetWeaponClass(player) == self.weaponClass);
end;

openAura.item:Register(ITEM);