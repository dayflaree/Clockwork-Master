ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName		= ""
ENT.Author		= ""
ENT.Contact		= ""
ENT.Purpose		= ""
ENT.Instructions	= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

local META = FindMetaTable("Entity")
if !META then return end

function META:IsStructure()
	return string.find( self:GetClass(), "bldg_" )
end

META = nil