-------------------------------
-- LemonadeScript - FIXED For "Public" Use!
-- Author: LuaBanana and Looter
-- Project Start: 5/24/2008
-- init.lua
-- This file calls the rest of the script
-------------------------------

--VVV MODELS VVV

resource.AddFile( "models/weapons/w_fists.mdl" )
resource.AddFile( "models/weapons/w_fists.dx80.vtx" )
resource.AddFile( "models/weapons/w_fists.dx80.vtx.ztmp" )
resource.AddFile( "models/weapons/w_fists.dx90.vtx" )
resource.AddFile( "models/weapons/w_fists.dx90.vtx.ztmp" )
resource.AddFile( "models/weapons/w_fists.mdl.ztmp" )
resource.AddFile( "models/weapons/w_fists.phy" )
resource.AddFile( "models/weapons/w_fists.sw.vtx" )
resource.AddFile( "models/weapons/w_fists.sw.vtx.ztmp" )
resource.AddFile( "models/weapons/w_fists.vvd" )
resource.AddFile( "models/weapons/w_fists.vvd.ztmp" )
resource.AddFile( "models/weapons/v_fists.mdl" )
resource.AddFile( "models/weapons/v_fists.sw.vtx" )
resource.AddFile( "models/weapons/v_fists.vvd" )
resource.AddFile( "models/weapons/v_fists.dx80.vtx" )
resource.AddFile( "models/weapons/v_fists.dx90.vtx" )

resource.AddFile( "materials/models/nukacola/sodabottleclosed01.vmt" )
resource.AddFile( "materials/models/nukacola/sodabottleclosed01glass.vmt" )
resource.AddFile( "materials/models/nukacola/sodabottleclosed02.vmt" )
resource.AddFile( "materials/models/nukacola/sodabottleclosed02glass.vmt" )
resource.AddFile( "materials/models/nukacola/sodabottleclosed03.vmt" )
resource.AddFile( "materials/models/nukacola/sodabottleclosed03glass.vmt" )
resource.AddFile( "materials/models/nukacola/sodabottleclosed04.vmt" )
resource.AddFile( "materials/models/nukacola/sodabottleclosed04glass.vmt" )
resource.AddFile( "materials/models/nukacola/nuka.vtf" )
resource.AddFile( "materials/models/nukacola/nuka2.vtf" )
resource.AddFile( "materials/models/nukacola/quantum.vtf" )
resource.AddFile( "materials/models/nukacola/quantum2.vtf" )
resource.AddFile( "materials/models/nukacola/glass2.vtf" )
resource.AddFile( "materials/models/nukacola/glass3.vtf" )
resource.AddFile( "materials/models/nukacola/glass4.vtf" )
resource.AddFile( "materials/models/nukacola/glass_normal.vtf" )

resource.AddFile( "models/weapons/v_snip_rifle.mdl" )
resource.AddFile( "models/weapons/v_snip_rifle.dx80.vtx" )
resource.AddFile( "models/weapons/v_snip_rifle.dx90.vtx" )
resource.AddFile( "models/weapons/v_snip_rifle.sw.vtx" )
resource.AddFile( "models/weapons/v_snip_rifle.vvd" )
resource.AddFile( "materials/models/weapons/v_models/snip_scout/snip_scout.vmt" )
resource.AddFile( "materials/models/weapons/v_models/snip_scout/snip_scout.vtf" )
resource.AddFile( "materials/models/weapons/v_models/snip_scout/snip_scout_ref.vtf" )

--VVV HUD VVV

