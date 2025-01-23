local ITEM = {}
ITEM.Name = "soda"
ITEM.PrintName = "Soda"
ITEM.Description = "Coke or Pepsi?"
ITEM.Model = "models/props_junk/PopCan01a.mdl"
ITEM.StockLevel = 10
ITEM.DefaultStockLevel = 10

function ITEM.Use(ply, self)
	self:Remove()
end

RegisterItem(ITEM)