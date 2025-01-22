local PLUGIN = PLUGIN;

-- Called just after data should be saved.
function PLUGIN:PostSaveData()
	self:SaveCustomItems();
end;

-- Called after a player's config is initialized.
function PLUGIN:PlayerSendDataStreamInfo(player)
	Clockwork.datastream:Start(player, "GiveStartItems", self.customItems);
end;