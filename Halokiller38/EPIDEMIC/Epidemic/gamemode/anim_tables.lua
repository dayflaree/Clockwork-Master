AnimTables = { };


AnimTables[1] = { }

AnimTables[1].Models =
{
-- default so no point in wasting space!
};
AnimTables[1].Anim = { };
AnimTables[1].Reload = { };
AnimTables[1].Shoot = { };

AnimTables[1].Reload["PISTOL"] = ACT_GESTURE_RELOAD_SMG1;
AnimTables[1].Reload["SMG"] = ACT_GESTURE_RELOAD_SMG1;
AnimTables[1].Reload["RIFLE"] = ACT_GESTURE_RELOAD_SMG1;
AnimTables[1].Reload["SHOTGUN"] = ACT_GESTURE_RELOAD_SMG1;
AnimTables[1].Reload["SNIPER"] = ACT_GESTURE_RELOAD_SMG1;

AnimTables[1].Shoot["PISTOL"] = ACT_GESTURE_RANGE_ATTACK_SMG1;
AnimTables[1].Shoot["SMG"] = ACT_GESTURE_RANGE_ATTACK_SMG1;
AnimTables[1].Shoot["RIFLE"] = ACT_GESTURE_RANGE_ATTACK_AR2;
AnimTables[1].Shoot["SHOTGUN"] = ACT_GESTURE_RANGE_ATTACK_SHOTGUN;
AnimTables[1].Shoot["SNIPER"] = ACT_GESTURE_RANGE_ATTACK_SHOTGUN;

AnimTables[1].Anim["STAND_idle"] = ACT_IDLE;
AnimTables[1].Anim["STAND_walk"] = ACT_WALK;
AnimTables[1].Anim["STAND_run"] = "run_all_panicked";
AnimTables[1].Anim["STAND_jog"] = ACT_RUN;

AnimTables[1].Anim["CROUCH_idle"] = ACT_COVER_LOW;
AnimTables[1].Anim["CROUCH_walk"] = ACT_WALK_CROUCH;

AnimTables[1].Anim["STAND_FIST_idle"] = ACT_IDLE;
AnimTables[1].Anim["STAND_FIST_walk"] = ACT_WALK;
AnimTables[1].Anim["STAND_FIST_run"] = "run_all_panicked";
AnimTables[1].Anim["STAND_FIST_jog"] = ACT_RUN;
AnimTables[1].Anim["CROUCH_FIST_idle"] = ACT_COVER_LOW;
AnimTables[1].Anim["CROUCH_FIST_walk"] = ACT_WALK_CROUCH;

AnimTables[1].Anim["STAND_FIST_AIM_idle"] = "idle_angry_melee";
AnimTables[1].Anim["STAND_FIST_AIM_walk"] = ACT_WALK;
AnimTables[1].Anim["STAND_FIST_AIM_run"] = "run_all_panicked";
AnimTables[1].Anim["STAND_FIST_AIM_jog"] = ACT_RUN;
AnimTables[1].Anim["CROUCH_FIST_AIM_idle"] = ACT_COVER_LOW;
AnimTables[1].Anim["CROUCH_FIST_AIM_walk"] = ACT_WALK_CROUCH;

AnimTables[1].Anim["STAND_PISTOL_idle"] = ACT_IDLE;
AnimTables[1].Anim["STAND_PISTOL_walk"] = ACT_WALK;
AnimTables[1].Anim["STAND_PISTOL_run"] = "run_all_panicked";
AnimTables[1].Anim["STAND_PISTOL_jog"] = ACT_RUN;
AnimTables[1].Anim["CROUCH_PISTOL_idle"] = ACT_COVER_LOW;
AnimTables[1].Anim["CROUCH_PISTOL_walk"] = ACT_WALK_CROUCH;


AnimTables[1].Anim["STAND_PISTOL_AIM_idle"] = "Idle_SMG1_Aim_Alert";
AnimTables[1].Anim["STAND_PISTOL_AIM_walk"] = "walkAlertAimAll1";
AnimTables[1].Anim["STAND_PISTOL_AIM_run"] = "run_all_panicked";
AnimTables[1].Anim["STAND_PISTOL_AIM_jog"] = "run_alert_aiming_all";
AnimTables[1].Anim["CROUCH_PISTOL_AIM_idle"] = "crouch_aim_smg1";
AnimTables[1].Anim["CROUCH_PISTOL_AIM_walk"] = "crouch_walk_aiming_all";
 
AnimTables[1].Anim["STAND_SMG_idle"] = "Idle_relaxed_SMG1_1";
AnimTables[1].Anim["STAND_SMG_walk"] = "walk_smg1_relaxed_all";
AnimTables[1].Anim["STAND_SMG_run"] = "run_all_panicked";
AnimTables[1].Anim["STAND_SMG_jog"] = "run_smg1_relaxed_all";
AnimTables[1].Anim["CROUCH_SMG_idle"] = "Crouch_idleD";
AnimTables[1].Anim["CROUCH_SMG_walk"] = "crouch_walk_holding_all";

AnimTables[1].Anim["STAND_SMG_AIM_idle"] = "Idle_SMG1_Aim_Alert";
AnimTables[1].Anim["STAND_SMG_AIM_walk"] = "walkAlertAimAll1";
AnimTables[1].Anim["STAND_SMG_AIM_run"] = "run_all_panicked";
AnimTables[1].Anim["STAND_SMG_AIM_jog"] = "run_alert_aiming_all";
AnimTables[1].Anim["CROUCH_SMG_AIM_idle"] = "crouch_aim_smg1";
AnimTables[1].Anim["CROUCH_SMG_AIM_walk"] = "crouch_walk_aiming_all";

AnimTables[1].Anim["STAND_RIFLE_idle"] = "Idle_relaxed_Shotgun_1";
AnimTables[1].Anim["STAND_RIFLE_walk"] = "walk_smg1_relaxed_all";
AnimTables[1].Anim["STAND_RIFLE_run"] = "run_all_panicked";
AnimTables[1].Anim["STAND_RIFLE_jog"] = "run_smg1_relaxed_all";
AnimTables[1].Anim["CROUCH_RIFLE_idle"] = "Crouch_idleD";
AnimTables[1].Anim["CROUCH_RIFLE_walk"] = "crouch_walk_holding_all";

AnimTables[1].Anim["STAND_RIFLE_AIM_idle"] = "Idle_SMG1_Aim_Alert";
AnimTables[1].Anim["STAND_RIFLE_AIM_walk"] = "walkAlertAimAll1";
AnimTables[1].Anim["STAND_RIFLE_AIM_run"] = "run_all_panicked";
AnimTables[1].Anim["STAND_RIFLE_AIM_jog"] = "run_alert_aiming_all";
AnimTables[1].Anim["CROUCH_RIFLE_AIM_idle"] = "crouch_aim_smg1";
AnimTables[1].Anim["CROUCH_RIFLE_AIM_walk"] = "crouch_walk_aiming_all";

AnimTables[1].Anim["jump"] = ACT_JUMP;
AnimTables[1].Anim["vehicle"] = ACT_BUSY_SIT_CHAIR;



AnimTables[2] = { }
AnimTables[2].Models =
{
	"models/hecu01/1.mdl",
	"models/hecu01/2.mdl",
	"models/hecu01/3.mdl",
	"models/hecu01/4.mdl",
	"models/necro/hecu.mdl",
};

AnimTables[2].Anim = { }
AnimTables[2].Reload = { }
AnimTables[2].Shoot = { }

AnimTables[2].Reload["PISTOL"] = ACT_GESTURE_RELOAD_SMG1;
AnimTables[2].Reload["SMG"] = ACT_GESTURE_RELOAD_SMG1;
AnimTables[2].Reload["RIFLE"] = ACT_GESTURE_RELOAD_SMG1;
AnimTables[2].Reload["SHOTGUN"] = ACT_GESTURE_RELOAD_SMG1;
AnimTables[2].Reload["SNIPER"] = ACT_GESTURE_RELOAD_SMG1;

AnimTables[2].Shoot["PISTOL"] = ACT_GESTURE_RANGE_ATTACK_SMG1;
AnimTables[2].Shoot["SMG"] = ACT_GESTURE_RANGE_ATTACK_SMG1;
AnimTables[2].Shoot["RIFLE"] = ACT_GESTURE_RANGE_ATTACK_SMG1;
AnimTables[2].Shoot["SHOTGUN"] = ACT_GESTURE_RANGE_ATTACK_SHOTGUN;
AnimTables[2].Shoot["SNIPER"] = ACT_GESTURE_RANGE_ATTACK_SHOTGUN;

AnimTables[2].Anim["STAND_idle"] = "Idle_Unarmed";
AnimTables[2].Anim["STAND_walk"] = "WalkUnarmed_All";
AnimTables[2].Anim["STAND_run"] = "RunALL";
AnimTables[2].Anim["STAND_jog"] = "RunALL";


