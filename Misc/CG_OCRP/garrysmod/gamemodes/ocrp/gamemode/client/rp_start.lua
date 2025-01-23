require("datastream")

local vgui = vgui
local draw = draw
local surface = surface

local function OCRP_GetWardrobeUpdate( um )
	local key = um:ReadLong()
	local mdl = um:ReadString()
	local outfit = um:ReadString()
	local mykey = um:ReadLong()
	for k, v in pairs(OCRP_PLAYER["Wardrobe"]) do
		if v.Model == mdl then
			table.remove(OCRP_PLAYER["Wardrobe"], k)
		end
	end
	table.insert(OCRP_PLAYER["Wardrobe"], {Key = key, Model = mdl, Outfit = outfit, Choice = choice})
	OCRP_PLAYER["MyKey"] = mykey
end
usermessage.Hook("ocrp_wardrobe_update", OCRP_GetWardrobeUpdate)

function PMETA:CL_FindKey( mdl )
	local key = 0
	if string.find(mdl, "_01") then
		key = 1
	elseif string.find(mdl, "_02") then
		key = 2
	elseif string.find(mdl, "_03") then
		key = 3
	elseif string.find(mdl, "_04") then
		key = 4
	elseif string.find(mdl, "_05") then
		key = 5
	elseif string.find(mdl, "_06") then
		key = 6
	elseif string.find(mdl, "_07") then
		key = 7
	elseif string.find(mdl, "_08") then
		key = 8
	elseif string.find(mdl, "_09") then
		key = 9
	end
	return key
end

