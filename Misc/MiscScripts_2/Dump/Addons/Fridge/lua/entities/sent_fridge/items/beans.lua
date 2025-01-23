local ITEM = {}
ITEM.Name = "beans"
ITEM.PrintName = "Beans"
ITEM.Description = "Heinz."
ITEM.Model = "models/props_junk/garbage_metalcan001a.mdl"
ITEM.StockLevel = 2
ITEM.DefaultStockLevel = 2

function ITEM.Use(ply, self)
	ply:SendLua('chat.AddText(Color(15, 248, 5, 255), "Ewwww... Cold!")')
	self:Remove()
end

RegisterItem(ITEM)