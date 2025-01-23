--[[
	© 2012 Slidefuse.net do not share, re-distribute or modify
	without permission of its author (spencer@sf-n.com).
--]]

SF.dataHooks = {};
SF.netDebug = false;

SF.netCache = {};

if (datastream) then
	if (SERVER) then

		function SF:AcceptStream(player, data, id)
			return true;
		end;

		function SF:NetAll(name, data)
			players = _player.GetAll();
			datastream.StreamToClients(players, name, data);
		end;	
		
		function SF:Net(player, name, data)
			if (!player or player == nil) then
				SF:Log("---ERROR! Datastream: '"..name.."' players table is nil!");
				return false;
			end;
			datastream.StreamToClients(player, name, data);
		end;

		function SF:NetHook(name, Callback)
			self.dataHooks[name] = Callback;
			datastream.Hook(name, function (player, handler, id, encoded, decoded)
				self.dataHooks[name](player, decoded);
			end);
		end;	
		
	else

		function SF:NetHook(name, Callback)
			self.dataHooks[name] = Callback;
			datastream.Hook(name, function(handler, id, encoded, decoded)
				self.dataHooks[name](decoded)
			end);
		end;	

		function SF:Net(name, data)
			datastream.StreamToServer(name, data);
		end;
		
	end;
else
	if (SERVER) then

		function SF:NetAll(name, data)
			net.Start(name)
				net.WriteTable(data);
			net.Send(_player.GetAll());
		end;	
		
		function SF:Net(player, name, data)

			util.AddNetworkString(name);

			if (!player or player == nil) then
				SF:Log("---ERROR! NETWORK: '"..name.."' players table is nil!");
				return false;
			end;
			net.Start(name)
				net.WriteTable(data);
			net.Send(player);

			if (self.netDebug) then
				print("_ SERVER _ SF-NET: Sent '"..name.."'\n");
			end;
		end;

		function SF:NetHook(name, Callback)

			self.dataHooks[name] = Callback;
			net.Receive(name, function(len, player)
				if (self.netDebug) then
					print("_ SERVER _ SF-NET: Recieved '"..name.."' Stream ("..len.."B)\n");
				end;
				local recTable = net.ReadTable();
				self.dataHooks[name](player, recTable, len);
			end);
		end;	
		
	else

		function SF:NetHook(name, Callback)
			
			self.dataHooks[name] = Callback;

			net.Receive(name, function(len)
				if (self.netDebug) then
					print("_ CLIENT _ SF-NET: Receieved '"..name.."' Stream ("..len.."B)\n");
				end;
				self.dataHooks[name](net.ReadTable(), len);
			end);
		end;	

		function SF:Net(name, data)
			net.Start(name)
				net.WriteTable(data);
			net.SendToServer();
			if (self.netDebug) then
				print("_ CLIENT _ SF-NET: Sent '"..name.."'\n");
			end;
		end;
		
	end;
end;