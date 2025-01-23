--[[
Name: "cl_auto.lua".
Product: "eXperim3nt".
--]]

local MOUNT = MOUNT;

NEXUS:IncludePrefixed("sh_auto.lua");

function ThirdPersonMenu(entity, msg) 
	
	local THM = vgui.Create("DFrame")
	THM:SetPos( 180, 0 )
	THM:SetSize(300, 150)
	THM:SetTitle("Nexus Third Person Menu")
	THM:MakePopup()
	
	local THList = vgui.Create( "DPanelList", THM )
	THList:SetPos( 10,25 )
	THList:SetSize( 280, 600 )
	THList:SetSpacing( 10 ) 
	THList:EnableHorizontal( false )
	THList:EnableVerticalScrollbar( true )
	
	local THD = vgui.Create( "DNumSlider" )
	THD:SetSize( 125, 25 )
	THD:SetText( "Set x" )
	THD:SetMin( 0 ) 
	THD:SetMax( 60 )
	THD:SetDecimals( 0 )
	THD.ValueChanged = function(pSelf, fValue) LocalPlayer():ConCommand("~wstp_back ".. fValue) end
	THList:AddItem( THD )
	
	local THSR = vgui.Create( "DNumSlider" )
	THSR:SetSize( 125, 25 )
	THSR:SetText( "Set y" )
	THSR:SetMin( -30 ) 
	THSR:SetMax( 30 )
	THSR:SetDecimals( 0 )
	THSR.ValueChanged = function(pSelf, fValue) LocalPlayer():ConCommand("~wstp_right ".. fValue) end
	THList:AddItem( THSR )
	
	local THpreset1 = vgui.Create( "DButton" )
	THpreset1:SetText( "OverShoulder View" )
	THpreset1:SetWide( 450 )
	THpreset1.DoClick = function () LocalPlayer():ConCommand("~wstp_back 20") LocalPlayer():ConCommand("~wstp_right 25") surface.PlaySound( "hgn/crussaria/ui/RallyPointPlace.wav" ) end
	THList:AddItem( THpreset1 )
	
	local THpreset2 = vgui.Create( "DButton" )
	THpreset2:SetText( "Behind View" )
	THpreset2:SetWide( 450 )
	THpreset2.DoClick = function () LocalPlayer():ConCommand("~wstp_back 40") LocalPlayer():ConCommand("~wstp_right 0") surface.PlaySound( "hgn/crussaria/ui/RallyPointPlace.wav" ) end
	THList:AddItem( THpreset2 )
end

concommand.Add("ws_ThirdPersonMenu", ThirdPersonMenu)