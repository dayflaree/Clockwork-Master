-- Code: Sterilize, Unify, Pacifice.
TS.Flags =
{

	Recruit =
	{
	
		ID = "R",
		Loadout = { "flashlight", "radio", "ts2_zipties", "ts2_ziptiecutters", "ts2_stunstick" },
		Model = "models/police.mdl",
		IsCCA = true,
	},
	
	SquaddedRecruit =
	{
	
		ID = "Rs",
		Loadout = { "flashlight", "radio", "ts2_zipties", "ts2_ziptiecutters", "ts2_stunstick", "ts2_45" },
		Model = "models/police.mdl",
		IsCCA = true,
	},

	GroundUnit =
	{
	
		ID = "G",
		Loadout = { "flashlight", "radio", "ts2_zipties", "ts2_ziptiecutters", "ts2_mp7", "ts2_45", "ts2_stunstick" },
		Model = "models/police.mdl",
		IsCCA = true,
	},
	
	NomadUnit =
	{
	
		ID = "N",
		Loadout = { "flashlight", "radio", "ts2_zipties", "ts2_ziptiecutters", "ts2_mp7", "ts2_45", "ts2_stunstick" },
		Model = "models/police.mdl",
		IsCCA = true,
	},
	
	
	TrenchUnit =
	{
	
		ID = "T",
		Loadout = { "flashlight", "radio", "ts2_zipties", "ts2_ziptiecutters", "ts2_mp7", "ts2_45", "ts2_stunstick" },
		Model = "models/policetrench.mdl",
		IsCCA = true,
	},
	
	IntelUnit =
	{
	
		ID = "I",
		Loadout = { "flashlight", "radio", "ts2_zipties", "ts2_ziptiecutters", "ts2_mp7silenced", "ts2_m92s", "ts2_stunstick" },
		Model = "models/eliteshockcp.mdl",
		IsCCA = true,
	},
	
	CommandUnit =
	{
	
		ID = "C",
		Loadout = { "flashlight", "radio", "ts2_zipties", "ts2_ziptiecutters", "ts2_mp7", "ts2_m92s", "ts2_stunstick" },
		Model = "models/police.mdl",
		IsCCA = true,
	},
	
	DvL =
	{
	
		ID = "D",
		Loadout = { "flashlight", "radio", "ts2_zipties", "ts2_ziptiecutters", "ts2_ar2", "ts2_m92s", "ts2_stunstick" },
		Model = "models/urbantrenchcoat.mdl",
		IsCCA = true,
	},
	
	SeC =
	{
	
		ID = "S",
		Loadout = { "flashlight", "radio", "ts2_zipties", "ts2_ziptiecutters", "ts2_ar2", "ts2_m92s", "ts2_stunstick" },
		Model = "models/urbantrenchcoat.mdl",
		IsCCA = true,
	},
	
	OW =
	{
		ID = "O",
		Loadout = { "flashlight", "radio", "ts2_ar2", "ts2_12gauge" },
		Model = "models/combine_soldier.mdl",
		IsCCA = false,
	},
	
	OWElite = 
	{
		ID = "Oe",
		Loadout = { "flashlight", "radio", "ts2_ar2", "ts2_12gauge" },
		Model = "models/Combine_Super_Soldier.mdl",
		IsCCA = false,
	},
	
	OWPrisonGuard =
	{
		ID = "Op",
		Loadout = { "flashlight", "radio", "ts2_ar2", "ts2_12gauge" },
		Model = "models/Combine_Soldier_PrisonGuard.mdl",
		IsCCA = false,
	},
	
	CA =
	{
		ID = "A",
		Loadout = { "flashlight", "radio", "ts2_m92" },
		Model = "models/humans/barnes/c8_admin.mdl",
		IsCCA = false,
	},
	
	Vort =
	{
		ID = "V",
		Loadout = {},
		Model = "models/vortigaunt.mdl",
		IsCCA = false,
	},
	
	VortSlave =
	{
		ID = "Vs",
		Loadout = {},
		Model = "models/vortigaunt_slave.mdl",
		IsCCA = false,
	},
}

function GetBestFlag(flags)
	local bv = nil
	for _, v in pairs(TS.Flags) do
		if string.find(flags, v.ID) and (not bv or v.ID > bv.ID) then
			bv = v
		end
	end
	return bv
end