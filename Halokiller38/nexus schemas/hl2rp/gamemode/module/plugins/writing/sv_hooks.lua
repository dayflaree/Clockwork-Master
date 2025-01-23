--[[
Name: "sv_hooks.lua".
Product: "Kyron".
--]]

local PLUGIN = PLUGIN;

-- Called when an entity's menu option should be handled.
function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
	local class = entity:GetClass();
	
	if (class == "roleplay_paper" and arguments == "roleplay_paperOption") then
		if (entity.text) then
			if ( !player.paperIDs or !player.paperIDs[entity.uniqueID] ) then
				if (!player.paperIDs) then
					player.paperIDs = {};
				end;
				
				player.paperIDs[entity.uniqueID] = true;
				
				RESISTANCE:StartDataStream( player, "ViewPaper", {entity, entity.uniqueID, entity.text} );
			else
				RESISTANCE:StartDataStream( player, "ViewPaper", {entity, entity.uniqueID} );
			end;
		else
			umsg.Start("roleplay_EditPaper", player);
				umsg.Entity(entity);
			umsg.End();
		end;
	end;
end;

-- Called when resistance has loaded all of the entities.
function PLUGIN:ResistanceInitPostEntity()
	self:LoadPaper();
end;

-- Called just after data should be saved.
function PLUGIN:PostSaveData()
	self:SavePaper();
end;