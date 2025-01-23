--==================================================
--Knockout Script, GMod10 Edition
--By Kalinium
--==================================================
--Now with 100% less +forward
--Don't install this garry.

--Maximium health to be knocked out in
--==================================================
--Knockout Script, GMod10 Edition
--By Kalinium
--==================================================
--Now with 100% less +forward
--Don't install this garry.

--Maximium health to be knocked out in
healthLim = 33
--Minimum KO length (seconds)
minL = 30
--Maximum KO length (seconds)
maxL = 31
--Tell them how long they're gone for
tellLength = false
 


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
	ent:SetName( "plkoragdoll" )
	ent:Spawn()
	ent:Activate() 
	i:StoreWeapons2()
	i:Lock()
	i:StripWeapons()
	i:Spectate(3)
	i:SpectateEntity(ent)
	i:SetNWBool( "KOed", true )
	
	LEMON.DrugPlayer( i, 4 )

	i:DrawViewModel( false )
	i:DrawWorldModel( false )

	
	if(not len) then timerA = math.ceil(math.random(addL))+minL else timerA = len end
	timerB = math.ceil(math.random(9999))
	
	timer.Create(tostring(timerB),timerA,0,WakeUp,i,ent,timerB)
end

function pSpawn( i )
	
	if(spawnPos[i]) then 
		i:SetPos(spawnPos[i]:GetPos())
		spawnPos[i]:Remove()
		spawnPos[i] = false
	end
  
end
hook.Add("PlayerSpawn","PlayerSpawned",pSpawn)

function pHurt(user, attacker)

	if(attacker:GetActiveWeapon():GetClass() == "hands" or attacker:GetActiveWeapon():GetClass() == "melee_fs_crowbar" and user:Health() < healthLim) then
		if(user:Health()>0) then
			KnockOut(user)
		end
	end

end 

hook.Add("PlayerHurt","hurtPlayer",pHurt)

function WakeUp(i, ent, timerN)

		i:UnLock()
		i:KillSilent()
		i:DrawViewModel( true )
		i:DrawWorldModel( true )
		i:SetNWBool( "KOed", false )
		spawnPos[i] = ent
		timer.Remove(tostring(timerN))
		i:ConCommand( "rp_readkostorage" )

end

function setLength( i, command, arg )
	if(i:IsAdmin()) then
		a = string.sub(arg[1],1,string.find(arg[1],",")-1)
		b = string.sub(arg[1],string.find(arg[1],",")+1)
		minL = a
		maxL = b
		addL = a - b
	end
end
  
concommand.Add( "ko_prob", setLength ) 
 
function setHealth( i, command, arg )
	if(i:IsAdmin()) then
		lim = tonumber(arg[1])
		if(lim > 100) then lim = 100 end
		healthLim = lim
	end
end
  
concommand.Add( "ko_health", setHealth ) 

function adminKO( i, command, arg )
	if(i:IsAdmin()) then
		a = string.sub(arg[1],1,string.find(arg[1],",")-1)
		b = string.sub(arg[1],string.find(arg[1],",")+1)
		a = player.GetByID(a)
		KnockOut(a,b)
	end
end
  
concommand.Add( "ko_adminko", adminKO ) 