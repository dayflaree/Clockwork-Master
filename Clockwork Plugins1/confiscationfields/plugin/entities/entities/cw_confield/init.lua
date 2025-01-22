--[[
	This script has been purchased for "Blt950's HL2RP & Clockwork plugins" from CoderHire.com
	© 2014 Blt950 do not share, re-distribute or modify
	without permission.
--]]

include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props_combine/weaponstripper.mdl");
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);

timer.Create( "stripper"..math.random(1,9999), 3, 0, function()
	for k, v in pairs(ents.GetAll()) do
	if v:IsPlayer() and (v:GetFaction() != FACTION_MPF and v:GetFaction() != FACTION_OTA) then
		if v:GetPos():Distance( self:GetPos() ) < 220 and (v:HasWeapon("cw_stunstick") or v:HasWeapon("weapon_rpg") or v:HasWeapon("weapon_shotgun") or v:HasWeapon("weapon_357") or v:HasWeapon("weapon_ar2") or v:HasWeapon("weapon_smg1") or v:HasWeapon("weapon_crossbow") or v:HasWeapon("weapon_frag") or v:HasWeapon("weapon_pistol")) then
			if v:HasWeapon("cw_stunstick") then
			v:DropWeapon("cw_stunstick")
			end

			if v:HasWeapon("weapon_rpg") then
			v:StripWeapon("weapon_rpg")
			end

			if v:HasWeapon("weapon_shotgun") then
			v:StripWeapon("weapon_shotgun")
			end

			if v:HasWeapon("weapon_357") then
			v:StripWeapon("weapon_357")
			end

			if v:HasWeapon("weapon_ar2") then
			v:StripWeapon("weapon_ar2")
			end

			if v:HasWeapon("weapon_smg1") then
			v:StripWeapon("weapon_smg1")
			end

			if v:HasWeapon("weapon_crossbow") then
			v:StripWeapon("weapon_crossbow")
			end

			if v:HasWeapon("weapon_frag") then
			v:StripWeapon("weapon_frag")
			end

			if v:HasWeapon("weapon_ak47") then
			v:StripWeapon("weapon_ak47")
			end

			if v:HasWeapon("weapon_alexd_gsh18") then
			v:StripWeapon("weapon_alexd_gsh18")
			end

			if v:HasWeapon("weapon_csniper") then
			v:StripWeapon("weapon_csniper")
			end

			if v:HasWeapon("rcs_famas") then
			v:StripWeapon("rcs_famas")
			end

			if v:HasWeapon("rcs_galil") then
			v:StripWeapon("rcs_galil")
			end

			if v:HasWeapon("rcs_m3") then
			v:StripWeapon("rcs_m3")
			end

			if v:HasWeapon("rcs_m4a1") then
			v:StripWeapon("rcs_m4a1")
			end

			if v:HasWeapon("rcs_p228") then
			v:StripWeapon("rcs_p228")
			end

			if v:HasWeapon("rcs_p90") then
			v:StripWeapon("rcs_p90")
			end

			if v:HasWeapon("rcs_scout") then
			v:StripWeapon("rcs_scout")
			end

			if v:HasWeapon("rcs_sg552") then
			v:StripWeapon("rcs_sg552")
			end

			if v:HasWeapon("rcs_spas12") then
			v:StripWeapon("rcs_spas12")
			end

			if v:HasWeapon("rcs_ump") then
			v:StripWeapon("rcs_ump")
			end

			if v:HasWeapon("rcs_usp") then
			v:StripWeapon("rcs_usp")
			end

			if v:HasWeapon("rcs_uspmatch") then
			v:StripWeapon("rcs_uspmatch")
			end

			if v:HasWeapon("weapon_csniper") then
			v:StripWeapon("weapon_csniper")
			end

			if v:HasWeapon("weapon_csniper") then
			v:StripWeapon("weapon_csniper")
			end

			if v:HasWeapon("weapon_pistol") then
			v:StripWeapon("weapon_pistol")
			end

			v:EmitSound("physics/concrete/concrete_impact_soft1.wav")
			v:EmitSound("npc/overwatch/cityvoice/fcitadel_confiscating.wav")
		end
	end
	end
end)

end

-- Called when a player attempts to use a tool.
function ENT:CanTool(player, trace, tool)
	return false;
end;
