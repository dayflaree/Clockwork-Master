--[[------------------------------------------------------------------------------------------------------------------
	Layers STOOL
		Description: Put entities in different layers.
		Usage: Left click to set the layer of an entity and right click to set the layer you're in yourself.
------------------------------------------------------------------------------------------------------------------]]--

TOOL.Category = "Construction"
TOOL.Name = "#Layers"
TOOL.Command = nil
TOOL.ConfigName = nil

TOOL.ClientConVar[ "layer" ] = 1

if ( CLIENT ) then
	language.Add( "Tool_layers_name", "Layers" )
	language.Add( "Tool_layers_desc", "Construct in multiple layers." )
	language.Add( "Tool_layers_0", "Left click to set the layer of an entity, right click to set the layer you're in yourself." )
	language.Add( "Tool_layers_id", "Layer" )
end

--[[------------------------------------------------------------------------------------------------------------------
	Left click to set the layer of an entity.
------------------------------------------------------------------------------------------------------------------]]--

function TOOL:LeftClick( tr )
	if ( !ValidEntity( tr.Entity ) ) then return false end
	if ( CLIENT ) then return true end
	if ( !Layers.Layers[ self:GetOwner().SelectedLayer ] ) then return false end
	
	local entities = constraint.GetAllConstrainedEntities( tr.Entity )
	
	for _, ent in pairs( entities ) do
		ent:SetLayer( self:GetOwner().SelectedLayer )
	end
	
	return true
end

--[[------------------------------------------------------------------------------------------------------------------
	Right click to set the layer you're in yourself.
------------------------------------------------------------------------------------------------------------------]]--

function TOOL:RightClick( tr )
	if ( !ValidEntity( self:GetOwner() ) ) then return false end
	if ( CLIENT ) then return false end
	if ( !Layers.Layers[ self:GetOwner().SelectedLayer ] ) then return false end
	
	self:GetOwner():SetLayer( self:GetOwner().SelectedLayer )
	
	return false
end

if ( CLIENT ) then
	local layerListControl = vgui.RegisterFile( "vgui/layerlist.lua" )

	function TOOL.BuildCPanel( pnl )	
		layerList = vgui.CreateFromTable( layerListControl )
		pnl:AddPanel( layerList )
		
		timer.Simple( 0.1, function()
			local toolPanel = pnl:GetParent():GetParent()
			toolPanel:SetSpacing( 10 )
			
			local layerManager = vgui.Create( "ControlPanel", toolPanel )
			layerManager:SetName( "Layer management" )
			toolPanel:AddItem( layerManager )
			
			local CreateButton = vgui.Create( "DButton", layerManager )
			CreateButton:SetKeyboardInputEnabled( true )
			CreateButton:SetEnabled( true )
			CreateButton:SetText( "Create new layer" )
			CreateButton.DoClick = function()
				if ( self.HasLayer ) then
					RunConsoleCommand( "layers_destroy" )
				else
					RunConsoleCommand( "layers_create" )
				end
			end
			
			layerManager:AddPanel( CreateButton )
		end )
	end
	
	usermessage.Hook( "layer_created", function( um )
		if ( layerList ) then
			local id, title, owner = um:ReadShort(), um:ReadString(), um:ReadEntity()
			
			if ( owner == LocalPlayer() ) then
				layerList.HasLayer = true
				layerList.CreateButton:SetText( "Remove your layer" )
			end
			
			layerList:AddLayer( id, title, owner )
		end
	end )
	
	usermessage.Hook( "layer_destroyed", function( um )
		if ( layerList ) then
			local layerId = um:ReadShort()
			
			for _, layer in pairs( layerList.List:GetItems() ) do
				if ( layer.Layer.ID == layerId ) then
					if ( layer.Layer.Owner == LocalPlayer() ) then
						layerList.HasLayer = false
						layerList.CreateButton:SetText( "Create new layer" )
					end
					
					layerList.List:RemoveItem( layer )
					
					break
				end
			end
		end
	end )
end