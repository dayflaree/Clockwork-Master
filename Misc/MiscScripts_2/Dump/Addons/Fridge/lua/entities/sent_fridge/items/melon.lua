local ITEM = {}
ITEM.Name = "melon"
ITEM.PrintName = "Melon"
ITEM.Description = "Just a watermel(ol)on!"
ITEM.Model = "models/props_junk/watermelon01.mdl"
ITEM.StockLevel = 2
ITEM.DefaultStockLevel = 2

function ITEM.Use(ply, self)
	util.BlastDamage(self, self, self:GetPos(), 150, 150)
	local effect = EffectData()
		effect:SetOrigin(self:GetPos())
		effect:SetScale(1)
	util.Effect("Explosion", effect)
	if GetConVar("sbox_godmode") == 1 and GetConVar("sbox_plpldamage") == 0 then
		ply:Kill()
	end
	self:Remove()
end

RegisterItem(ITEM)