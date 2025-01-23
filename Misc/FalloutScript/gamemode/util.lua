-------------------------------
-- LemonadeScript
-- Author: LuaBanana and Looter
-- Project Start: 5/24/2008
--
-- util.lua
-- Contains important server functions.
-------------------------------

function FreezeRagdoll( ent )

	--THIS SHIT IS FROM GARRY'S STATUE TOOL
	
	if( ent:GetTable().StatueInfo ) then
		return;
	end
 	 
 	ent:GetTable().StatueInfo = {} 
 	ent:GetTable().StatueInfo.Welds = {} 
 	 
 	local bones = ent:GetPhysicsObjectCount() 
 	 
 	local forcelimit = 0 
 	 

 	for bone=1, bones do 
 	 
 		local bone1 = bone - 1 
 		local bone2 = bones - bone 
 		 

 		if ( !ent:GetTable().StatueInfo.Welds[bone2] ) then 
 		 
 			local constraint1 = constraint.Weld( ent, ent, bone1, bone2, forcelimit ) 
 			 
 			if ( constraint1 ) then 
 			 
 				ent:GetTable().StatueInfo.Welds[bone1] = constraint1 
 			 
 			end 
 			 
 		end 
 		 
 		local constraint2 = constraint.Weld( ent, ent, bone1, 0, forcelimit ) 
 		 
 		if ( constraint2 ) then 
 		 
 			ent:GetTable().StatueInfo.Welds[bone1+bones] = constraint2 
 		 
 		end 
 		 
 	end 

end


function string.explode(str)

	local rets = {};
	
	for i=1, string.len(str) do
	
		rets[i] = string.sub(str, i, i);
		
	end
	
	return rets;

end

function LEMON.ReferenceFix(data)

	if(type(data) == "table") then
	
		return table.Copy(data);
		
	else
	
		return data;
		
	end
	
end

function LEMON.NilFix(val, default)

	if(val == nil) then
	
		return default;
	
	else
	
		return val;
		
	end
	
end
-- Handles most of the time. Requires daylight.lua for some reason.... I commented out the sun code in it btw.
function LEMON.InitTime() -- Load the time from a text file or default value, this occurs on gamemode initialization.

	local clumpedtime = "1 1 2200 1"
	
	if(file.Exists("FalloutScript/time.txt")) then
	
		clumpedtime = file.Read("FalloutScript/time.txt")
		
	else
	
		file.Write("FalloutScript/time.txt", "3 1 2254 1")
		
	end
	
	local unclumped = string.Explode(" ", clumpedtime)
	LEMON.ClockDay = tonumber(unclumped[1])
	LEMON.ClockMonth = tonumber(unclumped[2])
	LEMON.ClockYear = tonumber(unclumped[3])
	LEMON.ClockMins = tonumber(unclumped[4])
	
	SetGlobalString("time", "Loading..")
	
end

function LEMON.SaveTime()

	local clumpedtime = LEMON.ClockDay .. " " .. LEMON.ClockMonth .. " " .. LEMON.ClockYear .. " " .. LEMON.ClockMins
	file.Write("FalloutScript/time.txt", clumpedtime)
	
end

function LEMON.SendTime()

	local nHours = string.format("%02.f", math.floor(LEMON.ClockMins / 60 ));
	local nMins = string.format("%02.f", math.floor(LEMON.ClockMins - (nHours * 60 )));
	
	if(tonumber(nHours) > 12) then 
	
		nHours = nHours - 12
		timez = "PM";
		
	else
	
		timez = "AM";
		
	end
	
	if(tonumber(nHours) == 0) then
	
		nHours = 12
		
	end
	
	SetGlobalString( "time", nHours .. ":" .. nMins .." ".. timez .." ".. LEMON.ClockMonth .. "/" .. LEMON.ClockDay .. "/" .. LEMON.ClockYear )
	
end



function LEMON.FindPlayer(name)

	local ply = nil;
	local count = 0;
	
	for k, v in pairs(player.GetAll()) do
	
		if(string.find(v:Nick(), name) != nil) then
			
				ply = v;
				
		end
			
		if(string.find(v:Name(), name) != nil) then
			
			ply = v;
				
		end
			
	end
	
	return ply;
	
end
