-------------------------------
-- LemonadeScript
-- Author: LuaBanana and Looter and Otoris
-- Project Start: 5/24/2008
--
-- concmd.lua
-- Contains the concommands and changes the way other concommands work.
-------------------------------

-- Check for admin auth and let them boot up the admin menu panel -- panel functions need work!

function ccAdminMenu( ply )

if( ply:IsAdmin() or ply:IsSuperAdmin() ) then

umsg.Start( "startadmin", ply ); umsg.End( );

else

LEMON.SendChat(ply, "You're not an admin!");

end
-- print( ply:GetActiveWeapon():GetClass() ) debug purposes
-- print( ply:GetActiveWeapon():GetTable() ) debug purposes

end
concommand.Add( "rp_adminmenu", ccAdminMenu )
-- Create a container
function CreateContainer( Model, Pos, Ang, Inventory, limit )

  local Box = ents.Create( "prop_physics" )
  Box:SetModel( Model )
  Box:SetPos( Pos )
  Box:SetAngles( Ang )
  Box.inventory = Inventory;
  Box.limit = limit;
  Box:SetNWBool( "container", true )
  Box:Spawn();
  Box:Activate();

end
-- List the container models here and make sure you add the limit for it below
Containers = {
"models/props_c17/FurnitureDresser001a.mdl",
"models/props_c17/FurnitureDrawer003a.mdl",
"models/props_c17/oildrum001.mdl",
"models/props_interiors/Furniture_Couch01a.mdl",
"models/props_borealis/bluebarrel001.mdl",
"models/props_interiors/Furniture_Desk01a.mdl",
"models/props_junk/wood_crate001a.mdl",
"models/props_junk/wood_crate001a_damaged.mdl",
"models/props_wasteland/controlroom_filecabinet002a.mdl",
"models/props_junk/wood_crate002a.mdl",
"models/props_c17/Lockers001a.mdl",
"models/props_combine/breendesk.mdl",
"models/props_wasteland/controlroom_storagecloset001a.mdl",
"models/props_junk/TrashDumpster01a.mdl",
"models/props_interiors/Furniture_Couch02a.mdl",
"models/props_junk/TrashBin01a.mdl",
"models/Items/ammocrate_grenade.mdl",
"models/props_wasteland/controlroom_storagecloset001b.mdl",
"models/props_wasteland/controlroom_filecabinet001a.mdl",
"models/props_trainstation/trashcan_indoor001a.mdl",
"models/props_trainstation/trashcan_indoor001b.mdl",
"models/props_c17/FurnitureDrawer002a.mdl",
"models/props_c17/FurnitureDrawer001a.mdl",
"models/Items/item_item_crate.mdl",
"models\props/CS_militia/footlocker01_closed.mdl"
}

--OKAY allow players to right click on props and use them as containers

function SetContainers()

for k,v in pairs( ents.GetAll() ) do
if( table.HasValue( Containers, v:GetModel() ) ) then

v.inventory = { };
if( mdl == "models/props_c17/FurnitureDresser001a.mdl" or mdl == "models/props_c17/FurnitureDrawer003a.mdl" ) then
v:SetNWInt( "limit", 5 )
elseif( mdl == "models/Items/item_item_crate.mdl" or mdl == "models/props_wasteland/controlroom_filecabinet001a.mdl" or mdl == "models/props_c17/oildrum001.mdl" or mdl == "models/props_interiors/Furniture_Couch01a.mdl" or mdl == "models/props_interiors/Furniture_Couch02a.mdl" or mdl == "models/props_borealis/bluebarrel001.mdl" or mdl == "models/props_interiors/Furniture_Desk01a.mdl" ) then
v:SetNWInt( "limit", 1 )
elseif( mdl == "models/props_c17/FurnitureDrawer002a.mdl" or mdl == "models/props_trainstation/trashcan_indoor001a.mdl" or mdl == "models/props_trainstation/trashcan_indoor001b.mdl" or mdl == "models/props_junk/wood_crate001a.mdl" or mdl == "models/props_junk/TrashBin01a.mdl" or mdl == "models/props_junk/wood_crate001a_damaged.mdl" or mdl == "models/props_wasteland/controlroom_filecabinet002a.mdl" ) then

v:SetNWInt( "limit", 3 )

elseif( mdl == "models/props_wasteland/controlroom_storagecloset001b.mdl" or mdl == "models\props/CS_militia/footlocker01_closed.mdl" or mdl == "models/props_junk/wood_crate002a.mdl" or mdl == "models/props_c17/Lockers001a.mdl" or mdl == "models/props_combine/breendesk.mdl" ) then

v:SetNWInt( "limit", 4 )

elseif( mdl == "models/props_wasteland/controlroom_storagecloset001a.mdl" or mdl == "models/Items/ammocrate_grenade.mdl" or mdl == "models/Items/ammocrate_ar2.mdl" or mdl == "models/Items/ammocrate_smg1.mdl" or mdl == "models/Items/ammoCrate_Rockets.mdl" ) then

v:SetNWInt( "limit", 7 )

elseif( mdl == "models/props_junk/TrashDumpster01a.mdl" ) then

v:SetNWInt( "limit", 15 )

end

v:SetNWBool( "container", true ) 

end

end

end

-- The begining of a prop drop code for crates that will spawn in the random item spawner below. Needs work! Needs Inovating!

function GM:PropBreak( killer, prop )
local RarityMath = math.random(1,100)
if( prop:GetNWBool( "container" ) == true ) then

for k,v in pairs( prop.inventory ) do
LEMON.CreateMapItem( v, prop:GetPos(), prop:GetAngles(), prop:GetVelocity() )
end

end

