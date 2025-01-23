include('shared.lua')

fridgeframe = nil
surface.CreateFont("coolvetica", 30, 400, true, false, "FTitle")
surface.CreateFont("coolvetica", 22, 400, true, false, "FItems")

function ENT:Draw()
	self:DrawModel()
	
	local pos = self:GetPos() + (self:GetForward() * 24.2) + (self:GetUp() * 77) + (self:GetRight() * 13)
	local ang = self:GetAngles()
	
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Up(), 90)
	
	cam.Start3D2D(pos, ang, 0.1)
		surface.SetDrawColor(0, 0, 0, 255)
		//surface.DrawRect(-120, -120, 240, 240)
		
		local sx, sy = -115, -120
		
		draw.SimpleText("Fridge!", "FTitle", sx, sy, Color(15, 248, 5, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		
		sx, sy = -100, -90
		local i = 0
		for k, ITEM in pairs(Items) do
			if ITEM.StockLevel > 0 then
				draw.SimpleText(ITEM.StockLevel .. " x " .. ITEM.PrintName .. " - " .. ITEM.Description, "FItems", sx, sy - i, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
				i = i - 18
			end
		end
	cam.End3D2D()
end

function ENT.Menu()
	if fridgeframe then
		if fridgeframe:IsVisible() then
			fridgeframe:Remove()
		end
	end
	local fridgeframe = vgui.Create("DFrame")
	fridgeframe:SetWide(120)
	fridgeframe:SetTall(210)
	fridgeframe:SetTitle("Fridge V2 Menu")
	fridgeframe:SetDraggable(true)
	fridgeframe:SetSizable(false)
	fridgeframe:Center()
	fridgeframe:SetDeleteOnClose(true)
	
	local fridgeitems = vgui.Create("DListView", fridgeframe) 
	fridgeitems:SetPos(10, 30) 
	fridgeitems:SetSize(100, 140)
	fridgeitems:SetMultiSelect(false) 
	fridgeitems:AddColumn("Item")
	
	for k, ITEM in pairs(Items) do
		if ITEM.StockLevel > 0 then
			local line = fridgeitems:AddLine(ITEM.PrintName)
			line.OnSelect = function()
				RunConsoleCommand("fridgeitem", ITEM.Name)
				ITEM.StockLevel = ITEM.StockLevel - 1
				fridgeframe:Remove()
			end
		end
	end
	
	if LocalPlayer():IsAdmin() then
		local fillbutton = vgui.Create("DButton", fridgeframe)
		fillbutton:SetPos(10, 180)
		fillbutton:SetSize(100, 20)
		fillbutton:SetText("Fill Fridge!")
		fillbutton.DoClick = function(fillbutton)
			RunConsoleCommand("fridgefill")
			fridgeframe:Remove()
		end
	end
	
	fridgeframe:MakePopup()
end
concommand.Add("fridgemenu", ENT.Menu)