--[[
	� 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local Clockwork = Clockwork;
local net = net;
local ErrorNoHalt = ErrorNoHalt;
local pairs = pairs;
local pcall = pcall;
local type = type;
local util = util;

Clockwork.datastream = Clockwork.kernel:NewLibrary("Datastream");
Clockwork.datastream.stored = Clockwork.datastream.stored or {};

if (DBugR) then
	DBugR.Profilers.Datastream = table.Copy(DBugR.SP);
	DBugR.Profilers.Datastream.CChan = "";
	DBugR.Profilers.Datastream.Name = "Datastream";
	DBugR.Profilers.Datastream.Type = SERVICE_PROVIDER_TYPE_NET;

	DBugR.Profilers.DatastreamPerf = table.Copy(DBugR.SP);
	DBugR.Profilers.DatastreamPerf.Name = "Datastream";
	DBugR.Profilers.DatastreamPerf.Type = SERVICE_PROVIDER_TYPE_CPU;
end;

--[[
	@codebase Shared
	@details A function to hook a data stream.
	@param String A unique identifier.
	@param Function The datastream callback.
	@returns Bool Whether or not the tables are equal.
--]]
function Clockwork.datastream:Hook(name, Callback)
	self.stored[name] = Callback;
end;

if (DBugR) then
	local oldDS = Clockwork.datastream.Hook;

	for name, func in pairs(Clockwork.datastream.stored) do
		Clockwork.datastream.stored[name] = nil;

		oldDS(Clockwork.datastream, name, DBugR.Util.Func.AttachProfiler(func, function(time) 
			DBugR.Profilers.DatastreamPerf:AddPerformanceData(tostring(name), time, func);
		end));
	end;

	Clockwork.datastream.Hook = DBugR.Util.Func.AddDetourM(Clockwork.datastream.Hook, function(datastream, name, func, ...) 
		func = DBugR.Util.Func.AttachProfiler(func, function(time) 
			DBugR.Profilers.DatastreamPerf:AddPerformanceData(tostring(name), time, func);
		end);

		return datastream, name, func, ...;
	end);
end;

if (SERVER) then
	util.AddNetworkString("cwDataDS");

	-- A function to start a data stream.
	function Clockwork.datastream:Start(player, name, data)
		local recipients = {};
		local bShouldSend = false;
	
		if (type(player) != "table") then
			if (!player) then
				player = _player.GetAll();
			else
				player = {player};
			end;
		end;
		
		for k, v in pairs(player) do
			if (type(v) == "Player") then
				recipients[#recipients + 1] = v;
				
				bShouldSend = true;
			elseif (type(k) == "Player") then
				recipients[#recipients + 1] = k;
			
				bShouldSend = true;
			end;
		end;
		
		if (data == nil) then data = 0; end;
		
		local dataTable = {data = data};
		local encodedData = Clockwork.kernel:Serialize(dataTable);
			
		if (encodedData and #encodedData > 0 and bShouldSend) then
			net.Start("cwDataDS");
				net.WriteString(name);
				net.WriteUInt(#encodedData, 32);
				net.WriteData(encodedData, #encodedData);
			net.Send(recipients);
		end;
	end;

	if (DBugR) then
		Clockwork.datastream.Start = DBugR.Util.Func.AddDetour(Clockwork.datastream.Start, function(datastream, player, name, data)
			if (data == nil) then data = 0; end;
			
			local dataTable = {data = data};
			local encodedData = pon.encode(dataTable);

			DBugR.Profilers.Datastream:AddNetData(name, #encodedData);
		end);
	end;

	net.Receive("cwDataDS", function(length, player)
		local CW_DS_NAME = net.ReadString();
		local CW_DS_LENGTH = net.ReadUInt(32);
		local CW_DS_DATA = net.ReadData(CW_DS_LENGTH);
		
		if (CW_DS_NAME and CW_DS_DATA and CW_DS_LENGTH) then
			player.cwDataStreamName = CW_DS_NAME;
			player.cwDataStreamData = "";
			
			if (player.cwDataStreamName and player.cwDataStreamData) then
				player.cwDataStreamData = CW_DS_DATA;
				
				if (Clockwork.datastream.stored[player.cwDataStreamName]) then
					local bSuccess, value = pcall(Clockwork.kernel.Deserialize, Clockwork.kernel, player.cwDataStreamData);
					
					if (bSuccess) then
						Clockwork.datastream.stored[player.cwDataStreamName](player, value.data);
					elseif (value != nil) then
						ErrorNoHalt("[Clockwork] The '"..CW_DS_NAME.."' datastream has failed to run.\n"..value.."\nData: "..tostring(player.cwDataStreamData).."\n");
					end;
				end;
				
				player.cwDataStreamName = nil;
				player.cwDataStreamData = nil;
			end;
		end;
		
		CW_DS_NAME, CW_DS_DATA, CW_DS_LENGTH = nil, nil, nil;
	end);
else
	-- A function to start a data stream.
	function Clockwork.datastream:Start(name, data)
		if (data == nil) then data = 0; end;
		
		local dataTable = {data = data};
		local encodedData = Clockwork.kernel:Serialize(dataTable);
		
		if (encodedData and #encodedData > 0) then
			net.Start("cwDataDS");
				net.WriteString(name);
				net.WriteUInt(#encodedData, 32);
				net.WriteData(encodedData, #encodedData);
			net.SendToServer();
		end;
	end;

	if (DBugR) then
		Clockwork.datastream.Start = DBugR.Util.Func.AddDetour(Clockwork.datastream.Start, function(datastream, name, data)
			if (data == nil) then data = 0; end;
			
			local dataTable = {data = data};
			local encodedData = pon.encode(dataTable);

			DBugR.Profilers.Datastream:AddNetData(name, #encodedData);
		end);
	end;

	net.Receive("cwDataDS", function(length)
		local CW_DS_NAME = net.ReadString();
		local CW_DS_LENGTH = net.ReadUInt(32);
		local CW_DS_DATA = net.ReadData(CW_DS_LENGTH);

		if (CW_DS_NAME and CW_DS_DATA and CW_DS_LENGTH) then			
			if (Clockwork.datastream.stored[CW_DS_NAME]) then
				local bSuccess, value = pcall(Clockwork.kernel.Deserialize, Clockwork.kernel, CW_DS_DATA);
			
				if (bSuccess) then
					Clockwork.datastream.stored[CW_DS_NAME](value.data);
				elseif (value != nil) then
					ErrorNoHalt("[Clockwork] The '"..CW_DS_NAME.."' datastream has failed to run.\n"..value.."\nData: "..tostring(CW_DS_DATA).."\n");
				end;
			end;
		end;
		
		CW_DS_NAME, CW_DS_DATA, CW_DS_LENGTH = nil, nil, nil;
	end);
end;