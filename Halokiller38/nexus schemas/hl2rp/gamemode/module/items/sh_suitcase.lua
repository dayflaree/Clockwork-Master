--[[
Name: "sh_suitcase.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.base = "weapon_base";
ITEM.name = "Suitcase";
ITEM.cost = 12;
ITEM.model = "models/weapons/w_suitcase_passenger.mdl";
ITEM.weight = 2;
ITEM.access = "1";
ITEM.business = true;
ITEM.category = "Reusables";
ITEM.uniqueID = "roleplay_suitcase";
ITEM.fakeWeapon = true;
ITEM.meleeWeapon = true;
ITEM.description = "Contains the usual stuff, spare clothes and some food.";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_R_Hand";
ITEM.attachmentOffsetAngles = Angle(0, 90, -10);
ITEM.attachmentOffsetVector = Vector(0, 0, 4);

-- A function to get whether the attachment is visible.
function ITEM:GetAttachmentVisible(player, entity)
	return (resistance.player.GetWeaponClass(player) == self.weaponClass);
end;

resistance.item.Register(ITEM);