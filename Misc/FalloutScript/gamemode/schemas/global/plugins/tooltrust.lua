PLUGIN.Name = "Tool Trust"; -- What is the plugin name
PLUGIN.Author = "Looter"; -- Author of the plugin
PLUGIN.Description = "Toolgun permissions, as well as physgun ban."; -- The description or purpose of the plugin

function Tooltrust_Give(ply)
ply:GetTable().ForceGive = true;
	if(tostring(LEMON.GetPlayerField(ply, "tooltrust")) == "1") then
		ply:SetNWInt( "tooltrust", 1 )
		ply:Give("gmod_tool");
		
	end
	
	if(tostring(LEMON.GetPlayerField(ply, "phystrust")) == "1") then
		ply:SetNWInt( "phystrust", 1 )
		ply:Give("weapon_physgun");
	
	end
	
	if(tostring(LEMON.GetPlayerField(ply, "gravtrust")) == "1") then
		ply:SetNWInt( "gravtrust", 1 )
		ply:Give("weapon_physcannon");
		
	end
ply:GetTable().ForceGive = false;
end

function Admin_Tooltrust(ply, cmd, args)

	if(#args != 2) then
	
		LEMON.SendChat( ply, "Invalid number of arguments! ( rp_admin tooltrust \"name\" 1/0 )" );
		return;

	end
	
	local target = LEMON.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		LEMON.SendChat( ply, "Target not found!" );
		return;
	end
	
	if(args[2] == "1") then
	target:GetTable().ForceGive = true;
		LEMON.SetPlayerField(target, "tooltrust", 1);
		ply:SetNWInt( "tooltrust", 1 )
		target:Give("gmod_tool");
		LEMON.SendChat( target, "You have been given tooltrust by " .. ply:Name() );
		LEMON.SendChat( ply, target:Name() .. " has been given tooltrust" );
	target:GetTable().ForceGive = false;
	elseif(args[2] == "0") then
	target:GetTable().ForceGive = true;
		LEMON.SetPlayerField(target, "tooltrust", 0);
		ply:SetNWInt( "tooltrust", 0 )
		target:StripWeapon("gmod_tool");
		LEMON.SendChat( target, "Your tooltrust has been removed by " .. ply:Name() );
		LEMON.SendChat( ply, target:Name() .. "'s tooltrust has been removed" );
	target:GetTable().ForceGive = false;
	end

end

function Admin_Phystrust(ply, cmd, args)

	if(#args != 2) then
	
		LEMON.SendChat( ply, "Invalid number of arguments! ( rp_admin phystrust \"name\" 1/0 )" );
		return;

	end
	
	local target = LEMON.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		LEMON.SendChat( ply, "Target not found!" );
		return;
	end
	
	if(args[2] == "0") then
	target:GetTable().ForceGive = true;
		LEMON.SetPlayerField(target, "phystrust", 0);
		ply:SetNWInt( "phystrust", 0 )
		target:StripWeapon("weapon_physgun");
		LEMON.SendChat( target, "You have been banned from the physics gun by " .. ply:Name());
		LEMON.SendChat( ply, target:Name() .. " has been banned from the physics gun" );
	target:GetTable().ForceGive = false;
	elseif(args[2] == "1") then
	target:GetTable().ForceGive = true;
		LEMON.SetPlayerField(target, "phystrust", 1);
		ply:SetNWInt( "phystrust", 1 )
		target:Give("weapon_physgun");
		LEMON.SendChat( target, "You have been given the physgun by " .. ply:Name() );
		LEMON.SendChat( ply, target:Name() .. " has been given a physgun" );
	target:GetTable().ForceGive = false;
	end
	
end

function Admin_Gravtrust(ply, cmd, args)

	if(#args != 2) then
	
		LEMON.SendChat( ply, "Invalid number of arguments! ( rp_admin gravtrust \"name\" 1/0 )" );
		return;

	end
	
	local target = LEMON.FindPlayer(args[1])
	
	if(target != nil and target:IsValid() and target:IsPlayer()) then
		-- klol
	else
		LEMON.SendChat( ply, "Target not found!" );
		return;
	end
	
	if(args[2] == "0") then
	
		LEMON.SetPlayerField(target, "gravtrust", 0);
		ply:SetNWInt( "gravtrust", 0 )
		target:StripWeapon("weapon_physcannon");
		LEMON.SendChat( target, "You have been banned from the gravity gun by " .. ply:Name());
		LEMON.SendChat( ply, target:Name() .. " has been banned from the gravity gun" );
		
	elseif(args[2] == "1") then
	
		LEMON.SetPlayerField(target, "gravtrust", 1);
		ply:SetNWInt( "gravtrust", 1 )
		target:Give("weapon_physcannon");
		LEMON.SendChat( target, "You have been given the gravgun by " .. ply:Name() );
		LEMON.SendChat( ply, target:Name() .. " has been given a gravgun" );
		
	end
	
end

	
function PLUGIN.Init()

	LEMON.ConVars[ "Default_Tooltrust" ] = "0"; -- Are players allowed to have the toolgun when they first start.
	LEMON.ConVars[ "Default_Gravtrust" ] = "1"; -- Are players allowed to have the gravgun when they first start.
	LEMON.ConVars[ "Default_Phystrust" ] = "1"; -- Are players allowed to have the physgun when they first start.
	
	LEMON.AddDataField( 1, "tooltrust", LEMON.ConVars[ "Default_Tooltrust" ] ); -- Is the player allowed to have the toolgun
	LEMON.AddDataField( 1, "gravtrust", LEMON.ConVars[ "Default_Gravtrust" ] ); -- Is the player allowed to have the gravity gun
	LEMON.AddDataField( 1, "phystrust", LEMON.ConVars[ "Default_Phystrust" ] ); -- Is the player allowed to have the physics gun
	LEMON.AddDataField( 1, "proptrust", LEMON.ConVars[ "Default_Proptrust" ] ); -- Is the player allowed to spawn props
	
	LEMON.AddHook("PlayerSpawn", "tooltrust_give", Tooltrust_Give);
	
	LEMON.AdminCommand( "tooltrust", Admin_Tooltrust, "Change someones tooltrust", true, true, false );
	LEMON.AdminCommand( "gravtrust", Admin_Gravtrust, "Change someones gravtrust", true, true, false );
	LEMON.AdminCommand( "phystrust", Admin_Phystrust, "Change someones phystrust", true, true, false );
	
end