AnimTables[2].Anim["STAND_FIST_idle"] = "Idle_Unarmed";
AnimTables[2].Anim["STAND_FIST_walk"] = "WalkUnarmed_All";
AnimTables[2].Anim["STAND_FIST_run"] = "RunALL";
AnimTables[2].Anim["STAND_FIST_jog"] = "RunALL";
AnimTables[2].Anim["CROUCH_FIST_idle"] = "CrouchIdle";
AnimTables[2].Anim["CROUCH_FIST_walk"] = "Crouch_walkALL";

AnimTables[2].Anim["STAND_FIST_AIM_idle"] = "Idle1";
AnimTables[2].Anim["STAND_FIST_AIM_walk"] = "WalkUnarmed_All";
AnimTables[2].Anim["STAND_FIST_AIM_run"] = "RunALL";
AnimTables[2].Anim["STAND_FIST_AIM_jog"] = "RunALL";
AnimTables[2].Anim["CROUCH_FIST_AIM_idle"] = "CrouchIdle";
AnimTables[2].Anim["CROUCH_FIST_AIM_walk"] = "Crouch_walkALL";


AnimTables[2].Anim["STAND_PISTOL_idle"] = "Idle_Unarmed";
AnimTables[2].Anim["STAND_PISTOL_walk"] = "WalkUnarmed_All";
AnimTables[2].Anim["STAND_PISTOL_run"] = "RunALL";
AnimTables[2].Anim["STAND_PISTOL_jog"] = "RunALL";
AnimTables[2].Anim["CROUCH_PISTOL_idle"] = "CrouchIdle";
AnimTables[2].Anim["CROUCH_PISTOL_walk"] = "Crouch_walkALL";

AnimTables[2].Anim["STAND_PISTOL_AIM_idle"] = "CombatIdle1";
AnimTables[2].Anim["STAND_PISTOL_AIM_walk"] = "walk_aiming_all";
AnimTables[2].Anim["STAND_PISTOL_AIM_run"] = "RunALL";
AnimTables[2].Anim["STAND_PISTOL_AIM_jog"] = "RunALL";
AnimTables[2].Anim["CROUCH_PISTOL_AIM_idle"] = "CrouchIdle";
AnimTables[2].Anim["CROUCH_PISTOL_AIM_walk"] = "Crouch_walkALL";

AnimTables[2].Anim["STAND_SMG_idle"] = "Idle1";
AnimTables[2].Anim["STAND_SMG_walk"] = "WalkEasy_All";
AnimTables[2].Anim["STAND_SMG_run"] = "RunALL";
AnimTables[2].Anim["STAND_SMG_jog"] = "RunALL";
AnimTables[2].Anim["CROUCH_SMG_idle"] = "CrouchIdle";
AnimTables[2].Anim["CROUCH_SMG_walk"] = "Crouch_walkALL";

AnimTables[2].Anim["STAND_SMG_AIM_idle"] = "CombatIdle1_SMG1";
AnimTables[2].Anim["STAND_SMG_AIM_walk"] = "walk_aiming_all";
AnimTables[2].Anim["STAND_SMG_AIM_run"] = "RunALL";
AnimTables[2].Anim["STAND_SMG_AIM_jog"] = "RunAIMALL1";
AnimTables[2].Anim["CROUCH_SMG_AIM_idle"] = "CrouchIdle";
AnimTables[2].Anim["CROUCH_SMG_AIM_walk"] = "Crouch_walkALL";

AnimTables[2].Anim["STAND_RIFLE_idle"] = "Idle1";
AnimTables[2].Anim["STAND_RIFLE_walk"] = "WalkEasy_All";
AnimTables[2].Anim["STAND_RIFLE_run"] = "RunALL";
AnimTables[2].Anim["STAND_RIFLE_jog"] = "RunALL";
AnimTables[2].Anim["CROUCH_RIFLE_idle"] = "CrouchIdle";
AnimTables[2].Anim["CROUCH_RIFLE_walk"] = "Crouch_walkALL";

AnimTables[2].Anim["STAND_RIFLE_AIM_idle"] = "CombatIdle1";
AnimTables[2].Anim["STAND_RIFLE_AIM_walk"] = "walk_aiming_all";
AnimTables[2].Anim["STAND_RIFLE_AIM_run"] = "RunALL";
AnimTables[2].Anim["STAND_RIFLE_AIM_jog"] = "RunAIMALL1";
AnimTables[2].Anim["CROUCH_RIFLE_AIM_idle"] = "CrouchIdle";
AnimTables[2].Anim["CROUCH_RIFLE_AIM_walk"] = "Crouch_walkALL";


AnimTables[2].Anim["CROUCH_idle"] = "CrouchIdle";
AnimTables[2].Anim["CROUCH_walk"] = "Crouch_walkALL";

AnimTables[2].Anim["jump"] = ACT_JUMP;
AnimTables[2].Anim["vehicle"] = ACT_CROUCHIDLE;


AnimTables[3] = { };
AnimTables[3].Models =
{
	"models/rusty/Survivors/Fsurvivor1.mdl",
	"models/rusty/Survivors/Fsurvivor2.mdl",
	"models/rusty/Survivors/Fsurvivor3.mdl",
	"models/rusty/Survivors/Fsurvivor4.mdl",
	"models/rusty/Survivors/Fsurvivor6.mdl",
	"models/rusty/Survivors/Fsurvivor7.mdl",
	"models/humans/toastkn/Female_01.mdl",
	"models/humans/toastkn/Female_02.mdl",
	"models/humans/toastkn/Female_03.mdl",
	"models/humans/toastkn/Female_04.mdl",
	"models/humans/toastkn/Female_06.mdl",
	"models/humans/toastkn/Female_07.mdl",
	"models/humans/toastkn/Female_08.mdl",
	"models/humans/toastkn/Female_09.mdl",
	"models/humans/toastkn/Female_10.mdl",
	"models/humans/toastkn/Female_11.mdl",
	"models/humans/toastkn/Female_12.mdl",
	"models/humans/toastkn/Female_13.mdl",
	"models/humans/toastkn/Female_14.mdl",
	"models/humans/toastkn/Female_15.mdl",
	"models/humans/toastkn/Female_16.mdl",
	"models/humans/toastkn/Female_17.mdl",
	"models/humans/toastkn/Female_18.mdl",
	"models/Humans/Group01/clo1fe_01.mdl",
	"models/Humans/Group01/clo1fe_02.mdl",
	"models/Humans/Group01/clo1fe_03.mdl",
	"models/Humans/Group01/clo1fe_04.mdl",
	"models/Humans/Group01/clo1fe_05.mdl",
	"models/Humans/Group01/clo1fe_06.mdl",
	"models/Humans/Group01/clo1fe_07.mdl",
	"models/Humans/Group01/clo2fe_01.mdl",
	"models/Humans/Group01/clo2fe_02.mdl",
	"models/Humans/Group01/clo2fe_03.mdl",
	"models/Humans/Group01/clo2fe_04.mdl",
	"models/Humans/Group01/clo2fe_05.mdl",
	"models/Humans/Group01/clo2fe_06.mdl",
	"models/Humans/Group01/clo2fe_07.mdl",
	"models/humans/foldier/female_01.mdl",
	"models/humans/foldier/female_02.mdl",
	"models/humans/foldier/female_03.mdl",
	"models/humans/foldier/female_04.mdl",
	"models/humans/foldier/female_06.mdl",
	"models/humans/foldier/female_07.mdl",
	"models/humans/Group01/female_01.mdl",
	"models/humans/Group01/female_02.mdl",
	"models/humans/Group01/female_03.mdl",
	"models/humans/Group01/female_04.mdl",
	"models/humans/Group01/female_06.mdl",
	"models/humans/Group01/female_07.mdl",
	"models/humans/necropolis/bandit_fem_1.mdl",
	"models/humans/necropolis/bandit_fem_2.mdl",
	"models/humans/necropolis/syntax.mdl",

};

AnimTables[3].Anim = { }
AnimTables[3].Reload = { }
AnimTables[3].Shoot = { }

AnimTables[3].Reload["PISTOL"] = ACT_GESTURE_RELOAD_SMG1;
AnimTables[3].Reload["SMG"] = ACT_GESTURE_RELOAD_SMG1;
AnimTables[3].Reload["RIFLE"] = ACT_GESTURE_RELOAD_SMG1;
AnimTables[3].Reload["SHOTGUN"] = ACT_GESTURE_RELOAD_SMG1;
AnimTables[3].Reload["SNIPER"] = ACT_GESTURE_RELOAD_SMG1;

