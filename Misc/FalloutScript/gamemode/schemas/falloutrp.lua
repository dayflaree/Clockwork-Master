SCHEMA.Name = "FalloutRP";
SCHEMA.Author = "FalloutRP.com";
SCHEMA.Description = " ";
SCHEMA.Base = "global";

function SCHEMA.SetUp( )
	
	local team = LEMON.FalloutTeam();

	-- name, color, model_path, default_model, partial_model, weapons, flag_key, door_groups, sound_groups, item_groups, salary, public, business
	
	-- Item Groups
	-- Bartender/trader: 5
	
	LEMON.AddTeam( LEMON.FalloutTeam( ) ); -- Resident team

	-- Classes
	--Better to give each team the weapon directly instead of trying to give it to them thru the FS items
	LEMON.AddTeam( LEMON.FalloutTeam( "Farmer", 0, Color(0, 255, 0, 255), "", false, false, {}, "f", {}, {1}, {}, 75, true, false) )
	LEMON.AddTeam( LEMON.FalloutTeam( "Tribal", 0, Color(0, 255, 0, 255), "", false, false, {}, "tb", {}, {1}, {}, 75, true, false) )
	LEMON.AddTeam( LEMON.FalloutTeam( "Traveller", 0, Color(0, 255, 0, 255), "", false, false, {}, "tv", {}, {1}, {}, 75, true, false) )
	LEMON.AddTeam( LEMON.FalloutTeam( "Vault Dweller", 0, Color(0, 255, 0, 255), "", false, false, {}, "vd", {}, {1}, {}, 75, true, false) )
	LEMON.AddTeam( LEMON.FalloutTeam( "Trader", 0, Color(0, 255, 0, 255), "", false, false, {}, "tr", {}, {1}, {5}, 50, false, true) )
	LEMON.AddTeam( LEMON.FalloutTeam( "Bartender", 0, Color(0, 255, 0, 255), "", false, false, {}, "bt", {}, {1}, {5}, 50, false, true) )
	LEMON.AddTeam( LEMON.FalloutTeam( "Raider", 0, Color(0, 255, 0, 255), "", false, false, {}, "rd", {}, {1}, {}, 50, false, false) )
	LEMON.AddTeam( LEMON.FalloutTeam( "Test", 0, Color(0, 255, 0, 255), "", false, false, {}, "pub", {}, {1}, {}, 50, true, false) )
	-- LEMON.AddTeam( LEMON.FalloutTeam( "Enclave Officer" , 0, Color(0, 255, 0, 255), "", false, false, {}, "eco", {}, {1}, {}, 75, true, false) )
	--LEMON.AddTeam( LEMON.FalloutTeam( "Enclave", 0, Color(0, 255, 0, 255), "", false, false, {}, "ec", {}, {1}, {}, 75, true, false) ); Teh enclave

	
	-- Selectable models on character creation
	-- Bogus models were needed because the shitty derma doesn't wanna scroll unless it has a certain amount of models.
	-- This is now actually being used.
	-- female_05's don't exist - don't use them
	-- Unfortunatly I changed all the paths to player meaning player model not npc model make sure to change it back when you put the new NPC animation script back

	LEMON.AddModels({
              "models/player/group01/male_01.mdl",
              "models/player/group01/male_02.mdl",
              "models/player/group01/male_03.mdl",
			  "models/player/group01/male_04.mdl",
			  "models/player/group01/male_05.mdl",
              "models/player/group01/male_06.mdl",
              "models/player/group01/male_07.mdl",
              "models/player/group01/male_08.mdl",
              "models/player/group01/male_09.mdl",

              "models/chance/Citizen/male_01.mdl",
              "models/chance/Citizen/male_02.mdl",
              "models/chance/Citizen/male_03.mdl",
			  "models/chance/Citizen/male_04.mdl",
			  "models/chance/Citizen/male_05.mdl",
              "models/chance/Citizen/male_06.mdl",
              "models/chance/Citizen/male_07.mdl",
              "models/chance/Citizen/male_08.mdl",
              "models/chance/Citizen/male_09.mdl",
              -- "models/player/group02/male_01.mdl",
              -- "models/player/group02/male_02.mdl",
              -- "models/player/group02/male_03.mdl",
              -- "models/player/group02/male_04.mdl",
			  -- "models/player/group02/male_05.mdl",
              -- "models/player/group02/male_06.mdl",
              -- "models/player/group02/male_07.mdl",
              -- "models/player/group02/male_08.mdl",
              -- "models/player/group02/male_09.mdl",
              -- "models/player/group03/male_01.mdl",
              -- "models/player/group03/male_02.mdl",
              -- "models/player/group03/male_03.mdl",
              -- "models/player/group03/male_04.mdl",
			  -- "models/player/group03/male_05.mdl",
              -- "models/player/group03/male_06.mdl",
              -- "models/player/group03/male_07.mdl",
              -- "models/player/group03/male_08.mdl",
              -- "models/player/group03/male_09.mdl",
              -- "models/player/group03m/male_01.mdl",
              -- "models/player/group03m/male_02.mdl",
              -- "models/player/group03m/male_03.mdl",
              -- "models/player/group03m/male_04.mdl",
			  -- "models/player/group03m/male_05.mdl",
              -- "models/player/group03m/male_06.mdl",
              -- "models/player/group03m/male_07.mdl",
              -- "models/player/group03m/male_08.mdl",
              -- "models/player/group03m/male_09.mdl",
			  "models/player/group01/female_01.mdl",
              "models/player/group01/female_02.mdl",
              "models/player/group01/female_03.mdl",
              "models/player/group01/female_04.mdl",
              "models/player/group01/female_06.mdl",
              "models/player/group01/female_07.mdl",
			  --"models/player/slow/fallout_3/power_armor/slow.mdl"
              -- "models/player/group02/female_01.mdl",
              -- "models/player/group02/female_02.mdl",
              -- "models/player/group02/female_03.mdl",
              -- "models/player/group02/female_04.mdl",
              -- "models/player/group02/female_06.mdl",
              -- "models/player/group02/female_07.mdl",
              -- "models/player/group03/female_01.mdl",
              -- "models/player/group03/female_02.mdl",
              -- "models/player/group03/female_03.mdl",
              -- "models/player/group03/female_04.mdl",
              -- "models/player/group03/female_06.mdl",
              -- "models/player/group03/female_07.mdl",
              -- "models/player/group03m/female_01.mdl",
              -- "models/player/group03m/female_02.mdl",
              -- "models/player/group03m/female_03.mdl",
              -- "models/player/group03m/female_04.mdl",
              -- "models/player/group03m/female_06.mdl",
              -- "models/player/group03m/female_07.mdl"
	});		

end