--resource.AddFile( "materials/VGUI/hud/top_hud_bar" )
--resource.AddFile( "materials/VGUI/hud/Bottom_hud_bar" )
resource.AddFile( "materials/VGUI/hud/HUD_TOP_SCREEN.vtf" )
resource.AddFile( "materials/VGUI/hud/HUD_TOP_SCREEN.vmt" )
resource.AddFile( "materials/VGUI/hud/pipboy_screen.vtf" )
resource.AddFile( "materials/VGUI/hud/pipboy_screen.vmt" )
resource.AddFile( "materials/VGUI/hud/status_100.vmt" )
resource.AddFile( "materials/VGUI/hud/status_100.vtf" )
resource.AddFile( "materials/VGUI/hud/status_90.vmt" )
resource.AddFile( "materials/VGUI/hud/status_90.vtf" )
resource.AddFile( "materials/VGUI/hud/status_80.vtf" )
resource.AddFile( "materials/VGUI/hud/status_80.vmt" )
resource.AddFile( "materials/VGUI/hud/status_60.vmt" )
resource.AddFile( "materials/VGUI/hud/status_60.vtf" )
resource.AddFile( "materials/VGUI/hud/status_30.vmt" )
resource.AddFile( "materials/VGUI/hud/status_30.vtf" )

--VVV FONTS VVV

resource.AddFile( "resource/fonts/carpocalypse.ttf" )
resource.AddFile( "resource/fonts/coolvetica.ttf" )
resource.AddFile( "resource/fonts/csd.ttf" )
resource.AddFile( "resource/fonts/digital-7.ttf" )
resource.AddFile( "resource/fonts/JOURNAL.TTF" )
resource.AddFile( "resource/fonts/Patagonia.ttf" )
resource.AddFile( "resource/fonts/akbar.ttf" )
resource.AddFile( "resource/fonts/halflife2_frp.ttf" )
--resource.AddFile( "resource/fonts/halflife2.ttf" )



-- Set up the gamemode
DeriveGamemode( "sandbox" )

-- Define global variables
LEMON = {  };
TS = { };
LEMON.Running = false;
LEMON.Loaded = false;

-- Server Includes
include( "client_resources.lua" ); -- Sends files to the client
include( "shared.lua" ); -- Shared Functions
include( "log.lua" ); -- Logging functions
include( "error_handling.lua" ); -- Error handling functions
include( "hooks.lua" ); -- LemonadeScript Hook System
include( "configuration.lua" ); -- Configuration data
include( "player_data.lua" ); -- Player data functions
include( "player_shared.lua" ); -- Shared player functions
include( "player_util.lua" ); -- Player functions
include( "admin.lua" ); -- Admin functions
include( "admin_cc.lua" ); -- Admin commands
include( "chat.lua" ); -- Chat Commands
include( "concmd.lua" ); -- Concommands
include( "util.lua" ); -- Functions
include( "charactercreate.lua" ); -- Character Creation functions
include( "items.lua" ); -- Items system
include( "schema.lua" ); -- Schema system
include( "plugins.lua" ); -- Plugin system
include( "teams.lua" ); -- Teams system
--include( "animations.lua" );  -- Need the most upto date animation script off gmod.org
include( "doors.lua" ); -- Doors
include( "parse.lua" ); -- Parse file
include( "daynight.lua" )
include( "rpknockout.lua" )
--include( "thirdperson.lua" )

LEMON.LoadSchema( LEMON.ConVars[ "Schema" ] ); -- Load the schema and plugins, this is NOT initializing.

LEMON.Loaded = true; -- Tell the server that we're loaded up
-- Thanks for the directory add function on the gmod wiki T3h Ub3r K1tten credit goes to that guy :D
function AddDir(dir) -- recursively adds everything in a directory to be downloaded by client 
	local list = file.FindDir("../"..dir.."/*") 
	for _, fdir in pairs(list) do 
		if fdir != ".svn" then -- don't spam people with useless .svn folders 
			AddDir(fdir) 
		end 
	end

		
	 
	for k,v in pairs(file.Find("../"..dir.."/*")) do 
		resource.AddFile(dir.."/"..v) 
	end
end  

AddDir("models/nukacola")



function GM:ForceDermaSkin()
    return "LS";
end 

function PeriodicSave()

SaveItems();

end