AnimTables[3].Shoot["PISTOL"] = ACT_GESTURE_RANGE_ATTACK_PISTOL;
AnimTables[3].Shoot["SMG"] = ACT_GESTURE_RANGE_ATTACK_SMG1;
AnimTables[3].Shoot["RIFLE"] = ACT_GESTURE_RANGE_ATTACK_SMG1;
AnimTables[3].Shoot["SHOTGUN"] = ACT_GESTURE_RANGE_ATTACK_SHOTGUN;
AnimTables[3].Shoot["SNIPER"] = ACT_GESTURE_RANGE_ATTACK_SHOTGUN;

AnimTables[3].Anim["STAND_idle"] = ACT_IDLE;
AnimTables[3].Anim["STAND_walk"] = ACT_WALK;
AnimTables[3].Anim["STAND_run"] = "run_panicked3__all";
AnimTables[3].Anim["STAND_jog"] = ACT_RUN;

AnimTables[3].Anim["CROUCH_idle"] = ACT_COVER_LOW;
AnimTables[3].Anim["CROUCH_walk"] = ACT_WALK_CROUCH;

AnimTables[3].Anim["STAND_FIST_idle"] = ACT_IDLE;
AnimTables[3].Anim["STAND_FIST_walk"] = ACT_WALK;
AnimTables[3].Anim["STAND_FIST_run"] = "run_panicked3__all";
AnimTables[3].Anim["STAND_FIST_jog"] = ACT_RUN;
AnimTables[3].Anim["CROUCH_FIST_idle"] = ACT_COVER_LOW;
AnimTables[3].Anim["CROUCH_FIST_walk"] = ACT_WALK_CROUCH;

AnimTables[3].Anim["STAND_FIST_AIM_idle"] = ACT_IDLE;
AnimTables[3].Anim["STAND_FIST_AIM_walk"] = ACT_WALK;
AnimTables[3].Anim["STAND_FIST_AIM_run"] = "run_panicked3__all";
AnimTables[3].Anim["STAND_FIST_AIM_jog"] = ACT_RUN;
AnimTables[3].Anim["CROUCH_FIST_AIM_idle"] = ACT_COVER_LOW;
AnimTables[3].Anim["CROUCH_FIST_AIM_walk"] = ACT_WALK_CROUCH;

AnimTables[3].Anim["STAND_PISTOL_idle"] = ACT_IDLE;
AnimTables[3].Anim["STAND_PISTOL_walk"] = ACT_WALK;
AnimTables[3].Anim["STAND_PISTOL_run"] = "run_panicked3__all";
AnimTables[3].Anim["STAND_PISTOL_jog"] = ACT_RUN;
AnimTables[3].Anim["CROUCH_PISTOL_idle"] = ACT_COVER_LOW;
AnimTables[3].Anim["CROUCH_PISTOL_walk"] = ACT_WALK_CROUCH;


AnimTables[3].Anim["STAND_PISTOL_AIM_idle"] = "Pistol_idle_aim";
AnimTables[3].Anim["STAND_PISTOL_AIM_walk"] = "walk_aiming_p_all";
AnimTables[3].Anim["STAND_PISTOL_AIM_jog"] = "run_aiming_p_all";
AnimTables[3].Anim["STAND_PISTOL_AIM_run"] = "run_panicked3__all";
AnimTables[3].Anim["CROUCH_PISTOL_AIM_idle"] = "crouch_aim_smg1";
AnimTables[3].Anim["CROUCH_PISTOL_AIM_walk"] = "Crouch_walk_aiming_all";
 
AnimTables[3].Anim["STAND_SMG_idle"] = "idle_alert_smg1_6";
AnimTables[3].Anim["STAND_SMG_walk"] = "walk_smg1_relaxed_all";
AnimTables[3].Anim["STAND_SMG_run"] = "run_panicked3__all";
AnimTables[3].Anim["STAND_SMG_jog"] = "run_smg1_relaxed_all";
AnimTables[3].Anim["CROUCH_SMG_idle"] = "crouch_idleD";
AnimTables[3].Anim["CROUCH_SMG_walk"] = "crouch_walk_holding_all";

AnimTables[3].Anim["STAND_SMG_AIM_idle"] = "idle_smg1_aim_alert";
AnimTables[3].Anim["STAND_SMG_AIM_walk"] = "walkalertaimall1";
AnimTables[3].Anim["STAND_SMG_AIM_run"] = "run_panicked3__all";
AnimTables[3].Anim["STAND_SMG_AIM_jog"] = "run_alert_aiming_all";
AnimTables[3].Anim["CROUCH_SMG_AIM_idle"] = "crouch_aim_smg1";
AnimTables[3].Anim["CROUCH_SMG_AIM_walk"] = "Crouch_walk_aiming_all";

AnimTables[3].Anim["STAND_RIFLE_idle"] = "idle_relaxed_shotgun_1";
AnimTables[3].Anim["STAND_RIFLE_walk"] = "walk_smg1_relaxed_all";
AnimTables[3].Anim["STAND_RIFLE_run"] = "run_panicked3__all";
AnimTables[3].Anim["STAND_RIFLE_jog"] = "run_smg1_relaxed_all";
AnimTables[3].Anim["CROUCH_RIFLE_idle"] = "crouch_idleD";
AnimTables[3].Anim["CROUCH_RIFLE_walk"] = "crouch_walk_holding_all";

AnimTables[3].Anim["STAND_RIFLE_AIM_idle"] = "idle_smg1_aim_alert";
AnimTables[3].Anim["STAND_RIFLE_AIM_walk"] = "walkalertaimall1";
AnimTables[3].Anim["STAND_RIFLE_AIM_run"] = "run_panicked3__all";
AnimTables[3].Anim["STAND_RIFLE_AIM_jog"] = "run_alert_aiming_all";
AnimTables[3].Anim["CROUCH_RIFLE_AIM_idle"] = "crouch_aim_smg1";
AnimTables[3].Anim["CROUCH_RIFLE_AIM_walk"] = "Crouch_walk_aiming_all";

AnimTables[3].Anim["jump"] = ACT_JUMP;
AnimTables[3].Anim["vehicle"] = ACT_BUSY_SIT_CHAIR;


AnimTables[4] = { };
AnimTables[4].Models =
{
	"models/infected/necropolis/hunter.mdl",
	"models/infected/necropolis/hunter2.mdl",
	"models/infected/necropolis/smoker.mdl",
	"models/infected/necropolis/smoker2.mdl",
	"models/infected/necropolis/smoker3.mdl",
	"models/infected/necropolis/smoker4.mdl",
	"models/infected/necropolis/witch.mdl",
	"models/infected/necropolis/femhunter1.mdl",
	"models/infected/necropolis/femhunter2.mdl",
	"models/infected/necropolis/common/female_01.mdl",
	"models/infected/necropolis/common/female_02.mdl",
	"models/infected/necropolis/common/female_03.mdl",
	"models/infected/necropolis/common/female_04.mdl",
	"models/infected/necropolis/common/female_06.mdl",
	"models/infected/necropolis/common/female_07.mdl",
	"models/infected/necropolis/common/male_01.mdl",
	"models/infected/necropolis/common/male_02.mdl",
	"models/infected/necropolis/common/male_03.mdl",
	"models/infected/necropolis/common/male_04.mdl",
	"models/infected/necropolis/common/male_05.mdl",
	"models/infected/necropolis/common/male_06.mdl",
	"models/infected/necropolis/common/male_07.mdl",
	"models/infected/necropolis/common/male_08.mdl",
	"models/infected/necropolis/common/male_12.mdl",
	"models/infected/necropolis/common/male_13.mdl",
	"models/infected/necropolis/common/male_14.mdl",
	"models/infected/necropolis/common/male_15.mdl",
	"models/infected/necropolis/common/male_16.mdl",
	"models/infected/necropolis/common/male_17.mdl",
	"models/infected/necropolis/common/male_18.mdl",
	"models/infected/necropolis/common/male_19.mdl",
	
};

AnimTables[4]._NOWEPS = true;
AnimTables[4].Anim = { }

AnimTables[4].Anim["STAND_idle"] = ACT_IDLE;
AnimTables[4].Anim["STAND_walk"] = "walk_panicked_all";
AnimTables[4].Anim["STAND_run"] = "sprint_all";
AnimTables[4].Anim["STAND_jog"] = ACT_RUN;

AnimTables[4].Anim["CROUCH_idle"] = ACT_COVER_LOW;
AnimTables[4].Anim["CROUCH_walk"] = ACT_WALK_CROUCH;

AnimTables[4].Anim["jump"] = ACT_JUMP;

AnimTables[5] = { }
AnimTables[5].Models =
{
	"models/Zombie/Classic.mdl",
};

AnimTables[5]._NOWEPS = true;
AnimTables[5].Anim = { }

