
GM.CarPlaces = {
	{Car = "CAR_BMW_M5",
	Pos = Vector(-2810.5938, -506.5625, 31.0313),
	Angles = Angle(-8.395, -0.176, 0.571),
	Pos2 = Vector(-2943.0000, -507.0000, 12.5000),
	Angles2 = Angle(0,180,0),
	ParentID = 490,
	},
	{Car = "CAR_PMP",
	Pos = Vector(-3146.417480, -840.598145, 48.491394),
	Angles = Angle(-8.395, -0.176, 0.571),
	Pos2 = Vector(-3289.0000, -839.0000, 12.5000),
	Angles2 = Angle(0,180,0),
	ParentID = 489,
	},
	{Car = "CAR_HUMMER",
	Pos = Vector(-2931.386963, -837.897766, 43.542248),
	Angles = Angle(0,90,0),
	Pos2 = Vector(-2929.0000, -975.0000, 12.5000),
	Angles2 = Angle(0,180,0),
	ParentID = 499,
	},
	{Car = "CAR_MINI",
	Pos = Vector(-2569.038086, -668.013916, 43.790932),
	Angles = Angle(0,90,0),
	Pos2 = Vector(-6055.380859, 1901.941284, 72.031250),
	Angles2 = Angle(0,180,0),
	ParentID = 500,
	},
	{Car = "CAR_CORVETTE",
	Pos = Vector(-4842.506348, 1923.634033, 50.639568),
	Angles = Angle(4, 25, 0),
	Pos2 = Vector(-4710.0000, 1977.0000, 12.5000),
	Angles2 = Angle(0,180,0),
	ParentID = 503,
	},
	}
	
	
	
RunConsoleCommand("ai_disable", 1)
	
GM.Maps = {}

GM.Maps["rp_cosmoscity"] = {
	RemoveVectors = {},
	UnOwnable = {},
	Public = {},
	Police = {},
	Locked = {},
	Jails = {},
	SpawnsPolice = {},
	SpawnsMedic = {},
	SpawnsCitizen = {},
	SpawnsCar = {
		--	{Position = Vector(-2478.0261, -1472.8445, 7.0313), Ang = Angle(0,0,0)},
		--	{Position = Vector(-2487.3040, -1622.1737, 7.0313), Ang = Angle(0,0,0)},
		--	{Position = Vector(-2495.4661, -1803.6760, 7.0313), Ang = Angle(0,0,0)},
			},
	AddObjs = {},
	Function = function()
					AddNPC(Vector(3665,-102,0), Angle(0, 180, 0), "OCRP_ShopMenu", "npc_barney","Materials",{5,6,7})
					AddNPC(Vector(-6055, 1902, 72), Angle(3, -45, 0), "OCRP_NPCTalk", "npc_alyx","Skin",{"Skin_001"})
					AddNPC(Vector(-5317,-10301,71), Angle(0, 145, 0), "CL_Garage", "npc_eli", "Garage", {})
					AddNPC(Vector(3251, 87, 64), Angle(0, 180, 0), "OCRP_ShopMenu", "npc_eli","Materials",{2,1,3,4})
				end,
 }

function GM.ProtectCave ( )
	for k, v in pairs(ents.FindInSphere(Vector(-8951, 13034, 283), 1500)) do //
		if v and v:IsValid() then
			if v:IsPlayer() then
				if v:Alive() then
					v:SetPos(Vector(-2518,-5486,198))
					v:Hint('Ask an admeen to fully respawn you - This shit is broken. AND STAY AWAY FROM THE CAVE.');
				end
			else
				v:Remove();
			end
		end
	end
end

if !string.find(game.GetMap(), 'rp_evocity') then
	hook.Add('Think', 'GM.ProtectCave', GM.ProtectCave);
