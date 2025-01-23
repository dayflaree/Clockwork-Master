-- CONFIG
OCRPCfg = {}
--Money CONFIG
Msg( "OCRP: Loading money config...\n" )
OCRPCfg["MoneyTime"] = 120 -- How often should we give the player their paycheck
OCRPCfg["MoneyAmount_C"] = 60 -- How much we should give the citizens on their paycheck
OCRPCfg["MoneyAmount_MA"] = 130 -- How much we should give the mayor on their paycheck
OCRPCfg["MoneyAmount_M"] = 100 -- How much we should give the medics on their paycheck
OCRPCfg["MoneyAmount_P"] = 90 -- How much we should give the police on their paycheck
OCRPCfg["MoneyStart"] = 10000 -- How much the player starts with on there first join
OCRPCfg["MoneyAmount_V_C"] = math.Round(OCRPCfg["MoneyAmount_C"] * 1.25) -- How much we should give the citizens on their paycheck - VIP
OCRPCfg["MoneyAmount_V_MA"] = math.Round(OCRPCfg["MoneyAmount_MA"] * 1.25) -- How much we should give the mayor on their paycheck - VIP
OCRPCfg["MoneyAmount_V_M"] = math.Round(OCRPCfg["MoneyAmount_M"] * 1.25) -- How much we should give the medics on their paycheck - VIP
OCRPCfg["MoneyAmount_V_P"] = math.Round(OCRPCfg["MoneyAmount_P"] * 1.25) -- How much we should give the police on their paycheck - VIP
Msg( "OCRP: Finished loading money config.\n" )
--End of money CONFIG

OCRPCfg["Prop_Limit"] = 40
OCRPCfg["Shop_Limit"] = 15

--Organization CONFIG
Msg( "OCRP: Loading organization config...\n" )
OCRPCfg["Org_MaxUsers"] = 20 -- How many users can be in a org at any one time
OCRPCfg["Org_StartCost"] = 3500 -- How much it costs to buy a organization
Msg( "OCRP: Finished loading organization config.\n" )
--End of organization CONFIG

--General CONFIG
Msg( "OCRP: Loading general config...\n" )
OCRPCfg["MaxDoors"] = 5 -- How many doors can a player have at any one time?
Msg( "OCRP: Finished loading general config.\n" )
--End of general CONFIG.

CosmosFM_DJs = {
 "STEAM_0:0:6717638", -- Darthkatzs
}
 
function PMETA:IsDJ()
	if (SERVER) then
		if self.CosmosFMDJ then
			return true
		else
			return false
		end
	elseif (CLIENT) then
		if self.AmDJ then
			return true
		else
			return false
		end
	end
	return false
end

GM.OCRP_Dialogue = {}

GM.OCRP_Dialogue["Job_Cop001"] = {
Dialogue = {},
Condition = function(ply)  
				if ply:Team() > 1 then
					if ply:Team() == CLASS_POLICE || ply:Team() == CLASS_CHIEF || ply:Team() == CLASS_SWAT then
						return "Quit"
					end
				end
				return 1 
			end,
}
			
GM.OCRP_Dialogue["Job_Cop001"].Dialogue["Full"] = { Question = "All our positions are filled, I'm sorry", YesAnswer = "Oh Ok,", NoAnswer = "You Jerk!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_Cop001"].Dialogue["Job"] = { Question = "Quit your current job first, then we will talk.", YesAnswer = "Oh Ok,", NoAnswer = "But I like this job!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_Cop001"].Dialogue["Quit"] = {Question = "How may I help you today?", YesAnswer = "I'm here to quit.", NoAnswer = "You can't help me.",Condition = function(ply) return true end,Function = function(ply) RunConsoleCommand("OCRP_Job_Quit") return "Exit" end,}