AnimTables[5].Anim["STAND_idle"] = ACT_IDLE;
AnimTables[5].Anim["STAND_walk"] = "walk4";
AnimTables[5].Anim["STAND_run"] = "walk4";
AnimTables[5].Anim["STAND_jog"] = "walk4";

AnimTables[5].Anim["CROUCH_idle"] = ACT_IDLE;
AnimTables[5].Anim["CROUCH_walk"] = "walk4";

AnimTables[5].Anim["jump"] = ACT_IDLE;

AnimTables[6] = { }
AnimTables[6].Models =
{
	"models/infected/necropolis/bloodsucker1.mdl",
	"models/infected/necropolis/bloodsucker2.mdl",
	"models/infected/necropolis/snork.mdl",
};

AnimTables[6]._NOWEPS = true;
AnimTables[6].Anim = { }

AnimTables[6].Anim["STAND_idle"] = ACT_IDLE;
AnimTables[6].Anim["STAND_walk"] = ACT_WALK;
AnimTables[6].Anim["STAND_run"] = ACT_RUN;
AnimTables[6].Anim["STAND_jog"] = ACT_RUN;

AnimTables[6].Anim["CROUCH_idle"] = ACT_IDLE;
AnimTables[6].Anim["CROUCH_walk"] = ACT_WALK;

AnimTables[6].Anim["jump"] = ACT_JUMP;

AnimTables[7] = { }
AnimTables[7].Models =
{
	"models/infected/necropolis/gigante.mdl",
};

AnimTables[7]._NOWEPS = true;
AnimTables[7].Anim = { }

AnimTables[7].Anim["STAND_idle"] = ACT_IDLE;
AnimTables[7].Anim["STAND_walk"] = ACT_WALK;
AnimTables[7].Anim["STAND_run"] = ACT_RUN;
AnimTables[7].Anim["STAND_jog"] = ACT_RUN;

AnimTables[7].Anim["CROUCH_idle"] = ACT_CROUCH;
AnimTables[7].Anim["CROUCH_walk"] = ACT_WALK_CROUCH;

AnimTables[7].Anim["jump"] = ACT_IDLE;

AnimTables[8] = { }
AnimTables[8].Models =
{
	"models/infected/necropolis/cyclops.mdl",
};

AnimTables[8]._NOWEPS = true;
AnimTables[8].Anim = { }

AnimTables[8].Anim["STAND_idle"] = ACT_IDLE;
AnimTables[8].Anim["STAND_walk"] = ACT_WALK;
AnimTables[8].Anim["STAND_run"] = ACT_RUN;
AnimTables[8].Anim["STAND_jog"] = ACT_RUN;

AnimTables[8].Anim["CROUCH_idle"] = ACT_IDLE;
AnimTables[8].Anim["CROUCH_walk"] = ACT_WALK;

AnimTables[8].Anim["jump"] = ACT_IDLE;

AnimTables[9] = { }
AnimTables[9].Models =
{
	"models/infected/necropolis/boomer.mdl",
	"models/infected/necropolis/boomer2.mdl",
	"models/infected/necropolis/boomette.mdl",
};

AnimTables[9]._NOWEPS = true;
AnimTables[9].Anim = { }

AnimTables[9].Anim["STAND_idle"] = ACT_IDLE;
AnimTables[9].Anim["STAND_walk"] = ACT_WALK;
AnimTables[9].Anim["STAND_run"] = ACT_RUN;
AnimTables[9].Anim["STAND_jog"] = ACT_RUN;

AnimTables[9].Anim["CROUCH_idle"] = ACT_IDLE;
AnimTables[9].Anim["CROUCH_walk"] = ACT_WALK;

AnimTables[9].Anim["jump"] = ACT_IDLE;

AnimTables[10] = { }
AnimTables[10].Models =
{
	"models/infected/necropolis/failure.mdl",
};

AnimTables[10]._NOWEPS = true;
AnimTables[10].Anim = { }

AnimTables[10].Anim["STAND_idle"] = ACT_IDLE;
AnimTables[10].Anim["STAND_walk"] = ACT_WALK;
AnimTables[10].Anim["STAND_run"] = ACT_WALK;
AnimTables[10].Anim["STAND_jog"] = ACT_WALK;

AnimTables[10].Anim["CROUCH_idle"] = ACT_IDLE;
AnimTables[10].Anim["CROUCH_walk"] = ACT_WALK;

AnimTables[10].Anim["jump"] = ACT_IDLE;

AnimTables[11] = { }
AnimTables[11].Models =
{
	"models/infected/necropolis/charger.mdl",
};

AnimTables[11]._NOWEPS = true;
AnimTables[11].Anim = { }

AnimTables[11].Anim["STAND_idle"] = ACT_IDLE;
AnimTables[11].Anim["STAND_walk"] = ACT_RUN;
AnimTables[11].Anim["STAND_run"] = 87;
AnimTables[11].Anim["STAND_jog"] = ACT_RUN;

AnimTables[11].Anim["CROUCH_idle"] = "crouchidle";
AnimTables[11].Anim["CROUCH_walk"] = ACT_RUN;

AnimTables[11].Anim["jump"] = ACT_IDLE;

AnimTables[12] = { }
AnimTables[12].Models =
{
	"models/infected/necropolis/spitter.mdl",
};

AnimTables[12]._NOWEPS = true;
AnimTables[12].Anim = { }

AnimTables[12].Anim["STAND_idle"] = ACT_IDLE;
AnimTables[12].Anim["STAND_walk"] = ACT_WALK;
AnimTables[12].Anim["STAND_run"] = ACT_WALK;
AnimTables[12].Anim["STAND_jog"] = ACT_WALK;

AnimTables[12].Anim["CROUCH_idle"] = ACT_IDLE;
AnimTables[12].Anim["CROUCH_walk"] = ACT_WALK;

AnimTables[12].Anim["jump"] = ACT_IDLE;

AnimTables[13] = { }
AnimTables[13].Models =
{
	"models/Zombie/Classic_torso.mdl",
	"models/Zombie/fast_torso.mdl",
};

AnimTables[13]._NOWEPS = true;
AnimTables[13].Anim = { }

AnimTables[13].Anim["STAND_idle"] = ACT_IDLE;
AnimTables[13].Anim["STAND_walk"] = ACT_WALK;
AnimTables[13].Anim["STAND_run"] = ACT_WALK;
AnimTables[13].Anim["STAND_jog"] = ACT_WALK;

AnimTables[13].Anim["CROUCH_idle"] = ACT_IDLE;
AnimTables[13].Anim["CROUCH_walk"] = ACT_WALK;

AnimTables[13].Anim["jump"] = ACT_IDLE;

AnimTables[14] = { }
AnimTables[14].Models =
{
	"models/player/chell.mdl",
};

AnimTables[14].Anim = { }

AnimTables[14].Anim["STAND_idle"] = "Idle";
AnimTables[14].Anim["STAND_walk"] = "Run";
AnimTables[14].Anim["STAND_run"] = "Run";
AnimTables[14].Anim["STAND_jog"] = "Run";

AnimTables[14].Anim["CROUCH_idle"] = "CrouchIdle";
AnimTables[14].Anim["CROUCH_walk"] = "CrouchWalk";

AnimTables[14].Anim["STAND_FIST_idle"] = "Idle";
AnimTables[14].Anim["STAND_FIST_walk"] = "Run";
AnimTables[14].Anim["STAND_FIST_run"] = "Run";
AnimTables[14].Anim["STAND_FIST_jog"] = "Run";
AnimTables[14].Anim["CROUCH_FIST_idle"] = "CrouchIdle";
AnimTables[14].Anim["CROUCH_FIST_walk"] = "CrouchWalk";

AnimTables[14].Anim["STAND_FIST_AIM_idle"] = "Idle";
AnimTables[14].Anim["STAND_FIST_AIM_walk"] = "Run";
AnimTables[14].Anim["STAND_FIST_AIM_run"] = "Run";
AnimTables[14].Anim["STAND_FIST_AIM_jog"] = "Run";
AnimTables[14].Anim["CROUCH_FIST_AIM_idle"] = "CrouchIdle";
AnimTables[14].Anim["CROUCH_FIST_AIM_walk"] = "CrouchWalk";

AnimTables[14].Anim["STAND_PISTOL_idle"] = "Idle";
AnimTables[14].Anim["STAND_PISTOL_walk"] = "Run";
AnimTables[14].Anim["STAND_PISTOL_run"] = "Run";
AnimTables[14].Anim["STAND_PISTOL_jog"] = "Run";
AnimTables[14].Anim["CROUCH_PISTOL_idle"] = "CrouchIdle";
AnimTables[14].Anim["CROUCH_PISTOL_walk"] = "CrouchWalk";


