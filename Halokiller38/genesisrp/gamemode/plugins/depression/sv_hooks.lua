--[[
	Name: sh_info.lua.
	Author: TJjokerR.
--]]

local PLUGIN = PLUGIN;
PLUGIN.Sounds = {
	cry = {
	"cherno/cry1.wav",
	"cherno/cry2.wav"
	}
};

-- Called when a player's character data should be saved.
function PLUGIN:PlayerSaveCharacterData(player, data)
	if ( data["depression"] ) then
		data["depression"] = math.Round( data["depression"] );
	end;
end;

-- Called when a player's character data should be restored.
function PLUGIN:PlayerRestoreCharacterData(player, data)
	data["depression"] = data["depression"] or 0;
end;

-- Called just after a player spawns.
function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (!firstSpawn and !lightSpawn) then
		player:SetCharacterData("depression", 0);
	end;
end;

-- Called when a player's shared variables should be set.
function PLUGIN:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar( "depression", math.Round( player:GetCharacterData("depression") ) );
end;

-- Called each tick.
function PLUGIN:Tick()
	for _,p in pairs( player.GetAll() ) do
		if ( p:GetSharedVar("depression") ) then
			if ( p:Alive() ) then
				if (( p:GetCharacterData("depression")) > 75 ) then
					if ( p.LastCry ) then
						if ( CurTime() > p.LastCry + 40 ) then
				
						local sound = "cherno/cry1.wav"
						local depression = p:GetSharedVar("depression");
				
						if (( p:GetCharacterData("depression")) > 75 ) then
							sound = table.Random(self.Sounds.cry);
						end;
				
						p:ConCommand("play " .. sound .. "");
						p.LastCry = CurTime() + 40;
						end;
					else
						p.LastCry = CurTime();
					end;
				end;
			end;
		end;
	end;
end;