GM.OCRP_Dialogue["Job_Cop001"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I'm looking for work as a cop, are there any positions open?", NoAnswer = "You can't help me.",
Condition = function(ply)
					if ply.InBallot == true then
						return 4
					end
					if ply:Team() > 1 then
						if ply:Team() == CLASS_POLICE || ply:Team() == CLASS_CHIEF || ply:Team() == CLASS_SWAT then
							return "Quit"
						else
							return "Job"
						end
					elseif ply:Team() <= 1 then
						if team.NumPlayers(CLASS_POLICE) < #player.GetAll()/4 then 
							return 2 
						else
							return "Full"
						end
					end
					return "Exit" 
				end,}

GM.OCRP_Dialogue["Job_Cop001"].Dialogue[2] = {Question = "Why yes there are, just sign here.", YesAnswer = "Alright", NoAnswer = "Woah, I just wanted a gun, not a signature.", 
Condition = function(ply)
	if team.NumPlayers(CLASS_POLICE) >= #player.GetAll()/3 then 
		return "Full"
	end 
	return true
end, Function = function(ply) RunConsoleCommand("OCRP_Job_Join",CLASS_POLICE) return 3 end,}-- Return the ending dialogue thing

GM.OCRP_Dialogue["Job_Cop001"].Dialogue[3] = {Question = "Alright, Here is your badge and gear. Good luck.", YesAnswer = "Yea, like I need luck", NoAnswer = "Lets rock.", Condition = function(ply) return true end,Function = function(ply) return "Exit" end,}

GM.OCRP_Dialogue["Job_Cop001"].Dialogue[4] = {Question = "Your in the mayor elections ballot, you cannot join.", YesAnswer = "Oh, okay", NoAnswer = "Well, stuff you!", Condition = function(ply) return true end, Function = function(ply) return "Exit" end, }

GM.OCRP_Dialogue["Job_Fire001"] = {
Dialogue = {},
Condition = function(ply)  
				if ply:Team() > 1 then
					if ply:Team() == CLASS_FIREMAN then
						return "Quit"
					end
				end
				return 1 
			end,
}
GM.OCRP_Dialogue["Job_Fire001"].Dialogue["Full"] = { Question = "All our positions are filled, I'm sorry", YesAnswer = "Oh Ok,", NoAnswer = "You Jerk!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_Fire001"].Dialogue["Job"] = { Question = "Quit your current job first, then we will talk.", YesAnswer = "Oh Ok,", NoAnswer = "But I like this job!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_Fire001"].Dialogue["Quit"] = {Question = "How may I help you today?", YesAnswer = "I'm here to quit.", NoAnswer = "You can't help me.",Condition = function(ply) return true end,Function = function(ply) RunConsoleCommand("OCRP_Job_Quit") return "Exit" end,}

GM.OCRP_Dialogue["Job_Fire001"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I'm looking for work as a fireman, are there any positions open?", NoAnswer = "You can't help me.",
Condition = function(ply)  
					if ply.InBallot == true then
						return 4
					end
					if ply:Team() > 1 then
						if ply:Team() == CLASS_FIREMAN then
							return "Quit"
						else
							return "Job"
						end
					elseif ply:Team() <= 1 then
						if team.NumPlayers(CLASS_FIREMAN) < #player.GetAll()/5 then 
							return 2 
						else
							return "Full"
						end 
					end
					return "Exit" 
				end,
}

GM.OCRP_Dialogue["Job_Fire001"].Dialogue[2] = {Question = "Why yes there are, just sign here.", YesAnswer = "Alright", NoAnswer = "Woah, I just wanted to help people, not sign anything.", 
Condition = function(ply)
	if team.NumPlayers(CLASS_FIREMAN) >= #player.GetAll()/5 then 
		return "Full"
	end
	return true
end, Function = function(ply) RunConsoleCommand("OCRP_Job_Join",CLASS_FIREMAN) return 3 end,}-- Return the ending dialogue thing

GM.OCRP_Dialogue["Job_Fire001"].Dialogue[3] = {Question = "Alright, Here is your equipment. Good luck.", YesAnswer = "Yea, like I need luck", NoAnswer = "Lets rock.", Condition = function(ply) return true end,Function = function(ply) return "Exit" end,}

GM.OCRP_Dialogue["Job_Fire001"].Dialogue[4] = {Question = "Your in the mayor elections ballot, you cannot join.", YesAnswer = "Oh, okay", NoAnswer = "Well, stuff you!", Condition = function(ply) return true end, Function = function(ply) return "Exit" end, }