end


 
GM.Maps["rp_evocity_v2d"] = {
	RemoveVectors = {Vector(3586,-6770,185),},
	UnOwnable = {Vector(-7992,-8929,2542),Vector(-7880,-9163,2541),Vector(-7640,-9163,2541),Vector(-6862,-9479,2542),Vector(-6830,-8915,2670),
	Vector(-5084,-9417,126),Vector(-6693,-7899,126),Vector(-6809,-7605,128),},
	
	Public = {Vector(-6485,-7663,135),Vector(-6485,-7727,135),Vector(-5598,-6866,126),Vector(-5598,-6228,126),
Vector(-7039,-6062,135),Vector(-7039,-6002,135),Vector(-6956,-4459,135),Vector(-7020,-4459,135),Vector(-5445,-4762,135),
Vector(-5445,-4702,135),Vector(-5445,-4514,135),Vector(-5445,-4454,135),Vector(-5539,-9255,135),Vector(-5539,-9315,135),
Vector(10602,-12424,-995),Vector(10474,-12424,-995),Vector(-6748,-8653,136),Vector(-7004,-8653,136),Vector(-7676,-8685,168),Vector(-7678,-8529,-322),
Vector(-7580,-8427,-280),Vector(-7252,-8205,-2138),Vector(-7196,-8205,-2138),Vector(-7232,-9489,126),Vector(-6928,-9489,-74),Vector(-4656,-7001,254),
Vector(-4777,-9263,134),Vector(-4777,-9307,134),Vector(-4771,-9307,289),Vector(-4771,-9263,461),Vector(-8992,-9769,130),Vector(-8992,-9985,130),Vector(-9120,-9041,190),
Vector(5784,-4373,126),Vector(4239,-4174,135),Vector(4117,-4174,135),Vector(4854,-3719,135),Vector(-4777,-9307,1670),Vector(-4777,-9263,1670),
	Vector(-3849,-6370,261),Vector(-3849,-6430,261), -- Flea market
	},


	Police = {Vector(-6560,-9185,895),Vector(-7704,-9210,894),Vector(-7704,-9104,894),Vector(-7872,-9210,894),Vector(-7872,-9104,894),
Vector(-8040,-9210,894),Vector(-8040,-9104,894),Vector(-8097,-9153,894),Vector(-6485,-7663,135),Vector(-7800,-8961,1788),Vector(-7936,-8781,1790),},
	Locked = {Vector(-6693,-7899,126),Vector(-6809,-7605,128),Vector(-5084,-9417,126),
	Vector(-7704,-9104,894),Vector(-7704,-9210,894),Vector(-7872,-9104,894),Vector(-7872,-9210,894),Vector(-8040,-9210,894),Vector(-8040,-9104,894),Vector(-8097,-9153,894),},
	Jails = {
			{Position = Vector(-7628, -9299, 870), Ang = Angle(-0, 179, 0)},
			{Position = Vector(-7614, -9007, 870), Ang = Angle(4, -178, 0)},
			{Position = Vector(-7877, -9008, 870), Ang = Angle(15, -87, 0)},
			{Position = Vector(-7866, -9300, 870), Ang = Angle(20, 91, 0)},
			{Position = Vector(-8031, -9302, 870), Ang = Angle(14, 90, 0)},
			{Position = Vector(-8041, -9004, 870), Ang = Angle(14, -87, 0)},
			{Position = Vector(-8170, -9162, 870), Ang = Angle(16, -1, 0)},	},
	SpawnsPolice = {
			--These are infront of the desk in the nexus.
			{Position = Vector(-7029, -9144, 136), Ang = Angle(5, 89, 0)},
			{Position = Vector(-6934, -9144, 136), Ang = Angle(5, 89, 0)},
			{Position = Vector(-6824, -9145, 136), Ang = Angle(5, 89, 0)},	
			{Position = Vector(-6694, -9145, 136), Ang = Angle(5, 89, 0)},	
			{Position = Vector(-6596, -9146, 136), Ang = Angle(5, 89, 0)},	
			{Position = Vector(-6595, -9040, 136), Ang = Angle(5, 89, 0)},	
			{Position = Vector(-6679, -9039, 136), Ang = Angle(5, 89, 0)},
			{Position = Vector(-6781, -9039, 136), Ang = Angle(5, 89, 0)},	
			{Position = Vector(-6885, -9038, 136), Ang = Angle(5, 89, 0)},	
			{Position = Vector(-6692, -9038, 136), Ang = Angle(5, 89, 0)},	
		},	
	SpawnsMedic = {
			--These are infront of the elevator
			{Position = Vector(-7138, -9119, 136), Ang = Angle(27, 91, 0)},
			{Position = Vector(-7234, -9122, 136), Ang = Angle(27, 91, 0)},
			{Position = Vector(-7236, -9037, 136), Ang = Angle(27, 91, 0)},
			{Position = Vector(-7156, -9034, 136), Ang = Angle(27, 91, 0)},
			{Position = Vector(-7159, -8935, 136), Ang = Angle(27, 91, 0)},
			{Position = Vector(-7269, -8939, 136), Ang = Angle(27, 91, 0)},		
		},
	SpawnsCitizen = {
			--[[Behind bank		
			{Position = Vector(-7395, -7521, 136), Ang = Angle(-2, 90, 0)},
			{Position = Vector(-7396, -7620, 136), Ang = Angle(-2, 90, 0)},
			{Position = Vector(-7398, -7711, 136), Ang = Angle(-2, 90, 0)},
			{Position = Vector(-7399, -7809, 136), Ang = Angle(-2, 90, 0)},			
			{Position = Vector(-7400, -7898, 136), Ang = Angle(-2, 0, 0)},	
			{Position = Vector(-7401, -7964, 136), Ang = Angle(-2, 0, 0)},
			{Position = Vector(-7710, -7340, 136), Ang = Angle(-2, 0, 0)},	
			{Position = Vector(-7709, -7249, 136), Ang = Angle(-2, 0, 0)},	
			{Position = Vector(-7709, -7138, 136), Ang = Angle(-2, 0, 0)},	
			{Position = Vector(-7708, -6994, 136), Ang = Angle(-2, 0, 0)},	
			{Position = Vector(-7707, -6856, 136), Ang = Angle(-2, 0, 0)},	
			{Position = Vector(-7706, -6721, 136), Ang = Angle(-2, 0, 0)},	
			{Position = Vector(-7705, -6599, 136), Ang = Angle(-2, 0, 0)},	
			{Position = Vector(-7704, -6471, 136), Ang = Angle(-2, 0, 0)},	
			{Position = Vector(-7704, -6350, 136), Ang = Angle(-2, 0, 0)},	
			{Position = Vector(-7805, -6749, 136), Ang = Angle(-0, -1, 0)},
			{Position = Vector(-7807, -6852, 136), Ang = Angle(-0, -1, 0)},	
			{Position = Vector(-7809, -6969, 136), Ang = Angle(-0, -1, 0)},	
			{Position = Vector(-7811, -7086, 136), Ang = Angle(-0, -1, 0)},	
			{Position = Vector(-7813, -7180, 136), Ang = Angle(-0, -1, 0)},	
			{Position = Vector(-7816, -7339, 136), Ang = Angle(-0, -1, 0)},	
			{Position = Vector(-7390, -6780, 136), Ang = Angle(0, 90, 0)},	
			{Position = Vector(-7391, -6681, 136), Ang = Angle(0, 90, 0)},	
			{Position = Vector(-7391, -6568, 136), Ang = Angle(0, 90, 0)},	]]
			
			-- Flea Market
			{Position = Vector(-2615,-6276,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2561,-6276,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2484,-6284,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2468,-6224,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2537,-6217,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2604,-6234,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2613,-6161,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2554,-6164,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2451,-6160,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2444,-6081,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2527,-6083,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2592,-6080,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2598,-5987,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2521,-5981,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2441,-5980,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2438,-5792,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2523,-5803,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2593,-5804,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2590,-5920,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2508,-5909,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2435,-5903,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2620,-5550,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2539,-5552,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2456,-5569,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2439,-5502,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2518,-5486,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2606,-5484,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2600,-5413,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2529,-5401,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2454,-5402,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2457,-5316,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2535,-5311,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2547,-5226,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2441,-5224,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2427,-5615,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2522,-5617,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2592,-5635,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2598,-5705,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2515,-5707,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-2438,-5703,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-3218,-5191,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-3225,-5279,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-3223,-5688,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-3219,-5809,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-3220,-5913,198),Ang = Angle(0, -180, 0)},
			{Position = Vector(-3210,-6041,198),Ang = Angle(0, -180, 0)},

		},
	SpawnsMoney =  {
				{Position = Vector(-6755,-7557,95),Ang = Angle(0, 180, 0)},
				{Position = Vector(-6755,-7491,95),Ang = Angle(0, 180, 0)},
				{Position = Vector(-6850,-7483,95),Ang = Angle(0, 180, 0)},
				{Position = Vector(-6850,-7546,95),Ang = Angle(0, 180, 0)},
			},
	SpawnsCar = {
			{Position = Vector(5483, -3610, 64), Ang = Angle(0, 180, 0)},
			{Position = Vector(-3907, -10315, 71), Ang = Angle(0,180,0)},
			{Position = Vector(-4650, -10181, 71), Ang = Angle(0,180,0)},
			{Position = Vector(-5017, -10496, 71), Ang = Angle(0,180,0)},
			{Position = Vector(5140, -3605, 71), Ang = Angle(0,180,0)},
			},	
	AddObjs = {
		{	Class = "Bank_atm",
			Pos = Vector(-6448 ,-7816, 72.0313),
			Angles = Angle(0,90,0),
		--	Model ="models/env/misc/bank_atm/bank_atm.mdl", Bank
			Skin = 1,
			Activate = false,
		},
		{	Class = "Bank_atm",
			Pos = Vector(-4829, -4855, 208.0313),
			Angles = Angle(0,90,0),
		--	Model ="models/env/misc/bank_atm/bank_atm.mdl", Tides
			Skin = 1,
			Activate = false,
		},
		{	Class = "Bank_atm",
			Pos = Vector(-3724,-7447,198.0313),
			Angles = Angle(0,90,0),
		--	Model ="models/env/misc/bank_atm/bank_atm.mdl", market
			Skin = 1,
			Activate = false,
		},		
		-- Abandonded House v
		{	Class = "prop_door_rotating",
			Pos = Vector(-2662,196,259),
			Angles = Angle(0,90,0),
			Model ="models/props_c17/door01_left.mdl", 
			Skin = 1,
			Activate = false,
		},			
		{	Class = "prop_door_rotating",
			Pos = Vector(-3386,247,123),
			Angles = Angle(0,0,0),
			Model ="models/props_c17/door01_left.mdl", 
			Skin = 1,
			Activate = false,
		},		
		{	Class = "prop_door_rotating",
			Pos = Vector(-2753,29,123),
			Angles = Angle(0,0,0),
			Model ="models/props_c17/door01_left.mdl", 
			Skin = 1,
			Activate = false,
		},		
		{	Class = "prop_door_rotating",
			Pos = Vector(-2535,161,123),
			Angles = Angle(0,-90,0),
			Model ="models/props_c17/door01_left.mdl", 
			Skin = 1,
			Activate = false,
		},	
		{	Class = "prop_door_rotating",
			Pos = Vector(-2855,-128,123),
			Angles = Angle(0,90,0),
			Model ="models/props_c17/door01_left.mdl", 
			Skin = 1,
			Activate = false,
		},
		-- Abandoned house ^	
		--Slums Shop A
		{	Class = "prop_door_rotating",
			Pos = Vector(-7943,-10256,125),
			Angles = Angle(0,0,0),
			Model ="models/props_c17/door01_left.mdl", 
			Skin = 4,
			Activate = false,
		},
		-- Slums shop b
		{	Class = "prop_door_rotating",
			Pos = Vector(-8240,-10468,258),
			Angles = Angle(0,90,0),
			Model ="models/props_c17/door01_left.mdl", 
			Skin = 4,
			Activate = false,
		},
		{	Class = "prop_door_rotating",
			Pos = Vector(-8240,-10213,258),
			Angles = Angle(0,90,0),
			Model ="models/props_c17/door01_left.mdl", 
			Skin = 4,
			Activate = false,
		},		
		--Slums shop c
		{	Class = "prop_door_rotating",
			Pos = Vector(-7944,-10840,125),
			Angles = Angle(0,0,0),
			Model ="models/props_c17/door01_left.mdl", 
			Skin = 4,
			Activate = false,
		},
		{	Class = "gov_resupply",
			Pos = Vector(-7180,-9227,72),
			Angles = Angle(0,90,0),
			Activate = false,
		},		

	},	
	Function = function()
					AddNPC(Vector(-7270,-6074,72), Angle(0, 0, 0), "OCRP_ShopMenu", "npc_gman","BP gas",{8})
					AddNPC(Vector(-5209,-6390,72), Angle(0, 180, 0), "OCRP_ShopMenu", "npc_barney","Materials",{5,6,7})
					AddNPC(Vector(-7580,-9777,72), Angle(0, 180, 0), "OCRP_ShopMenu", "npc_eli","Materials",{2,1,3,4})
					AddNPC(Vector(-6745,-9396,72), Angle(0, 90, 0), "OCRP_NPCTalk", "npc_mossman","Medic",{"Job_Medic001"})
					AddNPC(Vector(-6653,-9396,72), Angle(0, 90, 0), "OCRP_NPCTalk", "npc_metropolice","Cop",{"Job_Cop001"})
					AddNPC(Vector(-5203,-9450,71), Angle(0, 90, 0), "OCRP_NPCTalk", "npc_kleiner","Mayor",{"Job_Mayor001"})	
					AddNPC(Vector(4597,-4340,204), Angle(0, 90, 0), "CL_CarDealer", "npc_eli","CarDealer",{})	
					AddNPC(Vector(-6722,-7736,72), Angle(0, 0, 0), "OCRP_RelatorMenu", "npc_alyx","Relator",{})
					AddNPC(Vector(-5317,-10301,71), Angle(0, 145, 0), "CL_Garage", "npc_eli", "Garage", {})
					AddNPC(Vector(-7307,-9036,72), Angle(0, 0, 0), "OCRP_NPCTalk","npc_metropolice" ,"Cop",{"Job_CopCar01"})
					AddNPC(Vector(-7279,-8866,72), Angle(0, 0, 0), "OCRP_NPCTalk","npc_mossman", "Ambo",{"Job_Ambulence01"})					
					AddNPC(Vector(-6730,-7668,72), Angle(0, 0, 0), "OCRP_NPCTalk", "npc_alyx","Org",{"Org"})
					AddNPC(Vector(-9523, -10080, 140), Angle(0, 35, 0), "OCRP_NPCTalk", "npc_alyx","Skin",{"Skin_001"})
					AddNPC(Vector(-3211,-6410,198), Angle(0, 180, 0), "OCRP_ShopMenu", "npc_gman","Buying",{9})
					AddNPC(Vector(-6972,-4673,136), Angle(0, 0, 0), "OCRP_Model", "npc_gman", "Model", {})
					
					AddNPC(Vector(-7050,-9425,-128), Angle(0, 90, 0), "OCRP_ShopMenu", "npc_gman","Cheepies",{28})

					AddNPC(Vector(-4648,-4589,208), Angle(0, 180, 0), "OCRP_ShopMenu", "npc_barney","Furniture",{29})
				
					AddNPC(Vector(-5405,-6603,72), Angle(0,-90, 0), "OCRP_ShopMenu", "npc_kleiner","Mayor",{10,11,12,13,14,15,16,17,18,19,20,21,22,23,24},{Min = 120,Max = 900})		
				end,
}	

