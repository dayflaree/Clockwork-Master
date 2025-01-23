--[[
Name: "sv_auto.lua".
Product: "Half-Life 2".
--]]

local PLUGIN = PLUGIN;

RESISTANCE:IncludePrefixed("sh_auto.lua");

RESISTANCE:HookDataStream("EditPaper", function(player, data)
	if ( IsValid( data[1] ) ) then
		if (data[1]:GetClass() == "roleplay_paper") then
			if ( player:GetPos():Distance( data[1]:GetPos() ) <= 192 and player:GetEyeTraceNoCursor().Entity == data[1] ) then
				if (string.len( data[2] ) > 0) then
					data[1]:SetText( string.sub(data[2], 0, 500) );
				end;
			end;
		end;
	end;
end);

-- A function to load the paper.
function PLUGIN:LoadPaper()
	local paper = RESISTANCE:RestoreModuleData( "plugins/paper/"..game.GetMap() );
	
	for k, v in pairs(paper) do
		local entity = ents.Create("roleplay_paper");
		
		resistance.player.GivePropertyOffline(v.key, v.uniqueID, entity);
		
		entity:SetAngles(v.angles);
		entity:SetPos(v.position);
		entity:Spawn();
		
		if ( IsValid(entity) ) then
			entity:SetText(v.text);
		end;
		
		if (!v.moveable) then
			local physicsObject = entity:GetPhysicsObject();
			
			if ( IsValid(physicsObject) ) then
				physicsObject:EnableMotion(false);
			end;
		end;
	end;
end;

-- A function to save the paper.
function PLUGIN:SavePaper()
	local paper = {};
	
	for k, v in pairs( ents.FindByClass("roleplay_paper") ) do
		local physicsObject = v:GetPhysicsObject();
		local moveable;
		
		if ( IsValid(physicsObject) ) then
			moveable = physicsObject:IsMoveable();
		end;
		
		paper[#paper + 1] = {
			key = resistance.entity.QueryProperty(v, "key"),
			text = v.text,
			angles = v:GetAngles(),
			moveable = moveable,
			uniqueID = resistance.entity.QueryProperty(v, "uniqueID"),
			position = v:GetPos()
		};
	end;
	
	RESISTANCE:SaveModuleData("plugins/paper/"..game.GetMap(), paper);
end;