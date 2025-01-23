/*-------------------------------------------------------------------------------------------------------------------------
	Clientside store core
-------------------------------------------------------------------------------------------------------------------------*/

// Includes
include( "store_shared.lua" )
include( "vgui/dframetransparent.lua" )
include( "vgui/storeitem.lua" )
include( "vgui/itempreview.lua" )
include( "items/hats.lua" )
include( "items/models.lua" )
include( "items/trails.lua" )

// Open store when F2 is pressed
hook.Add( "ShowTeam", "OpenStore", function()
	if ( !store.window ) then
		store.Create()
	else
		store.window:SetVisible( true )
	end
	
	return true
end )

// Create store window
function store.Create()	
	store.window = vgui.Create( "DFrameTransparent" )
	store.window:SetSize( 800, 600 )
	store.window:SetPos( ScrW() / 2 - store.window:GetWide() / 2, ScrH() / 2 - store.window:GetTall() / 2 )
	store.window:SetTitle( "Item Store" )
	store.window:ShowCloseButton( true )
	store.window:SetDraggable( false )
	store.window:SetDeleteOnClose( false )
	store.window:MakePopup()
	
	surface.SetFont( "DefaultBold" )
	local sx = surface.GetTextSize( store.money .. " coins" ) + 21
	
	store.coins = vgui.Create( "DImage", store.window )
	store.coins:SetImage( "vgui/coins" )
	store.coins:SizeToContents()
	store.coins:SetPos( store.window:GetWide() - 10 - sx, 33 )
	store.moneylabel = vgui.Create( "DLabel", store.window )
	store.moneylabel:SetText( store.money .. " coins" )
	store.moneylabel:SetFont( "DefaultBold" )
	store.moneylabel:SizeToContents()
	store.moneylabel:SetPos( store.window:GetWide() - 10 - sx + 21, 33 )
	store.moneylabel:SetTextColor( Color( 255, 255, 255, 255 ) )
	
	store.tabs = vgui.Create( "DPropertySheet", store.window )
	store.tabs:SetPos( 7, 30 )
	store.tabs:SetSize( 500, store.window:GetTall() - 37 )
	store.tabs:AddSheet( "Hats", store.CreateHatTab(), "vgui/rosette", false, false, "Hat section." )
	store.tabs:AddSheet( "Trails", store.CreateTrailsTab(), "vgui/rainbow", false, false, "Trail section." )
	store.tabs:AddSheet( "Models", store.CreateModelsTab(), "gui/silkicons/user", false, false, "Models section." )
	//store.tabs:AddSheet( "Power-ups", vgui.Create( "DLabel" ), "gui/silkicons/add", false, false, "Power-up section." )
	
	store.preview = vgui.Create( "ItemPreview", store.window )
	store.preview:SetAnimated( true )
	store.preview:SetAnimSpeed( 1 )
	store.preview:SetPos( 400, 80 )
	store.preview:SetModel( LocalPlayer():GetModel() )
	store.preview:SetSize( 500, 500 )
	store.preview:SetCamPos( Vector( 60, 60, 84 ) )
	store.preview:SetLookAt( Vector( 0, 0, 40 ) )
	store.preview:SetHat( store.hat )
end

usermessage.Hook( "STORE_MONEY", function( um )
	store.money = um:ReadLong()
	
	if ( store.window ) then
		// Update money label
		surface.SetFont( "DefaultBold" )
		local sx = surface.GetTextSize( store.money .. " coins" ) + 21
		
		store.moneylabel:SetText( store.money .. " coins" )
		store.moneylabel:SizeToContents()
		store.moneylabel:SetPos( store.window:GetWide() - 10 - sx + 21, 33 )
		store.coins:SetPos( store.window:GetWide() - 10 - sx, 33 )
		
		store.hatcontainer:InvalidateLayout()
		store.modelscontainer:InvalidateLayout()
		store.trailscontainer:InvalidateLayout()
	end
end )

usermessage.Hook( "STORE_HATS", function( um )
	store.ownedhats = store.ItemStringToTable( um:ReadString() )
	
	if ( store.window ) then
		store.hatcontainer:InvalidateLayout()
	end
end )

usermessage.Hook( "STORE_HAT", function( um )
	store.hat = store.hats[ um:ReadLong() ]
	
	if ( store.window ) then
		store.preview:SetHat( store.hat )
	end
end )

usermessage.Hook( "STORE_MODELS", function( um )
	store.ownedmodels = store.ItemStringToTable( um:ReadString() )
	
	if ( store.window ) then
		store.modelscontainer:InvalidateLayout()
	end
end )

usermessage.Hook( "STORE_MODEL", function( um )
	store.model = store.models[ um:ReadLong() ]
	
	if ( store.window ) then
		store.preview:SetModel( ( store.model and store.model.id != 1 ) and store.model.model or store.DefaultModel( LocalPlayer() ) )
	end
end )

usermessage.Hook( "STORE_TRAILS", function( um )
	store.ownedtrails = store.ItemStringToTable( um:ReadString() )
	
	if ( store.window ) then
		store.trailscontainer:InvalidateLayout()
	end
end )

usermessage.Hook( "STORE_TRAIL", function( um )
	store.trail = store.trails[ um:ReadLong() ]
	
	if ( store.window ) then
		store.preview:SetTrail( store.trail )
	end
end )

// Messages
usermessage.Hook( "STORE_MESSAGE", function( um )
	chat.AddText( Color( 218, 0, 18 ), um:ReadString() )
end )

// Create tab with hats
function store.CreateHatTab()
	store.hatcontainer = vgui.Create( "DPanelList" )
	store.hatcontainer:SetSpacing( 5 )
	store.hatcontainer:SetPadding( 5 )
	store.hatcontainer:EnableHorizontal( false )
	store.hatcontainer:EnableVerticalScrollbar( true )
	
	for _, hat in ipairs( store.hats ) do
		local item = vgui.Create( "StoreItem" )
		item:SetItem( hat, "hat" )
		store.hatcontainer:AddItem( item )
	end
	
	return store.hatcontainer
end

// Create tab with trails
function store.CreateTrailsTab()
	store.trailscontainer = vgui.Create( "DPanelList" )
	store.trailscontainer:SetSpacing( 5 )
	store.trailscontainer:SetPadding( 5 )
	store.trailscontainer:EnableHorizontal( false )
	store.trailscontainer:EnableVerticalScrollbar( true )
	
	for _, trail in ipairs( store.trails ) do
		local item = vgui.Create( "StoreItem" )
		item:SetItem( trail, "trail" )
		store.trailscontainer:AddItem( item )
	end
	
	return store.trailscontainer
end

// Create tab with models
function store.CreateModelsTab()
	store.modelscontainer = vgui.Create( "DPanelList" )
	store.modelscontainer:SetSpacing( 5 )
	store.modelscontainer:SetPadding( 5 )
	store.modelscontainer:EnableHorizontal( false )
	store.modelscontainer:EnableVerticalScrollbar( true )
	
	for _, model in ipairs( store.models ) do
		local item = vgui.Create( "StoreItem" )
		item:SetItem( model, "model" )
		store.modelscontainer:AddItem( item )
	end
	
	return store.modelscontainer
end