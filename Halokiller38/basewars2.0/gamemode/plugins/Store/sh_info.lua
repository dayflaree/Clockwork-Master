--[[
	2011 Slidefuse Networks; Do NOT Share/Distribute/Modify
	Author: Spencer Sharkey (spencer@sf-n.com)
--]]

RP.Store = {};

local PLUGIN = PLUGIN;
RP:IncludeFile("cl_derma.lua");

PLUGIN.name = "Store";

RP.Store.Categories = {};
RP.Store.Entities = {};

local COMMAND = {}
COMMAND.description = "Buy's an item";
COMMAND.arguments = {{"String", "UniqueID"}};
function COMMAND:OnRun(player, args)
	local itemTable = RP.Item:Get(args["UniqueID"]);
	if (itemTable) then
		if (player:CanAfford(itemTable.cost)) then
			if (itemTable:CanPurchase(player)) then
				local trace = player:EyeTrace(100);

				if (trace.HitPos:Distance(player:GetPos()) <= 300) then
				
					player:TakeCash(itemTable.cost);
					
					if (itemTable:OnPurchase(player, trace)) then
					
						local itemID = RP.Item:CreateID(itemTable.uniqueID);
						local entity = RP.Item:CreateEntity(player, itemID, trace.HitPos);
						
						RP:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
					end;
					player:Notify("You bought a(n) "..itemTable.name.." for "..itemTable.cost.." shards");
				else
					player:Notify("You can not buy something that far away!");
				end;
			end;
		else
			player:Notify("You can not afford that item!");
		end;
	else
		player:Notify("Invalid Item!");
	end;
end;
RP.Command:New("OrderItem", COMMAND);
			
	
	
