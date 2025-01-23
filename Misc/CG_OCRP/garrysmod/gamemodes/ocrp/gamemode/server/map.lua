
GM.CarPlaces = {
	{Car = "CAR_BMW_M5",
--	Pos = Vector(-2810.5938, -506.5625, 31.0313),
--	Angles = Angle(-8.395, -0.176, 0.571),
	Pos2 = Vector(-2943.0000, -507.0000, 12.5000),
	Angles2 = Angle(0,180,0),
--	ParentID = 490,
	},
	{Car = "CAR_PMP",
--	Pos = Vector(-3146.417480, -840.598145, 48.491394),
--	Angles = Angle(-8.395, -0.176, 0.571),
	Pos2 = Vector(-3289.0000, -839.0000, 12.5000),
	Angles2 = Angle(0,135,0),
--	ParentID = 489,
	},
	{Car = "CAR_HUMMER",
--	Pos = Vector(-2931.386963, -837.897766, 43.542248),
--	Angles = Angle(0,90,0),
	Pos2 = Vector(-2929.0000, -975.0000, 12.5000),
	Angles2 = Angle(0,45,0),
--	ParentID = 499,
	},
	{Car = "CAR_CORVETTE",
--	Pos = Vector(-4842.506348, 1923.634033, 50.639568),
--	Angles = Angle(4, 25, 0),
	Pos2 = Vector(-2570,-806,12.5),
	Angles2 = Angle(0,90,0),
--	ParentID = 503,
	},
}
	
	
	
RunConsoleCommand("ai_disable", 1)
	
GM.Maps = {}

