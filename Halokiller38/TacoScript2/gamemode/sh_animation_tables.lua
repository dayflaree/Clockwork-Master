TS.AnimTables = { }

-----------------------------------------
-- MALE CITIZEN ANIM TABLE
-----------------------------------------
TS.AnimTables[1] = { }
TS.AnimTables[1].Models =
{

	"models/barnes/refugee/male_01.mdl",
	"models/barnes/refugee/male_02.mdl",
	"models/barnes/refugee/male_03.mdl",
	"models/barnes/refugee/male_04.mdl",
	"models/barnes/refugee/male_05.mdl",
	"models/barnes/refugee/male_06.mdl",
	"models/barnes/refugee/male_07.mdl",
	"models/barnes/refugee/male_08.mdl",
	"models/barnes/refugee/male_09.mdl",
	"models/barnes/refugee/male_12.mdl",
	"models/barnes/refugee/male_13.mdl",
	"models/barnes/refugee/male_24.mdl",
	"models/barnes/refugee/male_25.mdl",
	"models/barnes/refugee/male_28.mdl",
	"models/barnes/refugee/male_30.mdl",
	"models/barnes/refugee/male_31.mdl",
	"models/barnes/refugee/male_32.mdl",
	"models/barnes/refugee/male_35.mdl",
	"models/barnes/refugee/male_38.mdl",
	"models/barnes/refugee/male_52.mdl",
	"models/barnes/refugee/male_jb.mdl",
	"models/humans/group01/male_10.mdl",
	"models/humans/group01/male_11.mdl",
	"models/humans/group01/male_12.mdl",
	"models/humans/group01/male_13.mdl",
	"models/humans/group01/male_14.mdl",
	"models/humans/group01/male_15.mdl",
	"models/humans/group01/male_16.mdl",
	"models/humans/group01/male_17.mdl",
	"models/humans/group01/male_18.mdl",
	"models/humans/group01/male_19.mdl",
	"models/humans/group01/male_20.mdl",
	"models/humans/group01/male_21.mdl",
	"models/humans/group01/male_22.mdl",
	"models/humans/group01/male_23.mdl",
	"models/humans/group01/male_24.mdl",
	"models/humans/group01/male_25.mdl",
	"models/humans/group01/male_26.mdl",
	"models/humans/group01/male_27.mdl",
	"models/humans/group01/male_28.mdl",
	"models/humans/group01/male_29.mdl",
	"models/humans/group01/male_30.mdl",
	"models/humans/group01/male_31.mdl",
	"models/humans/group01/male_32.mdl",
	"models/humans/group01/male_33.mdl",
	"models/humans/group01/male_34.mdl",
	"models/humans/group01/male_35.mdl",
	"models/humans/group01/male_36.mdl",
	"models/humans/group01/male_37.mdl",
	"models/humans/group01/male_38.mdl",
	"models/humans/group01/male_39.mdl",
	"models/humans/group01/male_40.mdl",
	"models/humans/group01/male_41.mdl",
	"models/humans/group01/male_42.mdl",
	"models/humans/group01/male_43.mdl",
	"models/humans/group01/male_44.mdl",
	"models/humans/group01/male_45.mdl",
	"models/humans/group01/male_46.mdl",
	"models/humans/group01/male_47.mdl",
	"models/humans/group01/male_48.mdl",
	"models/player/Group01/Male_01.mdl",
	"models/player/Group01/Male_04.mdl",
	"models/player/Group01/Male_05.mdl",
	"models/player/Group01/male_02.mdl",
	"models/player/Group01/male_03.mdl",
	"models/player/Group01/male_06.mdl",
	"models/player/Group01/male_07.mdl",
	"models/player/Group01/male_08.mdl",
	"models/player/Group01/male_09.mdl",
	"models/player/Group03/Male_01.mdl",
	"models/player/Group03/Male_04.mdl",
	"models/player/Group03/Male_05.mdl",
	"models/player/Group03/male_02.mdl",
	"models/player/Group03/male_03.mdl",
	"models/player/Group03/male_06.mdl",
	"models/player/Group03/male_07.mdl",
	"models/player/Group03/male_08.mdl",
	"models/player/Group03/male_09.mdl",
	"models/purvis/male_01_metrocop.mdl",
	"models/purvis/male_02_metrocop.mdl",
	"models/purvis/male_03_metrocop.mdl",
	"models/purvis/male_04_metrocop.mdl",
	"models/purvis/male_05_metrocop.mdl",
	"models/purvis/male_06_metrocop.mdl",
	"models/purvis/male_07_metrocop.mdl",
	"models/purvis/male_08_metrocop.mdl",
	"models/purvis/male_09_metrocop.mdl",
	"models/purvis/male_10_metrocop.mdl",
	"models/purvis/male_12_metrocop.mdl",
	"models/purvis/male_16_metrocop.mdl",
	"models/purvis/male_18_metrocop.mdl",
	"models/purvis/male_20_metrocop.mdl",
	"models/purvis/male_24_metrocop.mdl",
	"models/purvis/male_25_metrocop.mdl",
	"models/purvis/male_rl_metrocop.mdl",

};

TS.AnimTables[1].Anim = { }

TS.AnimTables[1].Anim["STAND_idle"] = ACT_IDLE;
TS.AnimTables[1].Anim["STAND_walk"] = ACT_WALK;
TS.AnimTables[1].Anim["STAND_run"] = ACT_RUN;

TS.AnimTables[1].Anim["CROUCH_idle"] = ACT_COVER_LOW; -- IMP
TS.AnimTables[1].Anim["CROUCH_walk"] = ACT_WALK_CROUCH; -- IMP?

TS.AnimTables[1].Anim["STAND_FIST_idle"] = ACT_IDLE;
TS.AnimTables[1].Anim["STAND_FIST_walk"] = ACT_WALK;
TS.AnimTables[1].Anim["STAND_FIST_run"] = ACT_RUN;
TS.AnimTables[1].Anim["CROUCH_FIST_idle"] = ACT_COVER_LOW; -- IMP
TS.AnimTables[1].Anim["CROUCH_FIST_walk"] = ACT_WALK_CROUCH; -- IMP?

