--[[
Name: "sv_auto.lua".
Product: "Novus Two".
--]]

local MOUNT = MOUNT;

NEXUS:IncludePrefixed("sh_auto.lua");

NEXUS:HookDataStream("EditPaper", function(player, data)
	if ( IsValid( data[1] ) ) then
		if (data[1]:GetClass() == "nx_paper") then
			if ( player:GetPos():Distance( data[1]:GetPos() ) <= 192 and player:GetEyeTraceNoCursor().Entity == data[1] ) then
				if (string.len( data[2] ) > 0) then
					data[1]:SetText( string.sub(data[2], 0, 500) );
				end;
			end;
		end;
	end;
end);

-- A function to load the paper.
function MOUNT:LoadPaper()
	local paper = NEXUS:RestoreSchemaData( "mounts/paper/"..game.GetMap() );
	
	for k, v in pairs(paper) do
		local entity = ents.Create("nx_paper");
		
		nexus.player.GivePropertyOffline(v.key, v.uniqueID, entity);
		
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
function MOUNT:SavePaper()
	local paper = {};
	
	for k, v in pairs( ents.FindByClass("nx_paper") ) do
		local physicsObject = v:GetPhysicsObject();
		local moveable;
		
		if ( IsValid(physicsObject) ) then
			moveable = physicsObject:IsMoveable();
		end;
		
		paper[#paper + 1] = {
			key = nexus.entity.QueryProperty(v, "key"),
			text = v.text,
			angles = v:GetAngles(),
			moveable = moveable,
			uniqueID = nexus.entity.QueryProperty(v, "uniqueID"),
			position = v:GetPos()
		};
	end;
	
	NEXUS:SaveSchemaData("mounts/paper/"..game.GetMap(), paper);
end;