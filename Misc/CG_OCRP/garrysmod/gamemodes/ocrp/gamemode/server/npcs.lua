--Setup the NPC's.
timer.Create( "npc_respawn", 3600, 0, function()
		for _,v in pairs(ents.FindByClass("npc_*")) do 
			v:Remove() 
		end 
		GAMEMODE.Maps[string.lower(tostring(game.GetMap()))].Function() 
end )
function AddNPC(Pos, Ang, cmd, NPC, NPCName, Shopid,timetochange,Mdl)
	if NPC == nil then NPC = ents.Create("npc_citizen") end
	local TheNPC = ents.Create(NPC)
	TheNPC:SetPos( Pos + Vector(0,0,90) )
	TheNPC:SetAngles( Ang )
	TheNPC:Spawn()
	TheNPC:SetMoveType(MOVETYPE_NONE)
	TheNPC:SetSolid( SOLID_BBOX )
	TheNPC:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	TheNPC.TakeDamage = function() TheNPC:SetHealth(9999999999999999999) end
	TheNPC:SetHealth(9999999999999999999)
	if Mdl != nil then
		TheNPC:SetModel( Mdl )
	end
	TheNPC.Cmd = cmd
	TheNPC.Prev = NPCName
	TheNPC.Id = 1
	local npcphys = TheNPC:GetPhysicsObject()
	if npcphys:IsValid() then
		npcphys:EnableMotion(false)
	end

	
	TheNPC.Bubble = ents.Create("prop_physics")
	TheNPC.Bubble:SetModel("models/extras/info_speech.mdl")
	TheNPC.Bubble:SetMoveType( MOVETYPE_NONE )
	TheNPC.Bubble:SetSolid(0)
	TheNPC.Bubble:AddEffects( EF_ITEM_BLINK )
	TheNPC.Bubble:SetParent( TheNPC )
	TheNPC.Bubble:SetPos(TheNPC:GetPos() + Vector(0,0,90))
	TheNPC.Bubble:SetAngles( Ang )
	TheNPC.Bubble.TakeDamage = function() TheNPC.Bubble:SetHealth(9999999999999999999) end
	TheNPC.Bubble:SetHealth(9999999999999999999)
	TheNPC.Bubble:Spawn()
	
	if timetochange == nil then
		timetochange = {Min = 600,Max = 900}
	end
	
	if #Shopid > 1 then
		ID_Vary(TheNPC,Shopid,timetochange)
	else
		TheNPC.Id = Shopid[1]
	end
	
end


function ID_Vary(npc,tbl,timetochange)
	local random1 = table.Random(tbl)
	if random1 != npc.Id then
		npc.Id = random1
	end
	if timetochange == nil then
		timetochange = {Min = 600,Max = 900}
	end
	timer.Simple(math.random(timetochange.Min,timetochange.Max),function() ID_Vary(npc,tbl,timetochange)  end)
end

function PMETA:NearNPC( NPC )
	if self:InVehicle() then return false end
	for k, v in pairs(ents.FindInSphere(self:GetPos(), 100)) do
		if v:IsNPC() then
			if v.Prev == NPC then
				return true
			end
		end
	end
	return false
end

function GM:KeyPress ( ply, key )
	if ply.CantUse then return end
	if key == IN_USE then
		local traceTable = {}
		traceTable.start = ply:GetShootPos();
		traceTable.endpos = traceTable.start + ply:GetAimVector() * 100;
		traceTable.filter = ply;
		traceTable.mask = MASK_OPAQUE_AND_NPCS;
		
		local tr = util.TraceLine(traceTable);
			
		if tr.Entity and tr.Entity:IsValid() and tr.Entity.Cmd then
			if ply:IsPlayer() && !ply.CantUse then
				if tr.Entity.Cmd == "OCRP_ShopMenu" then
					umsg.Start("OCRP_CreateChat", ply)
					umsg.String( tr.Entity.Id )
					umsg.Bool( true )
					umsg.End()					
				elseif tr.Entity.Cmd == "OCRP_NPCTalk" then
					umsg.Start("OCRP_CreateChat", ply)
					umsg.String( tr.Entity.Id )
					umsg.Bool( false )
					umsg.End()
				elseif tr.Entity.Cmd == "OCRP_RelatorMenu" then
					umsg.Start("OCRP_OpenRelatorMenu", ply)
					umsg.End()
				else
					ply:ConCommand(tr.Entity.Cmd)
				end						
				timer.Simple(0.3, function() ply.CantUse = false end)
			end
		end
	end
end
--[[
function GM:OnNPCKilled( victim, killer, weapon )
	local vict = victim
	timer.Simple(30, function() AddNPC(vict:GetPos(),vict:GetAngles(), vict.Cmd,vict:GetClass(),vict.Prev,vict.Id,nil,vict:GetModel()) end)
	victim.Bubble:Remove()
end
]]

concommand.Add("OCRP_RespawnNpcs",function(ply,cmd,args)
	SV_PrintToAdmin( ply, "RESPAWN_NPCS", ply:Nick() .." attempted to run OCRP_RespawnNPCs" )
	if ply:IsAdmin() then
		for _,v in pairs(ents.FindByClass("npc_*")) do 
			v:Remove() 
		end 
		GAMEMODE.Maps[string.lower(tostring(game.GetMap()))].Function() 
	end
end)
