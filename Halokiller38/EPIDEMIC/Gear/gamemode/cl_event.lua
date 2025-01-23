
--The event table is just a way for me to interact with certain umsgs easier.
function CreateClientEvents()

	for k, v in pairs( event ) do
	
		if( type( v ) == "function" ) then
		
			local funcname = k;
			usermessage.Hook( "_" .. funcname, v );
		
		end
	
	end
	
end