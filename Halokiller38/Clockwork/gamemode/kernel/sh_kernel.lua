--[[
	Free Clockwork!
--]]

Clockwork.Timers = {};
Clockwork.Libraries = {};
Clockwork.SharedVars = {
	player = {vars = {}},
	global = {vars = {}}
};
Clockwork.DataStreamHooks = {};
Clockwork.GlobalSharedVars = {};

-- A function to get the global shared variables.
function Clockwork.SharedVars:Global(bObject)
	if (!bObject) then
		return self.global.vars;
	else
		return self.global;
	end;
end;

-- A function to get the player shared variables.
function Clockwork.SharedVars:Player(bObject)
	if (!bObject) then
		return self.player.vars;
	else
		return self.player;
	end;
end;

-- A function to add a player shared variable.
function Clockwork.SharedVars.player:Add(name, class, bPlayerOnly)
	self.vars[name] = {
		bPlayerOnly = bPlayerOnly,
		class = class,
		name = name
	};
end;

-- A function to add a player shared string.
function Clockwork.SharedVars.player:String(name, bPlayerOnly)
	self:Add(name, NWTYPE_STRING, bPlayerOnly);
end;

-- A function to add a player shared entity.
function Clockwork.SharedVars.player:Entity(name, bPlayerOnly)
	self:Add(name, NWTYPE_ENTITY, bPlayerOnly);
end;

-- A function to add a player shared vector.
function Clockwork.SharedVars.player:Vector(name, bPlayerOnly)
	self:Add(name, NWTYPE_VECTOR, bPlayerOnly);
end;

-- A function to add a player shared number.
function Clockwork.SharedVars.player:Number(name, bPlayerOnly)
	self:Add(name, NWTYPE_NUMBER, bPlayerOnly);
end;

-- A function to add a player shared angle.
function Clockwork.SharedVars.player:Angle(name, bPlayerOnly)
	self:Add(name, NWTYPE_ANGLE, bPlayerOnly);
end;

-- A function to add a player shared float.
function Clockwork.SharedVars.player:Float(name, bPlayerOnly)
	self:Add(name, NWTYPE_FLOAT, bPlayerOnly);
end;

-- A function to add a player shared bool.
function Clockwork.SharedVars.player:Bool(name, bPlayerOnly)
	self:Add(name, NWTYPE_BOOL, bPlayerOnly);
end;

-- A function to add a global shared variable.
function Clockwork.SharedVars.global:Add(name, class)
	self.vars[name] = {
		class = class,
		name = name
	};
end;

-- A function to add a global shared string.
function Clockwork.SharedVars.global:String(name)
	self:Add(name, NWTYPE_STRING);
end;

-- A function to add a global shared entity.
function Clockwork.SharedVars.global:Entity(name)
	self:Add(name, NWTYPE_ENTITY);
end;

-- A function to add a global shared vector.
function Clockwork.SharedVars.global:Vector(name)
	self:Add(name, NWTYPE_VECTOR);
end;

-- A function to add a global shared number.
function Clockwork.SharedVars.global:Number(name)
	self:Add(name, NWTYPE_NUMBER);
end;

-- A function to add a global shared angle.
function Clockwork.SharedVars.global:Angle(name)
	self:Add(name, NWTYPE_ANGLE);
end;

-- A function to add a global shared float.
function Clockwork.SharedVars.global:Float(name)
	self:Add(name, NWTYPE_FLOAT);
end;

-- A function to add a global shared bool.
function Clockwork.SharedVars.global:Bool(name)
	self:Add(name, NWTYPE_BOOL);
end;

-- A function to scale a size to wide screen.
function ScaleToWideScreen(size)
	return math.min(math.max(ScreenScale(size / 2.62467192), math.min(size, 16)), size);
end;

-- A function to encode a URL.
function Clockwork:URLEncode(url)
	local output = "";
	
	for i = 1, string.len(url) do
		local c = string.sub(url, i, i);
		local a = string.byte(c);
		
		if (a < 128) then
			if (a == 32 or a >= 34 and a <= 38 or a == 43 or a == 44 or a == 47 or a >= 58
			and a <= 64 or a >= 91 and a <= 94 or a == 96 or a >= 123 and a <= 126) then
				output = output.."%"..string.format("%x", a);
			else
				output = output..c;
			end;
		end;
	end;
	
	return output;
end;

-- A function to hook a data stream.
function Clockwork:HookDataStream(name, Callback)
	self.DataStreamHooks[name] = Callback;
end;

-- A function to get whether a weapon is a default weapon.
function Clockwork:IsDefaultWeapon(weapon)
	if (IsValid(weapon)) then
		local class = string.lower(weapon:GetClass());
		if (class == "weapon_physgun" or class == "gmod_physcannon"
		or class == "gmod_tool") then
			return true;
		end;
	end;
	
	return false;
end;

--[[
	Define the default library class.
--]]

local LIBRARY = {};

-- A function to add a library function to a metatable.
function LIBRARY:AddToMetaTable(metaName, funcName, Callback)
	local metaTable = FindMetaTable(metaName);
		metaTable[funcName] = Callback;
	return metaTable[funcName];
end;

-- A function to create a new library.
function Clockwork:NewLibrary(libName)
	Clockwork.Libraries[libName] = self:NewMetaTable(LIBRARY);
	return Clockwork.Libraries[libName];
end;

-- A function find a library by its name.
function Clockwork:FindLibrary(libName)
	return Clockwork.Libraries[libName];
end;

-- A function to get the path to the GMod directory.
function Clockwork:GetPathToGMod()
	return util.RelativePathToFull("."):sub(1, -2);
end;

-- A function to convert a string to a color.
function Clockwork:StringToColor(text)
	local explodedData = string.Explode(",", text);
	local color = Color(255, 255, 255, 255);
	
	if (explodedData[1]) then
		color.r = tonumber( explodedData[1]:Trim() ) or 255;
	end;
	
	if (explodedData[2]) then
		color.g = tonumber( explodedData[2]:Trim() ) or 255;
	end;
	
	if (explodedData[3]) then
		color.b = tonumber( explodedData[3]:Trim() ) or 255;
	end;
	
	if (explodedData[4]) then
		color.a = tonumber( explodedData[4]:Trim() ) or 255;
	end;
	
	return color;
end;

-- A function to get a log type color.
function Clockwork:GetLogTypeColor(logType)
	local logTypes = {
		Color(255, 50, 50, 255),
		Color(255, 150, 0, 255),
		Color(255, 200, 0, 255),
		Color(0, 150, 255, 255),
		Color(0, 255, 125, 255)
	};
	
	return logTypes[logType] or logTypes[5];
end;

-- A function to get the kernel version.
function Clockwork:GetKernelVersion()
	return self.KernelVersion;
end;

-- A function to get the schema folder.
function Clockwork:GetSchemaFolder(sFolderName)
	if (sFolderName) then
		return (string.gsub(self.SchemaFolder, "gamemodes/", "").."/gamemode/kernel/"..sFolderName);
	else
		return (string.gsub(self.SchemaFolder, "gamemodes/", ""));
	end;
end;

-- A function to get the Clockwork folder.
function Clockwork:GetClockworkFolder()
	return (string.gsub(self.ClockworkFolder, "gamemodes/", ""));
end;

-- A function to get the Clockwork path.
function Clockwork:GetClockworkPath()
	return (string.gsub(self.ClockworkFolder, "gamemodes/", "").."/gamemode");
end;

-- A function to get the kernel path.
function Clockwork:GetKernelPath()
	return self:GetClockworkPath().."/kernel";
end;

-- A function to convert a string to a boolean.
function Clockwork:ToBool(text)
	if (text == "true" or text == "yes" or text == "1") then
		return true;
	else
		return false;
	end;
end;

-- A function to split a string.
function Clockwork:SplitString(text, interval)
	local length = string.len(text);
	local baseTable = {};
	local i = 0;
	
	while (i * interval < length) do
		baseTable[i + 1] = string.sub(text, i * interval + 1, (i + 1) * interval);
		i = i + 1;
	end;
	
	return baseTable;
end;

-- A function to get whether a letter is a vowel.
function Clockwork:IsVowel(letter)
	letter = string.lower(letter);
	return (leter == "a" or letter == "e" or letter == "i"
	or letter == "o" or letter == "u");
end;

-- A function to pluralize some text.
function Clockwork:Pluralize(text)
	if (string.sub(text, -2) != "fe") then
		local lastLetter = string.sub(text, -1);
		
		if (lastLetter == "y") then
			if (self:IsVowel(string.sub(text, string.len(text) - 1, 2))) then
				return string.sub(text, 1, -2).."ies";
			else
				return text.."s";
			end;
		elseif (lastLetter == "h") then
			return text.."es";
		elseif (lastLetter != "s") then
			return text.."s";
		else
			return text;
		end;
	else
		return string.sub(text, 1, -3).."ves";
	end;
end;

-- A function to get ammo information from a weapon.
function Clockwork:GetAmmoInformation(weapon)
	if (IsValid(weapon) and IsValid(weapon.Owner) and weapon.Primary and weapon.Secondary) then
		if (!weapon.AmmoInfo) then
			weapon.AmmoInfo = {
				primary = {
					ammoType = weapon:GetPrimaryAmmoType(),
					clipSize = weapon.Primary.ClipSize
				},
				secondary = {
					ammoType = weapon:GetSecondaryAmmoType(),
					clipSize = weapon.Secondary.ClipSize
				}
			};
		end;
		
		weapon.AmmoInfo.primary.ownerAmmo = weapon.Owner:GetAmmoCount(weapon.AmmoInfo.primary.ammoType);
		weapon.AmmoInfo.primary.clipBullets = weapon:Clip1();
		weapon.AmmoInfo.primary.doesNotShoot = (weapon.AmmoInfo.primary.clipBullets == -1);
		weapon.AmmoInfo.secondary.ownerAmmo = weapon.Owner:GetAmmoCount(weapon.AmmoInfo.secondary.ammoType);
		weapon.AmmoInfo.secondary.clipBullets = weapon:Clip2();
		weapon.AmmoInfo.secondary.doesNotShoot = (weapon.AmmoInfo.secondary.clipBullets == -1);
		
		if (!weapon.AmmoInfo.primary.doesNotShoot and weapon.AmmoInfo.primary.ownerAmmo > 0) then
			weapon.AmmoInfo.primary.ownerClips = math.ceil(weapon.AmmoInfo.primary.clipSize / weapon.AmmoInfo.primary.ownerAmmo);
		else
			weapon.AmmoInfo.primary.ownerClips = 0;
		end;
		
		if (!weapon.AmmoInfo.secondary.doesNotShoot and weapon.AmmoInfo.secondary.ownerAmmo > 0) then
			weapon.AmmoInfo.secondary.ownerClips = math.ceil(weapon.AmmoInfo.secondary.clipSize / weapon.AmmoInfo.secondary.ownerAmmo);
		else
			weapon.AmmoInfo.secondary.ownerClips = 0;
		end;
		
		return weapon.AmmoInfo;
	end;
end;

-- A function to initialize the Clockwork kernel.
function Clockwork:InitializeKernel()
	local itemsTable = self.item:GetAll();

	for k, v in pairs(itemsTable) do
		if (v.baseItem and !self.item:Merge(v, v.baseItem)) then
			itemsTable[k] = nil;
		end;
	end;

	for k, v in pairs(itemsTable) do
		if (v.OnSetup) then v:OnSetup(); end;
		
		if (self.item:IsWeapon(v)) then
			self.item.weapons[v.weaponClass] = v;
		end;
		
		self.plugin:Call("ClockworkItemInitialized", v);
	end;

	self.plugin:Call("ClockworkSchemaLoaded");

	if (SERVER) then
		self.plugin:Call("ClockworkSaveShared", CW_SCRIPT_SHARED);
		
		local filePath = self:SetupFullDirectory("lua/autorun/client/Clockwork.lua");
		local saveData = [[CW_SCRIPT_SHARED = "]]..glon.encode(CW_SCRIPT_SHARED)..[[";]];
		
		fileio.Write(filePath, saveData);
		AddCSLuaFile("autorun/client/Clockwork.lua");
	else
		self.plugin:Call("ClockworkLoadShared", CW_SCRIPT_SHARED);
	end;

	self.plugin:Call("ClockworkAddSharedVars",
		self:GetSharedVars():Global(true),
		self:GetSharedVars():Player(true)
	);
	
	self:IncludePrefixed(self:GetKernelPath().."/sh_coms.lua");
end;

-- Called when the player's jumping animation should be handled.
function Clockwork:HandlePlayerJumping(player)
	if (!player.m_bJumping and !player:OnGround() and player:WaterLevel() <= 0) then
		player.m_bJumping = true;
		player.m_bFirstJumpFrame = false;
		player.m_flJumpStartTime = 0;
	end
	
	if (player.m_bJumping) then
		if (player.m_bFirstJumpFrame) then
			player.m_bFirstJumpFrame = false;
			player:AnimRestartMainSequence();
		end;
		
		if (player:WaterLevel() >= 2) then
			player.m_bJumping = false;
			player:AnimRestartMainSequence();
		elseif (CurTime() - player.m_flJumpStartTime > 0.2) then
			if (player:OnGround()) then
				player.m_bJumping = false;
				player:AnimRestartMainSequence();
			end
		end
		
		if (player.m_bJumping) then
			player.CalcIdeal = self.animation:GetForModel(player:GetModel(), "jump");
			
			return true;
		end;
	end;
	
	return false;
end;

-- Called when the player's ducking animation should be handled.
function Clockwork:HandlePlayerDucking(player, velocity)
	if (player:Crouching()) then
		local model = player:GetModel();
		local weapon = player:GetActiveWeapon();
		local bIsRaised = self.player:GetWeaponRaised(player, true);
		local velLength = velocity:Length2D();
		local animationAct = "crouch";
		local weaponHoldType = "pistol";
		
		if (IsValid(weapon)) then
			weaponHoldType = self.animation:GetWeaponHoldType(player, weapon);
		
			if (weaponHoldType) then
				animationAct = animationAct.."_"..weaponHoldType;
			end;
		end;
		
		if (bIsRaised) then
			animationAct = animationAct.."_aim";
		end;
		
		if (velLength > 0.5) then
			animationAct = animationAct.."_walk";
		else
			animationAct = animationAct.."_idle";
		end;

		player.CalcIdeal = self.animation:GetForModel(model, animationAct);
		
		return true;
	end;
	
	return false;
end;

-- Called when the player's swimming animation should be handled.
function Clockwork:HandlePlayerSwimming(player)
	if (player:WaterLevel() >= 2) then
		if (player.m_bFirstSwimFrame) then
			player:AnimRestartMainSequence();
			player.m_bFirstSwimFrame = false;
		end;
		
		player.m_bInSwim = true;
	else
		player.m_bInSwim = false;
		
		if (!player.m_bFirstSwimFrame) then
			player.m_bFirstSwimFrame = true;
		end;
	end;
	
	return false;
end;

-- Called when the player's driving animation should be handled.
function Clockwork:HandlePlayerDriving(player)
	if (player:InVehicle()) then
		player.CalcIdeal = self.animation:GetForModel(player:GetModel(), "sit");
		
		return true;
	end;
	
	return false;
end;

-- Called when a player's animation is updated.
function Clockwork:UpdateAnimation(player, velocity, maxSeqGroundSpeed)
	local velLength = velocity:Length2D();
	local rate = 1.0;
	
	if (velLength > 0.5) then
		rate = ((velLength * 0.8) / maxSeqGroundSpeed);
	end
	
	player.cwPlaybackRate = math.Clamp(rate, 0, 1.5);
	player:SetPlaybackRate(player.cwPlaybackRate);
	
	if (player:InVehicle() and CLIENT) then
		local vehicle = player:GetVehicle();
		
		if (IsValid(vehicle)) then
			local velocity = vehicle:GetVelocity();
			local steer = (vehicle:GetPoseParameter("vehicle_steer") * 2) - 1;
			
			player:SetPoseParameter("vertical_velocity", velocity.z * 0.01);
			player:SetPoseParameter("vehicle_steer", steer);
		end;
	end;
end;

