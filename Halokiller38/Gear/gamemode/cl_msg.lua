
function CreateClientMessages()

	for k, v in pairs( msgs ) do
	
		if( type( v ) == "function" ) then
		
			local funcname = k;
			usermessage.Hook( funcname, v );
		
		end
	
	end

end