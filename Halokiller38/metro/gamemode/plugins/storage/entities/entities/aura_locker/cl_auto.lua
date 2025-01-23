--[[
Name: "cl_auto.lua".
Product: "Cider Two".
--]]

openAura:IncludePrefixed("sh_auto.lua")

-- Called when the entity should draw.
function ENT:Draw() self:DrawModel(); end;