--Or else GMod crashes on map startup :(
function LMI()

LoadMapItems();

end

function GM:Initialize( ) 
	

	LEMON.InitPlugins( );

	LEMON.InitSchemas( );

	GAMEMODE.Name = "FalloutScript";
	
    LEMON.InitTime();
	LEMON.LoadDoors();

	
	timer.Simple( 5, LMI )
	timer.Simple( 5, function() SetContainers(); end )
	RunConsoleCommand( "rp_startrandomdrop" )



	timer.Create( "PeriodicSave", 180, 0, PeriodicSave );
	timer.Create( "timesave", 120, 0, LEMON.SaveTime )
	timer.Create( "sendtime", 1, 0, LEMON.SendTime )
	

	
	timer.Create( "givemoney", LEMON.ConVars[ "SalaryInterval" ] * 60, 0, function( )
		if( LEMON.ConVars[ "SalaryEnabled" ] == "1" ) then
		
			for k, v in pairs( player.GetAll( ) ) do
			
				if( LEMON.Teams[ v:Team( ) ] != nil ) then
				
					v:ChangeMoney( LEMON.Teams[ v:Team( ) ][ "salary" ] );
					LEMON.SendChat( v, "Paycheck! $" .. LEMON.Teams[ v:Team( ) ][ "salary" ] .. " caps earned." );
					
				end
				
			end 
			
		end

	end )
	
	timer.Create( "autoitemdropper", 2700, 0, function() RunConsoleCommand( "rp_startrandomdrop" ) end )
	timer.Create( "autoitemremover", 2700, 0, function() RunConsoleCommand( "rp_removerandomitems" ) RunConsoleCommand( "rp_removerandomitems", 1 ) end )

	LEMON.CallHook("GamemodeInitialize");
	
	LEMON.Running = true;
	
end


function GM:PlayerInitialSpawn( ply )


	LEMON.CallHook( "Player_Preload", ply );
	
	-- Send them valid models
	for k, v in pairs( LEMON.ValidModels ) do
		umsg.Start( "addmodel", ply );
			umsg.String( v );
		umsg.End( );
	end

	ply.Ready = false;
	ply:SetNWInt( "chatopen", 0 );
	ply:SetNWInt( "tiedup", 0 );
	ply:SetNWInt( "rave", 0 );
	ply:SetNWInt( "faggot", 0 );
	ply:SetNWInt( "AP", 280 )
	ply:SetNWInt( "apmod", 5 )

	ply:ChangeMaxHealth(LEMON.ConVars[ "DefaultHealth" ]);
	ply:ChangeMaxArmor(0);
	ply:ChangeMaxWalkSpeed(LEMON.ConVars[ "WalkSpeed" ]);
	ply:ChangeMaxRunSpeed(LEMON.ConVars[ "RunSpeed" ]);

	if( table.HasValue( SuperAdmins, ply:SteamID( ) ) ) then ply:SetUserGroup( "superadmin" ); end
	if( table.HasValue( Admins, ply:SteamID( ) ) ) then ply:SetUserGroup( "admin" ); end

	LEMON.InitTeams( ply );
	
	LEMON.LoadPlayerDataFile( ply );
	LEMON.CallHook( "Player_Postload", ply );
	
	self.BaseClass:PlayerInitialSpawn( ply )
	
	
end

function GM:PlayerLoadout(ply)
ply:GetTable().ForceGive = true;

LEMON.CallHook( "PlayerLoadout", ply );
	if(ply:GetNWInt("charactercreate") != 1) then
	
		if( ply:IsAdmin( ) or ply:IsSuperAdmin( ) ) then ply:Give("gmod_tool"); end
		
		if(LEMON.Teams[ply:Team()] != nil) then
		
			for k, v in pairs(LEMON.Teams[ply:Team()]["weapons"]) do

				ply:Give(v);

			end
			
			if( ply:HasWeapon("weapon_fs_colt")) then ply:GiveAmmo(24,"pistol"); end

		ply:SetArmor(LEMON.Teams[ply:Team()]["armor"])
			
		end

		ply:Give("hands");
		ply:Give("keys");
		ply:Give("weapon_physcannon");
		ply:SelectWeapon("keys");

	end

ply:GetTable().ForceGive = false;
end

function GM:PlayerSpawn( ply )

	if(LEMON.PlayerData[LEMON.FormatSteamID(ply:SteamID())] == nil) then
		return;
	end
	-- if ply:Team() == 9 then
		-- ply:SetModel("frp/enclave_soldier.mdl")
	-- end
	ply:StripWeapons( );

	self.BaseClass:PlayerSpawn( ply )
	
	GAMEMODE:SetPlayerSpeed( ply, LEMON.ConVars[ "WalkSpeed" ], LEMON.ConVars[ "RunSpeed" ] );

	if( ply:GetNWInt( "deathmode" ) == 1 ) then

		ply:SetNWInt( "deathmode", 0 );
		ply:SetViewEntity( ply );

	end
	ply:SetNWInt( "AP", 280 )
	-- Reset all the variables
	ply:ChangeMaxHealth(LEMON.ConVars[ "DefaultHealth" ] - ply:MaxHealth());
	ply:ChangeMaxArmor(0 - ply:MaxArmor());
	ply:ChangeMaxWalkSpeed(LEMON.ConVars[ "WalkSpeed" ] - ply:MaxWalkSpeed());
	ply:ChangeMaxRunSpeed(LEMON.ConVars[ "RunSpeed" ] - ply:MaxRunSpeed());
	ply:SetNWInt( "apmod", 5 )

	if( ply:Team() == 5 ) then
		ply:SetModel( "models/chance/dweller/male_0".. math.random( 1, 9 ) ..".mdl" )
	end

	LEMON.CallHook( "PlayerSpawn", ply )
	LEMON.CallTeamHook( "PlayerSpawn", ply ); -- Change player speeds perhaps?

end

function GM:PlayerSetModel(ply)
	
	if(LEMON.Teams[ply:Team()] != nil) then
	
		if(LEMON.Teams[ply:Team()].default_model == true) then
		
			if(LEMON.Teams[ply:Team()].partial_model == true) then
			
				local m = LEMON.Teams[ply:Team()]["model_path"] .. string.sub(ply:GetNWString("model"), 23, string.len(ply:GetNWString("model")));
				ply:SetModel(m);
				LEMON.CallHook( "PlayerSetModel", ply, m);
				
			elseif(LEMON.Teams[ply:Team()].partial_model == false) then
			
				local m = LEMON.Teams[ply:Team()]["model_path"];
				ply:SetModel(m);
				LEMON.CallHook( "PlayerSetModel", ply, m);
				
			end
			
		else
		
			local m = ply:GetNWString("model")
			ply:SetModel(m);
			LEMON.CallHook( "PlayerSetModel", ply, m);

		end
		
	else
		
		local m = "models/humans/group01/male_01.mdl";
		ply:SetModel("models/humans/group01/male_01.mdl");
		LEMON.CallHook( "PlayerSetModel", ply, m);
		
	end
	
	LEMON.CallTeamHook( "PlayerSetModel", ply, m); -- Hrm. Looks like the teamhook will take priority over the regular hook.. PREPARE FOR HELLFIRE (puts on helmet)
	

	
end

function GM:SetupMove( ply )
	
	apmod = ply:GetNWInt( "apmod" )
	if( ply:KeyDown( IN_SPEED ) and ply:GetNWInt( "AP" ) > 0 ) then
	
		if( ply:KeyDown( IN_FORWARD ) or
			ply:KeyDown( IN_BACK ) or
			ply:KeyDown( IN_MOVELEFT ) or
			ply:KeyDown( IN_MOVERIGHT ) ) then

				ply:SetNWInt( "AP", ply:GetNWInt( "AP" ) - apmod * FrameTime() );
				
				if( ply:GetNWInt( "AP" ) < 0 ) then
				
					ply:SetNWInt( "AP", 0 );
				
				end
				
		end
		
 		ply:SetRunSpeed( LEMON.ConVars[ "RunSpeed" ] )
 		
	elseif ply:KeyDown( IN_SPEED ) and ply:GetNWInt( "AP" ) <= 0 then
	
		ply:SetWalkSpeed( tonumber(LEMON.ConVars[ "WalkSpeed" ]) )
		ply:SetRunSpeed( 0 )
	
	end

end

function GM:PlayerDeath(ply)

	LEMON.DeathMode(ply);
	LEMON.CallHook("PlayerDeath", ply);
	LEMON.CallTeamHook("PlayerDeath", ply);

end

function GM:PlayerDeathThink(ply)

	ply.nextsecond = LEMON.NilFix(ply.nextsecond, CurTime())
	ply.deathtime = LEMON.NilFix(ply.deathtime, 120);
	
	if(CurTime() > ply.nextsecond) then
	
		if(ply.deathtime < 120) then
		
			ply.deathtime = ply.deathtime + 1;
			ply.nextsecond = CurTime() + 1;
			ply:SetNWInt("deathmoderemaining", 120 - ply.deathtime);
			
		else
		
			ply.deathtime = nil;
			ply.nextsecond = nil;
			ply:Spawn();
			ply:SetNWInt("deathmode", 0);
			ply:SetNWInt("deathmoderemaining", 0);
			
		end
		
	end
	
end

BannedGuns = {"hands", "weapon_gravcannon", "weapon_physcannon", "weapon_gravgun", "weapon_physgun", "gmod_tool" }

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo ) 
  
	if ent:IsPlayer() and dmginfo:GetAttacker():GetClass() == "func_door" then 
  
		dmginfo:SetDamage( 0 )
		--NO DAMAGE TAKEN WITH DOORS ^_^ -Otoris
  
	end 
   
