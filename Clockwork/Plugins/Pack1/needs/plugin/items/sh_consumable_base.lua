
local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "Consumable Base";
ITEM.uniqueID = "consumable_base";
ITEM.description = "A box full of yummies!";
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl";
ITEM.useText = "Consume";
ITEM.weight = 1;
ITEM.hunger = 0;
ITEM.thirst = 0;
ITEM.health = 0;
ITEM.damage = 0;
ITEM.drunkTime = 0;
ITEM.junk = nil;
ITEM.cost = 10;
ITEM.business = false;
ITEM.category = "Consumables";
ITEM.useSound = {"npc/barnacle/barnacle_crunch3.wav", "npc/barnacle/barnacle_crunch2.wav"};
ITEM.customFunctions = {"Empty"};

function ITEM:OnCustomFunction(player, name)
	if (name == "Empty") then
		player:TakeItem(self);

		if (self("junk") and type(self("junk")) == "string") then
			local item = Clockwork.item:CreateInstance(self("junk"))
			item.model = self( "model" );
			item.skin = self( "skin" );

			if (item) then
				player:GiveItem(item, true);
			else
				ErrorNoHalt("[Error] Consumable "..self("name").." attempted to give unexisting junk item "..self("junk")..".\n");
			end;
		end;
	end;
end;

function ITEM:GetCost()
	return math.max(math.Round(((self("hunger") + self("thirst")) * 8 / 90 + 10 / 9) * 3), 2);
end;
ITEM:AddQueryProxy("cost", ITEM.GetCost);

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (self("thirst", 0) > 0) then
		player:SetCharacterData("thirst", math.Clamp(player:GetCharacterData("thirst", 0) - self("thirst"), 0, 100));
	end;
	if (self("hunger", 0) > 0) then
		player:SetCharacterData("hunger", math.Clamp(player:GetCharacterData("hunger", 0) - self("hunger"), 0, 100));
	end;
	if (self("health", 0) > 0) then
		player:SetHealth(math.Clamp(player:Health() + self("health"), 0, player:GetMaxHealth()));
	end;
	if (self("damage", 0) > 0) then
		player:TakeDamage(damage, player, player)
	end;
		
	if (self("drunkTime", 0) > 0) then
		Clockwork.player:SetDrunk(player, self("drunkTime"));
	end;
	
	if (self("junk") and type(self("junk")) == "string") then
		local item = Clockwork.item:CreateInstance(self("junk"))
		item.model = self( "model" );
		item.skin = self( "skin" );
		if (item) then
			player:GiveItem(item, true);
		else
			ErrorNoHalt("[Error] Consumable "..self("name").." attempted to give unexisting junk item "..self("junk")..".\n");
		end;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

-- Called when the item's functions should be edited.
function ITEM:OnEditFunctions(functions)
	if (Schema:PlayerIsCombine(Clockwork.Client, false)) then
		for k, v in pairs(functions) do
			if (v == "Drink") then functions[k] = nil; end;
		end;
	end;
end;

ITEM:Register();