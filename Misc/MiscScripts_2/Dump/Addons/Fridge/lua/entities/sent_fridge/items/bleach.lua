local ITEM = {}
ITEM.Name = "bleach"
ITEM.PrintName = "Bleach"
ITEM.Description = "Why is this in here?"
ITEM.Model = "models/props_junk/garbage_plasticbottle001a.mdl"
ITEM.StockLevel = 1
ITEM.DefaultStockLevel = 1

function ITEM.Use(ply, self)
	timer.Simple(1, function() ply:SendLua('chat.AddText(Color(15, 248, 5, 255), "Hmm, that doesn\'t feel too good...")') end)
	timer.Simple(10, function() ply:SendLua('chat.AddText(Color(15, 248, 5, 255), "My belly feels funny!")') end)
	timer.Simple(20, function() ply:SendLua('chat.AddText(Color(15, 248, 5, 255), "OH GOD!!!")') end)
	timer.Simple(25, function() ply:SendLua('chat.AddText(Color(15, 248, 5, 255), "THE LIGHT, IT BURNS MY EYES.")') ply:Kill() end)
	self:Remove()
end

RegisterItem(ITEM)