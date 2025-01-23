--[[
Name: "sv_hooks.lua".
Product: "Day One".
--]]

local PLUGIN = PLUGIN;

-- Called when an entity's menu option should be handled.
function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
	local class = entity:GetClass();
	
	if (class == "bp_paper" and arguments == "bp_paperOption") then
		if (entity.text) then
			if ( !player.paperIDs or !player.paperIDs[entity.uniqueID] ) then
				if (!player.paperIDs) then
					player.paperIDs = {};
				end;
				
				player.paperIDs[entity.uniqueID] = true;
				
				BLUEPRINT:StartDataStream( player, "ViewPaper", {entity, entity.uniqueID, entity.text} );
			else
				BLUEPRINT:StartDataStream( player, "ViewPaper", {entity, entity.uniqueID} );
			end;
		else
			umsg.Start("bp_EditPaper", player);
				umsg.Entity(entity);
			umsg.End();
		end;
	end;
end;

-- Called when Blueprint has loaded all of the entities.
function PLUGIN:BlueprintInitPostEntity()
	self:LoadPaper();
end;

-- Called just after data should be saved.
function PLUGIN:PostSaveData()
	self:SavePaper();
end;