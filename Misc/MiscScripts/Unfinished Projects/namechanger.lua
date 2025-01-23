--
--	Overv's awesome name changing script
--

local requestedName = ""

hook.Add( "Think", "NameChanging", function()
	if ( requestedName and #requestedName > 0 ) then
		LocalPlayer():ConCommand( "setinfo name \"" .. requestedName .. "\"" )
	end
end )

hook.Add( "OnPlayerChat", "NewNameSet", function( ply, txt )
	if ( ply == LocalPlayer() and string.Left( txt, 5 ) == ".name" ) then
		requestedName = string.sub( txt, 7 )
	end
end )

concommand.Add( "changename", function( ply, com, args )
	requestedName = args[1]
end )