local function OCRP_Face( um )
	local MdlFrame = vgui.Create( "DFrame" )
	MdlFrame:SetTall( 410 )
	MdlFrame:SetWide( 750 )
	MdlFrame:SetTitle( " " )
	MdlFrame:Center()
	MdlFrame.Paint = function()
						draw.RoundedBox(8,1,1,MdlFrame:GetWide()-2,MdlFrame:GetTall()-2,OCRP_Options.Color)	
					end
	MdlFrame:MakePopup()
	
	local TitlePanel = vgui.Create( "DPanel", MdlFrame )
	TitlePanel:SetTall( 50 )
	TitlePanel:SetWide( 720 )
	TitlePanel:SetPos( 10, 10 )
	TitlePanel.Paint = function()
							draw.RoundedBox(8,1,1,TitlePanel:GetWide()-2,TitlePanel:GetTall()-2,Color(60,60,60,180))	
						end
						
	local SelectPanel = vgui.Create( "DPanel", MdlFrame )
	SelectPanel:SetTall( 330 )
	SelectPanel:SetWide( 500 )
	SelectPanel:SetPos( 10, 70 )
	SelectPanel.Paint = function()
							draw.RoundedBox(8,1,1,SelectPanel:GetWide()-2,SelectPanel:GetTall()-2,Color(60,60,60,180))	
						end
						
	local PreviewPanel = vgui.Create( "DPanel", MdlFrame )
	PreviewPanel:SetTall( 330 )
	PreviewPanel:SetWide( 220 )
	PreviewPanel:SetPos( 520, 70 )
	PreviewPanel.Paint = function()
							draw.RoundedBox(8,1,1,PreviewPanel:GetWide()-2,PreviewPanel:GetTall()-2,Color(60,60,60,180))	
						end
						
	local PreviewMdl = vgui.Create( "DModelPanel", PreviewPanel )
	PreviewMdl:SetTall( 200 )
	PreviewMdl:SetWide( 200 )
	PreviewMdl:SetPos( 5, 5 )
	PreviewMdl:SetModel( LocalPlayer():GetModel() )	
	PreviewMdl:SetCamPos( Vector( 50, 50, 50 ) )
	
	local PreviewSlider = vgui.Create( "DNumSlider", PreviewPanel )
	PreviewSlider:SetWide( 200 )
	PreviewSlider:SetPos( 10, 220 )
	PreviewSlider:SetText( "Angle" )
	PreviewSlider:SetMax( 360 )
	PreviewSlider:SetMin( 0 )
	PreviewSlider:SetDecimals( 0 )
	
	function PreviewMdl:LayoutEntity( ent )
	
		ent:SetAngles( Angle( 0, PreviewSlider:GetValue(), 0) )
		
	end
	
	local ShopLabel = vgui.Create( "DLabel", TitlePanel )
	ShopLabel:SetFont( "TargetID" )
	ShopLabel:SetText( "Kentuckys' Friendly Faces" )
	ShopLabel:SetColor( Color( 255, 255, 255, 255 ) )
	ShopLabel:SetPos( 10, 10 )
	ShopLabel:SizeToContents()
	
	local FaceButton = vgui.Create("DButton", PreviewPanel)
	FaceButton:SetPos(10,265)
	FaceButton:SetSize(200,20)
	FaceButton:SetText("")
	FaceButton.Paint = function()
									draw.RoundedBox(4,0,0,FaceButton:GetWide(),FaceButton:GetTall(),Color( 60, 60, 60, 155 ))
									draw.RoundedBox(4,1,1,FaceButton:GetWide()-2,FaceButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
									
									local struc = {}
									struc.pos = {}
									struc.pos[1] = 100 -- x pos
									struc.pos[2] = 10 -- y pos
									struc.color = Color(255,255,255,255) -- Red
									struc.text = "Face" -- Text
									struc.font = "UIBold" -- Font
									struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
									struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
									draw.Text( struc )
								end
	FaceButton.DoClick = function()
							PreviewMdl:SetCamPos( Vector( 50, 0, 60) )
							PreviewMdl:SetLookAt( Vector( 0, 0, 60) )
							PreviewMdl:SetFOV( 40 )
						end
								

	
	local MainClothes = vgui.Create( "DPanelList", SelectPanel )
	MainClothes:SetTall( 320 )
	MainClothes:SetWide( 490 )
	MainClothes:SetPos( 5, 5 )
	MainClothes:SetSpacing( 4 )
	MainClothes:EnableHorizontal( true )
	MainClothes:EnableVerticalScrollbar( true )
	MainClothes.Paint = function()
							draw.RoundedBox(8,0,0,MainClothes:GetWide(),MainClothes:GetTall(),Color(60,60,60,0))
						end
	
	PreviewMdl:SetModel( LocalPlayer():GetModel() )	
	local thekey = 1

	for _, face in pairs( GAMEMODE.OCRP_Models[LocalPlayer():GetSex() .."s"] ) do
		local ClothesList = vgui.Create( "DPanelList" )
		ClothesList:SetTall( 155 )
		ClothesList:SetWide( 120 )
		ClothesList:SetPos( 0, 0 )
		ClothesList.Paint = function()
								draw.RoundedBox(8,0,0,ClothesList:GetWide(),ClothesList:GetTall(),Color(60,60,60,180))
							end
	
		local ClothesName = vgui.Create( "DLabel", ClothesList )
		ClothesName:SetFont( "TargetIDSmall" )
		ClothesName:SetText( tostring( _ ) )
		ClothesName:SetColor( Color( 255, 255, 255, 255 ) )

		surface.SetFont( "TargetIDSmall" )
		local x, y = surface.GetTextSize( tostring( _ ) )
		ClothesName:SetPos( 59 - ( x / 2 ), 2 )
		ClothesName:SizeToContents()

		local ClothesMdl = vgui.Create( "DModelPanel", ClothesList )
		ClothesMdl:SetTall( 94 )
		ClothesMdl:SetWide( 94 )
		ClothesMdl:SetModel( face.Regular ) 
		ClothesMdl:SetPos( 12, 20 )
		ClothesMdl:SetCamPos( Vector( 50, 0, 60) )
		ClothesMdl:SetLookAt( Vector( 0, 0, 60) )

		local TryOnButton = vgui.Create("DButton", ClothesList)
		TryOnButton:SetPos(10,118)
		TryOnButton:SetSize(100,15)
		TryOnButton:SetText("")
		TryOnButton.Paint = function()
										draw.RoundedBox(4,0,0,TryOnButton:GetWide(),TryOnButton:GetTall(),Color( 60, 60, 60, 155 ))
										draw.RoundedBox(4,1,1,TryOnButton:GetWide()-2,TryOnButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
										
										local struc = {}
										struc.pos = {}
										struc.pos[1] = 50 -- x pos
										struc.pos[2] = 7 -- y pos
										struc.color = Color(255,255,255,255) -- Red
										struc.text = "Preview" -- Text
										struc.font = "UIBold" -- Font
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )
									end
		TryOnButton.DoClick = function()
									PreviewMdl:SetModel( tostring(face.Regular) )
								end
									
		local BuyClothesButton = vgui.Create("DButton", ClothesList)
		BuyClothesButton:SetPos(10,135)
		BuyClothesButton:SetSize(100,15)
		BuyClothesButton:SetText("")
		BuyClothesButton.Paint = function()
										draw.RoundedBox(4,0,0,BuyClothesButton:GetWide(),BuyClothesButton:GetTall(),Color( 60, 60, 60, 155 ))
										draw.RoundedBox(4,1,1,BuyClothesButton:GetWide()-2,BuyClothesButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
										
										local struc = {}
										struc.pos = {}
										struc.pos[1] = 50 -- x pos
										struc.pos[2] = 7 -- y pos
										struc.color = Color(255,255,255,255) -- Red
										struc.text = "Buy" -- Text
										struc.font = "UIBold" -- Font
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )
									end
		
		BuyClothesButton.DoClick = function()
										RunConsoleCommand("OCRP_ChangeFace", _)
									end
		
		MainClothes:AddItem( ClothesList )
	end
end
concommand.Add("OCRP_Face", OCRP_Face)

local function OCRP_Wardrobe(um)
	local WarFrame = vgui.Create( "DFrame" )
	WarFrame:SetTall( 520 )
	WarFrame:SetWide( 600 )
	WarFrame:SetTitle( "Wardrobe" )
	WarFrame:Center()
	WarFrame.Paint = function()
						draw.RoundedBox(8,1,1,WarFrame:GetWide()-2,WarFrame:GetTall()-2,OCRP_Options.Color)	
					end
	WarFrame:MakePopup()
	
	local MainList = vgui.Create( "DPanelList", WarFrame )
	MainList:SetTall( 490 )
	MainList:SetWide( 590 )
	MainList:SetPos( 5, 25 )
	MainList:SetSpacing( 5 )
	MainList:EnableHorizontal( true )
	MainList:EnableVerticalScrollbar( true )
	
	local MyKey = LocalPlayer():CL_FindKey( LocalPlayer():GetModel() )
	for k, v in pairs(OCRP_PLAYER["Wardrobe"]) do
		if tonumber(v.Key) == MyKey then
			local ClothesList = vgui.Create( "DPanelList" )
			ClothesList:SetTall( 242.5 )
			ClothesList:SetWide( 292.5 )
			ClothesList:SetPos( 0, 0 )
			ClothesList.Paint = function()
									draw.RoundedBox(8,0,0,ClothesList:GetWide(),ClothesList:GetTall(),Color(60,60,60,180))
								end
								
			local ClothesName = vgui.Create( "DLabel", ClothesList )
			ClothesName:SetFont( "TargetID" )
			ClothesName:SetText( v.Outfit )
			ClothesName:SetColor( Color( 255, 255, 255, 255 ) )
			
			surface.SetFont( "TargetID" )
			local x, y = surface.GetTextSize( tostring( v.Outfit ) )
			ClothesName:SetPos( 146 - ( x / 2 ), 2 )
			ClothesName:SizeToContents()
			
			local ClothesMdl = vgui.Create( "DModelPanel", ClothesList )
			ClothesMdl:SetTall( 150 )
			ClothesMdl:SetWide( 150 )
			ClothesMdl:SetModel( v.Model )
			ClothesMdl:SetPos( 71, 25 )
			
			local TryOnButton = vgui.Create("DButton", ClothesList)
			TryOnButton:SetPos(30,195)
			TryOnButton:SetSize(232.5,30)
			TryOnButton:SetText("")
			TryOnButton.Paint = function()
											draw.RoundedBox(4,0,0,TryOnButton:GetWide(),TryOnButton:GetTall(),Color( 60, 60, 60, 155 ))
											draw.RoundedBox(4,1,1,TryOnButton:GetWide()-2,TryOnButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
											
											local struc = {}
											struc.pos = {}
											struc.pos[1] = 116.25 -- x pos
											struc.pos[2] = 15 -- y pos
											struc.color = Color(255,255,255,255) -- Red
											struc.text = "Wear" -- Text
											struc.font = "UIBold" -- Font
											struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
											struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
											draw.Text( struc )
										end
			TryOnButton.DoClick = function()
										RunConsoleCommand("OCRP_PickWardrobeChoice", v.Model, OCRP_PLAYER["MyKey"])
									end
										
			
			MainList:AddItem( ClothesList )
		end
	end
		
end
usermessage.Hook("showward", OCRP_Wardrobe)

local function OCRP_Model()
	if LocalPlayer():Team() != CLASS_CITIZEN then
		return false
	end
	
	local MdlFrame = vgui.Create( "DFrame" )
	MdlFrame:SetTall( 410 )
	MdlFrame:SetWide( 750 )
	MdlFrame:SetTitle( " " )
	MdlFrame:Center()
	MdlFrame.Paint = function()
						draw.RoundedBox(8,1,1,MdlFrame:GetWide()-2,MdlFrame:GetTall()-2,OCRP_Options.Color)	
					end
	MdlFrame:MakePopup()
	
	local TitlePanel = vgui.Create( "DPanel", MdlFrame )
	TitlePanel:SetTall( 50 )
	TitlePanel:SetWide( 720 )
	TitlePanel:SetPos( 10, 10 )
	TitlePanel.Paint = function()
							draw.RoundedBox(8,1,1,TitlePanel:GetWide()-2,TitlePanel:GetTall()-2,Color(60,60,60,180))	
						end
						
	local SelectPanel = vgui.Create( "DPanel", MdlFrame )
	SelectPanel:SetTall( 330 )
	SelectPanel:SetWide( 500 )
	SelectPanel:SetPos( 10, 70 )
	SelectPanel.Paint = function()
							draw.RoundedBox(8,1,1,SelectPanel:GetWide()-2,SelectPanel:GetTall()-2,Color(60,60,60,180))	
						end
						
	local PreviewPanel = vgui.Create( "DPanel", MdlFrame )
	PreviewPanel:SetTall( 330 )
	PreviewPanel:SetWide( 220 )
	PreviewPanel:SetPos( 520, 70 )
	PreviewPanel.Paint = function()
							draw.RoundedBox(8,1,1,PreviewPanel:GetWide()-2,PreviewPanel:GetTall()-2,Color(60,60,60,180))	
						end
						
	local PreviewMdl = vgui.Create( "DModelPanel", PreviewPanel )
	PreviewMdl:SetTall( 200 )
	PreviewMdl:SetWide( 200 )
	PreviewMdl:SetPos( 5, 5 )
	PreviewMdl:SetModel( LocalPlayer():GetModel() )	
	PreviewMdl:SetCamPos( Vector( 50, 50, 50 ) )
	
	local PreviewSlider = vgui.Create( "DNumSlider", PreviewPanel )
	PreviewSlider:SetWide( 200 )
	PreviewSlider:SetPos( 10, 220 )
	PreviewSlider:SetText( "Angle" )
	PreviewSlider:SetMax( 360 )
	PreviewSlider:SetMin( 0 )
	PreviewSlider:SetDecimals( 0 )
	
	function PreviewMdl:LayoutEntity( ent )
	
		ent:SetAngles( Angle( 0, PreviewSlider:GetValue(), 0) )
		
	end
	
	local ShopLabel = vgui.Create( "DLabel", TitlePanel )
	ShopLabel:SetFont( "TargetID" )
	ShopLabel:SetText( "Kentuckys' Friendly Clothing - $2,500 each." )
	ShopLabel:SetColor( Color( 255, 255, 255, 255 ) )
	ShopLabel:SetPos( 10, 10 )
	ShopLabel:SizeToContents()
	
	local FaceButton = vgui.Create("DButton", PreviewPanel)
	FaceButton:SetPos(10,265)
	FaceButton:SetSize(200,20)
	FaceButton:SetText("")
	FaceButton.Paint = function()
									draw.RoundedBox(4,0,0,FaceButton:GetWide(),FaceButton:GetTall(),Color( 60, 60, 60, 155 ))
									draw.RoundedBox(4,1,1,FaceButton:GetWide()-2,FaceButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
									
									local struc = {}
									struc.pos = {}
									struc.pos[1] = 100 -- x pos
									struc.pos[2] = 10 -- y pos
									struc.color = Color(255,255,255,255) -- Red
									struc.text = "Face" -- Text
									struc.font = "UIBold" -- Font
									struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
									struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
									draw.Text( struc )
								end
	FaceButton.DoClick = function()
							PreviewMdl:SetCamPos( Vector( 50, 0, 60) )
							PreviewMdl:SetLookAt( Vector( 0, 0, 60) )
							PreviewMdl:SetFOV( 40 )
						end
								
	local BodyButton = vgui.Create("DButton", PreviewPanel)
	BodyButton:SetPos(10,290)
	BodyButton:SetSize(200,20)
	BodyButton:SetText("")
	BodyButton.Paint = function()
									draw.RoundedBox(4,0,0,BodyButton:GetWide(),BodyButton:GetTall(),Color( 60, 60, 60, 155 ))
									draw.RoundedBox(4,1,1,BodyButton:GetWide()-2,BodyButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
									
									local struc = {}
									struc.pos = {}
									struc.pos[1] = 100 -- x pos
									struc.pos[2] = 10 -- y pos
									struc.color = Color(255,255,255,255) -- Red
									struc.text = "Body" -- Text
									struc.font = "UIBold" -- Font
									struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
									struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
									draw.Text( struc )
								end
	BodyButton.DoClick = function()
							PreviewMdl:SetCamPos( Vector( 50, 0, 50) )
							PreviewMdl:SetLookAt( Vector( 0, 0, 50) )
							PreviewMdl:SetFOV( 70 )	
						end
	
	local MainClothes = vgui.Create( "DPanelList", SelectPanel )
	MainClothes:SetTall( 320 )
	MainClothes:SetWide( 490 )
	MainClothes:SetPos( 5, 5 )
	MainClothes:SetSpacing( 4 )
	MainClothes:EnableHorizontal( true )
	MainClothes:EnableVerticalScrollbar( true )
	MainClothes.Paint = function()
							draw.RoundedBox(8,0,0,MainClothes:GetWide(),MainClothes:GetTall(),Color(60,60,60,0))
						end
	
	PreviewMdl:SetModel( LocalPlayer():GetModel() )	

	for k, v in pairs( GAMEMODE.OCRP_Models[LocalPlayer():GetSex() .."s"][LocalPlayer():CL_FindKey(LocalPlayer():GetModel())] ) do
		local ClothesList = vgui.Create( "DPanelList" )
		ClothesList:SetTall( 155 )
		ClothesList:SetWide( 120 )
		ClothesList:SetPos( 0, 0 )
		ClothesList.Paint = function()
								draw.RoundedBox(8,0,0,ClothesList:GetWide(),ClothesList:GetTall(),Color(60,60,60,180))
							end
							
		local ClothesName = vgui.Create( "DLabel", ClothesList )
		ClothesName:SetFont( "TargetIDSmall" )
		ClothesName:SetText( tostring( k ) )
		ClothesName:SetColor( Color( 255, 255, 255, 255 ) )
		
		surface.SetFont( "TargetIDSmall" )
		local x, y = surface.GetTextSize( tostring( k ) )
		ClothesName:SetPos( 59 - ( x / 2 ), 2 )
		ClothesName:SizeToContents()
		
		local ClothesMdl = vgui.Create( "DModelPanel", ClothesList )
		ClothesMdl:SetTall( 94 )
		ClothesMdl:SetWide( 94 )
		ClothesMdl:SetModel( v )
		ClothesMdl:SetPos( 12, 20 )
		
		local TryOnButton = vgui.Create("DButton", ClothesList)
		TryOnButton:SetPos(10,118)
		TryOnButton:SetSize(100,15)
		TryOnButton:SetText("")
		TryOnButton.Paint = function()
										draw.RoundedBox(4,0,0,TryOnButton:GetWide(),TryOnButton:GetTall(),Color( 60, 60, 60, 155 ))
										draw.RoundedBox(4,1,1,TryOnButton:GetWide()-2,TryOnButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
										
										local struc = {}
										struc.pos = {}
										struc.pos[1] = 50 -- x pos
										struc.pos[2] = 7 -- y pos
										struc.color = Color(255,255,255,255) -- Red
										struc.text = "Try on" -- Text
										struc.font = "UIBold" -- Font
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )
									end
		TryOnButton.DoClick = function()
									PreviewMdl:SetModel( v )
								end
									
		local BuyClothesButton = vgui.Create("DButton", ClothesList)
		BuyClothesButton:SetPos(10,135)
		BuyClothesButton:SetSize(100,15)
		BuyClothesButton:SetText("")
		BuyClothesButton.Paint = function()
										draw.RoundedBox(4,0,0,BuyClothesButton:GetWide(),BuyClothesButton:GetTall(),Color( 60, 60, 60, 155 ))
										draw.RoundedBox(4,1,1,BuyClothesButton:GetWide()-2,BuyClothesButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
										
										local struc = {}
										struc.pos = {}
										struc.pos[1] = 50 -- x pos
										struc.pos[2] = 7 -- y pos
										struc.color = Color(255,255,255,255) -- Red
										struc.text = "Buy" -- Text
										struc.font = "UIBold" -- Font
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )
									end
		BuyClothesButton.DoClick = function()
										RunConsoleCommand("SV_BuyClothes", 0, v, k)
									end
		
		MainClothes:AddItem( ClothesList )
	end
end
concommand.Add("OCRP_Model", OCRP_Model)

function OCRP_Gender()
	local Gender_Frame = vgui.Create( "DFrame" )
	Gender_Frame:SetTall( 400 )
	Gender_Frame:SetWide( 400 )
	Gender_Frame:Center()
	Gender_Frame:SetTitle( "Select your gender.." )
	Gender_Frame:ShowCloseButton( false )
	Gender_Frame.Paint = function()
								Draw_OCRP_BackgroundBlur(Gender_Frame)
								return false
						end
	Gender_Frame:SetBackgroundBlur( true )
	Gender_Frame:MakePopup()

	local Gender_Male_Model = vgui.Create( "DModelPanel", Gender_Frame )
	Gender_Male_Model:SetTall( 170 )
	Gender_Male_Model:SetWide( 185 )
	Gender_Male_Model:SetPos( 10, 25 )
	Gender_Male_Model:SetModel( "kaldkkda.mdl" )
	
	local Gender_Female_Model = vgui.Create( "DModelPanel", Gender_Frame )
	Gender_Female_Model:SetTall( 170 )
	Gender_Female_Model:SetWide( 185 )
	Gender_Female_Model:SetPos( 205, 25 )
	Gender_Female_Model:SetModel( "kaldkkda.mdl" )
	
	local Gender_Male_Info_List2 = vgui.Create( "DPanel", Gender_Frame )
	Gender_Male_Info_List2:SetTall( 170 )
	Gender_Male_Info_List2:SetWide( 185 )
	Gender_Male_Info_List2:SetPos( 10, 200 )
	
	local Gender_Male_Info_Text = vgui.Create( "DLabel", Gender_Male_Info_List2 )
	Gender_Male_Info_Text:SetPos( 5, 5 )
	Gender_Male_Info_Text:SetTall( 160 )
	Gender_Male_Info_Text:SetWide( 175 )
	Gender_Male_Info_Text:SetText( "This is a male, he has all the features of a male." )
	Gender_Male_Info_Text:SetWrap( true )
	
	
	local Gender_Female_Info = vgui.Create( "DPanel", Gender_Frame )
	Gender_Female_Info:SetTall( 170 )
	Gender_Female_Info:SetWide( 185 )
	Gender_Female_Info:SetPos( 200, 200 )
end
concommand.Add("OCRP_Gender", OCRP_Gender)
	
function OCRP_Start_Model()

	local MdlFrame = vgui.Create( "DFrame" )
	MdlFrame:SetTall( 410 )
	MdlFrame:SetWide( 750 )
	MdlFrame:SetTitle( " " )
	MdlFrame:Center()
	MdlFrame:ShowCloseButton(false)
	MdlFrame.Paint = function()
						draw.RoundedBox(8,1,1,MdlFrame:GetWide()-2,MdlFrame:GetTall()-2,OCRP_Options.Color)	
					end
	MdlFrame:MakePopup()
	
	local TitlePanel = vgui.Create( "DPanel", MdlFrame )
	TitlePanel:SetTall( 50 )
	TitlePanel:SetWide( 730 )
	TitlePanel:SetPos( 10, 10 )
	TitlePanel.Paint = function()
							draw.RoundedBox(8,1,1,TitlePanel:GetWide()-2,TitlePanel:GetTall()-2,Color(60,60,60,180))	
						end
						
	local SelectPanel = vgui.Create( "DPanel", MdlFrame )
	SelectPanel:SetTall( 330 )
	SelectPanel:SetWide( 500 )
	SelectPanel:SetPos( 10, 70 )
	SelectPanel.Paint = function()
							draw.RoundedBox(8,1,1,SelectPanel:GetWide()-2,SelectPanel:GetTall()-2,Color(60,60,60,180))	
						end
						
	local PreviewPanel = vgui.Create( "DPanel", MdlFrame )
	PreviewPanel:SetTall( 330 )
	PreviewPanel:SetWide( 220 )
	PreviewPanel:SetPos( 520, 70 )
	PreviewPanel.Paint = function()
							draw.RoundedBox(8,1,1,PreviewPanel:GetWide()-2,PreviewPanel:GetTall()-2,Color(60,60,60,180))	
						end
						
	local PreviewMdl = vgui.Create( "DModelPanel", PreviewPanel )
	PreviewMdl:SetTall( 200 )
	PreviewMdl:SetWide( 200 )
	PreviewMdl:SetPos( 5, 5 )
	PreviewMdl:SetModel( LocalPlayer():GetModel() )	
	PreviewMdl:SetCamPos( Vector( 50, 50, 50 ) )
	
	local PreviewSlider = vgui.Create( "DNumSlider", PreviewPanel )
	PreviewSlider:SetWide( 200 )
	PreviewSlider:SetPos( 10, 220 )
	PreviewSlider:SetText( "Angle" )
	PreviewSlider:SetMax( 360 )
	PreviewSlider:SetMin( 0 )
	PreviewSlider:SetDecimals( 0 )
	
	function PreviewMdl:LayoutEntity( ent )
	
		ent:SetAngles( Angle( 0, PreviewSlider:GetValue(), 0) )
		
	end
	
	local ShopLabel = vgui.Create( "DLabel", TitlePanel )
	ShopLabel:SetFont( "TargetID" )
	ShopLabel:SetText( "Choose your model" )
	ShopLabel:SetColor( Color( 255, 255, 255, 255 ) )
	ShopLabel:SetPos( 10, 10 )
	ShopLabel:SizeToContents()
	
	local FaceButton = vgui.Create("DButton", PreviewPanel)
	FaceButton:SetPos(10,265)
	FaceButton:SetSize(200,20)
	FaceButton:SetText("")
	FaceButton.Paint = function()
									draw.RoundedBox(4,0,0,FaceButton:GetWide(),FaceButton:GetTall(),Color( 60, 60, 60, 155 ))
									draw.RoundedBox(4,1,1,FaceButton:GetWide()-2,FaceButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
									
									local struc = {}
									struc.pos = {}
									struc.pos[1] = 100 -- x pos
									struc.pos[2] = 10 -- y pos
									struc.color = Color(255,255,255,255) -- Red
									struc.text = "Face" -- Text
									struc.font = "UIBold" -- Font
									struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
									struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
									draw.Text( struc )
								end
	FaceButton.DoClick = function()
							PreviewMdl:SetCamPos( Vector( 50, 0, 60) )
							PreviewMdl:SetLookAt( Vector( 0, 0, 60) )
							PreviewMdl:SetFOV( 40 )
						end
								
	local BodyButton = vgui.Create("DButton", PreviewPanel)
	BodyButton:SetPos(10,290)
	BodyButton:SetSize(200,20)
	BodyButton:SetText("")
	BodyButton.Paint = function()
									draw.RoundedBox(4,0,0,BodyButton:GetWide(),BodyButton:GetTall(),Color( 60, 60, 60, 155 ))
									draw.RoundedBox(4,1,1,BodyButton:GetWide()-2,BodyButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
									
									local struc = {}
									struc.pos = {}
									struc.pos[1] = 100 -- x pos
									struc.pos[2] = 10 -- y pos
									struc.color = Color(255,255,255,255) -- Red
									struc.text = "Body" -- Text
									struc.font = "UIBold" -- Font
									struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
									struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
									draw.Text( struc )
								end
	BodyButton.DoClick = function()
							PreviewMdl:SetCamPos( Vector( 50, 0, 50) )
							PreviewMdl:SetLookAt( Vector( 0, 0, 50) )
							PreviewMdl:SetFOV( 70 )	
						end
	
	local MainClothes = vgui.Create( "DPanelList", SelectPanel )
	MainClothes:SetTall( 320 )
	MainClothes:SetWide( 490 )
	MainClothes:SetPos( 5, 5 )
	MainClothes:SetSpacing( 4 )
	MainClothes:EnableHorizontal( true )
	MainClothes:EnableVerticalScrollbar( true )
	MainClothes.Paint = function()
							draw.RoundedBox(8,0,0,MainClothes:GetWide(),MainClothes:GetTall(),Color(60,60,60,0))
						end
	
	PreviewMdl:SetModel( LocalPlayer():GetModel() )	
	for k, v in pairs( GAMEMODE.OCRP_Models["Males"] ) do
		local ClothesList = vgui.Create( "DPanelList" )
		ClothesList:SetTall( 155 )
		ClothesList:SetWide( 120 )
		ClothesList:SetPos( 0, 0 )
		ClothesList.Paint = function()
								draw.RoundedBox(8,0,0,ClothesList:GetWide(),ClothesList:GetTall(),Color(60,60,60,180))
							end
							
		local ClothesName = vgui.Create( "DLabel", ClothesList )
		ClothesName:SetFont( "TargetIDSmall" )
		ClothesName:SetText( tostring( k ) )
		ClothesName:SetColor( Color( 255, 255, 255, 255 ) )
		
		surface.SetFont( "TargetIDSmall" )
		local x, y = surface.GetTextSize( tostring( k ) )
		ClothesName:SetPos( 59 - ( x / 2 ), 2 )
		ClothesName:SizeToContents()
		
		local ClothesMdl = vgui.Create( "DModelPanel", ClothesList )
		ClothesMdl:SetTall( 94 )
		ClothesMdl:SetWide( 94 )
		ClothesMdl:SetModel( v["Regular"] )
		ClothesMdl:SetPos( 12, 20 )
		
		local TryOnButton = vgui.Create("DButton", ClothesList)
		TryOnButton:SetPos(10,118)
		TryOnButton:SetSize(100,15)
		TryOnButton:SetText("")
		TryOnButton.Paint = function()
										draw.RoundedBox(4,0,0,TryOnButton:GetWide(),TryOnButton:GetTall(),Color( 60, 60, 60, 155 ))
										draw.RoundedBox(4,1,1,TryOnButton:GetWide()-2,TryOnButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
										
										local struc = {}
										struc.pos = {}
										struc.pos[1] = 50 -- x pos
										struc.pos[2] = 7 -- y pos
										struc.color = Color(255,255,255,255) -- Red
										struc.text = "Try on" -- Text
										struc.font = "UIBold" -- Font
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )
									end
		TryOnButton.DoClick = function()
									PreviewMdl:SetModel( v["Regular"] )
								end
									
		local BuyClothesButton = vgui.Create("DButton", ClothesList)
		BuyClothesButton:SetPos(10,135)
		BuyClothesButton:SetSize(100,15)
		BuyClothesButton:SetText("")
		BuyClothesButton.Paint = function()
										draw.RoundedBox(4,0,0,BuyClothesButton:GetWide(),BuyClothesButton:GetTall(),Color( 60, 60, 60, 155 ))
										draw.RoundedBox(4,1,1,BuyClothesButton:GetWide()-2,BuyClothesButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
										
										local struc = {}
										struc.pos = {}
										struc.pos[1] = 50 -- x pos
										struc.pos[2] = 7 -- y pos
										struc.color = Color(255,255,255,255) -- Red
										struc.text = "Select" -- Text
										struc.font = "UIBold" -- Font
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )
									end
		BuyClothesButton.DoClick = function()
										RunConsoleCommand("AddToWardrobe", k, v["Regular"], "Regular", "true", "true")
										MdlFrame:Remove()
									end
		
		MainClothes:AddItem( ClothesList )
	end
	for k, v in pairs( GAMEMODE.OCRP_Models["Females"] ) do
		local ClothesList = vgui.Create( "DPanelList" )
		ClothesList:SetTall( 155 )
		ClothesList:SetWide( 120 )
		ClothesList:SetPos( 0, 0 )
		ClothesList.Paint = function()
								draw.RoundedBox(8,0,0,ClothesList:GetWide(),ClothesList:GetTall(),Color(60,60,60,180))
							end
							
		local ClothesName = vgui.Create( "DLabel", ClothesList )
		ClothesName:SetFont( "TargetIDSmall" )
		ClothesName:SetText( tostring( k ) )
		ClothesName:SetColor( Color( 255, 255, 255, 255 ) )
		
		surface.SetFont( "TargetIDSmall" )
		local x, y = surface.GetTextSize( tostring( k ) )
		ClothesName:SetPos( 59 - ( x / 2 ), 2 )
		ClothesName:SizeToContents()
		
		local ClothesMdl = vgui.Create( "DModelPanel", ClothesList )
		ClothesMdl:SetTall( 94 )
		ClothesMdl:SetWide( 94 )
		ClothesMdl:SetModel( v["Regular"] )
		ClothesMdl:SetPos( 12, 20 )
		
		local TryOnButton = vgui.Create("DButton", ClothesList)
		TryOnButton:SetPos(10,118)
		TryOnButton:SetSize(100,15)
		TryOnButton:SetText("")
		TryOnButton.Paint = function()
										draw.RoundedBox(4,0,0,TryOnButton:GetWide(),TryOnButton:GetTall(),Color( 60, 60, 60, 155 ))
										draw.RoundedBox(4,1,1,TryOnButton:GetWide()-2,TryOnButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
										
										local struc = {}
										struc.pos = {}
										struc.pos[1] = 50 -- x pos
										struc.pos[2] = 7 -- y pos
										struc.color = Color(255,255,255,255) -- Red
										struc.text = "Try on" -- Text
										struc.font = "UIBold" -- Font
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )
									end
		TryOnButton.DoClick = function()
									PreviewMdl:SetModel( v["Regular"] )
								end
									
		local BuyClothesButton = vgui.Create("DButton", ClothesList)
		BuyClothesButton:SetPos(10,135)
		BuyClothesButton:SetSize(100,15)
		BuyClothesButton:SetText("")
		BuyClothesButton.Paint = function()
										draw.RoundedBox(4,0,0,BuyClothesButton:GetWide(),BuyClothesButton:GetTall(),Color( 60, 60, 60, 155 ))
										draw.RoundedBox(4,1,1,BuyClothesButton:GetWide()-2,BuyClothesButton:GetTall()-2,Color(OCRP_Options.Color.r + 20,OCRP_Options.Color.g + 20,OCRP_Options.Color.b + 20,155))
										
										local struc = {}
										struc.pos = {}
										struc.pos[1] = 50 -- x pos
										struc.pos[2] = 7 -- y pos
										struc.color = Color(255,255,255,255) -- Red
										struc.text = "Select" -- Text
										struc.font = "UIBold" -- Font
										struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
										struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
										draw.Text( struc )
									end
		BuyClothesButton.DoClick = function()
										RunConsoleCommand("AddToWardrobe", k, v["Regular"], "Regular", "Extra")
										MdlFrame:Remove()
									end
		
		MainClothes:AddItem( ClothesList )
	end
end	

function RunStartModel( umsg )
	OCRP_Start_Model()
end
usermessage.Hook("ocrp_showstartmodel", RunStartModel)
