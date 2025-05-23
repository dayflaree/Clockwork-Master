--[[
	Free Clockwork!
--]]

Clockwork.limb = Clockwork:NewLibrary("Limb");
Clockwork.limb.bones = {
	["ValveBiped.Bip01_R_UpperArm"] = HITGROUP_RIGHTARM,
	["ValveBiped.Bip01_R_Forearm"] = HITGROUP_RIGHTARM,
	["ValveBiped.Bip01_L_UpperArm"] = HITGROUP_LEFTARM,
	["ValveBiped.Bip01_L_Forearm"] = HITGROUP_LEFTARM,
	["ValveBiped.Bip01_R_Thigh"] = HITGROUP_RIGHTLEG,
	["ValveBiped.Bip01_R_Calf"] = HITGROUP_RIGHTLEG,
	["ValveBiped.Bip01_R_Foot"] = HITGROUP_RIGHTLEG,
	["ValveBiped.Bip01_R_Hand"] = HITGROUP_RIGHTARM,
	["ValveBiped.Bip01_L_Thigh"] = HITGROUP_LEFTLEG,
	["ValveBiped.Bip01_L_Calf"] = HITGROUP_LEFTLEG,
	["ValveBiped.Bip01_L_Foot"] = HITGROUP_LEFTLEG,
	["ValveBiped.Bip01_L_Hand"] = HITGROUP_LEFTARM,
	["ValveBiped.Bip01_Pelvis"] = HITGROUP_STOMACH,
	["ValveBiped.Bip01_Spine2"] = HITGROUP_CHEST,
	["ValveBiped.Bip01_Spine1"] = HITGROUP_CHEST,
	["ValveBiped.Bip01_Head1"] = HITGROUP_HEAD,
	["ValveBiped.Bip01_Neck1"] = HITGROUP_HEAD
};

-- A function to convert a bone to a hit group.
function Clockwork.limb:BoneToHitGroup(bone)
	return self.bones[bone] or HITGROUP_CHEST;
end;

-- A function to get whether limb damage is active.
function Clockwork.limb:IsActive()
	return Clockwork.config:Get("limb_damage_system"):Get();
end;

if (SERVER) then
	function Clockwork.limb:TakeDamage(player, hitGroup, damage)
		local newDamage = math.Clamp(math.ceil(damage*2), 0, 100);
		local limbData = player:GetCharacterData("LimbData");
		
		if (limbData) then
			limbData[hitGroup] = math.min((limbData[hitGroup] or 0) + newDamage, 100);
			
			umsg.Start("cwTakeLimbDamage", player);
				umsg.Short(hitGroup);
				umsg.Short(newDamage);
			umsg.End();
			
			Clockwork.plugin:Call("PlayerLimbTakeDamage", player, hitGroup, newDamage);
		end;
	end;
	
	-- A function to heal a player's body.
	function Clockwork.limb:HealBody(player, amount)
		local limbData = player:GetCharacterData("LimbData");
		
		if (limbData) then
			for k, v in pairs(limbData) do
				self:HealDamage(player, k, amount);
			end;
		end;
	end;
	
	-- A function to heal a player's limb damage.
	function Clockwork.limb:HealDamage(player, hitGroup, amount)
		local newAmount = math.ceil(amount);
		local limbData = player:GetCharacterData("LimbData");
		
		if (limbData and limbData[hitGroup]) then
			limbData[hitGroup] = math.max(limbData[hitGroup] - newAmount, 0);
			
			if (limbData[hitGroup] == 0) then
				limbData[hitGroup] = nil;
			end;
			
			umsg.Start("cwHealLimbDamage", player);
				umsg.Short(hitGroup);
				umsg.Short(newAmount);
			umsg.End();
			
			Clockwork.plugin:Call("PlayerLimbDamageHealed", player, hitGroup, newAmount);
		end;
	end;
	
	-- A function to reset a player's limb damage.
	function Clockwork.limb:ResetDamage(player)
		player:SetCharacterData("LimbData", {});
		
		umsg.Start("cwResetLimbDamage", player);
		umsg.End();
		
		Clockwork.plugin:Call("PlayerLimbDamageReset", player);
	end;
	
	-- A function to get whether any of a player's limbs are damaged.
	function Clockwork.limb:IsAnyDamaged(player)
		local limbData = player:GetCharacterData("LimbData");
		
		if (limbData and table.Count(limbData) > 0) then
			return true;
		else
			return false;
		end;
	end
	
	-- A function to get a player's limb health.
	function Clockwork.limb:GetHealth(player, hitGroup, asFraction)
		return 100 - self:GetDamage(player, hitGroup, asFraction);
	end;
	
	-- A function to get a player's limb damage.
	function Clockwork.limb:GetDamage(player, hitGroup, asFraction)
		if (!Clockwork.config:Get("limb_damage_system"):Get()) then
			return 0;
		end;
		
		local limbData = player:GetCharacterData("LimbData");
		
		if (limbData and limbData[hitGroup]) then
			if (asFraction) then
				return limbData[hitGroup] / 100;
			else
				return limbData[hitGroup];
			end;
		end;
		
		return 0;
	end;
