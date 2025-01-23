--==================================================
--Knockout Script, GMod10 Edition
--By Kalinium
--==================================================
--Now with 100% less +forward
--Don't install this garry.
KOweps =
{
	"hands",
	"melee_fs_crowbar",
	"weapon_ar2",
	"weapon_pistol"
}
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
	
	local weps={}
	for k, v in pairs(i:GetWeapons()) do
		table.insert(weps,v:GetClass())
	end
	
	ent:SetModel( i:GetModel() )
	ent:SetKeyValue( "origin", i:GetPos().x .. " " .. i:GetPos().y .. " " .. i:GetPos().z )
	ent:Spawn()
	ent:SetName( "plkoragdoll" )
	ent:Activate() 
	i:DrawViewModel( false )
	i:DrawWorldModel( false )
	i:Spectate(4)
	i:SpectateEntity(ent)
	i:SetNWBool( "KOed", true )
	i.Weps = weps
	LEMON.DrugPlayer( i, 4 )
	--i:Freeze( true )

	if(not len) then timerA = math.ceil(math.random(addL))+minL else timerA = len end
	timerB = math.ceil(math.random(9999))
	
	if(tellLength) then i:SendLua("GAMEMODE:AddNotify(\"You will awaken in "..timerA.." seconds\", NOTIFY_GENERIC, 5) surface.PlaySound(\"player/pl_fallpain3.wav\")") end
	
	timer.Create(tostring(timerB),timerA,0,WakeUp,i,ent,timerB)
end
concommand.Add( "rp_knockout", KnockOut )
function pSpawn( i )
	--i:PrintMessage( 1, tostring(spawnPos[i]) )
	
	if(spawnPos[i]) then 
		i:SetPos(spawnPos[i]:GetPos())
		spawnPos[i]:Remove()
		spawnPos[i] = false
	end
end
hook.Add("PlayerSpawn","PlayerSpawned",pSpawn)



function pHurt(user, attacker)
for j, l in pairs(KOweps) do
	if( user:Health() < healthLim ) then --attacker:IsPlayer() or attacker:IsNPC() and attacker:GetActiveWeapon() == l and 
		if(user:Health()>0) then
			KnockOut(user)
		end
	end
end
end 

hook.Add("PlayerHurt","hurtPlayer",pHurt)

function WakeUp(i, ent, timerN)
	--rnd = math.ceil(math.random(100))
	--i:SendLua("GAMEMODE:AddNotify(\""..rnd.."\", NOTIFY_GENERIC, 5) surface.PlaySound(\"player/pl_fallpain3.wav\")")
	--if(rnd > wakeChance) then
		
		i:Freeze(false)
		--i:PrintMessage( 4, "kill\n" )
		i:KillSilent()
		i:DrawViewModel( true )
		i:DrawWorldModel( true )
		spawnPos[i] = ent
		timer.Remove(tostring(timerN))
		RestoreWeapons( i )
		ent:Remove()

				

	--end
end

function setLength( i, command, arg )
	if(i:IsAdmin()) then
		a = string.sub(arg[1],1,string.find(arg[1],",")-1)
		b = string.sub(arg[1],string.find(arg[1],",")+1)
		minL = a
		maxL = b
		addL = a - b
		--i:SendLua("GAMEMODE:AddNotify(\"Length changed\", NOTIFY_GENERIC, 5) surface.PlaySound(\"ambient/water/drip1.wav\")")
	end
end
  
concommand.Add( "ko_prob", setLength ) 
function RestoreWeapons(ply)
	--local i = playerid
	--i:StripWeapons()
ply:GetTable().ForceGive = true
	local wep = ply.Weps
	for i=1, #wep, 1 do
		ply:Give(wep[i])
	end	
ply:GetTable().ForceGive = false
end
function setHealth( i, command, arg )
	if(i:IsAdmin()) then
		lim = tonumber(arg[1])
		if(lim > 100) then lim = 100 end
		healthLim = lim
		--i:SendLua("GAMEMODE:AddNotify(\"Knockout health changed to "..lim.."\", NOTIFY_GENERIC, 5) surface.PlaySound(\"ambient/water/drip1.wav\")")
	end
end
  
concommand.Add( "ko_health", setHealth ) 

function adminKO( i, command, arg )
	if(i:IsAdmin()) then
		a = string.sub(arg[1],1,string.find(arg[1],",")-1)
		b = string.sub(arg[1],string.find(arg[1],",")+1)
		a = player.GetByID(a)
		KnockOut(a,b)
		--i:SendLua("GAMEMODE:AddNotify(\"Player KO'd\", NOTIFY_GENERIC, 5) surface.PlaySound(\"ambient/water/drip1.wav\")")
	end
end
  
concommand.Add( "ko_adminko", adminKO ) 