AnimTables[14].Anim["STAND_PISTOL_AIM_idle"] = "Idle";
AnimTables[14].Anim["STAND_PISTOL_AIM_walk"] = "Run";
AnimTables[14].Anim["STAND_PISTOL_AIM_jog"] = "Run";
AnimTables[14].Anim["STAND_PISTOL_AIM_run"] = "Run";
AnimTables[14].Anim["CROUCH_PISTOL_AIM_idle"] = "CrouchIdle";
AnimTables[14].Anim["CROUCH_PISTOL_AIM_walk"] = "CrouchWalk";
 
AnimTables[14].Anim["STAND_SMG_idle"] = "Idle_PORTALGUN";
AnimTables[14].Anim["STAND_SMG_walk"] = "Run_portalgun";
AnimTables[14].Anim["STAND_SMG_run"] = "Run_portalgun";
AnimTables[14].Anim["STAND_SMG_jog"] = "Run_portalgun";
AnimTables[14].Anim["CROUCH_SMG_idle"] = "idlecrouch_portalgun";
AnimTables[14].Anim["CROUCH_SMG_walk"] = "crouch_walk_portalgun";

AnimTables[14].Anim["STAND_SMG_AIM_idle"] = "Idle_PORTALGUN";
AnimTables[14].Anim["STAND_SMG_AIM_walk"] = "Run_portalgun";
AnimTables[14].Anim["STAND_SMG_AIM_run"] = "Run_portalgun";
AnimTables[14].Anim["STAND_SMG_AIM_jog"] = "Run_portalgun";
AnimTables[14].Anim["CROUCH_SMG_AIM_idle"] = "idlecrouch_portalgun";
AnimTables[14].Anim["CROUCH_SMG_AIM_walk"] = "crouch_walk_portalgun";

AnimTables[14].Anim["STAND_RIFLE_idle"] = "Idle_PORTALGUN";
AnimTables[14].Anim["STAND_RIFLE_walk"] = "Run_portalgun";
AnimTables[14].Anim["STAND_RIFLE_run"] = "Run_portalgun";
AnimTables[14].Anim["STAND_RIFLE_jog"] = "Run_portalgun";
AnimTables[14].Anim["CROUCH_RIFLE_idle"] = "idlecrouch_portalgun";
AnimTables[14].Anim["CROUCH_RIFLE_walk"] = "crouch_walk_portalgun";

AnimTables[14].Anim["STAND_RIFLE_AIM_idle"] = "Idle_PORTALGUN";
AnimTables[14].Anim["STAND_RIFLE_AIM_walk"] = "Run_portalgun";
AnimTables[14].Anim["STAND_RIFLE_AIM_run"] = "Run_portalgun";
AnimTables[14].Anim["STAND_RIFLE_AIM_jog"] = "Run_portalgun";
AnimTables[14].Anim["CROUCH_RIFLE_AIM_idle"] = "idlecrouch_portalgun";
AnimTables[14].Anim["CROUCH_RIFLE_AIM_walk"] = "crouch_walk_portalgun";

AnimTables[14].Anim["jump"] = "standing_jump";
AnimTables[14].Anim["vehicle"] = "CrouchIdle";

AnimTables[15] = { }
AnimTables[15].Models =
{
	"models/infected/boomer.mdl",
	"models/infected/boomette.mdl",
	"models/infected/hunter.mdl",
	"models/infected/smoker.mdl",
	"models/infected/jockey.mdl",
	"models/infected/spitter.mdl",
	"models/infected/charger.mdl",
};

AnimTables[15]._NOWEPS = true;
AnimTables[15].Anim = { }

AnimTables[15].Anim["STAND_idle"] = ACT_IDLE;
AnimTables[15].Anim["STAND_walk"] = ACT_WALK;
AnimTables[15].Anim["STAND_run"] = ACT_RUN;
AnimTables[15].Anim["STAND_jog"] = ACT_RUN;

AnimTables[15].Anim["CROUCH_idle"] = ACT_CROUCHIDLE;
AnimTables[15].Anim["CROUCH_walk"] = ACT_RUN_CROUCH;

AnimTables[15].Anim["jump"] = ACT_JUMP;

AnimTables[16] = { }
AnimTables[16].Models =
{
	"models/infected/hulk.mdl",
};

AnimTables[16]._NOWEPS = true;
AnimTables[16].Anim = { }

AnimTables[16].Anim["STAND_idle"] = "Idle";
AnimTables[16].Anim["STAND_walk"] = ACT_WALK;
AnimTables[16].Anim["STAND_run"] = "Run_1";
AnimTables[16].Anim["STAND_jog"] = "Run_1";

AnimTables[16].Anim["CROUCH_idle"] = ACT_CROUCHIDLE;
AnimTables[16].Anim["CROUCH_walk"] = ACT_RUN_CROUCH;

AnimTables[16].Anim["jump"] = ACT_JUMP;

AnimTables[17] = { }
AnimTables[17].Models =
{
	"models/infected/witch.mdl",
};

AnimTables[17]._NOWEPS = true;
AnimTables[17].Anim = { }

AnimTables[17].Anim["STAND_idle"] = "Idle_Standing";
AnimTables[17].Anim["STAND_walk"] = "Run";
AnimTables[17].Anim["STAND_run"] = "Run";
AnimTables[17].Anim["STAND_jog"] = "Run";

AnimTables[17].Anim["CROUCH_idle"] = "Idle_Sitting";
AnimTables[17].Anim["CROUCH_walk"] = "CrouchWalk_03";

AnimTables[17].Anim["jump"] = ACT_TERROR_JUMP;


AnimTables[18] = { }
AnimTables[18].Models =
{
	"models/infected/necropolis/feralghoul.mdl",
	"models/infected/necropolis/armorghoul.mdl",
};

AnimTables[18]._NOWEPS = true;
AnimTables[18].Anim = { }

AnimTables[18].Anim["STAND_idle"] = "idle";
AnimTables[18].Anim["STAND_walk"] = "walk_all";
AnimTables[18].Anim["STAND_run"] = "run_all";
AnimTables[18].Anim["STAND_jog"] = "run_all";

AnimTables[18].Anim["CROUCH_idle"] = "crouchidle";
AnimTables[18].Anim["CROUCH_walk"] = "walk_all";


AnimTables[19] = { }
AnimTables[19].Models =
{
	"models/police.mdl",
	"models/humans/necropolis/cultist.mdl",
};

AnimTables[19].Anim = { }
AnimTables[19].Reload = { };
AnimTables[19].Shoot = { };

AnimTables[19].Reload["PISTOL"] = ACT_GESTURE_RELOAD_PISTOL;
AnimTables[19].Reload["SMG"] = ACT_GESTURE_RELOAD_SMG1;
AnimTables[19].Reload["RIFLE"] = ACT_GESTURE_RELOAD_SMG1;
AnimTables[19].Reload["SHOTGUN"] = ACT_GESTURE_RELOAD_SMG1;
AnimTables[19].Reload["SNIPER"] = ACT_GESTURE_RELOAD_SMG1;

AnimTables[19].Shoot["PISTOL"] = ACT_GESTURE_RANGE_ATTACK_PISTOL;
AnimTables[19].Shoot["SMG"] = ACT_GESTURE_RANGE_ATTACK_SMG1;
AnimTables[19].Shoot["RIFLE"] = ACT_GESTURE_RANGE_ATTACK_SMG1;
AnimTables[19].Shoot["SHOTGUN"] = ACT_GESTURE_RANGE_ATTACK_PISTOL;
AnimTables[19].Shoot["SNIPER"] = ACT_GESTURE_RANGE_ATTACK_PISTOL;

AnimTables[19].Anim["STAND_idle"] = ACT_IDLE;
AnimTables[19].Anim["STAND_walk"] = ACT_WALK;
AnimTables[19].Anim["STAND_run"] = ACT_RUN;
AnimTables[19].Anim["STAND_jog"] = ACT_RUN;

AnimTables[19].Anim["CROUCH_idle"] = ACT_COVER_PISTOL_LOW;
AnimTables[19].Anim["CROUCH_walk"] = ACT_WALK_CROUCH;

AnimTables[19].Anim["STAND_FIST_idle"] = ACT_IDLE;
AnimTables[19].Anim["STAND_FIST_walk"] = ACT_WALK;
AnimTables[19].Anim["STAND_FIST_run"] = ACT_RUN;
AnimTables[19].Anim["STAND_FIST_jog"] = ACT_RUN;
AnimTables[19].Anim["CROUCH_FIST_idle"] = ACT_COVER_PISTOL_LOW;
AnimTables[19].Anim["CROUCH_FIST_walk"] = ACT_WALK_CROUCH;

