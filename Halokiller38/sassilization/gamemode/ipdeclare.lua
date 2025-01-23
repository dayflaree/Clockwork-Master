require("socket")

function tcpSend(addr,port,what)
	local s = socket.connect(addr,port)
	if !s then Error( "Failed to connect to "..addr..":"..port, "\n" ) end
	s:send(what)
	s:close()
	return true
end

function tcpReturn( where, what )
	if !where then return end
	where:send( what )
	where:close()
	return true
end

ServerList = {}

function InitServerList()
	print( "SERVERIP = ", GetConVar("ip"):GetString() )
	SERVERIP = GetConVar("ip"):GetString()
	tmysql.query("SELECT * FROM sa_servers",
	function( res, status, err )
		
		for k, v in pairs(res) do
			local server = {
				id = tonumber(v[1]),
				ip = v[4],
				port = v[5],
				chatport = v[6],
				name = v[8]
			}
				
			if (server.ip == SERVERIP) then
				SERVERID = server.id
				SERVERPORT = server.port
				CHATPORT = server.chatport
			end
			
			ServerList[server.id] = server
		end
		
		LOBBYIP = ServerList[1].ip
		LOBBYPORT = ServerList[1].port
		DATAPORT = "26780"

		if socket then
			datasock = socket.bind(SERVERIP,26780,10)
			print("BIND")
		else
			Error( "Failed to load the socket Module!" )
		end
		
		ResetServerStatus()
		
	end )
end


local packets = {}

function packets.TICKETS( tickets )
	
	print( tickets )
	RunString( tickets )
	
	if !(TICKETS and type( TICKETS ) == "table") then
		
		print( "Invalid Ticket table" )
		TICKETS = {}
		
	else
		
		GAMEMODE.FailSafeTimer = CurTime() + 90
		PrintTable( TICKETS )
		
	end
	
end

function dataServerInit()
	if !datasock then return end
	datasock:settimeout(0)
	local clisock = datasock:accept()
	if !clisock then return end
	data = clisock:receive()
	if !data then return end
	local hp = string.find(data,":")
	if !hp then return end
	local fn = string.sub( data, 1, hp-1 )
	data = string.sub( data, string.find(data,":")+1 )
	args = string.Explode( "|", data )
	if packets[fn] then
		packets[fn](unpack(args))
	end
end
hook.Add("Think","dataTCP",dataServerInit)
