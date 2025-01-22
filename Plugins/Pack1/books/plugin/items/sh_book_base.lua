--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "Book Base";
ITEM.isBook = true;
ITEM.weight = 0.4;
ITEM.access = "3";
ITEM.category = "Literature";
ITEM.useText = "Read";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

-- Called when the item should be setup.
function ITEM:OnSetup()
	if (self.bookInformation) then
		self.bookInformation = string.gsub( string.gsub(self.bookInformation, "\n", "<br>"), "\t", string.rep("&nbsp;", 4) );
		self.bookInformation = "<html><font face='Arial' size='2'>"..self.bookInformation.."</font></html>";
	end;
end;

function ITEM:OnUse(player, itemEntity)
	Clockwork.datastream:Start(player, "cwViewBook", {self.uniqueID, true, nil});
	return false;
end;

function ITEM:CanPickup(player, quickUse, itemEntity)
	-- If called from the 'read' option, don't pickup.
	if(quickUse) then
		Clockwork.datastream:Start(player, "cwViewBook", {self.uniqueID, false, itemEntity});
		return false;
	end;
end;

ITEM:Register();