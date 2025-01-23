local ITEM = {}
ITEM.Name = "milk"
ITEM.PrintName = "Milk"
ITEM.Description = "Original white stuff!"
ITEM.Model = "models/props_junk/garbage_milkcarton002a.mdl"
ITEM.StockLevel = 2
ITEM.DefaultStockLevel = 2

function ITEM.Use(ply, self)
	self:Remove()
end

RegisterItem(ITEM)