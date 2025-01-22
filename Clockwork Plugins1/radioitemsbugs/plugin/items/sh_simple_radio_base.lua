
local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "Simple Radio Base";
ITEM.uniqueID = "simple_radio_base";
ITEM.model = "models/deadbodies/dead_male_civilian_radio.mdl";
ITEM.weight = 1;
ITEM.business = false;
ITEM.useText = "Toggle On/Off";
ITEM.category = "Communication";
ITEM.description = "A simple handheld radio.";

ITEM.frequency = "main";
ITEM.frequencyID = "freq_main";
--ITEM.frequencySound = "npc/overwatch/radiovoice/off2.wav";
--ITEM.frequencyColor = Color(200, 0, 0);
--ITEM.frequencyPriority = 4;
--ITEM.stationaryCanAccess = true;

ITEM:AddData("On", true, true);

function ITEM:OnUse(player, entity)
	self:SetData("On", not self:GetData("On"));
	Clockwork.radio:SetPlayerChannels(player);

	return false;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (CLIENT) then
	function ITEM:GetClientSideInfo()
		if (!self:IsInstance()) then return; end;

		local clientSideInfo = "";
		
		if (self:GetData("On")) then
			clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "This radio is turned on.");
		else
			clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "This radio is turned off.");
		end;
		
		return (clientSideInfo != "" and clientSideInfo);
	end;
end;

ITEM:Register();