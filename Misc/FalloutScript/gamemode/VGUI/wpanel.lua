--Thanks Garry :D
/* 
 	Display a simple message box. 
 	 
 	Derma_Message( "Hey Some Text Here!!!", "Message Title (Optional)", "Button Text (Optional)" ) 
 	 
*/ 
function Warning_Message( strTitle, strButtonText ) 
   
	local Window = vgui.Create( "DFrame" ) 
 		Window:SetTitle( strTitle or "Warning" ) 
 		Window:SetDraggable( true ) 
 		Window:ShowCloseButton( true ) 
 		Window:SetBackgroundBlur( false ) 
 		Window:SetDrawOnTop( false ) 
 		 
 	local InnerPanel = vgui.Create( "DPanel", Window ) 
 	 
 	local Text = vgui.Create( "DLabel", InnerPanel ) 
 		Text:SetText( tostring(GetGlobalString( "wreasons" )) ) 
 		Text:SizeToContents() 
 		Text:SetContentAlignment( 5 ) 
 		Text:SetTextColor( color_white ) 
 		 
 	local ButtonPanel = vgui.Create( "DPanel", Window ) 
 	ButtonPanel:SetTall( 30 ) 
 		 
 	local Button = vgui.Create( "DButton", ButtonPanel ) 
 		Button:SetText( strButtonText or "OK" ) 
 		Button:SizeToContents() 
 		Button:SetTall( 20 ) 
 		Button:SetWide( Button:GetWide() + 20 ) 
 		Button:SetPos( 5, 5 ) 
 		Button.DoClick = function() Window:Close() end 
 		 
 	ButtonPanel:SetWide( Button:GetWide() + 10 ) 
 	 
 	local w, h = Text:GetSize() 
 	 
 	Window:SetSize( w + 50, h + 25 + 45 + 10 ) 
 	Window:Center() 
 	 
 	InnerPanel:StretchToParent( 5, 25, 5, 45 ) 
 	 
 	Text:StretchToParent( 5, 5, 5, 5 )	 
 	 
 	ButtonPanel:CenterHorizontal() 
 	ButtonPanel:AlignBottom( 8 ) 
 	 
 	Window:MakePopup() 
 	Window:DoModal() 
 	 
 	return menu 
   
end 
