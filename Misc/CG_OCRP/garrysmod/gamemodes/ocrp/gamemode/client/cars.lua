
OCRP_VehicleGas = 0

function GetCar( umsg )
	table.insert(OCRP_MyCars, {car = umsg:ReadString(), skin = umsg:ReadShort()})
end
usermessage.Hook("ocrp_single_car", GetCar)

function GetCars( umsg )
	table.insert(OCRP_MyCars, {car = umsg:ReadString(), skin = umsg:ReadShort()})
end
usermessage.Hook("ocrp_allcars", GetCar)
	
	
function CL_CarMenu( um )
	local CAR = um:ReadString()
	
	local CarMenuFrame = vgui.Create("DFrame")
	CarMenuFrame:SetTall( 160 )
	CarMenuFrame:SetWide( 450 )
	CarMenuFrame:SetTitle( "Purchasing a ".. GAMEMODE.OCRP_Cars[CAR].Name ..".." )
	CarMenuFrame:Center()
	CarMenuFrame.Paint = function()
								draw.RoundedBox(8,1,1,CarMenuFrame:GetWide()-2,CarMenuFrame:GetTall()-2,OCRP_Options.Color)
							end
	CarMenuFrame:MakePopup()
	
	local CarTopLeft = vgui.Create( "DPanel", CarMenuFrame )
	CarTopLeft:SetTall( 130 )
	CarTopLeft:SetWide( 130 )
	CarTopLeft:SetPos( 5, 25 )
	CarTopLeft.Paint = function()
							draw.RoundedBox(8,0,0,CarTopLeft:GetWide(),CarTopLeft:GetTall(),Color(60,60,60,230))
						end
						
	local SpeedLab = vgui.Create( "DLabel", CarTopLeft )
	SpeedLab:SetFont( "UIBold" )
	SpeedLab:SetText( "Speed" )
	SpeedLab:SetColor( Color( 255, 255, 255, 255 ) )
	SpeedLab:SetPos( 6, 5 )
	SpeedLab:SizeToContents()
	
	local SpeedBar = vgui.Create( "OCRPProgressBar", CarTopLeft )
	SpeedBar:SetTall( 15 )
	SpeedBar:SetWide( 120 )
	SpeedBar:SetPos( 5, 17 )
	SpeedBar:SetMin( 0 )
	SpeedBar:SetMax( 200 )
	SpeedBar:SetValue( 120 )
	SpeedBar:SetValueText( GAMEMODE.OCRP_Cars[CAR].Speed .." MPH" )
	
	local StrengthLab = vgui.Create( "DLabel", CarTopLeft )
	StrengthLab:SetFont( "UIBold" )
	StrengthLab:SetText( "Strength" )
	StrengthLab:SetColor( Color( 255, 255, 255, 255 ) )
	StrengthLab:SetPos( 6, 35 )
	StrengthLab:SizeToContents()
	
	local StrengthBar = vgui.Create( "OCRPProgressBar", CarTopLeft )
	StrengthBar:SetTall( 15 )
	StrengthBar:SetWide( 120 )
	StrengthBar:SetPos( 5, 47 )
	StrengthBar:SetMin( 0 )
	StrengthBar:SetMax( 200 )
	StrengthBar:SetValue( 50 )
	StrengthBar:SetValueText( GAMEMODE.OCRP_Cars[CAR].StrengthText )
	
	local SeatsLab = vgui.Create( "DLabel", CarTopLeft )
	SeatsLab:SetFont( "UIBold" )
	SeatsLab:SetText( "Seats" )
	SeatsLab:SetColor( Color( 255, 255, 255, 255 ) )
	SeatsLab:SetPos( 6, 65 )
	SeatsLab:SizeToContents()
	
	local SeatsBar = vgui.Create( "OCRPProgressBar", CarTopLeft )
	SeatsBar:SetTall( 15 )
	SeatsBar:SetWide( 120 )
	SeatsBar:SetPos( 5, 77 )
	SeatsBar:SetMin( 0 )
	SeatsBar:SetMax( 5 )
	SeatsBar:SetValue( 4 )
	SeatsBar:SetValueText( GAMEMODE.OCRP_Cars[CAR].SeatsNum )
	
	local SkinPriceLab = vgui.Create( "DLabel", CarTopLeft )
	SkinPriceLab:SetFont( "UIBold" )
	SkinPriceLab:SetText( "Respray Cost" )
	SkinPriceLab:SetColor( Color( 255, 255, 255, 255 ) )
	SkinPriceLab:SetPos( 6, 95 )
	SkinPriceLab:SizeToContents()
	
	local SkinPriceBar = vgui.Create( "OCRPProgressBar", CarTopLeft )
	SkinPriceBar:SetTall( 15 )
	SkinPriceBar:SetWide( 120 )
	SkinPriceBar:SetPos( 5, 107 )
	SkinPriceBar:SetMin( 0 )
	SkinPriceBar:SetMax( 5 )
	SkinPriceBar:SetValue( 3 )
	SkinPriceBar:SetValueText( "$".. GAMEMODE.OCRP_Cars[CAR].Skin_Price )
	
	local CarTopRight = vgui.Create( "DPanel", CarMenuFrame )
	CarTopRight:SetTall( 130 )
	CarTopRight:SetWide( 305 )
	CarTopRight:SetPos( 140, 25 )
	CarTopRight.Paint = function()
							draw.RoundedBox(8,0,0,CarTopRight:GetWide(),CarTopRight:GetTall(),Color(60,60,60,230))
						end
						
	local CarName = vgui.Create( "DLabel", CarTopRight )
	CarName:SetFont( "TargetID" )
	CarName:SetText( GAMEMODE.OCRP_Cars[CAR].Name .." - $".. GAMEMODE.OCRP_Cars[CAR].Price )
	CarName:SetPos( 5, 5 )
	CarName:SetColor(Color(255,255,255,255))
	CarName:SizeToContents()
	
	local CarDesc = vgui.Create( "DLabel", CarTopRight )
	CarDesc:SetTall( 30 )
	CarDesc:SetWide( 295 )
	CarDesc:SetPos( 5, 29 )
	CarDesc:SetFont( "TargetIDSmall" )
	CarDesc:SetText( GAMEMODE.OCRP_Cars[CAR].Desc )
	CarDesc:SetWrap( true )
	
	local CarBuy = vgui.Create( "DButton", CarTopRight )
	CarBuy:SetTall( 20 )
	CarBuy:SetWide( 295 )
	CarBuy:SetText( " " )
	CarBuy:SetPos( 5, 83 )
	CarBuy.Paint = function()
							draw.RoundedBox(8,0,0,CarBuy:GetWide(),CarBuy:GetTall(),Color( 60, 60, 60, 155 ))
							draw.RoundedBox(8,1,1,CarBuy:GetWide()-2,CarBuy:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
										
							local struc = {}
							struc.pos = {}
							struc.pos[1] = 147.5 -- x pos
							struc.pos[2] = 10 -- y pos
							struc.color = Color(255,255,255,255) -- Red
							struc.text = "Buy" -- Text
							struc.font = "UIBold" -- Font
							struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
							struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
							draw.Text( struc )
						end
	CarBuy.DoClick = function() RunConsoleCommand("OCRP_BuyCar", CAR) end
	
	local CarNo = vgui.Create( "DButton", CarTopRight )
	CarNo:SetTall( 20 )
	CarNo:SetWide( 295 )
	CarNo:SetText( " " )
	CarNo:SetPos( 5, 105 )
	CarNo.Paint = function()
							draw.RoundedBox(8,0,0,CarNo:GetWide(),CarNo:GetTall(),Color( 60, 60, 60, 155 ))
							draw.RoundedBox(8,1,1,CarNo:GetWide()-2,CarNo:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
										
							local struc = {}
							struc.pos = {}
							struc.pos[1] = 147.5 -- x pos
							struc.pos[2] = 10 -- y pos
							struc.color = Color(255,255,255,255) -- Red
							struc.text = "I can't make my mind up." -- Text
							struc.font = "UIBold" -- Font
							struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
							struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
							draw.Text( struc )
						end
	CarNo.DoClick = function() CarMenuFrame:Close() end 
						
	
end
usermessage.Hook("store_buycar", CL_CarMenu)

function CLA_CarDealer(um)
	local CarDealer_Frame = vgui.Create( "DFrame" )
	CarDealer_Frame:SetSize( 363, 500 )
	CarDealer_Frame:SetTitle( "" )
	CarDealer_Frame:Center()
	CarDealer_Frame.Paint = function()
								draw.RoundedBox(8,1,1,CarDealer_Frame:GetWide()-2,CarDealer_Frame:GetTall()-2,OCRP_Options.Color)	
							end
	CarDealer_Frame:MakePopup()
	
	local CDPanel = vgui.Create( "DPanel", CarDealer_Frame )
	CDPanel:SetTall( 85 )
	CDPanel:SetWide( 343 )
	CDPanel:SetPos( 10, 10 )
	CDPanel.Paint = function()
						draw.RoundedBox(7,0,0,CDPanel:GetWide(),20,Color(60,60,60,240))	
						draw.RoundedBox(8,0,25,CDPanel:GetWide(),60,Color(60,60,60,240))							
					end
	surface.SetFont( "TargetIDSmall" )
	local x, y = surface.GetTextSize( "Welcome to the Car Dealer." )
	
	local CDWelcome = vgui.Create( "DLabel", CDPanel )
	CDWelcome:SetPos( ( CDPanel:GetWide() / 2 ) - ( x / 2 ), 3 )
	CDWelcome:SetColor( Color( 255, 255, 255, 255 ) )
	CDWelcome:SetText( "Welcome to the Car Dealer." )
	CDWelcome:SetFont( "TargetIDSmall" )
	CDWelcome:SizeToContents()
	
	local numcars = #OCRP_MyCars or 0
	local totalcars = table.Count(GAMEMODE.OCRP_Cars) or 0
	
	local CDStatsLabel = vgui.Create( "DLabel", CDPanel )
	CDStatsLabel:SetPos( 10, 29 )
	CDStatsLabel:SetColor( Color( 255, 255, 255, 255 ) )
	CDStatsLabel:SetText( "You have ".. numcars .." cars, there is ".. totalcars .." cars in total.\nIn your wallet you have $".. LocalPlayer().Wallet or 0 .." and in your bank you have $".. LocalPlayer().Bank )
	CDStatsLabel:SetFont( "TargetIDSmall" )
	CDStatsLabel:SizeToContents()
	
	local CDListPanel = vgui.Create( "DPanelList", CarDealer_Frame )
	CDListPanel:SetTall( 385 )
	CDListPanel:SetWide( 343 )
	CDListPanel:SetPos( 10, 100 )
	CDListPanel:EnableVerticalScrollbar( true )
	
	for k, v in pairs( GAMEMODE.OCRP_Cars ) do
		if v.Name then
			local CarDealerCar_List = vgui.Create("DPanelList", CarDealer_List)
			CarDealerCar_List:SetTall( 70 )
			CarDealerCar_List:SetWide( 343 )
			CarDealerCar_List:SetPos( 0, 0 )
			CarDealerCar_List:SetSpacing( 5 )
			CarDealerCar_List.Paint = function()
											draw.RoundedBox(8,0,0,CarDealerCar_List:GetWide(),CarDealerCar_List:GetTall(),Color( 20, 20, 20, 155 ))
										end
			//CarDealerCar_List:SetToolTip( "Name: ".. v.Name .."\nHealth: ".. v.Health .."\nGas Tank Size: ".. v.GasTank .."\nStrength: ".. v.StrengthText .."\nSkin Price: ".. v.Skin_Price )
										
			if type(v.Model) == "table" then
				mdl = v.Model[1]
			else
				mdl = v.Model
			end
			
			local CDSpawnIcon = vgui.Create( "SpawnIcon", CarDealerCar_List )
			CDSpawnIcon:SetSize( 70, 70 )
			CDSpawnIcon:SetPos( 3, 3 )
			CDSpawnIcon:SetModel( mdl )
			CDSpawnIcon.OnMousePressed = function()
											RunConsoleCommand("OCRP_BuyCar", v.OtherName) 
											CarDealer_Frame:Close()
										end
					
			surface.SetFont( "TargetID" )
			local x, y = surface.GetTextSize( v.Name )
			local CDCarName = vgui.Create( "DLabel", CarDealerCar_List )
			CDCarName:SetPos( 73, 3 )
			CDCarName:SetFont( "TargetID" )
			CDCarName:SetColor( Color( 255, 255, 255, 255 ) )
			CDCarName:SetText( v.Name .."\nThis car's speed is about ".. v.Speed .." MPH." )
			CDCarName:SizeToContents()
			
			if LocalPlayer().Bank >= v.Price then
				local CDCarPrice = vgui.Create( "DLabel", CarDealerCar_List )
				CDCarPrice:SetPos( 76 + x, 3 )
				CDCarPrice:SetFont( "TargetID" )
				CDCarPrice:SetColor( Color(0,255,0,255) )
				CDCarPrice:SetText( "$".. v.Price )
				CDCarPrice:SizeToContents()
			else
				local CDCarPrice = vgui.Create( "DLabel", CarDealerCar_List )
				CDCarPrice:SetPos( 76 + x, 3 )
				CDCarPrice:SetFont( "TargetID" )
				CDCarPrice:SetColor( Color(255,0,0,255) )
				CDCarPrice:SetText( "$".. v.Price )
				CDCarPrice:SizeToContents()
			end
			
			local CDBuyButton = vgui.Create("DButton")
			CDBuyButton:SetParent(CarDealerCar_List)
			CDBuyButton:SetPos(73,CDCarName:GetTall() + 6)
			CDBuyButton:SetSize(CDCarName:GetWide(),15)
			CDBuyButton:SetText("")
			CDBuyButton.Paint = function()
											draw.RoundedBox(4,0,0,CDBuyButton:GetWide(),CDBuyButton:GetTall(),Color( 60, 60, 60, 155 ))
											draw.RoundedBox(4,1,1,CDBuyButton:GetWide()-2,CDBuyButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
											
											local struc = {}
											struc.pos = {}
											struc.pos[1] = CDCarName:GetWide() / 2 -- x pos
											struc.pos[2] = 7 -- y pos
											struc.color = Color(255,255,255,255) -- Red
											struc.text = "Purchase" -- Text
											struc.font = "UIBold" -- Font
											struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
											struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
											draw.Text( struc )
										end
			CDBuyButton.DoClick = function(CDBuyButton) RunConsoleCommand("OCRP_BuyCar", v.OtherName) CarDealer_Frame:Close() end	
			
			CDListPanel:AddItem( CarDealerCar_List )
		end
	end
		
	
	/*local CarDealer_Frame = vgui.Create("DFrame")
	CarDealer_Frame:SetTall( 500 )
	CarDealer_Frame:SetWide( 400 )
	CarDealer_Frame:SetTitle( "Car Dealer" )
	CarDealer_Frame:Center()
	CarDealer_Frame.Paint = function()
								draw.RoundedBox(8,1,1,CarDealer_Frame:GetWide()-2,CarDealer_Frame:GetTall()-2,OCRP_Options.Color)
							end
	CarDealer_Frame:MakePopup()
	CarDealer_Frame:ShowCloseButton(false)
	
	local CarDealer_Exit = vgui.Create("DButton", CarDealer_Frame)	
	CarDealer_Exit:SetSize(20,20)
	CarDealer_Exit:SetPos(375,5)
	CarDealer_Exit:SetText("")
	CarDealer_Exit.Paint = function()
										surface.SetMaterial(OC_Exit)
										surface.SetDrawColor(255,255,255,255)
										surface.DrawTexturedRect(0,0,CarDealer_Exit:GetWide(),CarDealer_Exit:GetTall())
									end
	CarDealer_Exit.DoClick = function()
								CarDealer_Frame:Remove()
							end
	
	local CarDealer_List = vgui.Create("DPanelList", CarDealer_Frame)
	CarDealer_List:SetTall( 460 )
	CarDealer_List:SetWide( 380 )
	CarDealer_List:SetPos( 10, 30 )
	CarDealer_List:EnableVerticalScrollbar( true )
	
	local Strength
	for k, v in pairs(GAMEMODE.OCRP_Cars) do
		if k != "Police" && k != "Ambo" then
			if v.Health <= 50 then
				Strength = "Very Weak"
			elseif v.Health <= 75 then
				Strength = "Weak"
			elseif v.Health <= 100 then
				Strength = "Average"
			elseif v.Health <= 125 then
				Strength = "Strong"
			else
				Strength = "Very Strong"
			end
			
			--Dumb, but was quick to do.
			if v.dj == "true" and LocalPlayer():IsDJ() then
				local CarDealerCar_List = vgui.Create("DPanelList", CarDealer_List)
				CarDealerCar_List:SetTall( 112 )
				CarDealerCar_List:SetWide( 380 )
				CarDealerCar_List:SetPos( 0, 0 )
				CarDealerCar_List:SetSpacing( 5 )
				CarDealerCar_List.Paint = function()
											draw.RoundedBox(8,0,0,CarDealerCar_List:GetWide(),CarDealerCar_List:GetTall(),Color( 60, 60, 60, 155 ))
											end
											
				local Car_Name = vgui.Create("DLabel")
				Car_Name:SetColor(Color(255,255,255,255))
				Car_Name:SetFont("Trebuchet22")
				Car_Name:SetText("Name: ".. v.Name)
				Car_Name:SizeToContents()
				Car_Name:SetParent(CarDealerCar_List)
				Car_Name:SetPos(10, 10)
				
				local Car_Health = vgui.Create("DLabel")
				Car_Health:SetColor(Color(255,255,255,255))
				Car_Health:SetFont("Trebuchet22")
				Car_Health:SetText("Strength: ".. Strength)
				Car_Health:SizeToContents()
				Car_Health:SetParent(CarDealerCar_List)
				Car_Health:SetPos(10, 35)
				
				local Car_Price = vgui.Create("DLabel")
				Car_Price:SetColor(Color(255,255,255,255))
				Car_Price:SetFont("Trebuchet22")
				Car_Price:SetText("Price: $".. v.Price)
				Car_Price:SizeToContents()
				Car_Price:SetParent(CarDealerCar_List)
				Car_Price:SetPos(10, 58)
				
				local Car_Name = vgui.Create("DLabel")
				Car_Name:SetColor(Color(255,255,255,255))
				Car_Name:SetFont("Trebuchet22")
				Car_Name:SetText("Seats: ".. v.SeatsNum)
				Car_Name:SizeToContents()
				Car_Name:SetParent(CarDealerCar_List)
				Car_Name:SetPos(10, 80)
				
				local BuyButton = vgui.Create("DButton", CarDealerCar_List)
				BuyButton:SetPos( 150, 72)
				BuyButton:SetText( " " )
				BuyButton:SetTall( 30 )
				BuyButton:SetWide( 220 )
				BuyButton.Paint = function()
											draw.RoundedBox(8,0,0,BuyButton:GetWide(),BuyButton:GetTall(),Color( 60, 60, 60, 155 ))
											draw.RoundedBox(8,1,1,BuyButton:GetWide()-2,BuyButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
														
											local struc = {}
											struc.pos = {}
											struc.pos[1] = 100 -- x pos
											struc.pos[2] = 15 -- y pos
											struc.color = Color(255,255,255,255) -- Red
											struc.text = "Click to buy." -- Text
											struc.font = "UIBold" -- Font
											struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
											struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
											draw.Text( struc )
										end
				BuyButton.DoClick = function(BuyButton) RunConsoleCommand("OCRP_BuyCar", v.OtherName) CarDealer_Frame:Close() end	
				
				CarDealer_List:AddItem(CarDealerCar_List)
			end
			if !v.dj then
			
				local CarDealerCar_List = vgui.Create("DPanelList", CarDealer_List)
				CarDealerCar_List:SetTall( 112 )
				CarDealerCar_List:SetWide( 380 )
				CarDealerCar_List:SetPos( 0, 0 )
				CarDealerCar_List:SetSpacing( 5 )
				CarDealerCar_List.Paint = function()
											draw.RoundedBox(8,0,0,CarDealerCar_List:GetWide(),CarDealerCar_List:GetTall(),Color( 60, 60, 60, 155 ))
											end
											
				local Car_Name = vgui.Create("DLabel")
				Car_Name:SetColor(Color(255,255,255,255))
				Car_Name:SetFont("Trebuchet22")
				Car_Name:SetText("Name: ".. v.Name)
				Car_Name:SizeToContents()
				Car_Name:SetParent(CarDealerCar_List)
				Car_Name:SetPos(10, 10)
				
				local Car_Health = vgui.Create("DLabel")
				Car_Health:SetColor(Color(255,255,255,255))
				Car_Health:SetFont("Trebuchet22")
				Car_Health:SetText("Strength: ".. Strength)
				Car_Health:SizeToContents()
				Car_Health:SetParent(CarDealerCar_List)
				Car_Health:SetPos(10, 35)
				
				local Car_Price = vgui.Create("DLabel")
				Car_Price:SetColor(Color(255,255,255,255))
				Car_Price:SetFont("Trebuchet22")
				Car_Price:SetText("Price: $".. v.Price)
				Car_Price:SizeToContents()
				Car_Price:SetParent(CarDealerCar_List)
				Car_Price:SetPos(10, 58)
				
				local Car_Name = vgui.Create("DLabel")
				Car_Name:SetColor(Color(255,255,255,255))
				Car_Name:SetFont("Trebuchet22")
				Car_Name:SetText("Seats: ".. v.SeatsNum)
				Car_Name:SizeToContents()
				Car_Name:SetParent(CarDealerCar_List)
				Car_Name:SetPos(10, 80)
				
				local BuyButton = vgui.Create("DButton", CarDealerCar_List)
				BuyButton:SetPos( 150, 72)
				BuyButton:SetText( " " )
				BuyButton:SetTall( 30 )
				BuyButton:SetWide( 220 )
				BuyButton.Paint = function()
											draw.RoundedBox(8,0,0,BuyButton:GetWide(),BuyButton:GetTall(),Color( 60, 60, 60, 155 ))
											draw.RoundedBox(8,1,1,BuyButton:GetWide()-2,BuyButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
														
											local struc = {}
											struc.pos = {}
											struc.pos[1] = 100 -- x pos
											struc.pos[2] = 15 -- y pos
											struc.color = Color(255,255,255,255) -- Red
											struc.text = "Click to buy." -- Text
											struc.font = "UIBold" -- Font
											struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
											struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
											draw.Text( struc )
										end
				BuyButton.DoClick = function(BuyButton) RunConsoleCommand("OCRP_BuyCar", v.OtherName) CarDealer_Frame:Close() end	
				
				CarDealer_List:AddItem(CarDealerCar_List)
			end
		end
	end*/
	
end
usermessage.Hook( "CL_CarDealer", CLA_CarDealer )

function CLA_Garage(um)
	local CarGarage_Frame = vgui.Create( "DFrame" )
	CarGarage_Frame:SetSize( 363, 500 )
	CarGarage_Frame:SetTitle( "" )
	CarGarage_Frame:Center()
	CarGarage_Frame.Paint = function()
								draw.RoundedBox(8,1,1,CarGarage_Frame:GetWide()-2,CarGarage_Frame:GetTall()-2,OCRP_Options.Color)	
							end
	CarGarage_Frame:MakePopup()
	
	local CDPanel = vgui.Create( "DPanel", CarGarage_Frame )
	CDPanel:SetTall( 85 )
	CDPanel:SetWide( 343 )
	CDPanel:SetPos( 10, 10 )
	CDPanel.Paint = function()
						draw.RoundedBox(7,0,0,CDPanel:GetWide(),20,Color(60,60,60,240))	
						draw.RoundedBox(8,0,25,CDPanel:GetWide(),60,Color(60,60,60,240))							
					end
	surface.SetFont( "TargetIDSmall" )
	local x, y = surface.GetTextSize( "Welcome to the Car Dealer." )
	
	local CDWelcome = vgui.Create( "DLabel", CDPanel )
	CDWelcome:SetPos( ( CDPanel:GetWide() / 2 ) - ( x / 2 ), 3 )
	CDWelcome:SetColor( Color( 255, 255, 255, 255 ) )
	CDWelcome:SetText( "Welcome to the Car Garage." )
	CDWelcome:SetFont( "TargetIDSmall" )
	CDWelcome:SizeToContents()
	
	local numcars = #OCRP_MyCars or 0
	local totalcars = table.Count(GAMEMODE.OCRP_Cars) or 0
	
	local CDStatsLabel = vgui.Create( "DLabel", CDPanel )
	CDStatsLabel:SetPos( 10, 29 )
	CDStatsLabel:SetColor( Color( 255, 255, 255, 255 ) )
	CDStatsLabel:SetText( "You have ".. numcars .." cars, there is ".. totalcars .." cars in total.\nIn your wallet you have $".. LocalPlayer().Wallet or 0 .." and in your bank you have $".. LocalPlayer().Bank )
	CDStatsLabel:SetFont( "TargetIDSmall" )
	CDStatsLabel:SizeToContents()
	
	local CDListPanel = vgui.Create( "DPanelList", CarGarage_Frame )
	CDListPanel:SetTall( 385 )
	CDListPanel:SetWide( 343 )
	CDListPanel:SetPos( 10, 100 )
	CDListPanel:EnableVerticalScrollbar( true )
	
	for k, v in pairs( OCRP_MyCars ) do
		if v.car then
			local CarDealerCar_List = vgui.Create("DPanelList", CarDealer_List)
			CarDealerCar_List:SetTall( 70 )
			CarDealerCar_List:SetWide( 343 )
			CarDealerCar_List:SetPos( 0, 0 )
			CarDealerCar_List:SetSpacing( 5 )
			CarDealerCar_List.Paint = function()
											draw.RoundedBox(8,0,0,CarDealerCar_List:GetWide(),CarDealerCar_List:GetTall(),Color( 20, 20, 20, 155 ))
										end
			//CarDealerCar_List:SetToolTip( "Name: ".. GAMEMODE.OCRP_Cars[v.car].Name .."\nHealth: ".. GAMEMODE.OCRP_Cars[v.car].Health .."\nGas Tank Size: ".. GAMEMODE.OCRP_Cars[v.car].GasTank .."\nStrength: ".. GAMEMODE.OCRP_Cars[v.car].StrengthText .."\nSkin Price: ".. GAMEMODE.OCRP_Cars[v.car].Skin_Price )
										
			if type(GAMEMODE.OCRP_Cars[v.car].Model) == "table" then
				mdl = GAMEMODE.OCRP_Cars[v.car].Model[1]
			else
				mdl = GAMEMODE.OCRP_Cars[v.car].Model
			end
			
			local CDSpawnIcon = vgui.Create( "SpawnIcon", CarDealerCar_List )
			CDSpawnIcon:SetSize( 70, 70 )
			CDSpawnIcon:SetPos( 3, 3 )
			CDSpawnIcon:SetModel( mdl )
			CDSpawnIcon.OnMousePressed = function()
											RunConsoleCommand("OCRP_SC", v.car)
											CarGarage_Frame:Close()
										end
			
			surface.SetFont( "TargetID" )
			local x, y = surface.GetTextSize( GAMEMODE.OCRP_Cars[v.car].Name )
			local CDCarName = vgui.Create( "DLabel", CarDealerCar_List )
			CDCarName:SetPos( 73, 3 )
			CDCarName:SetFont( "TargetID" )
			CDCarName:SetColor( Color( 255, 255, 255, 255 ) )
			CDCarName:SetText( GAMEMODE.OCRP_Cars[v.car].Name .."\nThis car's speed is about ".. GAMEMODE.OCRP_Cars[v.car].Speed .." MPH." )
			CDCarName:SizeToContents()
			
			if LocalPlayer().Bank >= GAMEMODE.OCRP_Cars[v.car].Price then
				local CDCarPrice = vgui.Create( "DLabel", CarDealerCar_List )
				CDCarPrice:SetPos( 76 + x, 3 )
				CDCarPrice:SetFont( "TargetID" )
				CDCarPrice:SetColor( Color(0,255,0,255) )
				CDCarPrice:SetText( "$".. GAMEMODE.OCRP_Cars[v.car].Price )
				CDCarPrice:SizeToContents()
			else
				local CDCarPrice = vgui.Create( "DLabel", CarDealerCar_List )
				CDCarPrice:SetPos( 76 + x, 3 )
				CDCarPrice:SetFont( "TargetID" )
				CDCarPrice:SetColor( Color(255,0,0,255) )
				CDCarPrice:SetText( "$".. GAMEMODE.OCRP_Cars[v.car].Price )
				CDCarPrice:SizeToContents()
			end
			
			local CDBuyButton = vgui.Create("DButton")
			CDBuyButton:SetParent(CarDealerCar_List)
			CDBuyButton:SetPos(73,CDCarName:GetTall() + 6)
			CDBuyButton:SetSize(CDCarName:GetWide(),15)
			CDBuyButton:SetText("")
			CDBuyButton.Paint = function()
											draw.RoundedBox(4,0,0,CDBuyButton:GetWide(),CDBuyButton:GetTall(),Color( 60, 60, 60, 155 ))
											draw.RoundedBox(4,1,1,CDBuyButton:GetWide()-2,CDBuyButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
											
											local struc = {}
											struc.pos = {}
											struc.pos[1] = CDCarName:GetWide() / 2 -- x pos
											struc.pos[2] = 7 -- y pos
											struc.color = Color(255,255,255,255) -- Red
											struc.text = "Spawn" -- Text
											struc.font = "UIBold" -- Font
											struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
											struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
											draw.Text( struc )
										end
			CDBuyButton.DoClick = function(CDBuyButton) RunConsoleCommand("OCRP_SC", v.car) CarGarage_Frame:Close() end	
			
			CDListPanel:AddItem( CarDealerCar_List )
		end
	end
	/*local CarGarage_Frame = vgui.Create("DFrame")
	CarGarage_Frame:SetTall( 500 )
	CarGarage_Frame:SetWide( 400 )
	CarGarage_Frame:SetTitle( "Garage" )
	CarGarage_Frame:Center()
	CarGarage_Frame.Paint = function()
								draw.RoundedBox(8,1,1,CarGarage_Frame:GetWide()-2,CarGarage_Frame:GetTall()-2,OCRP_Options.Color)
							end
	CarGarage_Frame:MakePopup()
	CarGarage_Frame:ShowCloseButton(false)
	
	local CarGarage_Exit = vgui.Create("DButton", CarGarage_Frame)	
	CarGarage_Exit:SetSize(20,20)
	CarGarage_Exit:SetPos(375,5)
	CarGarage_Exit:SetText("")
	CarGarage_Exit.Paint = function()
										surface.SetMaterial(OC_Exit)
										surface.SetDrawColor(255,255,255,255)
										surface.DrawTexturedRect(0,0,CarGarage_Exit:GetWide(),CarGarage_Exit:GetTall())
									end
	CarGarage_Exit.DoClick = function()
								CarGarage_Frame:Remove()
							end
	
	local CarGarage_List = vgui.Create("DPanelList", CarGarage_Frame)
	CarGarage_List:SetTall( 460 )
	CarGarage_List:SetWide( 380 )
	CarGarage_List:SetPos( 10, 30 )
	CarGarage_List:EnableVerticalScrollbar( true )
	
	local Strength
	for _, Data in pairs(OCRP_MyCars) do
		
		if GAMEMODE.OCRP_Cars[Data.car].Health <= 50 then
			Strength = "Very Weak"
		elseif GAMEMODE.OCRP_Cars[Data.car].Health <= 75 then
			Strength = "Weak"
		elseif GAMEMODE.OCRP_Cars[Data.car].Health <= 100 then
			Strength = "Average"
		elseif GAMEMODE.OCRP_Cars[Data.car].Health <= 125 then
			Strength = "Strong"
		else
			Strength = "Very Strong"
		end
		
		local CarGarageCar_List = vgui.Create("DPanelList", CarGarage_List)
		CarGarageCar_List:SetTall( 112 )
		CarGarageCar_List:SetWide( 380 )
		CarGarageCar_List:SetPos( 0, 0 )
		CarGarageCar_List:SetSpacing( 5 )
		CarGarageCar_List.Paint = function()
									draw.RoundedBox(8,0,0,CarGarageCar_List:GetWide(),CarGarageCar_List:GetTall(),Color( 60, 60, 60, 155 ))
									end
									
		local Car_Name = vgui.Create("DLabel")
		Car_Name:SetColor(Color(255,255,255,255))
		Car_Name:SetFont("Trebuchet22")
		Car_Name:SetText("Name: ".. GAMEMODE.OCRP_Cars[Data.car].Name)
		Car_Name:SizeToContents()
		Car_Name:SetParent(CarGarageCar_List)
		Car_Name:SetPos(10, 10)
		
		local Car_Health = vgui.Create("DLabel")
		Car_Health:SetColor(Color(255,255,255,255))
		Car_Health:SetFont("Trebuchet22")
		Car_Health:SetText("Strength: ".. Strength)
		Car_Health:SizeToContents()
		Car_Health:SetParent(CarGarageCar_List)
		Car_Health:SetPos(10, 35)
		
		local Car_Price = vgui.Create("DLabel")
		Car_Price:SetColor(Color(255,255,255,255))
		Car_Price:SetFont("Trebuchet22")
		Car_Price:SetText("Price: $".. GAMEMODE.OCRP_Cars[Data.car].Price)
		Car_Price:SizeToContents()
		Car_Price:SetParent(CarGarageCar_List)
		Car_Price:SetPos(10, 58)
		
		local Car_Name = vgui.Create("DLabel")
		Car_Name:SetColor(Color(255,255,255,255))
		Car_Name:SetFont("Trebuchet22")
		Car_Name:SetText("Seats: ".. GAMEMODE.OCRP_Cars[Data.car].SeatsNum)
		Car_Name:SizeToContents()
		Car_Name:SetParent(CarGarageCar_List)
		Car_Name:SetPos(10, 80)
		
		local SpawnButton = vgui.Create("DButton", CarGarageCar_List)
		SpawnButton:SetPos( 150, 72)
		SpawnButton:SetText( " " )
		SpawnButton:SetTall( 30 )
		SpawnButton:SetWide( 220 )
		SpawnButton.Paint = function()
									draw.RoundedBox(8,0,0,SpawnButton:GetWide(),SpawnButton:GetTall(),Color( 60, 60, 60, 155 ))
									draw.RoundedBox(8,1,1,SpawnButton:GetWide()-2,SpawnButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
												
									local struc = {}
									struc.pos = {}
									struc.pos[1] = 100 -- x pos
									struc.pos[2] = 15 -- y pos
									struc.color = Color(255,255,255,255) -- Red
									struc.text = "Retrieve" -- Text
									struc.font = "UIBold" -- Font
									struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
									struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
									draw.Text( struc )
								end
		SpawnButton.DoClick = function(SpawnButton) print("---------1---------") print(Data.car) print("---------1--") RunConsoleCommand("OCRP_SC", Data.car) CarGarage_Frame:Close() end	
		
		CarGarage_List:AddItem(CarGarageCar_List)
	
	end*/
end
usermessage.Hook( "CL_Garage", CLA_Garage )

function CL_Skins(um)
	local car = um:ReadString()
	print(car)
	local CarSkins_Frame = vgui.Create("DFrame")
	CarSkins_Frame:SetTall( 400 )
	CarSkins_Frame:SetWide( 400 )
	CarSkins_Frame:SetTitle( "Skins" )
	CarSkins_Frame:Center()
	CarSkins_Frame.Paint = function()
								draw.RoundedBox(8,1,1,CarSkins_Frame:GetWide()-2,CarSkins_Frame:GetTall()-2,OCRP_Options.Color)
							end
	CarSkins_Frame:MakePopup()
	CarSkins_Frame:ShowCloseButton(false)
	
	local CarSkins_Exit = vgui.Create("DButton", CarSkins_Frame)	
	CarSkins_Exit:SetSize(20,20)
	CarSkins_Exit:SetPos(375,5)
	CarSkins_Exit:SetText("")
	CarSkins_Exit.Paint = function()
										surface.SetMaterial(OC_Exit)
										surface.SetDrawColor(255,255,255,255)
										surface.DrawTexturedRect(0,0,CarSkins_Exit:GetWide(),CarSkins_Exit:GetTall())
									end
	CarSkins_Exit.DoClick = function()
								CarSkins_Frame:Remove()
							end
	
	local CarSkins_List = vgui.Create("DPanelList", CarSkins_Frame)
	CarSkins_List:SetTall( 360 )
	CarSkins_List:SetWide( 380 )
	CarSkins_List:SetPos( 10, 30 )
	CarSkins_List:EnableVerticalScrollbar( true )
	local ShouldAdd
	for _, Data in pairs(GAMEMODE.OCRP_Cars[car].Skins) do
		if Data.dj and LocalPlayer():IsDJ() then
			local CarSkinsCar_List = vgui.Create("DPanelList", CarSkins_List)
			CarSkinsCar_List:SetTall( 50 )
			CarSkinsCar_List:SetWide( 380 )
			CarSkinsCar_List:SetPos( 0, 0 )
			CarSkinsCar_List:SetSpacing( 5 )
			CarSkinsCar_List.Paint = function()
										draw.RoundedBox(8,0,0,CarSkinsCar_List:GetWide(),CarSkinsCar_List:GetTall(),Color( 60, 60, 60, 155 ))
										end
										
			
			local BuySkinButton = vgui.Create("DButton", CarSkinsCar_List)
			BuySkinButton:SetPos( 5, 10)
			BuySkinButton:SetText( " " )
			BuySkinButton:SetTall( 40 )
			BuySkinButton:SetWide( 370 )
			BuySkinButton.Paint = function()
										draw.RoundedBox(8,0,0,BuySkinButton:GetWide(),BuySkinButton:GetTall(),Color( 60, 60, 60, 155 ))
										draw.RoundedBox(8,1,1,BuySkinButton:GetWide()-2,BuySkinButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
													
										local struc = {}
										struc.pos = {}
										struc.pos[1] = 180 -- x pos
										struc.pos[2] = 20 -- y pos
										struc.color = Color(255,255,255,255) -- Red
										struc.text = Data.name -- Text
										struc.font = "UIBold" -- Font
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )
									end
			BuySkinButton.DoClick = function(BuySkinButton) RunConsoleCommand("ocrp_bskin", _, car) CarSkins_Frame:Close() end	
			
			CarSkins_List:AddItem(CarSkinsCar_List)
		end
		if !Data.Org and !Data.dj then
				

		local CarSkinsCar_List = vgui.Create("DPanelList", CarSkins_List)
		CarSkinsCar_List:SetTall( 50 )
		CarSkinsCar_List:SetWide( 380 )
		CarSkinsCar_List:SetPos( 0, 0 )
		CarSkinsCar_List:SetSpacing( 5 )
		CarSkinsCar_List.Paint = function()
									draw.RoundedBox(8,0,0,CarSkinsCar_List:GetWide(),CarSkinsCar_List:GetTall(),Color( 60, 60, 60, 155 ))
									end
									
		
		local BuySkinButton = vgui.Create("DButton", CarSkinsCar_List)
		BuySkinButton:SetPos( 5, 10)
		BuySkinButton:SetText( " " )
		BuySkinButton:SetTall( 40 )
		BuySkinButton:SetWide( 370 )
		BuySkinButton.Paint = function()
									draw.RoundedBox(8,0,0,BuySkinButton:GetWide(),BuySkinButton:GetTall(),Color( 60, 60, 60, 155 ))
									draw.RoundedBox(8,1,1,BuySkinButton:GetWide()-2,BuySkinButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
												
									local struc = {}
									struc.pos = {}
									struc.pos[1] = 180 -- x pos
									struc.pos[2] = 20 -- y pos
									struc.color = Color(255,255,255,255) -- Red
									struc.text = Data.name -- Text
									struc.font = "UIBold" -- Font
									struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
									struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
									draw.Text( struc )
								end
		BuySkinButton.DoClick = function(BuySkinButton) RunConsoleCommand("ocrp_bskin", _, car) CarSkins_Frame:Close() end	
		
		CarSkins_List:AddItem(CarSkinsCar_List)
	end
	
	end
end
usermessage.Hook("ocrp_open_skins", CL_Skins)

function CL_UpdateGas( umsg )
	local gas = umsg:ReadLong()
	OCRP_VehicleGas = gas
end
usermessage.Hook("OCRP_UpdateGas", CL_UpdateGas)

function GM.CarAlarm ( UMsg )
	local Entity = UMsg:ReadEntity();
	
	if !Entity or !Entity:IsValid() then return false; end
	
	if !Entity:GetTable().CarAlarmLoop then
		Entity:GetTable().CarAlarmLoop = CreateSound(Entity, Sound('ocrp/car_alarm.mp3'));
		Entity:GetTable().CarAlarmLoop_LastPlay = 0;
	end
	
	if Entity:GetTable().CarAlarmLoop_LastPlay + 25 < CurTime() then
		Entity:GetTable().CarAlarmLoop:Play();
		Entity:GetTable().CarAlarmLoop_LastPlay = CurTime();
	end
end
usermessage.Hook('car_alarm', GM.CarAlarm);


function GM.CarAlarmStop ( UMsg )
	local Entity = UMsg:ReadEntity();
	
	if !Entity or !Entity:IsValid() then return false; end
	
	if Entity:GetTable().CarAlarmLoop_LastPlay and Entity:GetTable().CarAlarmLoop_LastPlay + 23 > CurTime() then
		Entity:GetTable().CarAlarmLoop:Stop();
		Entity:GetTable().CarAlarmLoop_LastPlay = 0;
	end
end
usermessage.Hook('car_alarm_stop', GM.CarAlarmStop);
