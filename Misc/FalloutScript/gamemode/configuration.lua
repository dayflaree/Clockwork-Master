-------------------------------
-- LemonadeScript
-- Author: LuaBanana and Looter
-- Project Start: 5/24/2008
--
-- configuration.lua
-- Set up the script here.
-------------------------------

-- You can change these in the schema definition file as well.

LEMON.ConVars = {  };

LEMON.ConVars[ "DefaultHealth" ] = 100; -- How much health do they start with
LEMON.ConVars[ "WalkSpeed" ] = 90; -- How fast do they walk
LEMON.ConVars[ "CrouchSpeed" ] = 140; -- How fast do they crouchwalk
LEMON.ConVars[ "RunSpeed" ] = 225; -- How fast do they run : 255 default value
LEMON.ConVars[ "TalkRange" ] = 300; -- This is the range of talking.
LEMON.ConVars[ "ragremovaltime" ] = "45"
LEMON.ConVars[ "SuicideEnabled" ] = "1"; -- Can players compulsively suicide by using kill
LEMON.ConVars[ "SalaryEnabled" ] = "0"; -- Is salary enabled
LEMON.ConVars[ "SalaryInterval" ] = "5"; -- How often is salary given ( Minutes ) -- This cannot be changed after it has been set
LEMON.ConVars[ "Default_Gravgun" ] = "1"; -- Are players banned from the gravity gun when they first start.
LEMON.ConVars[ "Default_Physgun" ] = "0"; -- Are players banned from the physics gun when they first start.
LEMON.ConVars[ "Default_Money" ] = "100"; -- How much money do the characters start out with.
LEMON.ConVars[ "Default_Title" ] = "Resident"; -- What is their title when they create their character.
LEMON.ConVars[ "Default_Flags" ] = { "resident" }; -- What flags can the character select when it is first made. ( This does not include public flags ) This cannot be setconvar'd
LEMON.ConVars[ "Default_Inventory" ] = {  }; -- What inventory do characters start out with when they are first made. This cannot be setconvar'd
LEMON.ConVars[ "Schema" ] = "falloutrp"; -- What folder is schema data being loaded from?
LEMON.ConVars[ "Default_Warnings" ] = "0"