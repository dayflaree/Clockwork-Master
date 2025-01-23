-------------------------------
-- LemonadeScript
-- Author: LuaBanana and Looter
-- cl_init.lua
-- This file calls the rest of the script
-- As you can see, the clientside of LemonadeScript is pretty simple compared to the serverside.
-------------------------------

-- Set up the gamemode
DeriveGamemode( "sandbox" );
GM.Name = "FalloutScript: IRiS 1.0";

-- Define global variables
LEMON = {  };
LEMON.Running = false;
LEMON.Loaded = false;

readysent = false;

-- Client Includes
include( "VGUI/hpanel.lua" );
include( "VGUI/apanel.lua" );
include( "VGUI/ipanel.lua" );
include( "cl_skin.lua" );
include( "shared.lua" );
include( "player_shared.lua" );
include( "cl_hud.lua" );
include( "cl_binds.lua" );
include( "cl_charactercreate.lua" );
include( "cl_playermenu.lua" );
include( "cl_search.lua" );
include( "cl_admin.lua" );
include( "VGUI/wpanel.lua" )
include( "VGUI/motd.lua" )

LEMON.Loaded = true;


-- Initialize the gamemode
function GM:Initialize( )

	LEMON.Running = true;

	self.BaseClass:Initialize( );

	--timer.Create( "HelpTicker", 120, 0, HelpTicker() )
end

function GM:Think( )

	if( vgui and readysent == false ) then -- VGUI is initalized, tell the server we're ready for character creation.
	
		LocalPlayer( ):ConCommand( "rp_ready\n" );
		readysent = true;
		
	end
	
end
notaimed =
{
	"keys"
}

aimed = 
{
	"weapon_physcannon",
	"weapon_physgun",
	"gmod_tool"
}

-- Yes, this is from CatScript
local WalkTimer = 0
local VelSmooth = 0

function GM:CalcView( ply, origin, angle, fov )
 	local vel = ply:GetVelocity()
 	local ang = ply:EyeAngles()

 	VelSmooth = VelSmooth * 0.9 + vel:Length() * 0.1

 	WalkTimer = WalkTimer + VelSmooth * FrameTime() * 0.05

 	-- Roll on strafe
 	angle.roll = angle.roll + ang:Right():DotProduct( vel ) * 0.01

 	-- Roll on steps
 	if ( ply:GetGroundEntity() != NULL ) then
 		angle.roll = angle.roll + math.sin( WalkTimer ) * VelSmooth * 0.001
 		angle.pitch = angle.pitch + math.sin( WalkTimer * 0.5 ) * VelSmooth * 0.001
 	end
 	angle = angle + ply:HeadshotAngles()
 	return self.BaseClass:CalcView( ply, origin, angle, fov )
end

local PlayerMeta = FindMetaTable( "Player" )

function PlayerMeta:HeadshotAngles()
 	self:GetTable().HeadShotStart = self:GetTable().HeadShotStart or 0
 	self:GetTable().HeadShotRoll = self:GetTable().HeadShotRoll or 0
 	self:GetTable().HeadShotRoll = math.Approach( self:GetTable().HeadShotRoll, 0.0, 40.0 * FrameTime() )
 	local roll = self:GetTable().HeadShotRoll
 	local Time = (CurTime() - self:GetTable().HeadShotStart) * 10
 	return Angle( math.sin( Time ) * roll * 0.5, 0, math.sin( Time * 2 ) * roll * -1 )
end

local meta = FindMetaTable( "Entity" );

local DoorTypes =
{

	"func_door",
	"func_door_rotating",
	"prop_door_rotating"

}

function meta:IsDoor()

	local class = self:GetClass();
	
	for k, v in pairs( DoorTypes ) do
	
		if( v == class ) then return true; end
	
	end
	
	return false;

end

function KOEffect( )

if LocalPlayer():GetNWBool( "KOed" ) then

draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, TimedSin( 0.03, 510, 0, 4 ) ) )
end
end
hook.Add( "HUDPaint", "KOEffect", KOEffect )

function KillSelf( ply )

	if ply:GetNWBool( "radkiller" ) == true then
		ply:ConCommand( "kill" )
		ply:SetNWBool( "radkiller", false ) 
	end

end

--AKA TIP TICKER
-- function HelpTicker()

	-- LocalPlayer():PrintMessage( HUD_PRINTTALK, "[HelpTicker]"..HelpSentances[math.random(1, #HelpSentances)].."" )
	
-- end
-- concommand.Add( "rp_printhelp", HelpTicker )