TS.AnimTables[1].Anim["STAND_FIST_AIM_idle"] = ACT_IDLE_AIM_RIFLE_STIMULATED;
TS.AnimTables[1].Anim["STAND_FIST_AIM_walk"] = ACT_WALK_AIM_RIFLE_STIMULATED;
TS.AnimTables[1].Anim["STAND_FIST_AIM_run"] = ACT_RUN_AIM_RIFLE_STIMULATED;
TS.AnimTables[1].Anim["CROUCH_FIST_AIM_idle"] = ACT_RANGE_ATTACK_SMG1_LOW;
TS.AnimTables[1].Anim["CROUCH_FIST_AIM_walk"] = ACT_WALK_CROUCH_RPG;

TS.AnimTables[1].Anim["STAND_BLUNT_idle"] = ACT_IDLE;
TS.AnimTables[1].Anim["STAND_BLUNT_walk"] = ACT_WALK;
TS.AnimTables[1].Anim["STAND_BLUNT_run"] = ACT_RUN;
TS.AnimTables[1].Anim["CROUCH_BLUNT_idle"] = ACT_COVER_LOW;
TS.AnimTables[1].Anim["CROUCH_BLUNT_walk"] = ACT_WALK_CROUCH;

TS.AnimTables[1].Anim["STAND_BLUNT_AIM_idle"] = ACT_IDLE_AIM_RIFLE_STIMULATED;
TS.AnimTables[1].Anim["STAND_BLUNT_AIM_walk"] = ACT_WALK_AIM_RIFLE_STIMULATED;
TS.AnimTables[1].Anim["STAND_BLUNT_AIM_run"] = ACT_RUN_AIM_RIFLE_STIMULATED;
TS.AnimTables[1].Anim["CROUCH_BLUNT_AIM_idle"] = ACT_RANGE_ATTACK_SMG1_LOW;
TS.AnimTables[1].Anim["CROUCH_BLUNT_AIM_walk"] = ACT_WALK_CROUCH_RPG;

TS.AnimTables[1].Anim["STAND_PISTOL_idle"] = ACT_IDLE;
TS.AnimTables[1].Anim["STAND_PISTOL_walk"] = ACT_WALK;
TS.AnimTables[1].Anim["STAND_PISTOL_run"] = ACT_RUN;
TS.AnimTables[1].Anim["CROUCH_PISTOL_idle"] = ACT_COVER_LOW;
TS.AnimTables[1].Anim["CROUCH_PISTOL_walk"] = ACT_WALK_CROUCH;

TS.AnimTables[1].Anim["STAND_PISTOL_AIM_idle"] = ACT_RANGE_ATTACK_PISTOL;
TS.AnimTables[1].Anim["STAND_PISTOL_AIM_walk"] = ACT_WALK_AIM_RIFLE_STIMULATED;
TS.AnimTables[1].Anim["STAND_PISTOL_AIM_run"] = ACT_RUN_AIM_RIFLE_STIMULATED;
TS.AnimTables[1].Anim["CROUCH_PISTOL_AIM_idle"] = ACT_RANGE_ATTACK_PISTOL_LOW;
TS.AnimTables[1].Anim["CROUCH_PISTOL_AIM_walk"] = ACT_WALK_CROUCH_AIM_RIFLE;
 
TS.AnimTables[1].Anim["STAND_SMG_idle"] = ACT_IDLE_SMG1_RELAXED;
TS.AnimTables[1].Anim["STAND_SMG_walk"] = ACT_WALK_RIFLE_RELAXED;
TS.AnimTables[1].Anim["STAND_SMG_run"] = ACT_RUN_RIFLE_RELAXED;
TS.AnimTables[1].Anim["CROUCH_SMG_idle"] = ACT_COVER_LOW_RPG;
TS.AnimTables[1].Anim["CROUCH_SMG_walk"] = ACT_WALK_CROUCH_RIFLE;

TS.AnimTables[1].Anim["STAND_SMG_AIM_idle"] = ACT_IDLE_ANGRY_SMG1;
TS.AnimTables[1].Anim["STAND_SMG_AIM_walk"] = ACT_WALK_AIM_RIFLE_STIMULATED;
TS.AnimTables[1].Anim["STAND_SMG_AIM_run"] = ACT_RUN_AIM_RIFLE_STIMULATED;
TS.AnimTables[1].Anim["CROUCH_SMG_AIM_idle"] = ACT_RANGE_ATTACK_SMG1_LOW;
TS.AnimTables[1].Anim["CROUCH_SMG_AIM_walk"] = ACT_WALK_CROUCH_AIM_RIFLE; -- IMP

TS.AnimTables[1].Anim["STAND_RIFLE_idle"] = ACT_IDLE_RIFLE;
TS.AnimTables[1].Anim["STAND_RIFLE_walk"] = ACT_WALK_RIFLE_RELAXED;
TS.AnimTables[1].Anim["STAND_RIFLE_run"] = ACT_RUN_RIFLE_RELAXED;
TS.AnimTables[1].Anim["CROUCH_RIFLE_idle"] = ACT_WALK_CROUCH_RIFLE;
TS.AnimTables[1].Anim["CROUCH_RIFLE_walk"] = ACT_WALK_CROUCH_RIFLE;

TS.AnimTables[1].Anim["STAND_RIFLE_AIM_idle"] = ACT_IDLE_AIM_RIFLE_STIMULATED;
TS.AnimTables[1].Anim["STAND_RIFLE_AIM_walk"] = ACT_WALK_AIM_RIFLE_STIMULATED;
TS.AnimTables[1].Anim["STAND_RIFLE_AIM_run"] = ACT_RUN_AIM_RIFLE_STIMULATED;
TS.AnimTables[1].Anim["CROUCH_RIFLE_AIM_idle"] = ACT_RANGE_ATTACK_RIFLE_LOW;
TS.AnimTables[1].Anim["CROUCH_RIFLE_AIM_walk"] = ACT_WALK_CROUCH_AIM_RIFLE;

