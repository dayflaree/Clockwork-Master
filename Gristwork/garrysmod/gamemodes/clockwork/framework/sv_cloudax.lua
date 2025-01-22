--[[ 
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

function Clockwork.inventory:SendUpdateByInstance(player, itemTable)
	 if (itemTable) then
		Clockwork.datastream:Start(
			player, "InvUpdate", {Clockwork.item:GetDefinition(itemTable, true)}
		);
	end;
end;

function Clockwork.inventory:SendUpdateAll(player)
	local inventory = player:GetInventory();
 
	for k, v in pairs(inventory) do
		self:SendUpdateByID(player, k);
	end;
end;

function Clockwork.inventory:SendUpdateByID(player, uniqueID)
	local itemTables = self:GetItemsByID(player:GetInventory(), uniqueID);
 
	if (itemTables) then
		local definitions = {};
 
		for k, v in pairs(itemTables) do
			definitions[#definitions + 1] = Clockwork.item:GetDefinition(v, true);
		end;
 
		Clockwork.datastream:Start(player, "InvUpdate", definitions);
	end;
end;

function Clockwork.inventory:Rebuild(player)
	Clockwork.kernel:OnNextFrame("RebuildInv"..player:UniqueID(), function()
		if (IsValid(player)) then
			Clockwork.datastream:Start(player, "InvRebuild");
		end;
	end);
end;

_player, _team, _file = player, team, file;