----
GM.OCRP_Dialogue["Job_Medic001"] = {
Dialogue = {},
Condition = function(ply)  
				if ply:Team() > 1 then
					if ply:Team() == CLASS_MEDIC then
						return "Quit"
					end
				end
				return 1 
			end,
}
GM.OCRP_Dialogue["Job_Medic001"].Dialogue["Full"] = { Question = "All our positions are filled, I'm sorry", YesAnswer = "Oh Ok,", NoAnswer = "You Jerk!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_Medic001"].Dialogue["Job"] = { Question = "Quit your current job first, then we will talk.", YesAnswer = "Oh Ok,", NoAnswer = "But I like this job!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_Medic001"].Dialogue["Quit"] = {Question = "How may I help you today?", YesAnswer = "I'm here to quit.", NoAnswer = "You can't help me.",Condition = function(ply) return true end,Function = function(ply) RunConsoleCommand("OCRP_Job_Quit") return "Exit" end,}

GM.OCRP_Dialogue["Job_Medic001"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I'm looking for work as a paramedic, are there any positions open?", NoAnswer = "You can't help me.",
Condition = function(ply)  
					if ply.InBallot == true then
						return 4
					end
					if ply:Team() > 1 then
						if ply:Team() == CLASS_MEDIC then
							return "Quit"
						else
							return "Job"
						end
					elseif ply:Team() <= 1 then
						if team.NumPlayers(CLASS_MEDIC) < #player.GetAll()/4 then 
							return 2 
						else
							return "Full"
						end 
					end
					return "Exit" 
				end,
}

GM.OCRP_Dialogue["Job_Medic001"].Dialogue[2] = {Question = "Why yes there are, just sign here.", YesAnswer = "Alright", NoAnswer = "Woah, I just wanted to help people, not sign anything.", 
Condition = function(ply)
	if team.NumPlayers(CLASS_MEDIC) >= #player.GetAll()/4 then 
		return "Full"
	end
	return true
end, Function = function(ply) RunConsoleCommand("OCRP_Job_Join",CLASS_MEDIC) return 3 end,}-- Return the ending dialogue thing

GM.OCRP_Dialogue["Job_Medic001"].Dialogue[3] = {Question = "Alright, Here is your equipment. Good luck.", YesAnswer = "Yea, like I need luck", NoAnswer = "Lets rock.", Condition = function(ply) return true end,Function = function(ply) return "Exit" end,}

GM.OCRP_Dialogue["Job_Medic001"].Dialogue[4] = {Question = "Your in the mayor elections ballot, you cannot join.", YesAnswer = "Oh, okay", NoAnswer = "Well, stuff you!", Condition = function(ply) return true end, Function = function(ply) return "Exit" end, }

GM.OCRP_Dialogue["Job_CopCar01"] = {
Dialogue = {},
}

GM.OCRP_Dialogue["Job_CopCar01"].Dialogue["Enough"] = {Question = "Enough cars are out, patrol with someone", YesAnswer = "Oh Ok,", NoAnswer = "I didn't sign up for this.", Condition = function(ply) return true end, Function = function(ply) return "Exit" end, }