GM.Maps["rp_cosmoscity_v1b"] = {
	RemoveVectors = {},
	ActUnOwnable = {},
	UnOwnable = {
				Vector(-1586,690,123),Vector(-1815,845,132),-- Bank
				Vector(6446,990,63),Vector(6600,1358,63),Vector(6660,1358,63),--  Cosmos FM 
				Vector(-2216,166,-364),-- Sewer entrance
				Vector(-3824,32,-2),Vector(-3824,-4160,-2),Vector(8432,32,-2),-- Man Holes
	},
	Public = {Vector(2296,-399,58),Vector(2296,-432,58),Vector(2632,-432,58),Vector(2632,-399,58),-- Modern Apartment doors
			Vector(-2624,-354,61),Vector(-2693,-354,61), -- First Car dealer
			Vector(-5232,-355,62),Vector(-4804,-355,62),Vector(-5062,-1190,72),Vector(-4974,-1190,72),Vector(-4806,-1196,62),Vector(-5230,-1196,62), -- Single floor apartments
			Vector(-1897,464,91),-- bANK
			Vector(5811,-432,84),Vector(5777,-467,84),-- Police Station
			Vector(-7000,-6000,53),Vector(-7000,-5952,53),-- Art museum
			Vector(4640,-674,60),Vector(4504,-1026,60),Vector(4520,-1110,60),Vector(4420,-578,79),Vector(4188,-578,79), -- medic
			Vector(6257,2615,64),Vector(6257,2665,64),-- Gas Station
			Vector(-2715,488,60),Vector(-2646,488,60),Vector(389,2848,65),Vector(6165,426,68),
			Vector(2919,-9171,62),-- Starline
	},
	Police = {
			Vector(6616,-1312,79),Vector(6619,-1455,79),Vector(6440,-1032,79),Vector(6296,-1032,79),Vector(6152,-1032,79),Vector(6008,-1032,79),Vector(5888,-1112,79),Vector(5888,-1256,79),
			Vector(5888,-1400,79),Vector(5888,-1544,79),Vector(6084,-1592,79),Vector(6385,-1592,79),Vector(6619,-1455,79),Vector(6707,-696,84),Vector(6203,-713,84),Vector(6040,-708,84),Vector(6448,-1660,84),
			--police dep
	},
	Locked = {
			Vector(6616,-1312,79),Vector(6619,-1455,79),Vector(6440,-1032,79),Vector(6296,-1032,79),Vector(6152,-1032,79),Vector(6008,-1032,79),Vector(5888,-1112,79),Vector(5888,-1256,79),
			Vector(5888,-1400,79),Vector(5888,-1544,79),Vector(6084,-1592,79),Vector(6385,-1592,79),Vector(6619,-1455,79),Vector(6707,-696,84),Vector(6203,-713,84),Vector(6040,-708,84),
			--police dep
			Vector(-1586,690,123),Vector(-1815,845,132),-- bank
			},
	Jails = {
			{Position = Vector(5811,-1583,30), Ang = Angle(0,0,0)},
			{Position = Vector(5811,-1444,30), Ang = Angle(0,0,0)},
			{Position = Vector(5811,-1299,30), Ang = Angle(0,0,0)},
			{Position = Vector(5814,-1152,30), Ang = Angle(0,0,0)},
			{Position = Vector(5967,-963,30), Ang = Angle(0,0,0)},
			{Position = Vector(6109,-958,30), Ang = Angle(0,0,0)},
			{Position = Vector(6254,-959,30), Ang = Angle(0,0,0)},
			{Position = Vector(6402,-959,30), Ang = Angle(0,0,0)},
	},
	SpawnsPolice = {},
	SpawnsMedic = {},
	SpawnsCitizen = {
			{Position = Vector(1393,-1281,5), Ang = Angle(0,0,0)},
			{Position = Vector(1285,-1373,5), Ang = Angle(0,0,0)},
			{Position = Vector(2786,872,6), Ang = Angle(0,0,0)},
			{Position = Vector(3888,827,6), Ang = Angle(0,0,0)},
			{Position = Vector(3459,642,6), Ang = Angle(0,0,0)},
			{Position = Vector(3082,651,6), Ang = Angle(0,0,0)},
			{Position = Vector(3931,494,6), Ang = Angle(0,0,0)},
			{Position = Vector(2861,492,6), Ang = Angle(0,0,0)},
			{Position = Vector(6213,2771,8), Ang = Angle(0,0,0)},
			{Position = Vector(6201,2510,8), Ang = Angle(0,0,0)},
			{Position = Vector(2421,-1045,10), Ang = Angle(0,0,0)},
			{Position = Vector(2555,-1057,6), Ang = Angle(0,0,0)},
			{Position = Vector(1241,1352,5), Ang = Angle(0,0,0)},
			{Position = Vector(1345,1247,5), Ang = Angle(0,0,0)},
			{Position = Vector(-5099,2128,6), Ang = Angle(0,0,0)},
			{Position = Vector(-4941,2127,6), Ang = Angle(0,0,0)},
			{Position = Vector(-4942,1992,6), Ang = Angle(0,0,0)},
			{Position = Vector(-5099,1994,6), Ang = Angle(0,0,0)},
			{Position = Vector(-4938,-842,8), Ang = Angle(0,0,0)},
			{Position = Vector(-5095,-844,8), Ang = Angle(0,0,0)},
			{Position = Vector(-5093,-667,8), Ang = Angle(0,0,0)},
			{Position = Vector(-4934,-664,8), Ang = Angle(0,0,0)},
			{Position = Vector(-6259,-5854,0), Ang = Angle(0,0,0)},
			{Position = Vector(-6254,-6257,0), Ang = Angle(0,0,0)},
	},
	SpawnsCar = {
			{Position = Vector(), Ang = Angle(0,91,0)},
			{Position = Vector(-2631,-1662,3), Ang = Angle(0,91,0)},
			{Position = Vector(-2628,-1507,3), Ang = Angle(0,91,0)},
			{Position = Vector(-3015,-1502,3), Ang = Angle(0,93,0)},
			{Position = Vector(-3284, -1560, 7), Ang = Angle(0,93,0)},
			{Position = Vector(-3269, -1774, 7), Ang = Angle(0,93,0)},
		--	{Position = Vector(-2478.0261, -1472.8445, 7.0313), Ang = Angle(0,0,0)},
		--	{Position = Vector(-2487.3040, -1622.1737, 7.0313), Ang = Angle(0,0,0)},
		--	{Position = Vector(-2495.4661, -1803.6760, 7.0313), Ang = Angle(0,0,0)},
			},
	AddObjs = {
		{	Class = "Bank_atm",
			Pos = Vector(-1568,462,7),  
			Angles = Angle(0,-90,0),
		--	Model ="models/env/misc/bank_atm/bank_atm.mdl", Sintek
			Skin = 1,
			Activate = false,
		},

		{	Class = "gov_resupply",
			Pos = Vector(5715,-775,30), 
			Angles = Angle(0,0,0),
			Skin = 1,
			Activate = false,
		},

	},
	Function = function()
					AddNPC(Vector(6548,2655,10), Angle(0, 180, 0), "OCRP_ShopMenu", "npc_gman","BP gas",{8})--
					AddNPC(Vector(52,3118,7), Angle(0, -45, 0), "OCRP_ShopMenu", "npc_barney","Materials",{5,6,7})--
					AddNPC(Vector(3127,-2234,-409), Angle(0,-90, 0), "OCRP_ShopMenu", "npc_eli","Drugs",{2,1,3,4})--
					AddNPC(Vector(4673,-838,6),Angle(0, 90, 0), "OCRP_NPCTalk", "npc_mossman","Medic",{"Job_Medic001"})--
					AddNPC(Vector(6148,-518,30),Angle(0, 180, 0), "OCRP_NPCTalk", "npc_metropolice","Cop",{"Job_Cop001"})--
					AddNPC(Vector(-7634,-6198,0),Angle(0, 90, 0), "OCRP_NPCTalk", "npc_kleiner","Mayor",{"Job_Mayor001"})--
					AddNPC(Vector(-3332,-1268,52),Angle(0, 0, 0), "SV_CarDealer", "npc_eli","CarDealer",{})--
					AddNPC(Vector(-5017,-1451,8),Angle(0, 90, 0), "OCRP_RelatorMenu", "npc_alyx","Relator",{})--
					AddNPC(Vector(-2327, -1932, 71),Angle(0, 135, 0), "SV_Garage", "npc_eli", "Garage", {})--
					AddNPC(Vector(6565,-1565,30),Angle(0, 180, 0), "OCRP_NPCTalk","npc_metropolice" ,"Cop",{"Job_CopCar01"})--
					AddNPC(Vector(4759,-849,6),Angle(0,90, 0), "OCRP_NPCTalk","npc_alyx", "Ambo",{"Job_Ambulence01"})--				
					AddNPC(Vector(-3192,1970,7),Angle(0, 0, 0), "OCRP_NPCTalk", "npc_alyx","Org",{"Org"})--
					AddNPC(Vector(-9017,-10104,136),Angle(12,137,0), "OCRP_NPCTalk", "npc_alyx","Respray",{"Skin_001"})--
					AddNPC(Vector(-7442,-6675,0),Angle(0, 90, 0), "OCRP_ShopMenu", "npc_gman","Boxes",{9})--
					AddNPC(Vector(-7631,-5763,0),Angle(0, -90, 0), "OCRP_Model", "npc_gman", "KFC", {})--
					//setpos setpos -9017.675781 -10104.487305 136.031250;setang 12.979987 137.580246 0.000000


					AddNPC(Vector(-2028,876,-384),Angle(0, -90, 0), "OCRP_ShopMenu", "npc_gman","Cheepies",{28})--

					AddNPC(Vector(6429,399,14),Angle(0, 90, 0), "OCRP_ShopMenu", "npc_barney","Furniture",{29})--
				
					AddNPC(Vector(-7190,-5735,0),Angle(0,-90, 0), "OCRP_ShopMenu", "npc_kleiner","Mayor",{10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25},{Min = 120,Max = 900})	--	
					
				end,
 }

