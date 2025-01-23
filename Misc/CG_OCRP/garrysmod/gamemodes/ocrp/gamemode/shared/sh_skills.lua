GM.OCRP_Skills = {}

GM.OCRP_Skills["skill_conc"] = {
	Name = "Concentration Training",
	Desc = "Increases accuracy",
	Model = "models/props_lab/binderbluelabel.mdl",
	MaxLevel = 5,
	LvlDesc = {"Accuracy with guns increased by %10","Accuracy with guns increased by %10","Accuracy with guns increased by %10","Accuracy with guns increased by %10","Accuracy with guns increased by %10"},
}

GM.OCRP_Skills["skill_end"] = {
	Name = "Endurance Training",
	Desc = "Decreases energy decay",
	Model = "models/props_lab/binderblue.mdl",
	MaxLevel = 3,
	LvlDesc = {"Sprinting Speed Increased by %15","Speed Decay Reduced by %75","Sprinting Speed Increased by %15"},
	Function = function(ply,skill)
				local multiplier = 1
				local multi = 1
				local jump_multi = 1
					if skill  == "skill_end" then
						if ply:HasSkill("skill_end",1) then
							multi = multi + 0.15
							if ply:HasSkill("skill_end",2) then
								multiplier = multiplier + .75
								if ply:HasSkill("skill_end",3) then
									multi = multi + 0.15
								end
							end
						end
					end
					ply.SprintDecay = .05 * multiplier
					ply.Speeds.Sprint = 327 * multi
				end,
}

GM.OCRP_Skills["skill_str"] = {
	Name = "Strength Training",
	Desc = "Increases melee attacks, more resistant to damage",
	Model = "models/props_lab/binderredlabel.mdl",
	MaxLevel = 3,
	LvlDesc = {"Melee attack power increased by %25","Damage Taken reduced by %25","Melee attack power increased by %25"},
}

GM.OCRP_Skills["skill_picking"] = {
	Name = "Lockpicking",
	Desc = "Allows you to lockpick",
	Model = "models/props_lab/binderredlabel.mdl",
	MaxLevel = 7,
	LvlDesc = {"The ability to lockpick regular doors","%15 more likely to lockpick successfully","The ability to lockpick handcuffs","%20 more likely to lockpick successfully","The ability to lockpick padlocks","The ability to lockpick cars and other doors","%25 more likely to lockpick successfully"},
}

GM.OCRP_Skills["skill_herb"] = {
	Name = "Herbalism",
	Desc = "Allows you to grow plants",
	Model = "models/props_lab/bindergreenlabel.mdl",
	MaxLevel = 4,
	LvlDesc = {"The ability to grow weed","%5 less time to grow drugs","","%5 less time to grow drugs",},
}

GM.OCRP_Skills["skill_craft_bal"] = {
	Name = "Ballistics Crafting",
	Desc = "Allows players to craft with ballistics",
	Model = "models/props_lab/binderredlabel.mdl",
	MaxLevel = 5,
	Requirements = {{Skill =  "skill_craft_basic", level = 1},},
	LvlDesc = {"The ability to craft with ballistics"},
}

GM.OCRP_Skills["skill_craft_circ"] = {
	Name = "Circuitry Crafting",
	Desc = "Allows players to craft interfaces and electronic items",
	Model = "models/props_lab/bindergraylabel01b.mdl",
	MaxLevel = 1,
	Requirements = {{Skill =  "skill_craft_basic", level = 3},},
	LvlDesc = {"The ability to craft electronic items",},
}

GM.OCRP_Skills["skill_craft_mech"] = {
	Name = "Mechanical Crafting",
	Desc = "Allows players to craft weapons",
	Model = "models/props_lab/bindergraylabel01a.mdl",
	MaxLevel = 5,
	Requirements = {{Skill =  "skill_craft_basic", level = 1},},
	LvlDesc = {"The ability to craft mechanical objects"},
}