-- Called when the main activity should be calculated.
function Clockwork:CalcMainActivity(player, velocity)
	local model = player:GetModel();
	
	if (string.find(model, "/player/")) then
		return self.BaseClass:CalcMainActivity(player, velocity);
	end;
	
	ANIMATION_PLAYER = player;
	
	local weapon = player:GetActiveWeapon();
	local bIsRaised = self.player:GetWeaponRaised(player, true);
	local animationAct = "stand";
	local weaponHoldType = "pistol";
	local forcedAnimation = player:GetForcedAnimation();

	if (IsValid(weapon)) then
		weaponHoldType = self.animation:GetWeaponHoldType(player, weapon);
	
		if (weaponHoldType) then
			animationAct = animationAct.."_"..weaponHoldType;
		end;
	end;
	
	if (bIsRaised) then
		animationAct = animationAct.."_aim";
	end;
	
	player.CalcIdeal = self.animation:GetForModel(model, animationAct.."_idle");
	player.CalcSeqOverride = -1;
	
	if (!self:HandlePlayerDriving(player)
	and !self:HandlePlayerJumping(player)
	and !self:HandlePlayerDucking(player, velocity)
	and !self:HandlePlayerSwimming(player)) then
		local velLength = velocity:Length2D();
		
		if (player:IsRunning() or player:IsJogging()) then
			player.CalcIdeal = self.animation:GetForModel(model, animationAct.."_run");
		elseif (velLength > 0.5) then
			player.CalcIdeal = self.animation:GetForModel(model, animationAct.."_walk");
		end;
	end;
	
	if (forcedAnimation) then
		player.CalcSeqOverride = forcedAnimation.animation;
		
		if (forcedAnimation.OnAnimate) then
			forcedAnimation.OnAnimate(player);
			forcedAnimation.OnAnimate = nil;
		end;
	end;
	
	if (type(player.CalcSeqOverride) == "string") then
		player.CalcSeqOverride = player:LookupSequence(player.CalcSeqOverride);
	end;
	
	if (type(player.CalcIdeal) == "string") then
		player.CalcSeqOverride = player:LookupSequence(player.CalcIdeal);
	end;
	
	ANIMATION_PLAYER = nil;
	
	return player.CalcIdeal, player.CalcSeqOverride;
end;

local IdleActivity = ACT_HL2MP_IDLE;
local IdleActivityTranslate = {
	ACT_MP_ATTACK_CROUCH_PRIMARYFIRE = IdleActivity + 5,
	ACT_MP_ATTACK_STAND_PRIMARYFIRE = IdleActivity + 5,
	ACT_MP_RELOAD_CROUCH = IdleActivity + 6,
	ACT_MP_RELOAD_STAND = IdleActivity + 6,
	ACT_MP_CROUCH_IDLE = IdleActivity + 3,
	ACT_MP_STAND_IDLE = IdleActivity,
	ACT_MP_CROUCHWALK = IdleActivity + 4,
	ACT_MP_JUMP = ACT_HL2MP_JUMP_SLAM,
	ACT_MP_WALK = IdleActivity + 1,
	ACT_MP_RUN = IdleActivity + 2,
};
	
-- Called when a player's activity is supposed to be translated.
function Clockwork:TranslateActivity(player, act)
	local model = player:GetModel();
	local bIsRaised = self.player:GetWeaponRaised(player, true);
	
	if (string.find(model, "/player/")) then
		local newAct = player:TranslateWeaponActivity(act);
		
		if (!bIsRaised or act == newAct) then
			return IdleActivityTranslate[act];
		else
			return newAct;
		end;
	end;
	
	return act;
end;

-- Called when the animation event is supposed to be done.
function Clockwork:DoAnimationEvent(player, event, data)
	local model = player:GetModel();
	
	if (string.find(model, "/player/")) then
		return self.BaseClass:DoAnimationEvent(player, event, data);
	end;
	
	local weapon = player:GetActiveWeapon();
	local animationAct = "pistol";
	
	if (IsValid(weapon)) then
		weaponHoldType = self.animation:GetWeaponHoldType(player, weapon);
	
		if (weaponHoldType) then
			animationAct = weaponHoldType;
		end;
	end;
	
	if (event == PLAYERANIMEVENT_ATTACK_PRIMARY) then
		local gestureSequence = self.animation:GetForModel(model, animationAct.."_attack");

		if (player:Crouching()) then
			player:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, gestureSequence);
		else
			player:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, gestureSequence);
		end;
		
		return ACT_VM_PRIMARYATTACK;
	elseif (event == PLAYERANIMEVENT_RELOAD) then
		local gestureSequence = self.animation:GetForModel(model, animationAct.."_reload");

		if (player:Crouching()) then
			player:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, gestureSequence);
		else
			player:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, gestureSequence);
		end;
		
		return ACT_INVALID;
	elseif event == PLAYERANIMEVENT_JUMP then
		player.m_bJumping = true;
		player.m_bFirstJumpFrame = true;
		player.m_flJumpStartTime = CurTime();
		
		player:AnimRestartMainSequence();
		
		return ACT_INVALID;
	elseif (event == PLAYERANIMEVENT_CANCEL_RELOAD) then
		player:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD);
		
		return ACT_INVALID;
	end;

	return nil;
end;

