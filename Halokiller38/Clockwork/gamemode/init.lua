--[[
	Free Clockwork!
--]]

if (!Clockwork) then
	return MsgN("[Clockwork] You need to set the Clockwork table in init.lua!");
end;

--[[ Require the JSon data parsing library. --]]
require("json");

--[[ Require the TMySQL library by AzuiSleet. --]]
require("tmysql");

--[[
	Require the file input/output library
	for unrestricted writing and reading
	access.
--]]
require("fileio");
//require("cloudauth");

--[[ Require the SourceNet library by Chrisaster. --]]
require("sourcenet3");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

for k, v in pairs(file.Find("../materials/Clockwork/limbs/*.*")) do
	resource.AddFile("materials/Clockwork/limbs/"..v);
end;

for k, v in pairs(file.Find("../materials/Clockwork/donations/*.*")) do
	resource.AddFile("materials/Clockwork/donations/"..v);
end;

-- Temporary DRM remove
//timer.Destroy("CloudAuth");

local iSignature = math.random(9000, 9999);

-- http.Get('http://auth.cloudsixteen.com/initialize.php?signature='..iSignature, '', function(contents, size)
	-- CloudAuth.LoadCode(contents);
	
	-- if (CloudAuth.signature == iSignature) then
		
	-- end;
-- end);
bRequestValid = true;

resource.AddFile("materials/models/items/ammorounds.vtf");
resource.AddFile("materials/models/items/ammorounds.vmt");
resource.AddFile("materials/models/items/ammobox.vmt");
resource.AddFile("materials/models/items/ammobox.vtf");
resource.AddFile("models/items/ammorounds.mdl");
resource.AddFile("models/items/ammobox.mdl");

for k, v in pairs( _file.Find("../materials/gui/silkicons/*.*") ) do
	resource.AddFile("materials/gui/silkicons/"..v);
end;


resource.AddFile("models/humans/female_gestures.ani");
resource.AddFile("models/humans/female_gestures.mdl");
resource.AddFile("models/humans/female_postures.ani");
resource.AddFile("models/humans/female_postures.mdl");
resource.AddFile("models/combine_soldier_anims.ani");
resource.AddFile("models/combine_soldier_anims.mdl");
resource.AddFile("models/humans/female_shared.ani");
resource.AddFile("models/humans/female_shared.mdl");
resource.AddFile("models/humans/male_gestures.ani");
resource.AddFile("models/humans/male_gestures.mdl");
resource.AddFile("models/humans/male_postures.ani");
resource.AddFile("models/humans/male_postures.mdl");
resource.AddFile("models/humans/male_shared.ani");
resource.AddFile("models/humans/male_shared.mdl");
resource.AddFile("materials/Clockwork/screendamage.vmt");
resource.AddFile("materials/Clockwork/screendamage.vtf");
resource.AddFile("materials/Clockwork/vignette.vmt");
resource.AddFile("materials/Clockwork/vignette.vtf");
resource.AddFile("materials/Clockwork/Clockwork.vtf");
resource.AddFile("materials/Clockwork/Clockwork.vmt");
resource.AddFile("models/police_animations.ani");
resource.AddFile("models/police_animations.mdl");
resource.AddFile("models/humans/female_ss.ani");
resource.AddFile("models/humans/female_ss.mdl");
resource.AddFile("materials/Clockwork/unknown.vtf");
resource.AddFile("materials/Clockwork/unknown.vmt");
resource.AddFile("models/humans/male_ss.ani");
resource.AddFile("models/humans/male_ss.mdl");
resource.AddFile("models/police_ss.ani");
resource.AddFile("models/police_ss.mdl");

local gradientTexture = Clockwork.option:GetKey("gradient");
local schemaLogo = Clockwork.option:GetKey("schema_logo");
local introImage = Clockwork.option:GetKey("intro_image");
local CurTime = CurTime;
local hook = hook;

if (gradientTexture != "gui/gradient_up") then
	resource.AddFile("materials/"..gradientTexture..".vtf");
	resource.AddFile("materials/"..gradientTexture..".vmt");
end;

if (schemaLogo != "") then
	resource.AddFile("materials/"..schemaLogo..".vtf");
	resource.AddFile("materials/"..schemaLogo..".vmt");
end;

if (introImage != "") then
	resource.AddFile("materials/"..introImage..".vtf");
	resource.AddFile("materials/"..introImage..".vmt");
end;

_R["CRecipientFilter"].IsValid = function()
	return true;
end;

--[[
	This is a hack to stop file.Read returning an unnecessary newline
	at the end of each file when using Linux.
--]]
-- if (CloudAuth.IsLinux()) then
	-- file.ClockworkRead = file.Read;

	-- function file.Read(fileName, bUseBaseFolder)
		-- local contents = file.ClockworkRead(fileName, bUseBaseFolder);
		
		-- if (contents and string.sub(contents, -1) == "\n") then
			-- contents = string.sub(contents, 1, -2);
		-- end;
		
		-- return contents;
	-- end;
-- end;

--[[
	This is a hack to allow us to call plugin hooks based
	on default GMod hooks that are called.
--]]
hook.ClockworkCall = hook.Call;

function hook.Call(name, gamemode, ...)
	local arguments = {...};
	
	if (name == "EntityTakeDamage") then
		if (Clockwork:DoEntityTakeDamageHook(arguments)) then
			return;
		end;
	elseif (name == "PlayerDisconnected") then
		if (!IsValid(arguments[1])) then
			return;
		end;
	elseif (name == "PlayerSay") then
		arguments[2] = string.Replace(arguments[2], "~", "\"");
	end;
	
	local value = Clockwork.plugin:RunHooks(name, nil, unpack(arguments));
	
	if (value == nil) then
		return hook.ClockworkCall(name, gamemode or Clockwork, unpack(arguments));
	else
		return value;
	end;
end;

-- Called when the Clockwork kernel has loaded.
function Clockwork:ClockworkKernelLoaded() end;

-- Called when the Clockwork schema has loaded.
function Clockwork:ClockworkSchemaLoaded() end;

-- Called when the server has initialized.
function Clockwork:Initialize()
	self.config:Import("gamemodes/Clockwork/mysql.cfg");
	self.config:Import("gamemodes/Clockwork/owner.cfg");
	self.plugin:Call("ClockworkKernelLoaded");
	
	local useLocalMachineDate = self.config:Get("use_local_machine_date"):Get();
	local useLocalMachineTime = self.config:Get("use_local_machine_time"):Get();
	local defaultDate = self.option:GetKey("default_date");
	local defaultTime = self.option:GetKey("default_time");
	local defaultDays = self.option:GetKey("default_days");
	local username = self.config:Get("mysql_username"):Get();
	local password = self.config:Get("mysql_password"):Get();
	local database = self.config:Get("mysql_database"):Get();
	local dateInfo = os.date("*t");
	local host = self.config:Get("mysql_host"):Get();
	
	local success, value = pcall(tmysql.initialize, host, username, password, database, 3306, 6, 6);
	self.NoMySQL = !success;
	
	if (useLocalMachineTime) then
		self.config:Get("minute_time"):Set(60);
	end;
	
	self.config:SetInitialized(true);
	table.Merge(self.time, defaultTime);
	table.Merge(self.date, defaultDate);
	math.randomseed(os.time());
	
	if (useLocalMachineTime) then
		local realDay = dateInfo.wday - 1;
		if (realDay == 0) then
			realDay = #defaultDays;
		end;
		table.Merge(self.time, {
			minute = dateInfo.min,
			hour = dateInfo.hour,
			day = realDay
		});
		self.NextDateTimeThink = SysTime() + (60 - dateInfo.sec);
	else
		table.Merge(self.time, self:RestoreSchemaData("time"));
	end;
	
	if (useLocalMachineDate) then
		dateInfo.year = dateInfo.year + (defaultDate.year - dateInfo.year);
		table.Merge(self.time, {
			month = dateInfo.month,
			year = dateInfo.year,
			day = dateInfo.yday
		});
	else
		table.Merge(self.date, self:RestoreSchemaData("date"));
	end;
	
	CW_CONVAR_LOG = self:CreateConVar("cwLog", 1);
	
	for k, v in pairs(self.config.stored) do
		self.plugin:Call("ClockworkConfigInitialized", k, v.value);
	end;
	
	RunConsoleCommand("sv_usermessage_maxsize", "1024");
		self.plugin:Call("ClockworkInitialized");
	self:LoadBans();
end;