TS.AnimTables[1].Anim["STAND_SHOTGUN_idle"] = ACT_IDLE_SHOTGUN_RELAXED;
TS.AnimTables[1].Anim["STAND_SHOTGUN_walk"] = ACT_WALK_RPG_RELAXED;
TS.AnimTables[1].Anim["STAND_SHOTGUN_run"] = ACT_RUN_RPG_RELAXED;
TS.AnimTables[1].Anim["CROUCH_SHOTGUN_idle"] = ACT_COVER_LOW_RPG;
TS.AnimTables[1].Anim["CROUCH_SHOTGUN_walk"] = ACT_WALK_CROUCH_RPG;

TS.AnimTables[1].Anim["STAND_SHOTGUN_AIM_idle"] = ACT_IDLE_ANGRY_RPG;
TS.AnimTables[1].Anim["STAND_SHOTGUN_AIM_walk"] = ACT_WALK_AIM_RIFLE_STIMULATED;
TS.AnimTables[1].Anim["STAND_SHOTGUN_AIM_run"] = ACT_RUN_AIM_RIFLE_STIMULATED;
TS.AnimTables[1].Anim["CROUCH_SHOTGUN_AIM_idle"] = ACT_RANGE_AIM_SMG1_LOW;
TS.AnimTables[1].Anim["CROUCH_SHOTGUN_AIM_walk"] = ACT_WALK_CROUCH_AIM_RIFLE;

TS.AnimTables[1].Anim["jump"] = ACT_JUMP;

-----------------------------------------
-- END MALE CITIZEN ANIM TABLE
-----------------------------------------



-----------------------------------------
-- FEMALE CITIZEN ANIM TABLE
-----------------------------------------
TS.AnimTables[2] = { }
TS.AnimTables[2].Models =
{

	"models/barnes/refugee/female_01.mdl",
	"models/barnes/refugee/female_02.mdl",
	"models/barnes/refugee/female_03.mdl",
	"models/barnes/refugee/female_04.mdl",
	"models/barnes/refugee/female_06.mdl",
	"models/barnes/refugee/female_07.mdl",
	"models/barnes/refugee/female_19.mdl",
	"models/barnes/refugee/female_23.mdl",
	"models/barnes/refugee/female_24.mdl",
	"models/barnes/refugee/female_25.mdl",
	"models/barnes/refugee/female_31.mdl",
	"models/humans/female_ca.mdl",
	"models/humans/group01/Female_01.mdl",
	"models/humans/group01/Female_02.mdl",
	"models/humans/group01/Female_03.mdl",
	"models/humans/group01/Female_04.mdl",
	"models/humans/group01/Female_06.mdl",
	"models/humans/group01/Female_07.mdl",
	"models/humans/group01/female_05.mdl",
	"models/humans/group01/female_08.mdl",
	"models/humans/group01/female_09.mdl",
	"models/humans/group01/female_10.mdl",
	"models/humans/group01/female_11.mdl",
	"models/humans/group01/female_12.mdl",
	"models/humans/group01/female_13.mdl",
	"models/humans/group01/female_14.mdl",
	"models/humans/group01/female_15.mdl",
	"models/humans/group01/female_16.mdl",
	"models/humans/group01/female_17.mdl",
	"models/humans/group01/female_18.mdl",
	"models/humans/group01/female_19.mdl",
	"models/humans/group01/female_20.mdl",
	"models/humans/group01/female_21.mdl",
	"models/humans/group01/female_22.mdl",
	"models/humans/group01/female_23.mdl",
	"models/humans/group01/female_24.mdl",
	"models/humans/group01/female_25.mdl",
	"models/humans/group01/female_26.mdl",
	"models/humans/group01/female_27.mdl",
	"models/humans/group01/female_28.mdl",
	"models/humans/group01/female_29.mdl",
	"models/humans/group01/female_30.mdl",
	"models/humans/group01/female_31.mdl",
	"models/humans/group01/female_32.mdl",
	"models/humans/group01/female_33.mdl",
	"models/humans/group01/female_ca.mdl",
	"models/humans/group01/female_ct.mdl",
	"models/humans/group01/female_pz.mdl",
	"models/humans/group01/female_tc.mdl",
	"models/humans/group01/female_zo.mdl",
	"models/humans/group01/femalerei.mdl",
	"models/humans/group03/Female_01_bloody.mdl",
	"models/humans/group03/female_01.mdl",
	"models/humans/group03/female_02.mdl",
	"models/humans/group03/female_05.mdl",
	"models/humans/group03/female_08.mdl",
	"models/humans/group03/female_09.mdl",
	"models/humans/group03/female_10.mdl",
	"models/humans/group03/female_11.mdl",
	"models/humans/group03/female_12.mdl",
	"models/humans/group03/female_13.mdl",
	"models/humans/group03/female_14.mdl",
	"models/humans/group03/female_15.mdl",
	"models/humans/group03/female_16.mdl",
	"models/humans/group03/female_17.mdl",
	"models/humans/group03/female_18.mdl",
	"models/humans/group03/female_19.mdl",
	"models/humans/group03/female_20.mdl",
	"models/humans/group03/female_21.mdl",
	"models/humans/group03/female_22.mdl",
	"models/humans/group03/female_23.mdl",
	"models/humans/group03/female_24.mdl",
	"models/humans/group03/female_25.mdl",
	"models/humans/group03/female_26.mdl",
	"models/humans/group03/female_27.mdl",
	"models/humans/group03/female_28.mdl",
	"models/humans/group03/female_29.mdl",
	"models/humans/group03/female_30.mdl",
	"models/humans/group03/female_31.mdl",
	"models/humans/group03/female_32.mdl",
	"models/humans/group03/female_33.mdl",
	"models/humans/group03/female_ct.mdl",
	"models/humans/group03/female_pz.mdl",
	"models/humans/group03/female_tc.mdl",
	"models/humans/group03/female_zo.mdl",
	"models/humans/group03/femalerei.mdl",
	"models/humans/groupsp/Female_01.mdl",
	"models/humans/groupsp/Female_02.mdl",
	"models/humans/groupsp/Female_03.mdl",
	"models/humans/groupsp/Female_04.mdl",
	"models/humans/groupsp/Female_06.mdl",
	"models/humans/groupsp/Female_07.mdl",
	"models/player/Group01/Female_01.mdl",
	"models/player/Group01/Female_02.mdl",
	"models/player/Group01/Female_03.mdl",
	"models/player/Group01/Female_04.mdl",
	"models/player/Group01/Female_06.mdl",
	"models/player/Group01/Female_07.mdl",
	"models/player/Group03/Female_01.mdl",
	"models/player/Group03/Female_02.mdl",
	"models/player/Group03/Female_03.mdl",
	"models/player/Group03/Female_04.mdl",
	"models/player/Group03/Female_06.mdl",
	"models/player/Group03/Female_07.mdl",
	"models/lambdamovement_female.mdl",
	"models/tactical_rebel_female.mdl",
	"models/c08cop_female.mdl",

};