else
	Clockwork.limb.bodyTexture = surface.GetTextureID("Clockwork/limbs/body");
	Clockwork.limb.stored = {};
	Clockwork.limb.hitGroups = {
		[HITGROUP_RIGHTARM] = surface.GetTextureID("Clockwork/limbs/rarm"),
		[HITGROUP_RIGHTLEG] = surface.GetTextureID("Clockwork/limbs/rleg"),
		[HITGROUP_LEFTARM] = surface.GetTextureID("Clockwork/limbs/larm"),
		[HITGROUP_LEFTLEG] = surface.GetTextureID("Clockwork/limbs/lleg"),
		[HITGROUP_STOMACH] = surface.GetTextureID("Clockwork/limbs/stomach"),
		[HITGROUP_CHEST] = surface.GetTextureID("Clockwork/limbs/chest"),
		[HITGROUP_HEAD] = surface.GetTextureID("Clockwork/limbs/head")
	};
	Clockwork.limb.names = {
		[HITGROUP_RIGHTARM] = "Right Arm",
		[HITGROUP_RIGHTLEG] = "Right Leg",
		[HITGROUP_LEFTARM] = "Left Arm",
		[HITGROUP_LEFTLEG] = "Left Leg",
		[HITGROUP_STOMACH] = "Stomach",
		[HITGROUP_CHEST] = "Chest",
		[HITGROUP_HEAD] = "Head"
	};
	
	-- A function to get a limb's texture.
	function Clockwork.limb:GetTexture(hitGroup)
		if (hitGroup == "body") then
			return self.bodyTexture;
		else
			return self.hitGroups[hitGroup];
		end;
	end;
	
	-- A function to get a limb's name.
	function Clockwork.limb:GetName(hitGroup)
		return self.names[hitGroup] or "Generic";
	end;
	
	-- A function to get a limb color.
	function Clockwork.limb:GetColor(health)
		if (health > 99) then
			return Color(166, 243, 76, 255);
		elseif (health > 50) then
			return Color(233, 225, 94, 255);
		elseif (health > 25) then
			return Color(233, 173, 94, 255);
		else
			return Color(222, 57, 57, 255);
		end;
	end;
	
	-- A function to get the local player's limb health.
	function Clockwork.limb:GetHealth(hitGroup, asFraction)
		return 100 - self:GetDamage(hitGroup, asFraction);
	end;
	
	-- A function to get the local player's limb damage.
	function Clockwork.limb:GetDamage(hitGroup, asFraction)
		if (!Clockwork.config:Get("limb_damage_system"):Get()) then
			return 0;
		end;
		
		if (self.stored[hitGroup]) then
			if (asFraction) then
				return self.stored[hitGroup] / 100;
			else
				return self.stored[hitGroup];
			end;
		end;
		
		return 0;
	end;
	
	-- A function to get whether any of the local player's limbs are damaged.
	function Clockwork.limb:IsAnyDamaged()
		return table.Count(self.stored) > 0;
	end;
	
	Clockwork:HookDataStream("ReceiveLimbDamage", function(data)
		Clockwork.limb.stored = data;
		Clockwork.plugin:Call("PlayerLimbDamageReceived");
	end);

	usermessage.Hook("cwResetLimbDamage", function(msg)
		Clockwork.limb.stored = {};
		Clockwork.plugin:Call("PlayerLimbDamageReset");
	end);
	
	usermessage.Hook("cwTakeLimbDamage", function(msg)
		local hitGroup = msg:ReadShort();
		local damage = msg:ReadShort();
		
		Clockwork.limb.stored[hitGroup] = math.min((Clockwork.limb.stored[hitGroup] or 0) + damage, 100);
		Clockwork.plugin:Call("PlayerLimbTakeDamage", hitGroup, damage);
	end);
	
	usermessage.Hook("cwHealLimbDamage", function(msg)
		local hitGroup = msg:ReadShort();
		local amount = msg:ReadShort();
		
		if (Clockwork.limb.stored[hitGroup]) then
			Clockwork.limb.stored[hitGroup] = math.max(Clockwork.limb.stored[hitGroup] - amount, 0);
			
			if (Clockwork.limb.stored[hitGroup] == 100) then
				Clockwork.limb.stored[hitGroup] = nil;
			end;
			
			Clockwork.plugin:Call("PlayerLimbDamageHealed", hitGroup, amount);
		end;
	end);
end;