function GM.ProtectCave ( )
	for k, v in pairs(ents.FindInSphere(Vector(-8951, 13034, 283), 1500)) do //
		if v and v:IsValid() then
			if v:IsPlayer() then
				if v:Alive() then
					v:Spawn()
					v:Hint('Ask an admin to fully respawn you - This shit is broken. AND STAY AWAY FROM THE CAVE.');
				end
			else
				v:Remove();
			end
		end
	end
end

if string.lower(game.GetMap()) == "rp_evocity_v2d" then
	hook.Add('Think', 'GM.ProtectCave', GM.ProtectCave);
end


 
GM.Maps["rp_evocity_v2d"] = {
	RemoveVectors = {Vector(3586,-6770,185),Vector(-2890,-130,95),},
	UnOwnable = {Vector(-7992,-8929,2542),Vector(-7880,-9163,2541),Vector(-7640,-9163,2541),Vector(-6862,-9479,2542),Vector(-6830,-8915,2670),
	Vector(-5084,-9417,126),Vector(-6693,-7899,126),Vector(-6809,-7605,128),},
	
	ActUnOwnable = {},
	
	Public = {Vector(-6485,-7663,135),Vector(-6485,-7727,135),Vector(-5598,-6866,126),Vector(-5598,-6228,126),
				Vector(-7039,-6062,135),Vector(-7039,-6002,135),Vector(-6956,-4459,135),Vector(-7020,-4459,135),Vector(-5445,-4762,135),
				Vector(-5445,-4702,135),Vector(-5445,-4514,135),Vector(-5445,-4454,135),Vector(-5539,-9255,135),Vector(-5539,-9315,135),
				Vector(10602,-12424,-995),Vector(10474,-12424,-995),Vector(-6748,-8653,136),Vector(-7004,-8653,136),Vector(-7676,-8685,168),
				Vector(-7580,-8427,-280),Vector(-7232,-9489,126),Vector(-6928,-9489,-74),Vector(-4656,-7001,254),
				Vector(-4777,-9263,134),Vector(-4777,-9307,134),Vector(-4771,-9307,289),Vector(-4771,-9263,461),Vector(-8992,-9769,130),Vector(-8992,-9985,130),Vector(-9120,-9041,190),
				Vector(5784,-4373,126),Vector(4239,-4174,135),Vector(4117,-4174,135),Vector(4854,-3719,135),Vector(-4777,-9307,1670),Vector(-4777,-9263,1670),
				Vector(-3849,-6370,261),Vector(-3849,-6430,261), -- Flea market
			},


	Police = {Vector(-6560,-9185,895),Vector(-7704,-9210,894),Vector(-7704,-9104,894),Vector(-7872,-9210,894),Vector(-7872,-9104,894),Vector(-7682,-8529,-322),
			Vector(-7490,-8389,-2136),Vector(-7388,-8389,-2138),Vector(-6812,-8461,-2138),Vector(-6584,-8461,-2138),Vector(-7196,-8205,-2138),Vector(-7252,-8205,-2138),
			Vector(-7838,-7869,-2162),Vector(-7838,-8049,-2161),Vector(-6942,-7997,-2138),Vector(-6528,-7783,-2138),
			Vector(-8040,-9210,894),Vector(-8040,-9104,894),Vector(-8097,-9153,894),Vector(-6485,-7663,135),Vector(-7800,-8961,1788),Vector(-7936,-8781,1790),
			Vector(-7449,-7782,-2156), 
			},
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
		{	Class = "bank_atm",
			Pos = Vector(-6448 ,-7816, 72.0313),
			Angles = Angle(0,90,0),
		--	Model ="models/env/misc/bank_atm/bank_atm.mdl", Bank
			Skin = 1,
			Activate = false,
		},
		{	Class = "bank_atm",
			Pos = Vector(-4829, -4855, 208.0313),
			Angles = Angle(0,90,0),
		--	Model ="models/env/misc/bank_atm/bank_atm.mdl", Tides
			Skin = 1,
			Activate = false,
		},
		{	Class = "bank_atm",
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
		{	Class = "money_spawn",
			Pos = Vector(-6755,-7557,95),
			Angles = Angle(0,90,0),
			Activate = false,
		},
		{	Class = "money_spawn",
			Pos = Vector(-6755,-7491,95),
			Angles = Angle(0,90,0),
			Activate = false,
		},
		{	Class = "money_spawn",
			Pos = Vector(-6850,-7483,95),
			Angles = Angle(0,90,0),
			Activate = false,
		},
		{	Class = "money_spawn",
			Pos = Vector(-6850,-7546,95),
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
					AddNPC(Vector(4597,-4340,204), Angle(0, 90, 0), "SV_CarDealer", "npc_eli","CarDealer",{})	
					AddNPC(Vector(-6722,-7736,72), Angle(0, 0, 0), "OCRP_RelatorMenu", "npc_alyx","Relator",{})
					AddNPC(Vector(-5317,-10301,71), Angle(0, 145, 0), "SV_Garage", "npc_eli", "Garage", {})
					AddNPC(Vector(-7307,-9036,72), Angle(0, 0, 0), "OCRP_NPCTalk","npc_metropolice" ,"Cop",{"Job_CopCar01"})
					AddNPC(Vector(-7279,-8866,72), Angle(0, 0, 0), "OCRP_NPCTalk","npc_mossman", "Ambo",{"Job_Ambulence01"})					
					AddNPC(Vector(-6730,-7668,72), Angle(0, 0, 0), "OCRP_NPCTalk", "npc_alyx","Org",{"Org"})
					AddNPC(Vector(-9021,-9873,150),Angle(-1,179,0), "OCRP_NPCTalk", "npc_alyx","Respray",{"Skin_001"})
					AddNPC(Vector(-3211,-6410,198), Angle(0, 180, 0), "OCRP_ShopMenu", "npc_gman","Buying",{9})
					AddNPC(Vector(-6972,-4673,136), Angle(0, 0, 0), "OCRP_Model", "npc_gman", "KFC", {})
					AddNPC(Vector(-7285,-8949,72), Angle(0, 0, 0), "OCRP_NPCTalk", "npc_eli","Fireman",{"Job_FireEngine01"})
					AddNPC(Vector(-6475,-9393,72),  Angle(0,135,0), "OCRP_NPCTalk", "npc_eli","Fireman",{"Job_Fire001"})		
					AddNPC(Vector(-7050,-9425,-128), Angle(0, 90, 0), "OCRP_ShopMenu", "npc_gman","Cheepies",{28})
//setpos setpos setpos -9021.087891 -9873.816406 181.031250;setang -1.420002 179.380035 0.000000

					AddNPC(Vector(-4648,-4589,208), Angle(0, 180, 0), "OCRP_ShopMenu", "npc_barney","Furniture",{29})
				
					AddNPC(Vector(-5405,-6603,72), Angle(0,-90, 0), "OCRP_ShopMenu", "npc_kleiner","Mayor",{10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25},{Min = 120,Max = 900})		
					
					timer.Simple(5,function() 
								local key = 0
								for _,v in pairs(GAMEMODE.Properties[string.lower(game.GetMap())]) do
									if v.Name == "Cub Foods" then
										key = _
										break
									end
								end
								for _,entity in pairs(ents.FindInSphere(Vector(-3848,-7735,258),5)) do
									if entity:IsValid() && entity:IsDoor()  then
										entity.Propertykey = key
										break
									end
								end
								for _,v in pairs(GAMEMODE.Properties[string.lower(game.GetMap())]) do
									if v.Name == "Abandoned House" then
										key = _
										break
									end
								end
								for _,entity in pairs(ents.FindInSphere(Vector(-2876,-127,113),5)) do
									if entity:IsValid() && entity:IsDoor() then
										entity.Propertykey = key
										break
									end
								end
					end)
				end,
}	

GM.Maps["rp_evocity2_v2p"] = {
	RemoveVectors = {Vector(4008,-3122,311),Vector(1880,-2428,154),Vector(2580,-2960,154),Vector(671,-1589,-108),},
	UnOwnable = {Vector(-316,-2230,522),Vector(-316,-1678,522),Vector(72,-1220,532),Vector(-61,-1220,532), // Floor one nexus offices
	Vector(-409,-2124,1802),Vector(-487,-2124,1802),Vector(-487,-1752,1802),Vector(-409,-1752,1802), // Floor two nexus offices
	Vector(-9,-1452,3849),Vector(-103,-1452,3849),Vector(-384,-1929,3849),Vector(-384,-1977,3849), // Floor three nexus offices
	Vector(1366,5,207),},
				
	ActUnOwnable = {Vector(120,-2124,134),Vector(82,-2124,139),Vector(87,-2115,121),Vector(133,-2115,119),Vector(120,-2122,514),Vector(68,-2122,510),Vector(123,-2122,1797),Vector(82,-2122,1792),Vector(123,-2122,3838),Vector(84,-2122,3832), // Nexus Elevator doors
					Vector(3974,-2233,265),Vector(3783,-2383,275),Vector(3823,-1769,377),Vector(4069,-2223,531),Vector(4085,-2639,315), // Showers
					Vector(-296,1057,130),Vector(-295,1062,129),Vector(-233,1057,129),Vector(-233,1062,129),Vector(-255,1058,552),Vector(-279,1058,553),Vector(-251,1058,906),Vector(-281,1058,898), // sintek elevator
					Vector(359,-2174,-368),Vector(884,-2171,-368),Vector(-232,-1719,-368), // big jail doors
					Vector(462,-2073,-377),Vector(590,-2073,-377),Vector(718,-2073,-377),Vector(846,-2073,-377),Vector(846,-2272,-377),Vector(718,-2272,-377),Vector(590,-2272,-377),Vector(462,-2272,-377), // Jail cells
					Vector(930,-2474,-86), // Cop garage door
					Vector(-636,3026,148), // BK Drivethru door
					Vector(-2776,3484,42),Vector(-2552,3484,42), // Midas car lifts
					Vector(2714,858,-1704),Vector(2714,932,-1708),Vector(2247,935,-1704),Vector(2247,871,-1704), // Underground train doors
					},
	
	Public = {Vector(2037,-51,202),Vector(1975,-51,202),Vector(1911,-51,202),Vector(1849,-51,202), //Train station upper
	Vector(3740,-2146,132),Vector(3740,-2086,132), // apartments front
	Vector(2580,-1568,138),Vector(2580,-1632,138), // car dealer
	Vector(3739,427,130),Vector(4147,634,583), // old casino building from perp
	Vector(3795,2436,194), // Slums entrance
	Vector(4,2860,139),Vector(4,2796,139),Vector(-255,3434,130), // Burger King
	Vector(-711,610,139),Vector(-711,670,139), // Sintek
	Vector(-748,-1452,138),Vector(-700,-1452,138),Vector(-468,-1452,138),Vector(-420,-1452,138), // GC Main entrance
	Vector(-2412,1052,139),Vector(-2412,988,139),Vector(-2514,892,139),Vector(-2450,892,139),Vector(-2412,760,130),Vector(-2690,756,130),Vector(-2814,388,139),Vector(-2705,532,130),Vector(-2705,484,130),Vector(-2862,756,130), // Hospital
	Vector(-2882,-1028,130),// Ace Hardware 
	Vector(-2438,-1653,139),Vector(-2498,-1653,139),Vector(-2786,-1376,130), // Clothes store
	Vector(7962,7150,133),Vector(7962,7210,133),Vector(8304,7930,133),Vector(8373,7930,133), // Train station @ cubs
	Vector(-7388,1246,202),Vector(-7395,866,203),Vector(-7395,1038,203), // Sinclair Gas
	Vector(1784,108,203),Vector(1784,156,203), // Bank
	Vector(-7139,13637,252), // bar
	Vector(1057,962,139),Vector(1057,1022,139), // City Building
	Vector(3893,-1925,128),Vector(3869,-2307,126), // Furniture/bookstore
	},

	--[[Vector(4854,-3719,135),Vector(-4777,-9307,1670),Vector(-4777,-9263,1670),
	Vector(-3849,-6370,261),Vector(-3849,-6430,261), -- Flea market ]]--


	Police = {Vector(-522,-1460,-374),Vector(-570,-1460,-374),Vector(-600,-1530,-374),Vector(-664,-1817,-374),Vector(-213,-2104,-374),Vector(340,-2687,-374),Vector(340,-2735,-374),Vector(1006,-1941,-377),Vector(-187,-2082,-369),},
	Locked = {Vector(1365,4,194),}, // Bank back door
	Jails = {
			{Position = Vector(442.2706,-2016.2340,-427.9688), Ang = Angle(-0, 179, 0)},
			{Position = Vector(559.1437,-2012.1986,-427.9688), Ang = Angle(4, -178, 0)},
			{Position = Vector(686.5288,-2013.2102,-427.9688), Ang = Angle(15, -87, 0)},
			{Position = Vector(815.6661,-2010.0499,-427.9688), Ang = Angle(20, 91, 0)},
			{Position = Vector(813.0894,-2335.7334,-427.9688), Ang = Angle(14, 90, 0)},
			{Position = Vector(693.0419,-2331.1238,-427.9688), Ang = Angle(14, -87, 0)},
			{Position = Vector(564.0787,-2333.3154,-427.9688), Ang = Angle(16, -1, 0)},
			{Position = Vector(435.8467,-2332.6558,-427.9688), Ang = Angle(16, -1, 0)},
			},
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
						
			-- Sintek
			--[[
			{Position = Vector(-569,981,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-429,981,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-74,976,70), Ang = Angle(0,-90,0)},
			{Position = Vector(87,994,70), Ang = Angle(0,-90,0)},
			{Position = Vector(69,854,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-45,867,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-135,859,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-236,854,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-374,853,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-490,848,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-625,851,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-175,781,70), Ang = Angle(0,180,0)},
			{Position = Vector(-172,681,70), Ang = Angle(0,180,0)},
			{Position = Vector(-172,607,70), Ang = Angle(0,180,0)},
			{Position = Vector(-167,510,70), Ang = Angle(0,180,0)},
			{Position = Vector(130,420,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-3,421,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-150,424,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-306,426,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-487,425,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-487,312,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-384,313,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-265,310,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-135,315,70), Ang = Angle(0,-90,0)},
			{Position = Vector(6,318,70), Ang = Angle(0,-90,0)},
			{Position = Vector(77,-56,70), Ang = Angle(0,-90,0)},
			{Position = Vector(129,318,70), Ang = Angle(0,-90,0)},
			{Position = Vector(127,64,70), Ang = Angle(0,-90,0)},
			{Position = Vector(31,62,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-59,60,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-145,59,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-239,58,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-338,56,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-415,54,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-500,55,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-590,53,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-662,51,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-529,-66,70), Ang = Angle(0,-90,0)},
			{Position = Vector(-250,-69,70), Ang = Angle(0,-90,0)},

			-- Back of car dealer
			{Position = Vector(1390,-1710,70), Ang = Angle(0,0,0)},
			{Position = Vector(1387,-1785,70), Ang = Angle(0,0,0)},
			{Position = Vector(1383,-1854,70), Ang = Angle(0,0,0)},
			{Position = Vector(1388,-1946,70), Ang = Angle(0,0,0)},
			{Position = Vector(1395,-2021,70), Ang = Angle(0,0,0)},
			{Position = Vector(1389,-2106,70), Ang = Angle(0,0,0)},
			{Position = Vector(1393,-2186,70), Ang = Angle(0,0,0)},
			{Position = Vector(1391,-2273,70), Ang = Angle(0,0,0)},
			{Position = Vector(1392,-2359,70), Ang = Angle(0,0,0)},
			{Position = Vector(1480,-2365,70), Ang = Angle(0,0,0)},
			{Position = Vector(1477,-2279,70), Ang = Angle(0,0,0)},
			{Position = Vector(1476,-2173,70), Ang = Angle(0,0,0)},
			{Position = Vector(1475,-2085,70), Ang = Angle(0,0,0)},
			{Position = Vector(1471,-1983,70), Ang = Angle(0,0,0)},
			{Position = Vector(1469,-1899,70), Ang = Angle(0,0,0)},
			{Position = Vector(1467,-1799,70), Ang = Angle(0,0,0)},
			{Position = Vector(1464,-1709,70), Ang = Angle(0,0,0)},
			{Position = Vector(1462,-1627,70), Ang = Angle(0,0,0)},
			{Position = Vector(1461,-1528,70), Ang = Angle(0,0,0)},
			{Position = Vector(1458,-1432,70), Ang = Angle(0,0,0)},
			{Position = Vector(1456,-1345,70), Ang = Angle(0,0,0)},
			{Position = Vector(1454,-1271,70), Ang = Angle(0,0,0)},

			-- Bus stop spawns
			{Position = Vector(326,601,80), Ang = Angle(0,3,0)},
			{Position = Vector(320,640,80), Ang = Angle(0,0,0)},
			{Position = Vector(316,678,80), Ang = Angle(0,0,0)},
			{Position = Vector(2227,-3114,80), Ang = Angle(0,-89,0)},
			{Position = Vector(2190,-3115,80), Ang = Angle(0,-89,0)},
			{Position = Vector(2154,-3114,80), Ang = Angle(0,-89,0)},
			{Position = Vector(-2096,-3287,80), Ang = Angle(0,1,0)},
			{Position = Vector(-2088,-3244,80), Ang = Angle(0,2,0)},
			{Position = Vector(-2097,-3208,80), Ang = Angle(0,1,0)},
			{Position = Vector(-1976,-113,80), Ang = Angle(0,0,0)},
			{Position = Vector(-1978,-66,80), Ang = Angle(0,0,0)},
			{Position = Vector(-1977,-31,80), Ang = Angle(0,0,0)},
			{Position = Vector(-1949,3140,80), Ang = Angle(0,1,0)},
			{Position = Vector(-1948,3189,80), Ang = Angle(0,1,0)},
			{Position = Vector(-1951,3230,80), Ang = Angle(0,1,0)},
			{Position = Vector(3559,380,80), Ang = Angle(0,-178,0)},
			{Position = Vector(3556,341,80), Ang = Angle(0,179,0)},
			{Position = Vector(3555,305,80), Ang = Angle(0,179,0)},]]--
			
			-- Green line subway spawns
			
			{Position = Vector(2555,6930,-1740), Ang = Angle(0,-176,0)},
			{Position = Vector(2558,6862,-1740), Ang = Angle(0,178,0)},
			{Position = Vector(2386,6815,-1740), Ang = Angle(0,-178,0)},
			{Position = Vector(2381,6959,-1740), Ang = Angle(0,-178,0)},
			{Position = Vector(2382,7099,-1740), Ang = Angle(0,-178,0)},
			{Position = Vector(2374,7269,-1740), Ang = Angle(0,-178,0)},
			{Position = Vector(2371,7428,-1740), Ang = Angle(0,-178,0)},
			{Position = Vector(2367,7604,-1740), Ang = Angle(0,-178,0)},
			{Position = Vector(2362,7709,-1740), Ang = Angle(0,-178,0)},
			
			-- City train station underground
			
			{Position = Vector(2413,1560,-1740), Ang = Angle(0,-90,0)},
			{Position = Vector(2414,1467,-1740), Ang = Angle(0,-90,0)},
			{Position = Vector(2414,1369,-1740), Ang = Angle(0,-90,0)},
			{Position = Vector(2410,1261,-1740), Ang = Angle(0,-90,0)},
			{Position = Vector(2413,1159,-1740), Ang = Angle(0,-90,0)},
			{Position = Vector(2417,1046,-1740), Ang = Angle(0,-90,0)},
			{Position = Vector(2414,957,-1740), Ang = Angle(0,-90,0)},
			{Position = Vector(2418,847,-1740), Ang = Angle(0,-90,0)},
			{Position = Vector(2417,739,-1740), Ang = Angle(0,-90,0)},
			{Position = Vector(2410,639,-1740), Ang = Angle(0,-90,0)},
			{Position = Vector(2543,1578,-1740), Ang = Angle(0,-90,0)},
			{Position = Vector(2537,1513,-1740), Ang = Angle(0,-90,0)},
			{Position = Vector(2542,1384,-1740), Ang = Angle(0,-90,0)},
			{Position = Vector(2543,1288,-1740), Ang = Angle(0,-90,0)},
			{Position = Vector(2542,1187,-1740), Ang = Angle(0,-90,0)},
			{Position = Vector(2538,1072,-1740), Ang = Angle(0,-90,0)},
			{Position = Vector(2541,970,-1740), Ang = Angle(0,-90,0)},
			{Position = Vector(2541,862,-1740), Ang = Angle(0,-90,0)},
			{Position = Vector(2540,768,-1740), Ang = Angle(0,-90,0)},
			{Position = Vector(2544,659,-1740), Ang = Angle(0,-90,0)},
			{Position = Vector(2722,457,-1740), Ang = Angle(0,91,0)},
			{Position = Vector(2644,456,-1740), Ang = Angle(0,91,0)},
			{Position = Vector(2575,454,-1740), Ang = Angle(0,91,0)},
			{Position = Vector(2470,453,-1740), Ang = Angle(0,91,0)},
			{Position = Vector(2367,452,-1740), Ang = Angle(0,91,0)},
			{Position = Vector(2264,451,-1740), Ang = Angle(0,91,0)},
			{Position = Vector(2236,171,-1740), Ang = Angle(0,92,0)},
			{Position = Vector(2346,176,-1740), Ang = Angle(0,92,0)},
			{Position = Vector(2625,183,-1740), Ang = Angle(0,92,0)},
			{Position = Vector(2731,185,-1740), Ang = Angle(0,89,0)},
			
		},
	SpawnsMoney =  {
				{Position = Vector(1077,2,150),Ang = Angle(0, 180, 0)},
				{Position = Vector(1081,72,150),Ang = Angle(0, 180, 0)},
				{Position = Vector(992,39,150),Ang = Angle(0, 180, 0)},
				{Position = Vector(994,111,150),Ang = Angle(0, 180, 0)},
			},
	SpawnsCar = {
			{Position = Vector(1381,-2927,150), Ang = Angle(0, -90, 0)},
			{Position = Vector(1676,-2927,150), Ang = Angle(0,-90,0)},
			{Position = Vector(1992,-2929,150), Ang = Angle(0,-90,0)},
			{Position = Vector(1381,-2627,150), Ang = Angle(0, -90, 0)},
			{Position = Vector(1676,-2627,150), Ang = Angle(0,-90,0)},
			{Position = Vector(1992,-2629,150), Ang = Angle(0,-90,0)},
			},	
	AddObjs = {
		{	Class = "Bank_atm",
			Pos = Vector(185,-1607.94,75),
			Angles = Angle(0,180,0),
		--	Model ="models/env/misc/bank_atm/bank_atm.mdl", Nexus Lobby
			Skin = 1,
			Activate = false,
		},
		{	Class = "Bank_atm",
			Pos = Vector(-697,321,76),
			Angles = Angle(0,0,0),
		--	Model ="models/env/misc/bank_atm/bank_atm.mdl", Sintek
			Skin = 1,
			Activate = false,
		},
		{	Class = "Bank_atm",
			Pos = Vector(7974,6090.01,70),
			Angles = Angle(0,0,0),
		--	Model ="models/env/misc/bank_atm/bank_atm.mdl", Cubs
			Skin = 1,
			Activate = false,
		},	
		{	Class = "Bank_atm",
			Pos = Vector(-60,2932.9,76),
			Angles = Angle(0,-90,0),
		--	Model ="models/env/misc/bank_atm/bank_atm.mdl", BK
			Skin = 1,
			Activate = false,
		},	
		{	Class = "money_spawn",
			Pos = Vector(1077,2,170),
			Angles = Angle(0,90,0),
			Activate = false,
		},
		{	Class = "money_spawn",
			Pos = Vector(1081,72,170),
			Angles = Angle(0,90,0),
			Activate = false,
		},
		{	Class = "money_spawn",
			Pos = Vector(992,39,170),
			Angles = Angle(0,90,0),
			Activate = false,
		},
		{	Class = "money_spawn",
			Pos = Vector(994,111,170),
			Angles = Angle(0,90,0),
			Activate = false,
		},
		{	Class = "gov_resupply",
			Pos = Vector(-332,-2436,75),
			Angles = Angle(0,90,0),
			Activate = false,
		},		

	},	
	Function = function()
					print("Doing NPCS")
					AddNPC(Vector(1348,125,140), Angle(0, 0, 0), "OCRP_RelatorMenu", "npc_alyx","Relator",{})
					AddNPC(Vector(-7697,1204,197), Angle(0, 0, 0), "OCRP_ShopMenu", "npc_gman","BP gas",{8})
					AddNPC(Vector(-2851,-1283,126), Angle(0, 140, 0), "OCRP_ShopMenu", "npc_barney","Materials",{5,6,7})
					AddNPC(Vector(3908,219,129), Angle(0, -45, 0), "OCRP_ShopMenu", "npc_eli","Materials",{2,1,3,4})
					AddNPC(Vector(-243,-1864,123), Angle(0, -180, 0), "OCRP_NPCTalk", "npc_mossman","Medic",{"Job_Medic001"})
					AddNPC(Vector(-235,-2027,129), Angle(0, 180, 0), "OCRP_NPCTalk", "npc_metropolice","Cop",{"Job_Cop001"})
					AddNPC(Vector(1264,1050,128),  Angle(0, -180, 0), "OCRP_NPCTalk", "npc_kleiner","Mayor",{"Job_Mayor001"})	
					AddNPC(Vector(1372,-1934,294), Angle(0, 0, 0), "SV_CarDealer", "npc_eli","CarDealer",{})	
					AddNPC(Vector(1707,-2470,132), Angle(0, -90, 0), "SV_Garage", "npc_eli", "Garage", {})
					AddNPC(Vector(1121,-1494,-117), Angle(0, -142, 0), "OCRP_NPCTalk","npc_metropolice" ,"Cop",{"Job_CopCar01"})
					AddNPC(Vector(-135,-1513,128), Angle(0, -123, 0), "OCRP_NPCTalk","npc_mossman", "Ambo",{"Job_Ambulence01"})					
					AddNPC(Vector(1260,921,128), Angle(0, -180, 0), "OCRP_NPCTalk", "npc_alyx","Org",{"Org"})
					AddNPC(Vector(11335,-12361,-1668), Angle(0, 45, 0), "OCRP_NPCTalk", "npc_alyx","Skin",{"Skin_001"})
					AddNPC(Vector(3958,602,578), Angle(0, -34, 0), "OCRP_ShopMenu", "npc_gman","Buying",{9})
					AddNPC(Vector(-2492,-1462,130), Angle(0, -90, 0), "OCRP_Model", "npc_gman", "Model", {})
					
					AddNPC(Vector(-7436,13836,254), Angle(0, -45, 0), "OCRP_ShopMenu", "npc_gman","Cheepies",{28})

					AddNPC(Vector(3699,-2486,76), Angle(0, 45, 0), "OCRP_ShopMenu", "npc_barney","Furniture",{29})
					AddNPC(Vector(-769,-1868,76), Angle(0, 0, 0), "OCRP_NPCTalk", "npc_eli","Fireman",{"Job_FireEngine01"})
					AddNPC(Vector(-757,-2078,76),  Angle(0,0,0), "OCRP_NPCTalk", "npc_eli","Fireman",{"Job_Fire001"})	

					AddNPC(Vector(3852,-1723,76), Angle(0,-90, 0), "OCRP_ShopMenu", "npc_kleiner","Mayor",{10,11,12,13,14,15,16,17,18,19,20,21,22,23,24},{Min = 120,Max = 900})		
				end,
}	
	
function SpawnCarPlaces()
	for _, data in pairs(GAMEMODE.CarPlaces) do
		local ent2 = ents.Create("prop_dynamic")
		local mdla = GAMEMODE.OCRP_Cars[data.Car].Model
		if type(mdla) == "table" then
			mdla = mdla[1]
		end
		ent2:SetModel( mdla )
		ent2:SetPos( data.Pos2 )
		ent2:SetAngles( data.Angles2 )
		for k, v in pairs(ents.FindInSphere(data.Pos2, 40)) do
			if v:GetClass() == "func_rotating" then
				ent2:SetParent( v )
			end
		end
		ent2:Spawn()
	end
end
if string.lower(game.GetMap()) == "rp_cosmoscity_v1b" then
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