TS.AnimTables[2].Anim = { }

--[[
TS.AnimTables[2].Anim["STAND_idle"] = 1;
TS.AnimTables[2].Anim["STAND_walk"] = 6;
TS.AnimTables[2].Anim["STAND_run"] = 10;

TS.AnimTables[2].Anim["STAND_FIST_idle"] = 1;
TS.AnimTables[2].Anim["STAND_FIST_walk"] = 6;
TS.AnimTables[2].Anim["STAND_FIST_run"] = 10;
TS.AnimTables[2].Anim["CROUCH_FIST_idle"] = 5;
TS.AnimTables[2].Anim["CROUCH_FIST_walk"] = 8;

TS.AnimTables[2].Anim["STAND_FIST_AIM_idle"] = 278;
TS.AnimTables[2].Anim["STAND_FIST_AIM_walk"] = 365;
TS.AnimTables[2].Anim["STAND_FIST_AIM_run"] = 366;
TS.AnimTables[2].Anim["CROUCH_FIST_AIM_idle"] = 279;
TS.AnimTables[2].Anim["CROUCH_FIST_AIM_walk"] = 292;

TS.AnimTables[2].Anim["STAND_BLUNT_idle"] = 1;
TS.AnimTables[2].Anim["STAND_BLUNT_walk"] = 6;
TS.AnimTables[2].Anim["STAND_BLUNT_run"] = 10;
TS.AnimTables[2].Anim["CROUCH_BLUNT_idle"] = 5;
TS.AnimTables[2].Anim["CROUCH_BLUNT_walk"] = 8;

TS.AnimTables[2].Anim["STAND_BLUNT_AIM_idle"] = 278;
TS.AnimTables[2].Anim["STAND_BLUNT_AIM_walk"] = 365;
TS.AnimTables[2].Anim["STAND_BLUNT_AIM_run"] = 366;
TS.AnimTables[2].Anim["CROUCH_BLUNT_AIM_idle"] = 279;
TS.AnimTables[2].Anim["CROUCH_BLUNT_AIM_walk"] = 355;

TS.AnimTables[2].Anim["STAND_PISTOL_idle"] = 1;
TS.AnimTables[2].Anim["STAND_PISTOL_walk"] = 6;
TS.AnimTables[2].Anim["STAND_PISTOL_run"] = 10;
TS.AnimTables[2].Anim["CROUCH_PISTOL_idle"] = 5;
TS.AnimTables[2].Anim["CROUCH_PISTOL_walk"] = 8;

TS.AnimTables[2].Anim["STAND_PISTOL_AIM_idle"] = 283;
TS.AnimTables[2].Anim["STAND_PISTOL_AIM_walk"] = 365;
TS.AnimTables[2].Anim["STAND_PISTOL_AIM_run"] = 366;
TS.AnimTables[2].Anim["CROUCH_PISTOL_AIM_idle"] = 279;
TS.AnimTables[2].Anim["CROUCH_PISTOL_AIM_walk"] = 355;

TS.AnimTables[2].Anim["STAND_SMG_idle"] = 324;
TS.AnimTables[2].Anim["STAND_SMG_walk"] = 326;
TS.AnimTables[2].Anim["STAND_SMG_run"] = 327;
TS.AnimTables[2].Anim["CROUCH_SMG_idle"] = 345;
TS.AnimTables[2].Anim["CROUCH_SMG_walk"] = 348;

TS.AnimTables[2].Anim["STAND_SMG_AIM_idle"] = 278;
TS.AnimTables[2].Anim["STAND_SMG_AIM_walk"] = 353;
TS.AnimTables[2].Anim["STAND_SMG_AIM_run"] = 332;
TS.AnimTables[2].Anim["CROUCH_SMG_AIM_idle"] = 279;
TS.AnimTables[2].Anim["CROUCH_SMG_AIM_walk"] = 355;

TS.AnimTables[2].Anim["STAND_RIFLE_idle"] = 342;
TS.AnimTables[2].Anim["STAND_RIFLE_walk"] = 328;
TS.AnimTables[2].Anim["STAND_RIFLE_run"] = 329;
TS.AnimTables[2].Anim["CROUCH_RIFLE_idle"] = 345;
TS.AnimTables[2].Anim["CROUCH_RIFLE_walk"] = 348;

TS.AnimTables[2].Anim["STAND_RIFLE_AIM_idle"] = 344;
TS.AnimTables[2].Anim["STAND_RIFLE_AIM_walk"] = 331;
TS.AnimTables[2].Anim["STAND_RIFLE_AIM_run"] = 332;
TS.AnimTables[2].Anim["CROUCH_RIFLE_AIM_idle"] = 279;
TS.AnimTables[2].Anim["CROUCH_RIFLE_AIM_walk"] = 355;

TS.AnimTables[2].Anim["STAND_SHOTGUN_idle"] = ACT_IDLE_SHOTGUN_RELAXED;
TS.AnimTables[2].Anim["STAND_SHOTGUN_walk"] = 328;
TS.AnimTables[2].Anim["STAND_SHOTGUN_run"] = 351;
TS.AnimTables[2].Anim["CROUCH_SHOTGUN_idle"] = 345;
TS.AnimTables[2].Anim["CROUCH_SHOTGUN_walk"] = 8;

TS.AnimTables[2].Anim["STAND_SHOTGUN_AIM_idle"] = 335;
TS.AnimTables[2].Anim["STAND_SHOTGUN_AIM_walk"] = 331;
TS.AnimTables[2].Anim["STAND_SHOTGUN_AIM_run"] = 332;
TS.AnimTables[2].Anim["CROUCH_SHOTGUN_AIM_idle"] = 279;
TS.AnimTables[2].Anim["CROUCH_SHOTGUN_AIM_walk"] = 355;

TS.AnimTables[2].Anim["jump"] = 27;
]]
-----------------------------------------
-- END FEMALE CITIZEN ANIM TABLE
-----------------------------------------

