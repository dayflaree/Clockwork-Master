local ITEM = Clockwork.item:New("equipable_item_base");
ITEM.name = "Ski Mask";
ITEM.uniqueID = "headwear_skimask";
ITEM.model = "models/mask.mdl";
ITEM.weight = 0.1;
ITEM.description = "A woolen ski mask with a singular eyehole. Wearing it is fairly effective at concealing your identity, as well as keeping you protected from the elements.";

ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_Head1";
ITEM.attachmentOffsetAngles = Angle(-90, 28.475, 14.239);
ITEM.attachmentOffsetVector = Vector(-6.873, 3.19, 0);

ITEM:Register();