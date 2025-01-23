/*-------------------------------------------------------------------------------------------------------------------------
	Vars
-------------------------------------------------------------------------------------------------------------------------*/

local rtvPlayers = 0
local started = false
local mapcandidates = {
	"zm_roy_the_ship",
	"zm_hospital_remix",
	"zm_downtown_v1",
	"ttt_enclave_b1",
	"ttt_clue_pak",
	"ttt_canyon_a4",
	"ttt_camel_v1",
	"ttt_amsterville_b5",
	"rp_christmastown",
	"dm_richland",
	"dm_island17",
}
local maps = {}
local votes = {}

/*-------------------------------------------------------------------------------------------------------------------------
	Send maps to people
-------------------------------------------------------------------------------------------------------------------------*/

local function SendMaps()
	umsg.Start( "TTT_Maps" )
		for i = 1, 6 do
			umsg.Char( maps[i] )
		end
	umsg.End()
end

hook.Add( "Initialize", "VoteOverride", function()
	/*-------------------------------------------------------------------------------------------------------------------------
		Override the voting end behaviour
	-------------------------------------------------------------------------------------------------------------------------*/
	
	function GAMEMODE:FinishGamemodeVote()		
		local highest = -1
		local candidates = {}
		
		for i = 1, 6 do
			if ( ( votes[i] or 0 ) > highest ) then
				candidates = { i }
				highest = votes[i] or 0
			elseif ( ( votes[i] or 0 ) == highest ) then
				table.insert( candidates, i )
			end
		end
		
		local map = maps[ table.Random( candidates ) ]
		RunConsoleCommand( "changegamemode", mapcandidates[map], "TerrorTown" )
	end
	
	/*-------------------------------------------------------------------------------------------------------------------------
		RTV
	-------------------------------------------------------------------------------------------------------------------------*/
	
	hook.Add( "PlayerSay", "RTVHook", function( ply, msg )
		if ( started ) then return end
		
		if ( msg == "rtv" ) then			
			if ( ply.TTT_RTV ) then
				ply:SendLua( "chat.AddText( Color( 255, 0, 0 ), [[You have already rock'd the vote!]] )" )
			else
				if ( rtvPlayers + 1 >= #player.GetAll() * 70 / 100 ) then		
		
					BroadcastLua( "chat.AddText( Entity("..ply:EntIndex().."), Color( 255, 255, 255 ), [[ has rock'd the vote!]] )" )
					BroadcastLua( "chat.AddText( Color( 255, 0, 0 ), [[Voting has started!]] )" )
					
					started = true
					SendMaps()
					timer.Simple( 3, function() GAMEMODE:StartGamemodeVote() end )
				else
					BroadcastLua( "chat.AddText( Entity("..ply:EntIndex().."), Color( 255, 255, 255 ), [[ has rock'd the vote! (" .. math.ceil( #player.GetAll() * 70 / 100 - rtvPlayers - 1 ) .. " more required)]] )" )
					ply.TTT_RTV = true
				end
				
				return ""
			end
		end
	end )
	
	timer.Create( "RTVCheck", 1, 0, function()
		if ( started or #player.GetAll() == 0 ) then return end
		
		rtvPlayers = 0
		
		for _, ply in ipairs( player.GetAll() ) do
			if ( ply.TTT_RTV ) then rtvPlayers = rtvPlayers + 1 end
		end
		
		if ( rtvPlayers >= #player.GetAll() * 70 / 100 ) then			
			BroadcastLua( "chat.AddText( Color( 255, 255, 255 ), [[Voting has started!]] )" )
			
			started = true
			SendMaps()
			timer.Simple( 3, function() GAMEMODE:StartGamemodeVote() end )
		end
	end )
end )

/*-------------------------------------------------------------------------------------------------------------------------
	Console command to vote
-------------------------------------------------------------------------------------------------------------------------*/

local function SyncVotes()
	umsg.Start( "TTT_Vote" )
		for i = 1, 6 do
			if ( votes[i] ) then
				umsg.Char( votes[i] )
			else
				umsg.Char( 0 )
			end
		end
	umsg.End()
end

concommand.Add( "TTT_Vote", function( ply, com, args )
	if ( !maps[ tonumber( args[1] ) ] ) then return end
	local vote = tonumber( args[1] )
	
	if ( ply.TTT_Vote ) then
		votes[ply.TTT_Vote] = votes[ply.TTT_Vote] - 1
	end
	ply.TTT_Vote = vote
	
	if ( !votes[vote] ) then votes[vote] = 0 end
	votes[vote] = votes[vote] + 1
	
	SyncVotes()
end )

/*-------------------------------------------------------------------------------------------------------------------------
	Pick random maps
-------------------------------------------------------------------------------------------------------------------------*/

for i = 1, 6 do
	local c = math.random( #mapcandidates )
	while ( table.HasValue( maps, c ) ) do c = math.random( #mapcandidates ) end
	table.insert( maps, c )
end
PrintTable( maps )

hook.Add( "PlayerSpawn", "TTT_Sync", function( ply )
	umsg.Start( "TTT_Maps", ply )
		for i = 1, 6 do
			umsg.Char( maps[i] )
		end
	umsg.End()
end )