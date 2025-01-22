
local Clockwork = Clockwork;

-- Sceen overlay texture files
Clockwork.kernel:AddFile("materials/effects/gasmask_screen_1.vtf");
Clockwork.kernel:AddFile("materials/effects/gasmask_screen_2.vtf");
Clockwork.kernel:AddFile("materials/effects/gasmask_screen_3.vtf");
Clockwork.kernel:AddFile("materials/effects/gasmask_screen_4.vtf");

Clockwork.hint:Add("Durability", "Your suit degrades as it takes damage. Don't forget to repair it.");
Clockwork.hint:Add("Gasmask", "Gasmasks need a filter to provide protection against toxic gasses.");
Clockwork.hint:Add("Protection", "Better armor provides more damage reduction, regardless of durability.");

function PLUGIN:SaveClothesArmor(player)
	local clothes = player:GetClothesItem();
	
	if (clothes and clothes:GetData("armor")) then
		clothes:SetData("armor", math.Clamp(player:Armor(), 0, clothes("maxArmor", 0)));
	end;

	local items = player:GetInventory();

	for k, itemList in pairs(items) do
		for k, item in pairs(itemList) do
			if (!item:IsBasedFrom("filter_base")) then
				break;
			elseif (item:GetData("equipped")) then
				item:SetData("filterQuality", math.Clamp(math.Round(player:GetCharacterData("filterQuality"), 5), 0, item("maxFilterQuality")));
				return;
			end;
		end;
	end;
end;