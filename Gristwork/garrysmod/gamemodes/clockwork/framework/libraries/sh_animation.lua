--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local Clockwork = Clockwork;
local type = type;
local string = string;
local math = math;

Clockwork.animation = Clockwork.kernel:NewLibrary("Animation");
Clockwork.animation.sequences = Clockwork.animation.sequences or {};
Clockwork.animation.override = Clockwork.animation.override  or {};
Clockwork.animation.models = Clockwork.animation.models or {};
Clockwork.animation.stored = Clockwork.animation.stored or {};
Clockwork.animation.stored.combineOverwatch = {
	["normal"] = {
		["idle"] = {"idle_unarmed", "man_gun"},
		["idle_crouch"] = {"crouchidle", "crouchidle"},
		["walk"] = {"walkunarmed_all", ACT_WALK_RIFLE},
		["walk_crouch"] = {"crouch_walkall", "crouch_walkall"},
		["run"] = {"runall", ACT_RUN_AIM_RIFLE},
		["glide"] = ACT_GLIDE
	},
	["pistol"] = {
		["idle"] = {"idle_unarmed", ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {"crouchidle", "crouchidle"},
		["walk"] = {"walkunarmed_all", ACT_WALK_RIFLE},
		["walk_crouch"] = {"crouch_walkall", "crouch_walkall"},
		["run"] = {"runall", ACT_RUN_AIM_RIFLE}
	},
	["smg"] = {
		["idle"] = {ACT_IDLE_SMG1, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {"crouchidle", "crouchidle"},
		["walk"] = {ACT_WALK_RIFLE, ACT_WALK_AIM_RIFLE},
		["walk_crouch"] = {"crouch_walkall", "crouch_walkall"},
		["run"] = {ACT_RUN_RIFLE, ACT_RUN_AIM_RIFLE}
	},
	["shotgun"] = {
		["idle"] = {ACT_IDLE_SMG1, ACT_IDLE_ANGRY_SHOTGUN},
		["idle_crouch"] = {"crouchidle", "crouchidle"},
		["walk"] = {ACT_WALK_RIFLE, ACT_WALK_AIM_SHOTGUN},
		["walk_crouch"] = {"crouch_walkall", "crouch_walkall"},
		["run"] = {ACT_RUN_RIFLE, ACT_RUN_AIM_SHOTGUN}
	},
	["grenade"] = {
		["idle"] = {"idle_unarmed", "man_gun"},
		["idle_crouch"] = {"crouchidle", "crouchidle"},
		["walk"] = {"walkunarmed_all", ACT_WALK_RIFLE},
		["walk_crouch"] = {"crouch_walkall", "crouch_walkall"},
		["run"] = {"runall", ACT_RUN_AIM_RIFLE}
	},
	["melee"] = {
		["idle"] = {"idle_unarmed", "man_gun"},
		["idle_crouch"] = {"crouchidle", "crouchidle"},
		["walk"] = {"walkunarmed_all", ACT_WALK_RIFLE},
		["walk_crouch"] = {"crouch_walkall", "crouch_walkall"},
		["run"] = {"runall", ACT_RUN_AIM_RIFLE},
		["attack"] = ACT_MELEE_ATTACK_SWING_GESTURE
	}
};

Clockwork.animation.stored.civilProtection = {
	["normal"] = {
		["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_PISTOL_LOW, ACT_COVER_SMG1_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		["run"] = {ACT_RUN, ACT_RUN},
		["glide"] = ACT_GLIDE
	},
	["pistol"] = {
		["idle"] = {ACT_IDLE_PISTOL, ACT_IDLE_ANGRY_PISTOL},
		["idle_crouch"] = {ACT_COVER_PISTOL_LOW, ACT_COVER_PISTOL_LOW},
		["walk"] = {ACT_WALK_PISTOL, ACT_WALK_AIM_PISTOL},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		["run"] = {ACT_RUN_PISTOL, ACT_RUN_AIM_PISTOL},
		["attack"] = ACT_RANGE_ATTACK_PISTOL,
		["reload"] = ACT_RELOAD_PISTOL
	},
	["smg"] = {
		["idle"] = {ACT_IDLE_SMG1, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_SMG1_LOW, ACT_COVER_SMG1_LOW},
		["walk"] = {ACT_WALK_RIFLE, ACT_WALK_AIM_RIFLE},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		["run"] = {ACT_RUN_RIFLE, ACT_RUN_AIM_RIFLE}
	},
	["shotgun"] = {
		["idle"] = {ACT_IDLE_SMG1, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_SMG1_LOW, ACT_COVER_SMG1_LOW},
		["walk"] = {ACT_WALK_RIFLE, ACT_WALK_AIM_RIFLE},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		["run"] = {ACT_RUN_RIFLE, ACT_RUN_AIM_RIFLE_STIMULATED}
	},
	["grenade"] = {
		["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
		["idle_crouch"] = {ACT_COVER_PISTOL_LOW, ACT_COVER_PISTOL_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_ANGRY},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		["run"] = {ACT_RUN, ACT_RUN},
		["attack"] = ACT_COMBINE_THROW_GRENADE
	},
	["melee"] = {
		["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
		["idle_crouch"] = {ACT_COVER_PISTOL_LOW, ACT_COVER_PISTOL_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_ANGRY},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		["run"] = {ACT_RUN, ACT_RUN},
		["attack"] = ACT_MELEE_ATTACK_SWING_GESTURE
	}
};

Clockwork.animation.stored.femaleHuman = {
	["normal"] = {
		["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		["glide"] = ACT_GLIDE
	},
	["pistol"] = {
		["idle"] = {ACT_IDLE_PISTOL, ACT_IDLE_ANGRY_PISTOL},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_AIM_PISTOL},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_PISTOL},
		["run"] = {ACT_RUN, ACT_RUN_AIM_PISTOL},
		["attack"] = ACT_GESTURE_RANGE_ATTACK_PISTOL,
		["reload"] = ACT_RELOAD_PISTOL
	},
	["smg"] = {
		["idle"] = {ACT_IDLE_SMG1_RELAXED, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		["run"] = {ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		["attack"] = ACT_GESTURE_RANGE_ATTACK_SMG1,
		["reload"] = ACT_GESTURE_RELOAD_SMG1
	},
	["shotgun"] = {
		["idle"] = {ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		["run"] = {ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		["attack"] = ACT_GESTURE_RANGE_ATTACK_SHOTGUN
	},
	["grenade"] = {
		["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		["attack"] = ACT_RANGE_ATTACK_THROW
	},
	["melee"] = {
		["idle"] = {ACT_IDLE, ACT_IDLE_MANNEDGUN},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		["run"] = {ACT_RUN, ACT_RUN},
		["attack"] = ACT_MELEE_ATTACK_SWING
	}
};

Clockwork.animation.stored.maleHuman = {
	["normal"] = {
		["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		["glide"] = ACT_GLIDE
	},
	["pistol"] = {
		["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		["attack"] = ACT_GESTURE_RANGE_ATTACK_PISTOL,
		["reload"] = ACT_RELOAD_PISTOL
	},
	["smg"] = {
		["idle"] = {ACT_IDLE_SMG1_RELAXED, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		["run"] = {ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		["attack"] = ACT_GESTURE_RANGE_ATTACK_SMG1,
		["reload"] = ACT_GESTURE_RELOAD_SMG1
	},
	["shotgun"] = {
		["idle"] = {ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		["run"] = {ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		["attack"] = ACT_GESTURE_RANGE_ATTACK_SHOTGUN
	},
	["grenade"] = {
		["idle"] = {ACT_IDLE, ACT_IDLE_MANNEDGUN},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		["attack"] = ACT_RANGE_ATTACK_THROW
	},
	["melee"] = {
		["idle"] = {ACT_IDLE_SUITCASE, ACT_IDLE_ANGRY_MELEE},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		["run"] = {ACT_RUN, ACT_RUN},
		["attack"] = ACT_MELEE_ATTACK_SWING
	}
};

-- A function to set a model's menu sequence.
function Clockwork.animation:SetMenuSequence(model, sequence)
	self.sequences[string.lower(model)] = sequence;
end;

-- A function to get a model's menu sequence.
function Clockwork.animation:GetMenuSequence(model, bRandom)
	local lowerModel = string.lower(model);
	local sequence = self.sequences[lowerModel];
	
	if (sequence) then
		if (type(sequence) == "table") then
			if (bRandom) then
				return sequence[math.random(1, #sequence)];
			else
				return sequence;
			end;
		else
			return sequence;
		end;
	end;
end;

-- A function to add a model.
function Clockwork.animation:AddModel(class, model)
	local lowerModel = string.lower(model);
		self.models[lowerModel] = class;
	return lowerModel;
end;

-- A function to add an override.
function Clockwork.animation:AddOverride(model, key, value)
	local lowerModel = string.lower(model);
	
	if (!self.override[lowerModel]) then
		self.override[lowerModel] = {};
	end;
	
	self.override[lowerModel][key] = value;
end;

-- A function to get an animation for a model.
function Clockwork.animation:GetForModel(model, holdType, key, bNoFallbacks)
	if (!model) then
		debug.Trace();
		
		return false;
	end;

	local lowerModel = string.lower(model);
	local animTable = self:GetTable(lowerModel);
	local overrideTable = self.override[lowerModel];

	if (!bNoFallbacks) then
		if (!animTable[holdType]) then
			holdType = "normal";
		end;

		if (!animTable[holdType][key]) then
			key = "idle";
		end;
	end;

	local finalAnimation = animTable[holdType][key];
	
	if (overrideTable and overrideTable[holdType] and overrideTable[holdType][key]) then
		finalAnimation = overrideTable[holdType][key];
	end;
	
	return finalAnimation;
end;

-- A function to get a model's class.
function Clockwork.animation:GetModelClass(model, alwaysReal)
	local modelClass = self.models[string.lower(model)];
	
	if (!modelClass) then
		if (!alwaysReal) then
			return "maleHuman";
		end;
	else
		return modelClass;
	end;
end;

-- A function to add a Combine Overwatch model.
function Clockwork.animation:AddCombineOverwatchModel(model)
	return self:AddModel("combineOverwatch", model);
end;

-- A function to add a Civil Protection model.
function Clockwork.animation:AddCivilProtectionModel(model)
	return self:AddModel("civilProtection", model);
end;

-- A function to add a female human model.
function Clockwork.animation:AddFemaleHumanModel(model)
	return self:AddModel("femaleHuman", model);
end;

-- A function to add a male human model.
function Clockwork.animation:AddMaleHumanModel(model)
	return self:AddModel("maleHuman", model);
end;

local translateHoldTypes = {
	["melee2"] = "melee",
	["fist"] = "melee",
	["knife"] = "melee",
	["ar2"] = "smg",
	["physgun"] = "smg",
	["crossbow"] = "smg",
	["slam"] = "grenade",
	["passive"] = "normal",
	["rpg"] = "shotgun"
};

local weaponHoldTypes = {
	["weapon_ar2"] = "smg",
	["weapon_smg1"] = "smg",
	["weapon_physgun"] = "smg",
	["weapon_crossbow"] = "smg",
	["weapon_physcannon"] = "smg",
	["weapon_crowbar"] = "melee",
	["weapon_bugbait"] = "melee",
	["weapon_stunstick"] = "melee",
	["weapon_stunstick"] = "melee",
	["gmod_tool"] = "pistol",
	["weapon_357"] = "pistol",
	["weapon_pistol"] = "pistol",
	["weapon_frag"] = "grenade",
	["weapon_slam"] = "grenade",
	["weapon_rpg"] = "shotgun",
	["weapon_shotgun"] = "shotgun",
	["weapon_annabelle"] = "shotgun"
};

-- A function to get a weapon's hold type.
function Clockwork.animation:GetWeaponHoldType(player, weapon)
	local class = string.lower(weapon:GetClass());
	local holdType = "normal";
	
	if (weaponHoldTypes[class]) then
		holdType = weaponHoldTypes[class];
	elseif (weapon and weapon.HoldType) then
		if (translateHoldTypes[weapon.HoldType]) then
			holdType = translateHoldTypes[weapon.HoldType];
		else
			holdType = weapon.HoldType;
		end;
	end;
	
	return string.lower(holdType);
end;

-- A function to get an animation table.
function Clockwork.animation:GetTable(model)
	local lowerModel = string.lower(model);
	local class = self.models[lowerModel];
	
	if (class and self.stored[class]) then
		return self.stored[class];
	elseif (string.find(lowerModel, "female")) then
		return self.stored.femaleHuman;
	else
		return self.stored.maleHuman;
	end;
end;

local function ADD_CITIZEN_MODELS(prefix)
	for k, v in pairs(file.Find("models/humans/group01/"..prefix.."_*.mdl", "GAME")) do
		Clockwork.animation:AddModel(prefix.."Human", "models/humans/group01/"..v);
	end;

	for k, v in pairs(file.Find("models/humans/group02/"..prefix.."_*.mdl", "GAME")) do
		Clockwork.animation:AddModel(prefix.."Human", "models/humans/group02/"..v);
	end;

	for k, v in pairs(file.Find("models/humans/group03/"..prefix.."_*.mdl", "GAME")) do
		Clockwork.animation:AddModel(prefix.."Human", "models/humans/group03/"..v);
	end;

	for k, v in pairs(file.Find("models/humans/group03m/"..prefix.."_*.mdl", "GAME")) do
		Clockwork.animation:AddModel(prefix.."Human", "models/humans/group03m/"..v);
	end;
end;

Clockwork.animation:AddCombineOverwatchModel("models/combine_soldier_prisonguard.mdl");
Clockwork.animation:AddCombineOverwatchModel("models/combine_super_soldier.mdl");
Clockwork.animation:AddCombineOverwatchModel("models/combine_soldier.mdl");

Clockwork.animation:AddCivilProtectionModel("models/police.mdl");

ADD_CITIZEN_MODELS("male"); 
ADD_CITIZEN_MODELS("female");