-----------------------------------------
-- CP ANIM TABLE
-----------------------------------------
TS.AnimTables[3] = { }
TS.AnimTables[3].Models =
{

	"models/police.mdl",
	"models/leet_police2.mdl",
	"models/javelin_unit.mdl",
	"models/arbitercp.mdl",
	"models/policetrench.mdl",
	"models/yellowlake/BlaCop.mdl",
	"models/eliteshockcp.mdl",
	"models/c08cop.mdl",
	"models/c08sql.mdl",
	"models/c08coptrench.mdl",
	"models/metrold.mdl",
	"models/police_opcmd.mdl",
	"models/police/wollycop.mdl",
  
};

--[[
TS.AnimTables[3].Anim = { }

TS.AnimTables[3].Anim["STAND_idle"] = 1;
TS.AnimTables[3].Anim["STAND_walk"] = 6;
TS.AnimTables[3].Anim["STAND_run"] = 10;

TS.AnimTables[3].Anim["STAND_FIST_idle"] = 1;
TS.AnimTables[3].Anim["STAND_FIST_walk"] = 6;
TS.AnimTables[3].Anim["STAND_FIST_run"] = 10;
TS.AnimTables[3].Anim["CROUCH_FIST_idle"] = 295;
TS.AnimTables[3].Anim["CROUCH_FIST_walk"] = 8;

TS.AnimTables[3].Anim["STAND_FIST_AIM_idle"] = 315;
TS.AnimTables[3].Anim["STAND_FIST_AIM_walk"] = 340;
TS.AnimTables[3].Anim["STAND_FIST_AIM_run"] = 343;
TS.AnimTables[3].Anim["CROUCH_FIST_AIM_idle"] = 283;
TS.AnimTables[3].Anim["CROUCH_FIST_AIM_walk"] = 8;

TS.AnimTables[3].Anim["STAND_BLUNT_idle"] = 1;
TS.AnimTables[3].Anim["STAND_BLUNT_walk"] = 6;
TS.AnimTables[3].Anim["STAND_BLUNT_run"] = 10;
TS.AnimTables[3].Anim["CROUCH_BLUNT_idle"] = 283;
TS.AnimTables[3].Anim["CROUCH_BLUNT_walk"] = 8;

TS.AnimTables[3].Anim["STAND_BLUNT_AIM_idle"] = 341;
TS.AnimTables[3].Anim["STAND_BLUNT_AIM_walk"] = 336;
TS.AnimTables[3].Anim["STAND_BLUNT_AIM_run"] = 10;
TS.AnimTables[3].Anim["CROUCH_BLUNT_AIM_idle"] = 296;
TS.AnimTables[3].Anim["CROUCH_BLUNT_AIM_walk"] = 8;
TS.AnimTables[3].Anim["BLUNT_ATTACK"] = 290;

TS.AnimTables[3].Anim["STAND_PISTOL_idle"] = 1;
TS.AnimTables[3].Anim["STAND_PISTOL_walk"] = 6;
TS.AnimTables[3].Anim["STAND_PISTOL_run"] = 10;
TS.AnimTables[3].Anim["CROUCH_PISTOL_idle"] = 295;
TS.AnimTables[3].Anim["CROUCH_PISTOL_walk"] = 8;

TS.AnimTables[3].Anim["STAND_PISTOL_AIM_idle"] = 283;
TS.AnimTables[3].Anim["STAND_PISTOL_AIM_walk"] = 365;
TS.AnimTables[3].Anim["STAND_PISTOL_AIM_run"] = 366;
TS.AnimTables[3].Anim["CROUCH_PISTOL_AIM_idle"] = 296;
TS.AnimTables[3].Anim["CROUCH_PISTOL_AIM_walk"] = 8;

TS.AnimTables[3].Anim["STAND_SMG_idle"] = 314;
TS.AnimTables[3].Anim["STAND_SMG_walk"] = 352;
TS.AnimTables[3].Anim["STAND_SMG_run"] = 356;
TS.AnimTables[3].Anim["CROUCH_SMG_idle"] = 283;
TS.AnimTables[3].Anim["CROUCH_SMG_walk"] = 8;

TS.AnimTables[3].Anim["STAND_SMG_AIM_idle"] = 278;
TS.AnimTables[3].Anim["STAND_SMG_AIM_walk"] = 353;
TS.AnimTables[3].Anim["STAND_SMG_AIM_run"] = 356;
TS.AnimTables[3].Anim["CROUCH_SMG_AIM_idle"] = 296;
TS.AnimTables[3].Anim["CROUCH_SMG_AIM_walk"] = 8;

TS.AnimTables[3].Anim["STAND_RIFLE_idle"] = 314;
TS.AnimTables[3].Anim["STAND_RIFLE_walk"] = 352;
TS.AnimTables[3].Anim["STAND_RIFLE_run"] = 356;
TS.AnimTables[3].Anim["CROUCH_RIFLE_idle"] = 283;
TS.AnimTables[3].Anim["CROUCH_RIFLE_walk"] = 8;

TS.AnimTables[3].Anim["STAND_RIFLE_AIM_idle"] = 315;
TS.AnimTables[3].Anim["STAND_RIFLE_AIM_walk"] = 353;
TS.AnimTables[3].Anim["STAND_RIFLE_AIM_run"] = 356;
TS.AnimTables[3].Anim["CROUCH_RIFLE_AIM_idle"] = 296;
TS.AnimTables[3].Anim["CROUCH_RIFLE_AIM_walk"] = 8;

TS.AnimTables[3].Anim["STAND_SHOTGUN_idle"] = 314;
TS.AnimTables[3].Anim["STAND_SHOTGUN_walk"] = 352;
TS.AnimTables[3].Anim["STAND_SHOTGUN_run"] = 356;
TS.AnimTables[3].Anim["CROUCH_SHOTGUN_idle"] = 283;
TS.AnimTables[3].Anim["CROUCH_SHOTGUN_walk"] = 8;

TS.AnimTables[3].Anim["STAND_SHOTGUN_AIM_idle"] = 315;
TS.AnimTables[3].Anim["STAND_SHOTGUN_AIM_walk"] = 353;
TS.AnimTables[3].Anim["STAND_SHOTGUN_AIM_run"] = 356;
TS.AnimTables[3].Anim["CROUCH_SHOTGUN_AIM_idle"] = 296;
TS.AnimTables[3].Anim["CROUCH_SHOTGUN_AIM_walk"] = 8;

TS.AnimTables[3].Anim["jump"] = 27;
]]