AnimTables[19].Anim["STAND_FIST_AIM_idle"] = ACT_IDLE_ANGRY_MELEE;
AnimTables[19].Anim["STAND_FIST_AIM_walk"] = ACT_WALK_ANGRY;
AnimTables[19].Anim["STAND_FIST_AIM_run"] = ACT_RUN;
AnimTables[19].Anim["STAND_FIST_AIM_jog"] = ACT_RUN;
AnimTables[19].Anim["CROUCH_FIST_AIM_idle"] = ACT_COVER_PISTOL_LOW;
AnimTables[19].Anim["CROUCH_FIST_AIM_walk"] = ACT_WALK_CROUCH;

AnimTables[19].Anim["STAND_PISTOL_idle"] = ACT_IDLE_PISTOL;
AnimTables[19].Anim["STAND_PISTOL_walk"] = ACT_WALK;
AnimTables[19].Anim["STAND_PISTOL_run"] = ACT_RUN;
AnimTables[19].Anim["STAND_PISTOL_jog"] = ACT_RUN;
AnimTables[19].Anim["CROUCH_PISTOL_idle"] = ACT_COVER_PISTOL_LOW;
AnimTables[19].Anim["CROUCH_PISTOL_walk"] = ACT_WALK_CROUCH;


AnimTables[19].Anim["STAND_PISTOL_AIM_idle"] = ACT_IDLE_ANGRY_PISTOL;
AnimTables[19].Anim["STAND_PISTOL_AIM_walk"] = ACT_WALK_AIM_PISTOL;
AnimTables[19].Anim["STAND_PISTOL_AIM_jog"] = ACT_RUN_AIM_PISTOL;
AnimTables[19].Anim["STAND_PISTOL_AIM_run"] = ACT_RUN_AIM_PISTOL;
AnimTables[19].Anim["CROUCH_PISTOL_AIM_idle"] = ACT_COVER_PISTOL_LOW;
AnimTables[19].Anim["CROUCH_PISTOL_AIM_walk"] = ACT_WALK_CROUCH;
 
AnimTables[19].Anim["STAND_SMG_idle"] = ACT_IDLE_SMG1;
AnimTables[19].Anim["STAND_SMG_walk"] = ACT_WALK_RIFLE;
AnimTables[19].Anim["STAND_SMG_run"] = ACT_RUN_RIFLE;
AnimTables[19].Anim["STAND_SMG_jog"] = ACT_RUN_RIFLE;
AnimTables[19].Anim["CROUCH_SMG_idle"] = ACT_COVER_SMG1_LOW;
AnimTables[19].Anim["CROUCH_SMG_walk"] = ACT_WALK_CROUCH;

AnimTables[19].Anim["STAND_SMG_AIM_idle"] = ACT_IDLE_ANGRY_SMG1;
AnimTables[19].Anim["STAND_SMG_AIM_walk"] = ACT_WALK_AIM_RIFLE;
AnimTables[19].Anim["STAND_SMG_AIM_run"] = ACT_RUN_AIM_RIFLE;
AnimTables[19].Anim["STAND_SMG_AIM_jog"] = ACT_RUN_AIM_RIFLE;
AnimTables[19].Anim["CROUCH_SMG_AIM_idle"] = ACT_COVER_SMG1_LOW;
AnimTables[19].Anim["CROUCH_SMG_AIM_walk"] = ACT_WALK_CROUCH;

AnimTables[19].Anim["STAND_RIFLE_idle"] = ACT_IDLE_SMG1;
AnimTables[19].Anim["STAND_RIFLE_walk"] = ACT_WALK_RIFLE;
AnimTables[19].Anim["STAND_RIFLE_run"] = ACT_RUN_RIFLE;
AnimTables[19].Anim["STAND_RIFLE_jog"] = ACT_RUN_RIFLE;
AnimTables[19].Anim["CROUCH_RIFLE_idle"] = ACT_COVER_SMG1_LOW;
AnimTables[19].Anim["CROUCH_RIFLE_walk"] = ACT_WALK_CROUCH;

AnimTables[19].Anim["STAND_RIFLE_AIM_idle"] = ACT_IDLE_ANGRY_SMG1;
AnimTables[19].Anim["STAND_RIFLE_AIM_walk"] = ACT_WALK_AIM_RIFLE;
AnimTables[19].Anim["STAND_RIFLE_AIM_run"] = ACT_RUN_AIM_RIFLE;
AnimTables[19].Anim["STAND_RIFLE_AIM_jog"] = ACT_RUN_AIM_RIFLE;
AnimTables[19].Anim["CROUCH_RIFLE_AIM_idle"] = ACT_COVER_SMG1_LOW;
AnimTables[19].Anim["CROUCH_RIFLE_AIM_walk"] = ACT_WALK_CROUCH;

AnimTables[19].Anim["jump"] = 27;


AnimTables[20] = { }
AnimTables[20].Models =
{
	"models/zombie/zombie_soldier.mdl",
	"models/infected/necropolis/fat.mdl",
};

AnimTables[20]._NOWEPS = true;
AnimTables[20].Anim = { }

AnimTables[20].Anim["STAND_idle"] = "Idle01";
AnimTables[20].Anim["STAND_walk"] = ACT_WALK;
AnimTables[20].Anim["STAND_run"] = ACT_RUN;
AnimTables[20].Anim["STAND_jog"] = ACT_RUN;

AnimTables[20].Anim["CROUCH_idle"] = ACT_COVER_LOW;
AnimTables[20].Anim["CROUCH_walk"] = ACT_WALK_CROUCH;

AnimTables[20].Anim["jump"] = 27;


AnimTables[21] = { }
AnimTables[21].Models =
{
	"models/survivors/survivor_manager.mdl",
	"models/survivors/survivor_biker.mdl",
	"models/survivors/survivor_namvet.mdl",
	"models/survivors/survivor_teenangst.mdl",
};

AnimTables[21].Anim = { }

AnimTables[21].Reload = { };

AnimTables[21].Reload["PISTOL"] = ACT_RELOAD_PISTOL;

AnimTables[21].Anim["STAND_idle"] = "Idle_Calm_Elites";
AnimTables[21].Anim["STAND_walk"] = "CalmWalk_Elites";
AnimTables[21].Anim["STAND_run"] = "CalmRun_Elites";
AnimTables[21].Anim["STAND_jog"] = "CalmRun_Elites";
AnimTables[21].Anim["CROUCH_idle"] = "Idle_Crouching_Elites";
AnimTables[21].Anim["CROUCH_walk"] = "CrouchWalk_Elites";

AnimTables[21].Anim["STAND_FIST_idle"] = "Idle_Calm_Elites";
AnimTables[21].Anim["STAND_FIST_walk"] = "CalmWalk_Elites";
AnimTables[21].Anim["STAND_FIST_run"] = "CalmRun_Elites";
AnimTables[21].Anim["STAND_FIST_jog"] = "CalmRun_Elites";
AnimTables[21].Anim["CROUCH_FIST_idle"] = "Idle_Crouching_Elites";
AnimTables[21].Anim["CROUCH_FIST_walk"] = "CrouchWalk_Elites";

AnimTables[21].Anim["STAND_FIST_AIM_idle"] = "Idle_Standing_o2";
AnimTables[21].Anim["STAND_FIST_AIM_walk"] = "Walk_O2";
AnimTables[21].Anim["STAND_FIST_AIM_run"] = "Run_O2";
AnimTables[21].Anim["STAND_FIST_AIM_jog"] = "Run_O2";
AnimTables[21].Anim["CROUCH_FIST_AIM_idle"] = "Idle_Crouching_O2";
AnimTables[21].Anim["CROUCH_FIST_AIM_walk"] = "Crouchwalk_O2";

AnimTables[21].Anim["STAND_PISTOL_idle"] = "Idle_Calm_Pistol";
AnimTables[21].Anim["STAND_PISTOL_walk"] = "CalmWalk_Pistol";
AnimTables[21].Anim["STAND_PISTOL_run"] = "CalmRun_Pistol";
AnimTables[21].Anim["STAND_PISTOL_jog"] = "CalmRun_Pistol";
AnimTables[21].Anim["CROUCH_PISTOL_idle"] = "Idle_Crouching_Pistol";
AnimTables[21].Anim["CROUCH_PISTOL_walk"] = "CrouchWalk_Pistol";


AnimTables[21].Anim["STAND_PISTOL_AIM_idle"] = "Idle_Standing_Pistol";
AnimTables[21].Anim["STAND_PISTOL_AIM_walk"] = "Walk_pistol";
AnimTables[21].Anim["STAND_PISTOL_AIM_jog"] = "Run_Pistol";
AnimTables[21].Anim["STAND_PISTOL_AIM_run"] = "Run_Pistol";
AnimTables[21].Anim["CROUCH_PISTOL_AIM_idle"] = "Idle_Crouching_Pistol";
AnimTables[21].Anim["CROUCH_PISTOL_AIM_walk"] = "CrouchWalk_Pistol";
 
