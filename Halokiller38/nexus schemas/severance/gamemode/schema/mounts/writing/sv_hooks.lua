--[[
Name: "sv_hooks.lua".
Product: "Severance".
--]]

local MOUNT = MOUNT;

-- Called when an entity's menu option should be handled.
function MOUNT:EntityHandleMenuOption(player, entity, option, arguments)
	local class = entity:GetClass();
	
	if (class == "nx_paper" and arguments == "nx_paperOption") then
		if (entity.text) then
			if ( !player.paperIDs or !player.paperIDs[entity.uniqueID] ) then
				if (!player.paperIDs) then
					player.paperIDs = {};
				end;
				
				player.paperIDs[entity.uniqueID] = true;
				
				NEXUS:StartDataStream( player, "ViewPaper", {entity, entity.uniqueID, entity.text} );
			else
				NEXUS:StartDataStream( player, "ViewPaper", {entity, entity.uniqueID} );
			end;
		else
			umsg.Start("nx_EditPaper", player);
				umsg.Entity(entity);
			umsg.End();
		end;
	end;
end;

-- Called when nexus has loaded all of the entities.
function MOUNT:NexusInitPostEntity()
	self:LoadPaper();
end;

-- Called just after data should be saved.
function MOUNT:PostSaveData()
	self:SavePaper();
end;