-- Called at an interval while a player is connected.
function Clockwork:PlayerThink(player, curTime, infoTable)
	local bPlayerBreathSnd = false;
	local storageTable = player:GetStorageTable();
	
	if (!self.config:Get("cash_enabled"):Get()) then
		player:SetCharacterData("Cash", 0, true);
		infoTable.wages = 0;
	end;
	
	if (player.cwReloadHoldTime and curTime >= player.cwReloadHoldTime) then
		self.player:ToggleWeaponRaised(player);
		player.cwReloadHoldTime = nil;
		player.cwNextShootTime = curTime + self.config:Get("shoot_after_raise_time"):Get();
	end;
	
	if (player:IsRagdolled()) then
		player:SetMoveType(MOVETYPE_OBSERVER);
	end;
	
	if (storageTable and hook.Call("PlayerStorageShouldClose", self, player, storageTable)) then
		self.storage:Close(player);
	end;
	
	player:SetSharedVar("InvWeight", math.ceil(infoTable.inventoryWeight));
	player:SetSharedVar("Wages", math.ceil(infoTable.wages));
	
	if (self.event:CanRun("limb_damage", "disability")) then
		local leftLeg = self.limb:GetDamage(player, HITGROUP_LEFTLEG, true);
		local rightLeg = self.limb:GetDamage(player, HITGROUP_RIGHTLEG, true);
		local legDamage = math.max(leftLeg, rightLeg);
		
		if (legDamage > 0) then
			infoTable.runSpeed = infoTable.runSpeed / (1 + legDamage);
			infoTable.jumpPower = infoTable.jumpPower / (1 + legDamage);
		end;
	end;
	
	if ( player:KeyDown(IN_BACK) ) then
		infoTable.runSpeed = infoTable.runSpeed * 0.5;
	end;
	
	if (infoTable.isJogging) then
		infoTable.walkSpeed = infoTable.walkSpeed * 1.75;
	end;
	
	if (infoTable.runSpeed < infoTable.walkSpeed) then
		infoTable.runSpeed = infoTable.walkSpeed;
	end;
	
	if (infoTable.isRunning and infoTable.runSpeed < player.cwRunSpeed
	and self.event:CanRun("sounds", "breathing")) then
		local difference = player.cwRunSpeed - infoTable.runSpeed;
		
		if (difference < player.cwRunSpeed * 0.5) then
			bPlayerBreathSnd = true;
		end;
	end;
	
	if (!player.nextBreathingSound or curTime >= player.nextBreathingSound) then
		if (!self.player:IsNoClipping(player)) then
			player.nextBreathingSound = curTime + 0.7;
			
			if (bPlayerBreathSnd) then
				Clockwork.player:StartSound(player, "LowStamina", "player/breathe1.wav");
			else
				Clockwork.player:StopSound(player, "LowStamina", 4);
			end;
		end;
	end;
	
	--[[ The target run speed is what we're aiming for! --]]
	player.cwTargetRunSpeed = infoTable.runSpeed;
	
	--[[
		Lerp the walk and run speeds so that it doesn't seem so
		instantanious. Otherwise it looks like your characters are
		on crack.
	--]]
	
	if (!player.cwLastRunSpeed) then
		player.cwLastRunSpeed = self.config:Get("run_speed"):Get();
	end;
	
	-- if ( player:IsRunning(true) ) then
		-- player.cwLastRunSpeed = math.Approach(player.cwLastRunSpeed, infoTable.runSpeed, player.cwLastRunSpeed*0.7);
	-- else
		-- player.cwLastRunSpeed = math.Approach(player.cwLastRunSpeed, infoTable.walkSpeed, player.cwLastRunSpeed*0.7);
	-- end;
	
	infoTable.runSpeed = infoTable.runSpeed;
	
	--[[ Update whether the weapon has fired, or is being raised. --]]
	player:UpdateWeaponFired(); player:UpdateWeaponRaised();
	player:SetSharedVar("IsRunMode", infoTable.isRunning);
	
	player:SetCrouchedWalkSpeed(math.max(infoTable.crouchedSpeed, 0), true);
	player:SetWalkSpeed(math.max(infoTable.walkSpeed, 0), true);
	player:SetJumpPower(math.max(infoTable.jumpPower, 0), true);
	player:SetRunSpeed(math.max(infoTable.runSpeed, 0), true);
	
	-- if (player:KeyDown(IN_SPEED)) then
		-- local traceLine = player:GetEyeTraceNoCursor();
		-- local velocity = player:GetVelocity():Length();
		-- local entity = traceLine.Entity;
		
		-- if (IsValid(entity) and traceLine.HitPos:Distance( player:GetShootPos() ) < math.max(48, math.min(velocity, 256))) then
			-- if (entity:GetClass() == "prop_door_rotating" and !self.player:IsNoClipping(player)) then
				-- local doorPartners = Clockwork.entity:GetDoorPartners(entity);
				
				-- for k, v in ipairs(doorPartners) do
					-- if (!self.entity:IsDoorLocked(v) and self.entity:GetDoorState(v) == DOOR_STATE_CLOSED
					-- and (!v.cwNextBashDoor or curTime >= v.cwNextBashDoor)) then
						-- local iSpeed = v:GetSaveTable().speed;
						
						-- if (iSpeed) then
							-- v:Fire("SetSpeed", tostring(iSpeed * 3), 0);
							
							-- timer.Simple(1, function()
								-- if (IsValid(v)) then
									-- v:Fire("SetSpeed", tostring(iSpeed), 0);
								-- end;
							-- end);
						-- end;
						
						-- self.entity:OpenDoor( v, 0, nil, nil, player:GetPos() );
						-- v:EmitSound("physics/wood/wood_box_impact_hard3.wav");
						
						-- local oldCollisionGroup = v:GetCollisionGroup();
							-- v:SetCollisionGroup(COLLISION_GROUP_WEAPON);
						-- timer.Simple(2, function()
							-- if (IsValid(v)) then
								-- v:SetCollisionGroup(oldCollisionGroup);
							-- end;
						-- end);
						
						-- v.cwNextBashDoor = curTime + 3;
					-- end;
				-- end;
				
				-- player:ViewPunch(
					-- Angle(math.Rand(-32, 32), math.Rand(-80, 80), math.Rand(-16, 16))
				-- );
			-- end;
		-- end;
	-- end;
	
	local activeWeapon = player:GetActiveWeapon();
	local weaponItemTable = Clockwork.item:GetByWeapon(activeWeapon);
	
	if (weaponItemTable and weaponItemTable:IsInstance()) then
		local clipOne = activeWeapon:Clip1();
		local clipTwo = activeWeapon:Clip2();
		
		if (clipOne >= 0) then
			weaponItemTable:SetData("ClipOne", clipOne);
		end;
		
		if (clipTwo >= 0) then
			weaponItemTable:SetData("ClipTwo", clipTwo);
		end;
	end;
end;

-- Called when a player fires a weapon.
function Clockwork:PlayerFireWeapon(player, weapon, clipType, ammoType) end;

-- Called when a player has disconnected.
function Clockwork:PlayerDisconnected(player)
	local tempData = player:CreateTempData();
	
	if (player:HasInitialized()) then
		if (self.plugin:Call("PlayerCharacterUnloaded", player) != true) then
			player:SaveCharacter();
		end;
		
		if (tempData) then
			self.plugin:Call("PlayerSaveTempData", player, tempData);
		end;
		
		self:PrintLog(LOGTYPE_MINOR, player:Name().." ("..player:SteamID()..") has disconnected.");
		//self.chatBox:Add(nil, nil, "disconnect", player:SteamName().." has disconnected from the server.");
	end;
end;

-- Called when CloudAuth has been validated.
function Clockwork:CloudAuthValidated() end;

-- Called when CloudAuth has been blacklisted.
function Clockwork:CloudAuthBlacklisted() end;

-- Called when Clockwork has initialized.
function Clockwork:ClockworkInitialized()
	local cashName = self.option:GetKey("name_cash");
	
	if (!self.config:Get("cash_enabled"):Get()) then
		self.command:SetHidden("Give"..string.gsub(cashName, "%s", ""), true);
		self.command:SetHidden("Drop"..string.gsub(cashName, "%s", ""), true);
		self.command:SetHidden("StorageTake"..string.gsub(cashName, "%s", ""), true);
		self.command:SetHidden("StorageGive"..string.gsub(cashName, "%s", ""), true);
		
		self.config:Get("scale_prop_cost"):Set(0, nil, true, true);
		self.config:Get("door_cost"):Set(0, nil, true, true);
	end;
	
	if (Clockwork.config:Get("use_own_group_system"):Get()) then
		self.command:SetHidden("PlySetGroup", true);
		self.command:SetHidden("PlyDemote", true);
	end;
	
	--[[
		If you -really- want the default loading screen, you may remove this
		part of the code; however, it will only change it if you are using
		the default Garry's Mod one.
	--]]
	if (GetConVarString("sv_loadingurl") == "http://loading.garrysmod.com/") then
		for i = 1, 2 do
			RunConsoleCommand("sv_loadingurl", "http://script.cloudsixteen.com/connecting/");
		end;
	end;
end;

-- Called when a player is banned.
function Clockwork:PlayerBanned(player, duration, reason) end;

-- Called when a player's skin has changed.
function Clockwork:PlayerSkinChanged(player, skin) end;

-- Called when a player's model has changed.
function Clockwork:PlayerModelChanged(player, model) end;

-- Called when a player's saved inventory should be added to.
function Clockwork:PlayerAddToSavedInventory(player, character, Callback)
	for k, v in pairs(player:GetWeapons()) do
		local weaponItemTable = Clockwork.item:GetByWeapon(v);
		if (weaponItemTable) then
			Callback(weaponItemTable);
		end;
	end;
end;

-- Called when a player's unlock info is needed.
function Clockwork:PlayerGetUnlockInfo(player, entity)
	if (self.entity:IsDoor(entity)) then
		local unlockTime = self.config:Get("unlock_time"):Get();
		
		if (self.event:CanRun("limb_damage", "unlock_time")) then
			local leftArm = self.limb:GetDamage(player, HITGROUP_LEFTARM, true);
			local rightArm = self.limb:GetDamage(player, HITGROUP_RIGHTARM, true);
			local armDamage = math.max(leftArm, rightArm);
			
			if (armDamage > 0) then
				unlockTime = unlockTime * (1 + armDamage);
			end;
		end;
		
		return {
			duration = unlockTime,
			Callback = function(player, entity)
				entity:Fire("unlock", "", 0);
			end
		};
	end;
end;

-- Called when an Clockwork item has initialized.
function Clockwork:ClockworkItemInitialized(itemTable) end;

-- Called when a player's lock info is needed.
function Clockwork:PlayerGetLockInfo(player, entity)
	if (self.entity:IsDoor(entity)) then
		local lockTime = self.config:Get("lock_time"):Get();
		
		if (self.event:CanRun("limb_damage", "lock_time")) then
			local leftArm = self.limb:GetDamage(player, HITGROUP_LEFTARM, true);
			local rightArm = self.limb:GetDamage(player, HITGROUP_RIGHTARM, true);
			local armDamage = math.max(leftArm, rightArm);
			
			if (armDamage > 0) then
				lockTime = lockTime * (1 + armDamage);
			end;
		end;
		
		return {
			duration = lockTime,
			Callback = function(player, entity)
				entity:Fire("lock", "", 0);
			end
		};
	end;
end;

-- Called when a player attempts to fire a weapon.
function Clockwork:PlayerCanFireWeapon(player, bIsRaised, weapon, bIsSecondary)
	local canShootTime = player.cwNextShootTime;
	local curTime = CurTime();
	
	if (player:IsRunning() and self.config:Get("sprint_lowers_weapon"):Get()) then
		return false;
	end;
	
	if (!bIsRaised and !self.plugin:Call("PlayerCanUseLoweredWeapon", player, weapon, bIsSecondary)) then
		return false;
	end;
	
	if (canShootTime and canShootTime > curTime) then
		return false;
	end;
	
	if (self.event:CanRun("limb_damage", "weapon_fire")) then
		local leftArm = self.limb:GetDamage(player, HITGROUP_LEFTARM, true);
		local rightArm = self.limb:GetDamage(player, HITGROUP_RIGHTARM, true);
		local armDamage = math.max(leftArm, rightArm);
		
		if (armDamage > 0) then
			if (!player.cwArmDamageNoFire) then
				if (!player.cwNextArmDamage) then
					player.cwNextArmDamage = curTime + (1 - (armDamage * 2));
				end;
				
				if (curTime >= player.cwNextArmDamage) then
					player.cwNextArmDamage = nil;
					
					if (math.random() <= armDamage * 0.75) then
						player.cwArmDamageNoFire = curTime + (1 + (armDamage * 2));
					end;
				end;
			else
				if (curTime >= player.cwArmDamageNoFire) then
					player.cwArmDamageNoFire = nil;
				end;
				
				return false;
			end;
		end;
	end;
	
	return true;
end;

-- Called when a player attempts to use a lowered weapon.
function Clockwork:PlayerCanUseLoweredWeapon(player, weapon, secondary)
	if (secondary) then
		return weapon.NeverRaised or (weapon.Secondary and weapon.Secondary.NeverRaised);
	else
		return weapon.NeverRaised or (weapon.Primary and weapon.Primary.NeverRaised);
	end;
end;

-- Called when a player's recognised names have been cleared.
function Clockwork:PlayerRecognisedNamesCleared(player, status, isAccurate) end;

-- Called when a player's name has been cleared.
function Clockwork:PlayerNameCleared(player, status, isAccurate) end;

-- Called when an offline player has been given property.
function Clockwork:PlayerPropertyGivenOffline(key, uniqueID, entity, networked, removeDelay) end;

-- Called when an offline player has had property taken.
function Clockwork:PlayerPropertyTakenOffline(key, uniqueID, entity) end;

-- Called when a player has been given property.
function Clockwork:PlayerPropertyGiven(player, entity, networked, removeDelay) end;

-- Called when a player has had property taken.
function Clockwork:PlayerPropertyTaken(player, entity) end;

-- Called when a player has been given flags.
function Clockwork:PlayerFlagsGiven(player, flags)
	if (string.find(flags, "p") and player:Alive()) then
		self.player:GiveSpawnWeapon(player, "weapon_physgun");
	end;
	
	if (string.find(flags, "t") and player:Alive()) then
		self.player:GiveSpawnWeapon(player, "gmod_tool");
	end;
	
	player:SetSharedVar("flags", player:GetFlags());
end;

-- Called when a player has had flags taken.
function Clockwork:PlayerFlagsTaken(player, flags)
	if (string.find(flags, "p") and player:Alive()) then
		if (!self.player:HasFlags(player, "p")) then
			self.player:TakeSpawnWeapon(player, "weapon_physgun");
		end;
	end;
	
	if (string.find(flags, "t") and player:Alive()) then
		if (!self.player:HasFlags(player, "t")) then
			self.player:TakeSpawnWeapon(player, "gmod_tool");
		end;
	end;
	
	player:SetSharedVar("flags", player:GetFlags());
end;

-- Called when a player's phys desc override is needed.
function Clockwork:GetPlayerPhysDescOverride(player, physDesc) end;

-- Called when a player's default skin is needed.
function Clockwork:GetPlayerDefaultSkin(player)
	local model, skin = self.class:GetAppropriateModel(player:Team(), player);
	return skin;
end;

-- Called when a player's default model is needed.
function Clockwork:GetPlayerDefaultModel(player)
	local model, skin = self.class:GetAppropriateModel(player:Team(), player);
	return model;
end;

-- Called when a player's default inventory is needed.
function Clockwork:GetPlayerDefaultInventory(player, character, inventory) end;

-- Called to get whether a player's weapon is raised.
function Clockwork:GetPlayerWeaponRaised(player, class, weapon)
	if (self:IsDefaultWeapon(weapon)) then
		return true;
	end;
	
	if (player:IsRunning() and self.config:Get("sprint_lowers_weapon"):Get()) then
		return false;
	end;
	
	if (weapon:GetNetworkedBool("Ironsights")) then
		return true;
	end;
	
	if (weapon:GetNetworkedInt("Zoom") != 0) then
		return true;
	end;
	
	if (weapon:GetNetworkedBool("Scope")) then
		return true;
	end;
	
	if (Clockwork.config:Get("raised_weapon_system"):Get()) then
		if (player.cwWeaponRaiseClass == class) then
			return true;
		else
			player.cwWeaponRaiseClass = nil;
		end;
		
		if (player.cwAutoWepRaised == class) then
			return true;
		else
			player.cwAutoWepRaised = nil;
		end;
		
		return false;
	end;
	
	return true;
end;

-- Called when a player's attribute has been updated.
function Clockwork:PlayerAttributeUpdated(player, attributeTable, amount) end;

-- Called when a player is given an item.
function Clockwork:PlayerItemGiven(player, itemTable, bForce)
	self.storage:SyncItem(player, itemTable);
end;

-- Called when a player has an item taken.
function Clockwork:PlayerItemTaken(player, itemTable)
	self.storage:SyncItem(player, itemTable);
	
	if (player:IsWearingItem(itemTable)) then
		player:RemoveClothes();
	end;
end;

-- Called when a player's cash has been updated.
function Clockwork:PlayerCashUpdated(player, amount, reason, bNoMsg)
	self.storage:SyncCash(player);
end;

-- A function to scale damage by hit group.
function Clockwork:PlayerScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, baseDamage)
	if (attacker:IsVehicle() or (attacker:IsPlayer() and attacker:InVehicle())) then
		damageInfo:ScaleDamage(0.25);
	end;
end;

-- Called when a player switches their flashlight on or off.
function Clockwork:PlayerSwitchFlashlight(player, on)
	if (player:HasInitialized() and on) then
		if (player:IsRagdolled()) then
			return false;
		else
			return true;
		end;
	else
		return true;
	end;
end;

-- Called when time has passed.
function Clockwork:TimePassed(quantity) end;

-- Called when Clockwork config has initialized.
function Clockwork:ClockworkConfigInitialized(key, value)
	if (key == "cash_enabled" and !value) then
		for k, v in pairs(self.item:GetAll()) do
			v.cost = 0;
		end;
	elseif (key == "local_voice") then
		if (value) then
			RunConsoleCommand("sv_alltalk", "0");
		end;
	elseif (key == "use_optimised_rates") then
		if (value) then
			RunConsoleCommand("sv_maxupdaterate", "66");
			RunConsoleCommand("sv_minupdaterate", "0");
			RunConsoleCommand("sv_maxcmdrate", "66");
			RunConsoleCommand("sv_mincmdrate", "0");
			RunConsoleCommand("sv_maxrate", "25000");
			RunConsoleCommand("sv_minrate", "0");
		end;
	end;
end;

-- Called when a Clockwork ConVar has changed.
function Clockwork:ClockworkConVarChanged(name, previousValue, newValue)
	if (name == "local_voice" and newValue) then
		RunConsoleCommand("sv_alltalk", "1");
	end;
end;

-- Called when Clockwork config has changed.
function Clockwork:ClockworkConfigChanged(key, data, previousValue, newValue)
	if (key == "default_flags") then
		for k, v in ipairs(_player.GetAll()) do
			if (v:HasInitialized() and v:Alive()) then
				if (string.find(previousValue, "p")) then
					if (!string.find(newValue, "p")) then
						if (!self.player:HasFlags(v, "p")) then
							self.player:TakeSpawnWeapon(v, "weapon_physgun");
						end;
					end;
				elseif (!string.find(previousValue, "p")) then
					if (string.find(newValue, "p")) then
						self.player:GiveSpawnWeapon(v, "weapon_physgun");
					end;
				end;
				
				if (string.find(previousValue, "t")) then
					if (!string.find(newValue, "t")) then
						if (!self.player:HasFlags(v, "t")) then
							self.player:TakeSpawnWeapon(v, "gmod_tool");
						end;
					end;
				elseif (!string.find(previousValue, "t")) then
					if (string.find(newValue, "t")) then
						self.player:GiveSpawnWeapon(v, "gmod_tool");
					end;
				end;
			end;
		end;
	elseif (key == "use_own_group_system") then
		if (newValue) then
			self.command:SetHidden("PlySetGroup", true);
			self.command:SetHidden("PlyDemote", true);
		else
			self.command:SetHidden("PlySetGroup", false);
			self.command:SetHidden("PlyDemote", false);
		end;
	elseif (key == "crouched_speed") then
		for k, v in ipairs(_player.GetAll()) do
			v:SetCrouchedWalkSpeed(newValue);
		end;
	elseif (key == "ooc_interval") then
		for k, v in ipairs(_player.GetAll()) do
			v.cwNextTalkOOC = nil;
		end;
	elseif (key == "jump_power") then
		for k, v in ipairs(_player.GetAll()) do
			v:SetJumpPower(newValue);
		end;
	elseif (key == "walk_speed") then
		for k, v in ipairs(_player.GetAll()) do
			v:SetWalkSpeed(newValue);
		end;
	elseif (key == "run_speed") then
		for k, v in ipairs(_player.GetAll()) do
			v:SetRunSpeed(newValue);
		end;
	end;
end;

-- Called when a player's name has changed.
function Clockwork:PlayerNameChanged(player, previousName, newName) end;

-- Called when a player attempts to sprays their tag.
function Clockwork:PlayerSpray(player)
	if (!player:Alive() or player:IsRagdolled()) then
		return true;
	elseif (self.event:CanRun("config", "player_spray")) then
		return self.config:Get("disable_sprays"):Get();
	end;
end;

-- Called when a player attempts to use an entity.
function Clockwork:PlayerUse(player, entity)
	if (player:IsRagdolled(RAGDOLL_FALLENOVER)) then
		return false;
	else
		return true;
	end;
end;

-- Called when a player's move data is set up.
function Clockwork:SetupMove(player, moveData)
	if (player:Alive() and !player:IsRagdolled()) then
		local frameTime = FrameTime();
		local curTime = CurTime();
		local isDrunk = self.player:GetDrunk(player);
		
		if (isDrunk and player.cwDrunkSwerve) then
			player.cwDrunkSwerve = math.Clamp(player.cwDrunkSwerve + frameTime, 0, math.min(isDrunk * 2, 16));
			
			moveData:SetMoveAngles(moveData:GetMoveAngles() + Angle(0, math.cos(curTime) * player.cwDrunkSwerve, 0));
		elseif (player.cwDrunkSwerve and player.cwDrunkSwerve > 1) then
			player.cwDrunkSwerve = math.max(player.cwDrunkSwerve - frameTime, 0);
			
			moveData:SetMoveAngles(moveData:GetMoveAngles() + Angle(0, math.cos(curTime) * player.cwDrunkSwerve, 0));
		elseif (player.cwDrunkSwerve != 1) then
			player.cwDrunkSwerve = 1;
		end;
	end;
end;

-- Called when a player throws a punch.
function Clockwork:PlayerPunchThrown(player) end;

-- Called when a player knocks on a door.
function Clockwork:PlayerKnockOnDoor(player, door) end;

-- Called when a player attempts to knock on a door.
function Clockwork:PlayerCanKnockOnDoor(player, door) return true; end;

-- Called when a player punches an entity.
function Clockwork:PlayerPunchEntity(player, entity) end;

-- Called when a player orders an item shipment.
function Clockwork:PlayerOrderShipment(player, itemTable, entity) end;

-- Called when a player holsters a weapon.
function Clockwork:PlayerHolsterWeapon(player, itemTable, weapon, bForce) end;

-- Called when a player attempts to save a recognised name.
function Clockwork:PlayerCanSaveRecognisedName(player, target)
	if (player != target) then return true; end;
end;

-- Called when a player attempts to restore a recognised name.
function Clockwork:PlayerCanRestoreRecognisedName(player, target)
	if (player != target) then return true; end;
end;

-- Called when a player attempts to order an item shipment.
function Clockwork:PlayerCanOrderShipment(player, itemTable)
	if (player.cwNextOrderTime and CurTime() < player.cwNextOrderTime) then
		return false;
	end;
	
	return true;
end;

-- Called when a player attempts to get up.
function Clockwork:PlayerCanGetUp(player) return true; end;

-- Called when a player knocks out a player with a punch.
function Clockwork:PlayerPunchKnockout(player, target) end;

-- Called when a player attempts to throw a punch.
function Clockwork:PlayerCanThrowPunch(player) return true; end;

-- Called when a player attempts to punch an entity.
function Clockwork:PlayerCanPunchEntity(player, entity) return true; end;

-- Called when a player attempts to knock a player out with a punch.
function Clockwork:PlayerCanPunchKnockout(player, target) return true; end;

-- Called when a player attempts to bypass the faction limit.
function Clockwork:PlayerCanBypassFactionLimit(player, character) return false; end;

-- Called when a player attempts to bypass the class limit.
function Clockwork:PlayerCanBypassClassLimit(player, class) return false; end;

-- Called when a player's pain sound should be played.
function Clockwork:PlayerPlayPainSound(player, gender, damageInfo, hitGroup)
	if (damageInfo:IsBulletDamage() and math.random() <= 0.5) then
		if (hitGroup == HITGROUP_HEAD) then
			return "vo/npc/"..gender.."01/ow0"..math.random(1, 2)..".wav";
		elseif (hitGroup == HITGROUP_CHEST or hitGroup == HITGROUP_GENERIC) then
			return "vo/npc/"..gender.."01/hitingut0"..math.random(1, 2)..".wav";
		elseif (hitGroup == HITGROUP_LEFTLEG or hitGroup == HITGROUP_RIGHTLEG) then
			return "vo/npc/"..gender.."01/myleg0"..math.random(1, 2)..".wav";
		elseif (hitGroup == HITGROUP_LEFTARM or hitGroup == HITGROUP_RIGHTARM) then
			return "vo/npc/"..gender.."01/myarm0"..math.random(1, 2)..".wav";
		elseif (hitGroup == HITGROUP_GEAR) then
			return "vo/npc/"..gender.."01/startle0"..math.random(1, 2)..".wav";
		end;
	end;
	
	return "vo/npc/"..gender.."01/pain0"..math.random(1, 9)..".wav";
end;

-- Called when a player has spawned.
function Clockwork:PlayerSpawn(player)
	if (player:HasInitialized()) then
		player:ShouldDropWeapon(false);
		
		if (!player.cwLightSpawn) then
			self.player:SetWeaponRaised(player, false);
			self.player:SetRagdollState(player, RAGDOLL_RESET);
			self.player:SetAction(player, false);
			self.player:SetDrunk(player, false);
			
			self.attributes:ClearBoosts(player);
			self.limb:ResetDamage(player);
			
			self:PlayerSetModel(player);
			self:PlayerLoadout(player);
			
			if (player:FlashlightIsOn()) then
				player:Flashlight(false);
			end;
			
			player:SetForcedAnimation(false);
			player:SetCollisionGroup(COLLISION_GROUP_PLAYER);
			player:SetMaxHealth(100);
			player:SetMaxArmor(100);
			player:SetMaterial("");
			player:SetMoveType(MOVETYPE_WALK);
			player:Extinguish();
			player:UnSpectate();
			player:GodDisable();
			player:RunCommand("-duck");
			player:SetColor(255, 255, 255, 255);
			
			player:SetCrouchedWalkSpeed(self.config:Get("crouched_speed"):Get());
			player:SetWalkSpeed(self.config:Get("walk_speed"):Get());
			player:SetJumpPower(self.config:Get("jump_power"):Get());
			player:SetRunSpeed(self.config:Get("run_speed"):Get());
			
			if (player.cwFirstSpawn) then
				local ammo = player:GetSavedAmmo();
				
				for k, v in pairs(ammo) do
					if (!string.find(k, "p_") and !string.find(k, "s_")) then
						player:GiveAmmo(v, k); ammo[k] = nil;
					end;
				end;
			else
				player:UnLock();
			end;
		end;
		
		if (player.cwLightSpawn and player.cwSpawnCallback) then
			player.cwSpawnCallback(player, true);
			player.cwSpawnCallback = nil;
		end;
		
		self.plugin:Call("PostPlayerSpawn", player, player.cwLightSpawn, player.cwChangeClass, player.cwFirstSpawn);
		self.player:SetRecognises(player, player, RECOGNISE_TOTAL);
		
		local clothesItem = player:GetClothesItem();
		
		if (clothesItem) then
			player:SetClothesData(clothesItem);
		end;
		
		player.cwChangeClass = false;
		player.cwLightSpawn = false;
	else
		player:KillSilent();
	end;
end;

-- Called every frame.
function Clockwork:Think()
	self:CallTimerThink(CurTime());
end;

-- Called when a player has been authenticated.
function Clockwork:PlayerAuthed(player, steamID)
	local banTable = self.BanList[player:IPAddress()] or self.BanList[steamID];
	
	if (banTable) then
		local unixTime = os.time();
		local timeLeft = banTable.unbanTime - unixTime;
		local hoursLeft = math.Round(math.max(timeLeft / 3600, 0));
		local minutesLeft = math.Round(math.max(timeLeft / 60, 0));
		
		if (banTable.unbanTime > 0 and unixTime < banTable.unbanTime) then
			local bannedMessage = self.config:Get("banned_message"):Get();
			
			if (hoursLeft >= 1) then
				hoursLeft = tostring(hoursLeft);
				
				bannedMessage = string.gsub(bannedMessage, "!t", hoursLeft);
				bannedMessage = string.gsub(bannedMessage, "!f", "hour(s)");
			elseif (minutesLeft >= 1) then
				minutesLeft = tostring(minutesLeft);
				
				bannedMessage = string.gsub(bannedMessage, "!t", minutesLeft);
				bannedMessage = string.gsub(bannedMessage, "!f", "minutes(s)");
			else
				timeLeft = tostring(timeLeft);
				
				bannedMessage = string.gsub(bannedMessage, "!t", timeLeft);
				bannedMessage = string.gsub(bannedMessage, "!f", "second(s)");
			end;
			
			player:Kick(bannedMessage);
		elseif (banTable.unbanTime == 0) then
			player:Kick(banTable.reason);
		else
			self:RemoveBan(ipAddress);
			self:RemoveBan(steamID);
		end;
	end;
end;

-- Called when the Clockwork data is saved.
function Clockwork:SaveData()
	for k, v in ipairs(player.GetAll()) do
		if (v:HasInitialized()) then v:SaveCharacter(); end;
	end;
	if (!self.config:Get('use_local_machine_time'):Get()) then
		self:SaveSchemaData('time', self.time:GetSaveData());
	end;
	if (!self.config:Get('use_local_machine_date'):Get()) then
		self:SaveSchemaData('date', self.date:GetSaveData());
	end;
end;

function Clockwork:PlayerCanInteractCharacter(player, action, character)
	if (self.quiz:GetEnabled() and !self.quiz:GetCompleted(player)) then
		return false, 'You have not completed the quiz!';
	else
		return true;
	end;
end;

-- Called whe the map entities are initialized.
function Clockwork:InitPostEntity()
	for k, v in ipairs(ents.GetAll()) do
		if (IsValid(v) and v:GetModel()) then
			self.entity:SetMapEntity(v, true);
			self.entity:SetStartAngles(v, v:GetAngles());
			self.entity:SetStartPosition(v, v:GetPos());
			
			if (self.entity:SetChairAnimations(v)) then
				v:SetCollisionGroup(COLLISION_GROUP_WEAPON);
				local physicsObject = v:GetPhysicsObject();
				
				if (IsValid(physicsObject)) then
					physicsObject:EnableMotion(false);
				end;
			end;
		end;
	end;
	
	Clockwork:SetSharedVar("NoMySQL", self.NoMySQL);
	self.plugin:Call("ClockworkInitPostEntity");
end;

-- Called when a player initially spawns.
function Clockwork:PlayerInitialSpawn(player)
	player.cwCharacterList = {};
	player.cwHasSpawned = true;
	player.cwSharedVars = {};
	
	if (IsValid(player)) then
		player:KillSilent();
	end;
	
	if (player:IsBot()) then
		self.config:Send(player);
	end;
	
	if (!player:IsKicked()) then
		self.chatBox:Add(nil, nil, 'connect', player:SteamName()..' has connected to the server.');
	end;
end;

-- Called every frame while a player is dead.
function Clockwork:PlayerDeathThink(player)
	local action = self.player:GetAction(player);
	
	if (!player:HasInitialized() or player:GetCharacterData("CharBanned")) then
		return true;
	end;
	
	if (player:IsCharacterMenuReset()) then
		return true;
	end;
	
	if (action == "spawn") then
		return true;
	else
	
		player:Spawn();
	end;
end;

-- Called when a player's data has loaded.
function Clockwork:PlayerDataLoaded(player)
	if (self.config:Get("clockwork_intro_enabled"):Get()) then
		if (!player:GetData("ClockworkIntro")) then
			umsg.Start("cwClockworkIntro", player);
			umsg.End();
			
			player:SetData("ClockworkIntro", true);
		end;
	end;
	
	self:StartDataStream(player, "Donations", player.cwDonations);
end;

-- Called when a player attempts to be given a weapon.
function Clockwork:PlayerCanBeGivenWeapon(player, class, itemTable)
	return true;
end;

-- Called when a player has been given a weapon.
function Clockwork:PlayerGivenWeapon(player, class, itemTable)
	self.inventory:Rebuild(player);
end;

-- Called when a player attempts to create a character.
function Clockwork:PlayerCanCreateCharacter(player, character, characterID)
	if (self.quiz:GetEnabled() and !self.quiz:GetCompleted(player)) then
		return "You have not completed the quiz!";
	else
		return true;
	end;
end;

-- Called when a player's bullet info should be adjusted.
function Clockwork:PlayerAdjustBulletInfo(player, bulletInfo) end;

-- Called when an entity fires some bullets.
function Clockwork:EntityFireBullets(entity, bulletInfo) end;

-- Called when a player's fall damage is needed.
function Clockwork:GetFallDamage(player, velocity)
	local ragdollEntity = nil;
	local position = player:GetPos();
	local damage = math.max((velocity - 464) * 0.225225225, 0) * self.config:Get("scale_fall_damage"):Get();
	local filter = {player};
	
	if (self.config:Get("wood_breaks_fall"):Get()) then
		if (player:IsRagdolled()) then
			ragdollEntity = player:GetRagdollEntity();
			position = ragdollEntity:GetPos();
			filter = {player, ragdollEntity};
		end;
		
		local traceLine = util.TraceLine({
			endpos = position - Vector(0, 0, 64),
			start = position,
			filter = filter
		});

		if (IsValid(traceLine.Entity) and traceLine.MatType == MAT_WOOD) then
			if (string.find(traceLine.Entity:GetClass(), "prop_physics")) then
				traceLine.Entity:Fire("Break", "", 0);
				damage = damage * 0.25;
			end;
		end;
	end;
	
	return damage;
end;

-- Called when a player's data stream info has been sent.
function Clockwork:PlayerDataStreamInfoSent(player)
	if (player:IsBot()) then
		self.player:LoadData(player, function(player)
			self.plugin:Call("PlayerDataLoaded", player);
			
			local factions = table.ClearKeys(self.faction:GetAll(), true);
			local faction = factions[math.random(1, #factions)];
			
			if (faction) then
				local genders = {GENDER_MALE, GENDER_FEMALE};
				local gender = faction.singleGender or genders[math.random(1, #genders)];
				local models = faction.models[string.lower(gender)];
				local model = models[math.random(1, #models)];
				
				self.player:LoadCharacter(player, 1, {
					faction = faction.name,
					gender = gender,
					model = model,
					name = player:Name(),
					data = {}
				}, function()
					self.player:LoadCharacter(player, 1);
				end);
			end;
		end);
	elseif (table.Count(self.faction:GetAll()) > 0) then
		self.player:LoadData(player, function()
			self.plugin:Call("PlayerDataLoaded", player);
			
			local whitelisted = player:GetData("Whitelisted");
			local steamName = player:SteamName();
			local unixTime = os.time();
			
			self.player:SetCharacterMenuState(player, CHARACTER_MENU_OPEN);
			
			if (whitelisted) then
				for k, v in pairs(whitelisted) do
					if (self.faction.stored[v]) then
						self:StartDataStream(player, "SetWhitelisted", {v, true});
					else
						whitelisted[k] = nil;
					end;
				end;
			end;
			
			self.player:GetCharacters(player, function(characters)
				if (characters) then
					for k, v in pairs(characters) do
						self.player:ConvertCharacterMySQL(v);
						player.cwCharacterList[v.characterID] = {};
						
						for k2, v2 in pairs(v) do
							if (k2 == "timeCreated") then
								if (v2 == "") then
									player.cwCharacterList[v.characterID][k2] = unixTime;
								else
									player.cwCharacterList[v.characterID][k2] = v2;
								end;
							elseif (k2 == "lastPlayed") then
								player.cwCharacterList[v.characterID][k2] = unixTime;
							elseif (k2 == "steamName") then
								player.cwCharacterList[v.characterID][k2] = steamName;
							else
								player.cwCharacterList[v.characterID][k2] = v2;
							end;
						end;
					end;
					
					for k, v in pairs(player.cwCharacterList) do
						local bDelete = self.plugin:Call("PlayerAdjustCharacterTable", player, v);
						
						if (!bDelete) then
							self.player:CharacterScreenAdd(player, v);
						else
							self.player:ForceDeleteCharacter(player, k);
						end;
					end;
				end;
				
				self.player:SetCharacterMenuState(player, CHARACTER_MENU_LOADED);
			end);
		end);
	end;
end;

-- Called when a player's data stream info should be sent.
function Clockwork:PlayerSendDataStreamInfo(player)
	if (self.OverrideColorMod) then
		Clockwork:StartDataStream(player, "SystemColGet", self.OverrideColorMod);
	end;
end;

-- Called when a player's death sound should be played.
function Clockwork:PlayerPlayDeathSound(player, gender)
	return "vo/npc/"..string.lower(gender).."01/pain0"..math.random(1, 9)..".wav";
end;

-- Called when a player's character data should be restored.
function Clockwork:PlayerRestoreCharacterData(player, data)
	if (data["PhysDesc"]) then
		data["PhysDesc"] = self:ModifyPhysDesc(data["PhysDesc"]);
	end;
	
	if (!data["LimbData"]) then
		data["LimbData"] = {};
	end;
	
	if (!data["Clothes"]) then
		data["Clothes"] = {};
	end;
end;

-- Called when a player's limb damage is bIsHealed.
function Clockwork:PlayerLimbDamageHealed(player, hitGroup, amount) end;

-- Called when a player's limb takes damage.
function Clockwork:PlayerLimbTakeDamage(player, hitGroup, damage) end;

-- Called when a player's limb damage is reset.
function Clockwork:PlayerLimbDamageReset(player) end;

-- Called when a player's character data should be saved.
function Clockwork:PlayerSaveCharacterData(player, data)
	if (self.config:Get("save_attribute_boosts"):Get()) then
		self:SavePlayerAttributeBoosts(player, data);
	end;
	
	data["Health"] = player:Health();
	data["Armor"] = player:Armor();
	
	if (data["Health"] <= 1) then
		data["Health"] = nil;
	end;
	
	if (data["Armor"] <= 1) then
		data["Armor"] = nil;
	end;
end;

-- Called when a player's data should be saved.
function Clockwork:PlayerSaveData(player, data)
	if (data["Whitelisted"] and #data["Whitelisted"] == 0) then
		data["Whitelisted"] = nil;
	end;
end;

-- Called when a player's storage should close.
function Clockwork:PlayerStorageShouldClose(player, storageTable)
	local entity = player:GetStorageEntity();
	
	if (player:IsRagdolled() or !player:Alive() or !entity or (storageTable.distance and player:GetShootPos():Distance(entity:GetPos()) > storageTable.distance)) then
		return true;
	elseif (storageTable.ShouldClose and storageTable.ShouldClose(player, storageTable)) then
		return true;
	end;
end;

-- Called when a player attempts to pickup a weapon.
function Clockwork:PlayerCanPickupWeapon(player, weapon)
	if (player.forceGive or (player:GetEyeTraceNoCursor().Entity == weapon and player:KeyDown(IN_USE))) then
		return true;
	else
		return false;
	end;
end;

-- Called each tick.
function Clockwork:Tick()
	local sysTime = SysTime();
	local curTime = CurTime();
	
	if (!self.NextHint or curTime >= self.NextHint) then
		self.hint:Distribute();
		self.NextHint = curTime + self.config:Get("hint_interval"):Get();
	end;
	
	if (!self.NextWagesTime or curTime >= self.NextWagesTime) then
		self:DistributeWagesCash();
		self.NextWagesTime = curTime + self.config:Get("wages_interval"):Get();
	end;
	
	if (!self.NextGeneratorTime or curTime >= self.NextGeneratorTime) then
		self:DistributeGeneratorCash();
		self.NextGeneratorTime = curTime + self.config:Get("generator_interval"):Get();
	end;
	
	if (!self.NextDateTimeThink or sysTime >= self.NextDateTimeThink) then
		self:PerformDateTimeThink();
		self.NextDateTimeThink = sysTime + self.config:Get("minute_time"):Get();
	end;
	
	if (!self.NextSaveData or sysTime >= self.NextSaveData) then
		self.plugin:Call("PreSaveData");
			self.plugin:Call("SaveData");
		self.plugin:Call("PostSaveData");
		
		self.NextSaveData = sysTime + self.config:Get("save_data_interval"):Get();
	end;
	
	if (!self.NextCheckEmpty) then
		self.NextCheckEmpty = sysTime + 1200;
	end;
	
	if (sysTime >= self.NextCheckEmpty) then
		self.NextCheckEmpty = nil;
		
		if (#_player.GetAll() == 0) then
			RunConsoleCommand("changelevel", game.GetMap());
		end;
	end;
end;

-- Called when a player's shared variables should be set.
function Clockwork:PlayerSetSharedVars(player, curTime)
	local weaponClass = self.player:GetWeaponClass(player);
	local r, g, b, a = player:GetColor();
	local isDrunk = self.player:GetDrunk(player);
	
	player:HandleAttributeProgress(curTime);
	player:HandleAttributeBoosts(curTime);
	
	player:SetSharedVar("PhysDesc", player:GetCharacterData("PhysDesc"));
	player:SetSharedVar("Flags", player:GetFlags());
	player:SetSharedVar("Model", player:GetDefaultModel());
	player:SetSharedVar("Name", player:Name());
	player:SetSharedVar("Cash", player:GetCash());
	
	local clothesItem = player:IsWearingClothes();
	
	if (clothesItem) then
		player:NetworkClothesData();
	else
		player:RemoveClothes();
	end;
	
	if (self.config:Get("enable_temporary_damage"):Get()) then
		local maxHealth = player:GetMaxHealth();
		local health = player:Health();
		
		if (player:Alive()) then
			if (health >= (maxHealth / 2)) then
				if (health < maxHealth) then
					player:SetHealth(math.Clamp(health + 1, 0, maxHealth));
				end;
			elseif (health > 0) then
				if (!player.cwNextSlowRegen) then
					player.cwNextSlowRegen = curTime + 6;
				end;
				
				if (curTime >= player.cwNextSlowRegen) then
					player.cwNextSlowRegen = nil;
					player:SetHealth(math.Clamp(health + 1, 0, maxHealth));
				end;
			end;
		end;
	end;
	
	if (r == 255 and g == 0 and b == 0 and a == 0) then
		player:SetColor(255, 255, 255, 255);
	end;
	
	for k, v in pairs(player:GetWeapons()) do
		local ammoType = v:GetPrimaryAmmoType();
		
		if (ammoType == "grenade" and player:GetAmmoCount(ammoType) == 0) then
			player:StripWeapon(v:GetClass());
		end;
	end;
	
	if (player.cwDrunkTab) then
		for k, v in pairs(player.cwDrunkTab) do
			if (curTime >= v) then
				table.remove(player.cwDrunkTab, k);
			end;
		end;
	end;
	
	if (isDrunk) then
		player:SetSharedVar("IsDrunk", isDrunk);
	else
		player:SetSharedVar("IsDrunk", 0);
	end;
end;

-- Called when a player picks an item up.
function Clockwork:PlayerPickupItem(player, itemTable, itemEntity, bQuickUse) end;

-- Called when a player uses an item.
function Clockwork:PlayerUseItem(player, itemTable, itemEntity) end;

-- Called when a player drops an item.
function Clockwork:PlayerDropItem(player, itemTable, position, entity) end;

-- Called when a player destroys an item.
function Clockwork:PlayerDestroyItem(player, itemTable) end;

-- Called when a player drops a weapon.
function Clockwork:PlayerDropWeapon(player, itemTable, entity, weapon)
	if (itemTable:IsInstance() and IsValid(weapon)) then
		local clipOne = weapon:Clip1();
		local clipTwo = weapon:Clip2();
		
		if (clipOne > 0) then
			itemTable:SetData("ClipOne", clipOne);
		end;
		
		if (clipTwo > 0) then
			itemTable:SetData("ClipTwo", clipTwo);
		end;
	end;
end;

-- Called when a player charges generator.
function Clockwork:PlayerChargeGenerator(player, entity, generator) end;

-- Called when a player destroys generator.
function Clockwork:PlayerDestroyGenerator(player, entity, generator) end;

-- Called when a player's data should be restored.
function Clockwork:PlayerRestoreData(player, data)
	if (!data["Whitelisted"]) then
		data["Whitelisted"] = {};
	end;
end;

-- Called to get whether a player can pickup an entity.
function Clockwork:AllowPlayerPickup(player, entity)
	return false;
end;

-- Called when a player's temporary info should be saved.
function Clockwork:PlayerSaveTempData(player, tempData) end;

-- Called when a player's temporary info should be restored.
function Clockwork:PlayerRestoreTempData(player, tempData) end;

-- Called when a player selects a custom character option.
function Clockwork:PlayerSelectCharacterOption(player, character, option) end;

-- Called when a player attempts to see another player's status.
function Clockwork:PlayerCanSeeStatus(player, target)
	return "# "..target:UserID().." | "..target:Name().." | "..target:SteamName().." | "..target:SteamID().." | "..target:IPAddress();
end;

-- Called when a player attempts to see a player's chat.
function Clockwork:PlayerCanSeePlayersChat(text, teamOnly, listener, speaker)
	return true;
end;

-- Called when a player attempts to hear another player's voice.
function Clockwork:PlayerCanHearPlayersVoice(listener, speaker)
	if (self.config:Get("local_voice"):Get()) then
		if (listener:IsRagdolled(RAGDOLL_FALLENOVER) or !listener:Alive()) then
			return false;
		elseif (speaker:IsRagdolled(RAGDOLL_FALLENOVER) or !speaker:Alive()) then
			return false;
		elseif (listener:GetPos():Distance(speaker:GetPos()) > self.config:Get("talk_radius"):Get()) then
			return false;
		end;
	end;
	
	return true, true;
end;

-- Called when a player attempts to delete a character.
function Clockwork:PlayerCanDeleteCharacter(player, character)
	if (self.config:Get("cash_enabled"):Get() and character.cash < self.config:Get("default_cash"):Get()) then
		if (!character.data["CharBanned"]) then
			return "You cannot delete characters with less than "..FORMAT_CASH(self.config:Get("default_cash"):Get(), nil, true)..".";
		end;
	end;
end;

-- Called when a player attempts to switch to a character.
function Clockwork:PlayerCanSwitchCharacter(player, character)
	if (!player:Alive() and !player:IsCharacterMenuReset()) then
		return "You cannot switch characters when you are dead!";
	end;
	
	return true;
end;

-- Called when a player attempts to use a character.
function Clockwork:PlayerCanUseCharacter(player, character)
	if (character.data["CharBanned"]) then
		return character.name.." is banned and cannot be used!";
	end;
end;

-- Called when a player's weapons should be given.
function Clockwork:PlayerGiveWeapons(player) end;

-- Called when a player deletes a character.
function Clockwork:PlayerDeleteCharacter(player, character) end;

-- Called when a player's armor is set.
function Clockwork:PlayerArmorSet(player, newArmor, oldArmor)
	if (player:IsRagdolled()) then
		player:GetRagdollTable().armor = newArmor;
	end;
end;

-- Called when a player's health is set.
function Clockwork:PlayerHealthSet(player, newHealth, oldHealth)
	if (player:IsRagdolled()) then
		player:GetRagdollTable().health = newHealth;
	end;
	
	if (newHealth > oldHealth) then
		self.limb:HealBody(player, (newHealth - oldHealth) / 2);
	end;
	
	if (newHealth >= player:GetMaxHealth()) then
		self.limb:HealBody(player, 100);
	end;
end;

-- Called when a player attempts to own a door.
function Clockwork:PlayerCanOwnDoor(player, door)
	if (self.entity:IsDoorUnownable(door)) then
		return false;
	else
		return true;
	end;
end;

-- Called when a player attempts to view a door.
function Clockwork:PlayerCanViewDoor(player, door)
	if (self.entity:IsDoorUnownable(door)) then
		return false;
	end;
	
	return true;
end;

-- Called when a player attempts to holster a weapon.
function Clockwork:PlayerCanHolsterWeapon(player, itemTable, weapon, bForce, bNoMsg)
	if (self.player:GetSpawnWeapon(player, itemTable("weaponClass"))) then
		if (!bNoMsg) then
			self.player:Notify(player, "You cannot holster this weapon!");
		end;
		
		return false;
	elseif (itemTable.CanHolsterWeapon) then
		return itemTable:CanHolsterWeapon(player, weapon, bForce, bNoMsg);
	else
		return true;
	end;
end;

-- Called when a player attempts to drop a weapon.
function Clockwork:PlayerCanDropWeapon(player, itemTable, weapon, bNoMsg)
	if (self.player:GetSpawnWeapon(player, itemTable("weaponClass"))) then
		if (!bNoMsg) then
			self.player:Notify(player, "You cannot drop this weapon!");
		end;
		
		return false;
	elseif (itemTable.CanDropWeapon) then
		return itemTable:CanDropWeapon(player, bNoMsg);
	else
		return true;
	end;
end;

-- Called when a player attempts to use an item.
function Clockwork:PlayerCanUseItem(player, itemTable, bNoMsg)
	if (self.item:IsWeapon(itemTable) and self.player:GetSpawnWeapon(player, itemTable("weaponClass"))) then
		if (!bNoMsg) then
			self.player:Notify(player, "You cannot use this weapon!");
		end;
		
		return false;
	else
		return true;
	end;
end;

-- Called when a player attempts to drop an item.
function Clockwork:PlayerCanDropItem(player, itemTable, bNoMsg) return true; end;

-- Called when a player attempts to destroy an item.
function Clockwork:PlayerCanDestroyItem(player, itemTable, bNoMsg) return true; end;

-- Called when a player attempts to destroy generator.
function Clockwork:PlayerCanDestroyGenerator(player, entity, generator) return true; end;

-- Called when a player attempts to knockout a player.
function Clockwork:PlayerCanKnockout(player, target) return true; end;

-- Called when a player attempts to use the radio.
function Clockwork:PlayerCanRadio(player, text, listeners, eavesdroppers) return true; end;

-- Called when death attempts to clear a player's name.
function Clockwork:PlayerCanDeathClearName(player, attacker, damageInfo) return false; end;

-- Called when death attempts to clear a player's recognised names.
function Clockwork:PlayerCanDeathClearRecognisedNames(player, attacker, damageInfo) return false; end;

-- Called when a player's ragdoll attempts to take damage.
function Clockwork:PlayerRagdollCanTakeDamage(player, ragdoll, inflictor, attacker, hitGroup, damageInfo)
	if (!attacker:IsPlayer() and player:GetRagdollTable().immunity) then
		if (CurTime() <= player:GetRagdollTable().immunity) then
			return false;
		end;
	end;
	
	return true;
end;

-- Called when the player attempts to be ragdolled.
function Clockwork:PlayerCanRagdoll(player, state, delay, decay, ragdoll)
	return true;
end;

-- Called when the player attempts to be unragdolled.
function Clockwork:PlayerCanUnragdoll(player, state, ragdoll)
	return true;
end;

-- Called when a player has been ragdolled.
function Clockwork:PlayerRagdolled(player, state, ragdoll)
	player:SetSharedVar("FallenOver", false);
end;

-- Called when a player has been unragdolled.
function Clockwork:PlayerUnragdolled(player, state, ragdoll)
	player:SetSharedVar("FallenOver", false);
end;

-- Called to check if a player does have a flag.
function Clockwork:PlayerDoesHaveFlag(player, flag)
	if (string.find(self.config:Get("default_flags"):Get(), flag)) then
		return true;
	end;
end;

-- Called to check if a player does have door access.
function Clockwork:PlayerDoesHaveDoorAccess(player, door, access, isAccurate)
	if (self.entity:GetOwner(door) != player) then
		local key = player:GetCharacterKey();
		
		if (door.accessList and door.accessList[key]) then
			if (isAccurate) then
				return door.accessList[key] == access;
			else
				return door.accessList[key] >= access;
			end;
		end;
		
		return false;
	else
		return true;
	end;
end;

-- Called to check if a player does know another player.
function Clockwork:PlayerDoesRecognisePlayer(player, target, status, isAccurate, realValue)
	return realValue;
end;

-- Called when a player attempts to lock an entity.
function Clockwork:PlayerCanLockEntity(player, entity)
	if (self.entity:IsDoor(entity)) then
		return self.player:HasDoorAccess(player, entity);
	else
		return true;
	end;
end;

-- Called when a player's class has been set.
function Clockwork:PlayerClassSet(player, newClass, oldClass, noRespawn, addDelay, noModelChange) end;

-- Called when a player attempts to unlock an entity.
function Clockwork:PlayerCanUnlockEntity(player, entity)
	if (self.entity:IsDoor(entity)) then
		return self.player:HasDoorAccess(player, entity);
	else
		return true;
	end;
end;

-- Called when a player attempts to use a door.
function Clockwork:PlayerCanUseDoor(player, door)
	if (self.entity:GetOwner(door) and !self.player:HasDoorAccess(player, door)) then
		return false;
	end;
	
	if (self.entity:IsDoorFalse(door)) then
		return false;
	end;
	
	return true;
end;

-- Called when a player uses a door.
function Clockwork:PlayerUseDoor(player, door) end;

-- Called when a player attempts to use an entity in a vehicle.
function Clockwork:PlayerCanUseEntityInVehicle(player, entity, vehicle)
	if (entity.UsableInVehicle or self.entity:IsDoor(entity)) then
		return true;
	end;
end;

-- Called when a player's ragdoll attempts to decay.
function Clockwork:PlayerCanRagdollDecay(player, ragdoll, seconds)
	return true;
end;

-- Called when a player attempts to exit a vehicle.
function Clockwork:CanExitVehicle(vehicle, player)
	if (player.cwNextExitVehicle and player.cwNextExitVehicle > CurTime()) then
		return false;
	end;
	
	if (IsValid(player) and player:IsPlayer()) then
		local trace = player:GetEyeTraceNoCursor();
		
		if (IsValid(trace.Entity) and !trace.Entity:IsVehicle()) then
			if (self.plugin:Call("PlayerCanUseEntityInVehicle", player, trace.Entity, vehicle)) then
				return false;
			end;
		end;
	end;
	
	if (self.entity:IsChairEntity(vehicle) and !IsValid(vehicle:GetParent())) then
		local trace = player:GetEyeTraceNoCursor();
		
		if (trace.HitPos:Distance(player:GetShootPos()) <= 192) then
			trace = {
				start = trace.HitPos,
				endpos = trace.HitPos - Vector(0, 0, 1024),
				filter = {player, vehicle}
			};
			
			player.cwExitVehiclePos = util.TraceLine(trace).HitPos;
			
			player:SetMoveType(MOVETYPE_NOCLIP);
		else
			return false;
		end;
	end;
	
	return true;
end;

-- Called when a player leaves a vehicle.
function Clockwork:PlayerLeaveVehicle(player, vehicle)
	timer.Simple(FrameTime() * 0.5, function()
		if (IsValid(player) and !player:InVehicle()) then
			if (IsValid(vehicle)) then
				if (self.entity:IsChairEntity(vehicle)) then
					local position = player.cwExitVehiclePos or vehicle:GetPos();
					local targetPosition = self.player:GetSafePosition(player, position, vehicle);
					
					if (targetPosition) then
						player:SetMoveType(MOVETYPE_NOCLIP);
						player:SetPos(targetPosition);
					end;
					
					player:SetMoveType(MOVETYPE_WALK);
					player.cwExitVehiclePos = nil;
				end;
			end;
		end;
	end);
end;

-- Called when a player enters a vehicle.
function Clockwork:PlayerEnteredVehicle(player, vehicle, class)
	timer.Simple(FrameTime() * 0.5, function()
		if (IsValid(player)) then
			local model = player:GetModel();
			local class = self.animation:GetModelClass(model);
			
			if (IsValid(vehicle) and !string.find(model, "/player/")) then
				if (class == "maleHuman" or class == "femaleHuman") then
					if (self.entity:IsChairEntity(vehicle)) then
						player:SetLocalPos(Vector(16.5438, -0.1642, -20.5493));
					else
						player:SetLocalPos(Vector(30.1880, 4.2020, -6.6476));
					end;
				end;
			end;
			
			player:SetCollisionGroup(COLLISION_GROUP_PLAYER);
		end;
	end);
end;

-- Called when a player attempts to change class.
function Clockwork:PlayerCanChangeClass(player, class)
	local curTime = CurTime();
	
	if (player.cwNextChangeClass and curTime < player.cwNextChangeClass) then
		self.player:Notify(player, "You cannot change class for another "..math.ceil(player.cwNextChangeClass - curTime).." second(s)!");
		
		return false;
	else
		return true;
	end;
end;

-- Called when a player attempts to earn generator cash.
function Clockwork:PlayerCanEarnGeneratorCash(player, info, cash)
	return true;
end;

-- Called when a player earns generator cash.
function Clockwork:PlayerEarnGeneratorCash(player, info, cash) end;

-- Called when a player attempts to earn wages cash.
function Clockwork:PlayerCanEarnWagesCash(player, cash)
	return true;
end;

-- Called when a player is given wages cash.
function Clockwork:PlayerGiveWagesCash(player, cash, wagesName)
	return true;
end;

-- Called when a player earns wages cash.
function Clockwork:PlayerEarnWagesCash(player, cash) end;

-- Called when Clockwork has loaded all of the entities.
function Clockwork:ClockworkInitPostEntity() end;

-- Called when a player attempts to say something in-character.
function Clockwork:PlayerCanSayIC(player, text)
	if ((!player:Alive() or player:IsRagdolled(RAGDOLL_FALLENOVER)) and !self.player:GetDeathCode(player, true)) then
		self.player:Notify(player, "You cannot do this action at the moment!");
		
		return false;
	else
		return true;
	end;
end;

-- Called when a player attempts to say something out-of-character.
function Clockwork:PlayerCanSayOOC(player, text) return true; end;

-- Called when a player attempts to say something locally out-of-character.
function Clockwork:PlayerCanSayLOOC(player, text) return true; end;

-- Called when attempts to use a command.
function Clockwork:PlayerCanUseCommand(player, commandTable, arguments) return true; end;

-- Called when a player says something.
function Clockwork:PlayerSay(player, text, public)
	text = Clockwork:Replace(text, " ' ", "'");
	text = Clockwork:Replace(text, " : ", ":");
	text = Clockwork:Replace(text, "\\\"", "\"");
	
	local prefix = self.config:Get("command_prefix"):Get();
	local curTime = CurTime();
	
	if (string.sub(text, 1, 2) == "//") then
		text = string.Trim(string.sub(text, 3));
		
		if (text != "") then
			if (self.plugin:Call("PlayerCanSayOOC", player, text)) then
				if (Clockwork.player:HasAnyFlags(player, "oas") or !player.cwNextTalkOOC or curTime > player.cwNextTalkOOC) then
					self:ServerLog("[OOC] "..player:Name()..": "..text);
						self.chatBox:Add(nil, player, "ooc", text);
					player.cwNextTalkOOC = curTime + self.config:Get("ooc_interval"):Get();
				else
					self.player:Notify(player, "You cannot cannot talk out-of-character for another "..math.ceil(player.cwNextTalkOOC - CurTime()).." second(s)!");
					
					return "";
				end;
			end;
		end;
	elseif (string.sub(text, 1, 3) == ".//" or string.sub(text, 1, 2) == "[[") then
		if (string.sub(text, 1, 3) == ".//") then
			text = string.Trim(string.sub(text, 4));
		else
			text = string.Trim(string.sub(text, 3));
		end;
		
		if (text != "") then
			if (self.plugin:Call("PlayerCanSayLOOC", player, text)) then
				self.chatBox:AddInRadius(player, "looc", text, player:GetPos(), self.config:Get("talk_radius"):Get());
			end;
		end;
	elseif (string.sub(text, 1, 1) == prefix) then
		local prefixLength = string.len(prefix);
		local arguments = self:ExplodeByTags(text, " ", "\"", "\"", true);
		local command = string.sub(arguments[1], prefixLength + 1);
		
		if (self.command.stored[command] and self.command.stored[command].arguments < 2
		and !self.command.stored[command].optionalArguments) then
			text = string.sub(text, string.len(command) + prefixLength + 2);
			
			if (text != "") then
				arguments = {command, text};
			else
				arguments = {command};
			end;
		else
			arguments[1] = command;
		end;
		
		self.command:ConsoleCommand(player, "cwCmd", arguments);
	elseif (self.plugin:Call("PlayerCanSayIC", player, text)) then
		self.chatBox:AddInRadius(player, "ic", text, player:GetPos(), self.config:Get("talk_radius"):Get());
		
		if (self.player:GetDeathCode(player, true)) then
			self.player:UseDeathCode(player, nil, {text});
		end;
	end;
	
	if (self.player:GetDeathCode(player)) then
		self.player:TakeDeathCode(player);
	end;
	
	return "";
end;

-- Called when a player attempts to suicide.
function Clockwork:CanPlayerSuicide(player) return false; end;

-- Called when a player attempts to punt an entity with the gravity gun.
function Clockwork:GravGunPunt(player, entity)
	return self.config:Get("enable_gravgun_punt"):Get();
end;

-- Called when a player attempts to pickup an entity with the gravity gun.
function Clockwork:GravGunPickupAllowed(player, entity)
	if (IsValid(entity)) then
		if (!self.player:IsAdmin(player) and !self.entity:IsInteractable(entity)) then
			return false;
		else
			return self.BaseClass:GravGunPickupAllowed(player, entity);
		end;
	end;
	
	return false;
end;

-- Called when a player picks up an entity with the gravity gun.
function Clockwork:GravGunOnPickedUp(player, entity)
	player.cwIsHoldingEnt = entity;
	entity.cwIsBeingHeld = player;
end;

-- Called when a player drops an entity with the gravity gun.
function Clockwork:GravGunOnDropped(player, entity)
	player.cwIsHoldingEnt = nil;
	entity.cwIsBeingHeld = nil;
end;

-- Called when a player attempts to unfreeze an entity.
function Clockwork:CanPlayerUnfreeze(player, entity, physicsObject)
	local bIsAdmin = self.player:IsAdmin(player);
	
	if (self.config:Get("enable_prop_protection"):Get() and !bIsAdmin) then
		local ownerKey = entity:GetOwnerKey();
		
		if (ownerKey and player:GetCharacterKey() != ownerKey) then
			return false;
		end;
	end;
	
	if (!bIsAdmin and !self.entity:IsInteractable(entity)) then
		return false;
	end;
	
	if (entity:IsVehicle()) then
		if (IsValid(entity:GetDriver())) then
			return false;
		end;
	end;
	
	return true;
end;

-- Called when a player attempts to freeze an entity with the physics gun.
function Clockwork:OnPhysgunFreeze(weapon, physicsObject, entity, player)
	local bIsAdmin = self.player:IsAdmin(player);
	
	if (self.config:Get("enable_prop_protection"):Get() and !bIsAdmin) then
		local ownerKey = entity:GetOwnerKey();
		
		if (ownerKey and player:GetCharacterKey() != ownerKey) then
			return false;
		end;
	end;
	
	if (!bIsAdmin and self.entity:IsChairEntity(entity)) then
		local entities = ents.FindInSphere(entity:GetPos(), 64);
		
		for k, v in ipairs(entities) do
			if (self.entity:IsDoor(v)) then
				return false;
			end;
		end;
	end;
	
	if (entity:GetPhysicsObject():IsPenetrating()) then
		return false;
	end;
	
	if (!bIsAdmin and entity.PhysgunDisabled) then
		return false;
	end;
	
	if (!bIsAdmin and !self.entity:IsInteractable(entity)) then
		return false;
	else
		return self.BaseClass:OnPhysgunFreeze(weapon, physicsObject, entity, player);
	end;
end;

-- Called when a player attempts to pickup an entity with the physics gun.
function Clockwork:PhysgunPickup(player, entity)
	local bCanPickup = nil;
	local bIsAdmin = self.player:IsAdmin(player);
	
	if (!bIsAdmin and !self.entity:IsInteractable(entity)) then
		return false;
	end;
	
	if (!bIsAdmin and self.entity:IsPlayerRagdoll(entity)) then
		return false;
	end;
	
	if (!bIsAdmin and entity:GetClass() == "prop_ragdoll") then
		local ownerKey = entity:GetOwnerKey();
		
		if (ownerKey and player:GetCharacterKey() != ownerKey) then
			return false;
		end;
	end;
	
	if (!bIsAdmin) then
		bCanPickup = self.BaseClass:PhysgunPickup(player, entity);
	else
		bCanPickup = true;
	end;
	
	if (self.entity:IsChairEntity(entity) and !bIsAdmin) then
		local entities = ents.FindInSphere(entity:GetPos(), 256);
		
		for k, v in ipairs(entities) do
			if (self.entity:IsDoor(v)) then
				return false;
			end;
		end;
	end;
	
	if (self.config:Get("enable_prop_protection"):Get() and !bIsAdmin) then
		local ownerKey = entity:GetOwnerKey();
		
		if (ownerKey and player:GetCharacterKey() != ownerKey) then
			bCanPickup = false;
		end;
	end;
	
	if (entity:IsPlayer() and entity:InVehicle()) then
		bCanPickup = false;
	end;
	
	if (bCanPickup) then
		player.cwIsHoldingEnt = entity;
		entity.cwIsBeingHeld = player;
		
		if (!entity:IsPlayer()) then
			if (self.config:Get("prop_kill_protection"):Get()) then
				entity.cwLastCollideGroup = entity:GetCollisionGroup();
				entity:SetCollisionGroup(COLLISION_GROUP_WEAPON);
				entity.cwDamageImmunity = CurTime() + 60;
			end;
		else
			entity.cwMoveType = entity:GetMoveType();
			entity:SetMoveType(MOVETYPE_NOCLIP);
		end;
		
		return true;
	else
		return false;
	end;
end;

-- Called when a player attempts to drop an entity with the physics gun.
function Clockwork:PhysgunDrop(player, entity)
	if (!entity:IsPlayer()) then
		if (entity.cwLastCollideGroup) then
			self.entity:ReturnCollisionGroup(entity, entity.cwLastCollideGroup);
		end;
	else
		entity:SetMoveType(entity.cwMoveType or MOVETYPE_WALK);
		entity.cwMoveType = nil;
	end;
	
	player.cwIsHoldingEnt = nil;
	entity.cwIsBeingHeld = nil;
end;

-- Called when a player attempts to spawn an NPC.
function Clockwork:PlayerSpawnNPC(player, model)
	if (!self.player:HasFlags(player, "n")) then
		return false;
	end;
	
	if (!player:Alive() or player:IsRagdolled()) then
		self.player:Notify(player, "You cannot do this action at the moment!");
		
		return false;
	end;
	
	if (!self.player:IsAdmin(player)) then
		return false;
	else
		return true;
	end;
end;

-- Called when an NPC has been killed.
function Clockwork:OnNPCKilled(entity, attacker, inflictor) end;

-- Called to get whether an entity is being held.
function Clockwork:GetEntityBeingHeld(entity)
	return entity.cwIsBeingHeld or entity:IsPlayerHolding();
end;

-- Called when an entity is removed.
function Clockwork:EntityRemoved(entity)
	if (!self:IsShuttingDown()) then
		if (IsValid(entity)) then
			local allProperty = self.player:GetAllProperty();
			local entIndex = entity:EntIndex();
			
			if (entity.cwGiveRefundTab
			and CurTime() <= entity.cwGiveRefundTab[1]) then
				if (IsValid(entity.cwGiveRefundTab[2])) then
					self.player:GiveCash(entity.cwGiveRefundTab[2], entity.cwGiveRefundTab[3], "Prop Refund");
				end;
			end;
			
			allProperty[entIndex] = nil;
			
			if (entity:GetClass() == "csItem") then
				self.item:RemoveItemEntity(entity);
			end;
		end;
		
		self.entity:ClearProperty(entity);
	end;
end;

-- Called when an entity's menu option should be handled.
function Clockwork:EntityHandleMenuOption(player, entity, option, arguments)
	if (player.nextUseTime and CurTime() < player.nextUseTime) then
		return;
	end;

	player.nextUseTime = CurTime() + 1;

	local class = entity:GetClass();
	local generator = self.generator:Get(class);
	
	if (class == "cw_item" and (arguments == "cwItemTake" or arguments == "cwItemUse")) then
		if (self.entity:BelongsToAnotherCharacter(player, entity)) then
			self.player:Notify(player, "You cannot pick up items you dropped on another character!");
			return;
		end;
		
		player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
		
		local itemTable = entity.cwItemTable;
		local bQuickUse = (arguments == "cwItemUse");
		
		if (itemTable) then
			local bDidPickupItem = true;
			local bCanPickup = (!itemTable.CanPickup or itemTable:CanPickup(player, bQuickUse, entity));
			
			if (bCanPickup != false) then
				player:SetItemEntity(entity);
				
				if (bQuickUse) then
					itemTable = player:GiveItem(itemTable, true);
					
					if (!self.player:InventoryAction(player, itemTable, "use")) then
						player:TakeItem(itemTable, true);
						bDidPickupItem = false;
					else
						player:FakePickup(entity);
					end;
				else
					local success, fault = player:GiveItem(itemTable);
					
					if (!success) then
						self.player:Notify(player, fault);
						bDidPickupItem = false;
					else
						player:FakePickup(entity);
					end;
				end;
				
				Clockwork.plugin:Call(
					"PlayerPickupItem", player, itemTable, entity, bQuickUse
				);
				
				if (bDidPickupItem) then
					if (!itemTable.OnPickup or itemTable:OnPickup(player, bQuickUse, entity) != false) then
						entity:Remove();
					end;
				end;
				
				player:SetItemEntity(nil);
			end;
			
		end;
	elseif (class == "cw_item" and arguments == "cwItemAmmo") then
		local itemTable = entity.cwItemTable;
		
		if (self.item:IsWeapon(itemTable)) then
			if (itemTable:HasSecondaryClip() or itemTable:HasPrimaryClip()) then
				local clipOne = itemTable:GetData("ClipOne");
				local clipTwo = itemTable:GetData("ClipTwo");
				
				if (clipTwo > 0) then
					player:GiveAmmo(clipTwo, itemTable("secondaryAmmoClass"));
				end;
				
				if (clipOne > 0) then
					player:GiveAmmo(clipOne, itemTable("primaryAmmoClass"));
				end;
				
				itemTable:SetData("ClipOne", 0);
				itemTable:SetData("ClipTwo", 0);
				
				player:FakePickup(entity);
			end;
		end;
	elseif (class == "cw_shipment" and arguments == "cwShipmentOpen") then
		player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
		player:FakePickup(entity);
		
		self.storage:Open(player, {
			name = "Shipment",
			weight = entity.cwWeight,
			entity = entity,
			distance = 192,
			inventory = entity.cwInventory,
			OnClose = function(player, storageTable, entity)
				if (IsValid(entity) and Clockwork.inventory:IsEmpty(entity.cwInventory)) then
					entity:Explode(entity:BoundingRadius() * 2);
					entity:Remove();
				end;
			end,
			CanGiveItem = function(player, storageTable, itemTable)
				return false;
			end
		});
	elseif (class == "cw_cash" and arguments == "cwCashTake") then
		if (self.entity:BelongsToAnotherCharacter(player, entity)) then
			self.player:Notify(player, "You cannot pick up "..self.option:GetKey("name_cash", true).." you dropped on another character!");
			
			return;
		end;
		
		self.player:GiveCash(player, entity.cwAmount, self.option:GetKey("name_cash"));
		player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
		player:FakePickup(entity);
		
		entity:Remove();
	elseif (generator and arguments == "cwGeneratorSupply") then
		if (entity:GetPower() < generator.power) then
			if (!entity.CanSupply or entity:CanSupply(player)) then
				self.plugin:Call("PlayerChargeGenerator", player, entity, generator);
				
				entity:SetDTInt("Power", generator.power);
				player:FakePickup(entity);
				
				if (entity.OnSupplied) then
					entity:OnSupplied(player);
				end;
				
				entity:Explode();
			end;
		end;
	end;
end;

-- Called when a player has spawned a prop.
function Clockwork:PlayerSpawnedProp(player, model, entity)
	if (IsValid(entity)) then
		-- local scalePropCost = self.config:Get("scale_prop_cost"):Get();
		
		-- if (scalePropCost > 0) then
			-- local cost = math.ceil(math.max((entity:BoundingRadius() / 2) * scalePropCost, 1));
			-- local info = {cost = cost, name = "Prop"};
			
			-- self.plugin:Call("PlayerAdjustPropCostInfo", player, entity, info);
			
			-- if (self.player:CanAfford(player, info.cost)) then
				-- self.player:GiveCash(player, -info.cost, info.name);
				-- entity.cwGiveRefundTab = {CurTime() + 10, player, info.cost};
			-- else
				-- self.player:Notify(player, "You need another "..FORMAT_CASH(info.cost - player:GetCash(), nil, true).."!");
				-- entity:Remove();
				-- return;
			-- end;
		-- end;
		
		if (IsValid(entity)) then
			self.BaseClass:PlayerSpawnedProp(player, model, entity);
			entity:SetOwnerKey(player:GetCharacterKey());
			
			if (IsValid(entity)) then
				self:PrintLog(LOGTYPE_URGENT, player:Name().." has spawned '"..tostring(model).."'.");
				
				if (self.config:Get("prop_kill_protection"):Get()) then
					entity.cwDamageImmunity = CurTime() + 60;
				end;
			end;
		end;
	end;
end;

-- Called when a player attempts to spawn a prop.
function Clockwork:PlayerSpawnProp(player, model)
	if (!self.player:HasFlags(player, "e")) then
		return false;
	end;
	
	if (!player:Alive() or player:IsRagdolled()) then
		self.player:Notify(player, "You cannot do this action at the moment!");
		return false;
	end;
	
	if (self.player:IsAdmin(player)) then
		return true;
	end;
	
	return self.BaseClass:PlayerSpawnProp(player, model);
end;

-- Called when a player attempts to spawn a ragdoll.
function Clockwork:PlayerSpawnRagdoll(player, model)
	if (!self.player:HasFlags(player, "r")) then return false; end;
	
	if (!player:Alive() or player:IsRagdolled()) then
		self.player:Notify(player, "You cannot do this action at the moment!");
		
		return false;
	end;
		
	-- if (!self.player:IsAdmin(player)) then
		-- return false;
	-- else
		-- return true;
	-- end;
	return true;

end;

-- Called when a player attempts to spawn an effect.
function Clockwork:PlayerSpawnEffect(player, model)
	if (!player:Alive() or player:IsRagdolled()) then
		self.player:Notify(player, "You cannot do this action at the moment!");
		
		return false;
	end;
	
	if (!self.player:IsAdmin(player)) then
		return false;
	else
		return true;
	end;
end;

-- Called when a player attempts to spawn a vehicle.
function Clockwork:PlayerSpawnVehicle(player, model)
	if (!string.find(model, "chair") and !string.find(model, "seat")) then
		if (!self.player:HasFlags(player, "C")) then
			return false;
		end;
	elseif (!self.player:HasFlags(player, "c")) then
		return false;
	end;
	
	if (!player:Alive() or player:IsRagdolled()) then
		self.player:Notify(player, "You cannot do this action at the moment!");
		
		return false;
	end;
	
	if (self.player:IsAdmin(player)) then
		return true;
	end;
	
	return self.BaseClass:PlayerSpawnVehicle(player, model);
end;

-- Called when a player attempts to use a tool.
function Clockwork:CanTool(player, trace, tool)
	local bIsAdmin = self.player:IsAdmin(player);
	
	if (IsValid(trace.Entity)) then
		local isPropProtectionEnabled = self.config:Get("enable_prop_protection"):Get();
		local characterKey = player:GetCharacterKey();
		
		if (!bIsAdmin and !self.entity:IsInteractable(trace.Entity)) then
			return false;
		end;
		
		if (!bIsAdmin and self.entity:IsPlayerRagdoll(trace.Entity)) then
			return false;
		end;
		
		if (isPropProtectionEnabled and !bIsAdmin) then
			local ownerKey = trace.Entity:GetOwnerKey();
			
			if (ownerKey and characterKey != ownerKey) then
				return false;
			end;
		end;
		
		if (!bIsAdmin) then
			if (tool == "nail") then
				local newTrace = {};
				
				newTrace.start = trace.HitPos;
				newTrace.endpos = trace.HitPos + player:GetAimVector() * 16;
				newTrace.filter = {player, trace.Entity};
				
				newTrace = util.TraceLine(newTrace);
				
				if (IsValid(newTrace.Entity)) then
					if (!self.entity:IsInteractable(newTrace.Entity) or self.entity:IsPlayerRagdoll(newTrace.Entity)) then
						return false;
					end;
					
					if (isPropProtectionEnabled) then
						local ownerKey = newTrace.Entity:GetOwnerKey();
						
						if (ownerKey and characterKey != ownerKey) then
							return false;
						end;
					end;
				end;
			elseif (tool == "remover" and player:KeyDown(IN_ATTACK2) and !player:KeyDownLast(IN_ATTACK2)) then
				if (!trace.Entity:IsMapEntity()) then
					local entities = constraint.GetAllConstrainedEntities(trace.Entity);
					
					for k, v in pairs(entities) do
						if (v:IsMapEntity() or self.entity:IsPlayerRagdoll(v)) then
							return false;
						end;
						
						if (isPropProtectionEnabled) then
							local ownerKey = v:GetOwnerKey();
							
							if (ownerKey and characterKey != ownerKey) then
								return false;
							end;
						end;
					end
				else
					return false;
				end;
			end
		end;
	end;
	
	if (!bIsAdmin) then
		return self.BaseClass:CanTool(player, trace, tool);
	else
		return true;
	end;
end;

-- Called when a player attempts to NoClip.
function Clockwork:PlayerNoClip(player)
	if (player:IsRagdolled()) then
		return false;
	elseif (player:IsSuperAdmin()) then
		return true;
	else
		return false;
	end;
end;

-- Called when a player's character has initialized.
function Clockwork:PlayerCharacterInitialized(player)
	umsg.Start("cwInvClear", player);
	umsg.End();
	
	umsg.Start("cwAttrClear", player);
	umsg.End();
	
	self:StartDataStream(player, "ReceiveLimbDamage", player:GetCharacterData("LimbData"));
	
	if (!self.class:Get(player:Team())) then
		self.class:AssignToDefault(player);
	end;
	
	player.cwAttrProgress = {};
	player.cwAttrProgressTime = 0;
	
	for k, v in pairs(self.attribute:GetAll()) do
		player:UpdateAttribute(k);
	end;
	
	for k, v in pairs(player:GetAttributes()) do
		player.cwAttrProgress[k] = math.floor(v.progress);
	end;
	
	local startHintsDelay = 4;
	local starterHintsTable = {
		"Directory",
		"Give Name",
		"Target Recognises",
		"Raise Weapon"
	};
	
	for k, v in ipairs(starterHintsTable) do
		local hintTable = self.hint:Find(v);
		
		if (hintTable and !player:GetData("Hint"..k)) then
			if (!hintTable.Callback or hintTable.Callback(player) != false) then
				timer.Simple(startHintsDelay, function()
					if (IsValid(player)) then
						self.hint:Send(player, hintTable.text, 30);
						player:SetData("Hint"..k, true);
					end;
				end);
				
				startHintsDelay = startHintsDelay + 30;
			end;
		end;
	end;
	
	if (startHintsDelay > 4) then
		player.cwViewStartHints = true;
		
		timer.Simple(startHintsDelay, function()
			if (IsValid(player)) then
				player.cwViewStartHints = false;
			end;
		end);
	end;
	
	Clockwork.inventory:SendUpdateAll(player)
end;

-- Called when a player has used their death code.
function Clockwork:PlayerDeathCodeUsed(player, commandTable, arguments) end;

-- Called when a player has created a character.
function Clockwork:PlayerCharacterCreated(player, character) end;

-- Called when a player's character has unloaded.
function Clockwork:PlayerCharacterUnloaded(player)
	self.player:SetupRemovePropertyDelays(player);
	self.player:DisableProperty(player);
	self.player:SetRagdollState(player, RAGDOLL_RESET);
	self.storage:Close(player, true)
	
	player:SetTeam(TEAM_UNASSIGNED);
end;

-- Called when a player's character has loaded.
function Clockwork:PlayerCharacterLoaded(player)
	player:SetSharedVar("InvWeight", self.config:Get("default_inv_weight"):Get());
	
	player.cwCharLoadedTime = CurTime();
	player.cwCrouchedSpeed = self.config:Get("crouched_speed"):Get();
	player.cwClipTwoInfo = {weapon = NULL, ammo = 0};
	player.cwClipOneInfo = {weapon = NULL, ammo = 0};
	player.cwInitialized = true;
	player.cwAttrBoosts = {};
	player.cwRagdollTab = {};
	player.cwSpawnWeps = {};
	player.cwFirstSpawn = true;
	player.cwLightSpawn = false;
	player.cwChangeClass = false;
	player.cwSpawnAmmo = {};
	player.cwJumpPower = self.config:Get("jump_power"):Get();
	player.cwWalkSpeed = self.config:Get("walk_speed"):Get();
	player.cwRunSpeed = self.config:Get("run_speed"):Get();
	
	hook.Call("PlayerRestoreCharacterData", Clockwork, player, player:QueryCharacter("Data"));
	hook.Call("PlayerRestoreTempData", Clockwork, player, player:CreateTempData());
	
	self.player:SetCharacterMenuState(player, CHARACTER_MENU_CLOSE);
	self.plugin:Call("PlayerCharacterInitialized", player);
	
	self.player:RestoreRecognisedNames(player);
	self.player:ReturnProperty(player);
	self.player:SetInitialized(player, true);
	
	player.cwFirstSpawn = false;
	
	local charactersTable = self.config:Get("mysql_characters_table"):Get();
	local schemaFolder = self:GetSchemaFolder();
	local characterID = player:GetCharacterID();
	local onNextLoad = player:QueryCharacter("OnNextLoad");
	local steamID = player:SteamID();
	local query = "UPDATE "..charactersTable.." SET _OnNextLoad = \"\" WHERE";
	
	if (onNextLoad != "") then
		tmysql.query(query.." _Schema = \""..schemaFolder.."\" AND _SteamID = \""..steamID.."\" AND _CharacterID = "..characterID);
		player:SetCharacterData("OnNextLoad", "", true);
		
		CHARACTER = player:GetCharacter();
			PLAYER = player;
				RunString(onNextLoad);
			PLAYER = nil;
		CHARACTER = nil;
	end;
	
	player:FixInventory();
end;

-- Called when a player's property should be restored.
function Clockwork:PlayerReturnProperty(player) end;

-- Called when config has initialized for a player.
function Clockwork:PlayerConfigInitialized(player)
	self.plugin:Call("PlayerSendDataStreamInfo", player);
	
	if (!player:IsBot()) then
		timer.Simple(FrameTime() * 32, function()
			if (IsValid(player)) then
				umsg.Start("cwDataStreaming", player);
				umsg.End();
			end;
		end);
	else
		self.plugin:Call("PlayerDataStreamInfoSent", player);
	end;
end;

-- Called when a player has used their radio.
function Clockwork:PlayerRadioUsed(player, text, listeners, eavesdroppers) end;

-- Called when a player's drop weapon info should be adjusted.
function Clockwork:PlayerAdjustDropWeaponInfo(player, info)
	return true;
end;

-- Called when a player's character creation info should be adjusted.
function Clockwork:PlayerAdjustCharacterCreationInfo(player, info, data) end;

-- Called when a player's earn generator info should be adjusted.
function Clockwork:PlayerAdjustEarnGeneratorInfo(player, info) end;

-- Called when a player's order item should be adjusted.
function Clockwork:PlayerAdjustOrderItemTable(player, itemTable) end;

-- Called when a player's next punch info should be adjusted.
function Clockwork:PlayerAdjustNextPunchInfo(player, info) end;

-- Called when a player uses an unknown item function.
function Clockwork:PlayerUseUnknownItemFunction(player, itemTable, itemFunction) end;

-- Called when a player's character table should be adjusted.
function Clockwork:PlayerAdjustCharacterTable(player, character)
	if (self.faction.stored[character.faction]) then
		if (self.faction.stored[character.faction].whitelist
		and !self.player:IsWhitelisted(player, character.faction)) then
			character.data["CharBanned"] = true;
		end;
	else
		return true;
	end;
end;

-- Called when a player's character screen info should be adjusted.
function Clockwork:PlayerAdjustCharacterScreenInfo(player, character, info) end;

-- Called when a player's prop cost info should be adjusted.
function Clockwork:PlayerAdjustPropCostInfo(player, entity, info) end;

-- Called when a player's death info should be adjusted.
function Clockwork:PlayerAdjustDeathInfo(player, info) end;

-- Called when chat box info should be adjusted.
function Clockwork:ChatBoxAdjustInfo(info) end;

-- Called when a chat box message has been added.
function Clockwork:ChatBoxMessageAdded(info) end;

-- Called when a player's radio text should be adjusted.
function Clockwork:PlayerAdjustRadioInfo(player, info) end;

-- Called when a player should gain a frag.
function Clockwork:PlayerCanGainFrag(player, victim) return true; end;

-- Called when a player's model should be set.
function Clockwork:PlayerSetModel(player)
	self.player:SetDefaultModel(player);
	self.player:SetDefaultSkin(player);
end;

-- Called just after a player spawns.
function Clockwork:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (firstSpawn) then
		local attrBoosts = player:GetCharacterData("AttrBoosts");
		local health = player:GetCharacterData("Health");
		local armor = player:GetCharacterData("Armor");
		
		if (health and health > 1) then
			player:SetHealth(health);
		end;
		
		if (armor and armor > 1) then
			player:SetArmor(armor);
		end;
		
		if (attrBoosts) then
			for k, v in pairs(attrBoosts) do
				for k2, v2 in pairs(v) do
					self.attributes:Boost(player, k2, k, v2.amount, v2.duration);
				end;
			end;
		end;
	else
		player:SetCharacterData("AttrBoosts", nil);
		player:SetCharacterData("Health", nil);
		player:SetCharacterData("Armor", nil);
	end;
end;

-- Called when a player should take damage.
function Clockwork:PlayerShouldTakeDamage(player, attacker, inflictor, damageInfo)
	if (self.player:IsNoClipping(player)) then
		return false;
	end;
	
	return true;
end;

-- Called when a player is attacked by a trace.
function Clockwork:PlayerTraceAttack(player, damageInfo, direction, trace)
	player.cwLastHitGroup = trace.HitGroup;
	return false;
end;

-- Called just before a player dies.
function Clockwork:DoPlayerDeath(player, attacker, damageInfo)
	self.player:DropWeapons(player, attacker);
	self.player:SetAction(player, false);
	self.player:SetDrunk(player, false);
	
	local deathSound = self.plugin:Call("PlayerPlayDeathSound", player, player:GetGender());
	local decayTime = self.config:Get("body_decay_time"):Get();

	if (decayTime > 0) then
		self.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, nil, decayTime, self:ConvertForce(damageInfo:GetDamageForce() * 32));
	else
		self.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, nil, 600, self:ConvertForce(damageInfo:GetDamageForce() * 32));
	end;
	
	if (self.plugin:Call("PlayerCanDeathClearRecognisedNames", player, attacker, damageInfo)) then
		self.player:ClearRecognisedNames(player);
	end;
	
	if (self.plugin:Call("PlayerCanDeathClearName", player, attacker, damageInfo)) then
		self.player:ClearName(player);
	end;
	
	if (deathSound) then
		player:EmitSound("physics/flesh/flesh_impact_hard"..math.random(1, 5)..".wav", 150);
		
		timer.Simple(FrameTime() * 25, function()
			if (IsValid(player)) then
				player:EmitSound(deathSound);
			end;
		end);
	end;
	
	player:SetForcedAnimation(false);
	player:SetCharacterData("Ammo", {}, true);
	player:StripWeapons();
	player:Extinguish();
	player.cwSpawnAmmo = {};
	player:StripAmmo();
	player:AddDeaths(1);
	player:UnLock();
	
	if (IsValid(attacker) and attacker:IsPlayer() and player != attacker) then
		if (self.plugin:Call("PlayerCanGainFrag", attacker, player)) then
			attacker:AddFrags(1);
		end;
	end;
end;

-- Called when a player dies.
function Clockwork:PlayerDeath(player, inflictor, attacker, damageInfo)
	self:CalculateSpawnTime(player, inflictor, attacker, damageInfo);
	
	if (player:GetRagdollEntity()) then
		local ragdoll = player:GetRagdollEntity();
		
		if (inflictor:GetClass() == "prop_combine_ball") then
			if (damageInfo) then
				self.entity:Disintegrate(player:GetRagdollEntity(), 3, damageInfo:GetDamageForce() * 32);
			else
				self.entity:Disintegrate(player:GetRagdollEntity(), 3);
			end;
		end;
	end;
	
	if (attacker:IsPlayer()) then
		if (IsValid(attacker:GetActiveWeapon())) then
			self:PrintLog(LOGTYPE_CRITICAL, attacker:Name().." has killed "..player:Name().." with "..self.player:GetWeaponClass(attacker)..".");
		else
			self:PrintLog(LOGTYPE_CRITICAL, attacker:Name().." has killed "..player:Name()..".");
		end;
	else
		self:PrintLog(LOGTYPE_URGENT, attacker:GetClass().." has killed "..player:Name()..".");
	end;
end;

-- Called when an item entity has taken damage.
function Clockwork:ItemEntityTakeDamage(itemEntity, itemTable, damageInfo)
	return true;
end;

-- Called when an item entity has been destroyed.
function Clockwork:ItemEntityDestroyed(itemEntity, itemTable) end;

-- Called when an item's network observers are needed.
function Clockwork:ItemGetNetworkObservers(itemTable, info)
	local uniqueID = itemTable("uniqueID");
	local itemID = itemTable("itemID");
	local entity = Clockwork.item:FindEntityByInstance(itemTable);
	
	if (entity) then
		info.sendToAll = true;
		return false;
	end;
	
	for k, v in ipairs(player.GetAll()) do
		if (v:HasInitialized()) then
			local inventory = self.storage:Query(v, "inventory");
			
			if ((inventory and inventory[uniqueID]
			and inventory[uniqueID][itemID]) or v:HasItemInstance(itemTable)) then
				info.observers[v] = v;
			elseif (v:HasItemAsWeapon(itemTable)) then
				info.observers[v] = v;
			end;
		end;
	end;
end;

-- Called when a player's weapons should be given.
function Clockwork:PlayerLoadout(player)
	local weapons = self.class:Query(player:Team(), "weapons");
	local ammo = self.class:Query(player:Team(), "ammo");
	
	player.cwSpawnWeps = {};
	player.cwSpawnAmmo = {};
	
	if (self.player:HasFlags(player, "t")) then
		self.player:GiveSpawnWeapon(player, "gmod_tool");
	end
	
	if (self.player:HasFlags(player, "p")) then
		self.player:GiveSpawnWeapon(player, "weapon_physgun");
	end
	
	self.player:GiveSpawnWeapon(player, "weapon_physcannon");
	
	if (self.config:Get("give_hands"):Get()) then
		self.player:GiveSpawnWeapon(player, "cw_hands");
	end;
	
	if (self.config:Get("give_keys"):Get()) then
		self.player:GiveSpawnWeapon(player, "cw_keys");
	end;
	
	if (weapons) then
		for k, v in ipairs(weapons) do
			local itemTable = Clockwork.item:CreateInstance(v);
			if (!self.player:GiveSpawnItemWeapon(player, itemTable)) then
				player:Give(v);
			end;
		end;
	end;
	
	if (ammo) then
		for k, v in pairs(ammo) do
			self.player:GiveSpawnAmmo(player, k, v);
		end;
	end;
	
	self.plugin:Call("PlayerGiveWeapons", player);
	
	if (self.config:Get("give_hands"):Get()) then
		player:SelectWeapon("cw_hands");
	end;
end

-- Called when the server shuts down.
function Clockwork:ShutDown()
	self.ShuttingDown = true;
end;

-- Called when a player presses F1.
function Clockwork:ShowHelp(player)
	umsg.Start("cwInfoToggle", player);
	umsg.End();
end;

-- Called when a player presses F2.
function Clockwork:ShowTeam(player)
	if (!self.player:IsNoClipping(player)) then
		local doRecogniseMenu = true;
		local entity = player:GetEyeTraceNoCursor().Entity;
		
		if (IsValid(entity) and self.entity:IsDoor(entity)) then
			if (entity:GetPos():Distance(player:GetShootPos()) <= 192) then
				if (self.plugin:Call("PlayerCanViewDoor", player, entity)) then
					if (self.plugin:Call("PlayerUse", player, entity)) then
						local owner = self.entity:GetOwner(entity);
						
						if (IsValid(owner)) then
							if (self.player:HasDoorAccess(player, entity, DOOR_ACCESS_COMPLETE)) then
								local data = {
									sharedAccess = self.entity:DoorHasSharedAccess(entity),
									sharedText = self.entity:DoorHasSharedText(entity),
									unsellable = self.entity:IsDoorUnsellable(entity),
									accessList = {},
									isParent = self.entity:IsDoorParent(entity),
									entity = entity,
									owner = owner
								};
								
								for k, v in ipairs(_player.GetAll()) do
									if (v != player and v != owner) then
										if (self.player:HasDoorAccess(v, entity, DOOR_ACCESS_COMPLETE)) then
											data.accessList[v] = DOOR_ACCESS_COMPLETE;
										elseif (self.player:HasDoorAccess(v, entity, DOOR_ACCESS_BASIC)) then
											data.accessList[v] = DOOR_ACCESS_BASIC;
										end;
									end;
								end;
								
								self:StartDataStream(player, "DoorManagement", data);
							end;
						else
							self:StartDataStream(player, "PurchaseDoor", entity);
						end;
					end;
				end;
				
				doRecogniseMenu = false;
			end;
		end;
		
		if (self.config:Get("recognise_system"):Get()) then
			if (doRecogniseMenu) then
				umsg.Start("cwRecogniseMenu", player);
				umsg.End();
			end;
		end;
	end;
end;

-- Called when a player selects a custom character option.
function Clockwork:PlayerSelectCustomCharacterOption(player, action, character) end;

-- Called when a player takes damage.
function Clockwork:PlayerTakeDamage(player, inflictor, attacker, hitGroup, damageInfo)
	if (hitGroup and !damageInfo:IsFallDamage()) then
		self.limb:TakeDamage(player, hitGroup, damageInfo:GetDamage());
		
		if (damageInfo:IsBulletDamage() and self.event:CanRun("limb_damage", "stumble")) then
			if (hitGroup == HITGROUP_LEFTLEG or hitGroup == HITGROUP_RIGHTLEG) then
				local rightLeg = self.limb:GetDamage(player, HITGROUP_RIGHTLEG);
				local leftLeg = self.limb:GetDamage(player, HITGROUP_LEFTLEG);
				
				if (rightLeg > 50 and leftLeg > 50 and !player:IsRagdolled()) then
					self.player:SetRagdollState(player, RAGDOLL_FALLENOVER, 8, nil, self:ConvertForce(damageInfo:GetDamageForce() * 32));
					damageInfo:ScaleDamage(0.25);
				end;
			end;
		end;
	else
		self.limb:TakeDamage(player, HITGROUP_RIGHTLEG, damageInfo:GetDamage());
		self.limb:TakeDamage(player, HITGROUP_LEFTLEG, damageInfo:GetDamage());
	end;
end;

-- Called when an entity takes damage.
function Clockwork:EntityTakeDamage(entity, inflictor, attacker, amount, damageInfo)
	if (self.config:Get("prop_kill_protection"):Get()) then
		local curTime = CurTime();
		
		if ((IsValid(inflictor) and inflictor.cwDamageImmunity and inflictor.cwDamageImmunity > curTime)
		or (attacker.cwDamageImmunity and attacker.cwDamageImmunity > curTime)) then
			damageInfo:SetDamage(0);
		end;
		
		if ((IsValid(inflictor) and inflictor:IsBeingHeld())
		or attacker:IsBeingHeld()) then
			damageInfo:SetDamage(0);
		end;
	end;
	
	if (entity:IsPlayer() and entity:InVehicle() and !IsValid(entity:GetVehicle():GetParent())) then
		entity.cwLastHitGroup = self:GetRagdollHitBone(entity, damageInfo:GetDamagePosition(), HITGROUP_GEAR);
		
		if (damageInfo:IsBulletDamage()) then
			if ((attacker:IsPlayer() or attacker:IsNPC()) and attacker != player) then
				damageInfo:ScaleDamage(10000);
			end;
		end;
	end;
	
	if (damageInfo:GetDamage() > 0) then
		local isPlayerRagdoll = self.entity:IsPlayerRagdoll(entity);
		local player = self.entity:GetPlayer(entity);
		
		if (player and (entity:IsPlayer() or isPlayerRagdoll)) then
			if (damageInfo:IsFallDamage() or self.config:Get("damage_view_punch"):Get()) then
				player:ViewPunch(
					Angle(math.random(amount, amount), math.random(amount, amount), math.random(amount, amount))
				);
			end;
			
			if (!isPlayerRagdoll) then
				if (damageInfo:IsDamageType(DMG_CRUSH) and damageInfo:GetDamage() < 10) then
					damageInfo:SetDamage(0);
				else
					local lastHitGroup = player:LastHitGroup();
					local killed = nil;
					
					if (player:InVehicle() and damageInfo:IsExplosionDamage()) then
						if (!damageInfo:GetDamage() or damageInfo:GetDamage() == 0) then
							damageInfo:SetDamage(player:GetMaxHealth());
						end;
					end;
					
					self:ScaleDamageByHitGroup(player, attacker, lastHitGroup, damageInfo, amount);
					
					if (damageInfo:GetDamage() > 0) then
						self:CalculatePlayerDamage(player, lastHitGroup, damageInfo);
						
						player:SetVelocity(self:ConvertForce(damageInfo:GetDamageForce() * 32, 200));
						
						if (player:Alive() and player:Health() == 1) then
							player:SetFakingDeath(true);
								hook.Call("DoPlayerDeath", self, player, attacker, damageInfo);
								hook.Call("PlayerDeath", self, player, inflictor, attacker, damageInfo);
								self:CreateBloodEffects(damageInfo:GetDamagePosition(), 1, player, damageInfo:GetDamageForce());
							player:SetFakingDeath(false, true);
						else
							local bNoMsg = self.plugin:Call("PlayerTakeDamage", player, inflictor, attacker, lastHitGroup, damageInfo);
							local sound = self.plugin:Call("PlayerPlayPainSound", player, player:GetGender(), damageInfo, lastHitGroup);
							
							self:CreateBloodEffects(damageInfo:GetDamagePosition(), 1, player, damageInfo:GetDamageForce());
							
							if (sound and !bNoMsg) then
								player:EmitSound("physics/flesh/flesh_impact_bullet"..math.random(1, 5)..".wav", 150);
								
								timer.Simple(FrameTime() * 25, function()
									if (IsValid(player)) then
										player:EmitSound(sound);
									end;
								end);
							end;
							
							if (attacker:IsPlayer()) then
								self:PrintLog(LOGTYPE_MAJOR, player:Name().." has taken damage from "..attacker:Name().." with "..self.player:GetWeaponClass(attacker, "an unknown weapon")..".");
							else
								self:PrintLog(LOGTYPE_MAJOR, player:Name().." has taken damage from "..attacker:GetClass()..".");
							end;
						end;
					end;
					
					damageInfo:SetDamage(0);
					player.cwLastHitGroup = nil;
				end;
			else
				local hitGroup = self:GetRagdollHitGroup(entity, damageInfo:GetDamagePosition());
				local curTime = CurTime();
				local killed = nil;
				
				self:ScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, amount);
				
				if (self.plugin:Call("PlayerRagdollCanTakeDamage", player, entity, inflictor, attacker, hitGroup, damageInfo)
				and damageInfo:GetDamage() > 0) then
					if (!attacker:IsPlayer()) then
						if (attacker:GetClass() == "prop_ragdoll" or self.entity:IsDoor(attacker)
						or damageInfo:GetDamage() < 5) then
							return;
						end;
					end;
					
					if (damageInfo:GetDamage() >= 10 or damageInfo:IsBulletDamage()) then
						self:CreateBloodEffects(damageInfo:GetDamagePosition(), 1, entity, damageInfo:GetDamageForce());
					end;
					
					self:CalculatePlayerDamage(player, hitGroup, damageInfo);
					
					if (player:Alive() and player:Health() == 1) then
						player:SetFakingDeath(true);
							player:GetRagdollTable().health = 0;
							player:GetRagdollTable().armor = 0;
							
							hook.Call("DoPlayerDeath", self, player, attacker, damageInfo);
							hook.Call("PlayerDeath", self, player, inflictor, attacker, damageInfo);
						player:SetFakingDeath(false, true);
					elseif (player:Alive()) then
						local bNoMsg = self.plugin:Call("PlayerTakeDamage", player, inflictor, attacker, hitGroup, damageInfo);
						local sound = self.plugin:Call("PlayerPlayPainSound", player, player:GetGender(), damageInfo, hitGroup);
						
						if (sound and !bNoMsg) then
							entity:EmitSound("physics/flesh/flesh_impact_bullet"..math.random(1, 5)..".wav", 320, 150);
							
							timer.Simple(FrameTime() * 25, function()
								if (IsValid(entity)) then
									entity:EmitSound(sound);
								end;
							end);
						end;
						
						if (attacker:IsPlayer()) then
							self:PrintLog(LOGTYPE_MAJOR, player:Name().." has taken damage from "..attacker:Name().." with "..self.player:GetWeaponClass(attacker, "an unknown weapon")..".");
						else
							self:PrintLog(LOGTYPE_MAJOR, player:Name().." has taken damage from "..attacker:GetClass()..".");
						end;
					end;
				end;
				
				damageInfo:SetDamage(0);
			end;
		elseif (entity:GetClass() == "prop_ragdoll") then
			if (damageInfo:GetDamage() >= 20 or damageInfo:IsBulletDamage()) then
				if (!string.find(entity:GetModel(), "matt") and !string.find(entity:GetModel(), "gib")) then
					local matType = util.QuickTrace(entity:GetPos(), entity:GetPos()).MatType;
					
					if (matType == MAT_FLESH or matType == MAT_BLOODYFLESH) then
						self:CreateBloodEffects(damageInfo:GetDamagePosition(), 1, entity, damageInfo:GetDamageForce());
					end;
				end;
			end;
			
			if (inflictor:GetClass() == "prop_combine_ball") then
				if (!entity.disintegrating) then
					self.entity:Disintegrate(entity, 3, damageInfo:GetDamageForce());
					
					entity.disintegrating = true;
				end;
			end;
		elseif (entity:IsNPC()) then
			if (attacker:IsPlayer() and IsValid(attacker:GetActiveWeapon())
			and self.player:GetWeaponClass(attacker) == "weapon_crowbar") then
				damageInfo:ScaleDamage(0.25);
			end;
		end;
	end;
end;

-- Called when the death sound for a player should be played.
function Clockwork:PlayerDeathSound(player) return true; end;

-- Called when a player attempts to spawn a SWEP.
function Clockwork:PlayerSpawnSWEP(player, class, weapon)
	if (!player:IsSuperAdmin()) then
		return false;
	else
		return true;
	end;
end;

-- Called when a player is given a SWEP.
function Clockwork:PlayerGiveSWEP(player, class, weapon)
	if (!player:IsSuperAdmin()) then
		return false;
	else
		return true;
	end;
end;

-- Called when attempts to spawn a SENT.
function Clockwork:PlayerSpawnSENT(player, class)
	if (!player:IsSuperAdmin()) then
		return false;
	else
		return true;
	end;
end;

-- Called when a player presses a key.
function Clockwork:KeyPress(player, key)
	if (key == IN_USE) then
		local trace = player:GetEyeTraceNoCursor();
		
		if (IsValid(trace.Entity)) then
			if (trace.HitPos:Distance(player:GetShootPos()) <= 192) then
				if (self.plugin:Call("PlayerUse", player, trace.Entity)) then
					if (self.entity:IsDoor(trace.Entity) and !trace.Entity:HasSpawnFlags(256)
					and !trace.Entity:HasSpawnFlags(8192) and !trace.Entity:HasSpawnFlags(32768)) then
						if (self.plugin:Call("PlayerCanUseDoor", player, trace.Entity)) then
							self.plugin:Call("PlayerUseDoor", player, trace.Entity);
							
							self.entity:OpenDoor(trace.Entity, 0, nil, nil, player:GetPos());
						end;
					elseif (trace.Entity.UsableInVehicle) then
						if (player:InVehicle()) then
							if (trace.Entity.Use) then
								trace.Entity:Use(player, player);
								
								player.cwNextExitVehicle = CurTime() + 1;
							end;
						end;
					end;
				end;
			end;
		end;
	elseif (key == IN_WALK) then
		local velocity = player:GetVelocity():Length();
		
		if (velocity > 0 and !player:KeyDown(IN_SPEED)) then
			if (player:GetSharedVar("IsRunMode")) then
				player:SetSharedVar("IsRunMode", false);
			else
				player:SetSharedVar("IsRunMode", true);
			end;
		elseif (velocity == 0 and player:KeyDown(IN_SPEED)) then
			if (player:Crouching()) then
				player:RunCommand("-duck");
			else
				player:RunCommand("+duck");
			end;
		end;
	elseif (key == IN_RELOAD) then
		if (self.player:GetWeaponRaised(player, true)) then
			player.cwReloadHoldTime = CurTime() + 0.75;
		else
			player.cwReloadHoldTime = CurTime() + 0.25;
		end;
	end;
end;

-- Called when a player releases a key.
function Clockwork:KeyRelease(player, key)
	if (key == IN_RELOAD and player.cwReloadHoldTime) then
		player.cwReloadHoldTime = nil;
	end;
end;

--[[
	Please do not alter the game description. Doing so may result
	in your server being less known to users. The Clockwork tag
	and schema name are there to let users know what you're running.
--]]

-- A function to get the game description.
function Clockwork:GetGameDescription()
	return "[CW-"..Clockwork.KernelVersion.."] "..Clockwork.schema:GetName();
end;

-- A function to setup a player's visibility.
function Clockwork:SetupPlayerVisibility(player)
	local ragdollEntity = player:GetRagdollEntity();
	local curTime = CurTime();
	
	if (ragdollEntity) then
		AddOriginToPVS(ragdollEntity:GetPos());
	end;
	
	if (player:HasInitialized()) then
		if (!player.cwNextThink) then
			player.cwNextThink = curTime + 0.5;
		end;
		
		if (!player.cwNextSetSharedVars) then
			player.cwNextSetSharedVars = curTime + 2;
		end;
		
		if (curTime >= player.cwNextThink) then
			self.player:CallThinkHook(
				player, (curTime >= player.cwNextSetSharedVars), {}, curTime
			);
		end;
	end;
end;
 
--[[
	Load some encrypted code through the CloudAuth system. This code is 100% safe
	it is just to ensure that the CloudAuth system is used.
--]]

--[[ GetTargetRecognises datastream callback. --]]
--CloudAuth.LoadCode("M0ZpcmBudHJvbjdLbHJoR153XlZxdWJkaisfSmJ3UWRvamJ3T2hgcmRxZnZidh8vHWlycWB3ZnJrK21vXnxidSkjYWRxZCYjZmkdKx1ZXm9mZ0JxcWxxfCVnXndeLB1ka2cdZ153Xj1Gdk1vXnxidSUsHSwdd2VoayNtb158YnU3VmJ3UGtedWJnU2RvKx0lUWRvamJ3SHFsenAlKSNAb2xmaHpsdWgxbW9efGJ1N0dsaHBVYmZsamtscGglZ153Xi8dc2lkdmhvLB0sOCNicWE+HWhrZyY+");

Clockwork:HookDataStream("GetTargetRecognises", function(player, data)
	if ( ValidEntity(data) and data:IsPlayer() ) then
		player:SetSharedVar("TargetKnows", Clockwork.player:DoesRecognise(data, player));
	end;
end);


--[[ EntityMenuOption datastream callback. --]]
--CloudAuth.LoadCode("MURrcGJsdnBxbDlJbnBqRWB1YFRzc2RibCkhRm11aHV4TmRvdFBvdWhwbSMrIWV2bWRzam5vJ3FrYnhmcS0fZWB1YCofbW5kYG0fZm11aHV4ITwhY2JzYloyXDwfbW5kYG0fcG91aHBtITwhY2JzYlozXDwfbW5kYG0fdGdwbnVPcHIhPCFvbWB6ZHM5SGR1UmlucHNRbnQnKjoha3BiYmshYHNmdmxmbXVyITwhY2JzYlo0XDwfamUhJ0pyV2BtaGUnZm11aHV4Kh9ibWUfdXhxZClucXNqbm8oITw+HyNydXFqbWghKh91Z2ZtIWhnHylkb3Nqc3o5T2RicWZydU9waG9zKXJpbnBzUW50KDtDanJ1YG9iZid0Z3BudU9wciofPTwhNzEoIXNpZG8famUhJyFCbW5kanhuc2ovb210aGhvOURgbWspIVFrYnhmcVZyZiEtH3FrYnhmcS0fZm11aHV4Kh8qH3VnZm0hQm1uZGp4bnNqL29tdGhobzlEYG1rKSFGbXVodXhJYG9jbWROZG90UG91aHBtIyshb21gemRzKyFkb3Nqc3orIW5xc2pubyshYHNmdmxmbXVyKjohZG9jPB9mbWU6IWRvYzwfZm1lKDw=");

Clockwork:HookDataStream("EntityMenuOption", function(player, data)
	local entity = data[1];
	local option = data[2];
	local shootPos = player:GetShootPos();
	local arguments = data[3];
	
	if (IsValid(entity) and type(option) == "string") then
		if (entity:NearestPoint(shootPos):Distance(shootPos) <= 80) then
			if ( Clockwork.plugin:Call("PlayerUse", player, entity) ) then
				Clockwork.plugin:Call("EntityHandleMenuOption", player, entity, option, arguments);
			end;
		end;
	end;
end);

--[[ DataStreamInfoSent datastream callback. --]]
--CloudAuth.LoadCode("MkVqcWFtdXFwbThKbXFpRl92X1VydGNjayogRl92X1VydGNja0tsaG1VY3ByJCoiZHdsZXJrbXAmcmpjd2dwLh5mX3ZfKx5rZCImI25uX3tjdCxldUZfdl9VcnRjY2tLbGhtVWNwcisedmZnbCJBbm1laXltdGkwbm5zaWdwOEVfbmoqIFJqY3dncEZfdl9VcnRjY2tLbGhtVWNwciQqIm5uX3tjdCc9HnZnb2N0LFVnb25uYypEdF9vY1Znb2MqJyIoIjE0KiJkd2xlcmttcCYrHmtkIiYiR3VUY2prYipubl97Y3QnIicicmpjcB53a3VlMFF2X3RyKiBldUZfdl9VcnRjY2tnYiQqIm5uX3tjdCc9HndrdWUwQ3BiKic9HmdsZjkiY3BiKzkibm5fe2N0LGV1Rl92X1VydGNja0tsaG1VY3ByIjsicnRzZzkiY3BiPR5nbGYnPR4=");

Clockwork:HookDataStream("DataStreamInfoSent", function(player, data)
	if (!player.dataStreamInfoSent) then
		Clockwork.plugin:Call("PlayerDataStreamInfoSent", player);
		
		timer.Simple(FrameTime() * 32, function()
			if ( IsValid(player) ) then
				umsg.Start("cwDataStreamed", player);
				umsg.End();
			end;
		end);
		
		player.dataStreamInfoSent = true;
	end;
end);

--[[ LocalPlayerCreated datastream callback. --]]
--CloudAuth.LoadCode("M0ZpcmBudHJvbjdLbHJoR153XlZxdWJkaisfT2xmXm9Nb158YnVAdWJkcWhhJSkjY3hrZnFsbHElc2lkdmhvLx1nXndeLB1sYyMlI0Z2U2RpbGErbW9efGJ1JiNecWEjHnNpZHZobz1FZHBGbHFjbGRMa2xxbF5vZn1iZyUsHSwdd2VoayNAb2xmaHpsdWg9QHViZHFoUWxqaG8rH1ZicWFGY2ofMStzaWR2aG89UnFmdHJoRkclLCkjQ3VecGJXZnBiKyYjJyMzNykjLi8daXJxYHdmcmsrJiNmaR0rHUxwWV5vZmclc2lkdmhvLB0sHXdlaGsjQG9sZmh6bHVoMWBya2lmajdWYnFhK21vXnxidSY+HWhrZzgjYnFhLDgjYnFhPh1oa2cmPg==");

Clockwork:HookDataStream("LocalPlayerCreated", function(player, data)
	if ( IsValid(player) and !player:HasConfigInitialized() ) then
		Clockwork:CreateTimer("send_cfg_"..player:UniqueID(), FrameTime() * 64, 1, function()
			if ( IsValid(player) ) then
				Clockwork.config:Send(player);
			end;
		end);
	end;
end);

--[[ InteractCharacter datastream callback. --]]
--CloudAuth.LoadCode("M0ZpcmBudHJvbjdLbHJoR153XlZxdWJkaisfTGt3YnVeZnFGZWRvZGB3YnUfLx1pcnFgd2Zyayttb158YnUpI2FkcWQmI2lyYGRpI2BrXnVeZnFob0xBIzojYWRxZCtmZWRvZGB3YnVGRzgjaXJgZGkjXmZxbGxxHUAdZ153XjFeZnFsbHE4I2ZpHStga151XmZxaG9MQSNecWEjXmZxbGxxJiNxa2JxHW9sZl5vHWZlZG9kYHdidR1AHXNpZHZobz1EaHFGZWRvZGB3YnVwKyZeYGtedV5mcWhvTEFgOCNmaR0rYGtedV5mcWhvLB13ZWhrI2lyYGRpI2Nkcm9xIzojQG9sZmh6bHVoMW1vcmpmcTdGXm9pKx9TaWR2aG9GXnFGcXFob2Rgd0BrXnVeZnFobyUpI21vXnxidSkjXmZxbGxxKSNga151XmZxaG8sOCNmaR0rY2Ryb3EjOkAdaV5vcGgdcm8jcXxtaCVpXnhpdyYjOkAdJXB3b2xrah8sHXdlaGsjb2hxeG9xHUZpcmBudHJvbitzaWR2aG89UGhxRm9oXndiSV54aXclaV54aXcdcm8jH1xseB1mXnFrcnEjZnFxaG9kYHcdemZ3ZSNxa2Z2HWZlZG9kYHdidR4lJj4daGl2YmxjIyVkYHdmcmsjOkAdJWFoaWhxaB8sHXdlaGsjaXJgZGkjcHhgZmJ2cC8daV54aXcdQB1GaXJgbnRyb24rc2lkdmhvPUFoaWhxaEBrXnVeZnFobyttb158YnUpI2BrXnVeZnFob0xBLDgjZmkdKx52cmZgaHB2JiNxa2JxHUZpcmBudHJvbitzaWR2aG89UGhxRm9oXndiSV54aXclc2lkdmhvLx1pXnhpdyY+HWhrZzgjYm9waGZpHSteZnFsbHEdQDojH3hwaB8sHXdlaGsjaXJgZGkjcHhgZmJ2cC8daV54aXcdQB1GaXJgbnRyb24rc2lkdmhvPVJ2YkZlZG9kYHdidSVzaWR2aG8vHWZlZG9kYHdidUZHJj4dbGMjJSRweGBmYnZwLB13ZWhrI0BvbGZoemx1aDFtb158YnU3VmJ3QHViZHFoQ2Ryb3ErbW9efGJ1KSNjZHJvcSw4I2JxYT4daGl2YiNAb2xmaHpsdWgxbW9yamZxN0Zeb2krH1NpZHZob1Zib2JmcUZydnFyakZlZG9kYHdidUxzcWxscR8vHXNpZHZoby8dZGB3ZnJrLx1mZWRvZGB3YnUmPh1oa2c4I2JxYT4daGtnOCNicWEsOA==");

Clockwork:HookDataStream("InteractCharacter", function(player, data)
	local characterID = data.characterID;
	local action = data.action;
	
	if (characterID and action) then
		local character = player:GetCharacters()[characterID];
		
		if (character) then
			local fault = Clockwork.plugin:Call("PlayerCanInteractCharacter", player, action, character);
			
			if (fault == false or type(fault) == "string") then
				return Clockwork.player:SetCreateFault(fault or "You cannot interact with this character!");
			elseif (action == "delete") then
				local success, fault = Clockwork.player:DeleteCharacter(player, characterID);
				
				if (!success) then
					Clockwork.player:SetCreateFault(player, fault);
				end;
			elseif (action == "use") then
				local success, fault = Clockwork.player:UseCharacter(player, characterID);
				
				if (!success) then
					Clockwork.player:SetCreateFault(player, fault);
				end;
			else
				Clockwork.plugin:Call("PlayerSelectCustomCharacterOption", player, action, character);
			end;
		end;
	end;
end);


--[[ GetQuizStatus datastream callback. --]]
--CloudAuth.LoadCode("MkVqcWFtdXFwbThKbXFpRl92X1VydGNjayogSWN2T3dnfFF2X3ZzdSAuHmhzcGF2Z3FsKm5uX3tjdCoiYmNyYyciZ2geKh4jQW5tZWl5bXRpMG93Z3w4SWN2Q3BfZGpnYionIm10HkVqcWFtdXFwbSxzc2t4PEVnckVtb25uY3ZjZiZyamN3Z3ArHisedmZnbCJzb3FpLFVyY3B2JiRheU93Z3xBcWtyamdyZ2IkKiJubl97Y3QnPR53a3VlMEBxbW4mdnB3Yys5InNvcWksR2xmJis5ImNucWced2t1ZTBRdl90ciogZXVTc2t4RW1vbm5jdmNmIC4ecmpjd2dwKzkic29xaSxEbXFqKmRjanVjKzkic29xaSxHbGYmKzkiY3BiPR5nbGYnPQ==");

Clockwork:HookDataStream("GetQuizStatus", function(player, data)
	if ( !Clockwork.quiz:GetEnabled() or Clockwork.quiz:GetCompleted(player) ) then
		umsg.Start("cwQuizCompleted", player);
			umsg.Bool(true);
		umsg.End();
	else
		umsg.Start("cwQuizCompleted", player);
			umsg.Bool(false);
		umsg.End();
	end;
end);

--[[ DoorManagement datastream callback. --]]
--CloudAuth.LoadCode("M0ZpcmBudHJvbjdLbHJoR153XlZxdWJkaisfR2xyb1BecV5qYnBicXElKSNjeGtmcWxscSVzaWR2aG8vHWded14sHWxjIyUjRnZTZGlsYSsdZ153Xl4uYB0sHWRrZx1zaWR2aG89RGhxSHZoUXVeZmJRbEZydXBybysmMUJxcWxxfB1AOiNhZHFkWDRaIyYjcWticR1sYyMlZ153Xl4uYDdKYndNcnArJj1BbHB3XnFgaCUjbW9efGJ1N0pid01ycCsmIyYjOUAdNDY1JiNxa2JxHWxjIyVnXndeXi9gHUA6Ix9TcnVga152YiUmI3FrYnEdbGMjJSMeRmlyYG50cm9uK2hrd2Z3dj1EaHFSdHFidSUjYWRxZFg0WiMmIyYjcWticR1sYyMlI2VybG4rRl5vaSsdJU1vXnxidUBka1J0cUFybHUfLx1GaXJgbnRyb24pI21vXnxidSkjYWRxZFg0WiMmIyYjcWticR1vbGZebx1nbHJvdh1AHUZpcmBudHJvbitzaWR2aG89RGhxR2xyb0ZseGt3JXNpZHZobyw4I2ZpHSsdZ2xyb3YdQDojQG9sZmh6bHVoMWBya2lmajdKYnclJWpkdWJhcmx1cCUmPURocSsmIyYjcWticR1GaXJgbnRyb24rc2lkdmhvPUtycWxjfCVzaWR2aG8vHSVWcnIjYGRrcWx3HXNydWBrXnZiI15xbHdlaG8jYXJsdR4lJj4daGl2YiNpcmBkaSNhcmx1QHJwdx1AHUZpcmBudHJvbitmbHFjbGQ9RGhxKx9nbHJvYmBycHcfLDdKYnclLDgjZmkdKx1nbHJvRmx2cSM6QB0zHXJvI0BvbGZoemx1aDFtb158YnU3Rl5xPmljcm9nJXNpZHZoby8dZ2xyb0ZsdnEsHSwdd2VoayNpcmBkaSNhcmx1S2RqaB1AHUZpcmBudHJvbitoa3dmd3Y9RGhxR2xyb1FecGIrHWded15eLmAdLDgjZmkdK2FybHVLZGpoHUA6Ix9pXm9waB8jbHUdZ2xyb1FecGIjOkAdJWVsYWdicR8jbHUdZ2xyb1FecGIjOkAdJR8sHXdlaGsjYXJsdUtkamgdQB0lQXJsdR8+HWhrZzgjZmkdK2FybHVAcnB3HUEdMyYjcWticR1GaXJgbnRyb24rc2lkdmhvPURsc2hAZHBrJXNpZHZoby8dMGFybHVAcnB3KSNhcmx1S2RqaCY+HWhrZzgjQG9sZmh6bHVoMW1vXnxidTdKZnliR2xybysdc2lkdmhvLx1nXndeXi5gHSw4I2JvcGgdb2xmXm8dZGpycnFxIzojYXJsdUBycHcdMB1zaWR2aG89RGhxRl52ZSsmPh1GaXJgbnRyb24rc2lkdmhvPUtycWxjfCVzaWR2aG8vHSVWcnIja2hiZx1ka3Jxa2J1HSUrMUNST1A+V1xGPlZFK15wbHhrdykja2xpLx13b3hiLCsxHyQfLDgjYnFhPh1oa2c4I2JxYT4daGtnOCNib3BoZmkdK2FkcWRYNVojOkAdJT5mYGhwdh8sHXdlaGsjZmkdKx1GaXJgbnRyb24rc2lkdmhvPUVkcEdscm9EYGZidnArbW9efGJ1KSNhZHFkWDRaLx1HTFJPYj5GQEhQVlxGTFBNT0JXQiwdLB13ZWhrI2ZpHSsdTHBZXm9mZyUjYWRxZFg2WiMmI15xYSNhZHFkWDZaIx5AHXNpZHZobyNecWEjYWRxZFg2WiMeQB1GaXJgbnRyb24raGt3Znd2PURocVJ0cWJ1JSNhZHFkWDRaIyYjJiNxa2JxHWxjIyVnXndeXjFgHUA6I0FSTFVcREBGQlZQYkBSSlNJSFFIJiNxa2JxHWxjIyUjQG9sZmh6bHVoMW1vXnxidTdLXnZBcmx1PmZgaHB2JWded15eMGApI2FkcWRYNFovHUdMUk9iPkZASFBWXEZMUE1PQldCLB0sHXdlaGsjQG9sZmh6bHVoMW1vXnxidTdKZnliR2xyb0RgZmJ2cCthZHFkWDZaLx1nXndeXi5gKSNBUkxVXERARkJWUGI/RFBMQCw4I2JvcGgdRmlyYG50cm9uK3NpZHZobz1EbHNoQXJsdT5mYGhwdiVnXndeXjBgKSNhZHFkWDRaLx1HTFJPYj5GQEhQVlxGTFBNT0JXQiw4I2JxYT4daGl2YmxjIyVnXndeXjFgHUA6I0FSTFVcREBGQlZQYj9EUExALB13ZWhrI2ZpHSsdRmlyYG50cm9uK3NpZHZobz1FZHBHbHJvRGBmYnZwK2FkcWRYNlovHWded15eLmApI0FSTFVcREBGQlZQYj9EUExALB0sHXdlaGsjQG9sZmh6bHVoMW1vXnxidTdXXm5iR2xyb0RgZmJ2cCsdZ153Xl4wYCkjYWRxZFg0WiMmPh1oaXZiI0BvbGZoemx1aDFtb158YnU3SmZ5Ykdscm9EYGZidnArYWRxZFg2Wi8dZ153Xl4uYCkjQVJMVVxEQEZCVlBiP0RQTEAsOCNicWE+HWhrZzgjZmkdKx1GaXJgbnRyb24rc2lkdmhvPUVkcEdscm9EYGZidnArYWRxZFg2Wi8dZ153Xl4uYCkjQVJMVVxEQEZCVlBiQFJKU0lIUUgmIyYjcWticR1GaXJgbnRyb243VnFkb3dBZHFkUHdvaF5wJSNtb158YnUpIx9HbHJvRGBmYnZwJSkjeGded15eMGApI0FSTFVcREBGQlZQYkBSSlNJSFFIeiMmPh1oaXZibGMjJSNAb2xmaHpsdWgxbW9efGJ1N0tedkFybHU+ZmBocHYlZ153Xl4wYCkjYWRxZFg0Wi8dR0xST2I+RkBIUFZcRT5WRkYmIyYjcWticR1GaXJgbnRyb243VnFkb3dBZHFkUHdvaF5wJSNtb158YnUpIx9HbHJvRGBmYnZwJSkjeGded15eMGApI0FSTFVcREBGQlZQYj9EUExAgB0sOCNib3BoHUZpcmBudHJvbjdWcWRvd0FkcWRQd29oXnAlI21vXnxidSkjH0dscm9EYGZidnAlKSN4I2FkcWRYNlojeiMmPh1oa2c4I2JxYT4daGtnOCNib3BoZmkdK2FkcWRYNVojOkAdJVJxcGtedWIlJiNxa2JxHWxjIyUjQG9sZmh6bHVoMWJxcWxxfDdMcEdscm9TXnVicXErHWded15eLmAdLB0sHXdlaGsjZmkdK2FkcWRYNlojOkAdJVFodXcfLB13ZWhrI0BvbGZoemx1aD1Qd151cUded15WcXViZGorbW9efGJ1KSMfVmJ3UGtedWJnUWh1dx8vHWleb3BoJj4dZ153Xl4uYCtmdEdscm9WZWRvaGFXdXcdQB1xZm84I2JvcGgdRmlyYG50cm9uN1ZxZG93QWRxZFB3b2hecCVzaWR2aG8vHSVQaHFWZWRvaGFEYGZidnAlKSNjZGl2Yiw4I2FkcWRYNFoxYHpBcmx1UGtedWJnPntwIzoja2xpPh1oa2c4I2JxYT4daGl2YmxjIyVnXndeXi9gHUA6Ix9WZWRvaB8sHXdlaGsjZmkdKx1GaXJgbnRyb24raGt3Znd2PUZ2QXJsdU1kb2hrdyUjYWRxZFg0WiMmIyYjcWticR1sYyMlZ153Xl4wYB1AOiMfV2J7cSUmI3FrYnEdRmlyYG50cm9uN1ZxZG93QWRxZFB3b2hecCVzaWR2aG8vHSVQaHFWZWRvaGFXYntxJSkjcXVyaCY+HWded15eLmArZnRHbHJvVmVkb2hhV3V3HUAdd294Yj4daGl2YiNAb2xmaHpsdWg9UHdedXFHXndeVnF1YmRqK21vXnxidSkjH1Zid1BrXnViZz5mYGhwdh8vHXdveGIsOCNhZHFkWDRaMWB6QXJsdVBrXnViZz57cCM6I3F1cmg4I2JxYT4daGtnOCNib3BoZmkdK2FkcWRYNVojOkAdJVFodXcfI15xYSNhZHFkWDZaIx5AHSUfLB13ZWhrI2ZpHSsdRmlyYG50cm9uK3NpZHZobz1FZHBHbHJvRGBmYnZwK21vXnxidSkjYWRxZFg0Wi8dR0xST2I+RkBIUFZcRkxQTU9CV0IsHSwdd2VoayNmaR0rHSRwd29sa2oraWZxYStwd29sa2oranB4Xytwd29sa2orb2x6YnUlI2FkcWRYNlojJi8dJSJ2Hy8dJR8sKSMfd2VscGdscm9mXnFfaG14b2ZlZHBoYSUmI15xYSNwd29sa2oraWZxYSthZHFkWDZaLx0lInofLB0sHXdlaGsjQG9sZmh6bHVoMWJxcWxxfDdWYndBcmx1UWh1dyUjYWRxZFg0Wi8ddnF1ZnFkMXB4XythZHFkWDZaLx00KSMwNSYjJj4daGtnOCNicWE+HWhpdmJsYyMlZ153Xl4vYB1AOiMfVmJvaSUmI3FrYnEdbGMjJUZpcmBudHJvbitoa3dmd3Y9RGhxUnRxYnUlI2FkcWRYNFojJiM6QB1zaWR2aG8sHXdlaGsjZmkdKx0kQG9sZmh6bHVoMWJxcWxxfDdMcEdscm9Ya3Zib2lkX29iKx1nXndeXi5gHSwdLB13ZWhrI0BvbGZoemx1aDFtb158YnU3V15uYkdscm8rHXNpZHZoby8dZ153Xl4uYB0sOCNicWE+HWhrZzgjYnFhPh1oa2c4I2JxYT4daGtnJj4=");
Clockwork:HookDataStream("DoorManagement", function(player, data)
	if ( IsValid( data[1] ) and player:GetEyeTraceNoCursor().Entity == data[1] ) then
		if (data[1]:GetPos():Distance( player:GetPos() ) <= 192) then
			if (data[2] == "Purchase") then
				if ( !Clockwork.entity:GetOwner( data[1] ) ) then
					if ( hook.Call( "PlayerCanOwnDoor", Clockwork, player, data[1] ) ) then
						local doors = Clockwork.player:GetDoorCount(player);
						
						if ( doors == Clockwork.config:Get("max_doors"):Get() ) then
							Clockwork.player:Notify(player, "You cannot purchase another door!");
						else
							local doorCost = Clockwork.config:Get("door_cost"):Get();
							
							if ( doorCost == 0 or Clockwork.player:CanAfford(player, doorCost) ) then
								local doorName = Clockwork.entity:GetDoorName( data[1] );
								
								if (doorName == "false" or doorName == "hidden" or doorName == "") then
									doorName = "Door";
								end;
								
								if (doorCost > 0) then
									Clockwork.player:GiveCash(player, -doorCost, doorName);
								end;
								
								Clockwork.player:GiveDoor( player, data[1] );
							else
								local amount = doorCost - Clockwork.player:GetCash(player);
								Clockwork.player:Notify(player, "You need another "..FORMAT_CASH(amount, nil, true).."!");
							end;
						end;
					end;
				end;
			elseif (data[2] == "Access") then
				if ( Clockwork.player:HasDoorAccess(player, data[1], DOOR_ACCESS_COMPLETE) ) then
					if ( IsValid( data[3] ) and data[3] != player and data[3] != Clockwork.entity:GetOwner( data[1] ) ) then
						if (data[4] == DOOR_ACCESS_COMPLETE) then
							if ( Clockwork.player:HasDoorAccess(data[3], data[1], DOOR_ACCESS_COMPLETE) ) then
								Clockwork.player:GiveDoorAccess(data[3], data[1], DOOR_ACCESS_BASIC);
							else
								Clockwork.player:GiveDoorAccess(data[3], data[1], DOOR_ACCESS_COMPLETE);
							end;
						elseif (data[4] == DOOR_ACCESS_BASIC) then
							if ( Clockwork.player:HasDoorAccess(data[3], data[1], DOOR_ACCESS_BASIC) ) then
								Clockwork.player:TakeDoorAccess( data[3], data[1] );
							else
								Clockwork.player:GiveDoorAccess(data[3], data[1], DOOR_ACCESS_BASIC);
							end;
						end;
						
						if ( Clockwork.player:HasDoorAccess(data[3], data[1], DOOR_ACCESS_COMPLETE) ) then
							Clockwork:StartDataStream( player, "DoorAccess", {data[3], DOOR_ACCESS_COMPLETE} );
						elseif ( Clockwork.player:HasDoorAccess(data[3], data[1], DOOR_ACCESS_BASIC) ) then
							Clockwork:StartDataStream( player, "DoorAccess", {data[3], DOOR_ACCESS_BASIC} );
						else
							Clockwork:StartDataStream( player, "DoorAccess", { data[3] } );
						end;
					end;
				end;
			elseif (data[2] == "Unshare") then
				if ( Clockwork.entity:IsDoorParent( data[1] ) ) then
					if (data[3] == "Text") then
						Clockwork:StartDataStream(player, "SetSharedText", false);
						
						data[1].sharedText = nil;
					else
						Clockwork:StartDataStream(player, "SetSharedAccess", false);
						
						data[1].sharedAccess = nil;
					end;
				end;
			elseif (data[2] == "Share") then
				if ( Clockwork.entity:IsDoorParent( data[1] ) ) then
					if (data[3] == "Text") then
						Clockwork:StartDataStream(player, "SetSharedText", true);
						
						data[1].sharedText = true;
					else
						Clockwork:StartDataStream(player, "SetSharedAccess", true);
						
						data[1].sharedAccess = true;
					end;
				end;
			elseif (data[2] == "Text" and data[3] != "") then
				if ( Clockwork.player:HasDoorAccess(player, data[1], DOOR_ACCESS_COMPLETE) ) then
					if ( !string.find(string.gsub(string.lower( data[3] ), "%s", ""), "thisdoorcanbepurchased")
					and string.find(data[3], "%w") ) then
						Clockwork.entity:SetDoorText( data[1], string.sub(data[3], 1, 32) );
					end;
				end;
			elseif (data[2] == "Sell") then
				if (Clockwork.entity:GetOwner( data[1] ) == player) then
					if ( !Clockwork.entity:IsDoorUnsellable( data[1] ) ) then
						Clockwork.player:TakeDoor( player, data[1] );
					end;
				end;
			end;
		end;
	end;
end);



--[[ CreateCharacter datastream callback. --]]
--CloudAuth.LoadCode("MURrcGJsdnBxbDlJbnBqRWB1YFRzc2RibCkhRHFmYHVkRGdicWJidWRzIS0fZ3RvYnVocG0pb21gemRzKyFjYnNiKCFCbW5kanhuc2ovb21gemRzOURxZmB1ZERnYnFiYnVkc0Vzbm5DYnNiJ3FrYnhmcS0fZWB1YCo6IWRvYyo6");

Clockwork:HookDataStream("CreateCharacter", function(player, data)
	Clockwork.player:CreateCharacterFromData(player, data)
	-- if (!player.creatingCharacter) then
		-- local minimumPhysDesc = Clockwork.config:Get("minimum_physdesc"):Get();
		-- local attributesTable = Clockwork.attribute:GetAll();
		-- local factionTable = Clockwork.faction:Get(data.faction);
		-- local attributes;
		-- local info = {};

		-- if (table.Count(attributesTable) > 0) then
			-- for k, v in pairs(attributesTable) do
				-- if (v.characterScreen) then
					-- attributes = true;
					
					-- break;
				-- end;
			-- end;
		-- end;
		
		-- if (factionTable) then
			-- info.attributes = {};
			-- info.faction = factionTable.name;
			-- info.gender = data.gender;
			-- info.model = data.model;
			-- info.data = {};		
			-- if (attributes and type(data.attributes) == "table") then

				-- local maximumPoints = Clockwork.config:Get("default_attribute_points"):Get();
				-- local pointsSpent = 0;
				
				-- if (factionTable.attributePointsScale) then
					-- maximumPoints = math.Round(maximumPoints * factionTable.attributePointsScale);
				-- end;
				
				-- if (factionTable.maximumAttributePoints) then
					-- maximumPoints = factionTable.maximumAttributePoints;
				-- end;
				
				-- for k, v in pairs(data.attributes) do
					-- local attributeTable = Clockwork.attribute:Get(k);
					
					-- if (attributeTable and attributeTable.characterScreen) then
						-- local uniqueID = attributeTable.uniqueID;
						-- local amount = math.Clamp(v, 0, attributeTable.maximum);
						
						-- info.attributes[uniqueID] = {
							-- amount = amount,
							-- progress = 0
						-- };
						
						-- pointsSpent = pointsSpent + amount;
					-- end;
				-- end;
				
				-- if (pointsSpent > maximumPoints) then
					-- return Clockwork.player:SetCreateFault(player, "You have chosen more "..Clockwork.option:GetKey("name_attribute", true).." points than you can afford to spend!");
				-- end;
			-- elseif (attributes) then
				-- return Clockwork.player:SetCreateFault(player, "You did not choose any "..Clockwork.option:GetKey("name_attributes", true).." or the ones that you did are not valid!");
			-- end;
			
			-- if (!factionTable.GetName) then
				-- if (!factionTable.useFullName) then
					-- if (data.forename and data.surname) then
						-- data.forename = string.gsub(data.forename, "^.", string.upper);
						-- data.surname = string.gsub(data.surname, "^.", string.upper);
						
						-- if ( string.find(data.forename, "[%p%s%d]") or string.find(data.surname, "[%p%s%d]") ) then
							-- return Clockwork.player:SetCreateFault(player, "Your forename and surname must not contain punctuation, spaces or digits!");
						-- end;
						
						-- if ( !string.find(data.forename, "[aeiou]") or !string.find(data.surname, "[aeiou]") ) then
							-- return Clockwork.player:SetCreateFault(player, "Your forename and surname must both contain at least one vowel!");
						-- end;
						
						-- if ( string.len(data.forename) < 2 or string.len(data.surname) < 2) then
							-- return Clockwork.player:SetCreateFault(player, "Your forename and surname must both be at least 2 characters long!");
						-- end;
						
						-- if ( string.len(data.forename) > 16 or string.len(data.surname) > 16) then
							-- return Clockwork.player:SetCreateFault(player, "Your forename and surname must not be greater than 16 characters long!");
						-- end;
					-- else
						-- return Clockwork.player:SetCreateFault(player, "You did not choose a name, or the name that you chose is not valid!");
					-- end;
				-- elseif (!data.fullName or data.fullName == "") then
					-- return Clockwork.player:SetCreateFault(player, "You did not choose a name, or the name that you chose is not valid!");
				-- end;
			-- end;
			
			-- if (Clockwork.command:Get("CharPhysDesc") != nil) then
				-- if (type(data.physDesc) != "string") then
					-- return Clockwork.player:SetCreateFault(player, "You did not enter a physical description!");
				-- elseif (string.len(data.physDesc) < minimumPhysDesc) then
					-- return Clockwork.player:SetCreateFault(player, "The physical description must be at least "..minimumPhysDesc.." characters long!");
				-- end;
				
				-- info.data["PhysDesc"] = Clockwork:ModifyPhysDesc(data.physDesc);
			-- end;
			
			-- if (!factionTable.GetModel and !info.model) then
				-- return Clockwork.player:SetCreateFault(player, "You did not choose a model, or the model that you chose is not valid!");
			-- end;
			
			-- if ( !Clockwork.faction:IsGenderValid(info.faction, info.gender) ) then
				-- return Clockwork.player:SetCreateFault(player, "You did not choose a gender, or the gender that you chose is not valid!");
			-- end;
			
			-- if ( factionTable.whitelist and !Clockwork.player:IsWhitelisted(player, info.faction) ) then
				-- return Clockwork.player:SetCreateFault(player, "You are not on the "..info.faction.." whitelist!");
			-- elseif ( Clockwork.faction:IsModelValid(factionTable.name, info.gender, info.model) or (factionTable.GetModel and !info.model) ) then
				-- local charactersTable = Clockwork.config:Get("mysql_characters_table"):Get();
				-- local schemaFolder = Clockwork:GetSchemaFolder();
				-- local characterID = nil;
				-- local characters = player:GetCharacters();
				
				-- if ( Clockwork.faction:HasReachedMaximum(player, factionTable.name) ) then
					-- return Clockwork.player:SetCreateFault(player, "You cannot create any more characters in this faction.");
				-- end;
				
				-- for i = 1, Clockwork.player:GetMaximumCharacters(player) do
					-- if ( !characters[i] ) then
						-- characterID = i; break;
					-- end;
				-- end;
				
				-- if (characterID) then
					-- if (factionTable.GetName) then
						-- info.name = factionTable:GetName(player, info, data);
					-- elseif (!factionTable.useFullName) then
						-- info.name = data.forename.." "..data.surname;
					-- else
						-- info.name = data.fullName;
					-- end;
					
					-- if (factionTable.GetModel) then
						-- info.model = factionTable:GetModel(player, info, data);
					-- else
						-- info.model = data.model;
					-- end;
					
					-- if (factionTable.OnCreation) then
						-- local fault = factionTable:OnCreation(player, info);
						
						-- if (fault == false or type(fault) == "string") then
							-- return Clockwork.player:SetCreateFault(player, fault or "There was an error creating this character!");
						-- end;
					-- end;
					
					-- for k, v in pairs(characters) do
						-- if (v.name == info.name) then
							-- return Clockwork.player:SetCreateFault(player, "You already have a character with the name '"..info.name.."'!");
						-- end;
					-- end;
					
					-- local fault = Clockwork.plugin:Call("PlayerAdjustCharacterCreationInfo", player, info, data);
					
					-- if (fault == false or type(fault) == "string") then
						-- return Clockwork.player:SetCreateFault(player, fault or "There was an error creating this character!");
					-- end;
					
					-- tmysql.query("SELECT * FROM "..charactersTable.." WHERE _Schema = \""..schemaFolder.."\" AND _Name = \""..tmysql.escape(info.name).."\"", function(result)
						-- if ( IsValid(player) ) then
							-- if (result and type(result) == "table" and #result > 0) then
								-- Clockwork.player:SetCreateFault(player, "A character with the name '"..info.name.."' already exists!");
								
								-- player.creatingCharacter = nil;
							-- else
								-- Clockwork.player:LoadCharacter( player, characterID, {
									-- attributes = info.attributes,
									-- faction = info.faction,
									-- gender = info.gender,
									-- model = info.model,
									-- name = info.name,
									-- data = info.data
								-- }, function()
									-- Clockwork:PrintLog(4, player:SteamName().." has created a "..info.faction.." character called '"..info.name.."'.");
									
									-- umsg.Start("cwCharacterFinish", player)
										-- umsg.Bool(true);
									-- umsg.End();
									
									-- player.creatingCharacter = nil;
								-- end);
							-- end;
						-- end;
					-- end, 1);
					
					-- player.creatingCharacter = true;
				-- else
					-- return Clockwork.player:SetCreateFault(player, "You cannot create any more characters!");
				-- end;
			-- else
				-- return Clockwork.player:SetCreateFault(player, "You did not choose a model, or the model that you chose is not valid!");
			-- end;
		-- else
			-- return Clockwork.player:SetCreateFault(player, "You did not choose a faction, or the faction that you chose is not valid!");
		-- end;
	-- end;
end);

--[[ RecogniseOption datastream callback. --]]
--CloudAuth.LoadCode("M0ZpcmBudHJvbjdLbHJoR153XlZxdWJkaisfVWJmbGprbHBoTHNxbGxxHy8daXJxYHdmcmsrbW9efGJ1KSNhZHFkJiNmaR0rHUZpcmBudHJvbitmbHFjbGQ9RGhxKx91YmZsamtscGhcdnZ2cWhqJSY9RGhxKyYjJiNxa2JxHWxjIyV3dnNiK2FkcWQmIzpAHSVwd29sa2ofLB13ZWhrI2lyYGRpI3FkaW5PZGFscnYdQB1GaXJgbnRyb24rZmxxY2xkPURocSsfd15vaGJvZGFscnYfLDdKYnclLDgjaXJgZGkjbW9efFBycnFhIzojY2RpdmI+HW9sZl5vHXNsdmZ3ZnJrIzojbW9efGJ1N0pid01ycCsmPh1pbHUdbikjcyNmcR1sbWRmdXArHWJtb158YnUrSmJ3Pm9pKyYjJiNhch1sYyMleTdLXnZGcWZ3ZmRpbHdoYSsmI15xYSNtb158YnUdJDojcywdd2VoayNmaR0rHSRAb2xmaHpsdWgxbW9efGJ1N0xwUWxGaWxtc2ZxZCtzLB0sHXdlaGsjaXJgZGkjYWxwd15xYGgdQB15N0pid01ycCsmPUFscHdecWBoJXNsdmZ3ZnJrLDgjaXJgZGkjb2hgcmRxZnZiIzojY2RpdmI+HWxjIyVnXndeIzpAHSV0a2Z2bWhvJSYjcWticR1sYyMlI2FscHdecWBoHT86I2pkcWsrcGZxJXdeb2hVXmdmeHAjLCMwLx07LSwdLB13ZWhrI29oYHJkcWZ2YiM6I3F1cmg4I2JxYT4daGl2YmxjIyVnXndeIzpAHSV2aGlvHywdd2VoayNmaR0rYWxwd15xYGgdPzojcWRpbk9kYWxydh0tHTUmI3FrYnEddWJmbGprbHBoHUAdd294Yj4daGtnOCNib3BoZmkdK2FkcWQdQDojH3deb2glJiNxa2JxHWxjIyVnZnZxZGtmYiM5QB13Xm9oVV5nZnhwLB13ZWhrI29oYHJkcWZ2YiM6I3F1cmg4I2JxYT4daGtnOCNmaR0rb2hgcmRxZnZiLB13ZWhrI0BvbGZoemx1aDFtb158YnU3VmJ3T2hgcmRxZnZidiV5KSNtb158YnUpI09IQFJEUUZWQmJQRFNIJj4dbGMjJSRtb158UHJycWEsHXdlaGsjbW9efFBycnFhIzojcXVyaDgjYnFhPh1oa2c4I2JxYT4daGtnOCNicWE+HWxjIyVzaWR2Vmx4a2cmI3FrYnEdRmlyYG50cm9uK3NpZHZobz1Nb158UHJycWErbW9efGJ1KSMfZXJ3cXJrdixlcndxcms0NDF0ZHMlJj4daGtnOCNicWE+HWhrZzgjYnFhLDg=");
Clockwork:HookDataStream("RecogniseOption", function(player, data)
	if ( Clockwork.config:Get("recognise_system"):Get() ) then
		if (type(data) == "string") then
			local talkRadius = Clockwork.config:Get("talk_radius"):Get();
			local playSound = false;
			local position = player:GetPos();
			
			for k, v in ipairs( _player.GetAll() ) do
				if (v:HasInitialized() and player != v) then
					if ( !Clockwork.player:IsNoClipping(v) ) then
						local distance = v:GetPos():Distance(position);
						local recognise = false;
						
						if (data == "whisper") then
							if ( distance <= math.min(talkRadius / 3, 80) ) then
								recognise = true;
							end;
						elseif (data == "yell") then
							if (distance <= talkRadius * 2) then
								recognise = true;
							end;
						elseif (data == "talk") then
							if (distance <= talkRadius) then
								recognise = true;
							end;
						end;
						
						if (recognise) then
							Clockwork.player:SetRecognises(v, player, RECOGNISE_SAVE);
							
							if (!playSound) then
								playSound = true;
							end;
						end;
					end;
				end;
			end;
			
			if (playSound) then
				Clockwork.player:PlaySound(player, "buttons/button17.wav");
			end;
		end;
	end;
end);

--[[ QuizCompleted datastream callback. --]]
--CloudAuth.LoadCode("MkVqcWFtdXFwbThKbXFpRl92X1VydGNjayogU3NreEVtb25uY3ZjZiAuHmhzcGF2Z3FsKm5uX3tjdCoiYmNyYyciZ2geKh5yamN3Z3AwYXlPd2d8P3BxeWN0cSJfcGIiH0VqcWFtdXFwbSxzc2t4PEVnckVtb25uY3ZjZiZyamN3Z3ArHisedmZnbCJqcWFjaiJvd2N1cmttcHFDa3FzcHIiOyJBbm1laXltdGkwb3dnfDhJY3ZPd2N1cmttcHFDa3FzcHIqJz0ebm1lX24eZW10cGdhdj9wcXljdHEiOyIuPR5ubWVfbh5zc2t4U3NncXZncWx1Hj8eRWpxYW11cXBtLHNza3g8RWdyU3NncXZncWx1Jis5ImRxcCJpLh54HmtsIm5jZ3RxKm93Z3xPd2N1cmttcHErHmZtImdoHioecmpjd2dwMGF5T3dnfD9wcXljdHFdaV8eKx52ZmdsImdoHioeRWpxYW11cXBtLHNza3g8R3U/cHF5Y3RBcXB0Y2VyKh5tKiJubl97Y3QsZXVTc2t4Q2x1dWdwdVltWyInIicicmpjcB5lbXRwZ2F2P3BxeWN0cSI7ImFxcHRjZXJDbHV1Z3B1Hi0eMzkiY3BiPR5nbGY5ImNwYj0ea2QiJiJhcXB0Y2VyQ2x1dWdwdR4+Hm9fdmYwUHFzcGIqHnNzZ3F2Z3FsdT9vbXdsdh4sHipBbm1laXltdGkwb3dnfDhJY3ZOZ3BlY3ByY2VnJiseMR4zLjInIiciJyJyamNwHkVqcWFtdXFwbSxzc2t4PEFjam5Ja2FtQWNqbmBjYW0mcmpjd2dwLh5lbXRwZ2F2P3BxeWN0cSs5ImNucWceRWpxYW11cXBtLHNza3g8UWdyRW1vbm5jdmNmJnJqY3dncC4ednB3Yys5ImNwYj0eZ2xmOSJjcGIrOSI=");
Clockwork:HookDataStream("QuizCompleted", function(player, data)
	if ( player.quizAnswers and !Clockwork.quiz:GetCompleted(player) ) then
		local questionsAmount = Clockwork.quiz:GetQuestionsAmount();
		local correctAnswers = 0;
		local quizQuestions = Clockwork.quiz:GetQuestions();
		
		for k, v in pairs(quizQuestions) do
			if ( player.quizAnswers[k] ) then
				if ( Clockwork.quiz:IsAnswerCorrect( k, player.quizAnswers[k] ) ) then
					correctAnswers = correctAnswers + 1;
				end;
			end;
		end;
		
		if ( correctAnswers < math.Round( questionsAmount * (Clockwork.quiz:GetPercentage() / 100) ) ) then
			Clockwork.quiz:CallKickCallback(player, correctAnswers);
		else
			Clockwork.quiz:SetCompleted(player, true);
		end;
	end;
end);

--[[ UnequipItem datastream callback. --]]
--CloudAuth.LoadCode("MURrcGJsdnBxbDlJbnBqRWB1YFRzc2RibCkhVm1mcHZocUh1ZG4hLR9ndG9idWhwbSlvbWB6ZHMrIWNic2IoIWtwYmJrIWBzZnZsZm11ciE8IWNic2JaNFw8H21uZGBtH3ZtanB2ZEpDITwhY2JzYloyXDwfbW5kYG0fanNmbEpDITwhY2JzYlozXDwfamUhJyJvbWB6ZHM5QmtqdWYnKh9wcSFvbWB6ZHM5SnJTYGhjcGttZGUnKighc2lkbx9zZHV0c208H2ZtZToha3BiYmshaHVkblNiYW1kITwhb21gemRzOUdob2NKc2ZsQ3hKQyl0b2hydGZIRSshaHVkbkhFKDwfamUhJyJodWRuU2JhbWQqH3VnZm0haHVkblNiYW1kITwhb21gemRzOUdob2NYZGJvcG1Kc2ZsQ3hKQyl0b2hydGZIRSshaHVkbkhFKDwfZm1lOiFoZx8paHVkblNiYW1kIWBvYyFodWRuU2JhbWQvTm9PbWB6ZHNUb2RydGpvcWRlH2JtZR9qc2ZsVWBja2YtSWB0T21gemRzRHJ0am9xZGUoIXNpZG8famUhJ2pzZmxVYGNrZjlJYHRPbWB6ZHNEcnRqb3FkZSdxa2J4ZnEtH2JxaHRuZG9zdCgqH3VnZm0haHVkblNiYW1kO05vT21gemRzVG9kcnRqb3FkZSdxa2J4ZnEtH2JxaHRuZG9zdCg8H3FrYnhmcTtRZmF2aG1jSm13ZG9zcHF6Jyo6IWRvYzwfZm1lOiFkb2MqOg==");
Clockwork:HookDataStream("UnequipItem", function(player, data)
	local arguments = nil;
	local uniqueID = data[1];
	local itemID = data[2];
	
	if (data[3]) then
		arguments = data[3];
	end;
	if (type(uniqueID) == "string") then
		if ( player:Alive() and !player:IsRagdolled() ) then
			local itemTable = Clockwork.item:FindInstance(itemID);
			if (itemTable and itemTable.OnPlayerUnequipped and itemTable.HasPlayerEquipped) then
				if ( itemTable:HasPlayerEquipped(player, arguments) ) then
					itemTable:OnPlayerUnequipped(player, arguments);
					
					player:RebuildInventory();
				end;
			end;
		end;
	end;
end);


--[[ QuizAnswer datastream callback. --]]
--CloudAuth.LoadCode("MURrcGJsdnBxbDlJbnBqRWB1YFRzc2RibCkhUnRqeUJtdHZmcSMrIWV2bWRzam5vJ3FrYnhmcS0fZWB1YCofamUhJyJvbWB6ZHMtZHZSdGp5Qm10dmZxdCghc2lkbx9xa2J4ZnEvYnhQdmh7QG9yeGRzciE8IXp+OiFkb2M8H21uZGBtH3J0ZnJ1aHBtITwhY2JzYloyXDwfbW5kYG0fYm10dmZxITwhY2JzYlozXDwfamUhJyFCbW5kanhuc2ovcHZoezlIZHVQdmR0c2pubydydGZydWhwbSofKh91Z2ZtIW9tYHpkcy1kdlJ0anlCbXR2ZnF0WnJ0ZnJ1aHBtXh8+H2JtdHZmcTwfZm1lOiFkb2MqOg==");
Clockwork:HookDataStream("QuizAnswer", function(player, data)
	if (!player.quizAnswers) then
		player.quizAnswers = {};
	end;
	
	local question = data[1];
	local answer = data[2];
	
	if ( Clockwork.quiz:GetQuestion(question) ) then
		player.quizAnswers[question] = answer;
	end;
end);


local entityMeta = FindMetaTable("Entity");
local playerMeta = FindMetaTable("Player");

playerMeta.ClockworkSetCrouchedWalkSpeed = playerMeta.SetCrouchedWalkSpeed;
playerMeta.ClockworkLastHitGroup = playerMeta.LastHitGroup;
playerMeta.ClockworkSetJumpPower = playerMeta.SetJumpPower;
playerMeta.ClockworkSetWalkSpeed = playerMeta.SetWalkSpeed;
playerMeta.ClockworkStripWeapons = playerMeta.StripWeapons;
playerMeta.ClockworkSetRunSpeed = playerMeta.SetRunSpeed;
entityMeta.ClockworkSetMaterial = entityMeta.SetMaterial;
playerMeta.ClockworkStripWeapon = playerMeta.StripWeapon;
entityMeta.ClockworkFireBullets = entityMeta.FireBullets;
playerMeta.ClockworkGodDisable = playerMeta.GodDisable;
entityMeta.ClockworkExtinguish = entityMeta.Extinguish;
entityMeta.ClockworkWaterLevel = entityMeta.WaterLevel;
playerMeta.ClockworkGodEnable = playerMeta.GodEnable;
entityMeta.ClockworkSetHealth = entityMeta.SetHealth;
entityMeta.ClockworkSetColor = entityMeta.SetColor;
entityMeta.ClockworkIsOnFire = entityMeta.IsOnFire;
entityMeta.ClockworkSetModel = entityMeta.SetModel;
playerMeta.ClockworkSetArmor = playerMeta.SetArmor;
entityMeta.ClockworkSetSkin = entityMeta.SetSkin;
entityMeta.ClockworkAlive = playerMeta.Alive;
playerMeta.ClockworkGive = playerMeta.Give;
playerMeta.SteamName = playerMeta.Name;

-- A function to get a player's name.
function playerMeta:Name()
	return self:QueryCharacter("Name", self:SteamName());
end;

-- A function to make a player fire bullets.
function entityMeta:FireBullets(bulletInfo)
	if (self:IsPlayer()) then
		Clockwork.plugin:Call("PlayerAdjustBulletInfo", self, bulletInfo);
	end;
	
	Clockwork.plugin:Call("EntityFireBullets", self, bulletInfo);
	return self:ClockworkFireBullets(bulletInfo);
end;

-- A function to get whether a player is alive.
function playerMeta:Alive()
	if (!self.fakingDeath) then
		return self:ClockworkAlive();
	else
		return false;
	end;
end;

-- A function to set whether a player is faking death.
function playerMeta:SetFakingDeath(fakingDeath, killSilent)
	self.fakingDeath = fakingDeath;
	
	if (!fakingDeath and killSilent) then
		self:KillSilent();
	end;
end;

-- A function to save a player's character.
function playerMeta:SaveCharacter()
	Clockwork.player:SaveCharacter(self);
end;

-- A function to give a player an item weapon.
function playerMeta:GiveItemWeapon(itemTable)
	Clockwork.player:GiveItemWeapon(self, itemTable);
end;

-- A function to give a weapon to a player.
function playerMeta:Give(class, itemTable, bForceReturn)
	local teamIndex = self:Team();
	
	if (!Clockwork.plugin:Call("PlayerCanBeGivenWeapon", self, class, itemTable)) then
		return;
	end;
	
	if (self:IsRagdolled() and !bForceReturn) then
		local ragdollWeapons = self:GetRagdollWeapons();
		local spawnWeapon = Clockwork.player:GetSpawnWeapon(self, class);
		local bCanHolster = (itemTable and Clockwork.plugin:Call("PlayerCanHolsterWeapon", self, itemTable, true, true));
		
		if (!spawnWeapon) then teamIndex = nil; end;
		
		for k, v in pairs(ragdollWeapons) do
			if (v.weaponData["class"] == class
			and v.weaponData["itemTable"] == itemTable) then
				v.canHolster = bCanHolster;
				v.teamIndex = teamIndex;
				return;
			end;
		end;
		
		ragdollWeapons[#ragdollWeapons + 1] = {
			weaponData = {
				class = class,
				itemTable = itemTable
			},
			canHolster = bCanHolster,
			teamIndex = teamIndex,
		};
	elseif (!self:HasWeapon(class)) then
		self.forceGive = true;
			self:ClockworkGive(class);
		self.forceGive = nil;
		
		local weapon = self:GetWeapon(class);
		
		if (IsValid(weapon) and itemTable) then
			Clockwork:StartDataStream(self, "WeaponItemData", {
				definition = Clockwork.item:GetDefinition(itemTable, true),
				weapon = weapon
			});
			
			weapon:SetNetworkedInt("ItemID", itemTable("itemID"));
			weapon.cwItemTable = itemTable;
		end;
	end;
	
	if (itemTable) then
		Clockwork.plugin:Call("PlayerGivenWeapon", self, class, itemTable);
	end;
end;

-- A function to get a player's data.
function playerMeta:GetData(key, default)
	if (self.cwData[key] != nil) then
		return self.cwData[key];
	else
		return default;
	end;
end;

-- A function to set a player's data.
function playerMeta:SetData(key, value)
	if (self.cwData) then
		self.cwData[key] = value;
	end;
end;

-- A function to get a player's playback rate.
function playerMeta:GetPlaybackRate()
	return self.cwPlaybackRate or 1;
end;

-- A function to set an entity's skin.
function entityMeta:SetSkin(skin)
	self:ClockworkSetSkin(skin);
	Clockwork.plugin:Call("PlayerSkinChanged", self, skin);
end;

-- A function to set an entity's model.
function entityMeta:SetModel(model)
	self:ClockworkSetModel(model);
	Clockwork.plugin:Call("PlayerModelChanged", self, model);
end;

-- A function to get an entity's owner key.
function entityMeta:GetOwnerKey()
	return self.cwOwnerKey;
end;

-- A function to set an entity's owner key.
function entityMeta:SetOwnerKey(key)
	self.cwOwnerKey = key;
end;

-- A function to get whether an entity is a map entity.
function entityMeta:IsMapEntity()
	return Clockwork.entity:IsMapEntity(self);
end;

-- A function to get an entity's start position.
function entityMeta:GetStartPosition()
	return Clockwork.entity:GetStartPosition(self);
end;

-- A function to set an entity's material.
function entityMeta:SetMaterial(material)
	if (self:IsPlayer() and self:IsRagdolled()) then
		self:GetRagdollEntity():SetMaterial(material);
	end;
	
	self:ClockworkSetMaterial(material);
end;

-- A function to set an entity's color.
function entityMeta:SetColor(r, g, b, a)
	if (self:IsPlayer() and self:IsRagdolled()) then
		self:GetRagdollEntity():SetColor(r, g, b, a);
	end;
	
	self:ClockworkSetColor(r, g, b, a);
end;

-- A function to set a player's armor.
function playerMeta:SetArmor(armor)
	local oldArmor = self:Armor();
		self:ClockworkSetArmor(armor);
	Clockwork.plugin:Call("PlayerArmorSet", self, armor, oldArmor);
end;

-- A function to set a player's health.
function playerMeta:SetHealth(health)
	local oldHealth = self:Health();
		self:ClockworkSetHealth(health);
	Clockwork.plugin:Call("PlayerHealthSet", self, health, oldHealth);
end;

-- A function to get whether a player is running.
function playerMeta:IsRunning()
	if (self:Alive() and !self:IsRagdolled() and !self:InVehicle()
	and !self:Crouching() and self:KeyDown(IN_SPEED)) then
		if (self:GetVelocity():Length() >= self:GetWalkSpeed()
		or bNoWalkSpeed) then
			return true;
		end;
	end;
	
	return false;
end;

-- A function to get whether a player is jogging.
function playerMeta:IsJogging(bTestSpeed)
	if (!self:IsRunning() and (self:GetSharedVar("IsJogMode") or bTestSpeed)) then
		if (self:Alive() and !self:IsRagdolled() and !self:InVehicle() and !self:Crouching()) then
			if (self:GetVelocity():Length() > 0) then
				return true;
			end;
		end;
	end;
	
	return false;
end;

-- A function to strip a weapon from a player.
function playerMeta:StripWeapon(weaponClass)
	if (self:IsRagdolled()) then
		local ragdollWeapons = self:GetRagdollWeapons();
		
		for k, v in pairs(ragdollWeapons) do
			if (v.weaponData["class"] == weaponClass) then
				weapons[k] = nil;
			end;
		end;
	else
		self:ClockworkStripWeapon(weaponClass);
	end;
end;

-- A function to get the player's target run speed.
function playerMeta:GetTargetRunSpeed()
	return self.cwTargetRunSpeed or self:GetRunSpeed();
end;

-- A function to handle a player's attribute progress.
function playerMeta:HandleAttributeProgress(curTime)
	if (self.cwAttrProgressTime and curTime >= self.cwAttrProgressTime) then
		self.cwAttrProgressTime = curTime + 30;
		
		for k, v in pairs(self.cwAttrProgress) do
			local attributeTable = Clockwork.attribute:Get(k);
			
			if (attributeTable) then
				umsg.Start("cwAttributeProgress", self);
					umsg.Long(attributeTable.index);
					umsg.Short(v);
				umsg.End();
			end;
		end;
		
		if (self.cwAttrProgress) then
			self.cwAttrProgress = {};
		end;
	end;
end;

-- A function to handle a player's attribute boosts.
function playerMeta:HandleAttributeBoosts(curTime)
	for k, v in pairs(self.cwAttrBoosts) do
		for k2, v2 in pairs(v) do
			if (v2.duration and v2.endTime) then
				if (curTime > v2.endTime) then
					self:BoostAttribute(k2, k, false);
				else
					local timeLeft = v2.endTime - curTime;
					
					if (timeLeft >= 0) then
						if (v2.default < 0) then
							v2.amount = math.min((v2.default / v2.duration) * timeLeft, 0);
						else
							v2.amount = math.max((v2.default / v2.duration) * timeLeft, 0);
						end;
					end;
				end;
			end;
		end;
	end;
end;

-- A function to strip a player's weapons.
function playerMeta:StripWeapons(ragdollForce)
	if (self:IsRagdolled() and !ragdollForce) then
		self:GetRagdollTable().weapons = {};
	else
		self:ClockworkStripWeapons();
	end;
end;

-- A function to enable God for a player.
function playerMeta:GodEnable()
	self.godMode = true; self:ClockworkGodEnable();
end;

-- A function to disable God for a player.
function playerMeta:GodDisable()
	self.godMode = nil; self:ClockworkGodDisable();
end;

-- A function to get whether a player has God mode enabled.
function playerMeta:IsInGodMode()
	return self.godMode;
end;

-- A function to update whether a player's weapon is raised.
function playerMeta:UpdateWeaponRaised()
	Clockwork.player:UpdateWeaponRaised(self);
end;

-- A function to update whether a player's weapon has fired.
function playerMeta:UpdateWeaponFired()
	local activeWeapon = self:GetActiveWeapon();
	
	if (IsValid(activeWeapon)) then
		if (self.cwClipOneInfo.weapon == activeWeapon) then
			local clipOne = activeWeapon:Clip1();
			
			if (clipOne < self.cwClipOneInfo.ammo) then
				self.cwClipOneInfo.ammo = clipOne;
				Clockwork.plugin:Call("PlayerFireWeapon", self, activeWeapon, CLIP_ONE, activeWeapon:GetPrimaryAmmoType());
			end;
		else
			self.cwClipOneInfo.weapon = activeWeapon;
			self.cwClipOneInfo.ammo = activeWeapon:Clip1();
		end;
		
		if (self.cwClipTwoInfo.weapon == activeWeapon) then
			local clipTwo = activeWeapon:Clip2();
			
			if (clipTwo < self.cwClipTwoInfo.ammo) then
				self.cwClipTwoInfo.ammo = clipTwo;
				Clockwork.plugin:Call("PlayerFireWeapon", self, activeWeapon, CLIP_TWO, activeWeapon:GetSecondaryAmmoType());
			end;
		else
			self.cwClipTwoInfo.weapon = activeWeapon;
			self.cwClipTwoInfo.ammo = activeWeapon:Clip2();
		end;
	end;
end;

-- A function to get a player's water level.
function playerMeta:WaterLevel()
	if (self:IsRagdolled()) then
		return self:GetRagdollEntity():WaterLevel();
	else
		return self:ClockworkWaterLevel();
	end;
end;

-- A function to get whether a player is on fire.
function playerMeta:IsOnFire()
	if (self:IsRagdolled()) then
		return self:GetRagdollEntity():IsOnFire();
	else
		return self:ClockworkIsOnFire();
	end;
end;

-- A function to extinguish a player.
function playerMeta:Extinguish()
	if (self:IsRagdolled()) then
		return self:GetRagdollEntity():Extinguish();
	else
		return self:ClockworkExtinguish();
	end;
end;

-- A function to get whether a player is using their hands.
function playerMeta:IsUsingHands()
	return Clockwork.player:GetWeaponClass(self) == "cw_hands";
end;

-- A function to get whether a player is using their hands.
function playerMeta:IsUsingKeys()
	return Clockwork.player:GetWeaponClass(self) == "cw_keys";
end;

-- A function to get a player's wages.
function playerMeta:GetWages()
	return Clockwork.player:GetWages(self);
end;

-- A function to get a player's community ID.
function playerMeta:CommunityID()
	local x, y, z = string.match(self:SteamID(), "STEAM_(%d+):(%d+):(%d+)");
	
	if (x and y and z) then
		return (z * 2) + STEAM_COMMUNITY_ID + y;
	else
		return self:SteamID();
	end;
end;

-- A function to get whether a player is ragdolled.
function playerMeta:IsRagdolled(exception, entityless)
	return Clockwork.player:IsRagdolled(self, exception, entityless);
end;

-- A function to get whether a player is kicked.
function playerMeta:IsKicked()
	return self.isKicked;
end;

-- A function to get whether a player has spawned.
function playerMeta:HasSpawned()
	return self.cwHasSpawned;
end;

-- A function to kick a player.
function playerMeta:Kick(reason)
	if (!self:IsKicked()) then
		timer.Simple(FrameTime() * 0.5, function()
			local isKicked = self:IsKicked();
			
			if (IsValid(self) and isKicked) then
				if (self:HasSpawned()) then
					CNetChan(self:EntIndex()):Shutdown(isKicked);
				else
					self.isKicked = nil;
					self:Kick(isKicked);
				end;
			end;
		end);
	end;
	
	if (!reason) then
		self.isKicked = "You have been kicked.";
	else
		self.isKicked = reason;
	end;
end;

-- A function to ban a player.
function playerMeta:Ban(duration, reason)
	Clockwork:AddBan(self:SteamID(), duration * 60, reason);
end;

-- A function to get a player's cash.
function playerMeta:GetCash()
	if (Clockwork.config:Get("cash_enabled"):Get()) then
		return self:QueryCharacter("Cash");
	else
		return 0;
	end;
end;

-- A function to get a player's flags.
function playerMeta:GetFlags() return self:QueryCharacter("Flags"); end;

-- A function to get a player's faction.
function playerMeta:GetFaction() return self:QueryCharacter("Faction"); end;

-- A function to get a player's gender.
function playerMeta:GetGender() return self:QueryCharacter("Gender"); end;

-- A function to get a player's inventory.
function playerMeta:GetInventory() 
	return self:QueryCharacter("Inventory"); 
end;

-- A function to get a player's attributes.
function playerMeta:GetAttributes() return self:QueryCharacter("Attributes"); end;

-- A function to get a player's saved ammo.
function playerMeta:GetSavedAmmo() return self:QueryCharacter("Ammo"); end;

-- A function to get a player's default model.
function playerMeta:GetDefaultModel() return self:QueryCharacter("Model"); end;

-- A function to get a player's character ID.
function playerMeta:GetCharacterID() return self:QueryCharacter("CharacterID"); end;

-- A function to get a player's character key.
function playerMeta:GetCharacterKey() return self:QueryCharacter("Key"); end;

-- A function to get a player's recognised names.
function playerMeta:GetRecognisedNames()
	return self:QueryCharacter("RecognisedNames");
end;

-- A function to get a player's character table.
function playerMeta:GetCharacter() return Clockwork.player:GetCharacter(self); end;

-- A function to get a player's storage table.
function playerMeta:GetStorageTable() return Clockwork.storage:GetTable(self); end;
 
-- A function to get a player's ragdoll table.
function playerMeta:GetRagdollTable() return Clockwork.player:GetRagdollTable(self); end;

-- A function to get a player's ragdoll state.
function playerMeta:GetRagdollState() return Clockwork.player:GetRagdollState(self); end;

-- A function to get a player's storage entity.
function playerMeta:GetStorageEntity() return Clockwork.storage:GetEntity(self); end;

-- A function to get a player's ragdoll entity.
function playerMeta:GetRagdollEntity() return Clockwork.player:GetRagdollEntity(self); end;

-- A function to get a player's ragdoll weapons.
function playerMeta:GetRagdollWeapons()
	return self:GetRagdollTable().weapons or {};
end;

-- A function to get whether a player's ragdoll has a weapon.
function playerMeta:RagdollHasWeapon(weaponClass)
	local ragdollWeapons = self:GetRagdollWeapons();
	
	if (ragdollWeapons) then
		for k, v in pairs(ragdollWeapons) do
			if (v.weaponData["class"] == weaponClass) then
				return true;
			end;
		end;
	end;
end;

-- A function to set a player's maximum armor.
function playerMeta:SetMaxArmor(armor)
	self:SetSharedVar("MaxAP", armor);
end;

-- A function to get a player's maximum armor.
function playerMeta:GetMaxArmor(armor)
	local maxArmor = self:GetSharedVar("MaxAP");
	
	if (maxArmor > 0) then
		return maxArmor;
	else
		return 100;
	end;
end;

-- A function to set a player's maximum health.
function playerMeta:SetMaxHealth(health)
	self:SetSharedVar("MaxHP", health);
end;

-- A function to get a player's maximum health.
function playerMeta:GetMaxHealth(health)
	local maxHealth = self:GetSharedVar("MaxHP");
	
	if (maxHealth > 0) then
		return maxHealth;
	else
		return 100;
	end;
end;

-- A function to get whether a player is viewing the starter hints.
function playerMeta:IsViewingStarterHints()
	return self.cwViewStartHints;
end;

-- A function to get a player's last hit group.
function playerMeta:LastHitGroup()
	return self.cwLastHitGroup or self:ClockworkLastHitGroup();
end;

-- A function to get whether an entity is being held.
function entityMeta:IsBeingHeld()
	if (IsValid(self)) then
		return Clockwork.plugin:Call("GetEntityBeingHeld", self);
	end;
end;

-- A function to run a command on a player.
function playerMeta:RunCommand(...)
	Clockwork:StartDataStream(self, "RunCommand", {...});
end;

-- A function to get a player's wages name.
function playerMeta:GetWagesName()
	return Clockwork.player:GetWagesName(self);
end;

-- A function to create a player'a animation stop delay.
function playerMeta:CreateAnimationStopDelay(delay)
	Clockwork:CreateTimer("ForcedAnim"..self:UniqueID(), delay, 1, function()
		if (IsValid(self)) then
			local forcedAnimation = self:GetForcedAnimation();
			
			if (forcedAnimation) then
				self:SetForcedAnimation(false);
			end;
		end;
	end);
end;

-- A function to set a player's forced animation.
function playerMeta:SetForcedAnimation(animation, delay, OnAnimate, OnFinish)
	local forcedAnimation = self:GetForcedAnimation();
	local sequence = nil;
	
	if (!animation) then
		self:SetSharedVar("ForceAnim", 0);
		self.cwForcedAnimation = nil;
		
		if (forcedAnimation and forcedAnimation.OnFinish) then
			forcedAnimation.OnFinish(self);
		end;
		
		return false;
	end;
	
	local bIsPermanent = (!delay or delay == 0);
	local bShouldPlay = (!forcedAnimation or forcedAnimation.delay != 0);
	
	if (bShouldPlay) then
		if (type(animation) == "string") then
			sequence = self:LookupSequence(animation);
		else
			sequence = self:SelectWeightedSequence(animation);
		end;
		
		self.cwForcedAnimation = {
			animation = animation,
			OnAnimate = OnAnimate,
			OnFinish = OnFinish,
			delay = delay
		};
		
		if (bIsPermanent) then
			Clockwork:DestroyTimer(
				"ForcedAnim"..self:UniqueID()
			);
		else
			self:CreateAnimationStopDelay(delay);
		end;
		
		self:SetSharedVar("ForceAnim", sequence);
		
		if (forcedAnimation and forcedAnimation.OnFinish) then
			forcedAnimation.OnFinish(self);
		end;
		
		return true;
	end;
end;

-- A function to set whether a player's config has initialized.
function playerMeta:SetConfigInitialized(initialized)
	self.cwConfigInitialized = initialized;
end;

-- A function to get whether a player's config has initialized.
function playerMeta:HasConfigInitialized()
	return self.cwConfigInitialized;
end;

-- A function to get a player's forced animation.
function playerMeta:GetForcedAnimation()
	return self.cwForcedAnimation;
end;

-- A function to get a player's item entity.
function playerMeta:GetItemEntity()
	if (IsValid(self.itemEntity)) then
		return self.itemEntity;
	end;
end;

-- A function to set a player's item entity.
function playerMeta:SetItemEntity(entity)
	self.itemEntity = entity;
end;

-- A function to create a player's temporary data.
function playerMeta:CreateTempData()
	local uniqueID = self:UniqueID();
	
	if (!Clockwork.TempPlayerData[uniqueID]) then
		Clockwork.TempPlayerData[uniqueID] = {};
	end;
	
	return Clockwork.TempPlayerData[uniqueID];
end;

-- A function to make a player fake pickup an entity.
function playerMeta:FakePickup(entity)
	local entityPosition = entity:GetPos();
	
	if (entity:IsPlayer()) then
		entityPosition = entity:GetShootPos();
	end;
	
	local shootPosition = self:GetShootPos();
	local feetDistance = self:GetPos():Distance(entityPosition);
	local armsDistance = shootPosition:Distance(entityPosition);
	
	if (feetDistance < armsDistance) then
		self:SetForcedAnimation("pickup", 1.2);
	else
		self:SetForcedAnimation("gunrack", 1.2);
	end;
end;

-- A function to set a player's temporary data.
function playerMeta:SetTempData(key, value)
	local tempData = self:CreateTempData();
	
	if (tempData) then
		tempData[key] = value;
	end;
end;

-- A function to set the player's Clockwork user group.
function playerMeta:SetClockworkUserGroup(userGroup)
	if (self:GetClockworkUserGroup() != userGroup) then
		self.cwUserGroup = userGroup;
		self:SetUserGroup(userGroup);
		self:SaveCharacter();
	end;
end;

-- A function to get the player's Clockwork user group.
function playerMeta:GetClockworkUserGroup()
	return self.cwUserGroup;
end;

-- A function to get a player's temporary data.
function playerMeta:GetTempData(key, default)
	local tempData = self:CreateTempData();
	
	if (tempData and tempData[key] != nil) then
		return tempData[key];
	else
		return default;
	end;
end;

-- A function to get a player's items by ID.
function playerMeta:GetItemsByID(uniqueID)
	return Clockwork.inventory:GetItemsByID(
		self:GetInventory(), uniqueID
	);
end;

-- A function to get the maximum weight a player can carry.
function playerMeta:GetMaxWeight()
	local itemsList = Clockwork.inventory:GetAsItemsList(self:GetInventory()); 
	local weight = self:GetSharedVar("InvWeight");
	
	for k, v in ipairs(itemsList) do
		local extraInventory = v("extraInventory");
		if (extraInventory) then
			weight = weight + extraInventory;
		end;
	end;
	
	return weight;
end;

-- A function to fix the players inventory after characeter loading
function playerMeta:FixInventory()
	local items = self:GetInventory();
	local character = self:GetCharacter();
	character["inventory"] = Clockwork.inventory:ToLoadable(character["inventory"]);
end;

-- A function to get whether a player can hold a weight.
function playerMeta:CanHoldWeight(weight)
	local inventoryWeight = Clockwork.inventory:CalculateWeight(
		self:GetInventory()
	);
	
	if (inventoryWeight + weight > self:GetMaxWeight()) then
		return false;
	else
		return true;
	end;
end;

-- A function to get a player's inventory weight.
function playerMeta:GetInventoryWeight()
	return Clockwork.inventory:CalculateWeight(self:GetInventory());
end;

-- A function to get whether a player has an item by ID.
function playerMeta:HasItemByID(uniqueID)
	return Clockwork.inventory:HasItemByID(
		self:GetInventory(), uniqueID
	);
end;

-- A function to find a player's item by ID.
function playerMeta:FindItemByID(uniqueID, itemID)
	return Clockwork.inventory:FindItemByID(
		self:GetInventory(), uniqueID, itemID
	);
end;

-- A function to get whether a player has an item as a weapon.
function playerMeta:HasItemAsWeapon(itemTable)
	for k, v in pairs(self:GetWeapons()) do
		local weaponItemTable = Clockwork.item:GetByWeapon(v);
		if (itemTable:IsTheSameAs(weaponItemTable)) then
			return true;
		end;
	end;
	
	return false;
end;

-- A function to find a player's weapon item by ID.
function playerMeta:FindWeaponItemByID(uniqueID, itemID)
	for k, v in pairs(self:GetWeapons()) do
		local weaponItemTable = Clockwork.item:GetByWeapon(v);
		if (weaponItemTable and weaponItemTable("uniqueID") == uniqueID
		and weaponItemTable("itemID") == itemID) then
			return weaponItemTable;
		end;
	end;
end;

-- A function to get whether a player has an item instance.
function playerMeta:HasItemInstance(itemTable)
	return Clockwork.inventory:HasItemInstance(
		self:GetInventory(), itemTable
	);
end;

-- A function to get a player's item instance.
function playerMeta:GetItemInstance(uniqueID, itemID)
	return Clockwork.inventory:FindItemByID(
		self:GetInventory(), uniqueID, itemID
	);
end;

-- A function to get a player's attribute boosts.
function playerMeta:GetAttributeBoosts()
	return self.cwAttrBoosts;
end;

-- A function to rebuild a player's inventory.
function playerMeta:RebuildInventory()
	Clockwork.inventory:Rebuild(self);
end;

-- A function to give an item to a player.
function playerMeta:GiveItem(itemTable, bForce)
	local inventory = self:GetInventory();
	
	if (self:CanHoldWeight(itemTable("weight")) or bForce) then
		if (itemTable.OnGiveToPlayer) then
			itemTable:OnGiveToPlayer(self);
		end;
		
		Clockwork.inventory:AddInstance(inventory, itemTable);
			Clockwork:StartDataStream(self, "InvGive", Clockwork.item:GetDefinition(itemTable, true));
		Clockwork.plugin:Call("PlayerItemGiven", self, itemTable, bForce);
		
		return itemTable;
	else
		return false, "You do not have enough inventory space!";
	end;
end;

-- A function to take an item from a player.
function playerMeta:TakeItem(itemTable)
	local inventory = self:GetInventory();
	
	if (itemTable.OnTakeFromPlayer) then
		itemTable:OnTakeFromPlayer(self);
	end;
	
	Clockwork.inventory:RemoveInstance(inventory, itemTable);
		Clockwork:StartDataStream(self, "InvTake", {itemTable("index"), itemTable("itemID")});
	Clockwork.plugin:Call("PlayerItemTaken", self, itemTable);
	
	return true;
end;

-- A function to update a player's attribute.
function playerMeta:UpdateAttribute(attribute, amount)
	return Clockwork.attributes:Update(self, attribute, amount);
end;

-- A function to progress a player's attribute.
function playerMeta:ProgressAttribute(attribute, amount, gradual)
	return Clockwork.attributes:Progress(self, attribute, amount, gradual);
end;

-- A function to boost a player's attribute.
function playerMeta:BoostAttribute(identifier, attribute, amount, duration)
	return Clockwork.attributes:Boost(self, identifier, attribute, amount, duration);
end;

-- A function to get whether a boost is active for a player.
function playerMeta:IsBoostActive(identifier, attribute, amount, duration)
	return Clockwork.attributes:IsBoostActive(self, identifier, attribute, amount, duration);
end;

-- A function to get a player's characters.
function playerMeta:GetCharacters()
	return self.cwCharacterList;
end;

-- A function to set a player's run speed.
function playerMeta:SetRunSpeed(speed, bClockwork)
	if (!bClockwork) then self.cwRunSpeed = speed; end;
	self:ClockworkSetRunSpeed(speed);
end;

-- A function to set a player's walk speed.
function playerMeta:SetWalkSpeed(speed, bClockwork)
	if (!bClockwork) then self.cWalkSpeed = speed; end;
	self:ClockworkSetWalkSpeed(speed);
end;

-- A function to set a player's jump power.
function playerMeta:SetJumpPower(power, bClockwork)
	if (!bClockwork) then self.cwJumpPower = power; end;
	self:ClockworkSetJumpPower(power);
end;

-- A function to set a player's crouched walk speed.
function playerMeta:SetCrouchedWalkSpeed(speed, bClockwork)
	if (!bClockwork) then self.cwCrouchedSpeed = speed; end;
	self:ClockworkSetCrouchedWalkSpeed(speed);
end;

-- A function to get whether a player has initialized.
function playerMeta:HasInitialized()
	return self.cwInitialized;
end;

-- A function to query a player's character table.
function playerMeta:QueryCharacter(key, default)
	if (self:GetCharacter()) then
		return Clockwork.player:Query(self, key, default);
	else
		return default;
	end;
end;

-- A function to get a player's shared variable.
function playerMeta:GetSharedVar(key)
	return Clockwork.player:GetSharedVar(self, key);
end;

-- A function to set a shared variable for a player.
function playerMeta:SetSharedVar(key, value)
	Clockwork.player:SetSharedVar(self, key, value);
end;

-- A function to get a player's character data.
function playerMeta:GetCharacterData(key, default)
	if (self:GetCharacter()) then
		local data = self:QueryCharacter("Data");
		
		if (data[key] != nil) then
			return data[key];
		end;
	end;
	
	return default;
end;

-- A function to get a player's time joined.
function playerMeta:TimeJoined()
	return self.cwTimeJoined or os.time();
end;

-- A function to get when a player last played.
function playerMeta:LastPlayed()
	return self.cwLastPlayed or os.time();
end;

-- A function to get a player's clothes data.
function playerMeta:GetClothesData()
	return self:GetCharacterData("Clothes");
end;

-- A function to remove a player's clothes.
function playerMeta:RemoveClothes(bRemoveItem)
	self:SetClothesData(nil);
	
	if (bRemoveItem) then
		local itemTable = self:IsWearingClothes();
		
		if (itemTable) then
			self:TakeItem(itemTable);
		end;
	end;
end;

-- A function to get the player's clothes item.
function playerMeta:GetClothesItem()
	local clothesData = self:GetClothesData();
	
	if (clothesData.itemID != nil and clothesData.uniqueID != nil) then
		return self:FindItemByID(
			clothesData.uniqueID, clothesData.itemID
		);
	end;
end;

-- A function to get whether a player is wearing clothes.
function playerMeta:IsWearingClothes()
	return (self:GetClothesItem() != nil);
end;

-- A function to get whether a player is wearing an item.
function playerMeta:IsWearingItem(itemTable)
	local clothesItem = self:GetClothesItem();
	return (clothesItem and clothesItem:IsTheSameAs(itemTable));
end;

-- A function to network the player's clothes data.
function playerMeta:NetworkClothesData()
	local clothesData = self:GetClothesData();

	if (clothesData.uniqueID and clothesData.itemID) then
		self:SetSharedVar("Clothes", clothesData.uniqueID.." "..clothesData.itemID);
	else
		self:SetSharedVar("Clothes", "");
	end;
end;

-- A function to set a player's clothes data.
function playerMeta:SetClothesData(itemTable)
	local clothesItem = self:GetClothesItem();
	
	if (itemTable) then
		local model = Clockwork.class:GetAppropriateModel(self:Team(), self, true);
		
		if (!model) then
			if (clothesItem and itemTable != clothesItem) then
				clothesItem:OnChangeClothes(self, false);
			end;
			
			itemTable:OnChangeClothes(self, true);
			
			local clothesData = self:GetClothesData();
				clothesData.itemID = itemTable("itemID");
				clothesData.uniqueID = itemTable("uniqueID");
			self:NetworkClothesData();
		end;
	else
		local clothesData = self:GetClothesData();
			clothesData.itemID = nil;
			clothesData.uniqueID = nil;
		self:NetworkClothesData();
		
		if (clothesItem) then
			clothesItem:OnChangeClothes(self, false);
		end;
	end;
end;

-- A function to set a player's character data.
function playerMeta:SetCharacterData(key, value, bFromBase)
	local character = self:GetCharacter();
	
	if (!character) then
		return;
	end;
	
	if (bFromBase) then
		key = Clockwork:SetCamelCase(key, true);
		
		if (character[key] != nil) then
			character[key] = value;
		end;
	else
		character.data[key] = value;
	end;
end;

-- A function to get whether a player's character menu is reset.
function playerMeta:IsCharacterMenuReset()
	return self.cwCharMenuReset;
end;

-- A function to get the entity a player is holding.
function playerMeta:GetHoldingEntity()
	return self.cwIsHoldingEnt;
end;

playerMeta.GetName = playerMeta.Name;
playerMeta.Nick = playerMeta.Name;