-----------------------------------------
-- END CP ANIM TABLE
-----------------------------------------

-----------------------------------------
-- COMBINE OVERWATCH ANIM TABLE
-----------------------------------------
TS.AnimTables[4] = { }
TS.AnimTables[4].Models =
{

	"models/combine_super_soldier.mdl",
	"models/Combine_Soldier.mdl",
	"models/Combine_Black_Soldier.mdl",
	"models/urbantrenchcoat.mdl",
	"models/JBarnes/soldiers/city08soldier.mdl",
	"models/combine_elite_soldier.mdl",
	"models/combine_bacon_soldier.mdl",
	"models/combine_se.mdl",
	"models/city8_overwatch.mdl",
	"models/city8_overwatch_elite.mdl",
	"models/city8ow.mdl",
	"models/city8_ow_elite.mdl",
	
};
--[[
TS.AnimTables[4].Anim = { }

TS.AnimTables[4].Anim["STAND_idle"] = 314
TS.AnimTables[4].Anim["STAND_walk"] = 352;
TS.AnimTables[4].Anim["STAND_run"] = 356;

TS.AnimTables[4].Anim["STAND_FIST_idle"] = 314
TS.AnimTables[4].Anim["STAND_FIST_walk"] = 352;
TS.AnimTables[4].Anim["STAND_FIST_run"] = 356;
TS.AnimTables[4].Anim["CROUCH_FIST_idle"] = 45;
TS.AnimTables[4].Anim["CROUCH_FIST_walk"] = 341;

TS.AnimTables[4].Anim["STAND_FIST_AIM_idle"] = 302;
TS.AnimTables[4].Anim["STAND_FIST_AIM_walk"] = 340;
TS.AnimTables[4].Anim["STAND_FIST_AIM_run"] = 344;
TS.AnimTables[4].Anim["CROUCH_FIST_AIM_idle"] = 45;
TS.AnimTables[4].Anim["CROUCH_FIST_AIM_walk"] = 341;

TS.AnimTables[4].Anim["STAND_PISTOL_idle"] = 1;
TS.AnimTables[4].Anim["STAND_PISTOL_walk"] = 352;
TS.AnimTables[4].Anim["STAND_PISTOL_run"] = 356;
TS.AnimTables[4].Anim["CROUCH_PISTOL_idle"] = 45;
TS.AnimTables[4].Anim["CROUCH_PISTOL_walk"] = 341;

TS.AnimTables[4].Anim["STAND_PISTOL_AIM_idle"] = 315;
TS.AnimTables[4].Anim["STAND_PISTOL_AIM_walk"] = 353;
TS.AnimTables[4].Anim["STAND_PISTOL_AIM_run"] = 344;
TS.AnimTables[4].Anim["CROUCH_PISTOL_AIM_idle"] = 45;
TS.AnimTables[4].Anim["CROUCH_PISTOL_AIM_walk"] = 342;

TS.AnimTables[4].Anim["STAND_SMG_idle"] = 1;
TS.AnimTables[4].Anim["STAND_SMG_walk"] = 352;
TS.AnimTables[4].Anim["STAND_SMG_run"] = 356;
TS.AnimTables[4].Anim["CROUCH_SMG_idle"] = 45;
TS.AnimTables[4].Anim["CROUCH_SMG_walk"] = 354;

TS.AnimTables[4].Anim["STAND_SMG_AIM_idle"] = 278;
TS.AnimTables[4].Anim["STAND_SMG_AIM_walk"] = 353;
TS.AnimTables[4].Anim["STAND_SMG_AIM_run"] = 357;
TS.AnimTables[4].Anim["CROUCH_SMG_AIM_idle"] = 279;
TS.AnimTables[4].Anim["CROUCH_SMG_AIM_walk"] = 354;

TS.AnimTables[4].Anim["STAND_RIFLE_idle"] = 1;
TS.AnimTables[4].Anim["STAND_RIFLE_walk"] = 352;
TS.AnimTables[4].Anim["STAND_RIFLE_run"] = 356;
TS.AnimTables[4].Anim["CROUCH_RIFLE_idle"] = 274;
TS.AnimTables[4].Anim["CROUCH_RIFLE_walk"] = 354;

TS.AnimTables[4].Anim["STAND_RIFLE_AIM_idle"] = 273;
TS.AnimTables[4].Anim["STAND_RIFLE_AIM_walk"] = 353;
TS.AnimTables[4].Anim["STAND_RIFLE_AIM_run"] = 344;
TS.AnimTables[4].Anim["CROUCH_RIFLE_AIM_idle"] = 274;
TS.AnimTables[4].Anim["CROUCH_RIFLE_AIM_walk"] = 354;

TS.AnimTables[4].Anim["STAND_SHOTGUN_idle"] = 1;
TS.AnimTables[4].Anim["STAND_SHOTGUN_walk"] = 352;
TS.AnimTables[4].Anim["STAND_SHOTGUN_run"] = 356;
TS.AnimTables[4].Anim["CROUCH_SHOTGUN_idle"] = 45;
TS.AnimTables[4].Anim["CROUCH_SHOTGUN_walk"] = 341;

TS.AnimTables[4].Anim["STAND_SHOTGUN_AIM_idle"] = 281;
TS.AnimTables[4].Anim["STAND_SHOTGUN_AIM_walk"] = 361;
TS.AnimTables[4].Anim["STAND_SHOTGUN_AIM_run"] = 362;
TS.AnimTables[4].Anim["CROUCH_SHOTGUN_AIM_idle"] = 282;
TS.AnimTables[4].Anim["CROUCH_SHOTGUN_AIM_walk"] = 354;

TS.AnimTables[4].Anim["CROUCH_idle"] = 45;
TS.AnimTables[4].Anim["CROUCH_walk"] = 341;

TS.AnimTables[4].Anim["jump"] = 27;
]]
-----------------------------------------
-- END COMBINE OVERWATCH ANIM TABLE
-----------------------------------------

