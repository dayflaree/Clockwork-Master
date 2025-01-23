-------------------------------
-- LemonadeScript
-- Author: LuaBanana and Looter
-- Project Start: 5/24/2008
--
-- cl_charactercreate.lua
-- Houses some functions for the character creation.
-------------------------------

TeamTable = {};

function SetUpTeam(data)

	local newteam = {}
	newteam.id = data:ReadLong();
	newteam.name = data:ReadString();
	newteam.r = data:ReadLong();
	newteam.g = data:ReadLong();
	newteam.b = data:ReadLong();
	newteam.a = data:ReadLong();
	newteam.public = data:ReadBool();
	newteam.salary = data:ReadLong();
	newteam.flagkey = data:ReadString();
	newteam.business = data:ReadBool();
	
	team.SetUp(newteam.id, newteam.name, Color(newteam.r,newteam.g,newteam.b,newteam.a));
	TeamTable[newteam.id] = newteam;
	
end
usermessage.Hook("setupteam", SetUpTeam);

ChosenModel = "";
models = {};

function AddModel( data )

	table.insert( models, data:ReadString( ) )
	
end
usermessage.Hook( "addmodel", AddModel );

function SetChosenModel( mdl )

	if( table.HasValue( models, mdl ) ) then	
	
		ChosenModel = mdl
		
	else
	
		LocalPlayer( ):PrintMessage( 3, LEMON.ChosenModel .. " is not a valid model!" );
		
	end
	
end

ExistingChars = {  }

function ReceiveChar( data )

	local n = data:ReadLong( );
	ExistingChars[ n ] = {  }
	ExistingChars[ n ][ 'name' ] = data:ReadString( );
	ExistingChars[ n ][ 'model' ] = data:ReadString( );
	ExistingChars[ n ][ 'flags' ] = data:ReadString( );
	
end
usermessage.Hook( "ReceiveChar", ReceiveChar );

local function CharacterCreatePanel( )


	CreatePlayerMenu( )
	PlayerMenu:ShowCloseButton( false )
	PropertySheet:SetActiveTab( PropertySheet.Items[ 2 ].Tab );
	PropertySheet.SetActiveTab = function( ) end;
	
	InitHUDMenu( );

	
end
usermessage.Hook( "charactercreate", CharacterCreatePanel );