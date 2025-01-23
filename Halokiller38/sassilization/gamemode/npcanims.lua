if( SERVER ) then

	NPC_ANIMS_ENABLED = true
	NPC_ANIMS_ALWAYSAIM = true

	Models = {
		"models/Humans/Group01/Male_01.mdl",
		"models/Humans/Group01/male_02.mdl",
		"models/Humans/Group01/male_03.mdl",
		"models/Humans/Group01/Male_04.mdl",
		"models/Humans/Group01/Male_05.mdl",
		"models/Humans/Group01/male_06.mdl",
		"models/Humans/Group01/male_07.mdl",
		"models/Humans/Group01/male_08.mdl",
		"models/Humans/Group01/male_09.mdl",
		"models/Humans/Group02/Male_01.mdl",
		"models/Humans/Group02/male_02.mdl",
		"models/Humans/Group02/male_03.mdl",
		"models/Humans/Group02/Male_04.mdl",
		"models/Humans/Group02/Male_05.mdl",
		"models/Humans/Group02/male_06.mdl",
		"models/Humans/Group02/male_07.mdl",
		"models/Humans/Group02/male_08.mdl",
		"models/Humans/Group02/male_09.mdl",
		"models/Humans/Group03/Male_01.mdl",
		"models/Humans/Group03/male_02.mdl",
		"models/Humans/Group03/male_03.mdl",
		"models/Humans/Group03/Male_04.mdl",
		"models/Humans/Group03/Male_05.mdl",
		"models/Humans/Group03/male_06.mdl",
		"models/Humans/Group03/male_07.mdl",
		"models/Humans/Group03/male_08.mdl",
		"models/Humans/Group03/male_09.mdl",
		"models/Humans/Group03m/Male_01.mdl",
		"models/Humans/Group03m/male_02.mdl",
		"models/Humans/Group03m/male_03.mdl",
		"models/Humans/Group03m/Male_04.mdl",
		"models/Humans/Group03m/Male_05.mdl",
		"models/Humans/Group03m/male_06.mdl",
		"models/Humans/Group03m/male_07.mdl",
		"models/Humans/Group03m/male_08.mdl",
		"models/Humans/Group03m/male_09.mdl",

		"models/Humans/Group01/Female_01.mdl",
		"models/Humans/Group01/Female_02.mdl",
		"models/Humans/Group01/Female_03.mdl",
		"models/Humans/Group01/Female_04.mdl",
		"models/Humans/Group01/Female_06.mdl",
		"models/Humans/Group01/Female_07.mdl",
		"models/Humans/Group02/Female_01.mdl",
		"models/Humans/Group02/Female_02.mdl",
		"models/Humans/Group02/Female_03.mdl",
		"models/Humans/Group02/Female_04.mdl",
		"models/Humans/Group02/Female_06.mdl",
		"models/Humans/Group02/Female_07.mdl",
		"models/Humans/Group03/Female_01.mdl",
		"models/Humans/Group03/Female_02.mdl",
		"models/Humans/Group03/Female_03.mdl",
		"models/Humans/Group03/Female_04.mdl",
		"models/Humans/Group03/Female_06.mdl",
		"models/Humans/Group03/Female_07.mdl",
		"models/Humans/Group03m/Female_01.mdl",
		"models/Humans/Group03m/Female_02.mdl",
		"models/Humans/Group03m/Female_03.mdl",
		"models/Humans/Group03m/Female_04.mdl",
		"models/Humans/Group03m/Female_06.mdl",
		"models/Humans/Group03m/Female_07.mdl"

	}
	function MakeAim( ply )

		ply:DrawViewModel( true );
		ply:GetActiveWeapon():SetNWBool( "NPCAimed", true );
		--ply:GetActiveWeapon():SetNextPrimaryFire( CurTime() );
		
		ply:SetNWInt( "holstered", 0 );

	end

	function MakeUnAim( ply )

		ply:DrawViewModel( false );
		
		if( ply:GetActiveWeapon():IsValid() ) then
			ply:GetActiveWeapon():SetNWBool( "NPCAimed", false );
			--ply:GetActiveWeapon():SetNextPrimaryFire( CurTime() + 999999 );
			
			if( ply:GetActiveWeapon():GetNWBool( "ironsights" ) ) then
				if( ply:GetActiveWeapon().ToggleIronsight ) then
					ply:GetActiveWeapon():ToggleIronsight();
				end
			end
		end
		
		ply:SetNWInt( "holstered", 1 );

	end

	function NPCPlayerSpawn( pl )

		MakeAim( pl );

	end
	hook.Add( "PlayerSpawn", "NPCPlayerSpawn", NPCPlayerSpawn );


	NPCAnim = { }

	NPCAnim.CitizenMaleAnim = { }
	NPCAnim.CitizenMaleModels = 
	{

		"models/Humans/Group01/Male_01.mdl",
		"models/Humans/Group01/male_02.mdl",
		"models/Humans/Group01/male_03.mdl",
		"models/Humans/Group01/Male_04.mdl",
		"models/Humans/Group01/Male_05.mdl",
		"models/Humans/Group01/male_06.mdl",
		"models/Humans/Group01/male_07.mdl",
		"models/Humans/Group01/male_08.mdl",
		"models/Humans/Group01/male_09.mdl",
		"models/Humans/Group02/Male_01.mdl",
		"models/Humans/Group02/male_02.mdl",
		"models/Humans/Group02/male_03.mdl",
		"models/Humans/Group02/Male_04.mdl",
		"models/Humans/Group02/Male_05.mdl",
		"models/Humans/Group02/male_06.mdl",
		"models/Humans/Group02/male_07.mdl",
		"models/Humans/Group02/male_08.mdl",
		"models/Humans/Group02/male_09.mdl",
		"models/Humans/Group03/Male_01.mdl",
		"models/Humans/Group03/male_02.mdl",
		"models/Humans/Group03/male_03.mdl",
		"models/Humans/Group03/Male_04.mdl",
		"models/Humans/Group03/Male_05.mdl",
		"models/Humans/Group03/male_06.mdl",
		"models/Humans/Group03/male_07.mdl",
		"models/Humans/Group03/male_08.mdl",
		"models/Humans/Group03/male_09.mdl",
		"models/Humans/Group03m/Male_01.mdl",
		"models/Humans/Group03m/male_02.mdl",
		"models/Humans/Group03m/male_03.mdl",
		"models/Humans/Group03m/Male_04.mdl",
		"models/Humans/Group03m/Male_05.mdl",
		"models/Humans/Group03m/male_06.mdl",
		"models/Humans/Group03m/male_07.mdl",
		"models/Humans/Group03m/male_08.mdl",
		"models/Humans/Group03m/male_09.mdl"
	 
	}

	for k, v in pairs( NPCAnim.CitizenMaleModels ) do

		NPCAnim.CitizenMaleModels[k] = string.lower( v );

	end


	NPCAnim.CitizenMaleAnim["idle"] = 1
	NPCAnim.CitizenMaleAnim["walk"] = 6
	NPCAnim.CitizenMaleAnim["run"] = 10
	NPCAnim.CitizenMaleAnim["glide"] = 27
	NPCAnim.CitizenMaleAnim["sit"] = 0
	NPCAnim.CitizenMaleAnim["crouch"] = 5
	NPCAnim.CitizenMaleAnim["crouchwalk"] = 8
	 
	NPCAnim.CitizenMaleAnim["pistolidle"] = 1
	NPCAnim.CitizenMaleAnim["pistolwalk"] = 6
	NPCAnim.CitizenMaleAnim["pistolrun"] = 10
	NPCAnim.CitizenMaleAnim["pistolcrouch"] = 5
	NPCAnim.CitizenMaleAnim["pistolcrouchwalk"] = 8
	NPCAnim.CitizenMaleAnim["pistolaimidle"] = 266
	NPCAnim.CitizenMaleAnim["pistolaimwalk"] = 336
	NPCAnim.CitizenMaleAnim["pistolaimrun"] = 340
	NPCAnim.CitizenMaleAnim["pistolaimcrouch"] = 275
	NPCAnim.CitizenMaleAnim["pistolaimcrouchwalk"] = 338
	NPCAnim.CitizenMaleAnim["pistolreload"] = 359
	NPCAnim.CitizenMaleAnim["pistolfire"] = 285
	 
	NPCAnim.CitizenMaleAnim["smgidle"] = 307
	NPCAnim.CitizenMaleAnim["smgrun"] = 310
	NPCAnim.CitizenMaleAnim["smgwalk"] = 309
	NPCAnim.CitizenMaleAnim["smgaimidle"] = 298
	NPCAnim.CitizenMaleAnim["smgaimwalk"] = 336
	NPCAnim.CitizenMaleAnim["smgcrouchwalk"] = 8
	NPCAnim.CitizenMaleAnim["smgcrouch"] = 5
	NPCAnim.CitizenMaleAnim["smgaimcrouch"] = 275
	NPCAnim.CitizenMaleAnim["smgaimcrouchwalk"] = 338
	NPCAnim.CitizenMaleAnim["smgaimrun"] = 342
	NPCAnim.CitizenMaleAnim["smgreload"] = 359
	NPCAnim.CitizenMaleAnim["smgfire"] = 289
	 
	NPCAnim.CitizenMaleAnim["ar2idle"] = 307
	NPCAnim.CitizenMaleAnim["ar2walk"] = 309
	NPCAnim.CitizenMaleAnim["ar2run"] = 310
	NPCAnim.CitizenMaleAnim["ar2aimidle"] = 256
	NPCAnim.CitizenMaleAnim["ar2aimwalk"] = 336
	NPCAnim.CitizenMaleAnim["ar2aimrun"] = 340
	NPCAnim.CitizenMaleAnim["ar2crouchwalk"] = 8
	NPCAnim.CitizenMaleAnim["ar2crouch"] = 5
	NPCAnim.CitizenMaleAnim["ar2aimcrouch"] = 275
	NPCAnim.CitizenMaleAnim["ar2aimcrouchwalk"] = 338
	NPCAnim.CitizenMaleAnim["ar2reload"] = 359
	NPCAnim.CitizenMaleAnim["ar2fire"] = 281
	 
	NPCAnim.CitizenMaleAnim["shotgunidle"] = 316
	NPCAnim.CitizenMaleAnim["shotgunwalk"] = 309
	NPCAnim.CitizenMaleAnim["shotgunrun"] = 310
	NPCAnim.CitizenMaleAnim["shotgunaimidle"] = 256
	NPCAnim.CitizenMaleAnim["shotgunaimwalk"] = 336
	NPCAnim.CitizenMaleAnim["shotgunaimrun"] = 340
	NPCAnim.CitizenMaleAnim["shotguncrouchwalk"] = 8
	NPCAnim.CitizenMaleAnim["shotguncrouch"] = 5
	NPCAnim.CitizenMaleAnim["shotgunaimcrouch"] = 275
	NPCAnim.CitizenMaleAnim["shotgunaimcrouchwalk"] = 338
	NPCAnim.CitizenMaleAnim["shotgunreload"] = 359
	NPCAnim.CitizenMaleAnim["shotgunfire"] = 288
	 
	NPCAnim.CitizenMaleAnim["crossbowidle"] = 316
	NPCAnim.CitizenMaleAnim["crossbowwalk"] = 309
	NPCAnim.CitizenMaleAnim["crossbowrun"] = 310
	NPCAnim.CitizenMaleAnim["crossbowaimidle"] = 256
	NPCAnim.CitizenMaleAnim["crossbowaimwalk"] = 336
	NPCAnim.CitizenMaleAnim["crossbowaimrun"] = 340
	NPCAnim.CitizenMaleAnim["crossbowcrouchwalk"] = 8
	NPCAnim.CitizenMaleAnim["crossbowcrouch"] = 5
	NPCAnim.CitizenMaleAnim["crossbowaimcrouch"] = 275
	NPCAnim.CitizenMaleAnim["crossbowaimcrouchwalk"] = 338
	NPCAnim.CitizenMaleAnim["crossbowreload"] = 359
	NPCAnim.CitizenMaleAnim["crossbowfire"] = 288
	 
	NPCAnim.CitizenMaleAnim["meleeidle"] = 1
	NPCAnim.CitizenMaleAnim["meleewalk"] = 6
	NPCAnim.CitizenMaleAnim["meleerun"] = 10
	NPCAnim.CitizenMaleAnim["meleeaimidle"] = 324
	NPCAnim.CitizenMaleAnim["meleeaimcrouchwalk"] = 8
	NPCAnim.CitizenMaleAnim["meleeaimcrouch"] = 5
	NPCAnim.CitizenMaleAnim["meleecrouchwalk"] = 8
	NPCAnim.CitizenMaleAnim["meleecrouch"] = 5
	NPCAnim.CitizenMaleAnim["meleeaimwalk"] = 6
	NPCAnim.CitizenMaleAnim["meleeaimrun"] = 10
	NPCAnim.CitizenMaleAnim["meleefire"] = 273
	 
	NPCAnim.CitizenMaleAnim["rpgidle"] = 316
	NPCAnim.CitizenMaleAnim["rpgwalk"] = 309
	NPCAnim.CitizenMaleAnim["rpgrun"] = 310
	NPCAnim.CitizenMaleAnim["rpgaimidle"] = 327
	NPCAnim.CitizenMaleAnim["rpgaimwalk"] = 336
	NPCAnim.CitizenMaleAnim["rpgaimrun"] = 340
	NPCAnim.CitizenMaleAnim["rpgcrouchwalk"] = 8
	NPCAnim.CitizenMaleAnim["rpgcrouch"] = 5
	NPCAnim.CitizenMaleAnim["rpgaimcrouch"] = 275
	NPCAnim.CitizenMaleAnim["rpgaimcrouchwalk"] = 338
	NPCAnim.CitizenMaleAnim["rpgfire"] = 272
	 
	NPCAnim.CitizenMaleAnim["grenadeidle"] = 1
	NPCAnim.CitizenMaleAnim["grenadewalk"] = 6
	NPCAnim.CitizenMaleAnim["grenaderun"] = 10
	NPCAnim.CitizenMaleAnim["grenadeaimidle"] = 1
	NPCAnim.CitizenMaleAnim["grenadeaimcrouchwalk"] = 8
	NPCAnim.CitizenMaleAnim["grenadeaimcrouch"] = 5
	NPCAnim.CitizenMaleAnim["grenadecrouchwalk"] = 8
	NPCAnim.CitizenMaleAnim["grenadecrouch"] = 5
	NPCAnim.CitizenMaleAnim["grenadeaimwalk"] = 6
	NPCAnim.CitizenMaleAnim["grenadeaimrun"] = 10
	NPCAnim.CitizenMaleAnim["grenadefire"] = 273
	 
	NPCAnim.CitizenMaleAnim["slamidle"] = 1
	NPCAnim.CitizenMaleAnim["slamwalk"] = 6
	NPCAnim.CitizenMaleAnim["slamrun"] = 10
	NPCAnim.CitizenMaleAnim["slamaimidle"] = 1
	NPCAnim.CitizenMaleAnim["slamaimcrouchwalk"] = 8
	NPCAnim.CitizenMaleAnim["slamaimcrouch"] = 5
	NPCAnim.CitizenMaleAnim["slamcrouchwalk"] = 8
	NPCAnim.CitizenMaleAnim["slamcrouch"] = 5
	NPCAnim.CitizenMaleAnim["slamaimwalk"] = 6
	NPCAnim.CitizenMaleAnim["slamaimrun"] = 10
	NPCAnim.CitizenMaleAnim["slamfire"] = 273
	 
	NPCAnim.CitizenMaleAnim["physgunidle"] = 256
	NPCAnim.CitizenMaleAnim["physgunwalk"] = 336
	NPCAnim.CitizenMaleAnim["physgunrun"] = 340
	NPCAnim.CitizenMaleAnim["physgunaimidle"] = 256
	NPCAnim.CitizenMaleAnim["physgunaimwalk"] = 336
	NPCAnim.CitizenMaleAnim["physgunaimrun"] = 340
	NPCAnim.CitizenMaleAnim["physgunaimcrouchwalk"] = 338
	NPCAnim.CitizenMaleAnim["physgunaimcrouch"] = 275

	NPCAnim.CitizenFemaleAnim = { }
	NPCAnim.CitizenFemaleModels = 
	{
		
		"models/Humans/Group01/Female_01.mdl",
		"models/Humans/Group01/Female_02.mdl",
		"models/Humans/Group01/Female_03.mdl",
		"models/Humans/Group01/Female_04.mdl",
		"models/Humans/Group01/Female_06.mdl",
		"models/Humans/Group01/Female_07.mdl",
		"models/Humans/Group02/Female_01.mdl",
		"models/Humans/Group02/Female_02.mdl",
		"models/Humans/Group02/Female_03.mdl",
		"models/Humans/Group02/Female_04.mdl",
		"models/Humans/Group02/Female_06.mdl",
		"models/Humans/Group02/Female_07.mdl",
		"models/Humans/Group03/Female_01.mdl",
		"models/Humans/Group03/Female_02.mdl",
		"models/Humans/Group03/Female_03.mdl",
		"models/Humans/Group03/Female_04.mdl",
		"models/Humans/Group03/Female_06.mdl",
		"models/Humans/Group03/Female_07.mdl",
		"models/Humans/Group03m/Female_01.mdl",
		"models/Humans/Group03m/Female_02.mdl",
		"models/Humans/Group03m/Female_03.mdl",
		"models/Humans/Group03m/Female_04.mdl",
		"models/Humans/Group03m/Female_06.mdl",
		"models/Humans/Group03m/Female_07.mdl"
	}

	for k, v in pairs( NPCAnim.CitizenFemaleModels ) do

		NPCAnim.CitizenFemaleModels[k] = string.lower( v );

	end

	NPCAnim.CitizenFemaleAnim["idle"] = 1
	NPCAnim.CitizenFemaleAnim["walk"] = 6
	NPCAnim.CitizenFemaleAnim["run"] = 10
	NPCAnim.CitizenFemaleAnim["glide"] = 27
	NPCAnim.CitizenFemaleAnim["sit"] = 0
	NPCAnim.CitizenFemaleAnim["crouch"] = 5
	NPCAnim.CitizenFemaleAnim["crouchwalk"] = 8

	NPCAnim.CitizenFemaleAnim["pistolidle"] = 1
	NPCAnim.CitizenFemaleAnim["pistolwalk"] = 6
	NPCAnim.CitizenFemaleAnim["pistolrun"] = 10
	NPCAnim.CitizenFemaleAnim["pistolcrouchwalk"] = 8
	NPCAnim.CitizenFemaleAnim["pistolcrouch"] = 5
	NPCAnim.CitizenFemaleAnim["pistolaimidle"] = 266
	NPCAnim.CitizenFemaleAnim["pistolaimwalk"] = 346
	NPCAnim.CitizenFemaleAnim["pistolaimrun"] = 347
	NPCAnim.CitizenFemaleAnim["pistolaimcrouch"] = 275
	NPCAnim.CitizenFemaleAnim["pistolaimcrouchwalk"] = 338
	NPCAnim.CitizenFemaleAnim["pistolreload"] = 359
	NPCAnim.CitizenFemaleAnim["pistolfire"] = 285

	NPCAnim.CitizenFemaleAnim["smgidle"] = 307
	NPCAnim.CitizenFemaleAnim["smgrun"] = 310
	NPCAnim.CitizenFemaleAnim["smgwalk"] = 309
	NPCAnim.CitizenFemaleAnim["smgaimidle"] = 298
	NPCAnim.CitizenFemaleAnim["smgaimwalk"] = 336
	NPCAnim.CitizenFemaleAnim["smgcrouchwalk"] = 8
	NPCAnim.CitizenFemaleAnim["smgcrouch"] = 5
	NPCAnim.CitizenFemaleAnim["smgaimcrouch"] = 275
	NPCAnim.CitizenFemaleAnim["smgaimcrouchwalk"] = 338
	NPCAnim.CitizenFemaleAnim["smgaimrun"] = 342
	NPCAnim.CitizenFemaleAnim["smgreload"] = 359
	NPCAnim.CitizenFemaleAnim["smgfire"] = 289

	NPCAnim.CitizenFemaleAnim["ar2idle"] = 307
	NPCAnim.CitizenFemaleAnim["ar2walk"] = 309
	NPCAnim.CitizenFemaleAnim["ar2run"] = 310
	NPCAnim.CitizenFemaleAnim["ar2aimidle"] = 256
	NPCAnim.CitizenFemaleAnim["ar2aimwalk"] = 336
	NPCAnim.CitizenFemaleAnim["ar2aimrun"] = 340
	NPCAnim.CitizenFemaleAnim["ar2crouchwalk"] = 8
	NPCAnim.CitizenFemaleAnim["ar2crouch"] = 5
	NPCAnim.CitizenFemaleAnim["ar2aimcrouch"] = 275
	NPCAnim.CitizenFemaleAnim["ar2aimcrouchwalk"] = 338
	NPCAnim.CitizenFemaleAnim["ar2reload"] = 359
	NPCAnim.CitizenFemaleAnim["ar2fire"] = 281

	NPCAnim.CitizenFemaleAnim["shotgunidle"] = 316
	NPCAnim.CitizenFemaleAnim["shotgunwalk"] = 309
	NPCAnim.CitizenFemaleAnim["shotgunrun"] = 310
	NPCAnim.CitizenFemaleAnim["shotgunaimidle"] = 256
	NPCAnim.CitizenFemaleAnim["shotgunaimwalk"] = 336
	NPCAnim.CitizenFemaleAnim["shotgunaimrun"] = 340
	NPCAnim.CitizenFemaleAnim["shotguncrouchwalk"] = 8
	NPCAnim.CitizenFemaleAnim["shotguncrouch"] = 5
	NPCAnim.CitizenFemaleAnim["shotgunaimcrouch"] = 275
	NPCAnim.CitizenFemaleAnim["shotgunaimcrouchwalk"] = 338
	NPCAnim.CitizenFemaleAnim["shotgunreload"] = 359
	NPCAnim.CitizenFemaleAnim["shotgunfire"] = 288

	NPCAnim.CitizenFemaleAnim["crossbowidle"] = 316
	NPCAnim.CitizenFemaleAnim["crossbowwalk"] = 309
	NPCAnim.CitizenFemaleAnim["crossbowrun"] = 310
	NPCAnim.CitizenFemaleAnim["crossbowaimidle"] = 256
	NPCAnim.CitizenFemaleAnim["crossbowaimwalk"] = 336
	NPCAnim.CitizenFemaleAnim["crossbowaimrun"] = 340
	NPCAnim.CitizenFemaleAnim["crossbowcrouchwalk"] = 8
	NPCAnim.CitizenFemaleAnim["crossbowcrouch"] = 5
	NPCAnim.CitizenFemaleAnim["crossbowaimcrouch"] = 275
	NPCAnim.CitizenFemaleAnim["crossbowaimcrouchwalk"] = 338
	NPCAnim.CitizenFemaleAnim["crossbowreload"] = 359
	NPCAnim.CitizenFemaleAnim["crossbowfire"] = 288

	NPCAnim.CitizenFemaleAnim["meleeidle"] = 1
	NPCAnim.CitizenFemaleAnim["meleewalk"] = 6
	NPCAnim.CitizenFemaleAnim["meleerun"] = 10
	NPCAnim.CitizenFemaleAnim["meleeaimidle"] = 273
	NPCAnim.CitizenFemaleAnim["meleeaimcrouchwalk"] = 8
	NPCAnim.CitizenFemaleAnim["meleeaimcrouch"] = 5
	NPCAnim.CitizenFemaleAnim["meleecrouchwalk"] = 8
	NPCAnim.CitizenFemaleAnim["meleecrouch"] = 5
	NPCAnim.CitizenFemaleAnim["meleeaimwalk"] = 6
	NPCAnim.CitizenFemaleAnim["meleeaimrun"] = 10
	NPCAnim.CitizenFemaleAnim["meleefire"] = 273

	NPCAnim.CitizenFemaleAnim["rpgidle"] = 316
	NPCAnim.CitizenFemaleAnim["rpgwalk"] = 309
	NPCAnim.CitizenFemaleAnim["rpgrun"] = 310
	NPCAnim.CitizenFemaleAnim["rpgaimidle"] = 327
	NPCAnim.CitizenFemaleAnim["rpgaimwalk"] = 336
	NPCAnim.CitizenFemaleAnim["rpgaimrun"] = 340
	NPCAnim.CitizenFemaleAnim["rpgcrouchwalk"] = 8
	NPCAnim.CitizenFemaleAnim["rpgcrouch"] = 5
	NPCAnim.CitizenFemaleAnim["rpgaimcrouch"] = 275
	NPCAnim.CitizenFemaleAnim["rpgaimcrouchwalk"] = 338
	NPCAnim.CitizenFemaleAnim["rpgfire"] = 272

	NPCAnim.CitizenFemaleAnim["grenadeidle"] = 1
	NPCAnim.CitizenFemaleAnim["grenadewalk"] = 6
	NPCAnim.CitizenFemaleAnim["grenaderun"] = 10
	NPCAnim.CitizenFemaleAnim["grenadeaimidle"] = 1
	NPCAnim.CitizenFemaleAnim["grenadeaimcrouchwalk"] = 8
	NPCAnim.CitizenFemaleAnim["grenadeaimcrouch"] = 5
	NPCAnim.CitizenFemaleAnim["grenadecrouchwalk"] = 8
	NPCAnim.CitizenFemaleAnim["grenadecrouch"] = 5
	NPCAnim.CitizenFemaleAnim["grenadeaimwalk"] = 6
	NPCAnim.CitizenFemaleAnim["grenadeaimrun"] = 10
	NPCAnim.CitizenFemaleAnim["grenadefire"] = 273

	NPCAnim.CitizenFemaleAnim["slamidle"] = 1
	NPCAnim.CitizenFemaleAnim["slamwalk"] = 6
	NPCAnim.CitizenFemaleAnim["slamrun"] = 10
	NPCAnim.CitizenFemaleAnim["slamaimidle"] = 1
	NPCAnim.CitizenFemaleAnim["slamaimcrouchwalk"] = 8
	NPCAnim.CitizenFemaleAnim["slamaimcrouch"] = 5
	NPCAnim.CitizenFemaleAnim["slamcrouchwalk"] = 8
	NPCAnim.CitizenFemaleAnim["slamcrouch"] = 5
	NPCAnim.CitizenFemaleAnim["slamaimwalk"] = 6
	NPCAnim.CitizenFemaleAnim["slamaimrun"] = 10
	NPCAnim.CitizenFemaleAnim["slamfire"] = 273

	NPCAnim.CitizenFemaleAnim["physgunidle"] = 256
	NPCAnim.CitizenFemaleAnim["physgunwalk"] = 336
	NPCAnim.CitizenFemaleAnim["physgunrun"] = 340
	NPCAnim.CitizenFemaleAnim["physgunaimidle"] = 256
	NPCAnim.CitizenFemaleAnim["physgunaimwalk"] = 336
	NPCAnim.CitizenFemaleAnim["physgunaimrun"] = 340
	NPCAnim.CitizenFemaleAnim["physgunaimcrouchwalk"] = 338
	NPCAnim.CitizenFemaleAnim["physgunaimcrouch"] = 275

	WeapActivityTranslate = { }

	WeapActivityTranslate[ACT_HL2MP_IDLE_PISTOL] = "pistol";
	WeapActivityTranslate[ACT_HL2MP_IDLE_SMG1] = "smg";
	WeapActivityTranslate[ACT_HL2MP_IDLE_AR2] = "ar2";
	WeapActivityTranslate[ACT_HL2MP_IDLE_RPG] = "rpg";
	WeapActivityTranslate[ACT_HL2MP_IDLE_GRENADE] = "grenade";
	WeapActivityTranslate[ACT_HL2MP_IDLE_SHOTGUN] = "shotgun";
	WeapActivityTranslate[ACT_HL2MP_IDLE_PHYSGUN] = "physgun";
	WeapActivityTranslate[ACT_HL2MP_IDLE_CROSSBOW] = "crossbow";
	WeapActivityTranslate[ACT_HL2MP_IDLE_SLAM] = "slam";
	WeapActivityTranslate[ACT_HL2MP_IDLE_MELEE] = "melee";
	WeapActivityTranslate[ACT_HL2MP_IDLE] = "";
	WeapActivityTranslate["weapon_pistol"] = "pistol";
	WeapActivityTranslate["weapon_357"] = "pistol";
	WeapActivityTranslate["gmod_tool"] = "pistol";
	WeapActivityTranslate["weapon_smg1"] = "smg";
	WeapActivityTranslate["weapon_ar2"] = "ar2";
	WeapActivityTranslate["weapon_rpg"] = "rpg";
	WeapActivityTranslate["weapon_frag"] = "grenade";
	WeapActivityTranslate["weapon_slam"] = "slam";
	WeapActivityTranslate["weapon_physgun"] = "physgun";
	WeapActivityTranslate["weapon_physcannon"] = "physgun";
	WeapActivityTranslate["weapon_crossbow"] = "crossbow";
	WeapActivityTranslate["weapon_shotgun"] = "shotgun";
	WeapActivityTranslate["weapon_crowbar"] = "melee";
	WeapActivityTranslate["weapon_stunstick"] = "melee";

	local function GetWeaponAct( ply, act )

		return "";/*

		local weap = ply:GetActiveWeapon();
		
		if( weap == NULL or not weap:IsValid() ) then
			return "";
		end

		local class = weap:GetClass();
		
		local trans = "";
		local posttrans = "";
		
		--if( weap:GetNWBool( "NPCAimed" ) ) then
			posttrans = "aim";	
		--end

		if( act ~= -1 ) then
			trans = WeapActivityTranslate[act];
		else
			trans = WeapActivityTranslate[class];
		end
		
		return trans .. posttrans or "";*/

	end



	local function GetAnimTable( ply )

		local model = string.lower( ply:GetModel() );

		if( table.HasValue( NPCAnim.CitizenMaleModels, model ) ) then return NPCAnim.CitizenMaleAnim; end
		if( table.HasValue( NPCAnim.CitizenFemaleModels, model ) ) then return NPCAnim.CitizenFemaleAnim; end
		
		return NPCAnim.CitizenMaleAnim;

	end

	function GM:SetPlayerAnimation( ply, weapanim )

		if( not NPC_ANIMS_ENABLED ) then return; end
		
		local animname = "";
		
		local seqname = animname;
		
		if( ply:GetVelocity():Length() >= 1 ) then

			seqname = seqname .. "run";

		else
			
			seqname = seqname .. "idle";
			
		end

		local AnimTable = GetAnimTable( ply );

		if ( ( not ply:OnGround() or ply:WaterLevel() > 4 ) and not ply:InVehicle() ) then
			seqname = "glide";
		end
	 

		local actid = AnimTable[seqname];
		local seq = nil;

		if( actid == nil or actid == -1 ) then
			seq = ply:GetSequence();
		else
			seq = ply:SelectWeightedSequence( actid );
		end

		if ( ply:GetSequence() == seq ) then return true; end

		ply:SetPlaybackRate( 1 );
		ply:ResetSequence( seq );
		ply:SetCycle( 1 );
		
		return true;

	end

	function NPCSetupMove ( ply, move )

		if( not NPC_ANIMS_ENABLED ) then return; end

		if( not ply:IsValid() or not ply:Alive() ) then
			return;

		end

		move:SetMaxClientSpeed( 260 );
		return true;

	end
	hook.Add( "SetupMove", "NPCSetupMove", NPCSetupMove );

end
