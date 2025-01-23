GM.OCRP_Cars = {}

GM.OCRP_Cars["CAR_BMW_M5"] = {
	Name = "BMW M5",
	OtherName = "CAR_BMW_M5", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/bmw.txt",
	Model = "models/sickness/bmw-m5.mdl",
	Price = 55500,
	Health = 100,
	Speed = 60,
	GasTank = 800,
	StrengthText = "Weak",
	RepairCost = 1000,
	SeatsNum = 4,
	Skin_Price = 5000,
	Skins = {
				{skin = 0, name = "White", model = "models/sickness/bmw-m5.mdl"},
				{skin = 1, name = "Red", model = "models/sickness/bmw-m5.mdl"},
				{skin = 2, name = "Purple", model = "models/sickness/bmw-m5.mdl"},
				{skin = 3, name = "Navy", model = "models/sickness/bmw-m5.mdl"},
				{skin = 4, name = "Green", model = "models/sickness/bmw-m5.mdl"},
				{skin = 5, name = "Dark Red", model = "models/sickness/bmw-m5.mdl"},
				{skin = 6, name = "Black", model = "models/sickness/bmw-m5.mdl"},
				{skin = 7, name = "Light Blue", model = "models/sickness/bmw-m5.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -5, 8), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 30, 5), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-17, 30, 5), Angle(0, 0 ,10))
			end,
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["CAR_SHELBY"] = {
	Name = "Shelby",
	OtherName = "CAR_SHELBY", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/shelby.txt",
	Model = "models/shelby/shelby.mdl",
	Price = 255000,
	Health = 100,
	Speed = 60,
	GasTank = 800,
	StrengthText = "Weak",
	RepairCost = 1000,
	SeatsNum = 4,
	Skin_Price = 5000,
	Skins = {
				{skin = 0, name = "White", model = "models/shelby/shelby.mdl"},
				{skin = 1, name = "Red", model = "models/shelby/shelby.mdl"},
				{skin = 2, name = "Blue", model = "models/shelby/shelby.mdl"},
				{skin = 3, name = "Silver", model = "models/shelby/shelby.mdl"},
				{skin = 4, name = "Orange", model = "models/shelby/shelby.mdl"},
				{skin = 5, name = "Light Blue", model = "models/shelby/shelby.mdl"},
				{skin = 6, name = "Green", model = "models/shelby/shelby.mdl"},
				{skin = 7, name = "Black", model = "models/shelby/shelby.mdl"},
				{skin = 8, name = "Brown", model = "models/shelby/shelby.mdl"},
				{skin = 9, name = "Purple", model = "models/shelby/shelby.mdl"},
				{skin = 10, name = "Pink", model = "models/shelby/shelby.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(16, 4, 13), Angle(0, 0, 10));
			end,
	MovePos = Vector(0,0,0),
	Exits = { Vector( -72.3996, -6.1857, 1.8621 ), Vector(72.3996, -0.1439, 0.3239) },
}

GM.OCRP_Cars["CAR_ORACLE"] = {
	Name = "Oracle XS Sedan",
	OtherName = "CAR_ORACLE", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/oracle.txt",
	Model = "models/sickness/oracledr.mdl",
	Price = 75000,
	Health = 100,
	Speed = 70,
	GasTank = 650,
	StrengthText = "Weak",
	RepairCost = 1000,
	SeatsNum = 4,
	Skin_Price = 5600,
	Skins = {
				{skin = 0, name = "Black", model = "models/sickness/oracledr.mdl"},
				{skin = 1, name = "White", model = "models/sickness/oracledr.mdl"},
				{skin = 2, name = "Red", model = "models/sickness/oracledr.mdl"},
				{skin = 3, name = "Green", model = "models/sickness/oracledr.mdl"},
				{skin = 4, name = "Dark Blue", model = "models/sickness/oracledr.mdl"},
				{skin = 5, name = "Dark Red", model = "models/sickness/oracledr.mdl"},
				{skin = 6, name = "Purple", model = "models/sickness/oracledr.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -8, 15), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 35, 18.5), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-17, 35, 18.5), Angle(0, 0 ,10))
			end,
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["CAR_ROLLS"] = {
	Name = "Rolls Royce Phantom",
	OtherName = "CAR_ROLLS", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/roller.txt",
	Model = "models/sickness/superddr.mdl",
	Price = 1750000,
	Health = 100,
	Speed = 60,
	GasTank = 850,
	StrengthText = "Strong",
	RepairCost = 1000,
	SeatsNum = 4,
	Skin_Price = 10000,
	Skins = {
				{skin = 0, name = "Carbon Black", model = "models/sickness/superddr.mdl"},
				{skin = 1, name = "Carbon White", model = "models/sickness/superddr.mdl"},
				{skin = 2, name = "Carbon Silver", model = "models/sickness/superddr.mdl"},
				{skin = 3, name = "Carbon Red", model = "models/sickness/superddr.mdl"},
				{skin = 4, name = "Purple Blue", model = "models/sickness/superddr.mdl"},
				{skin = 5, name = "Carbon Light Blue", model = "models/sickness/superddr.mdl"},
				{skin = 6, name = "Carbon Marine", model = "models/sickness/superddr.mdl"},
				{skin = 7, name = "Carbon Dark Green", model = "models/sickness/superddr.mdl"},
				{skin = 8, name = "Carbon Baby Red", model = "models/sickness/superddr.mdl"},
				{skin = 9, name = "Carbon Baby Blue", model = "models/sickness/superddr.mdl"},
				{skin = 10, name = "Carbon Dark Red", model = "models/sickness/superddr.mdl"},
				{skin = 11, name = "Carbon Cream", model = "models/sickness/superddr.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(17, 45, 20.5), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-17, 45, 20.5), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -6, 20), Angle(0, 0 ,10))
			end,
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["CAR_BUGGY"] = {
	Name = "Ex-Military Desert Rat",
	OtherName = "CAR_BUGGY", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/bf2buggy.txt",
	Model = "models/bf2bb.mdl",
	Price = 150000,
	Health = 150,
	Speed = 80,
	GasTank = 650,
	StrengthText = "Very Strong",
	RepairCost = 1000,
	SeatsNum = 2,
	Skin_Price = 5600,
	Skins = {
				{skin = 0, name = "Rustic", model = "models/bf2bb.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(0, 95, 58), Angle(0, 0 ,-10))
			end,
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["CAR_EMPEROR"] = {
	Name = "Lincoln Emperor",
	OtherName = "CAR_EMPEROR", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/emperor.txt",
	Model = "models/sickness/emperordr.mdl",
	Price = 30000,
	Health = 100,
	Speed = 70,
	GasTank = 650,
	StrengthText = "Weak",
	RepairCost = 1000,
	SeatsNum = 4,
	Skin_Price = 5600,
	Skins = {
				{skin = 0, name = "Black", model = "models/sickness/emperordr.mdl"},
				{skin = 1, name = "White", model = "models/sickness/emperordr.mdl"},
				{skin = 2, name = "Grey", model = "models/sickness/emperordr.mdl"},
				{skin = 3, name = "Red", model = "models/sickness/emperordr.mdl"},
				{skin = 4, name = "Green", model = "models/sickness/emperordr.mdl"},
				{skin = 5, name = "Blue", model = "models/sickness/emperordr.mdl"},
			
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -8, 15), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 35, 14), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-17, 35, 14), Angle(0, 0 ,10))
			end,
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["CAR_GOLF"] = {
	Name = "VW Golf GTi",
	OtherName = "CAR_GOLF", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/golf.txt",
	Model = {
				"models/golf/golf.mdl",
				"models/golf/gol2.mdl",
				"models/golf/gol3.mdl",
			},
	Price = 60000,
	Health = 100,
	Speed = 70,
	GasTank = 650,
	StrengthText = "Weak",
	RepairCost = 1000,
	SeatsNum = 4,
	Skin_Price = 5200,
	Skins = {
				{skin = 0, name = "Grey", model = "models/golf/golf.mdl"},
				{skin = 1, name = "Blue", model = "models/golf/golf.mdl"},
				{skin = 2, name = "Green", model = "models/golf/golf.mdl"},
				{skin = 0, name = "Red", model = "models/golf/gol2.mdl"},
				{skin = 1, name = "Yellow", model = "models/golf/gol2.mdl"},
				{skin = 2, name = "Black", model = "models/golf/gol2.mdl"},
				{skin = 0, name = "Purple", model = "models/golf/gol3.mdl"},
				{skin = 1, name = "Taxi", model = "models/golf/gol3.mdl"},
				{skin = 2, name = "Light Blue", model = "models/golf/gol3.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 5, 15), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 57, 17), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-17, 57, 17), Angle(0, 0 ,10))
			end,
	MovePos = Vector(20,5,10),
}

GM.OCRP_Cars["CAR_BLISTA"] = {
	Name = "Blista Sport",
	OtherName = "CAR_BLISTA", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/blista.txt",
	Model = 	"models/sickness/blistadr.mdl",
	Price = 40000,
	Health = 100,
	Speed = 60,
	GasTank = 650,
	StrengthText = "Weak",
	RepairCost = 1000,
	SeatsNum = 2,
	Skin_Price = 5200,
	Skins = {
				{skin = 0, name = "Black", model = "models/sickness/blistadr.mdl"},
				{skin = 1, name = "White", model = "models/sickness/blistadr.mdl"},
				{skin = 2, name = "Red", model = "models/sickness/blistadr.mdl"},
				{skin = 3, name = "Green", model = "models/sickness/blistadr.mdl"},
				{skin = 4, name = "Blue", model = "models/sickness/blistadr.mdl"},
				{skin = 5, name = "Yellow", model = "models/sickness/blistadr.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 5, 15), Angle(0, 0 ,10))
				--GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 57, 17), Angle(0, 0 ,10))
				--GAMEMODE.CreatePassengerSeat(Entity, Vector(-17, 57, 17), Angle(0, 0 ,10))
			end,
	MovePos = Vector(20,5,10),
}


GM.OCRP_Cars["CAR_LIMO"] = {
	Name = "Dundreary Stretch Limousine",
	OtherName = "CAR_LIMO", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/stretch.txt",
	Model = "models/sickness/stretchdr.mdl",
	Price = 350000,
	Health = 120,
	Speed = 60,
	GasTank = 300,
	StrengthText = "Strong",
	RepairCost = 1000,
	SeatsNum = 8,
	Skin_Price = 8000,
	Skins = {
				{skin = 0, name = "Black", model = "models/sickness/stretchdr.mdl"},
				{skin = 1, name = "White", model = "models/sickness/stretchdr.mdl"},
				{skin = 2, name = "Grey", model = "models/sickness/stretchdr.mdl"},
				{skin = 3, name = "Red", model = "models/sickness/stretchdr.mdl"},
				{skin = 4, name = "Dark Green Fade", model = "models/sickness/stretchdr.mdl"},
				{skin = 5, name = "Dark Turq", model = "models/sickness/stretchdr.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-22,112,18), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(22,112,18), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-18,0,18), Angle(0, -90 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-18,28,18), Angle(0, -90 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-18,56,18), Angle(0, -90 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(22,-48,18), Angle(0, 0 ,10))			
			end,
	Exits = {
				Vector(-90,36,22),
				Vector(82,36,22),
				Vector(22,24,90),
				Vector(2,100,30),
			},
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["CAR_HUMMER"] = {
	Name = "Hummer H2",
	OtherName = "CAR_HUMMER", -- For the hell of it.
	Desc = "A nice sleek, hummer, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/hummer.txt",
	Model = "models/sickness/hummer-h2.mdl",
	Price = 80000,
	Health = 150,
	Speed = 55,
	GasTank = 300,
	StrengthText = "Very Strong",
	RepairCost = 1000,
	SeatsNum = 4,
	Skin_Price = 6000,
	Skins = {
				{skin = 0, name = "Red", model = "models/sickness/hummer-h2.mdl"},
				{skin = 1, name = "Black", model = "models/sickness/hummer-h2.mdl"},
				{skin = 2, name = "Silver", model = "models/sickness/hummer-h2.mdl"},
				{skin = 3, name = "White", model = "models/sickness/hummer-h2.mdl"},
				{skin = 4, name = "Green", model = "models/sickness/hummer-h2.mdl"},
				{skin = 5, name = "Blue", model = "models/sickness/hummer-h2.mdl"},
				{skin = 6, name = "Gray", model = "models/sickness/hummer-h2.mdl"},
				{skin = 8, name = "Yellow", model = "models/sickness/hummer-h2.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(25, -14, 36), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(25, 20, 36), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-25, 20, 36), Angle(0, 0 ,10))
			end,
	Exits = {
				Vector(-85.4888, 32.0606, 70),
				Vector(-85.7425, -21.2776, 70),
				Vector(85.3276, -25.8024, 70),
				Vector(85.5768, 35.7472, 70),
			},
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["CAR_BUS"] = {
	Name = "City Bus",
	OtherName = "CAR_BUS", -- For the hell of it.
	Desc = "A nice sleek van, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/evotrans.txt",
	Model = "models/sickness/gtabus.mdl",
	Price = 155000,
	Health = 150,
	Speed = 40,
	GasTank = 400,
	StrengthText = "Very Strong",
	RepairCost = 1000,
	SeatsNum = 17,
	Skin_Price = 6000,
	Skins = {
				{skin = 0, name = "Green", model = "models/sickness/gtabus.mdl"},
				{skin = 1, name = "Blue", model = "models/sickness/gtabus.mdl"},
				{skin = 2, name = "Black", model = "models/sickness/gtabus.mdl"},
				{skin = 3, name = "Full Black", model = "models/sickness/gtabus.mdl"},
				{skin = 4, name = "Red", model = "models/sickness/gtabus.mdl"},
				{skin = 5, name = "Full White", model = "models/sickness/gtabus.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(40, -100, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -100, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-40, -100, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-20, -100, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(40, -70, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -70, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-40, -70, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-20, -70, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(40, -40, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -40, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-40, -40, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-20, -40, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(40, -10, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -10, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-40, -10, 52), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-20, -10, 52), Angle(0, 0 ,0))
			
			end,
	-- Exits = {
				-- Vector(75.4888, 12.0606, 20.5582),
				-- Vector(-75.7425, 12.2776, 20.6878),
				-- Vector(-75.7425, -40, 20.6878),
			-- },
	MovePos = Vector(0,0,0),
}


GM.OCRP_Cars["CAR_VAN"] = {
	Name = "Vapid ST Van MK2",
	OtherName = "CAR_VAN", -- For the hell of it.
	Desc = "A nice sleek van, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/van.txt",
	Model = "models/sickness/speedodr.mdl",
	Price = 55000,
	Health = 150,
	Speed = 65,
	GasTank = 400,
	StrengthText = "Very Strong",
	RepairCost = 1000,
	SeatsNum = 6,
	Skin_Price = 6000,
	Skins = {
				{skin = 0, name = "Black", model = "models/sickness/speedodr.mdl"},
				{skin = 1, name = "White", model = "models/sickness/speedodr.mdl"},
				{skin = 2, name = "Red", model = "models/sickness/speedodr.mdl"},
				{skin = 3, name = "Pale Green", model = "models/sickness/speedodr.mdl"},
				{skin = 4, name = "Pale Blue", model = "models/sickness/speedodr.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(22, -30, 30), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(25, 52, 33), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(25, 67, 33), Angle(0, 180 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-25, 52, 33), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-25, 67, 33), Angle(0, 180 ,0))
			end,
	Exits = {
				Vector(75.4888, 12.0606, 20.5582),
				Vector(-75.7425, 12.2776, 20.6878),
				Vector(-75.7425, -40, 20.6878),
			},
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["CAR_MINIVAN"] = {
	Name = "Vapid Minivan Sport",
	OtherName = "CAR_MINIVAN", -- For the hell of it.
	Desc = "A nice sleek minivan, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/minivan.txt",
	Model = "models/sickness/minivandr.mdl",
	Price = 60000,
	Health = 100,
	Speed = 60,
	GasTank = 500,
	StrengthText = "Average Strength",
	RepairCost = 1000,
	SeatsNum = 5,
	Skin_Price = 4500,
	Skins = {
				{skin = 0, name = "Black", model = "models/sickness/minivandr.mdl"},
				{skin = 1, name = "White", model = "models/sickness/minivandr.mdl"},
				{skin = 2, name = "Grey", model = "models/sickness/minivandr.mdl"},
				{skin = 3, name = "Purple/Maroon", model = "models/sickness/minivandr.mdl"},
				{skin = 4, name = "Dark Green", model = "models/sickness/minivandr.mdl"},
				{skin = 5, name = "Dark Turq.", model = "models/sickness/minivandr.mdl"},
				{skin = 6, name = "Taxi Yellow", model = "models/sickness/minivandr.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(18,-13,19.5), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(18,31,19.5), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(0,31,19.5), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-18,31,19.5), Angle(0, 0 ,10))
			end,
	Exits = {
				Vector(-90,36,22),
				Vector(82,36,22),
				Vector(-90,18,22),
				Vector(82,18,22),
			},
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["CAR_PMP"] = {
	Name = "PMP600",
	OtherName = "CAR_PMP", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/pmp600.txt",
	Model = "models/sickness/pmp600dr.mdl",
	Price = 69500,
	Health = 100,
	Speed = 60,
	GasTank = 550,
	StrengthText = "Strong",
	RepairCost = 3000,
	SeatsNum = 4,
	Skin_Price = 9000,
	Skins = {
				{skin = 0, name = "Grey", model = "models/sickness/pmp600dr.mdl"},
				{skin = 1, name = "White", model = "models/sickness/pmp600dr.mdl"},
				{skin = 2, name = "Dark Pink", model = "models/sickness/pmp600dr.mdl"},
				{skin = 3, name = "Dark Green", model = "models/sickness/pmp600dr.mdl"},
				{skin = 4, name = "Turquoise", model = "models/sickness/pmp600dr.mdl"},
				{skin = 5, name = "Purple", model = "models/sickness/pmp600dr.mdl"},
				{skin = 6, name = "Orange", model = "models/sickness/pmp600dr.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -1, 10), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 20, 10), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-20, 20, 10), Angle(0, 0 ,10))
			end,
	MovePos = {Vec = Vector(-18,8,18), Ang = Angle(0,90,0)},
}

GM.OCRP_Cars["CAR_ASTON"] = {
	Name = "Aston Martin Vanquish",
	OtherName = "CAR_ASTON", -- For the hell of it.
	Desc = "The British pride. This car beats them all on the track!",
	Script = "scripts/vehicles/vanquish.txt",
	Model = "models/sickness/vanquish.mdl",
	Price = 300000,
	Health = 120,
	Speed = 90,
	GasTank = 800,
	StrengthText = "Strong",
	RepairCost = 3000,
	SeatsNum = 2,
	Skin_Price = 7000,
	Skins = {
				{skin = 0, name = "Green", model = "models/sickness/vanquish.mdl"},
				{skin = 1, name = "Blue", model = "models/sickness/vanquish.mdl"},
				{skin = 2, name = "Dark Blue", model = "models/sickness/vanquish.mdl"},
				{skin = 3, name = "White", model = "models/sickness/vanquish.mdl"},
				{skin = 4, name = "Red", model = "models/sickness/vanquish.mdl"},
				{skin = 5, name = "Black", model = "models/sickness/vanquish.mdl"},
				{skin = 6, name = "Cream", model = "models/sickness/vanquish.mdl"},
				{skin = 7, name = "Forest Green", model = "models/sickness/vanquish.mdl"},
				{skin = 8, name = "Brown", model = "models/sickness/vanquish.mdl"},

			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(25, 10, 15), Angle(0, 0, 20))
			end,
	MovePos = {Vec = Vector(-23, -30, 20), Ang = Angle(0, 90, 0)}
}


GM.OCRP_Cars["CAR_LAMBO"] = {
	Name = "Lamborghini Miura SV",
	OtherName = "CAR_LAMBO", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/lambo.txt",
	Model = "models/lambo/lambo.mdl",
	Price = 225000,
	Health = 120,
	Speed = 85,
	GasTank = 800,
	StrengthText = "Strong",
	RepairCost = 3000,
	SeatsNum = 2,
	Skin_Price = 7000,
	Skins = {
				{skin = 0, name = "White", model = "models/lambo/lambo.mdl"},
				{skin = 1, name = "Red", model = "models/lambo/lambo.mdl"},
				{skin = 2, name = "Blue", model = "models/lambo/lambo.mdl"},
				{skin = 3, name = "Silver", model = "models/lambo/lambo.mdl"},
				{skin = 4, name = "Orange", model = "models/lambo/lambo.mdl"},
				{skin = 5, name = "Light Blue", model = "models/lambo/lambo.mdl"},
				{skin = 6, name = "Green", model = "models/lambo/lambo.mdl"},
				{skin = 7, name = "Black", model = "models/lambo/lambo.mdl"},
				{skin = 8, name = "Brown", model = "models/lambo/lambo.mdl"},
				{skin = 9, name = "Purple", model = "models/lambo/lambo.mdl"},
				{skin = 10, name = "Pink", model = "models/lambo/lambo.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(25, 10, 15), Angle(0, 0, 20))
			end,
	MovePos = {Vec = Vector(-23, -30, 20), Ang = Angle(0, 90, 0)}
}

GM.OCRP_Cars["CAR_STALLION"] = {
	Name = "Stallion GTO",
	OtherName = "CAR_STALLION", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/stallion.txt",
	Model = "models/sickness/stalliondr.mdl",
	Price = 110000,
	Health = 120,
	Speed = 85,
	GasTank = 800,
	StrengthText = "Strong",
	RepairCost = 3000,
	SeatsNum = 2,
	Skin_Price = 5000,
	Skins = {
				{skin = 0, name = "Black", model = "models/sickness/stalliondr.mdl"},
				{skin = 1, name = "White", model = "models/sickness/stalliondr.mdl"},
				{skin = 2, name = "Red", model = "models/sickness/stalliondr.mdl"},
				{skin = 3, name = "Green", model = "models/sickness/stalliondr.mdl"},
				{skin = 4, name = "Blue", model = "models/sickness/stalliondr.mdl"},
				{skin = 5, name = "Yellow", model = "models/sickness/stalliondr.mdl"},

			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 10, 10), Angle(0, 0, 20))
			end,
	MovePos = Vector(0,0,0) --{Vec = Vector(-23, -30, 20), Ang = Angle(0, 90, 0)}
}

GM.OCRP_Cars["CAR_VIRGO"] = {
	Name = "Lincoln Virgo",
	OtherName = "CAR_VIRGO", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/virgo.txt",
	Model = "models/sickness/virgodr.mdl",
	Price = 100000,
	Health = 120,
	Speed = 85,
	GasTank = 800,
	StrengthText = "Strong",
	RepairCost = 3000,
	SeatsNum = 2,
	Skin_Price = 5000,
	Skins = {
				{skin = 0, name = "Black", model = "models/sickness/virgodr.mdl"},
				{skin = 1, name = "White", model = "models/sickness/virgodr.mdl"},
				{skin = 2, name = "Red", model = "models/sickness/virgodr.mdl"},
				{skin = 3, name = "Green", model = "models/sickness/virgodr.mdl"},
				{skin = 4, name = "Blue", model = "models/sickness/virgodr.mdl"},

			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 10, 10), Angle(0, 0, 20))
			end,
	MovePos = Vector(0,0,0) --{Vec = Vector(-23, -30, 20), Ang = Angle(0, 90, 0)}
}

GM.OCRP_Cars["CAR_CATERHAM"] = {
	Name = "Caterham Roadster",
	OtherName = "CAR_CATERHAM", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/caterham.txt",
	Model = "models/caterham/caterham.mdl",
	Price = 289500,
	Health = 80,
	Speed = 100,
	GasTank = 350,
	StrengthText = "Weak",
	RepairCost = 6000,
	SeatsNum = 2,
	Skin_Price = 10000,
	Skins = {
				{skin = 0, name = "White", model = "models/caterham/caterham.mdl"},
				{skin = 1, name = "Red", model = "models/caterham/caterham.mdl"},
				{skin = 2, name = "Blue", model = "models/caterham/caterham.mdl"},
				{skin = 3, name = "Grey", model = "models/caterham/caterham.mdl"},
				{skin = 4, name = "Orange", model = "models/caterham/caterham.mdl"},
				{skin = 5, name = "Light Blue", model = "models/caterham/caterham.mdl"},
				{skin = 6, name = "Green", model = "models/caterham/caterham.mdl"},
				{skin = 7, name = "Black", model = "models/caterham/caterham.mdl"},
				{skin = 8, name = "Brown", model = "models/caterham/caterham.mdl"},
				{skin = 9, name = "Purple", model = "models/caterham/caterham.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(12, 30, 10), Angle(0, 0, 10))
			end,
	MovePos = {Vec = Vector(-10,-45,15), Ang = Angle(0, 90, 0)}
}

GM.OCRP_Cars["CAR_MINI"] = {
	Name = "Mini",
	OtherName = "CAR_MINI", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/mini.txt",
	Model = "models/mini/mini.mdl",
	Price = 29500,
	Health = 80,
	Speed = 50,
	GasTank = 600,
	StrengthText = "Weak",
	RepairCost = 1000,
	SeatsNum = 4,
	Skin_Price = 4000,
	Skins = {
				{skin = 0, name = "White", model = "models/mini/mini.mdl"},
				{skin = 1, name = "Red", model = "models/mini/mini.mdl"},
				{skin = 2, name = "Blue", model = "models/mini/mini.mdl"},
				{skin = 3, name = "Silver", model = "models/mini/mini.mdl"},
				{skin = 4, name = "Orange", model = "models/mini/mini.mdl"},
				{skin = 5, name = "Light Blue", model = "models/mini/mini.mdl"},
				{skin = 6, name = "Green", model = "models/mini/mini.mdl"},
				{skin = 7, name = "Black", model = "models/mini/mini.mdl"},
				{skin = 8, name = "Brown", model = "models/mini/mini.mdl"},
				{skin = 9, name = "Purple", model = "models/mini/mini.mdl"},
				{skin = 10, name = "Pink", model = "models/mini/mini.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-14, -6, 10), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(14, 36, 10), Angle(0, 0 ,0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-14, 36, 10), Angle(0, 0 ,0))
			end,
	MovePos = {Vec = Vector(14, -6, 18), Ang = Angle(0, 90, 0)}
}

GM.OCRP_Cars["CAR_CORVETTE"] = {
	Name = "Corvette",
	OtherName = "CAR_CORVETTE", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/corvette.txt",
	Model = {
				"models/corvette/corvette.mdl",
				"models/corvette/corvett2.mdl",
				"models/corvette/corvett3.mdl",
				"models/corvette/corvett4.mdl",
				"models/corvette/corvetoc.mdl",
			},
	Price = 115000,
	Health = 120,
	Speed = 75,
	GasTank = 700,
	StrengthText = "Strong",
	RepairCost = 1000,
	SeatsNum = 2,
	Skin_Price = 6000,
	Skins = {
				{skin = 0, name = "Blue", model = "models/corvette/corvette.mdl"},
				{skin = 1, name = "Silver", model = "models/corvette/corvette.mdl"},
				{skin = 2, name = "Yellow", model = "models/corvette/corvette.mdl"},
				{skin = 0, name = "Red", model = "models/corvette/corvett2.mdl"},
				{skin = 1, name = "Green", model = "models/corvette/corvett2.mdl"},
				{skin = 2, name = "Black", model = "models/corvette/corvett2.mdl"},
				{skin = 0, name = "Purple", model = "models/corvette/corvett3.mdl"},
				{skin = 0, name = "Special", model = "models/corvette/corvetoc.mdl", Org = 99},
				{skin = 2, name = "Light Blue", model = "models/corvette/corvett3.mdl"},
				{skin = 1, name = "Blue with Stripes", model = "models/corvette/corvett4.mdl"},
				{skin = 2, name = "Yellow with Stripes", model = "models/corvette/corvett4.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(23, 15, 13), Angle(0, 0, 10))
			end,
	MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["CAR_VOODOO"] = {
	Name = "Voodoo SS",
	OtherName = "CAR_VOODOO", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/lowrider.txt",
	Model = "models/sickness/voodoodr.mdl",
	Price = 50000,
	Health = 120,
	Speed = 45,
	GasTank = 500,
	StrengthText = "Strong",
	RepairCost = 1000,
	SeatsNum = 4,
	Skin_Price = 4500,
	Skins = {
				{skin = 0, name = "Blue/White", model = "models/sickness/voodoodr.mdl"},
				{skin = 1, name = "Black/White", model = "models/sickness/voodoodr.mdl"},
				{skin = 2, name = "Green/White", model = "models/sickness/voodoodr.mdl"},
				{skin = 3, name = "White/Light Blue", model = "models/sickness/voodoodr.mdl"},
				{skin = 4, name = "Orange/White", model = "models/sickness/voodoodr.mdl"},
				{skin = 5, name = "Purple/White", model = "models/sickness/voodoodr.mdl"},
				{skin = 6, name = "Purple/Black", model = "models/sickness/voodoodr.mdl"},
				{skin = 7, name = "Black/Light Blue", model = "models/sickness/voodoodr.mdl"},
				{skin = 8, name = "Green/Black", model = "models/sickness/voodoodr.mdl"},
				{skin = 9, name = "Dark Blue/Light Blue", model = "models/sickness/voodoodr.mdl"},
				{skin = 10, name = "Orange/Black", model = "models/sickness/voodoodr.mdl"},
				{skin = 11, name = "Orange/Purple", model = "models/sickness/voodoodr.mdl"},
				
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -8, 12), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 33, 10), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-17, 33, 10), Angle(0, 0 ,10))
			end,
	MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["CAR_ESCALADE"] = {
	Name = "Albany Cavalcade RS",
	OtherName = "CAR_ESCALADE", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/escalade.txt",
	Model = "models/sickness/cavalcadedr.mdl",
	Price = 62500,
	Health = 160,
	Speed = 52,
	GasTank = 400,
	StrengthText = "Very Strong",
	RepairCost = 1000,
	SeatsNum = 5,
	Skin_Price = 6500,
	Skins = {
				{skin = 0, name = "Black", model = "models/sickness/cavalcadedr.mdl"},
				{skin = 1, name = "White", model = "models/sickness/cavalcadedr.mdl"},
				{skin = 2, name = "Grey", model = "models/sickness/cavalcadedr.mdl"},
				{skin = 3, name = "Dark Pink", model = "models/sickness/cavalcadedr.mdl"},
				{skin = 4, name = "Green", model = "models/sickness/cavalcadedr.mdl"},
				{skin = 5, name = "Turquoise", model = "models/sickness/cavalcadedr.mdl"},				
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -8, 30), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(22, 35, 30), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(0, 35, 30), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-22, 35, 30), Angle(0, 0 ,10))
			end,
	MovePos = Vector(0,0,0)
}


GM.OCRP_Cars["CAR_YANKEE"] = {
	Name = "DS9 Yankee Truck",
	OtherName = "CAR_YANKEE", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/yankee.txt",
	Model = {
				"models/sickness/yankeedr.mdl",
				"models/yankee/yankeedr1.mdl",
			},
	Price = 69500,
	Health = 150,
	Speed = 50,
	GasTank = 500,
	StrengthText = "Very Strong",
	RepairCost = 1000,
	SeatsNum = 2,
	Skin_Price = 4500,
	Skins = {
				{skin = 0, name = "White", model = "models/sickness/yankeedr.mdl"},
				{skin = 1, name = "MTL Black", model = "models/sickness/yankeedr.mdl"},
				{skin = 2, name = "Brown", model = "models/sickness/yankeedr.mdl"},
				{skin = 3, name = "Blue", model = "models/sickness/yankeedr.mdl"},
				{skin = 4, name = "EDOT Orange", model = "models/sickness/yankeedr.mdl"},
				{skin = 4, name = "CosmosFM", model = "models/yankee/yankeedr1.mdl", dj = "true"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(23, -42, 52), Angle(0, 0, 0))
			end,
	MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["CAR_MULE"] = {
	Name = "Maibatsu Mule Cargo Truck",
	OtherName = "CAR_MULE", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/mulebox.txt",
	Model = "models/sickness/muledr.mdl",
	Price = 75500,
	Health = 150,
	Speed = 60,
	GasTank = 500,
	StrengthText = "Very Strong",
	RepairCost = 1000,
	SeatsNum = 2,
	Skin_Price = 4500,
	Skins = {
				{skin = 0, name = "White", model = "models/sickness/muledr.mdl"},
				{skin = 1, name = "MTL Black", model = "models/sickness/muledr.mdl"},
				{skin = 2, name = "Brown", model = "models/sickness/muledr.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(23, -109, 60), Angle(0, 0, 0))
			end,
	MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["CAR_INTER"] = {
	Name = "International 2674 Truck",
	OtherName = "CAR_INTER", -- For the hell of it.
	Desc = "Perfect to transport large objects and vehicles.",
	Script = "scripts/vehicles/international_2674.txt",
	Model = "models/sickness/international_2674.mdl",
	Price = 69500,
	Health = 150,
	Speed = 50,
	GasTank = 500,
	StrengthText = "Very Strong",
	RepairCost = 1000,
	SeatsNum = 2,
	Skin_Price = 4500,
	Skins = {
				{skin = 0, name = "Edot", model = "models/sickness/international_2674.mdl"},
				{skin = 1, name = "MTL Blue", model = "models/sickness/international_2674.mdl"},
				{skin = 2, name = "White", model = "models/sickness/international_2674.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -30, 55), Angle(0, 0, 0))
			end,
	MovePos = Vector(0,0,0)
}


GM.OCRP_Cars["CAR_PHANTOM"] = {
	Name = "Phantom SemiTruck",
	OtherName = "CAR_PHANTOM", -- For the hell of it.
	Desc = "A tank.",
	Script = "scripts/vehicles/phantom.txt",
	Model = "models/sickness/phantomdr.mdl",
	Price = 99500,
	Health = 500,
	Speed = 50,
	GasTank = 1000,
	StrengthText = "TAAAAANK",
	RepairCost = 1000,
	SeatsNum = 2,
	Skin_Price = 4500,
	Skins = {
				{skin = 0, name = "White", model = "models/sickness/phantomdr.mdl"},
				{skin = 1, name = "Black", model = "models/sickness/phantomdr.mdl"},
				{skin = 2, name = "Brown", model = "models/sickness/phantomdr.mdl"},
				{skin = 3, name = "Semi Turquoise", model = "models/sickness/phantomdr.mdl"},
				{skin = 4, name = "Orange", model = "models/sickness/phantomdr.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, -30, 55), Angle(0, 0, 0))
			end,
	MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["CAR_HUNTLEY"] = {
	Name = "Vapid Hunltey Sport 4x4",
	OtherName = "CAR_HUNTLEY", -- For the hell of it.
	Desc = "Sports SUV with a range of colours.",
	Script = "scripts/vehicles/sports-suv.txt",
	Model = "models/sickness/huntleydr.mdl",
	Price = 130000,
	Health = 150,
	Speed = 50,
	GasTank = 420,
	StrengthText = "Very Strong",
	RepairCost = 1000,
	SeatsNum = 5,
	Skin_Price = 4500,
	Skins = {
				{skin = 0, name = "Black/White", model = "models/sickness/huntleydr.mdl"},
				{skin = 1, name = "Blue/White", model = "models/sickness/huntleydr.mdl"},
				{skin = 2, name = "Red/White", model = "models/sickness/huntleydr.mdl"},
				{skin = 3, name = "Maroon/White", model = "models/sickness/huntleydr.mdl"},
				{skin = 4, name = "Green/White", model = "models/sickness/huntleydr.mdl"},
				{skin = 6, name = "White", model = "models/sickness/huntleydr.mdl"},
				{skin = 7, name = "Black/Blue", model = "models/sickness/huntleydr.mdl"},
				{skin = 8, name = "Black/Red", model = "models/sickness/huntleydr.mdl"},
				{skin = 9, name = "Black/Maroon", model = "models/sickness/huntleydr.mdl"},
				{skin = 10, name = "Black/Green", model = "models/sickness/huntleydr.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 1, 30), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(22, 50, 35), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(0, 50, 35), Angle(0, 0 ,10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-22, 50, 35), Angle(0, 0 ,10))
			end,
	MovePos = Vector(0,0,0)
}

GM.OCRP_Cars["CAR_ATV"] = {
	Name = "ATV",
	OtherName = "CAR_ATV", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/rubicon.txt",
	Model = {
				"models/rubicon.mdl",
				"models/rubicon2.mdl",
			},
	Price = 1500,
	Health = 60,
	Speed = 30,
	GasTank = 125,
	StrengthText = "Weak",
	RepairCost = 500,
	SeatsNum = 1,
	Skin_Price = 3000,
	Skins = {
				{skin = 0, name = "Red", model = "models/rubicon.mdl"},
				{skin = 1, name = "Blue", model = "models/rubicon.mdl"},
				{skin = 2, name = "Black", model = "models/rubicon.mdl"},
				{skin = 0, name = "Orange", model = "models/rubicon2.mdl"},
				{skin = 1, name = "Green", model = "models/rubicon2.mdl"},
				{skin = 2, name = "Pink", model = "models/rubicon2.mdl"},
			},
	Seats = function( ply, Entity )
			end,
	MovePos = {Vec = Vector(0, -23, 40), Ang = Angle(25, 90, 0)}
}

GM.OCRP_Cars["CAR_MURC"] = {
	Name = "Murcielago",
	OtherName = "CAR_MURC", -- For the hell of it.
	Desc = "A nice sleek, car, yup you can't beat it... heh this is really just a test of this to test if it's multiline okay.",
	Script = "scripts/vehicles/murcielago.txt",
	Model = {	
				"models/sickness/murcielago.mdl",
				"models/sickness/murcielag1.mdl",
			},
	Price = 300000,
	Health = 60,
	Speed = 30,
	GasTank = 600,
	StrengthText = "Strong",
	RepairCost = 500,
	SeatsNum = 2,
	Skin_Price = 3000,
	Skins = {
				{skin = 0, name = "Yellow", model = "models/sickness/murcielago.mdl"},
				{skin = 1, name = "Black", model = "models/sickness/murcielago.mdl"},
				{skin = 2, name = "Orange", model = "models/sickness/murcielago.mdl"},
				{skin = 3, name = "Grey/Silver", model = "models/sickness/murcielago.mdl"},
				{skin = 4, name = "Purple", model = "models/sickness/murcielago.mdl"},
				{skin = 5, name = "Lime", model = "models/sickness/murcielago.mdl"},
				{skin = 6, name = "Light Blue", model = "models/sickness/murcielago.mdl"},
			},
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(50, 0, 5), Angle(0, 0, 0))
			end,
	MovePos = {Vec = Vector(0, -23, 40), Ang = Angle(25, 90, 0)}
}

GM.OCRP_Cars["Police"] = {
	Model = "models/sickness/lcpddr.mdl",
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 0, 13), Angle(0, 0, 10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 28, 13), Angle(0, 0, 10))	
				GAMEMODE.CreatePassengerSeat(Entity, Vector(5, 28, 13), Angle(0, 0, 10))
			end,
	Exits = {},
	GasTank = 1,
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["Police_NEW"] = {
	Model = "models/tdmcars/copcar.mdl",
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 0, 13), Angle(0, 0, 10))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(20, 28, 13), Angle(0, 0, 10))	
				GAMEMODE.CreatePassengerSeat(Entity, Vector(5, 28, 13), Angle(0, 0, 10))
			end,
	Exits = {},
	GasTank = 1,
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["Ambo"] = {
	Model = "models/sickness/meatwagon.mdl",
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(25, -53, 34), Angle(0, 0, 10))
			end,
	Exits = {
				Vector(-70.3399, 70.0193, 0.2515),
				Vector(70.520, 59.9409, 0.3834),
			},
	GasTank = 1,		
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["Fire"] = {
	Model = "models/sickness/truckfire.mdl",
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(23, -121, 46), Angle(0, 0, 0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(23, -60, 46), Angle(0, 0, 0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-23, -60, 46), Angle(0, 0, 0))
			end,
	Exits = {
				Vector(104, 133, -2),
				Vector(104, 68, -2),
				Vector(-104, 133, -2),
				Vector(-104, 68, -2),
			},
	GasTank = 1,		
	MovePos = Vector(0,0,0),
}

GM.OCRP_Cars["SWAT"] = {
	Model = "models/sickness/stockade2dr.mdl",
	Seats = function( ply, Entity )
				GAMEMODE.CreatePassengerSeat(Entity, Vector(23, -31, 50), Angle(0, 0, 0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(28, 100, 50), Angle(0, 90, 0))
				GAMEMODE.CreatePassengerSeat(Entity, Vector(-28, 100, 50), Angle(0, 270, 0))
			end,
	Exits = {
				Vector(104, 133, -2),
				Vector(104, 68, -2),
				Vector(-104, 133, -2),
				Vector(-104, 68, -2),
			},
	GasTank = 1,		
	MovePos = Vector(0,0,0),
}