if (SERVER) then
	Clockwork.Entities = {};
	Clockwork.TempPlayerData = {};
	Clockwork.HitGroupBonesCache = {
		{"ValveBiped.Bip01_R_UpperArm", HITGROUP_RIGHTARM},
		{"ValveBiped.Bip01_R_Forearm", HITGROUP_RIGHTARM},
		{"ValveBiped.Bip01_L_UpperArm", HITGROUP_LEFTARM},
		{"ValveBiped.Bip01_L_Forearm", HITGROUP_LEFTARM},
		{"ValveBiped.Bip01_R_Thigh", HITGROUP_RIGHTLEG},
		{"ValveBiped.Bip01_R_Calf", HITGROUP_RIGHTLEG},
		{"ValveBiped.Bip01_R_Foot", HITGROUP_RIGHTLEG},
		{"ValveBiped.Bip01_R_Hand", HITGROUP_RIGHTARM},
		{"ValveBiped.Bip01_L_Thigh", HITGROUP_LEFTLEG},
		{"ValveBiped.Bip01_L_Calf", HITGROUP_LEFTLEG},
		{"ValveBiped.Bip01_L_Foot", HITGROUP_LEFTLEG},
		{"ValveBiped.Bip01_L_Hand", HITGROUP_LEFTARM},
		{"ValveBiped.Bip01_Pelvis", HITGROUP_STOMACH},
		{"ValveBiped.Bip01_Spine2", HITGROUP_CHEST},
		{"ValveBiped.Bip01_Spine1", HITGROUP_CHEST},
		{"ValveBiped.Bip01_Head1", HITGROUP_HEAD},
		{"ValveBiped.Bip01_Neck1", HITGROUP_HEAD}
	};
	Clockwork.MeleeTranslation = {
		[ACT_HL2MP_GESTURE_RANGE_ATTACK] = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2,
		[ACT_HL2MP_GESTURE_RELOAD] = ACT_HL2MP_GESTURE_RELOAD_MELEE2,
		[ACT_HL2MP_WALK_CROUCH] = ACT_HL2MP_WALK_CROUCH_MELEE2,
		[ACT_HL2MP_IDLE_CROUCH] = ACT_HL2MP_IDLE_CROUCH_MELEE2,
		[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK1_MELEE2,
		[ACT_HL2MP_IDLE] = ACT_HL2MP_IDLE_MELEE2,
		[ACT_HL2MP_WALK] = ACT_HL2MP_WALK_MELEE2,
		[ACT_HL2MP_JUMP] = ACT_HL2MP_JUMP_MELEE2,
		[ACT_HL2MP_RUN] = ACT_HL2MP_RUN_MELEE2
	};
	
	-- A function to load the bans.
	function Clockwork:LoadBans()
		self.BanList = self:RestoreClockworkData("bans");
		
		local unixTime = os.time();
		
		for k, v in pairs(self.BanList) do
			if (type(v) == "table") then
				if (v.unbanTime > 0 and unixTime >= v.unbanTime) then
					self:RemoveBan(k, true);
				end;
			else
				self.BanList[k] = nil;
			end;
		end;
		
		self:SaveClockworkData("bans", self.BanList);
	end;
	
	-- A function to get the schema serial key.
	function Clockwork:GetSerialKey()
		local schemaFolder = self:GetSchemaFolder();
		local serialKey = file.Read("../gamemodes/"..schemaFolder.."/serial.cfg");

		if (!serialKey or serialKey == "") then
			serialKey = "################################";
		end;

		if (string.sub(serialKey, -1) == "\n") then
			serialKey = string.sub(serialKey, 1, -2);
		end;
		
		return serialKey;
	end;
	
	-- A function to add a ban.
	function Clockwork:AddBan(identifier, duration, reason, Callback, saveless, user)
		local steamName = nil;
		local playerGet = self.player:FindByID(identifier);
		
		if (identifier) then
			identifier = string.upper(identifier);
		end;
		
		for k, v in ipairs(_player.GetAll()) do
			local playerIP = v:IPAddress();
			local playerSteam = v:SteamID();
			
			if (playerSteam == identifier or playerIP == identifier or playerGet == v) then
				self.plugin:Call("PlayerBanned", v, duration, reason);
				
				if (playerIP == identifier) then
					identifier = playerIP;
				else
					identifier = playerSteam;
				end;
				
				steamName = v:SteamName();
				v:Kick(reason);
			end;
		end;
		
		if (!reason) then
			reason = "Banned for an unspecified reason.";
		end;
		
		if (!steamName) then
			local playersTable = self.config:Get("mysql_players_table"):Get();
			local newIdentifier = tmysql.escape(identifier);
			
			if (string.find(identifier, "STEAM")) then
				tmysql.query("SELECT * FROM "..playersTable.." WHERE _SteamID = \""..newIdentifier.."\"", function(result)
					local steamName = identifier;
					
					if (result and type(result) == "table" and #result > 0) then
						steamName = result[1]._SteamName;
					end;
					
					if (duration == 0) then
						
						self.BanList[identifier] = {
							unbanTime = 0,
							steamName = steamName,
							duration = duration,
							reason = reason
						};
					else
						self.BanList[identifier] = {
							unbanTime = os.time() + duration,
							steamName = steamName,
							duration = duration,
							reason = reason
						};
					end;
					
					if (!saveless) then
						self:SaveClockworkData("bans", self.BanList);
					end;
					
					if (Callback) then
						Callback(steamName, duration, reason);
					end;
				end, 1);
			elseif (string.find(identifier, "%d+%.%d+%.%d+%.%d+")) then
				tmysql.query("SELECT * FROM "..playersTable.." WHERE _IPAddress = \""..newIdentifier.."\"", function(result)
					local steamName = identifier;
					
					if (result and type(result) == "table" and #result > 0) then
						steamName = result[1]._SteamName;
					end;
					
					if (duration == 0) then
						self.BanList[identifier] = {
							unbanTime = 0,
							steamName = steamName,
							duration = duration,
							reason = reason
						};
					else
						self.BanList[identifier] = {
							unbanTime = os.time() + duration,
							steamName = steamName,
							duration = duration,
							reason = reason
						};
					end;
					
					if (!saveless) then
						self:SaveClockworkData("bans", self.BanList);
					end;
					
					if (Callback) then
						Callback(steamName, duration, reason);
					end;
				end, 1);
			elseif (Callback) then
				Callback();
			end;
		else
			if (duration == 0) then
			//	Clockwork:BanSQL(identifier, 0, steamName, "", reason, user:SteamID())
				self.BanList[identifier] = {
					unbanTime = 0,
					steamName = steamName,
					duration = duration,
					reason = reason
				};
			else
				self.BanList[identifier] = {
					unbanTime = os.time() + duration,
					steamName = steamName,
					duration = duration,
					reason = reason
				};
			end;
			
			if (!saveless) then
				self:SaveClockworkData("bans", self.BanList);
			end;
			
			if (Callback) then
				Callback(steamName, duration, reason);
			end;
		end;
	end;
	
	-- A function to remove a ban.
	function Clockwork:RemoveBan(identifier, saveless)
		if (self.BanList[identifier]) then
			self.BanList[identifier] = nil;
			
			if (!saveless) then
				self:SaveClockworkData("bans", self.BanList);
			end;
			//self:UnbanSQL(identifier);
		end;
	end;
	
	-- A function to manage the Ban SQL
	function Clockwork:BanSQL(identifier, unbanTime, steamName, IPAddress, banReason, bannedBy)
		local newidentifier = tmysql.escape(identifier);
		local newUnbanTime = tmysql.escape(unbanTime);
		local newSteamName = tmysql.escape(steamName);
		local newIPAddress = tmysql.escape(IPAddress);
		local newBanReason = tmysql.escape(banReason);
		local newUBannedBy = tmysql.escape(uBannedBy);
			
		tmysql.query("INSERT INTO bans (_Identifier, _BanReason, _UnbanTime, _SteamName, _IPAddress, _BannedBy) VALUES ('"..newidentifier.."', '"..newBanReason.."', '"..newUnbanTime.."', '"..newSteamName.."', '"..newUBannedBy.."')");
	end;
	
	-- A function to manage the UnBan SQL
	function Clockwork:UnbanSQL(identifier)
		local newidentifier = tmysql.escape(identifier);		
		tmysql.query("DELETE FROM bans WHERE _Identifier = '"..newidentifier.."'");
	end;
	
	-- A function to start a data stream.
	function Clockwork:StartDataStream(player, name, data)
		if (type(player) != "table") then
			if (!player) then
				player = _player.GetAll();
			else
				player = {player};
			end;
		end;
		
		local bShouldSend = false;
		local encodedData = glon.encode((data != nil and data or 0));
		local splitTable = self:SplitString(encodedData, 128);
		local players = RecipientFilter();
		
		for k, v in pairs(player) do
			if (type(v) == "Player") then
				players:AddPlayer(v);
				bShouldSend = true;
			elseif (type(k) == "Player") then
				players:AddPlayer(k);
				bShouldSend = true;
			end;
		end;
		
		if (#splitTable > 0 and bShouldSend) then
			umsg.Start("cwStartDS", players);
				umsg.String(name);
				umsg.String(splitTable[1]);
				umsg.Short(#splitTable);
			umsg.End();
			
			if (#splitTable > 1) then
				for k, v in ipairs(splitTable) do
					if (k > 1) then
						umsg.Start("cwDataDS", players);
							umsg.String(v);
							umsg.Short(k);
						umsg.End();
					end;
				end;
			end;
		end;
	end;
	
	-- A function to save schema data.
	function Clockwork:SaveSchemaData(fileName, data)
		fileio.Write(self:SetupFullDirectory("settings/Clockwork/schemas/"..self:GetSchemaFolder().."/"..fileName..".cw"), glon.encode(data));
	end;

	-- A function to delete schema data.
	function Clockwork:DeleteSchemaData(fileName)
		fileio.Delete(self:SetupFullDirectory("settings/Clockwork/schemas/"..self:GetSchemaFolder().."/"..fileName..".cw"));
	end;

	-- A function to check if schema data exists.
	function Clockwork:SchemaDataExists(fileName)
		return _file.Exists("../settings/Clockwork/schemas/"..self:GetSchemaFolder().."/"..fileName..".cw");
	end;
	
	-- A function to get the schema data path.
	function Clockwork:GetSchemaDataPath()
		return "../settings/Clockwork/schemas/"..self:GetSchemaFolder();
	end;

	-- A function to restore schema data.
	function Clockwork:RestoreSchemaData(fileName, failSafe)
		if (self:SchemaDataExists(fileName)) then
			local data = fileio.Read(
				self:SetupFullDirectory("settings/Clockwork/schemas/"..self:GetSchemaFolder().."/"..fileName..".cw")
			);
			
			if (data) then
				local success, value = pcall(glon.decode, data);
				
				if (success and value != nil) then
					return value;
				else
					local success, value = pcall(Json.Decode, data);
					
					if (success and value != nil) then
						return value;
					end;
				end;
			end;
		end;
		
		if (failSafe != nil) then
			return failSafe;
		else
			return {};
		end;
	end;

	-- A function to restore Clockwork data.
	function Clockwork:RestoreClockworkData(fileName, failSafe)
		if (self:ClockworkDataExists(fileName)) then
			local data = fileio.Read(self:SetupFullDirectory("settings/Clockwork/"..fileName..".cw"));
			
			if (data) then
				local success, value = pcall(glon.decode, data);
				
				if (success and value != nil) then
					return value;
				end;
			end;
		end;
		
		if (failSafe != nil) then
			return failSafe;
		else
			return {};
		end;
	end;
	
	-- A function to setup a full directory.
	function Clockwork:SetupFullDirectory(filePath)
		local directory = string.gsub(self:GetPathToGMod()..filePath, "\\", "/");
		local exploded = string.Explode("/", directory);
		local currentPath = "";
		
		for k, v in ipairs(exploded) do
			if (k < #exploded) then
				currentPath = currentPath..v.."/";
				fileio.MakeDirectory(currentPath);
			end;
		end;
		
		return currentPath..exploded[#exploded];
		//return "../"..filePath;
	end;

	-- A function to save Clockwork data.
	function Clockwork:SaveClockworkData(fileName, data)
		fileio.Write(self:SetupFullDirectory("settings/Clockwork/"..fileName..".cw"), glon.encode(data));
	end;

	-- A function to check if Clockwork data exists.
	function Clockwork:ClockworkDataExists(fileName)
		return _file.Exists("../settings/Clockwork/"..fileName..".cw");
	end;

	-- A function to delete Clockwork data.
	function Clockwork:DeleteClockworkData(fileName)
		fileio.Delete(self:SetupFullDirectory("settings/Clockwork/"..fileName..".cw"));
	end;

	-- A function to convert a force.
	function Clockwork:ConvertForce(force, limit)
		local forceLength = force:Length();
		
		if (forceLength == 0) then
			return Vector(0, 0, 0);
		end;
		
		if (!limit) then
			limit = 800;
		end;
		
		if (forceLength > limit) then
			return force / (forceLength / limit);
		else
			return force;
		end;
	end;
	
	-- A function to save a player's attribute boosts.
	function Clockwork:SavePlayerAttributeBoosts(player, data)
		local attributeBoosts = player:GetAttributeBoosts();
		local curTime = CurTime();
		
		if (data["AttrBoosts"]) then
			data["AttrBoosts"] = nil;
		end;
		
		if (table.Count(attributeBoosts) > 0) then
			data["AttrBoosts"] = {};
			
			for k, v in pairs(attributeBoosts) do
				data["AttrBoosts"][k] = {};
				
				for k2, v2 in pairs(v) do
					if (v2.duration) then
						if (curTime < v2.endTime) then
							data["AttrBoosts"][k][k2] = {
								duration = math.ceil(v2.endTime - curTime),
								amount = v2.amount
							};
						end;
					else
						data["AttrBoosts"][k][k2] = {
							amount = v2.amount
						};
					end;
				end;
			end;
		end;
	end;
	
	-- A function to calculate a player's spawn time.
	function Clockwork:CalculateSpawnTime(player, inflictor, attacker, damageInfo)
		local info = {
			attacker = attacker,
			inflictor = inflictor,
			spawnTime = self.config:Get("spawn_time"):Get(),
			damageInfo = damageInfo
		};

		self.plugin:Call("PlayerAdjustDeathInfo", player, info);

		if (info.spawnTime and info.spawnTime > 0) then
			self.player:SetAction(player, "spawn", info.spawnTime, 3);
		end;
	end;
	
	-- A function to create a decal.
	function Clockwork:CreateDecal(texture, position, temporary)
		local decal = ents.Create("infodecal");
		
		if (temporary) then
			decal:SetKeyValue("LowPriority", "true");
		end;
		
		decal:SetKeyValue("Texture", texture);
		decal:SetPos(position);
		decal:Spawn();
		decal:Fire("activate");
		
		return decal;
	end;
	
	-- A function to handle a player's weapon fire delay.
	function Clockwork:HandleWeaponFireDelay(player, bIsRaised, weapon, curTime)
		local delaySecondaryFire = nil;
		local delayPrimaryFire = nil;
		
		if (!self.plugin:Call("PlayerCanFireWeapon", player, bIsRaised, weapon, true)) then
			delaySecondaryFire = curTime + 60;
		end;
		
		if (!self.plugin:Call("PlayerCanFireWeapon", player, bIsRaised, weapon)) then
			delayPrimaryFire = curTime + 60;
		end;
		
		if (delaySecondaryFire == nil and weapon.secondaryFireDelayed) then
			weapon:SetNextSecondaryFire(weapon.secondaryFireDelayed);
			weapon.secondaryFireDelayed = nil;
		end;
		
		if (delayPrimaryFire == nil and weapon.primaryFireDelayed) then
			weapon:SetNextPrimaryFire(weapon.primaryFireDelayed);
			weapon.primaryFireDelayed = nil;
		end;
		
		if (delaySecondaryFire) then
			if (!weapon.secondaryFireDelayed) then
				weapon.secondaryFireDelayed = weapon:GetNextSecondaryFire();
			end;
			
			weapon:SetNextSecondaryFire(delaySecondaryFire);
		end;
		
		if (delayPrimaryFire) then
			if (!weapon.primaryFireDelayed) then
				weapon.primaryFireDelayed = weapon:GetNextPrimaryFire();
			end;
			
			weapon:SetNextPrimaryFire(delayPrimaryFire);
		end;
	end;
	
	-- A function to scale damage by hit group.
	function Clockwork:ScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, baseDamage)
		if (!damageInfo:IsFallDamage() and !damageInfo:IsDamageType(DMG_CRUSH)) then
			if (hitGroup == HITGROUP_HEAD) then
				damageInfo:ScaleDamage(self.config:Get("scale_head_dmg"):Get());
			elseif (hitGroup == HITGROUP_CHEST or hitGroup == HITGROUP_GENERIC) then
				damageInfo:ScaleDamage(self.config:Get("scale_chest_dmg"):Get());
			elseif (hitGroup == HITGROUP_LEFTARM or hitGroup == HITGROUP_RIGHTARM or hitGroup == HITGROUP_LEFTLEG
			or hitGroup == HITGROUP_RIGHTLEG or hitGroup == HITGROUP_GEAR) then
				damageInfo:ScaleDamage(self.config:Get("scale_limb_dmg"):Get());
			end;
		end;
		
		self.plugin:Call("PlayerScaleDamageByHitGroup", player, attacker, hitGroup, damageInfo, baseDamage);
	end;
	
	-- A function to calculate player damage.
	function Clockwork:CalculatePlayerDamage(player, hitGroup, damageInfo)
		local damageIsValid = damageInfo:IsBulletDamage() or damageInfo:IsDamageType(DMG_CLUB) or damageInfo:IsDamageType(DMG_SLASH);
		local hitGroupIsValid = true;
		
		if (self.config:Get("armor_chest_only"):Get()) then
			if (hitGroup != HITGROUP_CHEST and hitGroup != HITGROUP_GENERIC) then
				hitGroupIsValid = nil;
			end;
		end;
		
		if (player:Armor() > 0 and damageIsValid and hitGroupIsValid) then
			local armor = player:Armor() - damageInfo:GetDamage();
			
			if (armor < 0) then
				player:SetHealth(math.max(player:Health() - math.abs(armor), 1));
				player:SetArmor(math.max(armor, 0));
			else
				player:SetArmor(math.max(armor, 0));
			end;
		else
			player:SetHealth(math.max(player:Health() - damageInfo:GetDamage(), 1));
		end;
	end;
	
	-- A function to get a ragdoll's hit bone.
	function Clockwork:GetRagdollHitBone(entity, position, failSafe, minimum)
		local closest = {};
		
		for k, v in ipairs(self.HitGroupBonesCache) do
			local bone = entity:LookupBone(v[1]);
			
			if (bone) then
				local bonePosition = entity:GetBonePosition(bone);
				
				if (bonePosition) then
					local distance = bonePosition:Distance(position);
					
					if (!closest[1] or distance < closest[1]) then
						if (!minimum or distance <= minimum) then
							closest[1] = distance;
							closest[2] = bone;
						end;
					end;
				end;
			end;
		end;
		
		if (closest[2]) then
			return closest[2];
		else
			return failSafe;
		end;
	end;
	
	-- A function to get a ragdoll's hit group.
	function Clockwork:GetRagdollHitGroup(entity, position)
		local closest = {nil, HITGROUP_GENERIC};
		
		for k, v in ipairs(self.HitGroupBonesCache) do
			local bone = entity:LookupBone(v[1]);
			
			if (bone) then
				local bonePosition = entity:GetBonePosition(bone);
				
				if (position) then
					local distance = bonePosition:Distance(position);
					
					if (!closest[1] or distance < closest[1]) then
						closest[1] = distance;
						closest[2] = v[2];
					end;
				end;
			end;
		end;
		
		return closest[2];
	end;

	-- A function to create blood effects at a position.
	function Clockwork:CreateBloodEffects(position, decals, entity, force)
		if (!force) then
			force = VectorRand() * 80;
		end;
		
		local effectData = EffectData();
			effectData:SetOrigin(position);
			effectData:SetNormal(force);
			effectData:SetScale(0.5);
		util.Effect("cw_bloodsmoke", effectData, true, true);
		
		local effectData = EffectData();
			effectData:SetOrigin(position);
			effectData:SetEntity(entity);
			effectData:SetStart(position);
			effectData:SetScale(0.5);
		util.Effect("BloodImpact", effectData, true, true);
		
		for i = 1, decals do
			local trace = {};
				trace.start = position;
				trace.endpos = trace.start;
				trace.filter = entity;
			trace = util.TraceLine(trace);
			
			util.Decal("Blood", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal);
		end;
	end;
	
	-- A function to do the entity take damage hook.
	function Clockwork:DoEntityTakeDamageHook(arguments)
		if (arguments[4] != arguments[5]:GetDamage()) then
			arguments[4] = arguments[5]:GetDamage();
		end;
		
		local player = self.entity:GetPlayer(arguments[1]);
		
		if (player) then
			local ragdoll = player:GetRagdollEntity();
			
			if (!hook.Call("PlayerShouldTakeDamage", self, player, arguments[3], arguments[2], arguments[5])
			or player:IsInGodMode()) then
				arguments[5]:SetDamage(0);
				return true;
			end;
			
			if (ragdoll and arguments[1] != ragdoll) then
				hook.Call("EntityTakeDamage", self, ragdoll, arguments[2], arguments[3], arguments[4], arguments[5]);
				arguments[5]:SetDamage(0);
				
				return true;
			end;
			
			if (arguments[1] == ragdoll) then
				local physicsObject = arguments[1]:GetPhysicsObject();
				
				if (IsValid(physicsObject)) then
					local velocity = physicsObject:GetVelocity():Length();
					local curTime = CurTime();
					
					if (arguments[5]:IsDamageType(DMG_CRUSH)) then
						if (arguments[1].cwNextFallDamage
						and curTime < arguments[1].cwNextFallDamage) then
							arguments[5]:SetDamage(0);
							return true;
						end;
						
						arguments[4] = hook.Call("GetFallDamage", self, player, velocity);
						arguments[1].cwNextFallDamage = curTime + 1;
						arguments[5]:SetDamage(arguments[4])
					end;
				end;
			end;
		end;
	end;
	
	-- A function to perform the date and time think.
	function Clockwork:PerformDateTimeThink()
		local defaultDays = self.option:GetKey("default_days");
		local minute = self.time:GetMinute();
		local month = self.date:GetMonth();
		local year = self.date:GetYear();
		local hour = self.time:GetHour();
		local day = self.time:GetDay();
		
		self.time.minute = self.time:GetMinute() + 1;
		
		if (self.time:GetMinute() == 60) then
			self.time.minute = 0;
			self.time.hour = self.time:GetHour() + 1;
			
			if (self.time:GetHour() == 24) then
				self.time.hour = 0;
				self.time.day = self.time:GetDay() + 1;
				self.date.day = self.date:GetDay() + 1;
				
				if (self.time:GetDay() == #defaultDays + 1) then
					self.time.day = 1;
				end;
				
				if (self.date:GetDay() == 31) then
					self.date.day = 1;
					self.date.month = self.date:GetMonth() + 1;
					
					if (self.date:GetMonth() == 13) then
						self.date.month = 1;
						self.date.year = self.date:GetYear() + 1;
					end;
				end;
			end;
		end;
		
		if (self.time:GetMinute() != minute) then
			self.plugin:Call("TimePassed", TIME_MINUTE);
		end;
		
		if (self.time:GetHour() != hour) then
			self.plugin:Call("TimePassed", TIME_HOUR);
		end;
		
		if (self.time:GetDay() != day) then
			self.plugin:Call("TimePassed", TIME_DAY);
		end;
		
		if (self.date:GetMonth() != month) then
			self.plugin:Call("TimePassed", TIME_MONTH);
		end;
		
		if (self.date:GetYear() != year) then
			self.plugin:Call("TimePassed", TIME_YEAR);
		end;
		
		local month = self:ZeroNumberToDigits(self.date:GetMonth(), 2);
		local day = self:ZeroNumberToDigits(self.date:GetDay(), 2);
		
		self:SetSharedVar("Minute", self.time:GetMinute());
		self:SetSharedVar("Hour", self.time:GetHour());
		self:SetSharedVar("Date", day.."/"..month.."/"..self.date:GetYear());
		self:SetSharedVar("Day", self.time:GetDay());
	end;
	
	-- A function to create a ConVar.
	function Clockwork:CreateConVar(name, value, flags, Callback)
		local conVar = CreateConVar(name, value, flags or FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE);
		
		cvars.AddChangeCallback(name, function(conVar, previousValue, newValue)
			self.plugin:Call("ClockworkConVarChanged", conVar, previousValue, newValue);
			
			if (Callback) then
				Callback(conVar, previousValue, newValue);
			end;
		end);
		
		return conVar;
	end;
	
	-- A function to check if the server is shutting down.
	function Clockwork:IsShuttingDown()
		return self.ShuttingDown;
	end;
	
	-- A function to distribute wages cash.
	function Clockwork:DistributeWagesCash()
		for k, v in ipairs(_player.GetAll()) do
			if (v:HasInitialized() and v:Alive()) then
				local wages = v:GetWages();
				
				if (self.plugin:Call("PlayerCanEarnWagesCash", v, wages)) then
					if (wages > 0) then
						if (self.plugin:Call("PlayerGiveWagesCash", v, wages, v:GetWagesName())) then
							self.player:GiveCash(v, wages, v:GetWagesName());
						end;
					end;
					
					self.plugin:Call("PlayerEarnWagesCash", v, wages);
				end;
			end;
		end;
	end;
	
	-- A function to distribute generator cash.
	function Clockwork:DistributeGeneratorCash()
		local generatorEntities = {};
		
		for k, v in pairs(self.generator:GetAll()) do
			table.Add(generatorEntities, ents.FindByClass(k));
		end;
		
		for k, v in pairs(generatorEntities) do
			local generator = self.generator:Get(v:GetClass());
			local player = v:GetPlayer();
			
			if (IsValid(player) and v:GetPower() != 0) then
				local info = {
					generator = generator,
					entity = v,
					cash = generator.cash,
					name = "Generator"
				};
				
				v:SetDTInt("Power", math.max(v:GetPower() - 1, 0));
				self.plugin:Call("PlayerAdjustEarnGeneratorInfo", player, info);
				
				if (self.plugin:Call("PlayerCanEarnGeneratorCash", player, info, info.cash)) then
					if (v.OnEarned) then
						local result = v:OnEarned(player, info.cash);
						
						if (type(result) == "number") then
							info.cash = result;
						end;
						
						if (result != false) then
							if (result != true) then
								self.player:GiveCash(k, info.cash, info.name);
							end;
							
							self.plugin:Call("PlayerEarnGeneratorCash", player, info, info.cash);
						end;
					else
						self.player:GiveCash(k, info.cash, info.name);
						self.plugin:Call("PlayerEarnGeneratorCash", player, info, info.cash);
					end;
				end;
			end;
		end;
	end;
	
	-- A function to include the schema.
	function Clockwork:IncludeSchema()
		local schemaFolder = self:GetSchemaFolder();
		
		if (schemaFolder and type(schemaFolder) == "string") then
			self.config:Load(nil, true);
				self.plugin:Include(schemaFolder.."/gamemode", true);
			self.config:Load();
		end;
	end;
	
	-- A function to print a log message.
	function Clockwork:PrintLog(logType, text)
		local recipientFilter = RecipientFilter();
		
		for k, v in ipairs(_player.GetAll()) do
			if (v:HasInitialized() and v:GetInfoNum("cwShowLog", 0) == 1) then
				if (self.player:IsAdmin(v)) then
					recipientFilter:AddPlayer(v);
				end;
			end;
		end;
		
		umsg.Start("cwLog", recipientFilter);
			umsg.Short(logType or 5);
			umsg.String(text);
		umsg.End();
		
		if (CW_CONVAR_LOG:GetInt() == 1 and isDedicatedServer()) then
			self:ServerLog(text);
		end;
	end;
	
	-- A function to log to the server.
	function Clockwork:ServerLog(text)
		ServerLog(text.."\n");
		
		if (isDedicatedServer()) then
			print(text);
		end;
	end;
else
	Clockwork.ProgressBarColor = Color(50, 100, 150, 200);
	Clockwork.TargetPlayerText = { text = {}};
	Clockwork.BackgroundBlurs = {};
	Clockwork.RecognisedNames = {};
	Clockwork.PlayerInfoText = { text = {}, width = 0, subText = {}};
	Clockwork.NetworkProxies = {};
	Clockwork.InfoMenuOpen = false;
	Clockwork.ColorModify = {};
	Clockwork.ClothesData = {};
	Clockwork.Cinematics = {};
	Clockwork.MenuItems = { items = {}};
	Clockwork.ESPInfo = {};
	Clockwork.Hints = {};
	Clockwork.Bars = { x = 0, y = 0, width = 0, height = 0, bars = {}};

	-- A function to register a network proxy.
	function Clockwork:RegisterNetworkProxy(entity, name, Callback)
		if (!self.NetworkProxies[entity]) then
			self.NetworkProxies[entity] = {};
		end;
		
		self.NetworkProxies[entity][name] = {
			Callback = Callback,
			oldValue = nil
		};
	end;
	
	-- A function to get whether the info menu is open.
	function Clockwork:IsInfoMenuOpen()
		return self.InfoMenuOpen;
	end;
	
	-- A function to get a menu item.
	function Clockwork.MenuItems:Get(text)
		for k, v in pairs(self.items) do
			if (v.text == text) then
				return v;
			end;
		end;
	end;
	
	-- A function to add a menu item.
	function Clockwork.MenuItems:Add(text, panel, tip)
		self.items[#self.items + 1] = {text = text, panel = panel, tip = tip};
	end;

	-- A function to destroy a menu item.
	function Clockwork.MenuItems:Destroy(text)
		for k, v in pairs(self.items) do
			if (v.text == text) then
				table.remove(self.items, k);
			end;
		end;
	end;
	
	-- A function to add some target player text.
	function Clockwork.TargetPlayerText:Add(uniqueID, text, color)
		self.text[#self.text + 1] = {
			uniqueID = uniqueID,
			color = color,
			text = text
		};
	end;
	
	-- A function to get some target player text.
	function Clockwork.TargetPlayerText:Get(uniqueID)
		for k, v in pairs(self.text) do
			if (v.uniqueID == uniqueID) then
				return v;
			end;
		end;
	end;

	-- A function to destroy some target player text.
	function Clockwork.TargetPlayerText:Destroy(uniqueID)
		for k, v in pairs(self.text) do
			if (v.uniqueID == uniqueID) then
				table.remove(self.text, k);
			end;
		end;
	end;
	
	-- A function to get whether any player info text exists.
	function Clockwork.PlayerInfoText:DoesAnyExist()
		return (#self.text > 0 or #self.subText > 0);
	end;

	-- A function to add some player info text.
	function Clockwork.PlayerInfoText:Add(uniqueID, text)
		if (text) then
			self.text[#self.text + 1] = {
				uniqueID = uniqueID,
				text = text
			};
		end;
	end;
	
	-- A function to get some player info text.
	function Clockwork.PlayerInfoText:Get(uniqueID)
		for k, v in pairs(self.text) do
			if (v.uniqueID == uniqueID) then
				return v;
			end;
		end;
	end;

	-- A function to add some sub player info text.
	function Clockwork.PlayerInfoText:AddSub(uniqueID, text, priority)
		if (text) then
			self.subText[#self.subText + 1] = {
				priority = priority or 0,
				uniqueID = uniqueID,
				text = text
			};
		end;
	end;
	
	-- A function to get some sub player info text.
	function Clockwork.PlayerInfoText:GetSub(uniqueID)
		for k, v in pairs(self.subText) do
			if (v.uniqueID == uniqueID) then
				return v;
			end;
		end;
	end;

	-- A function to destroy some player info text.
	function Clockwork.PlayerInfoText:Destroy(uniqueID)
		for k, v in pairs(self.text) do
			if (v.uniqueID == uniqueID) then
				table.remove(self.text, k);
			end;
		end;
	end;

	-- A function to destroy some sub player info text.
	function Clockwork.PlayerInfoText:DestroySub(uniqueID)
		for k, v in pairs(self.subText) do
			if (v.uniqueID == uniqueID) then
				table.remove(self.subText, k);
			end;
		end;
	end;

	-- A function to get a top bar.
	function Clockwork.Bars:Get(uniqueID)
		for k, v in pairs(self.bars) do
			if (v.uniqueID == uniqueID) then return v; end;
		end;
	end;
	
	-- A function to add a top bar.
	function Clockwork.Bars:Add(uniqueID, color, text, value, maximum, flash, priority)
		self.bars[#self.bars + 1] = {
			uniqueID = uniqueID,
			priority = priority or 0,
			maximum = maximum,
			color = color,
			class = class,
			value = value,
			flash = flash,
			text = text,
		};
	end;

	-- A function to destroy a top bar.
	function Clockwork.Bars:Destroy(uniqueID)
		for k, v in pairs(self.bars) do
			if (v.uniqueID == uniqueID) then
				table.remove(self.bars, k);
			end;
		end;
	end;
	
	-- A function to create a client ConVar.
	function Clockwork:CreateClientConVar(name, value, save, userData, Callback)
		local conVar = CreateClientConVar(name, value, save, userData);
		
		cvars.AddChangeCallback(name, function(conVar, previousValue, newValue)
			self.plugin:Call("ClockworkConVarChanged", conVar, previousValue, newValue);
			
			if (Callback) then
				Callback(conVar, previousValue, newValue);
			end;
		end);
		
		return conVar;
	end;
	
	-- A function to get the size of text.
	function Clockwork:GetTextSize(font, text)
		local defaultWidth, defaultHeight = self:GetCachedTextSize(font, "U");
		local height = defaultHeight;
		local width = 0;
		
		for i = 1, string.len(text) do
			local textWidth, textHeight = self:GetCachedTextSize(font, string.sub(text, i, i));
			
			if (textWidth == 0) then
				textWidth = defaultWidth;
			end;
			
			if (textHeight > height) then
				height = textHeight;
			end;
			
			width = width + textWidth;
		end;
		
		return width, height;
	end;
	
	-- A function to calculate alpha from a distance.
	function Clockwork:CalculateAlphaFromDistance(maximum, start, finish)
		if (type(start) == "Player") then
			start = start:GetShootPos();
		elseif (type(start) == "Entity") then
			start = start:GetPos();
		end;
		
		if (type(finish) == "Player") then
			finish = finish:GetShootPos();
		elseif (type(finish) == "Entity") then
			finish = finish:GetPos();
		end;
		
		return math.Clamp(255 - ((255 / maximum) * (start:Distance(finish))), 0, 255);
	end;
	
	-- A function to wrap text into a table.
	function Clockwork:WrapText(text, font, width, baseTable)
		if (width <= 0 or !text or text == "") then
			return;
		end;
		
		if (self:GetTextSize(font, text) > width) then
			local length = 0;
			local exploded = {};
			local seperator = "";
			
			if (string.find(text, " ")) then	
				exploded = string.Explode(" ", text);
				seperator = " ";
			else
				exploded = string.ToTable(text);
				seperator = "";
			end;
			
			local i = 1;
			
			while (length < width) do
				if (!exploded[i]) then
					break;
				end;
				
				length = self:GetTextSize(font, table.concat(exploded, seperator, 1, i));
				
				i = i + 1;
			end;
			
			baseTable[#baseTable + 1] = table.concat(exploded, seperator, 1, i - 2);
			
			text = table.concat(exploded, seperator, i - 1);
			
			if (self:GetTextSize(font, text) > width) then
				self:WrapText(text, font, width, baseTable);
			else
				baseTable[#baseTable + 1] = text;
			end;
		else
			baseTable[#baseTable + 1] = text;
		end;
	end;
	
	-- A function to handle an entity's menu.
	function Clockwork:HandleEntityMenu(entity)
		local options = {};
			self.plugin:Call("GetEntityMenuOptions", entity, options);
		if (table.Count(options) == 0) then return; end;
		
		if (table.Count(options) == 1) then
			self.entity:ForceMenuOption(entity, table.GetFirstKey(options), table.GetFirstValue(options));
			return;
		end;

		local menu = self:AddMenuFromData(nil, options, function(menu, option, arguments)
			menu:AddOption(option, function()
				if (type(arguments) == "table" and arguments.isArgTable) then
					if (arguments.Callback) then
						arguments.Callback(function(arguments)
							self.entity:ForceMenuOption(entity, option, arguments);
						end);
					else
						self.entity:ForceMenuOption(entity, option, arguments.arguments);
					end;
				else
					self.entity:ForceMenuOption(entity, option, arguments);
				end;
				
				timer.Simple(FrameTime(), function()
					self:RemoveActiveToolTip();
				end);
			end);
			
			local panel = menu.Items[#menu.Items];
			
			if (IsValid(panel)) then
				if (type(arguments) == "table") then
					if (arguments.isOrdered) then
						menu.Items[#menu.Items] = nil;
						table.insert(menu.Items, 1, panel);
					end;
					
					if (arguments.toolTip) then
						self:CreateMarkupToolTip(panel);
						panel:SetMarkupToolTip(arguments.toolTip);
					end;
				end;
			end;
		end);
		
		self:RegisterBackgroundBlur( menu, SysTime() );
		return menu;
	end;
	
	-- A function to get the gradient texture.
	function Clockwork:GetGradientTexture()
		return self.GradientTexture;
	end;
	
	-- A function to add a menu from data.
	function Clockwork:AddMenuFromData(menu, data, Callback)
		local bCreated = false;
		local options = {};
		
		if (!menu) then
			bCreated = true;
			menu = DermaMenu();
		end;
		
		for k, v in pairs(data) do
			options[#options + 1] = {k, v};
		end;
		
		table.sort(options, function(a, b)
			return a[1] < b[1];
		end);
		
		for k, v in pairs(options) do
			if (type(v[2]) == "table" and !v[2].isArgTable) then
				if (table.Count(v[2]) > 0) then
					self:AddMenuFromData(menu:AddSubMenu(v[1]), v[2], Callback);
				end;
			elseif (type(v[2]) == "function") then
				menu:AddOption(v[1], v[2]);
			elseif (Callback) then
				Callback(menu, v[1], v[2]);
			end;
		end;
		
		if (bCreated) then
			if (#options > 0) then
				menu:Open();
			else
				menu:Remove();
			end;
			
			return menu;
		end;
	end;
	
	-- A function to adjust the width of text.
	function Clockwork:AdjustMaximumWidth(font, text, width, addition, extra)
		local textString = tostring(Clockwork:Replace(text, "&", "U"));
		local textWidth = self:GetCachedTextSize(font, textString) + (extra or 0);
		
		if (textWidth > width) then
			width = textWidth + (addition or 0);
		end;
		
		return width;
	end;
	
	-- A function to add a top hint.
	function Clockwork:AddTopHint(text, delay, color, noSound)
		local colorWhite = self.option:GetColor("white");
		
		if (color) then
			if (type(color) == "string") then
				color = self.option:GetColor(color);
			end;
		else
			color = colorWhite;
		end;
		
		for k, v in ipairs(self.Hints) do
			if (v.text == text) then
				return;
			end;
		end;
		
		if (table.Count(self.Hints) == 10) then
			table.remove(self.Hints, 10);
		end;
		
		if (!noSound) then
			self.option:PlaySound("rollover");
		end;
		
		table.insert(self.Hints, 1, {
			targetAlpha = 255,
			alphaSpeed = 64,
			color = color,
			delay = delay,
			alpha = 0,
			text = text
		});
	end;
	
	-- A function to calculate the top hints.
	function Clockwork:CalculateHints()
		local frameTime = FrameTime();
		local curTime = UnPredictedCurTime();
		
		for k, v in pairs(self.Hints) do
			if (!v.nextChangeTarget or curTime >= v.nextChangeTarget) then
				v.alpha = math.Approach(v.alpha, v.targetAlpha, v.alphaSpeed * frameTime);
				
				if (v.alpha == v.targetAlpha) then
					if (v.targetAlpha == 0) then
						table.remove(self.Hints, k);
					else
						v.nextChangeTarget = curTime + v.delay;
						v.targetAlpha = 0;
						v.alphaSpeed = 16;
					end;
				end;
			end;
		end;
	end;
	
	-- A function to draw the date and time.
	function Clockwork:DrawDateTime()
		local backgroundColor = self.option:GetColor("background");
		local mainTextFont = self.option:GetFont("main_text");
		local colorWhite = self.option:GetColor("white");
		local colorInfo = self.option:GetColor("information");
		local scrW = ScrW();
		local scrH = ScrH();
		local info = {
			width = scrW * 0.2,
			x = scrW / 2,
			y = scrH * 0.2
		};
		
		info.originalX = info.x;
		info.originalY = info.y;
		
		if (self.LastDateTimeInfo and self.LastDateTimeInfo.y > info.y) then
			local height = (self.LastDateTimeInfo.y - info.y) + 8;
			local width = self.LastDateTimeInfo.width + 16;
			local x = self.LastDateTimeInfo.x - (self.LastDateTimeInfo.width / 2) - 8;
			local y = self.LastDateTimeInfo.y - height;
			
			self:OverrideMainFont(self.option:GetFont("menu_text_tiny"));
				self:DrawInfo("CHARACTER AND ROLEPLAY INFO", x, y + 4, colorInfo, nil, true, function(x, y, width, height)
					return x, y - height;
				end);
			
				self:DrawSimpleGradientBox(2, x, y + 8, width, height, backgroundColor);
				y = y + height + 16;
				
				if (self:CanCreateInfoMenuPanel() and self:IsInfoMenuOpen()) then
					local menuPanelX = x;
					local menuPanelY = y;
					
					self:DrawInfo("SELECT A QUICK MENU OPTION", x, y, colorInfo, nil, true, function(x, y, width, height)
						menuPanelY = menuPanelY + height + 4;
						return x, y;
					end);
					
					self:CreateInfoMenuPanel(menuPanelX, menuPanelY, width);
					self:DrawSimpleGradientBox(2, self.InfoMenuPanel.x - 4, self.InfoMenuPanel.y - 4, self.InfoMenuPanel:GetWide() + 8, self.InfoMenuPanel:GetTall() + 8, backgroundColor);
					self.InfoMenuPanel:SetSize(width, self.InfoMenuPanel:GetTall());
					
					if (!self.InfoMenuPanel.VisibilitySet) then
						self.InfoMenuPanel.VisibilitySet = true;
						
						timer.Simple(FrameTime() * 2, function()
							if (IsValid(self.InfoMenuPanel)) then
								self.InfoMenuPanel:SetVisible(true);
							end;
						end);
					end;
				end;
			self:OverrideMainFont(false);
		end;
		
		if (self.plugin:Call("PlayerCanSeeDateTime")) then
			local dateTimeFont = self.option:GetFont("date_time_text");
			local dateString = self.date:GetString();
			local timeString = self.time:GetString();
			
			if (dateString and timeString) then
				local dayName = self.time:GetDayName();
				local text = string.upper(dateString..". "..dayName..", "..timeString..".");
				
				self:OverrideMainFont(dateTimeFont);
					info.y = self:DrawInfo(text, info.x, info.y, colorWhite, 255);
				self:OverrideMainFont(false);
				
				local textWidth, textHeight = Clockwork:GetCachedTextSize(dateTimeFont, text);
				
				if (textWidth and textHeight) then
					info.width = textWidth;
				end;
			end;
		end;
		
		self:DrawBars(info, "tab");
			self.plugin:Call("ClockworkDateTimeDrawn", info);
		self.PlayerInfoBox = self:DrawPlayerInfo(info);
		
		self.LastDateTimeInfo = info;
		
		if (self.plugin:Call("PlayerCanSeeLimbDamage")) then
			local tipHeight = 0;
			local tipWidth = 0;
			local limbInfo = {};
			local height = 192;
			local width = 96;
			local texInfo = {
				shouldDisplay = true,
				textures = {
					[HITGROUP_RIGHTARM] = self.limb:GetTexture(HITGROUP_RIGHTARM),
					[HITGROUP_RIGHTLEG] = self.limb:GetTexture(HITGROUP_RIGHTLEG),
					[HITGROUP_LEFTARM] = self.limb:GetTexture(HITGROUP_LEFTARM),
					[HITGROUP_LEFTLEG] = self.limb:GetTexture(HITGROUP_LEFTLEG),
					[HITGROUP_STOMACH] = self.limb:GetTexture(HITGROUP_STOMACH),
					[HITGROUP_CHEST] = self.limb:GetTexture(HITGROUP_CHEST),
					[HITGROUP_HEAD] = self.limb:GetTexture(HITGROUP_HEAD),
					["body"] = self.limb:GetTexture("body")
				},
				names = {
					[HITGROUP_RIGHTARM] = self.limb:GetName(HITGROUP_RIGHTARM),
					[HITGROUP_RIGHTLEG] = self.limb:GetName(HITGROUP_RIGHTLEG),
					[HITGROUP_LEFTARM] = self.limb:GetName(HITGROUP_LEFTARM),
					[HITGROUP_LEFTLEG] = self.limb:GetName(HITGROUP_LEFTLEG),
					[HITGROUP_STOMACH] = self.limb:GetName(HITGROUP_STOMACH),
					[HITGROUP_CHEST] = self.limb:GetName(HITGROUP_CHEST),
					[HITGROUP_HEAD] = self.limb:GetName(HITGROUP_HEAD),
				}
			};
			local x = info.x + (info.width / 2) + 32;
			local y = info.originalY + 8;
			
			Clockwork.plugin:Call("GetPlayerLimbInfo", texInfo);
			
			if (texInfo.shouldDisplay) then
				surface.SetDrawColor(255, 255, 255, 150);
				surface.SetTexture(texInfo.textures["body"]);
				surface.DrawTexturedRect(x, y, width, height);
				
				for k, v in pairs(self.limb.hitGroups) do
					local limbHealth = self.limb:GetHealth(k);
					local limbColor = self.limb:GetColor(limbHealth);
					local newIndex = #limbInfo + 1;
					
					surface.SetDrawColor(limbColor.r, limbColor.g, limbColor.b, 150);
					surface.SetTexture(texInfo.textures[k]);
					surface.DrawTexturedRect(x, y, width, height);
					
					limbInfo[newIndex] = {
						color = limbColor,
						text = texInfo.names[k]..": "..limbHealth.."%"
					};
					
					local textWidth, textHeight = self:GetCachedTextSize(mainTextFont, limbInfo[newIndex].text);
					tipHeight = tipHeight + textHeight + 4;
					
					if (textWidth > tipWidth) then
						tipWidth = textWidth;
					end;
					
					limbInfo[newIndex].textHeight = textHeight;
				end;
				
				local mouseX = gui.MouseX();
				local mouseY = gui.MouseY();
				
				if (mouseX >= x and mouseX <= x + width
				and mouseY >= y and mouseY <= y + height) then
					local tipX = mouseX + 16;
					local tipY = mouseY + 16;
					
					self:DrawSimpleGradientBox(2, tipX - 8, tipY - 8, tipWidth + 16, tipHeight + 12, backgroundColor);
					
					for k, v in pairs(limbInfo) do
						self:DrawInfo(v.text, tipX, tipY, v.color, 255, true);
						
						if (k < #limbInfo) then
							tipY = tipY + v.textHeight + 4;
						else
							tipY = tipY + v.textHeight;
						end;
					end;
				end;
			end;
		end;
	end;

	-- A function to draw the top hints.
	function Clockwork:DrawHints()
		local scrW, scrH = ScrW(), ScrH();
		local x = scrW;
		local y = 8;
		
		if (self.plugin:Call("PlayerCanSeeHints") and #self.Hints > 0) then
			local hintsFont = self.option:GetFont("hints_text");
			local fontWidth, fontHeight = self:GetCachedTextSize(hintsFont, "U");
			
			if (self.LastHintAlpha) then
				self:DrawGradient(
					GRADIENT_DOWN, 0, 0, scrW, (fontHeight + 4) * (#self.Hints + 1), Color(50, 50, 50, math.min(self.LastHintAlpha, 150))
				);
			end;
			
			self.LastHintAlpha = 0;
			
			for k, v in ipairs(self.Hints) do
				self:OverrideMainFont(hintsFont);
					y = self:DrawInfo(string.upper(v.text), x, y, v.color, v.alpha, true, function(x, y, width, height)
						return x - width - 8, y;
					end);
				self:OverrideMainFont(false);
				
				if (v.alpha > self.LastHintAlpha) then
					self.LastHintAlpha = v.alpha;
				end;
			end;
		end;
	end;

	-- A function to draw the top bars.
	function Clockwork:DrawBars(info, class)
		if (self.plugin:Call("PlayerCanSeeBars", class)) then
			local barTextFont = self.option:GetFont("bar_text");
			
			self.Bars.width = info.width;
			self.Bars.height = 16;
			self.Bars.y = info.y;
			
			if (class == "tab") then
				self.Bars.x = info.x - (info.width / 2);
			else
				self.Bars.x = info.x;
			end;
			
			self.option:SetFont("bar_text", self.option:GetFont("auto_bar_text"));
				for k, v in ipairs(self.Bars.bars) do
					self.Bars.y = self:DrawBar(self.Bars.x, self.Bars.y, self.Bars.width, self.Bars.height, v.color, v.text, v.value, v.maximum, v.flash) + (self.Bars.height + 2);
				end;
			self.option:SetFont("bar_text", barTextFont);
			
			info.y = self.Bars.y;
		end;
	end;
	
	-- A function to get the ESP info.
	function Clockwork:GetESPInfo()
		return self.ESPInfo;
	end;
	
	-- A function to draw the admin ESP.
	function Clockwork:DrawAdminESP()
		local colorWhite = self.option:GetColor("white");
		local curTime = UnPredictedCurTime();
		
		if (!self.NextGetESPInfo) then
			self.NextGetESPInfo = curTime + 0.25;
		end;
		
		if (curTime >= self.NextGetESPInfo) then
			self.NextGetESPInfo = curTime + 0.25;
			self.ESPInfo = {};
			
			self.plugin:Call("GetAdminESPInfo", self.ESPInfo);
		end;
		
		for k, v in pairs(self.ESPInfo) do
			local position = v.position:ToScreen();
			
			if (position) then
				self:DrawSimpleText(v.text, position.x, position.y, v.color or colorWhite, 1, 1);
			end;
		end;
	end;

	-- A function to draw a bar with a value and a maximum.
	function Clockwork:DrawBar(x, y, width, height, color, text, value, maximum, flash, barInfo)
		local backgroundColor = self.option:GetColor("background");
		local progressWidth = math.Clamp(((width - 2) / maximum) * value, 0, width - 2);
		local colorWhite = self.option:GetColor("white");
		local newBarInfo = {
			progressWidth = progressWidth,
			drawBackground = true,
			drawProgress = true,
			cornerSize = 4,
			maximum = maximum,
			height = height,
			width = width,
			color = color,
			value = value,
			flash = flash,
			text = text,
			x = x,
			y = y
		};

		if (barInfo) then
			for k, v in pairs(newBarInfo) do
				if (!barInfo[k]) then
					barInfo[k] = v;
				end;
			end;
		else
			barInfo = newBarInfo;
		end;

		if (!self.plugin:Call("PreDrawBar", barInfo)) then
			if (barInfo.drawBackground) then
				self:DrawTexturedGradientBox(barInfo.cornerSize, barInfo.x, barInfo.y, barInfo.width, barInfo.height, backgroundColor);
			end;

			if (barInfo.drawProgress) then
    				self:DrawTexturedGradientBox(0, barInfo.x + 1, barInfo.y + 1, barInfo.progressWidth, barInfo.height - 2, barInfo.color);
			end;

			if (barInfo.flash) then
	        	local alpha = math.Clamp(math.abs(math.sin(UnPredictedCurTime()) * 50), 0, 50);
			        
		        if (alpha > 0) then
	                draw.RoundedBox(0, barInfo.x + 2, barInfo.y + 2, barInfo.width - 4, barInfo.height - 4, Color(colorWhite.r, colorWhite.g, colorWhite.b, alpha));
		        end;
			end;
		end;

		if (!self.plugin:Call("PostDrawBar", barInfo)) then
	        if (barInfo.text and barInfo.text != "") then
                self:OverrideMainFont(self.option:GetFont("bar_text"));
            		self:DrawSimpleText(barInfo.text, barInfo.x + (barInfo.width / 2), barInfo.y + (barInfo.height / 2), Color(colorWhite.r, colorWhite.g, colorWhite.b, alpha), 1, 1);
                self:OverrideMainFont(false);
	        end;
		end;

		return barInfo.y;
	end;

	-- A function to set the recognise menu.
	function Clockwork:SetRecogniseMenu(menu)
		self.RecogniseMenu = menu;
	end;
	
	-- A function to get the recognise menu.
	function Clockwork:GetRecogniseMenu(menu)
		return self.RecogniseMenu;
	end;
	
	-- A function to override the main font.
	function Clockwork:OverrideMainFont(font)
		if (font) then
			if (!self.PreviousMainFont) then
				self.PreviousMainFont = self.option:GetFont("main_text");
			end;
			
			self.option:SetFont("main_text", font);
		elseif (self.PreviousMainFont) then
			self.option:SetFont("main_text", self.PreviousMainFont)
		end;
	end;

	-- A function to get the screen's center.
	function Clockwork:GetScreenCenter()
		return ScrW() / 2, (ScrH() / 2) + 32;
	end;
	
	-- A function to draw some simple text.
	function Clockwork:DrawSimpleText(text, x, y, color, alignX, alignY, shadowless, shadowDepth)
		local mainTextFont = self.option:GetFont("main_text");
		local realX = math.Round(x);
		local realY = math.Round(y);
		
		if (!shadowless) then
			local outlineColor = Color(25, 25, 25, math.min(225, color.a));
			
			for i = 1, (shadowDepth or 1) do
				draw.SimpleText(text, mainTextFont, realX + -i, realY + -i, outlineColor, alignX, alignY);
				draw.SimpleText(text, mainTextFont, realX + -i, realY + i, outlineColor, alignX, alignY);
				draw.SimpleText(text, mainTextFont, realX + i, realY + -i, outlineColor, alignX, alignY);
				draw.SimpleText(text, mainTextFont, realX + i, realY + i, outlineColor, alignX, alignY);
			end;
		end;
		
		draw.SimpleText(text, mainTextFont, realX, realY, color, alignX, alignY);
		local width, height = self:GetCachedTextSize(mainTextFont, text);
		
		return realY + height + 2, width;
	end;
	
	-- A function to get the black fade alpha.
	function Clockwork:GetBlackFadeAlpha()
		return self.BlackFadeIn or self.BlackFadeOut or 0;
	end;
	
	-- A function to get whether the screen is faded black.
	function Clockwork:IsScreenFadedBlack()
		return (self.BlackFadeIn == 255);
	end;
	
	--[[ 
		A function to print colored text to the console.
		Sure, it's hacky, but Garry is being a douche.
	--]]
	function Clockwork:PrintColoredText(...)
		local currentColor = nil;
		local colorWhite = Clockwork.option:GetColor("white");
		local text = {};
		
		for k, v in ipairs({...}) do
			if (type(v) == "Player") then
				text[#text + 1] = _team.GetColor(v:Team());
				text[#text + 1] = v:Name();
			elseif (type(v) == "table") then
				currentColor = v;
			elseif (currentColor) then
				text[#text + 1] = currentColor;
				text[#text + 1] = v;
				currentColor = nil;
			else
				text[#text + 1] = colorWhite;
				text[#text + 1] = v;
			end;
		end;
		
		chat.ClockworkAddText(unpack(text));
	end;
	
	-- A function to get whether a custom crosshair is used.
	function Clockwork:UsingCustomCrosshair()
		return self.CustomCrosshair;
	end;
	
	-- A function to get a cached text size.
	function Clockwork:GetCachedTextSize(font, text)
		local len = string.len(text);
		text = string.sub(text, 1, 99);
		if (!self.CachedTextSizes) then
			self.CachedTextSizes = {};
		end;
		
		if (!self.CachedTextSizes[font]) then
			self.CachedTextSizes[font] = {};
		end;
		
		if (!self.CachedTextSizes[font][text]) then
			surface.SetFont(font);
			
			self.CachedTextSizes[font][text] = { surface.GetTextSize(text) };
		end;
		
		return unpack(self.CachedTextSizes[font][text]);
	end;
	
	-- A function to draw information at a position.
	function Clockwork:DrawInfo(text, x, y, color, alpha, alignLeft, Callback, shadowDepth)
		local mainTextFont = self.option:GetFont("main_text");
		local width, height = self:GetCachedTextSize(mainTextFont, text);
		
		if (width and height) then
			if (!alignLeft) then
				x = x - (width / 2);
			end;
			
			if (Callback) then
				x, y = Callback(x, y, width, height);
			end;
		
			return self:DrawSimpleText(text, x, y, Color(color.r, color.g, color.b, alpha or color.a), nil, nil, nil, shadowDepth);
		end;
	end;
	
	-- A function to get the player info box.
	function Clockwork:GetPlayerInfoBox()
		return self.PlayerInfoBox;
	end;

	-- A function to draw the local player's information.
	function Clockwork:DrawPlayerInfo(info)
		if (self.plugin:Call("PlayerCanSeePlayerInfo")) then
			local backgroundColor = self.option:GetColor("background");
			local subInformation = self.PlayerInfoText.subText;
			local information = self.PlayerInfoText.text;
			local colorWhite = self.option:GetColor("white");
			local textWidth, textHeight = self:GetCachedTextSize(self.option:GetFont("player_info_text"), "U");
			local width = self.PlayerInfoText.width;
			
			if (width < info.width) then
				width = info.width;
			elseif (width > width) then
				info.width = width;
			end;
			
			if (#information > 0 or #subInformation > 0) then
				local height = (textHeight * #information) + ((textHeight + 4) * #subInformation);
				local scrW = ScrW();
				local scrH = ScrH();
				
				if (#information > 0) then
					height = height + 8;
				end;
				
				local y = info.y + 8;
				local x = info.x - (width / 2);
				
				local boxInfo = {
					subInformation = subInformation,
					drawBackground = true,
					information = information,
					textHeight = textHeight,
					cornerSize = 2,
					textWidth = textWidth,
					height = height,
					width = width,
					x = x,
					y = y
				};
				
				if (!self.plugin:Call("PreDrawPlayerInfo", boxInfo, information, subInformation)) then
					self:OverrideMainFont(self.option:GetFont("player_info_text"));
						for k, v in ipairs(subInformation) do
							x, y = self:DrawPlayerInfoSubBox(v.text, x, y, width, boxInfo);
						end;
						
						if (#information > 0) then
							if (boxInfo.drawBackground) then
								self:DrawTexturedGradientBox(boxInfo.cornerSize, x, y, width, height - ((textHeight + 4) * #subInformation), backgroundColor);
							end;
						end;
						
						if (#information > 0) then
							x = x + 8
							y = y + 4;
						end;
							
						for k, v in ipairs(information) do
							self:DrawInfo(v.text, x, y - 1, colorWhite, 255, true);
							y = y + textHeight;
						end;
					self:OverrideMainFont(false);
				end;
				
				self.plugin:Call("PostDrawPlayerInfo", boxInfo, information, subInformation);
				info.y = info.y + boxInfo.height + 16;
				
				return boxInfo;
			end;
		end;
	end;
	
	-- A function to get whether the info menu panel can be created.
	function Clockwork:CanCreateInfoMenuPanel()
		return (table.Count(self.quickmenu.stored) > 0 or table.Count(self.quickmenu.categories) > 0);
	end;
	
	-- A function to create the info menu panel.
	function Clockwork:CreateInfoMenuPanel(x, y, w)
		if (!IsValid(self.InfoMenuPanel)) then
			local options = {};
			
			for k, v in pairs(self.quickmenu.categories) do
				options[k] = {};
				
				for k2, v2 in pairs(v) do
					local info = v2.GetInfo();
					
					if (type(info) == "table") then
						options[k][k2] = info;
						options[k][k2].isArgTable = true;
					end;
				end;
			end;
			
			for k, v in pairs(self.quickmenu.stored) do
				local info = v.GetInfo();
				
				if (type(info) == "table") then
					options[k] = info;
					options[k].isArgTable = true;
				end;
			end;
			
			self.InfoMenuPanel = self:AddMenuFromData(nil, options, function(menu, option, arguments)
				if (arguments.name) then
					option = arguments.name;
				end;
				
				if (arguments.options) then
					local subMenu = menu:AddSubMenu(option);
					
					for k, v in ipairs(arguments.options) do
						local name = v;
						
						if (type(v) == "table") then
							name = v[1];
						end;
						
						subMenu:AddOption(name, function()
							if (arguments.Callback) then
								if (type(v) == "table") then
									arguments.Callback(v[2]);
								else
									arguments.Callback(v);
								end;
							end;
							
							self:RemoveActiveToolTip();
							self:CloseActiveDermaMenus();
						end);
					end;
					
					if (IsValid(subMenu)) then
						if (arguments.toolTip) then
							subMenu:SetToolTip(arguments.toolTip);
						end;
					end;
				else
					menu:AddOption(option, function()
						if (arguments.Callback) then
							arguments.Callback();
						end;
						
						self:RemoveActiveToolTip();
						self:CloseActiveDermaMenus();
					end);
					
					local panel = menu.Items[#menu.Items];
					
					if (IsValid(panel) and arguments.toolTip) then
						panel:SetToolTip(arguments.toolTip);
					end;
				end;
			end);
			
			if (IsValid(self.InfoMenuPanel)) then
				self.InfoMenuPanel:SetVisible(false);
				self.InfoMenuPanel:SetSize(w, self.InfoMenuPanel:GetTall());
				self.InfoMenuPanel:SetPos(x, y);
			end;
		end;
	end;
	
	-- A function to get the ragdoll eye angles.
	function Clockwork:GetRagdollEyeAngles()
		if (!self.RagdollEyeAngles) then
			self.RagdollEyeAngles = Angle(0, 0, 0);
		end;
		
		return self.RagdollEyeAngles;
	end;
	
	-- A function to draw a gradient.
	function Clockwork:DrawGradient(gradientType, x, y, width, height, color)
		if (!self.Gradients[gradientType]) then
			return;
		end;
		
		surface.SetDrawColor(color.r, color.g, color.b, color.a);
		surface.SetTexture(self.Gradients[gradientType]);
		surface.DrawTexturedRect(x, y, width, height);
	end;
	
	-- A function to draw a simple gradient box.
	function Clockwork:DrawSimpleGradientBox(cornerSize, x, y, width, height, color, maxAlpha)
		local gradientAlpha = math.min(color.a, maxAlpha or 100);
		draw.RoundedBox(cornerSize, x, y, width, height, Color(color.r, color.g, color.b, color.a * 0.75));
		
		if (x + cornerSize < x + width and y + cornerSize < y + height) then
			surface.SetDrawColor(gradientAlpha, gradientAlpha, gradientAlpha, gradientAlpha);
			surface.SetTexture(self.DefaultGradient);
			surface.DrawTexturedRect(x + cornerSize, y + cornerSize, width - (cornerSize * 2), height - (cornerSize * 2));
		end;
	end;
	
	-- A function to draw a textured gradient.
	function Clockwork:DrawTexturedGradientBox(cornerSize, x, y, width, height, color, maxAlpha)
		local gradientAlpha = math.min(color.a, maxAlpha or 150);
		draw.RoundedBox(cornerSize, x, y, width, height, Color(color.r, color.g, color.b, color.a * 0.75));
		
		if (x + cornerSize < x + width and y + cornerSize < y + height) then
			surface.SetDrawColor(gradientAlpha, gradientAlpha, gradientAlpha, gradientAlpha);
			surface.SetTexture(self:GetGradientTexture());
			surface.DrawTexturedRect(x + cornerSize, y + cornerSize, width - (cornerSize * 2), height - (cornerSize * 2));
		end;
	end;
	
	--[[
		Backwards compatability, you shouldn't use this
		function for anything new.
	--]]
	Clockwork.DrawRoundedGradient = Clockwork.DrawTexturedGradientBox;

	-- A function to draw a player information sub box.
	function Clockwork:DrawPlayerInfoSubBox(text, x, y, width, boxInfo)
		local backgroundColor = self.option:GetColor("background");
		local colorInfo = self.option:GetColor("information");
		
		if (boxInfo.drawBackground) then
			self:DrawTexturedGradientBox(boxInfo.cornerSize, x, y, width, boxInfo.textHeight + 2, backgroundColor);
		end;
		
		self:DrawInfo(text, x + 8, y + 1, colorInfo, 255, true);
		
		if (boxInfo) then
			return x, y + boxInfo.textHeight + 4;
		else
			return x, y + 20;
		end;
	end;
	
	-- A function to set a panel's perform layout callback.
	function Clockwork:SetOnLayoutCallback(target, Callback)
		if (target.PerformLayout) then
			target.OldPerformLayout = target.PerformLayout;
			
			-- Called when the panel's layout is performed.
			function target.PerformLayout()
				target:OldPerformLayout(); Callback(target);
			end;
		end;
	end;
	
	-- A function to add a markup line.
	function Clockwork:AddMarkupLine(markupText, text, color)
		if (markupText != "") then
			markupText = markupText.."\n";
		end;
		
		return markupText..self:MarkupTextWithColor(text, color);
	end;
	
	-- A function to draw a markup tool tip.
	function Clockwork:DrawMarkupToolTip(markupObject, x, y, alpha)
		local height = markupObject:GetHeight();
		local width = markupObject:GetWidth();
		
		if (x - (width / 2) > 0) then
			x = x - (width / 2);
		end;
		
		self:DrawSimpleGradientBox(2, x - 8, y - 8, width + 16, height + 16, Color(50, 50, 50, alpha));
		markupObject:Draw(x, y, nil, nil, alpha);
	end;
	
	-- A function to override a markup object's draw function.
	function Clockwork:OverrideMarkupDraw(markupObject)
		function markupObject:Draw(xOffset, yOffset, hAlign, vAlign, alphaOverride)
			for k, v in pairs(self.blocks) do
				if (!v.colour) then
					v.colour = Color(255, 255, 255, 255);
				end;
				
				local alpha = v.colour.a;
				local y = yOffset + (v.height - v.thisY) + v.offset.y;
				local x = xOffset;
				
				if (hAlign == TEXT_ALIGN_CENTER) then
					x = x - (self.totalWidth / 2);
				elseif (hAlign == TEXT_ALIGN_RIGHT) then
					x = x - self.totalWidth;
				end;
				
				x = x + v.offset.x;
				
				if (hAlign == TEXT_ALIGN_CENTER) then
					y = y - (self.totalHeight / 2);
				elseif (hAlign == TEXT_ALIGN_BOTTOM) then
					y = y - self.totalHeight;
				end;
				
				if (alphaOverride) then
					alpha = alphaOverride;
				end;
				
				Clockwork:OverrideMainFont(v.font);
					Clockwork:DrawSimpleText( v.text, x, y, Color(v.colour.r, v.colour.g, v.colour.b, alpha) );
				Clockwork:OverrideMainFont(false);
			end;
		end;
	end;
	
	-- A function to get the active markup tool tip.
	function Clockwork:GetActiveMarkupToolTip()
		return self.MarkupToolTip;
	end;
	
	-- A function to get markup from a color.
	function Clockwork:ColorToMarkup(color)
		return "<color="..color.r..","..color.g..","..color.b..","..color.a..">";
	end;
	
	-- A function to markup text with a color.
	function Clockwork:MarkupTextWithColor(text, color)
		if (color) then
			return self:ColorToMarkup(color)..text.."</color>";
		else
			return text;
		end;
	end;
	
	-- A function to create a markup tool tip.
	function Clockwork:CreateMarkupToolTip(panel)
		panel.OldCursorExited = panel.OnCursorExited;
		panel.OldCursorEntered = panel.OnCursorEntered;
		
		-- Called when the cursor enters the panel.
		function panel.OnCursorEntered(panel, ...)
			if (panel.OldCursorEntered) then
				panel:OldCursorEntered(...);
			end;
			
			self.MarkupToolTip = panel;
		end;

		-- Called when the cursor exits the panel.
		function panel.OnCursorExited(panel, ...)
			if (panel.OldCursorExited) then
				panel:OldCursorExited(...);
			end;
			
			if (self.MarkupToolTip == panel) then
				self.MarkupToolTip = nil;
			end;
		end;
		
		-- A function to set the panel's markup tool tip.
		function panel.SetMarkupToolTip(panel, text)
			if (!panel.MarkupToolTip or panel.MarkupToolTip.text != text) then
				panel.MarkupToolTip = {
					object = markup.Parse(text, ScrW() * 0.25),
					text = text
				};
				
				self:OverrideMarkupDraw(panel.MarkupToolTip.object);
			end;
		end;
		
		-- A function to get the panel's markup tool tip.
		function panel.GetMarkupToolTip(panel)
			return panel.MarkupToolTip;
		end;
		
		-- A function to set the panel's tool tip.
		function panel.SetToolTip(panel, toolTip)
			panel:SetMarkupToolTip(toolTip);
		end;
		
		return panel;
	end;
	
	-- A function to create a custom spawn icon.
	function Clockwork:CreateCustomSpawnIcon(parent, bNoMarkup)
		local spawnIcon = vgui.Create("SpawnIcon", parent);
		
		-- A function to set the spawn icon's color.
		function spawnIcon.SetColor(spawnIcon, color)
			spawnIcon.BorderColor = color;
		end;
		
		-- A function to set the spawn icon's cooldown.
		function spawnIcon.SetCooldown(spawnIcon, expireTime, textureID)
			spawnIcon.Cooldown = {
				expireTime = expireTime,
				textureID = textureID or surface.GetTextureID("vgui/white"),
				duration = expireTime - CurTime()
			}
		end;
		
		-- Called after the spawn icon's children are painted.
		function spawnIcon.Icon.PaintOver()
			local curTime = CurTime();
			
			if (spawnIcon.Cooldown and spawnIcon.Cooldown.expireTime > curTime) then
				local timeLeft = spawnIcon.Cooldown.expireTime - curTime;
				local progress = 100 - ((100 / spawnIcon.Cooldown.duration) * timeLeft);
				
				Clockwork.cooldown:DrawBox(
					spawnIcon.x,
					spawnIcon.y,
					spawnIcon:GetWide(),
					spawnIcon:GetTall(),
					progress, Color(255, 255, 255, 255 - ((255 / 100) * progress)),
					spawnIcon.Cooldown.textureID
				);
			end;
			
			if (spawnIcon.BorderColor) then
				local alpha = math.min(spawnIcon.BorderColor.a, spawnIcon:GetAlpha());
				
				self.SpawnIconMaterial:SetMaterialVector("$color", Vector(spawnIcon.BorderColor.r / 255, spawnIcon.BorderColor.g / 255, spawnIcon.BorderColor.b / 255));
				self.SpawnIconMaterial:SetMaterialFloat("$alpha", alpha / 255);
					surface.SetDrawColor(spawnIcon.BorderColor.r, spawnIcon.BorderColor.g, spawnIcon.BorderColor.b, alpha);
					surface.SetMaterial(self.SpawnIconMaterial);
					spawnIcon:DrawTexturedRect();
				self.SpawnIconMaterial:SetMaterialFloat("$alpha", 1);
				self.SpawnIconMaterial:SetMaterialVector("$color", Vector(1, 1, 1));
			end;
		end;
		
		if (!bNoMarkup) then
			return self:CreateMarkupToolTip(spawnIcon);
		else
			return spawnIcon;
		end;
	end;

	-- A function to draw the armor bar.
	function Clockwork:DrawArmorBar()
		local armor = math.Clamp(self.Client:Armor(), 0, self.Client:GetMaxArmor());
		
		if (armor > 0) then
			self.Bars:Add("ARMOR", Color(139, 174, 179, 255), "", armor, self.Client:GetMaxArmor(), armor < 10, 1);
		end;
	end;

	-- A function to draw the health bar.
	function Clockwork:DrawHealthBar()
		local health = math.Clamp(self.Client:Health(), 0, self.Client:GetMaxHealth());
		
		if (health > 0) then
			self.Bars:Add("HEALTH", Color(179, 46, 49, 255), "", health, self.Client:GetMaxHealth(), health < 10, 2);
		end;
	end;
	
	-- A function to remove the active tool tip.
	function Clockwork:RemoveActiveToolTip()
		ChangeTooltip();
	end;
	
	-- A function to close active Derma menus.
	function Clockwork:CloseActiveDermaMenus()
		CloseDermaMenus();
	end;
	
	-- A function to register a background blur.
	function Clockwork:RegisterBackgroundBlur(panel, fCreateTime)
		self.BackgroundBlurs[panel] = fCreateTime or SysTime();
	end;
	
	-- A function to remove a background blur.
	function Clockwork:RemoveBackgroundBlur(panel)
		self.BackgroundBlurs[panel] = nil;
	end;
	
	-- A function to draw the background blurs.
	function Clockwork:DrawBackgroundBlurs()
		local scrH, scrW = ScrH(), ScrW();
		local sysTime = SysTime();
		
		for k, v in pairs(self.BackgroundBlurs) do
			if (type(k) == "string" or (IsValid(k) and k:IsVisible())) then
				local fraction = math.Clamp((sysTime - v) / 1, 0, 1);
				local x, y = 0, 0;
				
				surface.SetMaterial(self.ScreenBlur);
				surface.SetDrawColor(255, 255, 255, 255);
				
				for i = 0.33, 1, 0.33 do
					self.ScreenBlur:SetMaterialFloat("$blur", fraction * 5 * i);
					if (render) then render.UpdateScreenEffectTexture();end;
					
					surface.DrawTexturedRect(x, y, scrW, scrH);
				end;
				
				surface.SetDrawColor(10, 10, 10, 200 * fraction);
				surface.DrawRect(x, y, scrW, scrH);
			end;
		end;
	end;
	
	-- A function to get the notice panel.
	function Clockwork:GetNoticePanel()
		if (IsValid(self.NoticePanel) and self.NoticePanel:IsVisible()) then
			return self.NoticePanel;
		end;
	end;
	
	-- A function to set the notice panel.
	function Clockwork:SetNoticePanel(noticePanel)
		self.NoticePanel = noticePanel;
	end;
	
	-- A function to add some cinematic text.
	function Clockwork:AddCinematicText(text, color, barLength, hangTime, font, bThisOnly)
		local colorWhite = self.option:GetColor("white");
		local cinematicTable = {
			barLength = barLength,
			hangTime = hangTime or 3,
			color = color or colorWhite,
			font = font,
			text = text,
			add = 0
		};
		
		if (bThisOnly) then
			self.Cinematics[1] = cinematicTable;
		else
			self.Cinematics[#self.Cinematics + 1] = cinematicTable;
		end;
	end;
	
	-- A function to add a notice.
	function Clockwork:AddNotify(text, class, length)
		if (class != NOTIFY_HINT or string.sub(text, 1, 6) != "#Hint_") then
			if (self.BaseClass.AddNotify) then
				self.BaseClass:AddNotify(text, class, length);
			end;
		end;
	end;
	
	-- A function to get whether the local player is using the tool gun.
	function Clockwork:IsUsingTool()
		if (IsValid(self.Client:GetActiveWeapon())
		and self.Client:GetActiveWeapon():GetClass() == "gmod_tool") then
			return true;
		else
			return false;
		end;
	end;

	-- A function to get whether the local player is using the camera.
	function Clockwork:IsUsingCamera()
		if (IsValid(self.Client:GetActiveWeapon())
		and self.Client:GetActiveWeapon():GetClass() == "gmod_camera") then
			return true;
		else
			return false;
		end;
	end;
	
	-- A function to get the target ID data.
	function Clockwork:GetTargetIDData()
		return self.TargetIDData;
	end;
	
	-- A function to calculate the screen fading.
	function Clockwork:CalculateScreenFading()
		if (self.plugin:Call("ShouldPlayerScreenFadeBlack")) then
			if (!self.BlackFadeIn) then
				if (self.BlackFadeOut) then
					self.BlackFadeIn = self.BlackFadeOut;
				else
					self.BlackFadeIn = 0;
				end;
			end;
			
			self.BlackFadeIn = math.Clamp(self.BlackFadeIn + (FrameTime() * 20), 0, 255);
			self.BlackFadeOut = nil;
			self:DrawSimpleGradientBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, self.BlackFadeIn));
		else
			if (self.BlackFadeIn) then
				self.BlackFadeOut = self.BlackFadeIn;
			end;
			
			self.BlackFadeIn = nil;
			
			if (self.BlackFadeOut) then
				self.BlackFadeOut = math.Clamp(self.BlackFadeOut - (FrameTime() * 40), 0, 255);
				self:DrawSimpleGradientBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, self.BlackFadeOut));
				
				if (self.BlackFadeOut == 0) then
					self.BlackFadeOut = nil;
				end;
			end;
		end;
	end;
	
	-- A function to draw a cinematic.
	function Clockwork:DrawCinematic(cinematicTable, curTime)
		local maxBarLength = cinematicTable.barLength or (ScrH() / 13);
		local font = cinematicTable.font or self.option:GetFont("cinematic_text");
		
		if (cinematicTable.goBack and curTime > cinematicTable.goBack) then
			cinematicTable.add = math.Clamp(cinematicTable.add - 2, 0, maxBarLength);
			
			if (cinematicTable.add == 0) then
				table.remove(self.Cinematics, 1);
				cinematicTable = nil;
			end;
		else
			cinematicTable.add = math.Clamp(cinematicTable.add + 1, 0, maxBarLength);
			
			if (cinematicTable.add == maxBarLength and !cinematicTable.goBack) then
				cinematicTable.goBack = curTime + cinematicTable.hangTime;
			end;
		end;
		
		if (cinematicTable) then
			draw.RoundedBox(0, 0, -maxBarLength + cinematicTable.add, ScrW(), maxBarLength, Color(0, 0, 0, 255));
			draw.RoundedBox(0, 0, ScrH() - cinematicTable.add, ScrW(), maxBarLength, Color(0, 0, 0, 255));
			
			draw.SimpleText(cinematicTable.text, font, ScrW() / 2, (ScrH() - cinematicTable.add) + (maxBarLength / 2), cinematicTable.color, 1, 1);
		end
	end;
	
	-- A function to draw the cinematic introduction.
	function Clockwork:DrawCinematicIntro(curTime)
		local cinematicInfo = self.plugin:Call("GetCinematicIntroInfo");
		local colorWhite = self.option:GetColor("white");
		
		if (cinematicInfo) then
			if (self.CinematicScreenAlpha and self.CinematicScreenTarget) then
				self.CinematicScreenAlpha = math.Approach(self.CinematicScreenAlpha, self.CinematicScreenTarget, 1);
				
				if (self.CinematicScreenAlpha == self.CinematicScreenTarget) then
					if (self.CinematicScreenTarget == 255) then
						if (!self.CinematicScreenGoBack) then
							self.CinematicScreenGoBack = curTime + 2.5;
							self.option:PlaySound("rollover");
						end;
					else
						self.CinematicScreenDone = true;
					end;
				end;
				
				if (self.CinematicScreenGoBack and curTime >= self.CinematicScreenGoBack) then
					self.CinematicScreenGoBack = nil;
					self.CinematicScreenTarget = 0;
					self.option:PlaySound("rollover");
				end;
				
				if (!self.CinematicScreenDone and cinematicInfo.credits) then
					local alpha = math.Clamp(self.CinematicScreenAlpha, 0, 255);
					
					self:OverrideMainFont(self.option:GetFont("intro_text_tiny"));
						self:DrawSimpleText(cinematicInfo.credits, ScrW() / 8, ScrH() * 0.75, Color(colorWhite.r, colorWhite.g, colorWhite.b, alpha));
					self:OverrideMainFont(false);
				end;
			else
				self.CinematicScreenAlpha = 0;
				self.CinematicScreenTarget = 255;
				self.option:PlaySound("rollover");
			end;
		end;
	end;
	
	-- A function to draw the cinematic introduction bars.
	function Clockwork:DrawCinematicIntroBars()
		local maxBarLength = ScrH() / 13;
		
		if (!self.CinematicBarsTarget and !self.CinematicBarsAlpha) then
			self.CinematicBarsAlpha = 0;
			self.CinematicBarsTarget = 255;
			self.option:PlaySound("rollover");
		end;
		
		self.CinematicBarsAlpha = math.Approach(self.CinematicBarsAlpha, self.CinematicBarsTarget, 1);
		
		if (self.CinematicScreenDone) then
			if (self.CinematicScreenBarLength != 0) then
				self.CinematicScreenBarLength = math.Clamp((maxBarLength / 255) * self.CinematicBarsAlpha, 0, maxBarLength);
			end;
			
			if (self.CinematicBarsTarget != 0) then
				self.CinematicBarsTarget = 0;
				self.option:PlaySound("rollover");
			end;
			
			if (self.CinematicBarsAlpha == 0) then
				self.CinematicBarsDrawn = true;
			end;
		elseif (self.CinematicScreenBarLength != maxBarLength) then
			if (!self.IntroBarsMultiplier) then
				self.IntroBarsMultiplier = 1;
			else
				self.IntroBarsMultiplier = math.Clamp(self.IntroBarsMultiplier + (FrameTime() * 8), 1, 12);
			end;
			
			self.CinematicScreenBarLength = math.Clamp((maxBarLength / 255) * math.Clamp(self.CinematicBarsAlpha * self.IntroBarsMultiplier, 0, 255), 0, maxBarLength);
		end;
		
		draw.RoundedBox(0, 0, 0, ScrW(), self.CinematicScreenBarLength, Color(0, 0, 0, 255));
		draw.RoundedBox(0, 0, ScrH() - self.CinematicScreenBarLength, ScrW(), maxBarLength, Color(0, 0, 0, 255));
	end;
	
	-- A function to draw the cinematic info.
	function Clockwork:DrawCinematicInfo()
		if (!self.CinematicInfoAlpha and !self.CinematicInfoSlide) then
			self.CinematicInfoAlpha = 255;
			self.CinematicInfoSlide = 0;
		end;
		
		self.CinematicInfoSlide = math.Approach(self.CinematicInfoSlide, 255, 1);
		
		if (self.CinematicScreenAlpha and self.CinematicScreenTarget) then
			self.CinematicInfoAlpha = math.Approach(self.CinematicInfoAlpha, 0, 1);
			
			if (self.CinematicInfoAlpha == 0) then
				self.CinematicInfoDrawn = true;
			end;
		end;
		
		local cinematicInfo = self.plugin:Call("GetCinematicIntroInfo");
		local colorWhite = self.option:GetColor("white");
		local colorInfo = self.option:GetColor("information");
		
		if (cinematicInfo) then
			local screenHeight = ScrH();
			local screenWidth = ScrW();
			local textPosY = screenHeight * 0.3;
			local textPosX = screenWidth * 0.5;
			
			if (cinematicInfo.title) then
				local cinematicInfoTitle = string.upper(cinematicInfo.title);
				local cinematicIntroText = string.upper(cinematicInfo.text);
				local introTextSmallFont = self.option:GetFont("intro_text_small");
				local introTextBigFont = self.option:GetFont("intro_text_big");
				local textWidth, textHeight = self:GetCachedTextSize(introTextBigFont, cinematicInfoTitle);
				local boxAlpha = math.min(self.CinematicInfoAlpha, 150);
				
				if (cinematicInfo.text) then
					local smallTextWidth, smallTextHeight = self:GetCachedTextSize(introTextSmallFont, cinematicIntroText);
					self:DrawGradient(GRADIENT_CENTER, 0, textPosY - 8, screenWidth, textHeight + smallTextHeight + 24, Color(100, 100, 100, boxAlpha));
				else
					self:DrawGradient(GRADIENT_CENTER, 0, textPosY - 8, screenWidth, textHeight + 16, Color(100, 100, 100, boxAlpha));
				end;
				
				self:OverrideMainFont(introTextBigFont);
					self:DrawSimpleText(cinematicInfoTitle, textPosX, textPosY, Color(colorInfo.r, colorInfo.g, colorInfo.b, self.CinematicInfoAlpha), 1);
				self:OverrideMainFont(false);
				
				if (cinematicInfo.text) then
					self:OverrideMainFont(introTextSmallFont);
						self:DrawSimpleText(cinematicIntroText, textPosX - (textWidth / 2), textPosY + textHeight + 8, Color(colorWhite.r, colorWhite.g, colorWhite.b, self.CinematicInfoAlpha));
					self:OverrideMainFont(false);
				end;
			elseif (cinematicInfo.text) then
				self:OverrideMainFont(introTextSmallFont);
					self:DrawSimpleText(cinematicIntroText, textPosX, textPosY, Color(colorWhite.r, colorWhite.g, colorWhite.b, self.CinematicInfoAlpha), 1);
				self:OverrideMainFont(false);
			end;
		end;
	end;
	
	-- A function to draw some door text.
	function Clockwork:DrawDoorText(entity, eyePos, eyeAngles, font, nameColor, textColor)
		local r, g, b, a = entity:GetColor();
		
		if (a <= 0 or entity:IsEffectActive(EF_NODRAW)) then
			return;
		end;
		
		local doorData = self.entity:CalculateDoorTextPosition(entity);
		
		if (!doorData.hitWorld) then
			local frontY = -26;
			local backY = -26;
			local alpha = self:CalculateAlphaFromDistance(256, eyePos, entity:GetPos());
			
			if (alpha <= 0) then
				return;
			end;
			
			local owner = self.entity:GetOwner(entity);
			local name = self.plugin:Call("GetDoorInfo", entity, DOOR_INFO_NAME);
			local text = self.plugin:Call("GetDoorInfo", entity, DOOR_INFO_TEXT);
			
			if (name or text) then
				local nameWidth, nameHeight = self:GetCachedTextSize(font, name or "");
				local textWidth, textHeight = self:GetCachedTextSize(font, text or "");
				local longWidth = nameWidth;
				local boxAlpha = math.min(alpha, 150);
				
				if (textWidth > longWidth) then
					longWidth = textWidth;
				end;
				
				local scale = math.abs((doorData.width * 0.75) / longWidth);
				local nameScale = math.min(scale, 0.05);
				local textScale = math.min(scale, 0.03);
				local longHeight = nameHeight + textHeight + 8;
				
				cam.Start3D2D(doorData.position, doorData.angles, nameScale);
					self:DrawGradient(GRADIENT_CENTER, -(longWidth / 2) - 128, frontY - 8, longWidth + 256, longHeight, Color(100, 100, 100, boxAlpha));
				cam.End3D2D();
				
				cam.Start3D2D(doorData.positionBack, doorData.anglesBack, nameScale);
					self:DrawGradient(GRADIENT_CENTER, -(longWidth / 2) - 128, frontY - 8, longWidth + 256, longHeight, Color(100, 100, 100, boxAlpha));
				cam.End3D2D();
				
				if (name) then
					if (!text or text == "") then
						nameColor = textColor or nameColor; 
					end;
					
					cam.Start3D2D(doorData.position, doorData.angles, nameScale);
						self:OverrideMainFont(font);
							frontY = self:DrawInfo(name, 0, frontY, nameColor, alpha, nil, nil, 3);
						self:OverrideMainFont(false);
					cam.End3D2D();
					
					cam.Start3D2D(doorData.positionBack, doorData.anglesBack, nameScale);
						self:OverrideMainFont(font);
							backY = self:DrawInfo(name, 0, backY, nameColor, alpha, nil, nil, 3);
						self:OverrideMainFont(false);
					cam.End3D2D();
				end;
				
				if (text) then
					cam.Start3D2D(doorData.position, doorData.angles, textScale);
						self:OverrideMainFont(font);
							frontY = self:DrawInfo(text, 0, frontY, textColor, alpha, nil, nil, 3);
						self:OverrideMainFont(false);
					cam.End3D2D();
					
					cam.Start3D2D(doorData.positionBack, doorData.anglesBack, textScale);
						self:OverrideMainFont(font);
							backY = self:DrawInfo(text, 0, backY, textColor, alpha, nil, nil, 3);
						self:OverrideMainFont(false);
					cam.End3D2D();
				end;
			end;
		end;
	end;
	
	-- A function to get whether the local player's character screen is open.
	function Clockwork:IsCharacterScreenOpen(isVisible)
		if (self.character:IsPanelOpen()) then
			local panel = self.character:GetPanel();
			
			if (isVisible) then
				if (panel) then
					return panel:IsVisible();
				end;
			else
				return panel != nil;
			end;
		end;
	end;
	
	-- A function to save schema data.
	function Clockwork:SaveSchemaData(fileName, data)
		_file.Write("Clockwork/schemas/"..self:GetSchemaFolder().."/"..fileName..".txt", glon.encode(data));
	end;

	-- A function to delete schema data.
	function Clockwork:DeleteSchemaData(fileName)
		_file.Delete("Clockwork/schemas/"..self:GetSchemaFolder().."/"..fileName..".txt");
	end;

	-- A function to check if schema data exists.
	function Clockwork:SchemaDataExists(fileName)
		return _file.Exists("Clockwork/schemas/"..self:GetSchemaFolder().."/"..fileName..".txt");
	end;

	-- A function to restore schema data.
	function Clockwork:RestoreSchemaData(fileName, failSafe)
		if (self:SchemaDataExists(fileName)) then
			local data = _file.Read("Clockwork/schemas/"..self:GetSchemaFolder().."/"..fileName..".txt");
			
			if (data) then
				local success, value = pcall(glon.decode, data);
				
				if (success and value != nil) then
					return value;
				else
					local success, value = pcall(Json.Decode, data);
					
					if (success and value != nil) then
						return value;
					end;
				end;
			end;
		end;
		
		if (failSafe != nil) then
			return failSafe;
		else
			return {};
		end;
	end;

	-- A function to restore Clockwork data.
	function Clockwork:RestoreClockworkData(fileName, failSafe)
		if (self:ClockworkDataExists(fileName)) then
			local data = _file.Read("Clockwork/"..fileName..".txt");
			
			if (data) then
				local success, value = pcall(glon.decode, data);
				
				if (success and value != nil) then
					return value;
				end;
			end;
		end;
		
		if (failSafe != nil) then
			return failSafe;
		else
			return {};
		end;
	end;

	-- A function to save Clockwork data.
	function Clockwork:SaveClockworkData(fileName, data)
		_file.Write("Clockwork/"..fileName..".txt", glon.encode(data));
	end;

	-- A function to check if Clockwork data exists.
	function Clockwork:ClockworkDataExists(fileName)
		return _file.Exists("Clockwork/"..fileName..".txt");
	end;

	-- A function to delete Clockwork data.
	function Clockwork:DeleteClockworkData(fileName)
		_file.Delete("Clockwork/"..fileName..".txt");
	end;
	
	-- A function to run a Clockwork command.
	function Clockwork:RunCommand(command, ...)
		RunConsoleCommand("cwCmd", command, ...);
	end;
	
	-- A function to get whether the local player is choosing a character.
	function Clockwork:IsChoosingCharacter()
		if (self.character:GetPanel()) then
			return self.character:IsPanelOpen();
		else
			return true;
		end;
	end;
	
	-- A function to include the schema.
	function Clockwork:IncludeSchema()
		local schemaFolder = self:GetSchemaFolder();
		
		if (schemaFolder and type(schemaFolder) == "string") then
			self.plugin:Include(schemaFolder.."/gamemode", true);
		end;
	end;
	
	-- A function to start a data stream.
	function Clockwork:StartDataStream(name, data)
		local encodedData = glon.encode((data != nil and data or 0));
		local splitTable = self:SplitString(string.gsub(string.gsub(encodedData, "\\", "\\\\"), "\n", "\\n"), 128);
		
		if (#splitTable > 0) then
			RunConsoleCommand("cwStartDS", name, tostring(#splitTable));
			
			for k, v in ipairs(splitTable) do
				RunConsoleCommand("cwDataDS", v, tostring(k));
			end;
		end;
	end;
end;

-- A function to explode a string by tags.
function Clockwork:ExplodeByTags(text, seperator, open, close, hide)
	local results = {};
	local current = "";
	local tag = nil;
	
	for i = 1, string.len(text) do
		local character = string.sub(text, i, i);
		
		if (!tag) then
			if (character == open) then
				if (!hide) then
					current = current..character;
				end;
				
				tag = true;
			elseif (character == seperator) then
				results[#results + 1] = current; current = "";
			else
				current = current..character;
			end;
		else
			if (character == close) then
				if (!hide) then
					current = current..character;
				end;
				
				tag = nil;
			else
				current = current..character;
			end;
		end;
	end;
	
	if (current != "") then
		results[#results + 1] = current;
	end;
	
	return results;
end;

-- A function to modify a physical description.
function Clockwork:ModifyPhysDesc(description)
	if (string.len(description) <= 128) then
		if (!string.find(string.sub(description, -2), "%p")) then
			return description..".";
		else
			return description;
		end;
	else
		return string.sub(description, 1, 125).."...";
	end;
end;

--[[ 
	Obsolete! Use string.Explode as it is faster and better.
--]]
function Clockwork:ExplodeString(seperator, text)
    return string.Explode(seperator, text);
end;

local MAGIC_CHARACTERS = "([%(%)%.%%%+%-%*%?%[%^%$])";

-- A function to replace something in text without pattern matching.
function Clockwork:Replace(text, find, replace)
	return (text:gsub(find:gsub(MAGIC_CHARACTERS, "%%%1"), replace));
end;

-- A function to create a new meta table.
function Clockwork:NewMetaTable(baseTable)
	local object = {};
		setmetatable(object, baseTable);
		baseTable.__index = baseTable;
	return object;
end;

-- A function to set whether a string should be in camel case.
function Clockwork:SetCamelCase(text, bCamelCase)
	if (bCamelCase) then
		return string.gsub(text, "^.", string.lower);
	else
		return string.gsub(text, "^.", string.upper);
	end;
end;

-- A function to include files in a directory.
function Clockwork:IncludeDirectory(directory, bFromBase)
	if (bFromBase) then
		directory = "Clockwork/gamemode/"..directory;
	end;
	
	if (string.sub(directory, -1) != "/") then
		directory = directory.."/";
	end;
	
	for k, v in pairs(_file.FindInLua(directory.."*.lua")) do
		Clockwork:IncludePrefixed(directory..v);
	end;
end;

-- A function to include a prefixed _file.
function Clockwork:IncludePrefixed(fileName)
	local isShared = (string.find(fileName, "sh_") or string.find(fileName, "shared.lua"));
	local isClient = (string.find(fileName, "cl_") or string.find(fileName, "cl_init.lua"));
	local isServer = (string.find(fileName, "sv_"));
	
	if (isServer and !SERVER) then
		return;
	end;
	
	if (isShared and SERVER) then
		AddCSLuaFile(fileName);
	elseif (isClient and SERVER) then
		AddCSLuaFile(fileName);
		return;
	end;
	
	include(fileName);
end;

-- A function to include plugins in a directory.
function Clockwork:IncludePlugins(directory, bFromBase)
	if (bFromBase) then
		directory = "Clockwork/gamemode/"..directory;
	end;
	
	if (string.sub(directory, -1) != "/") then
		directory = directory.."/";
	end;
	
	for k, v in pairs(_file.FindInLua(directory.."*")) do
		if (v != ".." and v != ".") then
			if (CLIENT) then
				if (_file.IsDir("../lua_temp/"..directory..v)) then
					self.plugin:Include(directory..v);
				end;
			elseif (_file.IsDir("../gamemodes/"..directory..v)) then
				self.plugin:Include(directory..v);
			end;
		end;
	end;
	
	return true;
end;

-- A function to perform the timer think.
function Clockwork:CallTimerThink(curTime)
	for k, v in pairs(self.Timers) do
		if (!v.paused) then
			if (curTime >= v.nextCall) then
				local success, value = pcall(v.Callback, unpack(v.arguments));
				
				if (!success) then
					ErrorNoHalt("[Clockwork] The "..tostring(k).." timer has failed to run.");
					ErrorNoHalt(value);
				end;
				
				v.nextCall = curTime + v.delay;
				v.calls = v.calls + 1;
				
				if (v.calls == v.repetitions) then
					self.Timers[k] = nil;
				end;
			end;
		end;
	end;
end;

-- A function to get whether a timer exists.
function Clockwork:TimerExists(name)
	return self.Timers[name];
end;

-- A function to start a timer.
function Clockwork:StartTimer(name)
	if (self.Timers[name] and self.Timers[name].paused) then
		self.Timers[name].nextCall = CurTime() + self.Timers[name].timeLeft;
		self.Timers[name].paused = nil;
	end;
end;

-- A function to pause a timer.
function Clockwork:PauseTimer(name)
	if (self.Timers[name] and !self.Timers[name].paused) then
		self.Timers[name].timeLeft = self.Timers[name].nextCall - CurTime();
		self.Timers[name].paused = true;
	end;
end;

-- A function to destroy a timer.
function Clockwork:DestroyTimer(name)
	self.Timers[name] = nil;
end;

-- A function to create a timer.
function Clockwork:CreateTimer(name, delay, repetitions, Callback, ...)
	self.Timers[name] = {
		calls = 0,
		delay = delay,
		nextCall = CurTime() + delay,
		Callback = Callback,
		arguments = {...},
		repetitions = repetitions
	};
end;

-- A function to run a function on the next frame.
function Clockwork:OnNextFrame(name, Callback)
	self:CreateTimer(name, FrameTime() * 0.5, 1, Callback);
end;

-- A function to get whether a player has access to an object.
function Clockwork:HasObjectAccess(player, object)
	local hasAccess = false;
	local faction = player:GetFaction();
	
	if (object.access) then
		if (self.player:HasAnyFlags(player, object.access)) then
			hasAccess = true;
		end;
	end;
	
	if (object.factions) then
		if (table.HasValue(object.factions, faction)) then
			hasAccess = true;
		end;
	end;
	
	if (object.classes) then
		local team = player:Team();
		local class = self.class:Get(team);
		
		if (class) then
			if (table.HasValue(object.classes, team)
			or table.HasValue(object.classes, class.name)) then
				hasAccess = true;
			end;
		end;
	end;
	
	if (!object.access and !object.factions
	and !object.classes) then
		hasAccess = true;
	end;
	
	if (object.blacklist) then
		local team = player:Team();
		local class = self.class:Get(team);
		
		if (table.HasValue(object.blacklist, faction)) then
			hasAccess = false;
		elseif (class) then
			if (table.HasValue(object.blacklist, team)
			or table.HasValue(object.blacklist, class.name)) then
				hasAccess = false;
			end;
		else
			for k, v in ipairs(object.blacklist) do
				if (type(v) == "string") then
					if (self.player:HasAnyFlags(player, v)) then
						hasAccess = false;
						
						break;
					end;
				end;
			end;
		end;
	end;
	
	if (object.HasObjectAccess) then
		return object:HasObjectAccess(player, hasAccess);
	end;
	
	return hasAccess;
end;

-- A function to derive from Sandbox.
function Clockwork:DeriveFromSandbox()
	DeriveGamemode("Sandbox");
	
	if (self.IsSandboxDerived) then
		return;
	end;
	
	GM = {Folder = "gamemodes/sandbox"};
	
	if (CLIENT) then
		include("sandbox/gamemode/cl_init.lua");
	else
		include("sandbox/gamemode/init.lua");
	end;
	
	local sandboxGamemode = GM;
	local baseGamemode = gamemode.Get("base");
	
	if (sandboxGamemode and baseGamemode) then
		table.Inherit(sandboxGamemode, baseGamemode);
		table.Inherit(Clockwork, sandboxGamemode);
		
		timer.Simple(FrameTime(), function()
			self.BaseClass = sandboxGamemode;
		end);
		
		GM = Clockwork;
	end;
end;

-- A function to get the sorted commands.
function Clockwork:GetSortedCommands()
	local commands = {};
	local source = self.command.stored;
	
	for k, v in pairs(source) do
		commands[#commands + 1] = k;
	end;
	
	table.sort(commands, function(a, b)
		return a < b;
	end);
	
	return commands;
end;

-- A function to zero a number to an amount of digits.
function Clockwork:ZeroNumberToDigits(number, digits)
	return string.rep("0", math.Clamp(digits - string.len(tostring(number)), 0, digits))..tostring(number);
end;

-- A function to get a short CRC from a value.
function Clockwork:GetShortCRC(value)
	return math.ceil(util.CRC(value) / 10000);
end;

-- A function to validate a table's keys.
function Clockwork:ValidateTableKeys(baseTable)
	for i = 1, #baseTable do
		if (!baseTable[i]) then
			table.remove(baseTable, i);
		end;
	end;
end;

-- A function to get the map's physics entities.
function Clockwork:GetPhysicsEntities()
	local entities = {};
	
	for k, v in ipairs(ents.FindByClass("prop_physicsmultiplayer")) do
		if (IsValid(v)) then
			entities[#entities + 1] = v;
		end;
	end;
	
	for k, v in ipairs(ents.FindByClass("prop_physics")) do
		if (IsValid(v)) then
			entities[#entities + 1] = v;
		end;
	end;
	
	return entities;
end;

-- A function to create a multicall table (by Deco Da Man).
function Clockwork:CreateMulticallTable(baseTable, object)
	local metaTable = getmetatable(baseTable) or {};
		function metaTable.__index(baseTable, key)
			return function(baseTable, ...)
				for k, v in pairs(baseTable) do
					object[key](v, ...);
				end;
			end
		end
	setmetatable(baseTable, metaTable);
	
	return baseTable;
end;

-- A function to check if the shared variables have initialized.
function Clockwork:SharedVarsHaveInitialized()
	local worldEntity = GetWorldEntity();
	
	if (worldEntity and worldEntity.IsWorld and worldEntity:IsWorld()) then
		return true;
	end;
end;

-- A function to convert a user message class.
function Clockwork:ConvertUserMessageClass(class)
	local convertTable = {
		[NWTYPE_STRING] = "String",
		[NWTYPE_ENTITY] = "Entity",
		[NWTYPE_VECTOR] = "Vector",
		[NWTYPE_NUMBER] = "Long",
		[NWTYPE_ANGLE] = "Angle",
		[NWTYPE_FLOAT] = "Float",
		[NWTYPE_BOOL] = "Bool"
	};
	
	return convertTable[class];
end;

local NETWORKED_VALUE_TABLE = {
	[NWTYPE_STRING] = "",
	[NWTYPE_ENTITY] = NULL,
	[NWTYPE_VECTOR] = Vector(0, 0, 0),
	[NWTYPE_NUMBER] = 0,
	[NWTYPE_ANGLE] = Angle(0, 0, 0),
	[NWTYPE_FLOAT] = 0.0,
	[NWTYPE_BOOL] = false
};

-- A function to get a default networked value.
function Clockwork:GetDefaultNetworkedValue(class)
	return NETWORKED_VALUE_TABLE[class];
end;

local NETWORKED_CLASS_TABLE = {
	[NWTYPE_STRING] = "String",
	[NWTYPE_ENTITY] = "Entity",
	[NWTYPE_VECTOR] = "Vector",
	[NWTYPE_NUMBER] = "Int",
	[NWTYPE_ANGLE] = "Angle",
	[NWTYPE_FLOAT] = "Float",
	[NWTYPE_BOOL] = "Bool"
};

-- A function to convert a networked class.
function Clockwork:ConvertNetworkedClass(class)
	return NETWORKED_CLASS_TABLE[class];
end;

-- A function to get the default class value.
function Clockwork:GetDefaultClassValue(class)
	local convertTable = {
		["String"] = "",
		["Entity"] = NULL,
		["Vector"] = Vector(0, 0, 0),
		["Int"] = 0,
		["Angle"] = Angle(0, 0, 0),
		["Float"] = 0.0,
		["Bool"] = false
	};
	
	return convertTable[class];
end;

-- A function to set a shared variable.
function Clockwork:SetSharedVar(key, value)
	local entity = GetWorldEntity();
	local sharedVars = self:GetSharedVars():Global();
	
	if (sharedVars and sharedVars[key]) then
		local class = self:ConvertNetworkedClass(
			sharedVars[key]
		);
		
		if (class) then
			if (value == nil) then
				value = Clockwork:GetDefaultClassValue(class);
			end;
			
			entity["SetNetworked"..class](entity, key, value);
			return;
		end;
	end;
	
	entity:SetNetworkedVar(key, value);
end;

-- A function to get the shared vars.
function Clockwork:GetSharedVars()
	return self.SharedVars;
end;

-- A function to get a shared variable.
function Clockwork:GetSharedVar(key)
	local entity = GetWorldEntity();
	local sharedVars = self:GetSharedVars():Global();
	
	if (sharedVars and sharedVars[key]) then
		local class = Clockwork:ConvertNetworkedClass(
			sharedVars[key]
		);
		
		if (class) then
			return entity["GetNetworked"..class](entity, key);
		end;
	end;
	
	return entity:GetNetworkedVar(key);
end;

-- A function to create fake damage info.
function Clockwork:FakeDamageInfo(damage, inflictor, attacker, position, damageType, damageForce)
	local damageInfo = DamageInfo();
	local realDamage = math.ceil(math.max(damage, 0));
	
	damageInfo:SetDamagePosition(position);
	damageInfo:SetDamageForce(Vector() * damageForce);
	damageInfo:SetDamageType(damageType);
	damageInfo:SetInflictor(inflictor);
	damageInfo:SetAttacker(attacker);
	damageInfo:SetDamage(realDamage);
	
	return damageInfo;
end;

-- A function to unpack a color.
function Clockwork:UnpackColor(color)
	return color.r, color.g, color.b, color.a;
end;

-- A function to parse data in text.
function Clockwork:ParseData(text)
	local classes = {"%^", "%!"};
	
	for k, v in ipairs(classes) do
		for key in string.gmatch(text, v.."(.-)"..v) do
			local lower = false;
			local amount;
			
			if (string.sub(key, 1, 1) == "(" and string.sub(key, -1) == ")") then
				lower = true;
				amount = tonumber(string.sub(key, 2, -2));
			else
				amount = tonumber(key);
			end;
			
			if (amount) then
				text = string.gsub(text, v..string.gsub(key, "([%(%)])", "%%%1")..v, tostring(FORMAT_CASH(amount, k == 2, lower)));
			end;
		end;
	end;
	
	for k in string.gmatch(text, "%*(.-)%*") do
		k = string.gsub(k, "[%(%)]", "");
		
		if (k != "") then
			text = string.gsub(text, "%*%("..k.."%)%*", tostring(self.option:GetKey(k, true)));
			text = string.gsub(text, "%*"..k.."%*", tostring(self.option:GetKey(k)));
		end;
	end;
	
	if (CLIENT) then
		for k in string.gmatch(text, ":(.-):") do
			if (k != "" and input.LookupBinding(k)) then
				text = Clockwork:Replace(text, ":"..k..":", "<"..string.upper(tostring(input.LookupBinding(k)))..">");
			end;
		end;
	end;
	
	return self.config:Parse(text);
end;