-----------------------------------------
-- HUNTER ANIM TABLE
-----------------------------------------
TS.AnimTables[5] = { }
TS.AnimTables[5].Models =
{

  "models/hunter.mdl"
  
};

--[[
TS.AnimTables[5].Anim = { }

TS.AnimTables[5].Anim["STAND_idle"] = 24;
TS.AnimTables[5].Anim["STAND_walk"] = 6;
TS.AnimTables[5].Anim["STAND_run"] = 10;

TS.AnimTables[5].Anim["STAND_FIST_idle"] = 24;
TS.AnimTables[5].Anim["STAND_FIST_walk"] = 6;
TS.AnimTables[5].Anim["STAND_FIST_run"] = 10;
TS.AnimTables[5].Anim["CROUCH_FIST_idle"] = 24;
TS.AnimTables[5].Anim["CROUCH_FIST_walk"] = 6;

TS.AnimTables[5].Anim["STAND_FIST_AIM_idle"] = 24;
TS.AnimTables[5].Anim["STAND_FIST_AIM_walk"] = 6;
TS.AnimTables[5].Anim["STAND_FIST_AIM_run"] = 10;
TS.AnimTables[5].Anim["CROUCH_FIST_AIM_idle"] = 24;
TS.AnimTables[5].Anim["CROUCH_FIST_AIM_walk"] = 6;

TS.AnimTables[5].Anim["STAND_PISTOL_idle"] = 24;
TS.AnimTables[5].Anim["STAND_PISTOL_walk"] = 6;
TS.AnimTables[5].Anim["STAND_PISTOL_run"] = 10;
TS.AnimTables[5].Anim["CROUCH_PISTOL_idle"] = 24;
TS.AnimTables[5].Anim["CROUCH_PISTOL_walk"] = 6;

TS.AnimTables[5].Anim["STAND_PISTOL_AIM_idle"] = 24;
TS.AnimTables[5].Anim["STAND_PISTOL_AIM_walk"] = 6;
TS.AnimTables[5].Anim["STAND_PISTOL_AIM_run"] = 10;
TS.AnimTables[5].Anim["CROUCH_PISTOL_AIM_idle"] = 24;
TS.AnimTables[5].Anim["CROUCH_PISTOL_AIM_walk"] = 6;

TS.AnimTables[5].Anim["STAND_SMG_idle"] = 24;
TS.AnimTables[5].Anim["STAND_SMG_walk"] = 6;
TS.AnimTables[5].Anim["STAND_SMG_run"] = 10;
TS.AnimTables[5].Anim["CROUCH_SMG_idle"] = 24;
TS.AnimTables[5].Anim["CROUCH_SMG_walk"] = 6;

TS.AnimTables[5].Anim["STAND_SMG_AIM_idle"] = 24;
TS.AnimTables[5].Anim["STAND_SMG_AIM_walk"] = 6;
TS.AnimTables[5].Anim["STAND_SMG_AIM_run"] = 10;
TS.AnimTables[5].Anim["CROUCH_SMG_AIM_idle"] = 24;
TS.AnimTables[5].Anim["CROUCH_SMG_AIM_walk"] = 6;

TS.AnimTables[5].Anim["STAND_RIFLE_idle"] = 24;
TS.AnimTables[5].Anim["STAND_RIFLE_walk"] = 6;
TS.AnimTables[5].Anim["STAND_RIFLE_run"] = 10;
TS.AnimTables[5].Anim["CROUCH_RIFLE_idle"] = 24;
TS.AnimTables[5].Anim["CROUCH_RIFLE_walk"] = 6;

TS.AnimTables[5].Anim["STAND_RIFLE_AIM_idle"] = 24;
TS.AnimTables[5].Anim["STAND_RIFLE_AIM_walk"] = 6;
TS.AnimTables[5].Anim["STAND_RIFLE_AIM_run"] = 10;
TS.AnimTables[5].Anim["CROUCH_RIFLE_AIM_idle"] = 24;
TS.AnimTables[5].Anim["CROUCH_RIFLE_AIM_walk"] = 6;

TS.AnimTables[5].Anim["STAND_SHOTGUN_idle"] = 24;
TS.AnimTables[5].Anim["STAND_SHOTGUN_walk"] = 6;
TS.AnimTables[5].Anim["STAND_SHOTGUN_run"] = 10;
TS.AnimTables[5].Anim["CROUCH_SHOTGUN_idle"] = 24;
TS.AnimTables[5].Anim["CROUCH_SHOTGUN_walk"] = 6;

TS.AnimTables[5].Anim["STAND_SHOTGUN_AIM_idle"] = 24;
TS.AnimTables[5].Anim["STAND_SHOTGUN_AIM_walk"] = 6;
TS.AnimTables[5].Anim["STAND_SHOTGUN_AIM_run"] = 10;
TS.AnimTables[5].Anim["CROUCH_SHOTGUN_AIM_idle"] = 24;
TS.AnimTables[5].Anim["CROUCH_SHOTGUN_AIM_walk"] = 6;

TS.AnimTables[5].Anim["CROUCH_idle"] = 24;
TS.AnimTables[5].Anim["CROUCH_walk"] = 6;

TS.AnimTables[5].Anim["jump"] = 29;
]]
-----------------------------------------
-- END HUNTER ANIM TABLE
-----------------------------------------