end  
 
function GM:DoPlayerDeath( ply, attacker, dmginfo )

    local weap = ply:GetActiveWeapon();

	if(table.HasValue(BannedGuns, weap:GetClass())) then return false; end
	
	LEMON.CreateItem( weap:GetClass(), ply:GetPos(), ply:GetAngles() )

end

function GM:PlayerUse(ply, entity)
if ValidEntity( entity ) and not ply:KeyDown(IN_ATTACK) then
	if(LEMON.IsDoor(entity)) then
		local doorgroups = LEMON.GetDoorGroup(entity)
		for k, v in pairs(doorgroups) do
			if(table.HasValue(LEMON.Teams[ply:Team()]["door_groups"], v)) then
				return false;
			end
		end
	end
end
	
	return self.BaseClass:PlayerUse(ply, entity);

end

function GM:Think( ply )

	for k, v in pairs( player.GetAll() ) do
	
		if( not v:KeyDown( IN_SPEED ) and CurTime() - v:GetNWInt( "lastAP" ) > 2 and v:GetNWInt( "AP" ) < 280 ) then
		
			if ( v:KeyDown( IN_FORWARD ) or
				v:KeyDown( IN_BACK ) or
				v:KeyDown( IN_MOVELEFT ) or
				v:KeyDown( IN_MOVERIGHT ) ) then
				v:SetNWInt( "AP", v:GetNWInt( "AP" ) + 220 * FrameTime() );
			elseif( v:KeyDown( IN_DUCK ) ) then
				v:SetNWInt( "AP", v:GetNWInt( "AP" ) + 450 * FrameTime() );
			else
				v:SetNWInt( "AP", v:GetNWInt( "AP" ) + 320 * FrameTime() );
			end
			
			if( v:GetNWInt( "AP" ) > 280 ) then
			
				v:SetNWInt( "AP", 280 );
			
			end
			
			v:SetNWInt( "lastAP", CurTime() );
		
		end
	end
	



end
