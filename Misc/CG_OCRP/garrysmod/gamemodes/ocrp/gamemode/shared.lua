--[[function AutoAdd_LuaFiles()
	if SERVER then
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/client/*') || {} ) do
			if string.find(file,".lua") then
				AddCSLuaFile('client/'..file)
				Msg(file..",")
			end
		end
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/shared/*') || {}) do
			if string.find(file,".lua") then
				AddCSLuaFile('shared/'..file)
				include('shared/'..file)
				Msg(file..",")
			end
		end
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/server/*') || {} ) do
			if string.find(file,".lua") then
				include('server/'..file)
				Msg(file..",")
			end
		end
	else
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/shared/*') || {}) do
			if string.find(file,".lua") then
				include('shared/'..file)
				Msg(file..",")
			end
		end
		for _, file in pairs(file.Find('../gamemodes/' .. GM.Path .. '/gamemode/client/*') || {} ) do
			if string.find(file,".lua") then
				include('client/'..file)
				Msg(file..",")
			end
		end
	end
end
]]

GM.Name 		= "Orange Cosmos RP"
GM.Author 		= "Jake_1305 and Noobulator"
GM.Email 		= "jake1305@gmail.com"
GM.Website 		= ""
GM.TeamBased 	= false

GM.Path = "OCRP";
GM.CurrentTime = 0;

--Let's add the CLASSES
CLASS_CITIZEN = 1 -- The Citizen Class
CLASS_MEDIC = 2 -- The Medic Class
CLASS_POLICE = 3 -- The Police Class
CLASS_SWAT = 4 -- Mayor Team
CLASS_CHIEF = 5
CLASS_Mayor = 6 -- Mayor Team
CLASS_FIREMAN = 7
--End adding CLASSES

PMETA = FindMetaTable( "Player" )

NUMBER_FIREMEN = 0

--Lets set up the teams as the following:
team.SetUp (CLASS_CITIZEN, "Citizen", Color (34, 180, 0, 255))
team.SetUp (CLASS_MEDIC, "Medic", Color (255, 135, 255, 255))
team.SetUp (CLASS_FIREMAN, "Fireman", Color (255, 165, 0, 255))
team.SetUp (CLASS_POLICE, "Police", Color (30,30,220, 255))
team.SetUp (CLASS_SWAT, "SWAT", Color (50,50,140, 255))
team.SetUp (CLASS_CHIEF, "Police Chief", Color (50,50,255, 255))
team.SetUp (CLASS_Mayor, "Mayor", Color (240, 0, 0, 255))

GM.Properties = {}




GM.Properties["rp_cosmoscity_v1b"] = {
	{Name = "Modern Apartment #1", Desc = "A stylish new apartment, ready for moving in.", Price = 500, PropVectors = {Vector(3096,-456,60),Vector(3184,-536,60),Vector(2791,-536,62),}, Type = "Apartment",},
	{Name = "Modern Apartment #2", Desc = "A stylish new apartment, ready for moving in.", Price = 500, PropVectors = {Vector(2791,-536,182),Vector(3096,-456,180),Vector(3184,-536,180),}, Type = "Apartment",},
	{Name = "Modern Apartment #3", Desc = "A stylish new apartment, ready for moving in.", Price = 500, PropVectors = {Vector(2791,-536,302),Vector(3096,-456,300),Vector(3184,-536,300),}, Type = "Apartment",},
	{Name = "Modern Apartment #4", Desc = "A stylish new apartment, ready for moving in.", Price = 500, PropVectors = {Vector(2136,-536,62),Vector(1832,-456,60),Vector(1744,-536,60),}, Type = "Apartment",},
	{Name = "Modern Apartment #5", Desc = "A stylish new apartment, ready for moving in.", Price = 500, PropVectors = {Vector(2136,-536,182),Vector(1832,-456,180),Vector(1744,-536,180),}, Type = "Apartment",},
	{Name = "Modern Apartment #6", Desc = "A stylish new apartment, ready for moving in.", Price = 500, PropVectors = {Vector(2136,-536,302),Vector(1832,-456,300),Vector(1744,-536,300),}, Type = "Apartment",},
	{Name = "Cheap Apartment #1", Desc = "A old, cheap apartment, ready for moving in.", Price = 400, PropVectors = {Vector(-5278,-1084,62),Vector(-5498,-1036,62),}, Type = "Apartment",},
	{Name = "Cheap Apartment #2", Desc = "A old, cheap apartment, ready for moving in.", Price = 400, PropVectors = {Vector(-5278,-660,62),Vector(-5498,-612,62),}, Type = "Apartment",},
	{Name = "Cheap Apartment #3", Desc = "A old, cheap apartment, ready for moving in.", Price = 400, PropVectors = {Vector(-4758,-892,62),Vector(-4538,-940,62),}, Type = "Apartment",},
	{Name = "Cheap Apartment #4", Desc = "A old, cheap apartment, ready for moving in.", Price = 400, PropVectors = {Vector(-4758,-468,62),Vector(-4538,-516,62),}, Type = "Apartment",},
	{Name = "Ol' Diner", Desc = "A sleek diner/resturaunt.", Price = 750, PropVectors = {Vector(4542,854,68),}, Type = "Buisness",},
	{Name = "Modern Shop #32", Desc = "A dirty shop with larged sized floor space.", Price = 300, PropVectors = {Vector(-1540,2127,64),}, Type = "Buisness",},	
	{Name = "Modern Shop #33", Desc = "A modern shop with medium sized floor space.", Price = 350, PropVectors = {Vector(-933,2837,65),}, Type = "Buisness",},
	{Name = "Modern Shop #34", Desc = "A modern shop with medium sized floor space.", Price = 350, PropVectors = {Vector(-273,2840,65),}, Type = "Buisness",},
	{Name = "Modern Shop #36", Desc = "A modern shop with medium sized floor space.", Price = 350, PropVectors = {Vector(1047,2840,65),}, Type = "Buisness",},
	{Name = "Modern Shop #134", Desc = "A clean shop with large sized floor space.", Price = 500, PropVectors = {Vector(375,-1975,68),}, Type = "Buisness",},
	{Name = "Open Shop", Desc = "A clean shop with large sized floor space.", Price = 750, PropVectors = {Vector(-4554,-5377,63),Vector(-4504,-5377,63),Vector(-4505,-4768,62),Vector(-4327,-4770,62),}, Type = "Buisness",},
	{Name = "Suburbian Department", Desc = "A large Department with enough space for 3 vehicles.", Price = 2500, PropVectors = {Vector(5824,-4206,84),Vector(6016,-4206,84),Vector(6208,-4206,84),Vector(6504,-4465,56),Vector(6568,-4465,56),Vector(6552,-4838,56),Vector(6397,-4771,56),Vector(5976,-4830,56),Vector(6104,-4910,56),Vector(6397,-4897,56),Vector(6275,-5251,56),Vector(5829,-5251,56),Vector(5827,-5011,56),}, Type = "Buisness",},		
	{Name = "Suburbian House #1", Desc = "A house close to the suburbian department", Price = 1250, PropVectors = {Vector(8845,-882,54),Vector(8396,-882,64),Vector(8198,-917,65),Vector(8210,-1108,64),Vector(8258,-799,64),Vector(8140,-638,64),Vector(8258,-606,64),Vector(8140,-562,64),Vector(8198,-476,64),}, Type = "House",},	
	{Name = "Suburbian House #2", Desc = "A house close to the suburbian department", Price = 1250, PropVectors = {Vector(9347,-4230,54),Vector(9796,-4230,64),Vector(9994,-4195,65),Vector(9982,-4004,64),Vector(9934,-4313,64),Vector(10052,-4474,64),Vector(9934,-4506,64),Vector(10052,-4550,64),Vector(9994,-4636,64),	}, Type = "House",},	
	{Name = "Suburbian House #3", Desc = "A house close to the suburbian department", Price = 1250, PropVectors = {Vector(9347,-6258,46),Vector(9796,-6258,64),Vector(9994,-6223,65),Vector(9982,-6032,64),Vector(9934,-6341,64),Vector(9934,-6534,64),Vector(10052,-6578,64),Vector(10052,-6502,64),Vector(9994,-6664,64),}, Type = "House",},	
	{Name = "Suburbian House #4", Desc = "A house close to the suburbian department", Price = 1250, PropVectors = {Vector(5702,-7127,61),Vector(6149,-7130,70),Vector(6287,-7018,70),Vector(6405,-6974,70),Vector(6347,-6888,70),Vector(6405,-7048,70),Vector(6347,-7329,71),Vector(6287,-7281,70),Vector(6335,-7520,70),}, Type = "House",},		
	{Name = "Lake-Side Shack #1", Desc = "A shack near the lake", Price = 500, PropVectors = {Vector(-9692,1099,-989),Vector(-9587,1291,-989),}, Type = "House",},		
	{Name = "Lake-Side Shack #2", Desc = "A shack near the lake", Price = 500, PropVectors = {Vector(-9844,3825,-1010),Vector(-10036,3930,-1010),}, Type = "House",},		
	{Name = "Lake-Side Shack #3", Desc = "A shack near the lake", Price = 500, PropVectors = {Vector(-13638,532,-1019),Vector(-13446,427,-1019),}, Type = "House",},		
	{Name = "The Complex Shop #1", Desc = "A clean shop with medium sized floor space.", Price = 400, PropVectors = {Vector(-2534,1804,60),Vector(-2534,1875,60),}, Type = "Buisness",},					
	{Name = "The Complex Shop #2", Desc = "A clean shop with large sized floor space.", Price = 500, PropVectors = {Vector(-2830,1663,60),Vector(-2830,1734,60),}, Type = "Buisness",},					
	{Name = "The Complex Shop #3", Desc = "A clean shop with large sized floor space and shelves.", Price = 600, PropVectors = {Vector(-2790,2135,60),Vector(-2861,2135,60),}, Type = "Buisness",},					
	{Name = "Grease House", Desc = "A open mechanics garage, with a gas station built in", Price = 1000, PropVectors = {Vector(969,-3955,77),Vector(967,-4103,62),Vector(961,-4243,56),Vector(1203,-3955,4),Vector(1463,-4307,-28),Vector(1455,-4457,72),Vector(1251,-4129,63),}, Type = "Buisness",},	
	{Name = "Large Shop #135", Desc = "Extremely Open Building", Price = 1000, PropVectors = {Vector(1468,-5775,60),Vector(1018,-5864,60),Vector(854,-5836,60),Vector(1294,-6528,60),Vector(1342,-6528,60),}, Type = "Buisness",},	
	{Name = "South Western Disposal Inc.", Desc = "Large building with many rooms.", Price = 1500, PropVectors = {Vector(2643,-6497,62),Vector(2595,-6497,62),Vector(2334,-6305,62),Vector(2502,-6067,62),Vector(2732,-6160,62),Vector(3178,-6067,62),Vector(3099,-5832,62),Vector(3099,-5627,62),}, Type = "Buisness",},	
	{Name = "Atlantic", Desc = "Open garage, with a accessible upstairs", Price = 800, PropVectors = {Vector(2849,-7797,62),Vector(2856,-7521,72),Vector(2856,-7374,72),Vector(2977,-7061,198),Vector(2941,-7143,61),}, Type = "Buisness",},	
	{Name = "J&M Glass CO.", Desc = "Open garage", Price = 500, PropVectors = {Vector(2919,-8521,61),Vector(2847,-8577,71),Vector(2847,-8633,71),Vector(2847,-8747,71),Vector(2847,-8803,71),Vector(2847,-8917,71),Vector(2847,-8973,71),Vector(2919,-9029,61),}, Type = "Buisness",},	
	{Name = "Parker", Desc = "Warehouse, with multiple booths", Price = 700, PropVectors = {Vector(1877,-8847,75),Vector(1877,-8776,75),Vector(1459,-8474,52),Vector(1493,-8474,52),Vector(1492,-8359,52),Vector(1458,-8359,52),}, Type = "Buisness",},	
	{Name = "Northern Petrol", Desc = "Warehouse, with many open containers and open space", Price = 2000, PropVectors = {Vector(2845,-10741,259),Vector(2845,-10789,259),Vector(2144,-10789,259),Vector(2144,-10741,259),Vector(2056,-11722,259),Vector(1653,-9639,63),Vector(1597,-9639,63),Vector(1509,-9639,92),}, Type = "Buisness",},	
	{Name = "Industrial Warehouse", Desc = "open space", Price = 500, PropVectors = {Vector(1536,2160,66),Vector(1536,2216,66),}, Type = "Buisness",},	
}

GM.Properties["rp_evocity_v2d"] = {
{Name = "Penthouse",Desc = "Nice and classy",Price = 1000,PropVectors = {Vector(5610,-12704,422),Vector(6144,-12742,422),Vector(6378,-12712,422),},Type = "House",},--
{Name = "Slums Shop A",Desc = "Tough to lockpick",Price = 600,PropVectors = {Vector(-8236,-10265,126),Vector(-7943,-10233,125),},Type = "Buisness",},--
{Name = "Slums Shop B",Desc = "Tough to lockpick",Price = 700,PropVectors = {Vector(-8168,-10341,126),Vector(-8263,-10213,258),Vector(-8263,-10468,258),},Type = "Buisness",},--
{Name = "Slums Shop C",Desc = "Tough to lockpick",Price = 600,PropVectors = {Vector(-8236,-10417,126),Vector(-7944,-10817,125),},Type = "Buisness",},--
{Name = "Slums Apartment 1",Desc = "A Dirty Apartment.",Price = 400,PropVectors = {Vector(-9500,-9540,190),},Type = "Apartment",},--
{Name = "Slums Apartment 2",Desc = "A Dirty Apartment.",Price = 400,PropVectors = {Vector(-9500,-9307,190),},Type = "Apartment",},--
{Name = "Slums Apartment 3",Desc = "A Dirty Apartment.",Price = 400,PropVectors = {Vector(-9496,-8893,190),},Type = "Apartment",},--
{Name = "Slums Apartment 4",Desc = "A Dirty Apartment.",Price = 400,PropVectors = {Vector(-9496,-8565,190),},Type = "Apartment",},--
{Name = "Cub Foods",Desc = "Large mart, very open.",Price = 750,PropVectors = {Vector(-3849,-7650,261),Vector(-3848,-7735,258),},Type = "Buisness",},--
--{Name = "Flea Market",Desc = "Large building, multiple stalls.",Price = 1000,PropVectors = {Vector(-3849,-6370,261),Vector(-3849,-6430,261),},Type = "Buisness",},--
{Name = "City Shop A",Desc = "Very open, and visible.",Price = 500,PropVectors = {Vector(-4660,-6474,267),Vector(-4660,-6414,267),},Type = "Buisness",},--
{Name = "City Shop B",Desc = "Very open, and visible.",Price = 300,PropVectors = {Vector(-4655,-5842,258),},Type = "Buisness",},--
--{Name = "Kentucy Fried Chicken",Desc = "A fast food resturant.",Price = 750,PropVectors = {411,410,412,},Type = "Buisness",},--
{Name = "Tides Apartment 1",Desc = "A Classy Apartment.",Price = 650,PropVectors = {Vector(-4477,-4995,262),Vector(-4765,-4987,262),},Type = "Apartment",},--
{Name = "Tides Apartment 2",Desc = "A Classy Apartment.",Price = 650,PropVectors = {Vector(-4269,-4860,262),Vector(-4233,-4604,262),},Type = "Apartment",},--
{Name = "Tides Apartment 3",Desc = "A Classy Apartment.",Price = 650,PropVectors = {Vector(-3961,-4860,262),Vector(-3769,-4604,262),},Type = "Apartment",},--
{Name = "Metro Cafe",Desc = "Small resturaunt.",Price = 250,PropVectors = {Vector(-5598,-6098,126),},Type = "Buisness",},--
{Name = "City Office Room 1",Desc = "This is the meeting room.",Price = 150,PropVectors = {Vector(-5157,-9409,1662),},Type = "Buisness",},--
{Name = "City Office Room 2",Desc = "Regular Office.",Price = 50,PropVectors = {Vector(-4944,-9153,1662),},Type = "Buisness",},--
{Name = "City Office Room 3",Desc = "Regular Office.",Price = 50,PropVectors = {Vector(-5104,-9153,1662),},Type = "Buisness",},--
{Name = "City Office Room 4",Desc = "Regular Office",Price = 50,PropVectors = {Vector(-5368,-9153,1662),},Type = "Buisness",},--
{Name = "Apartment 01",Desc = "A Basic Apartment. 1st Floor.",Price = 500,PropVectors = {Vector(-5104,-7353,254),Vector(-4816,-7257,254),Vector(-4776,-7201,254),},Type = "Apartment",},--
{Name = "Apartment 02",Desc = "A Basic Apartment. 1st Floor.",Price = 500,PropVectors = {Vector(-5224,-7361,254),Vector(-5512,-7329,254),Vector(-5552,-7457,254),},Type = "Apartment",},--
{Name = "Apartment 03",Desc = "A Basic Apartment. 1st Floor.",Price = 500,PropVectors = {Vector(-5104,-7665,254),Vector(-4816,-7697,254),Vector(-4776,-7641,254),},Type = "Apartment",},--
{Name = "Apartment 04",Desc = "A Basic Apartment. 1st Floor.",Price = 500,PropVectors = {Vector(-5224,-7665,254),Vector(-5512,-7769,254),Vector(-5552,-7897,254),},Type = "Apartment",},--
{Name = "Apartment 05",Desc = "A Basic Apartment. 2nd Floor.",Price = 500,PropVectors = {Vector(-5104,-7353,390),Vector(-4816,-7257,390),Vector(-4776,-7201,390),},Type = "Apartment",},---
{Name = "Apartment 06",Desc = "A Basic Apartment. 2nd Floor.",Price = 500,PropVectors = {Vector(-5224,-7361,390),Vector(-5512,-7329,390),Vector(-5552,-7457,390),},Type = "Apartment",},--
{Name = "Apartment 07",Desc = "A Basic Apartment. 2nd Floor.",Price = 500,PropVectors = {Vector(-5104,-7665,390),Vector(-4816,-7697,390),Vector(-4776,-7641,390),},Type = "Apartment",},--
{Name = "Apartment 08",Desc = "A Basic Apartment. 2nd Floor.",Price = 500,PropVectors = {Vector(-5224,-7665,390),Vector(-5512,-7769,390),Vector(-5552,-7897,390),},Type = "Apartment",},--
{Name = "Apartment 09",Desc = "A Basic Apartment. 3rd Floor.",Price = 500,PropVectors = {Vector(-5104,-7353,526),Vector(-4816,-7257,526),Vector(-4776,-7201,526),},Type = "Apartment",},--
{Name = "Apartment 10",Desc = "A Basic Apartment. 3rd Floor.",Price = 500,PropVectors = {Vector(-5224,-7361,526),Vector(-5512,-7329,526),Vector(-5552,-7457,526),},Type = "Apartment",},--
{Name = "Apartment 11",Desc = "A Basic Apartment. 3rd Floor.",Price = 500,PropVectors = {Vector(-5104,-7665,526),Vector(-4816,-7697,526),Vector(-4776,-7641,526),},Type = "Apartment",},--
{Name = "Apartment 12",Desc = "A Basic Apartment. 3rd Floor.",Price = 500,PropVectors = {Vector(-5224,-7665,526),Vector(-5512,-7769,526),Vector(-5552,-7897,526),},Type = "Apartment",},--
{Name = "Small Trailer",Desc = "Confined area, surrounded by woods.",Price = 1000,PropVectors = {Vector(-4493,7744,142),Vector(-4393,7715,142),Vector(-4393,8007,142),},Type = "House",},--
{Name = "Water Treatment plant",Desc = "Open area surrounded by woods.",Price = 1000,PropVectors = {Vector(-11810,9566,150),Vector(-11710,9829,150),Vector(-11810,9858,150),Vector(-10075,8638,120),Vector(-9841,8979,118),},Type = "Buisness",},--
{Name = "Industrial Garage",Desc = "Large open area.",Price = 750,PropVectors = {Vector(1456,4095,125),Vector(440,4120,157),},Type = "Buisness",},--
{Name = "Industrial Plant",Desc = "No windows here.",Price = 750,PropVectors = {Vector(3444,4098,117),Vector(3568,4102,126),Vector(3704,4102,126),},Type = "Buisness",},--Marks that this is doublechecked
{Name = "The Pool",Desc = "A pool area, great for parties.",Price = 1000,PropVectors = {Vector(3732,-6828,209),Vector(3464,-7206,209),Vector(3532,-7379,201),Vector(3532,-7476,201),Vector(3681,-7377,201),Vector(3680,-7474,201),},Type = "Buisness",},--
{Name = "Radio Station",Desc = "Plenty of room.",Price = 1500,PropVectors = {Vector(5601,-7964,118),Vector(5812,-7964,118),Vector(5746,-7644,118),Vector(5522,-7644,118),Vector(5046,-8152,156),Vector(5166,-7390,118),},Type = "Buisness",},--
{Name = "Office Complex",Desc = "A complex near the car dealership.",Price = 850,PropVectors = {Vector(5018,-4373,126),Vector(5094,-3947,126),Vector(5094,-4287,126),},Type = "Buisness",},--
{Name = "Office Room 1",Desc = "Windowed.",Price = 150,PropVectors = {Vector(5637,-4213,126),},Type = "Buisness",},--
{Name = "Office Room 2",Desc = "Windowed.",Price = 150,PropVectors = {Vector(5445,-4213,126),},Type = "Buisness",},--
{Name = "Office Room 3",Desc = "No windows.",Price = 300,PropVectors = {Vector(5637,-4169,258),},Type = "Buisness",},--
{Name = "Office Room 4",Desc = "No windows.",Price = 300,PropVectors = {Vector(5445,-4169,258),},Type = "Buisness",},--
{Name = "Office Room 5",Desc = "No windows.",Price = 300,PropVectors = {Vector(5253,-4169,258),},Type = "Buisness",},--
{Name = "Office Room 6",Desc = "No windows.",Price = 300,PropVectors = {Vector(5061,-4169,258),},Type = "Buisness",},--
{Name = "Office Room 7",Desc = "No windows.",Price = 300,PropVectors = {Vector(5031,-4127,258),},Type = "Buisness",},--
{Name = "Office Room 8",Desc = "No windows.",Price = 300,PropVectors = {Vector(5177,-4085,258),},Type = "Buisness",},--
{Name = "Office Room 9",Desc = "No windows.",Price = 300,PropVectors = {Vector(5324,-4085,258),},Type = "Buisness",},--
{Name = "Small Bar",Desc = "No windows. Hidden in the woods.",Price = 450,PropVectors = {Vector(11559,245,125),},Type = "Buisness",},--
{Name = "Suburban House 1",Desc = "A house with windows and a garage.",Price = 1250,PropVectors = {Vector(10200,13885,120),Vector(10143,14150,116),Vector(10386,14299,245),Vector(10421,14016,245),Vector(10386,14243,245),},Type = "House"},--
{Name = "Suburban House 2",Desc = "A house with no windows and a garage.",Price = 950,PropVectors = {Vector(5944,13820,116),Vector(5632,14552,118),Vector(5748,14078,116),Vector(5632,14664,118),Vector(5838,13988,116),Vector(5725,14055,116),},Type = "House",},--
{Name = "MTL headquaters",Desc = "3 garages, one office building and a gate.",Price = 2000,PropVectors = {Vector(3889,6151,186),Vector(4021,6055,186),Vector(3973,5647,186),Vector(3973,5471,186),Vector(4270,6783,115),Vector(4270,7039,115),Vector(3568,7173,164),Vector(3448,7173,164),Vector(3056,7173,164),Vector(2936,7173,164),Vector(2544,7173,190),Vector(2424,7173,190),Vector(2472,5959,154),Vector(2598,5899,153),Vector(2866,5899,153),Vector(877,7489,157),Vector(877,7337,157),Vector(877,7185,157),},Type = "Buisness",},--
{Name = "Abandoned House",Desc = "Hasn't been used in years.",Price = 450,PropVectors = {Vector(-2878,-128,123),Vector(-3386,270,123),Vector(-2753,52,123),Vector(-2512,161,123),Vector(-2685,196,259),Vector(-2879,-122,73),},Type = "House",},
}

GM.Properties["rp_evocity2_v2p"] = {
{Name = "Suburban House #1", Desc = "Nice and classy", Price = 1000, PropVectors = {Vector(5812,7851,-1706),Vector(5612,8133,-1642),Vector(5500,8149,-1642),Vector(5583,7952,-1770),Vector(5812,8072,-1769),Vector(5814,8263,-1772),Vector(5308,7981,-1770),}, Type = "House",},
{Name = "Suburban House #2", Desc = "Nice and classy", Price = 1000, PropVectors = {Vector(6231,10144,-1770),Vector(5937,10456,-1706),Vector(5983,10520,-1706),Vector(6105,10144,-1770),Vector(6044,10421,-1834),Vector(6044,10619,-1834),Vector(5976,9632,-1762),Vector(5499,9629,-1772),}, Type = "House",},
{Name = "Suburban House #3", Desc = "Nice and classy", Price = 1000, PropVectors = {Vector(8302,10006,-1738),Vector(8006,10165,-1738),Vector(7918,10237,-1738),Vector(7818,10165,-1738),Vector(8418,10101,-1738),Vector(8498,10197,-1738),Vector(8598,9909,-1762),Vector(8745,10466,-1772),}, Type = "House",},
{Name = "Suburban House #4", Desc = "Nice and classy", Price = 1000, PropVectors = {Vector(7500,7372,-1766),Vector(7668,7478,-1766),Vector(7758,7568,-1766),Vector(8232,7684,-1764),Vector(8344,7684,-1764),}, Type = "House",},
{Name = "Log Cabin #1", Desc = "Small but lovely.", Price = 400, PropVectors = {Vector(12016,10916,-1738),Vector(12152,10916,-1738),}, Type = "House"},
{Name = "Log Cabin #2", Desc = "Small but lovely.", Price = 400, PropVectors = {Vector(10723,10819,-1764),Vector(10563,10819,-1764),}, Type = "House"},
{Name = "MTL Headquaters", Desc = "Many garages, great for a repair centre.", Price = 2000, PropVectors = {Vector(9861,4110,-1770),Vector(9534,4170,-1770),Vector(9212,4114,-1728),Vector(9092,4114,-1728),Vector(8700,4114,-1728),Vector(8580,4114,-1728),Vector(8060,4114,-1700),Vector(7940,4114,-1700),Vector(7742,3498,-1738),Vector(7486,3088,-1730),Vector(7072,3342,-1730),Vector(6880,3342,-1730),Vector(7486,2704,-1730),Vector(7486,2320,-1730),Vector(10078,3782,-1770),Vector(10254,3470,-1770),Vector(9922,3292,-1732),Vector(9922,3004,-1732),Vector(4891,4767,-1126),}, Type = "Buisness"},
{Name = "Farm House #1", Desc = "A lovely farm house", Price = 600, PropVectors = {Vector(10214,-3054,-1642),Vector(10362,-2678,-1642),Vector(10362,-2582,-1642),}, Type = "House"},
{Name = "Farm House #2", Desc = "A lovely farm house", Price = 600, PropVectors = {Vector(13544,-10010,-1642),Vector(13692,-9634,-1642),Vector(13692,-9538,-1642),}, Type = "House"},
{Name = "Farm House #3", Desc = "A lovely farm house", Price = 600, PropVectors = {Vector(13292,-11356,-1664),Vector(13588,-11324,-1664),Vector(13724,-11324,-1664),Vector(13724,-11388,-1664),}, Type = "House"},
{Name = "Farm House #4", Desc = "A lovely farm house", Price = 600, PropVectors = {Vector(13292,-12492,-1664),Vector(13588,-12460,-1664),Vector(13724,-12460,-1664),Vector(13724,-12524,-1664),}, Type = "House"},
{Name = "Farm House #5", Desc = "A lovely farm house", Price = 600, PropVectors = {Vector(13292,-13508,-1664),Vector(13588,-13476,-1664),Vector(13724,-13476,-1664),Vector(13724,-13540,-1664),}, Type = "House"},
{Name = "Farm Cabin #1", Desc = "A lovely farm cabin", Price = 400, PropVectors = {Vector(11867,-11366,-1665),}, Type = "House"},
{Name = "Farm Buisness #1", Desc = "A lovely farm Buisness", Price = 900, PropVectors = {Vector(10651,-12058,-1665),Vector(10515,-11586,-1665),}, Type = "Buisness"},
{Name = "Farm Buisness #2", Desc = "A lovely farm Buisness", Price = 900, PropVectors = {Vector(10359,-12092,-1665),}, Type = "Buisness"},
{Name = "Farm Buisness #3", Desc = "A lovely farm Buisness", Price = 900, PropVectors = {Vector(9755,-12058,-1665),Vector(9619,-11594,-1665),}, Type = "Buisness"},
{Name = "Farm Warehouse", Desc = "A large warehouse in the farm district", Price = 900, PropVectors = {Vector(11347,-13709,-1665),Vector(11347,-13439,-1655),}, Type = "Buisness"},
{Name = "Farm Barn #1", Desc = "A lovely farm barn", Price = 900, PropVectors = {Vector(9403,-7553,-1617),Vector(9587,-7553,-1617),}, Type = "Buisness"},
{Name = "Farm Barn #2", Desc = "A lovely farm barn", Price = 900, PropVectors = {Vector(13297,-3332,-1617),Vector(13481,-3332,-1617),}, Type = "Buisness"},
{Name = "Log Cabin #3", Desc = "Small but lovely.", Price = 500, PropVectors = {Vector(6933,-10952,-2279),Vector(6928,-11208,-2279),}, Type = "House"},
{Name = "Log Cabin #4", Desc = "Small but lovely.", Price = 600, PropVectors = {Vector(3943,-10008,-2804),Vector(3897,-10264,-2804),Vector(3763,-10264,-2804),Vector(3629,-10264,-2804),}, Type = "House"},
{Name = "Log Cabin #5", Desc = "Small but lovely.", Price = 400, PropVectors = {Vector(1609,-10127,-2754),Vector(1614,-9871,-2754),}, Type = "House"},
{Name = "Log Cabin #6", Desc = "Small but lovely.", Price = 400, PropVectors = {Vector(189,-11400,-2442),Vector(-67,-11395,-2442),}, Type = "House"},
{Name = "Industrial Compound", Desc = "Huge warehouse/office complex", Price = 1800, PropVectors = {Vector(-4447,13692,258),Vector(-3135,13436,262),Vector(-3221,13252,316),Vector(-3221,13116,316),Vector(-3221,14076,316),Vector(-3221,14212,316),Vector(-2131,13956,262),Vector(-1999,13956,178),Vector(-1301,12962,126),}, Type = "Buisness"},
{Name = "Industrial Warehouse", Desc = "Large yellow warehouse", Price = 550, PropVectors = {Vector(231,13199,174),Vector(813,13199,118),Vector(766,13199,118),Vector(231,13705,174),Vector(236,12712,128),}, Type = "Buisness"},
{Name = "Evocity Electric", Desc = "Power Plant. Contains furnace.", Price = 550, PropVectors = {Vector(8288,12878,130),Vector(8288,13014,130),Vector(8292,13138,122),}, Type = "Buisness"},
{Name = "Cubs Food", Desc = "Food store.", Price = 600, PropVectors = {Vector(7962,5930,133),Vector(7962,5870,133),Vector(9068,6154,124),Vector(9068,6439,124),Vector(9068,6391,124),Vector(9315,5392,133),Vector(9164,5392,133),}, Type = "Buisness"},
{Name = "Midas Garage", Desc = "Suitable for running vehicle repairs", Price = 500, PropVectors = {Vector(-3304,3084,132),Vector(-3148,3450,130),Vector(-3268,3466,130),Vector(-3268,3682,130),Vector(-3000,3084,154),Vector(-2776,3084,154),Vector(-2552,3084,154),Vector(-2328,3084,154),}, Type = "Buisness"},
{Name = "Sintek Office 1-1", Desc = "Office 1 on L1 of Sintek.", Price = 300, PropVectors = {Vector(-360,1016,519),}, Type = "Buisness"},
{Name = "Sintek Office 1-2", Desc = "Office 2 on L1 of Sintek.", Price = 300, PropVectors = {Vector(-168,1014,519),}, Type = "Buisness"},
{Name = "Sintek Office 1-3", Desc = "Office 3 on L1 of Sintek.", Price = 300, PropVectors = {Vector(-360,262,519),}, Type = "Buisness"},
{Name = "Sintek Office 1-4", Desc = "Office 4 on L1 of Sintek.", Price = 300, PropVectors = {Vector(-168,260,519),}, Type = "Buisness"},
{Name = "Sintek Office 2-1", Desc = "Office 1 on L2 of Sintek.", Price = 300, PropVectors = {Vector(-360,1016,903),}, Type = "Buisness"},
{Name = "Sintek Office 2-2", Desc = "Office 2 on L2 of Sintek.", Price = 300, PropVectors = {Vector(-168,1014,903),}, Type = "Buisness"},
{Name = "Sintek Office 2-3", Desc = "Office 3 on L2 of Sintek.", Price = 300, PropVectors = {Vector(88,264,903),}, Type = "Buisness"},
{Name = "Sintek Office 2-4", Desc = "Office 4 on L2 of Sintek.", Price = 300, PropVectors = {Vector(-104,266,903),}, Type = "Buisness"},
{Name = "Medium Shop #1", Desc = "Medium sized shop floor next to Ace Hardware", Price = 400, PropVectors = {Vector(-2690,-1028,130),}, Type = "Buisness"},
{Name = "Medium Shop #2", Desc = "Medium sized shop floor near Apartments", Price = 400, PropVectors = {Vector(3620,-3124,130),}, Type = "Buisness"},
{Name = "Large Shop #1", Desc = "Large shop floor near Apartments", Price = 500, PropVectors = {Vector(3620,-2868,130),}, Type = "Buisness"},
{Name = "Amber Room", Desc = "Classy bar next to the Apartments", Price = 500, PropVectors = {Vector(3609,-1535,130),Vector(3609,-1521,130),Vector(3609,-1431,130),Vector(3609,-1417,130),Vector(3772,-1284,155),Vector(3935,-1284,130),Vector(3921,-1284,130),Vector(4015,-1284,130),Vector(4001,-1284,130),}, Type = "Buisness"},
{Name = "Modern Shop", Desc = "Modern and well sized shop near Slums", Price = 350, PropVectors = {Vector(3739,1251,131),}, Type = "Buisness"},
{Name = "Nathans' Drugs", Desc = "Old and unused drug store", Price = 450, PropVectors = {Vector(3739,1829,134),Vector(3739,1881,134),Vector(4203,1635,130),}, Type = "Buisness"},
{Name = "Small Storage Space", Desc = "Old and unused storage space above Nathans Drugs", Price = 350, PropVectors = {Vector(4331,1571,258),Vector(4203,1635,258),}, Type = "Buisness"},
{Name = "Small Warehouse", Desc = "Small warehouse just off the main industrial road.", Price = 350, PropVectors = {Vector(-413,11868,-64),Vector(-413,11709,-74),Vector(-413,11661,-74),}, Type = "Buisness"},
{Name = "Small Garage Space", Desc = "Useful for parking a car.", Price = 400, PropVectors = {Vector(2995,2301,130),Vector(2883,2525,130),Vector(2690,2480,130),Vector(3119,2302,142),}, Type = "Buisness"},
{Name = "City Office #1", Desc = "Office 1 in the City Building", Price = 300, PropVectors = {Vector(1474,1123,1666),}, Type = "Buisness"},
{Name = "City Office #2", Desc = "Office 2 in the City Building", Price = 300, PropVectors = {Vector(1398,1123,1666),}, Type = "Buisness"},
{Name = "City Office #3", Desc = "Office 3 in the City Building", Price = 300, PropVectors = {Vector(1565,1146,1538),}, Type = "Buisness"},
{Name = "City Office #4", Desc = "Office 4 in the City Building", Price = 300, PropVectors = {Vector(1565,922,1538),}, Type = "Buisness"},
{Name = "City Office #5", Desc = "Office 5 in the City Building", Price = 300, PropVectors = {Vector(1565,666,1538),}, Type = "Buisness"},
{Name = "Highrise Restaurant", Desc = "An expensive restaurant opp. Nexus", Price = 650, PropVectors = {Vector(-2496,-2698,139),Vector(-2436,-2698,139),}, Type = "Buisness"},
{Name = "Evocity Electronics", Desc = "A large electronics store", Price = 600, PropVectors = {Vector(-2668,-2206,139),Vector(-2668,-2146,139),}, Type = "Buisness"},
{Name = "Large Shop #2", Desc = "A large shop near the train station (city)", Price = 400, PropVectors = {Vector(748,-1146,132),}, Type = "Buisness"},
{Name = "Studio Apartment #1", Desc = "A simple studio apartment near car dealer", Price = 300, PropVectors = {Vector(4164,-2980,305),Vector(4012,-3068,305),}, Type = "Apartment"},
{Name = "Studio Apartment #2", Desc = "A simple studio apartment near car dealer", Price = 350, PropVectors = {Vector(4164,-2900,305),Vector(4076,-2793,305),}, Type = "Apartment"},
{Name = "Regular Apartment #1", Desc = "An apartment opp. car dealer", Price = 300, PropVectors = {Vector(4052,-2004,258),Vector(4024,-2116,258),Vector(3905,-2116,258),}, Type = "Apartment"},
{Name = "Regular Apartment #2", Desc = "An apartment opp. car dealer", Price = 300, PropVectors = {Vector(4132,-2308,258),Vector(3772,-2492,258),Vector(3740,-2524,258),}, Type = "Apartment"},
{Name = "Regular Apartment #3", Desc = "An apartment opp. car dealer", Price = 350, PropVectors = {Vector(4052,-2004,386),Vector(4024,-2116,386),Vector(3904,-1804,386),}, Type = "Apartment"},
{Name = "Regular Apartment #4", Desc = "An apartment opp. car dealer, w/ balcony.", Price = 350, PropVectors = {Vector(4132,-2308,386),Vector(3927,-2412,386),Vector(3772,-2308,386),Vector(3737,-2385,386),Vector(3737,-2399,386),}, Type = "Apartment"},
{Name = "Penthouse Suite", Desc = "Penthouse opp. Car Dealer, w/ Balcony.", Price = 450, PropVectors = {Vector(4048,-1924,514),Vector(4132,-2108,514),Vector(3996,-2108,514),Vector(3801,-1927,514),Vector(3815,-1927,514),}, Type = "Apartment"},
{Name = "Slums Apartment #1", Desc = "A run-down room in the slums", Price = 300, PropVectors = {Vector(4271,2812,194),}, Type = "Apartment"},
{Name = "Slums Apartment #2", Desc = "A run-down room in the slums", Price = 300, PropVectors = {Vector(3943,2812,194),}, Type = "Apartment"},
{Name = "Slums Apartment #3", Desc = "A run-down room in the slums", Price = 300, PropVectors = {Vector(3529,2816,194),}, Type = "Apartment"},
{Name = "Slums Apartment #4", Desc = "A run-down room in the slums", Price = 300, PropVectors = {Vector(3296,2816,194),}, Type = "Apartment"},
}

META = FindMetaTable( "Entity" )

function META:IsDoor()

	local class = self:GetClass();
	
	if( class == "func_door" or
		class == "func_door_rotating" or
		class == "prop_door_rotating" or
		class == "prop_vehicle_jeep") then
		
		return true;
		
	end
	
	return false;

end
 
 function GM.IsRaining ( )
	return GAMEMODE.IsStorming() or GetGlobalInt('ocrp_weather', WEATHER_NORMAL) == WEATHER_RAINY;
end

function GM.IsStorming ( )
	return GetGlobalInt('ocrp_weather', WEATHER_NORMAL) == WEATHER_STORMY or GetGlobalInt('ocrp_weather', WEATHER_NORMAL) == WEATHER_STORMY_HEAVY;
end
 
 
 
function physgunPickup( ply, ent )

	if ply:GetLevel() < 2  then
		return true
	end

	if ent:IsPlayer() then
		if ply:GetLevel() <= 2  then
			if ent:IsBetterOrSame(PLAYER) then
				return false
			end
		end
	elseif ent:IsDoor() then
		return false
	elseif ent:GetClass() == "prop_ocrp" then
		return false
	elseif ent:GetClass() == "func_rotating" then
		return false
	elseif ent:GetClass() == "func_brush" then
		return false
	elseif ent:GetClass() == "gov_resupply" then
		return false
	elseif ent:GetClass() == "vendingmachines" then
		return false
	elseif ent:GetClass() == "item_base" then	
		if ent:GetNWInt("Class") == "item_ladder" then
			return false
		elseif ent:GetNWInt("Class") == "item_pot" then
			return false
		end
		if ply:EntIndex() != ent:GetNWInt("Owner") then
			return false
		end
	elseif ent:GetClass() == "prop_ragdoll" then 
		return false
	elseif ent:GetClass() == "func_button" then
		return false
	elseif ent:GetClass() == "func_movelinear" then
		return false
	elseif ent:GetClass() == "gov_resupply" then
		return false
	elseif ent:GetClass() == "prop_dynamic" then
		return false
	elseif ent:GetClass() == "func_tracktrain" then 
		return false
	elseif ent:GetClass() == "func_breakable_surf" then
		return false
	elseif ent:GetClass() == "func_rotating" then
		return false
	elseif ent:GetClass() == "func_breakable" then
		return false
	elseif ent:GetClass() == "bank_atm"  then
		if ply:Team() == CLASS_Mayor && ent.OwnerType == "Mayor" then
			return true
		else
			return false
		end
	elseif ent.OwnerType == "Mayor" then
		if ply:Team() == CLASS_Mayor || ply:Team() == CLASS_CHIEF then
			return true
		else
			return false
		end
	elseif ent.OwnerType == "Chief" then
		if ply:Team() == CLASS_Mayor || ply:Team() == CLASS_CHIEF || ply:Team() == CLASS_POLICE || ply:Team() == CLASS_SWAT then
			return true
		else
			return false
		end
	elseif ent:IsNPC() then
		return false 
	end
end
 
hook.Add( "PhysgunPickup", "physgunPickup", physgunPickup );

function PMETA:GetOrg()
	if self.Org == nil then
		return 0
	else
		return self.Org
	end
end

function PMETA:OCRP_GetCar()
	for k, v in pairs(ents.FindByClass( "prop_vehicle_jeep" )) do
		if v:GetNWInt( "Owner" ) == self:EntIndex() then
			return v
		end
	end
end

function META:GetCarType()
	for _, data in pairs(GAMEMODE.OCRP_Cars) do
		if type(data.Model) == "table" then
			for a, d in pairs(data.Model) do
				if self:GetModel() == d then
					return _
				end
			end
		else
			if self:GetModel() == data.Model then
				return _
			end
		end
	end
	return "NULL"
end

function PMETA:InGang()
	if self:InOrg() then
		if GAMEMODE.Orgs[self:GetOrg()].Type == "Gang" then
			return true
		else
			return false
		end
	end
	return false
end

function PMETA:InBusiness()
	if self:InOrg() then
		if GAMEMODE.Orgs[self:GetOrg()].Type == "Business" then
			return true
		else
			return false
		end
	end
	return false
end

function PMETA:GetSex()
	if string.find( string.lower( self:GetModel() ), "female" ) then
		return "Female"
	elseif string.find( string.lower( self:GetModel() ), "male" ) then
		return "Male"
	end
end

function ModelPrinter( ply, ent )
	if SERVER then
		ply.CantUse = true
		timer.Simple(0.9,function() ply.CantUse = false end)
	end
end
hook.Add("PhysgunDrop", "ModelPrinter", ModelPrinter)

function gravgunPunt( userid, target )
	return false
end
 
hook.Add( "GravGunPunt", "gravgunPunt", gravgunPunt )


function GetVectorTraceUp ( vec )
	local trace = {};
	trace.start = vec;
	trace.endpos = vec + Vector(0, 0, 999999999);
	trace.mask = MASK_SOLID_BRUSHONLY;
	
	return util.TraceLine(trace);
end

function PMETA:GetUpTrace ( )
	local ourEnt = self;
	if (self:InVehicle()) then
		ourEnt = self:GetVehicle();
	end
	
	return GetVectorTraceUp(ourEnt:GetPos());
end

function PMETA:IsOutside ( ) return self:GetUpTrace().HitSky; end
function PMETA:IsInside ( ) return !self:IsOutside(); end

-- TIME_PER_DAY 	= 60 * 60 * 3.5; // 3.5 hours is one cycle.
-- DAY_LENGTH		= 1440;

-- DAY_START		= 5 * 60; // 5 am
-- DAY_END		= 18.5 * 60; // 6:30 pm
-- DAWN			= DAY_LENGTH / 4;
-- DAWN_START	= DAWN - 144;
-- DAWN_END		= DAWN + 144;
-- NOON			= DAY_LENGTH / 2;
-- DUSK			= DAY_LENGTH - DAWN;
-- DUSK_START	= DUSK - 144;
-- DUSK_END		= DUSK + 144;

-- local nextTick = CurTime();
-- local timePerMinute = TIME_PER_DAY / DAY_LENGTH * .5;
-- MONTH_DAYS = {31, 28, 30, 31, 30, 31, 30, 31, 30, 31, 30, 31};
-- CLOUD_NAMES = {"Clear Skies", "Partly Cloudy", "Mostly Cloudy [ PRE ]", "Mostly Clouy [ POST ]", "Stormy", "Stormy [ LIGHT ]", "Stormy [ PRE ]", "Stormy [ SEVERE ]", "Heat Wave"};
							 

-- local function manageTime ( )
	-- if (!GAMEMODE.CurrentTime || (SERVER && !GAMEMODE.timeEntities.shadow_control) || nextTick > CurTime()) then return; end
	-- nextTick = nextTick + timePerMinute;
	
	-- GAMEMODE.CurrentTime = GAMEMODE.CurrentTime + .5;
	-- if (GAMEMODE.CurrentTime > DAY_LENGTH) then
		-- GAMEMODE.CurrentTime = .5;
		
		-- GAMEMODE.CurrentDay = GAMEMODE.CurrentDay + 1;
		
		-- if (GAMEMODE.CurrentDay > MONTH_DAYS[GAMEMODE.CurrentMonth]) then
			-- GAMEMODE.CurrentDay = 1;
			-- GAMEMODE.CurrentMonth = GAMEMODE.CurrentMonth + 1;
			
			-- if (GAMEMODE.CurrentMonth > 12) then
				-- GAMEMODE.CurrentMonth = 1;
				-- GAMEMODE.CurrentYear = GAMEMODE.CurrentYear + 1;
				-- // Happy near years
			-- end
		-- end
		
		-- if SERVER then GAMEMODE.SaveDate(); end
	-- end
		
	-- if SERVER then GAMEMODE.progressTime(); end
-- end
-- hook.Add("Think", "manageTime", manageTime);

-- function GM.GetTime ( )
	-- local perHour = DAY_LENGTH / 24;
	-- local perMinute = DAY_LENGTH / 1440;
	
	-- local hours = math.floor(GAMEMODE.CurrentTime / perHour);
	-- local mins = math.floor(GAMEMODE.CurrentTime / perMinute) - hours * 60;
	
	-- return hours, mins;
-- end

function PMETA:CanSee ( Entity, Strict )
	if Strict then
		if !self:HasLOS(Entity) then return false; end
	end

	local fov = self:GetFOV()
	local Disp = Entity:GetPos() - self:GetPos()
	local Dist = Disp:Length()
	local EntWidth = Entity:BoundingRadius() * 0.5;
	
	local MaxCos = math.abs( math.cos( math.acos( Dist / math.sqrt( Dist * Dist + EntWidth * EntWidth ) ) + fov * ( math.pi / 180 ) ) )
	Disp:Normalize()

	if Disp:Dot( self:EyeAngles():Forward() ) > MaxCos and Entity:GetPos():Distance(self:GetPos()) < 5000 then
		return true
	end
	
	return false
end
