local ITEM = {};
ITEM.derive = "item_base";
ITEM.name = "Generator";
ITEM.category = "Generators";
ITEM.model = "models/props_combine/combine_mine01.mdl";
ITEM.cost = 100;

function ITEM:OnUse(player)
	self:OnPurchase(player, player:EyeTrace(100));
end;

function ITEM:CanPurchase(player)
	local check = (player.numGenerators and player.numGenerators < RP.generator.max or !player.numGenerators)
	
	if (!check) then
		player:Notify("You have reached the maximum number of generators!");
	end;
	
	return check;
end;

function ITEM:OnPurchase(player, trace)
	local success, err = RP.generator:Create(player, "gen_basic");
	
	if (!success) then
		player:Notify(err);
	end;
end;

function ITEM:CustomDesc(descMeta)
	descMeta:Color(Color(255, 255, 255));
	descMeta:Text("Prints tons of cash");
end;

RP.Item:New(ITEM);