--[[
Name: "sv_hooks.lua".
Product: "Kyron".
--]]

local PLUGIN = PLUGIN;

-- Called when an entity's menu option should be handled.
function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
	local class = entity:GetClass();
	
	if (class == "roleplay_book" and arguments == "roleplay_bookTake" or arguments == "roleplay_bookView") then
		if (arguments == "roleplay_bookView") then
			umsg.Start("roleplay_ViewBook", player);
				umsg.Entity(entity);
			umsg.End();
		else
			local success, fault = player:UpdateInventory(entity.book.uniqueID, 1);
			
			if (!success) then
				resistance.player.Notify(player, fault);
			else
				entity:Remove();
			end;
		end;
	end;
end;

-- Called when resistance has loaded all of the entities.
function PLUGIN:ResistanceInitPostEntity()
	self:LoadBooks();
end;

-- Called just after data should be saved.
function PLUGIN:PostSaveData()
	self:SaveBooks();
end;