AnimTables[21].Anim["STAND_SMG_idle"] = "Idle_Calm_SMG";
AnimTables[21].Anim["STAND_SMG_walk"] = "CalmWalk_SMG";
AnimTables[21].Anim["STAND_SMG_run"] = "CalmRun_SMG";
AnimTables[21].Anim["STAND_SMG_jog"] = "CalmRun_SMG";
AnimTables[21].Anim["CROUCH_SMG_idle"] = "Idle_Crouching_SMG";
AnimTables[21].Anim["CROUCH_SMG_walk"] = "CrouchWalk_SMG";

AnimTables[21].Anim["STAND_SMG_AIM_idle"] = "Idle_Standing_SMG";
AnimTables[21].Anim["STAND_SMG_AIM_walk"] = "Walk_SMG";
AnimTables[21].Anim["STAND_SMG_AIM_run"] = "Run_SMG";
AnimTables[21].Anim["STAND_SMG_AIM_jog"] = "Run_SMG";
AnimTables[21].Anim["CROUCH_SMG_AIM_idle"] = "Idle_Crouching_SMG";
AnimTables[21].Anim["CROUCH_SMG_AIM_walk"] = "CrouchWalk_SMG";

AnimTables[21].Anim["STAND_RIFLE_idle"] = "Idle_Calm_rifle";
AnimTables[21].Anim["STAND_RIFLE_walk"] = "CalmWalk_rifle";
AnimTables[21].Anim["STAND_RIFLE_run"] = "CalmRun_rifle";
AnimTables[21].Anim["STAND_RIFLE_jog"] = "CalmRun_rifle";
AnimTables[21].Anim["CROUCH_RIFLE_idle"] = "Idle_Crouching_rifle";
AnimTables[21].Anim["CROUCH_RIFLE_walk"] = "CrouchWalk_rifle";

AnimTables[21].Anim["STAND_RIFLE_AIM_idle"] = "Idle_Standing_rifle";
AnimTables[21].Anim["STAND_RIFLE_AIM_walk"] = "Walk_rifle";
AnimTables[21].Anim["STAND_RIFLE_AIM_run"] = "Run_rifle";
AnimTables[21].Anim["STAND_RIFLE_AIM_jog"] = "Run_rifle";
AnimTables[21].Anim["CROUCH_RIFLE_AIM_idle"] = "Idle_Crouching_rifle";
AnimTables[21].Anim["CROUCH_RIFLE_AIM_walk"] = "CrouchWalk_rifle";

AnimTables[21].Anim["jump"] = "Jump_SMG_02";

AnimTables[22] = { }
AnimTables[22].Models =
{
	"models/scientist.mdl",
};

AnimTables[22]._NOWEPS = true;
AnimTables[22].Anim = { }

AnimTables[22].Anim["STAND_idle"] = ACT_IDLE;
AnimTables[22].Anim["STAND_walk"] = ACT_WALK;
AnimTables[22].Anim["STAND_run"] = ACT_RUN_SCARED;
AnimTables[22].Anim["STAND_jog"] = ACT_RUN;

AnimTables[22].Anim["CROUCH_idle"] = ACT_CROUCHIDLE;
AnimTables[22].Anim["CROUCH_walk"] = "barnacled2";

AnimTables[23] = { }

AnimTables[23].Models =
{
	"models/lostcoast/fisherman/fisherman.mdl"
};

AnimTables[23].Anim = { };

AnimTables[23].Anim["STAND_idle"] = ACT_IDLE;
AnimTables[23].Anim["STAND_walk"] = ACT_WALK;
AnimTables[23].Anim["STAND_run"] = ACT_WALK;
AnimTables[23].Anim["STAND_jog"] = ACT_RUN;

AnimTables[23].Anim["CROUCH_idle"] = ACT_IDLE;
AnimTables[23].Anim["CROUCH_walk"] = ACT_WALK;

AnimTables[23].Anim["STAND_FIST_idle"] = ACT_IDLE;
AnimTables[23].Anim["STAND_FIST_walk"] = ACT_WALK;
AnimTables[23].Anim["STAND_FIST_run"] = ACT_WALK;
AnimTables[23].Anim["STAND_FIST_jog"] = ACT_WALK;
AnimTables[23].Anim["CROUCH_FIST_idle"] = ACT_IDLE;
AnimTables[23].Anim["CROUCH_FIST_walk"] = ACT_WALK;

AnimTables[23].Anim["STAND_FIST_AIM_idle"] = "idle_angry_melee";
AnimTables[23].Anim["STAND_FIST_AIM_walk"] = ACT_WALK;
AnimTables[23].Anim["STAND_FIST_AIM_run"] = "run_all_panicked";
AnimTables[23].Anim["STAND_FIST_AIM_jog"] = ACT_RUN;
AnimTables[23].Anim["CROUCH_FIST_AIM_idle"] = ACT_COVER_LOW;
AnimTables[23].Anim["CROUCH_FIST_AIM_walk"] = ACT_WALK_CROUCH;

AnimTables[23].Anim["STAND_PISTOL_idle"] = ACT_IDLE;
AnimTables[23].Anim["STAND_PISTOL_walk"] = ACT_WALK;
AnimTables[23].Anim["STAND_PISTOL_run"] = "run_all_panicked";
AnimTables[23].Anim["STAND_PISTOL_jog"] = ACT_RUN;
AnimTables[23].Anim["CROUCH_PISTOL_idle"] = ACT_COVER_LOW;
AnimTables[23].Anim["CROUCH_PISTOL_walk"] = ACT_WALK_CROUCH;


AnimTables[23].Anim["STAND_PISTOL_AIM_idle"] = "Idle_SMG1_Aim_Alert";
AnimTables[23].Anim["STAND_PISTOL_AIM_walk"] = "walkAlertAimAll1";
AnimTables[23].Anim["STAND_PISTOL_AIM_run"] = "run_all_panicked";
AnimTables[23].Anim["STAND_PISTOL_AIM_jog"] = "run_alert_aiming_all";
AnimTables[23].Anim["CROUCH_PISTOL_AIM_idle"] = "crouch_aim_smg1";
AnimTables[23].Anim["CROUCH_PISTOL_AIM_walk"] = "crouch_walk_aiming_all";
 
AnimTables[23].Anim["STAND_SMG_idle"] = "Idle_relaxed_SMG1_1";
AnimTables[23].Anim["STAND_SMG_walk"] = "walk_smg1_relaxed_all";
AnimTables[23].Anim["STAND_SMG_run"] = "run_all_panicked";
AnimTables[23].Anim["STAND_SMG_jog"] = "run_smg1_relaxed_all";
AnimTables[23].Anim["CROUCH_SMG_idle"] = "Crouch_idleD";
AnimTables[23].Anim["CROUCH_SMG_walk"] = "crouch_walk_holding_all";

AnimTables[23].Anim["STAND_SMG_AIM_idle"] = "Idle_SMG1_Aim_Alert";
AnimTables[23].Anim["STAND_SMG_AIM_walk"] = "walkAlertAimAll1";
AnimTables[23].Anim["STAND_SMG_AIM_run"] = "run_all_panicked";
AnimTables[23].Anim["STAND_SMG_AIM_jog"] = "run_alert_aiming_all";
AnimTables[23].Anim["CROUCH_SMG_AIM_idle"] = "crouch_aim_smg1";
AnimTables[23].Anim["CROUCH_SMG_AIM_walk"] = "crouch_walk_aiming_all";

AnimTables[23].Anim["STAND_RIFLE_idle"] = ACT_IDLE_SUITCASE;
AnimTables[23].Anim["STAND_RIFLE_walk"] = ACT_WALK_SUITCASE;
AnimTables[23].Anim["STAND_RIFLE_run"] = ACT_WALK_SUITCASE;
AnimTables[23].Anim["STAND_RIFLE_jog"] = ACT_WALK_SUITCASE;
AnimTables[23].Anim["CROUCH_RIFLE_idle"] = ACT_IDLE_SUITCASE;
AnimTables[23].Anim["CROUCH_RIFLE_walk"] = ACT_WALK_SUITCASE;

AnimTables[23].Anim["STAND_RIFLE_AIM_idle"] = "Idle_SMG1_Aim_Alert";
AnimTables[23].Anim["STAND_RIFLE_AIM_walk"] = "walkAlertAimAll1";
AnimTables[23].Anim["STAND_RIFLE_AIM_run"] = "run_all_panicked";
AnimTables[23].Anim["STAND_RIFLE_AIM_jog"] = "run_alert_aiming_all";
AnimTables[23].Anim["CROUCH_RIFLE_AIM_idle"] = "crouch_aim_smg1";
AnimTables[23].Anim["CROUCH_RIFLE_AIM_walk"] = "crouch_walk_aiming_all";

