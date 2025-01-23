--[[
Name: "sh_chinese_takeout.lua".
Product: "Skeleton".
--]]

--[[
	There are so many more options to choose from to customise your item to the maximum.
	But I cannot really document it fully, so make sure to check the entire nexus framework
	for cool little tricks and variables you can use with your items.
--]]

-- Create a table to store our item in.
local ITEM = {};

ITEM.name = "First Aid Kit"; -- The name of the item, obviously.
ITEM.cost = 10; -- How much does this item cost for people with business access to it?
ITEM.model = "models/Items/HealthKit.mdl"; -- What model does the item use.
ITEM.weight = 0.5; -- How much does it weigh in kg?
ITEM.access = "b"; -- What flags do you need to have access to this item in your business menu (you only need one of them)?
ITEM.useText = "Use"; -- What does the text say instead of Use, remove this line to keep it as Use.
ITEM.category = "Medical Supplies"; -- What category does the item belong in?
ITEM.business = true; -- Is this item available on the business menu (if the player has access to it)?
ITEM.description = "Hold near patient then press actuator";

--[[
	Called when a player uses the item.
	This is for people who know what they're doing, check out
	the nexus framework for a complete list of libraries and functions.
--]]
function ITEM:OnUse(player, itemEntity)
	if (!itemEntity) then return false; end;
	
	local ragdolls = {};
	local entities = ents.FindInSphere(itemEntity:GetPos(), 30);

	for k, v in pairs(entities) do
		local class = v:GetClass();
	
		if (IsValid(v) and class == "prop_ragdoll" and nexus.entity.IsPlayerRagdoll(v)) then
			table.insert(ragdolls, v);
		end;
	end;

	if (#ragdolls > 1) then
		player:ChatPrint("** bzzt, found mulitply bodies! Not enough power to support.");
		return false;
	elseif (#ragdolls <= 0) then
		player:ChatPrint("** bzzt, found no body!");
		return false;
	else
		for k, v in pairs(ragdolls) do
			local ragPlayer = v:GetNetworkedEntity("sh_Player");
			local position = v:GetPos();
			
			ragPlayer:Spawn();
			ragPlayer:SetPos(position);
			
			v:Remove();
		end;
	end;
end;

--[[
	Called when a player drops the item.
	This is for people who know what they're doing, check out
	the nexus framework for a complete list of libraries and functions.
--]]
function ITEM:OnDrop(player, position)
	-- If the item doesn't have this function, it cannot be dropped.
end;

--[[
	Called when a player destroys the item.
	This is for people who know what they're doing, check out
	the nexus framework for a complete list of libraries and functions.
--]]
function ITEM:OnDestroy(player)
	-- If the item doesn't have this function, it cannot be destroyed.
end;

-- Register the item to the nexus framework.
nexus.item.Register(ITEM);