GM.OCRP_Dialogue["Job_CopCar01"].Dialogue["Job"] = { Question = "Your not a cop. Scram", YesAnswer = "Oh Ok,", NoAnswer = "And your a meter-maid shove it.", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_CopCar01"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I'm looking for a service vehicle." , NoAnswer = "You can't help me.",
Condition = function(ply)
					if ply:Team() > 1 then
						if ply:Team() == CLASS_POLICE || ply:Team() == CLASS_CHIEF then
							if TotalCopCars() >= ((#team.GetPlayers(CLASS_POLICE) + #team.GetPlayers(CLASS_CHIEF)) / 2) then
								return "Enough"
							end
							return 2
						elseif ply:Team() == CLASS_SWAT then
							return 3
						else
							return "Job"
						end
					else
						return "Job"
					end
					return "Exit" 
				end,
}

GM.OCRP_Dialogue["Job_CopCar01"].Dialogue[2] = {Question = "Which service vehcile would you like?", YesAnswer = "I'll take the Vapid.", NoAnswer = "I'll take the Dodge.", SecondYes = true, Condition = function(ply) return true end,
Function = function(ply) RunConsoleCommand("OCRP_SpawnPolice") return "Exit" end,
Function2 = function(ply) RunConsoleCommand("OCRP_SpawnPoliceNEW") return "Exit" end,}-- Return the ending dialogue thing

GM.OCRP_Dialogue["Job_CopCar01"].Dialogue[3] = {Question = "Here are the keys.", YesAnswer = "Alright", NoAnswer = "Nice.", Condition = function(ply) return true end,Function = function(ply) RunConsoleCommand("OCRP_SpawnSWAT") return "Exit" end,}

GM.OCRP_Dialogue["Job_CopCar01"].Dialogue[4] = {Question = "I see you already have a car.", YesAnswer = "Yea, I'd like to get it fixed, someone broke it.", NoAnswer = "Here have the keys, I don't want it anymore.", SecondYes = true, Condition = function(ply) return true end,
Function = function(ply)
		if ply.OCRPData["CurCar"]:GetModel() == "models/tdmcars/copcar.mdl" then
			RunConsoleCommand("OCRP_SpawnPoliceNEW")
		elseif ply.OCRPData["CurCar"]:GetModel() == "models/sickness/lcpddr.mdl" then
			RunConsoleCommand("OCRP_SpawnPolice")
		end
		return "Exit"
	end,
Function2 = function(ply) ply.OCRPData["CurCar"]:Remove() return "Exit" end,}

GM.OCRP_Dialogue["Job_Ambulence01"] = {
Dialogue = {}
}
GM.OCRP_Dialogue["Job_Ambulence01"].Dialogue["Job"] = { Question = "Your not a paramedic. Scram", YesAnswer = "Oh Ok,", NoAnswer = "And your a meter-maid shove it.", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_Ambulence01"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I'm looking for a ambulance.", NoAnswer = "You can't help me.",
Condition = function(ply)  
					if ply:Team() > 1 then
						if ply:Team() == CLASS_MEDIC then
							return 2
						else
							return "Job"
						end
					else
						return "Job"
					end
					return "Exit" 
				end,
}

GM.OCRP_Dialogue["Job_Ambulence01"].Dialogue[2] = {Question = "Here are the keys.", YesAnswer = "Alright", NoAnswer = "Nice.", Condition = function(ply) return true end,Function = function(ply) RunConsoleCommand("OCRP_SpawnAmbo") return "Exit" end,}-- Return the ending dialogue thing
---
GM.OCRP_Dialogue["Job_FireEngine01"] = {
Dialogue = {}
}
GM.OCRP_Dialogue["Job_FireEngine01"].Dialogue["Job"] = { Question = "Your not a fireman. Scram", YesAnswer = "Oh Ok,", NoAnswer = "And your a meter-maid shove it.", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_FireEngine01"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I'm looking for a Fire Engine.", NoAnswer = "You can't help me.",
Condition = function(ply)  
					if ply:Team() > 1 then
						if ply:Team() == CLASS_FIREMAN then
							return 2
						else
							return "Job"
						end
					else
						return "Job"
					end
					return "Exit" 
				end,
}

GM.OCRP_Dialogue["Job_FireEngine01"].Dialogue[2] = {Question = "Here are the keys, it's parked outside.", YesAnswer = "Alright", NoAnswer = "Nice.", Condition = function(ply) return true end,Function = function(ply) RunConsoleCommand("OCRP_SpawnFireEngine") return "Exit" end,}-- Return the ending dialogue thing
--


--Organization
GM.OCRP_Dialogue["Org"] = {
Dialogue = {},
}

GM.OCRP_Dialogue["Org"].Dialogue["Create"] = {Question = "Here you go, it'll cost you $5000.", YesAnswer = "Thanks!", NoAnswer = "I think I've changed my mind.", Condition = function(ply) return true end, Function = function(ply) RunConsoleCommand("ocrp_no") return "Exit" end,}
GM.OCRP_Dialogue["Org"].Dialogue["InOrg"] = {Question = "Quit your current organisation before creating one", YesAnswer = "Oh, alright then I'll quit.", NoAnswer = "I think I will pass, I like this organisation!", Condition = function(ply) return true end, Function = function(ply) RunConsoleCommand("ocrp_qo", ply:GetOrg()) return "Exit" end, }
GM.OCRP_Dialogue["Org"].Dialogue[1] = {Question = "Hello there, are you looking to start a Organization?.", YesAnswer = "Yeah, I'm that kinda person.", NoAnswer = "I really don't think it's me, bye.",
Condition = function(ply)
					if tonumber(ply:GetNWInt("orgid",0)) > 0 then
						return "InOrg"
					else
						return "Create"
					end
				end,
}

GM.OCRP_Dialogue["Hydro"] = {
Dialogue = {},
}

GM.OCRP_Dialogue["Hydro"].Dialogue["BuyHydro"] = {Question = "You can have them, but at a price of $25,000", YesAnswer = "I'll take that deal!", NoAnswer = "I don't think I'm ready.", Condition = function(ply) return true end, Function = function(ply) RunConsoleCommand("ocrp_no") return "Exit" end,}
GM.OCRP_Dialogue["Hydro"].Dialogue["Already"] = {Question = "Yo, you already have Hydraulics on your car.", YesAnswer = "Oh, yeah, bye.", NoAnswer = "Woops, I brought the wrong car!", Condition = function(ply) return true end, Function = function(ply) return "Exit" end, }
GM.OCRP_Dialogue["Hydro"].Dialogue[1] = {Question = "Hello there, are you looking for Hydraulics?", YesAnswer = "Yeah, I'm that kinda person.", NoAnswer = "I'm not a pimp, no, thanks.",
Condition = function(ply)
	for k, v in pairs(ents.FindInSphere( ply:GetPos(), 400 )) do
		if v:GetClass() == "prop_vehicle_jeep" then
			print( "We have jeep" )
			if v:GetNWInt("Owner") == ply:EntIndex() then
				print("we have owner")
				tehthing = v
				if (SERVER) then
					if v.Hydros then
						return "Already"
					else
						return "BuyHydro"
					end
				end
				break
			end
		end
	end
	return false
end,
}


GM.OCRP_Dialogue["Job_Mayor001"] = {
Dialogue = {},
Condition = function(ply)  
				if ply:Team() == CLASS_Mayor then
					return "Quit"
				end
				return 1 
			end,
}
GM.OCRP_Dialogue["Job_Mayor001"].Dialogue["Full"] = { Question = "There is already a mayor", YesAnswer = "Oh Ok,", NoAnswer = "You Jerk!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_Mayor001"].Dialogue["Job"] = { Question = "Quit your current job first, then we will talk.", YesAnswer = "Oh Ok,", NoAnswer = "But I like this job!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end, } 

GM.OCRP_Dialogue["Job_Mayor001"].Dialogue["QuitBallot"] = {Question = "How may I help you today?", YesAnswer = "I'd like to withdraw my ballot.", NoAnswer = "I don't want your help.",Condition = function(ply) return true end,Function = function(ply) RunConsoleCommand("OCRP_RemoveBallot") return "Exit" end,}

GM.OCRP_Dialogue["Job_Mayor001"].Dialogue["Quit"] = {Question = "How may I help you today?", YesAnswer = "I'd like to resign as the mayor.", NoAnswer = "I don't want your help.",Condition = function(ply) return true end,Function = function(ply) RunConsoleCommand("OCRP_Job_Quit") return "Exit" end,}

GM.OCRP_Dialogue["Job_Mayor001"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I'm looking to become the mayor of this town!", NoAnswer = "You can't help me.",
Condition = function(ply)  
					if team.NumPlayers(CLASS_Mayor) >= 1 && ply:Team() != CLASS_Mayor then return "Full" end
					if ply.InBallot == true then
						return "QuitBallot"
					end
					if ply:Team() == CLASS_Mayor then
						return "Quit"
					elseif ply:Team() == CLASS_CITIZEN then
						return 2
					else
						return "Job"
					end
					return "Exit" 
				end,
}

GM.OCRP_Dialogue["Job_Mayor001"].Dialogue[2] = {Question = "All you have to do is enter your ballot.", YesAnswer = "Alright", NoAnswer = "Woah, I just wanted money, not a signature.", Condition = function(ply) RunConsoleCommand("OCRP_AddBallot") return 3 end,Func = function(ply)  end,}-- Return the ending dialogue thing

GM.OCRP_Dialogue["Job_Mayor001"].Dialogue[3] = {Question = "Good luck.", YesAnswer = "Yea, like I need luck", NoAnswer = "Time to win some votes!", Condition = function(ply) return true end,Function = function(ply) return "Exit" end,}

GM.OCRP_Dialogue["Skin_001"] = {
Dialogue = {},
}

GM.OCRP_Dialogue["Skin_001"].Dialogue[1] = {Question = "How may I help you today?", YesAnswer = "I'm looking to respray my car", NoAnswer = "I'm looking to buy some hydraulics", SecondYes = true, Condition = function(ply)
	for k, v in pairs(ents.FindInSphere( ply:GetPos(), 400 )) do
		if v:GetClass() == "prop_vehicle_jeep" then
			print( "We have jeep" )
			if v:GetNWInt("Owner") == ply:EntIndex() then
				print("we have owner")
				tehthing = v
				return true
			end
		end
	end
	return true
end,
 
 Function = function(ply) if !tehthing then return "Exit" end RunConsoleCommand("CL_ShowSkin", tehthing:GetCarType()) return "Exit" end,
 Function2 = function(ply) return "BuyHydro" end,}
 
 GM.OCRP_Dialogue["Skin_001"].Dialogue["BuyHydro"] = {Question = "Okay, those Hydraulics will cost you $25,000.", YesAnswer = "Alright, go for it.", NoAnswer = "Woah, no way dude, thats too much.", Condition = function(ply) return true end,Function = function(ply) RunConsoleCommand( "ocrp_bhydros" ) return "Exit" end,}-- Return the ending dialogue thing


OCRPCfg[CLASS_POLICE] = {
	Weapons = {"police_ram_ocrp","police_handcuffs","weapon_copgun_ocrp","police_baton",},
	Condition = function() 
					if team.NumPlayers(CLASS_POLICE) < #player.GetAll()/3 then 
						return true 
					end 
				return false 
			end,

	}
OCRPCfg[CLASS_CHIEF] = {
	Weapons = {"police_ram_ocrp","police_handcuffs","weapon_copgun_ocrp","police_baton",},
	Condition = function() 
				return true 
			end,

	}
OCRPCfg[CLASS_SWAT] = {
	Weapons = {"swat_usp_ocrp","police_baton",},
	Condition = function() 
				return true 
			end,

	}	
OCRPCfg[CLASS_MEDIC] = {
	Weapons = {"medic_health_ocrp","paramedic_charge",},
	Condition = function(ply) 
					if team.NumPlayers(CLASS_MEDIC) < #player.GetAll()/4 then 
						return true 
					end 
				return false 
			end,

	}
	
OCRPCfg[CLASS_FIREMAN] = {
	Weapons = {"fire_axe","fire_extinguisher","fire_hose",},
	Condition = function(ply) 
					if team.NumPlayers(CLASS_FIREMAN) < #player.GetAll()/4 then 
						return true 
					end 
				return false 
			end,

	}
	
OCRPCfg[CLASS_Mayor] = {
	Weapons = {},
	Condition = function(ply) 
					if team.NumPlayers(CLASS_Mayor) < 1 then 
						return true 
					end 
				return false 
			end,

	}
	
function TotalCopCars()
	Number = 0
	for k, v in pairs(ents.GetAll()) do
		if v != NULL and v:IsValid() then
			if v:GetModel() == "models/sickness/lcpddr.mdl" then
				Number = Number + 1
			end
		end
	end
	return Number
end
	