AnimTables[23].Anim["jump"] = ACT_JUMP;
AnimTables[23].Anim["vehicle"] = ACT_BUSY_SIT_CHAIR;

AnimTables[24] = { }
AnimTables[24].Models =
{
	"models/infected/common_female01.mdl",
	"models/infected/common_female_nurse01.mdl",
	"models/infected/common_female_rural01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male_baggagehandler01.mdl",
	"models/infected/common_male_pilot.mdl",
	"models/infected/common_male_rural01.mdl",
	"models/infected/common_male_suit.mdl",
	"models/infected/common_military_male01.mdl",
	"models/infected/common_patient_male01.mdl",
	"models/infected/common_police_male01.mdl",
	"models/infected/common_surgeon_male01.mdl",
	"models/infected/common_tsaagent_male01.mdl",
	"models/infected/common_worker_male01.mdl",
};

AnimTables[24]._NOWEPS = true;
AnimTables[24].Anim = { }

AnimTables[24].Anim["STAND_idle"] = "Idle_Alert_03";
AnimTables[24].Anim["STAND_walk"] = "Walk";
AnimTables[24].Anim["STAND_run"] = "Run_01";
AnimTables[24].Anim["STAND_jog"] = "Run_01";

AnimTables[24].Anim["CROUCH_idle"] = "Crouch_Idle_Upper_KNIFE";
AnimTables[24].Anim["CROUCH_walk"] = "CrouchWalk_03";

AnimTables[25] = { }

AnimTables[25].Models =
{
	"models/kleiner.mdl"
};
AnimTables[25].Anim = { };
AnimTables[25].Shoot = { };

AnimTables[25].Shoot["PISTOL"] = ACT_GESTURE_RANGE_ATTACK_SHOTGUN;
AnimTables[25].Shoot["SMG"] = ACT_GESTURE_RANGE_ATTACK_SHOTGUN;
AnimTables[25].Shoot["RIFLE"] = ACT_GESTURE_RANGE_ATTACK_SHOTGUN;
AnimTables[25].Shoot["SHOTGUN"] = ACT_GESTURE_RANGE_ATTACK_SHOTGUN;
AnimTables[25].Shoot["SNIPER"] = ACT_GESTURE_RANGE_ATTACK_SHOTGUN;

AnimTables[25].Anim["STAND_idle"] = ACT_IDLE;
AnimTables[25].Anim["STAND_walk"] = ACT_WALK;
AnimTables[25].Anim["STAND_run"] = ACT_WALK;
AnimTables[25].Anim["STAND_jog"] = ACT_WALK;

AnimTables[25].Anim["CROUCH_idle"] = ACT_IDLE;
AnimTables[25].Anim["CROUCH_walk"] = ACT_WALK;

AnimTables[25].Anim["STAND_FIST_idle"] = ACT_IDLE;
AnimTables[25].Anim["STAND_FIST_walk"] = ACT_WALK;
AnimTables[25].Anim["STAND_FIST_run"] = ACT_WALK;
AnimTables[25].Anim["STAND_FIST_jog"] = ACT_WALK;
AnimTables[25].Anim["CROUCH_FIST_idle"] = ACT_IDLE;
AnimTables[25].Anim["CROUCH_FIST_walk"] = ACT_WALK;

AnimTables[25].Anim["STAND_FIST_AIM_idle"] = ACT_IDLE;
AnimTables[25].Anim["STAND_FIST_AIM_walk"] = ACT_WALK;
AnimTables[25].Anim["STAND_FIST_AIM_run"] = ACT_WALK;
AnimTables[25].Anim["STAND_FIST_AIM_jog"] = ACT_WALK;
AnimTables[25].Anim["CROUCH_FIST_AIM_idle"] = ACT_IDLE;
AnimTables[25].Anim["CROUCH_FIST_AIM_walk"] = ACT_WALK;

AnimTables[25].Anim["STAND_PISTOL_idle"] = ACT_IDLE_SHOTGUN_AGITATED;
AnimTables[25].Anim["STAND_PISTOL_walk"] = ACT_WALK;
AnimTables[25].Anim["STAND_PISTOL_run"] = ACT_RUN_RIFLE_STIMULATED;
AnimTables[25].Anim["STAND_PISTOL_jog"] = ACT_RUN_RIFLE_STIMULATED;
AnimTables[25].Anim["CROUCH_PISTOL_idle"] = ACT_IDLE_SHOTGUN_AGITATED;
AnimTables[25].Anim["CROUCH_PISTOL_walk"] = ACT_WALK_CROUCH;


AnimTables[25].Anim["STAND_PISTOL_AIM_idle"] = ACT_IDLE_SHOTGUN_AGITATED;
AnimTables[25].Anim["STAND_PISTOL_AIM_walk"] = ACT_WALK_RIFLE_STIMULATED;
AnimTables[25].Anim["STAND_PISTOL_AIM_run"] = ACT_RUN_RIFLE_STIMULATED;
AnimTables[25].Anim["STAND_PISTOL_AIM_jog"] = ACT_RUN_RIFLE_STIMULATED;
AnimTables[25].Anim["CROUCH_PISTOL_AIM_idle"] = ACT_IDLE_SHOTGUN_AGITATED;
AnimTables[25].Anim["CROUCH_PISTOL_AIM_walk"] = ACT_WALK_RIFLE_STIMULATED;
 
AnimTables[25].Anim["STAND_SMG_idle"] = ACT_IDLE_SHOTGUN_AGITATED;
AnimTables[25].Anim["STAND_SMG_walk"] = ACT_WALK_RIFLE_STIMULATED;
AnimTables[25].Anim["STAND_SMG_run"] = ACT_RUN_RIFLE_STIMULATED;
AnimTables[25].Anim["STAND_SMG_jog"] = ACT_RUN_RIFLE_STIMULATED;
AnimTables[25].Anim["CROUCH_SMG_idle"] = ACT_IDLE_SHOTGUN_AGITATED;
AnimTables[25].Anim["CROUCH_SMG_walk"] = ACT_WALK_RIFLE_STIMULATED;

AnimTables[25].Anim["STAND_SMG_AIM_idle"] = ACT_IDLE_SHOTGUN_AGITATED;
AnimTables[25].Anim["STAND_SMG_AIM_walk"] = ACT_WALK_RIFLE_STIMULATED;
AnimTables[25].Anim["STAND_SMG_AIM_run"] = ACT_RUN_RIFLE_STIMULATED;
AnimTables[25].Anim["STAND_SMG_AIM_jog"] = ACT_RUN_RIFLE_STIMULATED;
AnimTables[25].Anim["CROUCH_SMG_AIM_idle"] = ACT_IDLE_SHOTGUN_AGITATED;
AnimTables[25].Anim["CROUCH_SMG_AIM_walk"] = ACT_WALK_RIFLE_STIMULATED;

AnimTables[25].Anim["STAND_RIFLE_idle"] = ACT_IDLE_SHOTGUN_AGITATED;
AnimTables[25].Anim["STAND_RIFLE_walk"] = ACT_WALK_RIFLE_STIMULATED;
AnimTables[25].Anim["STAND_RIFLE_run"] = ACT_RUN_RIFLE_STIMULATED;
AnimTables[25].Anim["STAND_RIFLE_jog"] = ACT_RUN_RIFLE_STIMULATED;
AnimTables[25].Anim["CROUCH_RIFLE_idle"] = ACT_IDLE_SHOTGUN_AGITATED;
AnimTables[25].Anim["CROUCH_RIFLE_walk"] = ACT_WALK_RIFLE_STIMULATED;

AnimTables[25].Anim["STAND_RIFLE_AIM_idle"] = ACT_IDLE_SHOTGUN_AGITATED;
AnimTables[25].Anim["STAND_RIFLE_AIM_walk"] = ACT_WALK_RIFLE_STIMULATED;
AnimTables[25].Anim["STAND_RIFLE_AIM_run"] = ACT_RUN_RIFLE_STIMULATED;
AnimTables[25].Anim["STAND_RIFLE_AIM_jog"] = ACT_RUN_RIFLE_STIMULATED;
AnimTables[25].Anim["CROUCH_RIFLE_AIM_idle"] = ACT_IDLE_SHOTGUN_AGITATED;
AnimTables[25].Anim["CROUCH_RIFLE_AIM_walk"] = ACT_WALK_RIFLE_STIMULATED;

AnimTables[25].Anim["jump"] = ACT_JUMP;
AnimTables[25].Anim["vehicle"] = ACT_BUSY_SIT_CHAIR;

for k, v in pairs( AnimTables ) do

	if( v.Models ) then

		for n, m in pairs( v.Models ) do
		
			AnimTables[k].Models[n] = string.lower( AnimTables[k].Models[n] );
		
		end
		
	end

end