GM.OCRP_Skills["skill_food"] = {
	Name = "Food Making",
	Desc = "Allows players to make food",
	Model = "models/props_lab/bindergraylabel01a.mdl",
	MaxLevel = 5,
	LvlDesc = {"The ability to make food"},
}

GM.OCRP_Skills["skill_craft_weapon"] = {
	Name = "Weapon Crafting",
	Desc = "Allows players to craft",
	Model = "models/props_lab/binderredlabel.mdl",
	MaxLevel = 5,
	Requirements = {{Skill =  "skill_craft_basic", level = 1},},
	LvlDesc = {"The ability to craft weapons"},
}

GM.OCRP_Skills["skill_craft_basic"] = {
	Name = "Basic Crafting",
	Desc = "Allows players to craft",
	Model = "models/props_lab/bindergreen.mdl",
	MaxLevel = 4,
	LvlDesc = {"The ability to craft basic neccessities"},
}

GM.OCRP_Skills["skill_acro"] = {
	Name = "Acrobatic Training",
	Desc = "Allows you to jump higher",
	Model = "models/props_lab/binderblue.mdl",
	MaxLevel = 2,
	LvlDesc = {"a 50% higher jump","-5 energy cost to jump",},
	Function = function(ply,skill)
					local jump_multi = 1
					if skill  == "skill_acro" then 
						if ply:HasSkill("skill_acro",1) then
							jump_multi = 1.5
						end
					end
					ply:SetJumpPower(160*jump_multi)
				end,
	RemoveFunc = function(ply,skill)
					ply:SetJumpPower(160)
				end,
}

GM.OCRP_Skills["skill_pack"] = {
	Name = "Back-Pack Training",
	Desc = "Allow you to carry more",
	Model = "models/props_lab/binderblue.mdl",
	MaxLevel = 1,
	LvlDesc = {"The ability to carry 25 more pounds",},
	Function = function(ply,skill)
					if ply:HasSkill(skill,1) && ply.OCRPData["Inventory"].WeightData.Max < 75 then
						ply.OCRPData["Inventory"].WeightData.Max = ply.OCRPData["Inventory"].WeightData.Max + 25
					end
				end,
	RemoveFunc = function(ply,skill)
					ply.OCRPData["Inventory"].WeightData.Max = ply.OCRPData["Inventory"].WeightData.Max - 25
				end,
}

GM.OCRP_Skills["skill_loot"] = {
	Name = "Looting",
	Desc = "Allow you to steal from players",
	Model = "models/props_lab/bindergreenlabel.mdl",
	MaxLevel = 9,
	LvlDesc = {	
				"The ability to loot bodies",
				"The ability to loot drugs and pots",
				"The ability to loot ammo and materials",
				"the ability to loot melee weapons",
				"the ability to loot pistols",
				"the ability to loot shotguns",
				"the ability to loot smgs",
				"the ability to loot assualt weapons",
				"the ability to loot from containers",
	},
	Requirements = {{Skill =  "skill_rob", level = 6},},
}

GM.OCRP_Skills["skill_rob"] = {
	Name = "Robbery",
	Desc = "Allow you to steal more mayor money",
	Model = "models/props_lab/binderredlabel.mdl",
	MaxLevel = 6,
	LvlDesc = {	"The ability to steal $100 more from mayor cash blocks.",
				"The ability to steal $100 more from mayor cash blocks.",
				"The ability to steal $100 more from mayor cash blocks.",
				"The ability to steal $100 more from mayor cash blocks.",
				"The ability to steal $100 more from mayor cash blocks.",
				"The ability to steal $100 more from mayor cash blocks.",
	},
}
GM.OCRP_Skills["skill_theft"] = {
	Name = "Theft",
	Desc = "Allows pickup shop goods without paying. If the owner isn't attending their shop.",
	Model = "models/props_lab/binderredlabel.mdl",
	MaxLevel = 1,
	LvlDesc = {	"The ability to take merchandise from shops if the owner isn't around",},
}