if( prop:GetNWBool( "container2" ) == true ) then
if RarityMath == 1 then
LEMON.CreateMapItem( "drink_quantum_nukacola", prop:GetPos(), prop:GetAngles(), prop:GetVelocity() )
return
elseif RarityMath < 94 then
LEMON.CreateMapItem( "melee_fs_crowbar", prop:GetPos(), prop:GetAngles(), prop:GetVelocity() )
return
elseif RarityMath > 2 and RarityMath < 22 then
LEMON.CreateMapItem( "med_radaway", prop:GetPos(), prop:GetAngles(), prop:GetVelocity() )
elseif RarityMath > 22 and RarityMath < 94 then
LEMON.CreateMapItem( ContainerItems[math.random(1, #ContainerItems)], prop:GetPos(), prop:GetAngles(), prop:GetVelocity() )
end

end

end
-- Disown doors when the player leaves
function GM:PlayerDisconnected( ply )

if( ply.door != nil ) then

local door = ply.door
timer.Create( "doortimer", 600, 1, function() 
door.owner = nil
end )
end

end
-- Use the IsBlocked table for ents you want blocked.
function GM:CanTool( pl, tr, toolmode )

if( pl:IsSuperAdmin() ) then return true; end
if(tr.Entity:IsWeapon()) then LEMON.SendChat( pl, "Can't toolgun weapons." ) return false; end
if(tr.Entity:GetClass() == "item_prop") then LEMON.SendChat( pl, "Can't toolgun items." ) return false; end
if( LEMON.IsDoor( tr.Entity ) ) then LEMON.SendChat( pl, "Can't toolgun doors." ) return false; end
if( LEMON.IsBlocked( tr.Entity ) ) then LEMON.SendChat( pl, "Can't toolgun this entity." ) return false; end

return true;

end
-- NO gravpunt for u!
function GM:GravGunPunt( ply ) 

	return false;

end
-- Make sure the entity isn't blocked or anything, make sure to utilize LEMON.IsBlocked here. Very effective way of blocking several ents instead of doing them individually
function GM:PhysgunPickup( ply, ent )

	if( ply:IsSuperAdmin() ) then return true; end
	if( ent:IsWeapon() and not ent:IsNPC() ) then return false; end
	if( LEMON.IsDoor( ent ) ) then return false; end
	if( LEMON.IsBlocked( ent ) ) then return false; end

	if( ent:IsNPC() ) then return false; end
		
	if( ent:IsPlayer() ) then
		return false;
	end
	
	return true;

end
-- Super admin only
function GM:PlayerSpawnSWEP( ply, class )

	LEMON.CallTeamHook( "PlayerSpawnSWEP", ply, class ); -- Perhaps allow certain flags to use sweps, eh?
	
	if( ply:IsSuperAdmin( ) ) then return true; end
	return false;
	
end

function GM:PlayerGiveSWEP( ply )

	LEMON.CallTeamHook( "PlayerGiveSWEP", ply, class ); -- Perhaps allow certain flags to use sweps, eh?

	if( ply:IsSuperAdmin( ) ) then return true; end
	return false; 
	
end

-- This is the F1 menu
function GM:ShowHelp( ply )

	local PlyCharTable = LEMON.PlayerData[ LEMON.FormatSteamID( ply:SteamID() ) ]["characters"]
    if(ply:HasFlag("cp")) then cp = "cp"; else cp = " "; end
	for k, v in pairs( PlyCharTable ) do

		umsg.Start( "ReceiveChar", ply );
			umsg.Long( k );
			umsg.String( v[ "name" ] );
			umsg.String( v[ "model" ] );
			umsg.String( cp );
		umsg.End( );

	end

	umsg.Start( "playermenu", ply );
	umsg.End( )
	ply:RefreshBusiness( )
end

function GM:ShowSpare1( ply )

umsg.Start( "GoScore", ply );
umsg.End( );
ply:RefreshBusiness( )
end

function GM:ShowSpare2( ply )

umsg.Start( "GoInv", ply );
umsg.End( );
ply:RefreshBusiness( )
end

function GM:ShowTeam( ply )

umsg.Start( "GoCommands", ply );
umsg.End( );
ply:RefreshBusiness( )
end

-- NO SENT FOR YOU.
function GM:PlayerSpawnSENT( ply, class )

	LEMON.CallTeamHook( "PlayerSpawnSWEP", ply, class ); -- Perhaps allow certain flags to use sents, eh?
	
	if( ply:IsAdmin() or ply:IsSuperAdmin( ) ) then return true; end
	return false;
	
end

-- Disallows suicide
function GM:CanPlayerSuicide( ply )

    if( ply:GetNWInt( "suicided" ) == 1 ) then return false; end
    if( ply:GetNWInt( "tiedup" ) == 1 ) then return false; end

	
	local function CanSuicide( player )
	
	player:SetNWInt( "suicided", 0 )
	
	end
 
	timer.Simple( 120, function() CanSuicide( ply ) end )


	ply:SetNWInt( "suicided", 1 )
	return true;
	
end
-- Tie up
function ccTieUp( ply, cmd, args )
	local target = ents.GetByIndex( tonumber( args[ 1 ] ) );
	if(!target:IsPlayer()) then return false; end

	local function TieUp( player )

		player:SetNWInt( "tiedup", 1 )

		ply:ConCommand("say /me tied up ".. player:Nick());
		
		ply:TakeItem( "item_ziptie" );

	end

	local function UnTie( player )

		player:SetNWInt( "tiedup", 0 )

		ply:ConCommand("say /me unties ".. player:Nick());

	end

	if(target:GetNWInt( "tiedup" ) == 0) then 
		
		if( ply:HasItem( "item_ziptie" ) ) then

			ply:ConCommand("say /me starts to tie up ".. target:Nick());
			timer.Simple(8, function() TieUp( target ) end )
			
		else
			
			LEMON.SendChat( ply, "You need a ziptie to tie someone up!" );
			
		end

	elseif(target:GetNWInt( "tiedup" ) == 1) then

		ply:ConCommand("say /me starts untie ".. target:Nick());
		timer.Simple(10, function() UnTie( target ) end )

	end

end
concommand.Add( "rp_ziptie", ccTieUp )

-- Set Title
function ccSetTitle( ply, cmd, args )

	local title = args[ 1 ];
	
	if( string.len( title ) > 33 ) then
	
		LEMON.SendChat( ply, "Title is too long! Max 32 characters" );
		return;
		
	end
	
	LEMON.SetCharField( ply, "title", title );
	ply:SetNWString("title", title);
	
	return;
	
end
concommand.Add( "rp_title", ccSetTitle );

-- Change IC Name
function ccChangeName( ply, cmd, args )

	local name = args[ 1 ];
	LEMON.SetCharField(ply, "name", name );
	ply:SetNWString("name", name);
	
end
concommand.Add( "rp_changename", ccChangeName );

-- Allows a player to skip the respawn timer.
function ccAcceptDeath( ply, cmd, args )

	ply.deathtime = 120;
	
end
concommand.Add( "rp_acceptdeath", ccAcceptDeath );

function ccFlag( ply, cmd, args )
	
	local FlagTo = "";
	
	for k, v in pairs( LEMON.Teams ) do
	
		if( v[ "flag_key" ] == args[ 1 ] ) then
		
			FlagTo = v;
			FlagTo.n = k;
			break;
			
		end
		
	end
	
	if( FlagTo == "" ) then
	
		LEMON.SendChat( ply, "Incorrect Flag!" );
		return;
		
	end

	if( ( LEMON.GetCharField(ply, "flags" ) != nil and table.HasValue( LEMON.GetCharField( ply, "flags" ), args[ 1 ] ) ) or FlagTo[ "public" ] ) then
		
		ply:SetTeam( FlagTo.n );
		ply:RefreshBusiness();
		ply:ConCommand( "rp_permaflag ".. args[ 1 ] );
		ply:Spawn( );
		return;
				
	else
	
		LEMON.SendChat( ply, "You do not have this flag!" );
		
	end		
	
end
concommand.Add( "rp_flag", ccFlag );

-- Put an item in the players inventory from the containers list of items

function ccContainerTakeItem( ply, cmd, args )

    local entity = ents.GetByIndex( tonumber( args[ 1 ] ) );
	local argitem = args[ 2 ];
	local entinv = { }
	local hasitem = false;
	
	if( entity:GetPos():Distance( ply:GetPos() ) <= 100 ) then

	local itemtable = LEMON.ItemData[ argitem ];
	
	ply:GiveItem( itemtable.Class );
	
	for k,v in pairs( entity.inventory ) do
	
	if( v == argitem ) then
	argitemz = k
	end
	
	end
	
	table.remove( entity.inventory, argitemz );
	
	umsg.Start( "clearsearchgui", ply ) umsg.End( );
	ply:ClearInventory();

	for k,v in pairs( entity.inventory ) do

	local ItemTable = LEMON.ItemData[ v ];

	umsg.Start( "addsearchitem", ply )
	umsg.String( ItemTable.Model )
	umsg.Bool( ItemTable.Takeable )
	umsg.String( ItemTable.Class )
	umsg.Entity( entity )
	umsg.End( );

    end
	
	ply:RefreshInventory();

end
end
concommand.Add( "container_takeitem", ccContainerTakeItem )

-- Insert the selected item in the table that this command receives

function ccContainerPutItem( ply, cmd, args )
local entity = ents.GetByIndex( tonumber( args[ 1 ] ) );
local item = args[ 2 ];
local count = 0;

for k,v in pairs( entity.inventory ) do
count = count + 1;
end

if( count > entity:GetNWInt("limit") ) then
LEMON.SendChat( ply, "That container is full!");
return false;
end

   ply:TakeItem( item );
   table.insert( entity.inventory, item )

	umsg.Start( "clearsearchgui", ply ) umsg.End( );
	ply:ClearInventory();

	for k,v in pairs( entity.inventory ) do

	local ItemTable = LEMON.ItemData[ v ];

	umsg.Start( "addsearchitem", ply )
	umsg.String( ItemTable.Model )
	umsg.Bool( ItemTable.Takeable )
	umsg.String( ItemTable.Class )
	umsg.Entity( entity )
	umsg.End( );

    end
	
	ply:RefreshInventory();

end
concommand.Add( "container_putitem", ccContainerPutItem )

-- This was here before I was developing, might be interesting....

function ccSearchBody( ply, cmd, args )
	
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if(entity.loottable != nil and entity:GetNWInt( "lootable" ) == 1) then
    ply:ConCommand("say /me Searches the corpse.");


	ply:GiveItem( entity.loottable );
	entity.loottable = nil;
	entity:SetNWInt( "lootable", 0 )
	
	else
	
	LEMON.SendChat( ply, "You find nothing on the corpse worth while." );
	
	end

end
concommand.Add( "rp_searchbody", ccSearchBody );


--FUN :D
function ccIsGay( ply, cmd, args )
if(!ply:IsSuperAdmin()) then return false; end

local target = LEMON.FindPlayer(args[1]);

if( target:GetNWInt( "faggot" ) == 1 ) then 
target:SetNWInt( "faggot", 0 ); 
target:SetColor( 255, 255, 255, 255 );
return; end

if( target:IsPlayer() ) then

for k,v in pairs( player.GetAll() ) do
LEMON.SendChat( v, "Attention. ".. target:Nick() .. ", Is GAY." );
v:ConCommand("play music/HL2_song25_Teleporter.mp3");

timer.Simple(25, function()
v:ConCommand("stopsounds");
end)
end

target:SetNWInt( "faggot", 1 );
target:SetColor( 255, 0, 228, 255 )
end

end
concommand.Add( "rp_faggot", ccIsGay );

AllNightLong = 1;
function ccLetsRave( ply, cmd, args )
if(!ply:IsSuperAdmin()) then return false; end
AllNightLong = 1
for k,v in pairs( player.GetAll() ) do
LEMON.SendChat(v, "ITS RAVE TIME." );

local function PlaySong()

v:ConCommand("play music/HL2_song29.mp3");

end

local function PlaySongz()

v:ConCommand("play music/HL2_song12_long.mp3");

end


timer.Simple(1, function() PlaySong() end )
timer.Simple(135, function() PlaySongz() end )

v:SetNWInt( "rave", 1 )
local function RaveColorBaby()

v:SetColor( math.random(1,255), math.random(1,255), math.random(1,255), math.random(200,255) )

if(AllNightLong == 1) then
timer.Simple(0.2, function() RaveColorBaby() end )
end

end
timer.Simple(0.2, function() RaveColorBaby() end )

end

end
concommand.Add( "rp_ravetime", ccLetsRave )

function ccLetsNotRave( ply, cmd, args )
if(!ply:IsSuperAdmin()) then return false; end


for k,v in pairs( player.GetAll() ) do

v:SetNWInt( "rave", 0 )

timer.Simple(2, function()

v:SetColor( 255, 255, 255, 255 )

end);

v:ConCommand( "stopsounds" );

AllNightLong = 0;

end

end
concommand.Add("rp_ravetimeover", ccLetsNotRave );

-- If containter prop then search it

function ccSearchContainer( ply, cmd, args )
	
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( entity:GetNWBool( "container" ) == true ) then
	
	umsg.Start( "clearsearchgui", ply )
	umsg.End( );
	
	for k,v in pairs( entity.inventory ) do

	local ItemTable = LEMON.ItemData[ v ];

	umsg.Start( "addsearchitem", ply )
	umsg.String( ItemTable.Model )
	umsg.Bool( true )
	umsg.String( ItemTable.Class )
	umsg.Entity( entity )
	umsg.String( ItemTable.Name )
	umsg.String( ItemTable.Description )
	umsg.End( );

	end
	
	entity.title = "Container";
	
	umsg.Start( "startsearch", ply )
	umsg.String( entity.title )
	umsg.Entity( entity )
	umsg.End( );

	else
	
	LEMON.SendChat( ply, "You find nothing." );
	
	end
	
end
concommand.Add( "rp_search", ccSearchContainer );

--Read Letter Command 

function ccReadLetter( ply, cmd, args )
	
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ) );

	if entity:GetTable().Letter then
		umsg.Start("ShowLetter", ply)
			--umsg.Short(tr.Entity:GetNWInt("type"))
			umsg.Vector(entity:GetPos())
			local numParts = entity:GetNWInt("numPts")
			umsg.Short(numParts)
			for k=1, numParts do umsg.String(entity:GetNWString("part" .. tostring(k))) print(entity:GetNWString("part" .. tostring(k))) end
		umsg.End()	
		return
	end
end
concommand.Add( "rp_readletter", ccReadLetter );

--If owner Lock Door

function ccLockDoor( ply, cmd, args )
	
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( LEMON.IsDoor( entity ) ) then
	
		if( entity.owner == ply ) then
		
			entity:Fire( "lock", "", 0 );
			ply:EmitSound( "doors/door_locked2.wav" )
        elseif( ply:IsInDoorGroup( entity ) ) then
		
		entity:Fire( "lock", "", 0 );
			
		else
		
			LEMON.SendChat( ply, "This is not your door!" );
			
		end
		
	end

end
concommand.Add( "rp_lockdoor", ccLockDoor );

-- If own Unlock Door

function ccUnLockDoor( ply, cmd, args )
	
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( LEMON.IsDoor( entity ) ) then
	
		if( entity.owner == ply ) then
		
			entity:Fire( "unlock", "", 0 );
			ply:EmitSound( "doors/latchunlocked1.wav" )
	    elseif( ply:IsInDoorGroup( entity ) ) then
		
		entity:Fire( "unlock", "", 0 );
		

		else
		
			LEMON.SendChat( ply, "This is not your door!" );
			
		end
		
	end

end
concommand.Add( "rp_unlockdoor", ccUnLockDoor );


--Pick Lock Discontinued for some reason
--[[
function ccPickLockDoor( ply, cmd, args )
	
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( LEMON.IsDoor( entity ) ) then
	
		if( team.GetName(ply:Team()) == "Resistance" ) then
		
		    if(ply:GetNWInt("picklocking") == 1) then LEMON.SendChat( ply, "You're already picklocking a door!" ); return; end

		local function picklock(ply)

			local rand = math.random(1,12)

			if( rand == 6 ) then
			entity:Fire( "unlock", "", 0 );
			entity:Fire( "toggle", "", 0 );
		
			ply:ConCommand("say /me Successfully picklocks the door.");
			LEMON.SendChat( ply, "You picklocked the door!" );
			else
			LEMON.SendChat( ply, "Picklocking failed." );
			end
			timer.Destroy("door_"..ply:Nick());
			ply:SetNWInt("picklocking", 0);

        end
			

			
		    ply:SetNWInt("picklocking", 1);
			ply:ConCommand("say /me Tries to picklock the door.");
			timer.Create( "door_"..ply:Nick(), 4, 0, picklock, ply );

			
		else
		
			LEMON.SendChat( ply, "You cannot picklock doors!" );
			
		end
		
	end

end
concommand.Add( "rp_picklock", ccPickLockDoor );
]]--

-- Make sure the door is not in a door group or whatever

function ccOpenDoor( ply, cmd, args )

	local entity = ply:GetEyeTrace().Entity;
	
	if( entity != nil and entity:IsValid( ) and LEMON.IsDoor( entity ) and ply:GetPos( ):Distance( entity:GetPos( ) ) < 200 ) then
	
		local pos = entity:GetPos( );
		
		for k, v in pairs( LEMON.Doors ) do
		
			if( tonumber( v[ "x" ] ) == math.ceil( tonumber( pos.x ) ) and tonumber( v[ "y" ] ) == math.ceil( tonumber( pos.y ) ) and tonumber( v[ "z" ] ) == math.ceil( tonumber( pos.z ) ) ) then
			
				for k2, v2 in pairs( LEMON.Teams[ ply:Team( ) ][ "door_groups" ] ) do
				
					if( tonumber( v[ "group" ] ) == tonumber( v2 ) ) then
					
						entity:Fire( "toggle", "", 0 );
						
					end
					
				end
				
			end
			
		end
		
	end
	
end
concommand.Add( "rp_opendoor", ccOpenDoor );

-- Buy Doors Command -- Having problems wit h the admin unown feature. Don't know why D:

function ccPurchaseDoor( ply, cmd, args )
	local door = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	local pos = door:GetPos( );
	
	for k, v in pairs( LEMON.Doors ) do
		
		if( tonumber( v[ "x" ] ) == math.ceil( tonumber( pos.x ) ) and tonumber( v[ "y" ] ) == math.ceil( tonumber( pos.y ) ) and tonumber( v[ "z" ] ) == math.ceil( tonumber( pos.z ) ) ) then
		
			LEMON.SendChat( ply, "This is not a purchaseable door!" );
			return;
			
		end
		
	end
	
	if( LEMON.IsDoor( door ) ) then

		if( door.owner == nil ) then
		
			if( tonumber( LEMON.GetCharField( ply, "money" ) ) >= 25 ) then
				
				-- Enough money to start off, let's start the rental.
				ply:ChangeMoney( -25 );
				door.owner = ply;
				ply.door = door;
				
				local function Rental( ply, doornum )
				
					local door = ents.GetByIndex( tonumber( doornum ) );
					
					if( door.owner == ply ) then
					
						if( tonumber( LEMON.GetCharField( ply, "money" ) ) >= 10 ) then
						
							ply:ChangeMoney( 0 - 10 );
							LEMON.SendChat( ply, "You have been charged $10 caps for a door!" );
							-- Start the timer again
							timer.Simple( 1800, Rental, ply, doornum ); -- 30 minutes hoo rah
							
						else
						
							LEMON.SendChat( ply, "You have lost a door due to insufficient funds." );
							door.owner = nil;
							
						end
						
					end
				
				end
				
				timer.Simple( 900, Rental, ply, tonumber( args[ 1 ] ) );
				
			end
			
		elseif( door.owner == ply ) then
		
			door.owner = nil;
			LEMON.SendChat( ply, "Door Unowned" );
			
		elseif ply:IsAdmin() or ply:IsSuperAdmin() then
		
			door.owner = nil
			LEMON.SendChat( ply, "Forced door unowned!" )
			
		else
		
			LEMON.SendChat( ply, "This door is already rented by someone else!" );
			
		end
	
	end
	
end
concommand.Add( "rp_purchasedoor", ccPurchaseDoor );

-- General Drop weapon command, This is currnetly the only way to store weapons if they are equiped in the players inventory. This can be glitched as well. When the player drops it will restore ammo on pickup. shh shh

function ccDropWeapon( ply, cmd, args )
	
	local wep = ply:GetActiveWeapon( )
	local wepclip = wep:Clip1()
	
	-- if wep:GetClass( ) == "weapon_crowbar" then
	
		-- LEMON.CreateItem( "melee_fs_crowbar", ply:CalcDrop( ), Angle( 0, 0, 0 ) )
		-- return;
		
	-- end
	
	if ( LEMON.ItemData[ wep:GetClass( ) ] == nil ) then 
		LEMON.SendChat( ply, "This weapon cannot be dropped!" ); 
		return; 
	end
	
	ply:StripWeapon( wep:GetClass( ) );
	
	LEMON.CreateItem( wep:GetClass( ), ply:CalcDrop( ), Angle( 0,0,0 ) );
	
	if ( wep:GetClass( ) == "gun_fs_colt" ) then ply:GiveAmmo(wepclip,"smg1"); end
	if ( wep:GetClass( ) == "gun_fs_deagle" ) then ply:GiveAmmo(wepclip,"357"); end
	if ( wep:GetClass( ) == "gun_fs_citykiller" ) then ply:GiveAmmo(wepclip,"buckshot"); end
	
end
concommand.Add( "rp_dropweapon", ccDropWeapon );

-- General Pickup Item Command

function ccPickupItem( ply, cmd, args )
	
	local item = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	if( item != nil and item:IsValid( ) and item:GetClass( ) == "item_prop" and item:GetPos( ):Distance( ply:GetShootPos( ) ) < 100 ) then
		
		item:Pickup( ply );
		ply:GiveItem( item.Class );
		
	end

end
concommand.Add( "rp_pickup", ccPickupItem );

-- General use item command

function ccUseItem( ply, cmd, args )

	local item = ents.GetByIndex( tonumber( args[ 1 ] ) );

	if( ply:GetNWInt( "tiedup" ) == 1 ) then return false; end

	if( item != nil and item:IsValid( ) and item:GetClass( ) == "item_prop" and item:GetPos( ):Distance( ply:GetShootPos( ) ) < 100 ) then
		
		item:UseItem( ply );
		
	end

end
concommand.Add( "rp_useitem", ccUseItem );

-- Kill Self Command in rp, No reason as of now.

function ccDeathMeh( ply, cmd, args )

	ply:Kill()
	
end
concommand.Add( "rp_deathmeh", ccDeathMeh )

-- GIFT MONEY -- SUPER ADMIN ONLY

function ccGiftFreeMoney( ply, cmd, args )

	if args[1] == nil then

		LEMON.SendChat( ply, "You must enter a name or part of a name!" )
	
	end

	if args[2] == nil then

		LEMON.SendChat( ply, "You must enter an amount!" )
	
	end

	if ply:IsSuperAdmin() then

		LEMON.FindPlayer( args[1] ):ChangeMoney( args[2] )
	
	else

		LEMON.SendChat( ply, "Super Admin Only" )

	end

end
concommand.Add( "rp_giftcaps", ccGiftFreeMoney )

-- GENERAL GIVE MONEY TO PLAYER COMMAND

function ccGiveMoney( ply, cmd, args )
	
	if( player.GetByID( args[ 1 ] ) != nil ) then
	
		local target = player.GetByID( args[ 1 ] );
		
		if( tonumber( args[ 2 ] ) > 0 ) then
		
			if( tonumber( LEMON.GetCharField( ply, "money" ) ) >= tonumber( args[ 2 ] ) ) then
			
				target:ChangeMoney( args[ 2 ] );
				ply:ChangeMoney( 0 - args[ 2 ] );
				LEMON.SendChat( ply, "You gave " .. target:Nick( ) .. " $" .. args[ 2 ] .. " caps!" );
				LEMON.SendChat( target, ply:Nick( ) .. " gave you $" .. args[ 2 ] .. " caps!" );
				
			else
			
				LEMON.SendChat( ply, "You do not have that much money!" );
				
			end
			
		else
		
			LEMON.SendChat( ply, "Invalid amount of caps!" );
			
		end
		
	else
	
		LEMON.SendChat( ply, "Target not found!" );
		
	end
	
end
concommand.Add( "rp_givemoney", ccGiveMoney );	

-- OOC Delay

function ccOOCTimer( ply, cmd, args )

	if args[1] == nil then
	
		LEMON.SendChat( ply, "You didn't set a time in seconds..." )
	
	end
	
	LEMON.ConVars[ "OOCDelay" ] = args[1]
	
end
concommand.Add( "rp_ooctimer", ccOOCTimer )

function ccSoundTimer( ply, cmd, args )

	if args[1] == nil then
	
		LEMON.SendChat( ply, "You didn't set a time in seconds..." )
	
	end
	
	LEMON.ConVars[ "SoundDelay" ] = args[1]
	
end
concommand.Add( "rp_soundtimer", ccSoundTimer )

--	Problem with the notification window. It locks the players keyboard and doesn't show the mouse sometimes.
--	Warnings System -- 3 warns and that player is kicked banned for 720 minutes
--	Seems to function fine. SetReason sets what the player sees when they are warned

function ccSetReason( ply, cmd, args )

	if args[1] == nil then
	
		LEMON.SendChat( ply, "Need to give the user a reason." )
		
	end
	
	
	SetGlobalString( "wreasons", args[1])

end
concommand.Add( "rp_setreason", ccSetReason )

function ccTakeWarn( ply, cmd, args )
	
	if( player.GetByID( args[1] ) != nil ) then
	
		local target = player.GetByID( args[1] );
		-- print( target )
		-- print( LEMON.FindPlayer( args[1] ) )
		if( tonumber( args[2] ) >= 1 ) then
		
			-- if( tonumber( LEMON:GetPlayerField( ply, "warnings" ) ) >= tonumber( args[2] ) ) then
			-- target
				LEMON.FindPlayer( args[1] ):ChangeWarning( 0 - args[2] )
				--ply:ChangeWarning( 0 - args[2] );

				LEMON.SendChat( ply, "You took " .. LEMON.FindPlayer( args[1] ):Name() .. " ".. args[2] .." warning/s" )
				LEMON.FindPlayer( args[1] ):SendLua( "Warning_Message()" )
					
			-- else
			
				-- LEMON.SendChat( ply, "huh? Error! ERROR! err0r!" );
				
			-- end
			
		else
		
			LEMON.SendChat( ply, "Invalid amount of warnings!" );
			
		end
		
	else
	
		LEMON.SendChat( ply, "Target not found!" );
		
	end
	
end
concommand.Add( "rp_takewarn", ccTakeWarn )	

function ccGiveWarn( ply, cmd, args )
	
	if( player.GetByID( args[1] ) != nil ) then
	
		local target = player.GetByID( args[1] );
		-- print( target )
		-- print( LEMON.FindPlayer( args[1] ) )
		if( tonumber( args[2] ) >= 1 ) then
			-- if args[3] == nil then
				-- LEMON.SendChat( ply, "You have to enter a reason." )
				-- return
			-- end
			-- if( tonumber( LEMON:GetPlayerField( ply, "warnings" ) ) >= tonumber( args[2] ) ) then
			-- target
				LEMON.FindPlayer( args[1] ):ChangeWarning( args[2] )
				--ply:ChangeWarning( 0 - args[2] );

				LEMON.SendChat( ply, "You gave " .. LEMON.FindPlayer( args[1] ):Name() .. " ".. args[2] .." warning/s" )
				LEMON.FindPlayer( args[1] ):SendLua( "Warning_Message()" ) 
				
			if LEMON.GetPlayerField( LEMON.FindPlayer( args[1] ), "warnings" ) >= 3 then
			
				LEMON.FindPlayer( args[1] ):ChangeWarning( 0 - 3 ) 
				RunConsoleCommand( "rp_admin", "ban", "".. args[1] .."", "You had 3 warnings", "720" )
				
			end		
			
		else
		
			LEMON.SendChat( ply, "Invalid amount of warnings!" );
			
		end
		
	else
	
		LEMON.SendChat( ply, "Target not found!" );
		
	end
	
end
concommand.Add( "rp_givewarn", ccGiveWarn )	

--	the Test VGUI will submit the console commands if the chekced the right answer and this code will make sure they passed, else it will kick ban 10 minutes.
--	RP QUIZ  -- Having trouble getting this and the rules screen to popup on player join, before the character creation screen comes up.
--	the a stands for Answer Number the q Stands for Question Number

function cca2q1( ply, cmd, args )

	ply:SetNWInt( "a2q1", 1 )
	
end
concommand.Add( "a2q1", cca2q1 )

function cca4q2( ply, cmd, args )

	ply:SetNWInt( "a4q2", 1 )
	
end
concommand.Add( "a4q2", cca4q2 )

function cca3q3( ply, cmd, args )

	ply:SetNWInt( "a3q3", 1 )
	
end
concommand.Add( "a3q3", cca3q3 )

function cca14q4( ply, cmd, args )

	ply:SetNWInt( "a14q4", 1 )
	
end
concommand.Add( "a14q4", cca14q4 )

function cca13q5( ply, cmd, args )

	ply:SetNWInt( "a13q5", 1 )
	
end
concommand.Add( "a13q5", cca13q5 )

function cca1q6( ply, cmd, args )

	ply:SetNWInt( "a1q6", 1 )
	
end
concommand.Add( "a1q6", cca1q6 )

function ccHaveTested( ply, cmd, args )
	if LEMON.GetPlayerField( LEMON.FindPlayer( ply:Name() ), "tested" ) == 0 then
	ply:SetNWBool( "testing", true )
	ply:ConCommand( "rp_rules3" )
	return
	end
end
concommand.Add( "havetested", ccHaveTested )

function ccCheckTest( ply, cmd, args )
	local correctanswers = 
	{
	
		2, 4, 3, 1, 3, 1 -- This all here is really for ref, nothing uses this table
	
	}
	if LEMON.GetPlayerField( LEMON.FindPlayer( ply:Name() ), "tested" ) == 1 then
		LEMON.SendChat( ply, "You can't test twice!" )
		return
	end
	
	if ply:GetNWInt( "a2q1" ) == 0 then
	RunConsoleCommand( "rp_admin", "ban", ply:Name(), "Failed the Test", "10" )	
	return 
	end
	
	if ply:GetNWInt( "a4q2" ) == 0 then
	RunConsoleCommand( "rp_admin", "ban", ply:Name(), "Failed the Test", "10" )	
	return 
	end
	
	if ply:GetNWInt( "a3q3" ) == 0 then
	RunConsoleCommand( "rp_admin", "ban", ply:Name(), "Failed the Test", "10" )	
	return 
	end
	
	if ply:GetNWInt( "a14q4" ) == 0  then
	RunConsoleCommand( "rp_admin", "ban", ply:Name(), "Failed the Test", "10" )	
	return 
	end
	
	if ply:GetNWInt( "a13q5" ) == 0 then
	RunConsoleCommand( "rp_admin", "ban", ply:Name(), "Failed the Test", "10" )
	return
 	end
	
	if ply:GetNWInt( "a1q6" ) == 0 then
	RunConsoleCommand( "rp_admin", "ban", ply:Name(), "Failed the Test", "10" )	
	return 
	end
	
	ply:Tested( 1 )
	
end
concommand.Add( "rp_checkmytest", ccCheckTest )	

function ccDoneTesting( ply, cmd, args )

	ply:SetNWBool( "testing", false ) -- Lets send the done testing signal for other things to use
	
end
concommand.Add( "donetesting", ccDoneTesting )

--Tell if the client has his or her chat box open, used in the HUD file to see if a player is typing or not...

function ccOpenChat( ply, cmd, args )

	ply:SetNWInt( "chatopen", 1 )
	
end
concommand.Add( "rp_openedchat", ccOpenChat );

function ccCloseChat( ply, cmd, args )

	ply:SetNWInt( "chatopen", 0 )
	
end
concommand.Add( "rp_closedchat", ccCloseChat );



--Hai is purly a experiment by Otoris
-- function ccHAI( ply, cmd, args )

-- if ply:Alive() then  
   
            -- ply:SetPlaybackRate(1.0)  
			-- ply:RestartGesture(ACT_GESTURE2)  
            -- ply.Ent:ResetSequence("signal_halt")  
            -- ply:SetCycle(0)   

-- end	
-- local sequence = ply:LookupSequence("signal_halt") 
-- ply:RestartGesture( ACT_GESTURE2 )  
	-- ply:SetPlaybackRate( 1.0 )
	-- ply:ResetSequence( "ACT_GESTURE2" )
	-- ply:SetCycle( 1 )
-- end
-- concommand.Add( "rp_wave", ccHAI )
-- hook.Add("UpdateAnimation","AnimateProp",ccHAI) 


--All Random item drop code starts here
-- The entire system uses timers and such, crate spawn is not actually working cause there is not a crate yet!
--Add any items here, format them the way you see it and then go down to itemtodrop and change the number in math.random to the number of items you have there.
randomitemlist = {}
randomitemlist[1] = "drink_randomwater"
randomitemlist[2] = "drink_nukacola"
randomitemlist[3] = "drink_dirtywater"

-- These coords are for gm_atomic only, I measured the map using getpos in the console and did the math.
function ccCreateRandomDrop( ply, cmd )

--config if you know what you are doing... xxx yyy zzz are all world vectors
itemtodrop = randomitemlist[math.random( 1, 6 )]
xxx = math.random( -13845, 14319 )
yyy = math.random( -13849, 14319 )
zzz = -9000 

LEMON.CreateItem( itemtodrop, Vector( xxx, yyy, zzz ), Vector(0, 0, 0) )

--debugger to find the coordiantes of the drop
--print( "setpos ".. xxx .." ".. yyy .." ".. zzz )

end
concommand.Add( "rp_randomitemdrop", ccCreateRandomDrop )

function ccStopTimerRandomDrop( ply, cmd )

timer.Create( "stoprandomcrates", 21, 1, function()
timer.Stop( "randomcrates" ) end )

timer.Create( "stoprandomitems", 200, 0, function()
	timer.Stop( "randomitems" )
	timer.Stop( "stoprandomitems" )
	for k, v in pairs(player.GetAll()) do
	if v:IsAdmin() or v:IsSuperAdmin() then
		LEMON.SendChat( v, "Random items have stopped falling" )
	end
	end
	--print( "Items have stopped falling..." )
end )

end
concommand.Add( "rp_stopdroptimer", ccStopTimerRandomDrop )

function ccStartRandomDrop( ply, cmd )
everysecondstodrop = 4
timer.Create( "randomitems", everysecondstodrop, 0, function()
	RunConsoleCommand( "rp_randomitemdrop" )
end )

timer.Create( "randomcrates", 5, 0, function()
	RunConsoleCommand( "rp_randomcratedrop" )
end )
for k, v in pairs(player.GetAll()) do
if v:IsAdmin() or v:IsSuperAdmin() then
	LEMON.SendChat( v, "Items have started falling..." )
end
end
LEMON.CreateItem( "drink_quantum_nukacola", Vector( xxx, yyy, zzz ), Vector(0, 0, 0) )
RunConsoleCommand( "rp_stopdroptimer" )
RunConsoleCommand( "rp_stopcratetimer" )

end
concommand.Add( "rp_startrandomdrop", ccStartRandomDrop )

--This will give the player back his weps after being KOed

function ccGiveWeapons( ply, cmd, args )

ply:GetTable().ForceGive = true
	local wep = ply.Weps
	for i=1, #wep, 1 do
		ply:Give(wep[i])
	end	
	PrintTable( wep )
	table.Empty( wep )
	PrintTable( wep )
ply:GetTable().ForceGive = false
	
end
concommand.Add( "rp_readkostorage", ccGiveWeapons )

--Okay check for item names that need to be removed! then execute!

function ccRemoveRandomItems( ply, cmd, args )

	if args[1] == nil then
		for k, v in pairs( ents.FindByName("ritem1") ) do

			v:Remove()
			
		end
		
		for k,v in pairs(ents.FindByName("ritem2")) do
		
			v:Remove()
			
		end
		
		for k, v in pairs(ents.FindByName( "crates" ) ) do
			v:Remove()
		end
	end

end
concommand.Add( "rp_removerandomitems", ccRemoveRandomItems )

-- This is a custom toggle holster script! Please add a new fixed version of NPC animations and block this code! Make sure to change the models the player can select in the schemas/falloutrp.lua

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

function ccToggleHolster( ply, cmd, args )

	if( not ply:GetActiveWeapon():IsValid() ) then
		return;
	end

	if( ply:GetNWInt( "holstertoggled" ) == 1 ) then
		
		for j, l in pairs( notaimed ) do
			
			if( l == ply:GetActiveWeapon():GetClass() ) then
				return;
			end
			
		end
	
		Aim( ply );
	else
		
		for j, l in pairs( aimed ) do
			
			if( l == ply:GetActiveWeapon():GetClass() ) then
				return;
			end
			
		end
		
		UnAim( ply );
	end

end

concommand.Add( "rp_toggleholster", ccToggleHolster )
concommand.Add( "toggleholster", ccToggleHolster )

function Aim( ply )

	ply:DrawViewModel( true )
	ply:DrawWorldModel( true )
	ply:GetActiveWeapon():SetNextPrimaryFire( CurTime() )
	--ply:GetActiveWeapon():SetNextSecondaryFire( CurTime() )
	
	
	if( ply:GetActiveWeapon():GetNWBool( "ironsights" ) == true ) then
			--ply:DrawCrosshair( false )
	end
	ply:SetNWInt( "holstertoggled", 0 )
	ply:ConCommand( "rp_currentweapon" )
end

function UnAim( ply )

	ply:DrawViewModel( false )
	ply:DrawWorldModel( false )
	ply:GetActiveWeapon():SetNextPrimaryFire( CurTime() + 1000000 )
	-- ply:GetActiveWeapon():SetNextSecondaryFire( CurTime() + 1000000 )

	if( ply:GetActiveWeapon():GetNWBool( "ironsights" ) == true ) then
		ply:GetActiveWeapon():SetNWBool( "ironsights", false )
	end
	
	ply:SetNWInt( "holstertoggled", 1 )
	ply:ConCommand( "rp_currentweapon" )
end

-- Admin function to see names above everyplayer in the server - see cl_hud.lua

function ccSeeAll( ply, cmd, args )
if(!ply:IsAdmin() or !ply:IsSuperAdmin()) then LEMON.SendChat( ply, "You're not an admin! D:" ) return false; end

		if ply:GetNWInt( "seeall" ) == 1 then
			ply:SetNWInt( "seeall", 0 )
		elseif ply:GetNWInt( "seeall" ) == 0 then
			ply:SetNWInt( "seeall", 1 )
		end

end
concommand.Add( "rp_seeall", ccSeeAll )

--Play sound all command simple and efficient taken from example and built upon.

local function ccPlaySound(playerx, command, arguments)

	//Run on all clients when triggered by admins
	if  playerx:IsAdmin() || playerx:IsSuperAdmin() then

		//Don't run if no sound specified
		if arguments[1] == nil then return end

		//Stop sounds if "stop"
		if arguments[1] == "stop" then
			local locateplayers = player.GetAll()
			for i = 1, table.getn(locateplayers) do
			locateplayers[i]:ConCommand("stopsounds")
			end
		return end

		util.PrecacheSound(arguments[1])

		//Play sound
		local locateplayers = player.GetAll()

		
	if(playerx.LastPlaySound + LEMON.ConVars[ "SoundDelay" ] < CurTime() ) then
	
		playerx.LastPlaySound = CurTime();
		return 
	
	else
	
		local TimeLeft = math.ceil(playerx.LastPlaySound + LEMON.ConVars[ "SoundDelay" ] - CurTime());
		LEMON.SendChat( ply, "Please wait " .. TimeLeft .. " seconds before playing another song.");
		
		return false;
		
	end
	for i = 1, table.getn(locateplayers) do
		locateplayers[i]:ConCommand("play " .. arguments[1] .. "")
	end
	end
	
end

concommand.Add( "playsound", ccPlaySound )
