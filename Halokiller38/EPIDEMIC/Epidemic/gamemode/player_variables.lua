
-- ========================================= --
-- PLAYER VARIABLES                          --
-- ========================================= --

---------------------------------------------------------
-- CreatePlayerVariable( name, type, default, canreset ):

-- name:  The name of the variable.  When you create a player variable, player functions will
-- be created for setting and getting these variables.  These functions will look like:
-- [Player]:SetPlayer(name)
-- [Player]:GetPlayer(name)
-- example - ply:SetPlayerSprint and ply:GetPlayerSprint

-- type:  The umsg type.  
-- You'll most likely use either.. 
-- Float - floating point numbers. AKA decimals.
-- Long - Huge integers (non-demical numbers)
-- Short - Small integers (non-decimal numbers)
-- Bool - true or false
-- String - Any form of text
-- Char - A single byte or character.
-- Vector - vectors, a data type with the x, y, z variables.
-- Angle - angles.
-- Entity - An entity
-- It's important that you pick the right one.  
-- Bigger data types like long, or big strings take longer to send to the client. 
-- The lag will be noticable.

-- default:  The default value for the variable for when the player first joins.  Can be nil.

-- canreset:  Each player has a function called :Reset(), which when called, will reset certain player variables to their default values.  
-- Put this as true if you want this variable to be resettable, put it as false or leave it blank otherwise.

---------------------------------------------------------

-- CreatePlayerSSVariable( name, value ) :  Creates a server side player variable

-- name: Name of the variable
-- value: Default value of the variable

---------------------------------------------------------


CreatePlayerVariable( "LastOOC", "Float", 0, false );
CreatePlayerVariable( "Sprint", "Float", 100, true );
CreatePlayerVariable( "Conscious", "Float", 100, true );
CreatePlayerVariable( "Flags", "String", "", false );
CreatePlayerVariable( "Class", "String", "", true );
CreatePlayerVariable( "Age", "Short", 0, true );
CreatePlayerVariable( "PhysDesc", "String", "", true );
CreatePlayerVariable( "Ragdolled", "Bool", false, false );
CreatePlayerVariable( "CanLeaveCharacterCreate", "Bool", false, false );
CreatePlayerVariable( "SBTitle", "String", "", false );

CreatePlayerVariable( "Armor", "Float", 0, true );
CreatePlayerVariable( "Blood", "Float", 100, true );
CreatePlayerVariable( "LArmHP", "Float", 100, true );
CreatePlayerVariable( "RArmHP", "Float", 100, true );
CreatePlayerVariable( "LLegHP", "Float", 100, true );
CreatePlayerVariable( "RLegHP", "Float", 100, true );

CreatePlayerSSVariable( "MaxHealth", 100 );
CreatePlayerSSVariable( "AdminFlags", "" );
CreatePlayerSSVariable( "OriginalModel", "" );
CreatePlayerSSVariable( "MySQLCharID", 0 );
CreatePlayerSSVariable( "LastHeldWeapon", "" );
CreatePlayerSSVariable( "DidInitialCC", false );
CreatePlayerSSVariable( "BleedingAmount", 0 );
CreatePlayerSSVariable( "IsInfected", false );
CreatePlayerSSVariable( "LWAmmo", 0 );
CreatePlayerSSVariable( "HWAmmo", 0 );
CreatePlayerSSVariable( "LastLWAmmo", 0 );
CreatePlayerSSVariable( "LastHWAmmo", 0 );
CreatePlayerSSVariable( "JoinDate", "" );

-- ========================================= --
-- END PLAYER VARIABLES                      --
-- ========================================= --