local ITEM = {}
ITEM.Name = "beer"
ITEM.PrintName = "Beer"
ITEM.Description = "A refreshing beer."
ITEM.Model = "models/props_junk/GlassBottle01a.mdl"
ITEM.StockLevel = 5
ITEM.DefaultStockLevel = 5

local drinks = {}

function ITEM.Use(ply, self)
	if not drinks[ply:Nick()] then drinks[ply:Nick()] = 0 end
	drinks[ply:Nick()] = drinks[ply:Nick()] + 1
	if drinks[ply:Nick()] > 4 then
		ply:SendLua('chat.AddText(Color(15, 248, 5, 255), "Woah! Too many!")')
		ply:Drunk(30)
		drinks[ply:Nick()] = 0
	else
		ply:SendLua('chat.AddText(Color(15, 248, 5, 255), "Aaaahhh... but don\'t have too many!")')
	end
	self:Remove()
end

RegisterItem(ITEM)

local Player = FindMetaTable("Player")

function Player:Drunk(timeout)
	self:ConCommand("pp_motionblur 1")
	self:ConCommand("pp_motionblur_addalpha 0.05")
	self:ConCommand("pp_motionblur_delay 0.035")
	self:ConCommand("pp_motionblur_drawalpha 1.00")
	self:ConCommand("pp_dof 1")
	self:ConCommand("pp_dof_initlength 5")
	self:ConCommand("pp_dof_spacing 5")
	timer.Simple(timeout, function() self:ConCommand("pp_motionblur 0") self:ConCommand("pp_dof 0") end)
end