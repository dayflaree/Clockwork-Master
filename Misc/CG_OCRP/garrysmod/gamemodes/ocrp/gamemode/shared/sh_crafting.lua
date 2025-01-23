function AddDir(dir) // recursively adds everything in a directory to be downloaded by client
	local list = file.FindDir("../"..dir.."/*")
	for _, fdir in pairs(list) do
		if fdir != ".svn" then // don't spam people with useless .svn folders
			AddDir(dir.."/"..fdir)
		end
	end
 
	for k,v in pairs(file.Find("../"..dir.."/*")) do
		resource.AddFile(dir.."/"..v)
	end
end
AddDir("sound/OCRP/")
AddDir("materials/gui/ocrp/")
AddDir("materials/OCRP/")
GM.OCRP_Recipies = {
	
				{Item = "item_ladder",
				Cata = "Prop",
				Skills = {skill_craft_basic = 1,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_pole",Amount = 2},{Item = "item_metal",Amount = 5},},},
				
				{Item = "item_pot",
				Cata = "Prop",
				Skills = {skill_craft_basic = 1,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_clay",Amount = 3},},},
				
				{Item = "item_molotov",
				Cata = "Wep",
				Skills = {skill_craft_basic = 4,skill_craft_mech = 5,skill_craft_bal = 2,skill_craft_weapon = 4,skill_craft_circ = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_clay",Amount = 10},{Item = "item_metal", Amount = 10},{Item = "item_cardboard", Amount = 10}, {Item = "item_gascan", Amount = 5},},},
					
				{Item = "item_pipe",
				Skills = {skill_craft_basic = 1,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_metal",Amount = 2},},},
				
				{Item = "item_ammo_pistol",
				Amount = 20,
				Cata = "Wep",
				Skills = {skill_craft_basic = 1,skill_craft_mech = 0,skill_craft_bal = 2,skill_craft_weapon = 0,skill_craft_circ = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_casing",Amount = 1},{Item = "item_metal",Amount = 1},{Item = "item_cardboard",Amount = 1},{Item = "item_explosives",Amount = 1},},},
				
				{Item = "item_ammo_rifle",
				Amount = 30,
				Cata = "Wep",
				Skills = {skill_craft_basic = 2,skill_craft_mech = 0,skill_craft_bal = 4,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_casing",Amount = 2},{Item = "item_metal",Amount = 2},{Item = "item_explosives",Amount = 2},},},
				
				{Item = "item_ammo_buckshot",
				Amount = 8,
				Cata = "Wep",
				Skills = {skill_craft_basic = 2,skill_craft_mech = 0,skill_craft_bal = 3,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_casing",Amount = 1},{Item = "item_metal",Amount = 2},{Item = "item_cardboard",Amount = 1},{Item = "item_plastic",Amount = 1},{Item = "item_explosives",Amount = 1},},},
				
				{Item = "item_ammo_smg",
				Amount = 30,
				Cata = "Wep",
				Skills = {skill_craft_basic = 2,skill_craft_mech = 0,skill_craft_bal = 3,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_casing",Amount = 2},{Item = "item_metal",Amount = 3},{Item = "item_explosives",Amount = 1},},},
				
				{Item = "item_casing",
				HeatSource = true,
				Cata = "Wep",
				Skills = {skill_craft_basic = 2,skill_craft_mech = 1,skill_craft_bal = 0,skill_craft_weapon = 1,},
				Requirements = {{Item = "item_metal",Amount = 2},},},

				{Item = "item_knife",
				HeatSource = true,
				Cata = "Wep",
				Skills = {skill_craft_basic = 2,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 2,},
				Requirements = {{Item = "item_metal",Amount = 2},{Item = "item_plastic",Amount = 3},},},--- Examples will change		

				{Item = "item_bat",
				HeatSource = true,
				Cata = "Wep",
				Skills = {skill_craft_basic = 2,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 2,},
				Requirements = {{Item = "item_metal",Amount = 1},{Item = "item_pipe",Amount = 2},{Item = "item_plastic",Amount = 3},},},--- Examples will change
				
				{Item = "item_lockpick",
				HeatSource = true,
				Skills = {skill_craft_basic = 2,skill_craft_mech = 2,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_metal",Amount = 2},{Item = "item_plastic",Amount = 1},{Item = "item_pipe",Amount = 1},},},
				
				{Item = "item_wrench",
				HeatSource = true,
				Skills = {skill_craft_basic = 2,skill_craft_mech = 2,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_metal",Amount = 2},{Item = "item_pipe",Amount = 1},},},
				
				{Item = "item_glock18",
				HeatSource = true,
				Cata = "Wep",
				Skills = {skill_craft_basic = 3,skill_craft_mech = 1,skill_craft_bal = 1,skill_craft_weapon = 1,},
				Requirements = {{Item = "item_metal",Amount = 5},},},			

				{Item = "item_fiveseven",
				HeatSource = true,
				Cata = "Wep",
				Skills = {skill_craft_basic = 3,skill_craft_mech = 1,skill_craft_bal = 1,skill_craft_weapon = 2,},
				Requirements = {{Item = "item_metal",Amount = 6},{Item = "item_plastic",Amount = 1},},},
				
				{Item = "item_deagle",
				HeatSource = true,
				Cata = "Wep",
				Skills = {skill_craft_basic = 3,skill_craft_mech = 2,skill_craft_bal = 2,skill_craft_weapon = 3,},
				Requirements = {{Item = "item_metal",Amount = 9},{Item = "item_plastic",Amount = 1},},},

				{Item = "item_shotgun",
				HeatSource = true,
				Cata = "Wep",
				Skills = {skill_craft_basic = 3,skill_craft_mech = 5,skill_craft_bal = 3,skill_craft_weapon = 3,},
				Requirements = {{Item = "item_metal",Amount = 10},{Item = "item_pipe",Amount = 2},{Item = "item_plastic",Amount = 1},},},
				
				{Item = "item_mac10",
				HeatSource = true,
				Cata = "Wep",
				Skills = {skill_craft_basic = 3,skill_craft_mech = 2,skill_craft_bal = 2,skill_craft_weapon = 4,},
				Requirements = {{Item = "item_metal",Amount = 7},{Item = "item_oil",Amount = 1},{Item = "item_pipe",Amount = 2},{Item = "item_plastic",Amount = 1},},},
				
				{Item = "item_mp5",
				HeatSource = true,
				Cata = "Wep",
				Skills = {skill_craft_basic = 3,skill_craft_mech = 4,skill_craft_bal = 2,skill_craft_weapon = 4,},
				Requirements = {{Item = "item_metal",Amount = 8},{Item = "item_oil",Amount = 1},{Item = "item_pipe",Amount = 1},{Item = "item_plastic",Amount = 1},},},
				
				{Item = "item_m4a1",
				HeatSource = true,
				Cata = "Wep",
				Skills = {skill_craft_basic = 2,skill_craft_mech = 3,skill_craft_bal = 3,skill_craft_weapon = 5,},
				Requirements = {{Item = "item_metal",Amount = 13},{Item = "item_oil",Amount = 2},{Item = "item_pipe",Amount = 1},{Item = "item_plastic",Amount = 3},},},
				
				{Item = "item_ak47",
				HeatSource = true,
				Cata = "Wep",
				Skills = {skill_craft_basic = 3,skill_craft_mech = 2,skill_craft_bal = 3,skill_craft_weapon = 5,},
				Requirements = {{Item = "item_metal",Amount = 14},{Item = "item_oil",Amount = 1},{Item = "item_pipe",Amount = 1},{Item = "item_wood",Amount = 2},},},

				{Item = "item_cone",
				Cata = "Prop",
				Skills = {skill_craft_basic = 1,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_plastic",Amount = 3},},},
				
				{Item = "item_metal_fence",
				HeatSource = true,
				Cata = "Prop",
				Skills = {skill_craft_basic = 1,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_pole",Amount = 2},{Item = "item_metal",Amount = 4},},},
				
				{Item = "item_wood_fence",
				Cata = "Prop",
				Skills = {skill_craft_basic = 3,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_wood",Amount = 4},},},
				
				{Item = "item_halffence",
				Cata = "Prop",
				Skills = {skill_craft_basic = 2,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_wood",Amount = 3},},},

				{Item = "item_wood_barricade",
				Cata = "Prop",
				Skills = {skill_craft_basic = 2,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_wood",Amount = 1},{Item = "item_pole",Amount = 2},{Item = "item_plastic",Amount = 1},{Item = "item_cinderblock",Amount = 2},},},
				
				{Item = "item_barrier",
				Cata = "Prop",
				Skills = {skill_craft_basic = 3,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_pole",Amount = 1},{Item = "item_cinderblock",Amount = 3},},},
				
				{Item = "item_explosives",
				HeatSource = true,
				Explosive = true,
				Skills = {skill_craft_basic = 1,skill_craft_mech = 0,skill_craft_bal = 2,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_gascan",Amount = 2},{Item = "item_oil",Amount = 1},{Item = "item_pipe",Amount = 1},},},
				
				{Item = "item_life_alert",
				Skills = {skill_craft_basic = 2,skill_craft_mech = 1,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 1,},
				Requirements = {{Item = "item_oil",Amount = 1},{Item = "item_metal",Amount = 1},{Item = "item_plastic",Amount = 3},},},

				{Item = "item_bodyarmor01",
				Skills = {skill_craft_basic = 3,skill_craft_mech = 0,skill_craft_bal = 2,skill_craft_weapon = 3,skill_craft_circ = 0,},
				Requirements = {{Item = "item_metal",Amount = 6},{Item = "item_plastic",Amount = 10},},},
				
				{Item = "item_padlock",
				Skills = {skill_craft_basic = 3,skill_craft_mech = 1,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_metal",Amount = 1},{Item = "item_pipe",Amount = 1},},},
				
				{Item = "item_desk",
				Cata = "Prop",
				Skills = {skill_craft_basic = 2,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_metal",Amount = 1},{Item = "item_plastic",Amount = 1},{Item = "item_wood",Amount = 4},},},
				
				{Item = "item_chair01",
				Cata = "Prop",
				Skills = {skill_craft_basic = 1,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_metal",Amount = 4},{Item = "item_plastic",Amount = 4},},},				

				{Item = "item_chair02",
				Cata = "Prop",
				Skills = {skill_craft_basic = 3,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_metal",Amount = 2},{Item = "item_plastic",Amount = 8},{Item = "item_wood",Amount = 5,},},},		
				
				{Item = "item_lockers",
				Cata = "Prop",
				Skills = {skill_craft_basic = 2,skill_craft_mech = 2,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_wood",Amount = 4},{Item = "item_pole", Amount = 1},},},

				{Item = "item_oildrum",
				Cata = "Prop",
				Skills = {skill_craft_basic = 1,skill_craft_mech = 1,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_metal",Amount = 3},},},
				
				{Item = "item_trashcan",
				Cata = "Prop",
				Skills = {skill_craft_basic = 2,skill_craft_mech = 1,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_metal",Amount = 3},{Item = "item_plastic",Amount = 1},},},
				
				{Item = "item_plasticcrate",
				Cata = "Prop",
				Skills = {skill_craft_basic = 1,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_plastic",Amount = 2},},},
				
				{Item = "item_floodlight",
				Cata = "Prop",
				Skills = {skill_craft_basic = 3,skill_craft_mech = 2,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 1,},
				Requirements = {{Item = "item_metal",Amount = 4},{Item = "item_pole",Amount = 1},{Item = "item_plastic", Amount = 1},},},

				{Item = "item_computer",
				Cata = "Prop",
				Skills = {skill_craft_basic = 3,skill_craft_mech = 2,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 1,},
				Requirements = {{Item = "item_metal", Amount = 3},{Item = "item_plastic",Amount = 2},},},
				
				{Item = "item_exitsign",
				Cata = "Prop",
				Skills = {skill_craft_basic = 2,skill_craft_mech = 2,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 1,},
				Requirements = {{Item = "item_metal", Amount = 1},{Item = "item_plastic",Amount = 3},},},
				
				{Item = "item_displaycooler",
				Cata = "Prop",
				Skills = {skill_craft_basic = 4,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_metal", Amount = 3},{Item = "item_plastic",Amount = 7},},},
				
				{Item = "item_woodenshelfs",
				Cata = "Prop",
				Skills = {skill_craft_basic = 4,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_metal", Amount = 1},{Item = "item_wood",Amount = 4},},},
				
				{Item = "item_kitchenshelf",
				Cata = "Prop",
				Skills = {skill_craft_basic = 4,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_plastic", Amount = 2},{Item = "item_pole",Amount = 4},},},
				
				{Item = "item_longdesk",
				Cata = "Prop",
				Skills = {skill_craft_basic = 4,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_pole", Amount = 1},{Item = "item_metal",Amount = 4},},},
				
				{Item = "item_twoshelf",
				Cata = "Prop",
				Skills = {skill_craft_basic = 2,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_wood", Amount = 3},{Item = "item_metal",Amount = 1},},},
				
				{Item = "item_bench",
				Cata = "Prop",
				Skills = {skill_craft_basic = 3,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_wood", Amount = 4},{Item = "item_metal",Amount = 2},},},
				
				{Item = "item_sawhorse",
				Cata = "Prop",
				Skills = {skill_craft_basic = 2,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_wood", Amount = 3},},},

				{Item = "item_shedtable",
				Cata = "Prop",
				Skills = {skill_craft_basic = 3,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_wood", Amount = 5},{Item = "item_metal",Amount = 1},},},
				
				{Item = "item_markettable1",
				Cata = "Prop",
				Skills = {skill_craft_basic = 3,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_wood", Amount = 5},},},
				
				{Item = "item_markettable2",
				Cata = "Prop",
				Skills = {skill_craft_basic = 3,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_wood", Amount = 5},{Item = "item_metal",Amount = 2},},},
				
				{Item = "item_markettable3",
				Cata = "Prop",
				Skills = {skill_craft_basic = 3,skill_craft_mech = 0,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_wood", Amount = 5},{Item = "item_metal",Amount = 1},},},
				
				{Item = "item_vendingcart",
				Cata = "Prop",
				Skills = {skill_craft_basic = 4,skill_craft_mech = 2,skill_craft_bal = 0,skill_craft_weapon = 0,skill_craft_circ = 0,},
				Requirements = {{Item = "item_wood", Amount = 6},{Item = "item_metal",Amount = 2},{Item = "item_plastic", Amount = 1},},},
	
}				


