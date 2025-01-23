--==================================================
--Knockout Script, GMod10 Edition
--By Kalinium
--==================================================
--Now with 100% less +forward
--Don't install this garry.

--Maximium health to be knocked out in
healthLim = 50
--Minimum KO length (seconds)
minL = 30
--Maximum KO length (seconds)
maxL = 31
--Tell them how long they're gone for
tellLength = true
 


addL = maxL - minL
spawnPos = {}
playerTimer = {}
playerLength = {}

function KnockOut(playerid, len)

	local i = playerid


	local ent = ents.Create( "prop_ragdoll" )
	if not ent:IsValid() then return end
	
	ent:SetModel( i:GetModel() )
	ent:SetKeyValue( "origin", i:GetPos().x .. " " .. i:GetPos().y .. " " .. i:GetPos().z )
	ent:Spawn()
	ent:Activate() 
	
	i:Lock()
	i:StripWeapons()
	i:Spectate(3)
	i:SpectateEntity(ent)

	i:DrawViewModel( false )
	i:DrawWorldModel( false )
	i:SendLua("GAMEMODE:AddNotify(\"You have been knocked unconcious\", NOTIFY_GENERIC, 5) surface.PlaySound(\"player/pl_fallpain3.wav\")")
	
	if(not len) then timerA = math.ceil(math.random(addL))+minL else timerA = len end
	timerB = math.ceil(math.random(9999))
	
	if(tellLength) then i:SendLua("GAMEMODE:AddNotify(\"You will awaken in "..timerA.." seconds\", NOTIFY_GENERIC, 5) surface.PlaySound(\"player/pl_fallpain3.wav\")") end
	
	timer.Create(tostring(timerB),timerA,0,WakeUp,i,ent,timerB)
end

function pSpawn( i )
	--i:PrintMessage( 1, tostring(spawnPos[i]) )
	
	if(spawnPos[i]) then 
		i:SetPos(spawnPos[i]:GetPos())
		spawnPos[i]:Remove()
		spawnPos[i] = false
	end
  
end
hook.Add("PlayerSpawn","PlayerSpawned",pSpawn)

function pHurt(user)
	if(user:Health() < healthLim) then
		if(user:Health()>0) then
			KnockOut(user)
		end
	end
end 

hook.Add("PlayerHurt","hurtPlayer",pHurt)

function WakeUp(i, ent, timerN)
	--rnd = math.ceil(math.random(100))
	--i:SendLua("GAMEMODE:AddNotify(\""..rnd.."\", NOTIFY_GENERIC, 5) surface.PlaySound(\"player/pl_fallpain3.wav\")")
	--if(rnd > wakeChance) then
		i:SendLua("GAMEMODE:AddNotify(\"You are awake\", NOTIFY_GENERIC, 5) surface.PlaySound(\"player/pl_fallpain3.wav\")")

		i:UnLock()
		--i:PrintMessage( 4, "kill\n" )
		i:KillSilent()
		i:DrawViewModel( true )
		i:DrawWorldModel( true )
		spawnPos[i] = ent
		timer.Remove(tostring(timerN))
	--end
end

function setLength( i, command, arg )
	if(i:IsAdmin()) then
		a = string.sub(arg[1],1,string.find(arg[1],",")-1)
		b = string.sub(arg[1],string.find(arg[1],",")+1)
		minL = a
		maxL = b
		addL = a - b
		i:SendLua("GAMEMODE:AddNotify(\"Length changed\", NOTIFY_GENERIC, 5) surface.PlaySound(\"ambient/water/drip1.wav\")")
	end
end
  
concommand.Add( "ko_prob", setLength ) 
 
function setHealth( i, command, arg )
	if(i:IsAdmin()) then
		lim = tonumber(arg[1])
		if(lim > 100) then lim = 100 end
		healthLim = lim
		i:SendLua("GAMEMODE:AddNotify(\"Knockout health changed to "..lim.."\", NOTIFY_GENERIC, 5) surface.PlaySound(\"ambient/water/drip1.wav\")")
	end
end
  
concommand.Add( "ko_health", setHealth ) 

function adminKO( i, command, arg )
	if(i:IsAdmin()) then
		a = string.sub(arg[1],1,string.find(arg[1],",")-1)
		b = string.sub(arg[1],string.find(arg[1],",")+1)
		a = player.GetByID(a)
		KnockOut(a,b)
		i:SendLua("GAMEMODE:AddNotify(\"Player KO'd\", NOTIFY_GENERIC, 5) surface.PlaySound(\"ambient/water/drip1.wav\")")
	end
end
  
concommand.Add( "ko_adminko", adminKO ) 