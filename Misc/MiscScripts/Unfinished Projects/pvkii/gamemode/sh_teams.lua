// Set up teams
TEAM_PIRATES = 1
TEAM_VIKINGS = 2
TEAM_KNIGHTS = 3

team.SetUp( TEAM_PIRATES, "Pirates", Color( 255, 62, 62, 255 ) )
team.SetUp( TEAM_VIKINGS, "Vikings", Color( 156, 253, 148, 255 ) )
team.SetUp( TEAM_KNIGHTS, "Knights", Color( 158, 205, 255, 255 ) )

// Load classes for each team
GM.Classes = {}

for _, filename in pairs( file.Find( "../" .. GM.Folder .. "/gamemode/playerclasses/*.lua" ) ) do
	CLASS = {}
		AddCSLuaFile( "playerclasses/" .. filename )
		include( "playerclasses/" .. filename )
		
		GM.Classes[CLASS.Id] = CLASS
	CLASS = nil
end

// Get class by name
function GM:ClassByName( name )
	for _, class in pairs( GAMEMODE.Classes ) do
		if ( class.Name == name ) then
			return class
		end
	end
end

// Get class of player
function GM:GetClass( ply )
	if ( SERVER ) then
		return self.Class
	else
		return self.Classes[ ply:GetDTInt( 0 ) ]
	end
end

if ( SERVER ) then
	// Set team and class of player
	function GM:SetClass( ply, class )
		ply:SetTeam( class.Team )
		ply:SetDTInt( 0, class.Id )
		ply.Class = class
		
		ply:StripWeapons()
		ply:Spawn()
	end
end