GM.Maps["rp_evocity2_v2p"] = {
	RemoveVectors = {Vector(4008,-3122,311),},
	UnOwnable = {Vector(-233,-1719,-368),Vector(358,-2174,-368),Vector(884,-2171,-368),Vector(-636,3026,148),Vector(930,-2474,-171),Vector(675,-1584,-84),},
	
	Public = {Vector(2037,-51,202),Vector(1975,-51,202),Vector(1911,-51,202),Vector(1849,-51,202), //Train station upper
	Vector(3740,-2146,132),Vector(3740,-2086,132), // apartments front
	Vector(2580,-1568,138),Vector(2580,-1632,138),Vector(1880,-2428,154),Vector(2580,-2960,154), // car dealer
	Vector(3739,427,130), // old casino building from perp
	Vector(3795,2436,194), // Slums entrance
	Vector(4,2860,139),Vector(4,2796,139), // Burger King
	Vector(-711,610,139),Vector(-711,670,139), // Sintek
	Vector(-748,-1452,138),Vector(-700,-1452,138),Vector(-468,-1452,138),Vector(-420,-1452,138), // GC Main entrance
	Vector(-2412,1052,139),Vector(-2412,988,139),Vector(-2514,892,139),Vector(-2450,892,139),Vector(-2412,760,130),Vector(-2690,756,130),Vector(-2814,388,139),Vector(-2705,532,130),Vector(-2705,484,130), // Hospital
	Vector(-2882,-1028,130),Vector(-2690,-1028,130), // Ace Hardware + Realtor location
	Vector(-2438,-1653,139),Vector(-2498,-1653,139),Vector(-2786,-1376,130), // Clothes store
	Vector(7962,7150,133),Vector(7962,7210,133),Vector(8304,7930,133),Vector(8373,7930,133), // Train station @ cubs
	Vector(-7388,1246,202),Vector(-7395,866,203),Vector(-7395,1038,203), // Sinclair Gas
	Vector(1784,108,203),Vector(1784,156,203), // Bank
	Vector(-7139,13637,252), // bar
	},

	--[[Vector(4854,-3719,135),Vector(-4777,-9307,1670),Vector(-4777,-9263,1670),
	Vector(-3849,-6370,261),Vector(-3849,-6430,261), -- Flea market ]]--


	Police = {Vector(-522,-1460,-374),Vector(-570,-1460,-374),Vector(-600,-1530,-374),Vector(-664,-1817,-374),Vector(-213,-2104,-374),Vector(340,-2687,-374),Vector(340,-2735,-374),Vector(1006,-1941,-377),},
	Locked = {Vector(1365,4,194),}, // Bank back door
	Jails = {
			{Position = Vector(442.2706,-2016.2340,-427.9688), Ang = Angle(-0, 179, 0)},
			{Position = Vector(559.1437,-2012.1986,-427.9688), Ang = Angle(4, -178, 0)},
			{Position = Vector(686.5288,-2013.2102,-427.9688), Ang = Angle(15, -87, 0)},
			{Position = Vector(815.6661,-2010.0499,-427.9688), Ang = Angle(20, 91, 0)},
			{Position = Vector(813.0894,-2335.7334,-427.9688), Ang = Angle(14, 90, 0)},
			{Position = Vector(693.0419,-2331.1238,-427.9688), Ang = Angle(14, -87, 0)},
			{Position = Vector(564.0787,-2333.3154,-427.9688), Ang = Angle(16, -1, 0)},},
			{Position = Vector(435.8467,-2332.6558,-427.9688), Ang = Angle(16, -1, 0)},},
	SpawnsPolice = {
			--These are infront of the desk in the nexus.
			{Position = Vector(-80.0043, -2327.9263, 76.0313), Ang = Angle(5, 89, 0)},
			{Position = Vector(-208.2688, -2327.5251, 76.0313), Ang = Angle(5, 89, 0)},
			{Position = Vector(-336.0963, -2327.8723, 76.0313), Ang = Angle(5, 89, 0)},	
			{Position = Vector(-464.0059, -2328.0801, 76.0313), Ang = Angle(5, 89, 0)},	
			{Position = Vector(-592.1052, -2328.1018, 76.0313), Ang = Angle(5, 89, 0)},	
			{Position = Vector(-720.1718, -2328.3330, 76.0313), Ang = Angle(5, 89, 0)},	
		},	
	SpawnsMedic = {
			--These are infront of the cop spawns
			{Position = Vector(-80.0043, -2200.9263, 76.0313), Ang = Angle(5, 89, 0)},
			{Position = Vector(-208.2688, -2200.5251, 76.0313), Ang = Angle(5, 89, 0)},
			{Position = Vector(-336.0963, -2200.8723, 76.0313), Ang = Angle(5, 89, 0)},	
			{Position = Vector(-464.0059, -2200.0801, 76.0313), Ang = Angle(5, 89, 0)},	
			{Position = Vector(-592.1052, -2200.1018, 76.0313), Ang = Angle(5, 89, 0)},	
			{Position = Vector(-720.1718, -2200.3330, 76.0313), Ang = Angle(5, 89, 0)},		
		},
	SpawnsCitizen = {
			--[[Behind bank		
			{Position = Vector(-7395, -7521, 136), Ang = Angle(-2, 90, 0)},
			{Position = Vector(-7396, -7620, 136), Ang = Angle(-2, 90, 0)},
			{Position = Vector(-7398, -7711, 136), Ang = Angle(-2, 90, 0)},
			{Position = Vector(-7399, -7809, 136), Ang = Angle(-2, 90, 0)},			
			{Position = Vector(-7400, -7898, 136), Ang = Angle(-2, 0, 0)},	
			{Position = Vector(-7401, -7964, 136), Ang = Angle(-2, 0, 0)},
			{Position = Vector(-7710, -7340, 136), Ang = Angle(-2, 0, 0)},	
			{Position = Vector(-7709, -7249, 136), Ang = Angle(-2, 0, 0)},	
			{Position = Vector(-7709, -7138, 136), Ang = Angle(-2, 0, 0)},	
			{Position = Vector(-7708, -6994, 136), Ang = Angle(-2, 0, 0)},	
			{Position = Vector(-7707, -6856, 136), Ang = Angle(-2, 0, 0)},	
			{Position = Vector(-7706, -6721, 136), Ang = Angle(-2, 0, 0)},	
			{Position = Vector(-7705, -6599, 136), Ang = Angle(-2, 0, 0)},	
			{Position = Vector(-7704, -6471, 136), Ang = Angle(-2, 0, 0)},	
			{Position = Vector(-7704, -6350, 136), Ang = Angle(-2, 0, 0)},	
			{Position = Vector(-7805, -6749, 136), Ang = Angle(-0, -1, 0)},
			{Position = Vector(-7807, -6852, 136), Ang = Angle(-0, -1, 0)},	
			{Position = Vector(-7809, -6969, 136), Ang = Angle(-0, -1, 0)},	
			{Position = Vector(-7811, -7086, 136), Ang = Angle(-0, -1, 0)},	
			{Position = Vector(-7813, -7180, 136), Ang = Angle(-0, -1, 0)},	
			{Position = Vector(-7816, -7339, 136), Ang = Angle(-0, -1, 0)},	
			{Position = Vector(-7390, -6780, 136), Ang = Angle(0, 90, 0)},	
			{Position = Vector(-7391, -6681, 136), Ang = Angle(0, 90, 0)},	
			{Position = Vector(-7391, -6568, 136), Ang = Angle(0, 90, 0)},	]]
			
			-- Sintek
			
			{Position = Vector(-569,981,131), Ang = Angle(0,-90,0)},
			{Position = Vector(-429,981,130), Ang = Angle(0,-90,0)},
			{Position = Vector(-74,976,121), Ang = Angle(0,-90,0)},
			{Position = Vector(87,994,127), Ang = Angle(0,-90,0)},
			{Position = Vector(69,854,133), Ang = Angle(0,-89,0)},
			{Position = Vector(-45,867,128), Ang = Angle(0,-89,0)},
			{Position = Vector(-135,859,129), Ang = Angle(0,-90,0)},
			{Position = Vector(-236,854,127), Ang = Angle(0,-90,0)},
			{Position = Vector(-374,853,130), Ang = Angle(0,-90,0)},
			{Position = Vector(-490,848,125), Ang = Angle(0,-90,0)},
			{Position = Vector(-625,851,129), Ang = Angle(0,-88,0)},
			{Position = Vector(-175,781,130), Ang = Angle(0,-179,0)},
			{Position = Vector(-172,681,131), Ang = Angle(0,-179,0)},
			{Position = Vector(-172,607,128), Ang = Angle(0,-179,0)},
			{Position = Vector(-167,510,129), Ang = Angle(0,-179,0)},
			{Position = Vector(130,420,131), Ang = Angle(0,89,0)},
			{Position = Vector(-3,421,130), Ang = Angle(0,89,0)},
			{Position = Vector(-150,424,131), Ang = Angle(0,89,0)},
			{Position = Vector(-306,426,134), Ang = Angle(0,89,0)},
			{Position = Vector(-487,425,132), Ang = Angle(0,89,0)},
			{Position = Vector(-487,312,132), Ang = Angle(0,-90,0)},
			{Position = Vector(-384,313,130), Ang = Angle(0,-90,0)},
			{Position = Vector(-265,310,124), Ang = Angle(0,-90,0)},
			{Position = Vector(-135,315,125), Ang = Angle(0,-90,0)},
			{Position = Vector(6,318,130), Ang = Angle(0,-90,0)},
			{Position = Vector(77,-56,131), Ang = Angle(0,-88,0)},
			{Position = Vector(129,318,132), Ang = Angle(0,-90,0)},
			{Position = Vector(127,64,131), Ang = Angle(0,91,0)},
			{Position = Vector(31,62,131), Ang = Angle(0,91,0)},
			{Position = Vector(-59,60,131), Ang = Angle(0,91,0)},
			{Position = Vector(-145,59,133), Ang = Angle(0,91,0)},
			{Position = Vector(-239,58,132), Ang = Angle(0,91,0)},
			{Position = Vector(-338,56,133), Ang = Angle(0,91,0)},
			{Position = Vector(-415,54,129), Ang = Angle(0,91,0)},
			{Position = Vector(-500,55,130), Ang = Angle(0,91,0)},
			{Position = Vector(-590,53,131), Ang = Angle(0,91,0)},
			{Position = Vector(-662,51,128), Ang = Angle(0,91,0)},
			{Position = Vector(-529,-66,131), Ang = Angle(0,-88,0)},
			{Position = Vector(-250,-69,130), Ang = Angle(0,-88,0)},


		},
	SpawnsMoney =  {
				{Position = Vector(1077,2,173),Ang = Angle(0, 180, 0)},
				{Position = Vector(1081,72,173),Ang = Angle(0, 180, 0)},
				{Position = Vector(992,39,173),Ang = Angle(0, 180, 0)},
				{Position = Vector(994,111,173),Ang = Angle(0, 180, 0)},
			},
	SpawnsCar = {
			{Position = Vector(1381,-2927,128), Ang = Angle(0, -90, 0)},
			{Position = Vector(1676,-2927,128), Ang = Angle(0,-90,0)},
			{Position = Vector(1992,-2929,128), Ang = Angle(0,-90,0)},
			{Position = Vector(1381,-2627,128), Ang = Angle(0, -90, 0)},
			{Position = Vector(1676,-2627,128), Ang = Angle(0,-90,0)},
			{Position = Vector(1992,-2629,128), Ang = Angle(0,-90,0)},
			},	
	AddObjs = {
		{	Class = "Bank_atm",
			Pos = Vector(1679,305,183),
			Angles = Angle(0,-90,0),
		--	Model ="models/env/misc/bank_atm/bank_atm.mdl", Bank
			Skin = 1,
			Activate = false,
		},
		{	Class = "Bank_atm",
			Pos = Vector(-3026,-1017,119),
			Angles = Angle(0,90,0),
		--	Model ="models/env/misc/bank_atm/bank_atm.mdl", Ace Hardware
			Skin = 1,
			Activate = false,
		},
		{	Class = "Bank_atm",
			Pos = Vector(3728,315,119),
			Angles = Angle(0,180,0),
		--	Model ="models/env/misc/bank_atm/bank_atm.mdl", Old Casino Hall
			Skin = 1,
			Activate = false,
		},		
		{	Class = "gov_resupply",
			Pos = Vector(-332,-2436,111),
			Angles = Angle(0,90,0),
			Activate = false,
		},		

	},	
	Function = function()
					AddNPC(Vector(-7681,1208,197), Angle(0, 0, 0) "OCRP_ShopMenu", "npc_gman","BP gas",{8})
					AddNPC(Vector(-2851,-1283,126), Angle(0, 140, 0), "OCRP_ShopMenu", "npc_barney","Materials",{5,6,7})
					AddNPC(Vector(3908,219,129), Angle(0, -45, 0), "OCRP_ShopMenu", "npc_eli","Materials",{2,1,3,4})
					AddNPC(Vector(-250,-1863,128), Angle(0, -180, 0), "OCRP_NPCTalk", "npc_mossman","Medic",{"Job_Medic001"})
					AddNPC(Vector(-248,-2026,128), Angle(0, 180, 0), "OCRP_NPCTalk", "npc_metropolice","Cop",{"Job_Cop001"})
					AddNPC(Vector(1246,1064,131), Angle(0, -180, 0), "OCRP_NPCTalk", "npc_kleiner","Mayor",{"Job_Mayor001"})	
					AddNPC(Vector(1372,-1934,294), Angle(0, 0, 0), "CL_CarDealer", "npc_eli","CarDealer",{})	
					AddNPC(Vector(1358,131,197), Angle(0, 0, 0), "OCRP_RelatorMenu", "npc_alyx","Relator",{})
					AddNPC(Vector(1707,-2470,132), Angle(0, -90, 0), "CL_Garage", "npc_eli", "Garage", {})
					AddNPC(Vector(1121,-1494,-117), Angle(0, -142, 0), "OCRP_NPCTalk","npc_metropolice" ,"Cop",{"Job_CopCar01"})
					AddNPC(Vector(-135,-1513,128), Angle(0, -123, 0), "OCRP_NPCTalk","npc_mossman", "Ambo",{"Job_Ambulence01"})					
					AddNPC(Vector(1250,924,130), Angle(0, -180, 0), "OCRP_NPCTalk", "npc_alyx","Org",{"Org"})
					AddNPC(Vector(11729,-11415,-1668), Angle(0, -122, 0), "OCRP_NPCTalk", "npc_alyx","Skin",{"Skin_001"})
					AddNPC(Vector(-7436,13836,254), Angle(0, -45, 0), "OCRP_ShopMenu", "npc_gman","Buying",{9})
					AddNPC(Vector(-2492,-1462,130), Angle(0, -90, 0), "OCRP_Model", "npc_gman", "Model", {})
					
					AddNPC(Vector(3958,602,578), Angle(0, -34, 0), "OCRP_ShopMenu", "npc_gman","Cheepies",{28})

					AddNPC(Vector(3661,-2497,134), Angle(0, 45, 0), "OCRP_ShopMenu", "npc_barney","Furniture",{29})
				
					AddNPC(Vector(3783,-1702,127), Angle(0,-90, 0), "OCRP_ShopMenu", "npc_kleiner","Mayor",{10,11,12,13,14,15,16,17,18,19,20,21,22,23,24},{Min = 120,Max = 900})		
				end,
}	

	
function SpawnCarPlaces()
	for _, data in pairs(GAMEMODE.CarPlaces) do
		local ent = ents.Create("dealer_car")
		ent:SetPos( data.Pos )
		ent:SetAngles( data.Angles )
		ent:Spawn()
		ent.Car = data.Car
		
		local ent2 = ents.Create("prop_dynamic")
		local mdla = GAMEMODE.OCRP_Cars[data.Car].Model
		if type(mdla) == "table" then
			mdla = mdla[1]
		end
		ent2:SetModel( mdla )
		ent2:SetPos( data.Pos2 )
		ent2:SetAngles( data.Angles2 )
		for k, v in pairs(ents.FindByName("car_rotator")) do
			if v:EntIndex() == data.ParentID then
				ent2:SetParent( v )
			end
		end
		ent2:Spawn()
	end
end
if string.lower(game.GetMap()) == "rp_cosmoscity" then
	hook.Add("InitPostEntity", "SpawnCarPlaces", SpawnCarPlaces) -- Just for testing.. - Jake	
end

util.PrecacheModel( "models/sickness/bmw-m5.mdl" )
util.PrecacheModel( "models/sickness/hummer-h2.mdl" )
util.PrecacheModel( "models/sickness/pmp600dr.mdl" )
util.PrecacheModel( "models/lambo/lambo.mdl" )
util.PrecacheModel( "models/mini/mini.mdl" )
util.PrecacheModel( "models/corvette/corvette.mdl" )
util.PrecacheModel( "models/corvette/corvett2.mdl" )
util.PrecacheModel( "models/corvette/corvett3.mdl" )
util.PrecacheModel( "models/corvette/corvett4.mdl" )
util.PrecacheModel( "models/rubicon.mdl" )
util.PrecacheModel( "models/rubicon2.mdl" )





