PLUGIN.Name = "Permaflags"; -- What is the plugin name
PLUGIN.Author = "Nori"; -- Author of the plugin
PLUGIN.Description = "Allows a player to automatically spawn as a certain flag when the character is selected"; -- The description or purpose of the plugin

function SetPermaflag(ply, cmd, args)

	if(#args != 1) then
	
		LEMON.SendConsole(ply, "Incorrect number of arguments!");
		return;
		
	end
	
	local flagkey = args[1];
	
	for k, v in pairs(LEMON.Teams) do
	
		if(v.flag_key == flagkey and (table.HasValue(LEMON.GetCharField(ply, "flags"), flagkey) or v.public == true)) then
			
			LEMON.SetCharField(ply, "permaflag", flagkey)
			LEMON.SendConsole(ply, "Permaflag set to " .. flagkey);
			
		end
		
	end
	
end
concommand.Add("rp_permaflag", SetPermaflag);

function Permaflag_Set(ply)


	
	for k, v in pairs(LEMON.Teams) do
	
		if(v.flag_key == LEMON.GetCharField(ply, "permaflag")) then
		
			if(table.HasValue(LEMON.GetCharField(ply, "flags"), LEMON.GetCharField(ply, "permaflag")) or v.public == true) then
			

				ply:SetTeam(k)
				
			else
			

				LEMON.SetCharField(ply, "permaflag", LEMON.ConVars["DefaultPermaflag"]);
			
			end
			
		end
		
	end
	
end

function PLUGIN.Init()
	
	LEMON.ConVars["DefaultPermaflag"] = "resident";
	
	LEMON.AddDataField( 2, "permaflag", LEMON.ConVars["DefaultPermaflag"] ); -- What is the default permaflag (Citizen by default, shouldn't be changed)
	LEMON.AddHook("CharacterSelect_PostSetTeam", "permaflag", Permaflag_Set);
	
end
