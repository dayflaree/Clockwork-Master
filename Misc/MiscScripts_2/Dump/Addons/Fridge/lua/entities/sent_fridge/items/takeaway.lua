local ITEM = {}
ITEM.Name = "takeaway"
ITEM.PrintName = "Takeaway"
ITEM.Description = "Chinese or Indian?"
ITEM.Model = "models/props_junk/garbage_takeoutcarton001a.mdl"
ITEM.StockLevel = 3
ITEM.DefaultStockLevel = 3

function ITEM.Use(ply, self)
	self:Remove()
end

RegisterItem(ITEM)