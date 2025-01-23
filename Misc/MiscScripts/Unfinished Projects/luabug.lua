local luabug = {}

function luabug:Open()
	if ( luabug.Frame ) then luabug.Frame:SetVisible( true ) return end
	
	local frame = vgui.Create( "DFrame" )
	frame:SetTitle( "LuaBug" )
	frame:SetSize( 600, 500 )
	frame:SetPos( 50, ScrH() / 2 - frame:GetTall() / 2 )
	frame:MakePopup()
	
	luabug.Frame = frame
	
	frame.tabs = vgui.Create( "DPropertySheet", frame )
	frame.tabs:SetPos( 5, 30 )
	frame.tabs:SetSize( frame:GetWide() - 10, frame:GetTall() - 35 )
	
	self:CreateHooksTab()
end

function luabug:CreateHooksTab()
	local tab = vgui.Create( "DPanel" )
	
	local hooks = vgui.Create( "DListView", tab )
	hooks:SetPos( 0, 0 )
	hooks:SetSize( self.Frame:GetWide() - 20, self.Frame:GetTall() - 65 )
	hooks:SetMultiSelect( false )
	hooks:AddColumn( "Name" )
	hooks:AddColumn( "Identifier" )
	hooks:AddColumn( "Last call" )
	
	for name, hooklist in pairs( hook.GetTable() ) do
		for identifier in pairs( hooklist ) do
			hooks:AddLine( name, identifier, "None." )
		end
	end
	
	self.HookList = hooks
		
	self.Frame.tabs:AddSheet( "Hooks", tab, "gui/silkicons/exclamation", false, false, "List of active hooks." )
end

concommand.Add( "luabug", function()
	if ( CLIENT ) then
		luabug:Open()
	end
end )

if ( !HOOKCALL ) then HOOKCALL = hook.Call end

function hook.Call( name, gm, ... )
	if ( luabug.HookList.GetLines ) then
		for _, line in ipairs( luabug.HookList:GetLines() ) do
			if ( line:GetValue( 1 ) == name ) then
				line:SetValue( 3, CurTime() )
			end
		end
	end
	
	return HOOKCALL( name, gm, ... )
end