-----------------------------------------
-- VORT ANIM TABLE
-----------------------------------------
TS.AnimTables[6] = { }
TS.AnimTables[6].Models =
{

  "models/vortigaunt.mdl",
	"models/vortigaunt_slave.mdl",
	"models/vortigaunt_doctor.mdl",
	"models/vortigaunt_ozaxi.mdl",
  
};
--[[
TS.AnimTables[6].Anim = { }

TS.AnimTables[6].Anim["STAND_idle"] = 1;
TS.AnimTables[6].Anim["STAND_walk"] = 6;
TS.AnimTables[6].Anim["STAND_run"] = 10;

TS.AnimTables[6].Anim["STAND_FIST_idle"] = 1;
TS.AnimTables[6].Anim["STAND_FIST_walk"] = 6;
TS.AnimTables[6].Anim["STAND_FIST_run"] = 10;
TS.AnimTables[6].Anim["CROUCH_FIST_idle"] = 45;
TS.AnimTables[6].Anim["CROUCH_FIST_walk"] = 341;

TS.AnimTables[6].Anim["STAND_FIST_AIM_idle"] = 75;
TS.AnimTables[6].Anim["STAND_FIST_AIM_walk"] = 340;
TS.AnimTables[6].Anim["STAND_FIST_AIM_run"] = 344;
TS.AnimTables[6].Anim["CROUCH_FIST_AIM_idle"] = 45;
TS.AnimTables[6].Anim["CROUCH_FIST_AIM_walk"] = 341;

TS.AnimTables[6].Anim["STAND_PISTOL_idle"] = 1;
TS.AnimTables[6].Anim["STAND_PISTOL_walk"] = 352;
TS.AnimTables[6].Anim["STAND_PISTOL_run"] = 356;
TS.AnimTables[6].Anim["CROUCH_PISTOL_idle"] = 45;
TS.AnimTables[6].Anim["CROUCH_PISTOL_walk"] = 341;

TS.AnimTables[6].Anim["STAND_PISTOL_AIM_idle"] = 315;
TS.AnimTables[6].Anim["STAND_PISTOL_AIM_walk"] = 353;
TS.AnimTables[6].Anim["STAND_PISTOL_AIM_run"] = 344;
TS.AnimTables[6].Anim["CROUCH_PISTOL_AIM_idle"] = 45;
TS.AnimTables[6].Anim["CROUCH_PISTOL_AIM_walk"] = 342;

TS.AnimTables[6].Anim["STAND_SMG_idle"] = 1;
TS.AnimTables[6].Anim["STAND_SMG_walk"] = 352;
TS.AnimTables[6].Anim["STAND_SMG_run"] = 356;
TS.AnimTables[6].Anim["CROUCH_SMG_idle"] = 45;
TS.AnimTables[6].Anim["CROUCH_SMG_walk"] = 354;

TS.AnimTables[6].Anim["STAND_SMG_AIM_idle"] = 278;
TS.AnimTables[6].Anim["STAND_SMG_AIM_walk"] = 353;
TS.AnimTables[6].Anim["STAND_SMG_AIM_run"] = 357;
TS.AnimTables[6].Anim["CROUCH_SMG_AIM_idle"] = 279;
TS.AnimTables[6].Anim["CROUCH_SMG_AIM_walk"] = 354;

TS.AnimTables[6].Anim["STAND_RIFLE_idle"] = 1;
TS.AnimTables[6].Anim["STAND_RIFLE_walk"] = 352;
TS.AnimTables[6].Anim["STAND_RIFLE_run"] = 356;
TS.AnimTables[6].Anim["CROUCH_RIFLE_idle"] = 274;
TS.AnimTables[6].Anim["CROUCH_RIFLE_walk"] = 354;

TS.AnimTables[6].Anim["STAND_RIFLE_AIM_idle"] = 273;
TS.AnimTables[6].Anim["STAND_RIFLE_AIM_walk"] = 353;
TS.AnimTables[6].Anim["STAND_RIFLE_AIM_run"] = 344;
TS.AnimTables[6].Anim["CROUCH_RIFLE_AIM_idle"] = 274;
TS.AnimTables[6].Anim["CROUCH_RIFLE_AIM_walk"] = 354;

TS.AnimTables[6].Anim["STAND_SHOTGUN_idle"] = 1;
TS.AnimTables[6].Anim["STAND_SHOTGUN_walk"] = 352;
TS.AnimTables[6].Anim["STAND_SHOTGUN_run"] = 356;
TS.AnimTables[6].Anim["CROUCH_SHOTGUN_idle"] = 45;
TS.AnimTables[6].Anim["CROUCH_SHOTGUN_walk"] = 341;

TS.AnimTables[6].Anim["STAND_SHOTGUN_AIM_idle"] = 281;
TS.AnimTables[6].Anim["STAND_SHOTGUN_AIM_walk"] = 361;
TS.AnimTables[6].Anim["STAND_SHOTGUN_AIM_run"] = 362;
TS.AnimTables[6].Anim["CROUCH_SHOTGUN_AIM_idle"] = 282;
TS.AnimTables[6].Anim["CROUCH_SHOTGUN_AIM_walk"] = 354;

TS.AnimTables[6].Anim["CROUCH_idle"] = 45;
TS.AnimTables[6].Anim["CROUCH_walk"] = 341;

TS.AnimTables[6].Anim["jump"] = 167;
]]
-----------------------------------------
-- END VORT ANIM TABLE
-----------------------------------------

TS.AnimTables[2].Anim = TS.AnimTables[1].Anim;
TS.AnimTables[3].Anim = TS.AnimTables[1].Anim;
TS.AnimTables[4].Anim = TS.AnimTables[1].Anim;
TS.AnimTables[5].Anim = TS.AnimTables[1].Anim;
TS.AnimTables[6].Anim = TS.AnimTables[1].Anim;

for k, v in pairs( TS.AnimTables ) do

	for n, m in pairs( v.Models ) do
	
		TS.AnimTables[k].Models[n] = string.lower( TS.AnimTables[k].Models[n] );
	
	end

end