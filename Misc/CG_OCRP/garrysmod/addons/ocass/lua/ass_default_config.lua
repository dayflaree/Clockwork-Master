
ASS_Config["writer"] = "Default Writer"
ASS_Config["max_temp_admin_time"] = 	4 * 60
ASS_Config["max_temp_admin_ban_time"] = 1 * 60

ASS_Config["bw_background"] = 1
ASS_Config["tell_admins_what_happened"] = 1

ASS_Config["demomode"] = 0
ASS_Config["demomode_ta_time"] = 30

ASS_Config["admin_speak_prefix"] = "@"

ASS_Config["reasons"] = {
		
	{	name = "Text Spamming",	        			reason = "Text Spamming"						},
	{	name = "Microphone Spamming",				reason = "Mic. Spamming"						},
	{	name = "Admin Disrespect",					reason = "Admin Disrespect"						},
	{	name = "Prop Deathmatch/Surfing/Blocking",	reason = "Prop Deathmatch/Surfing/Blocking"		},
	{ 	name = "Metagaming",						reason = "Metagaming"							},
	{ 	name = "Random Deathmatch",					reason = "Random Deathmatch (RDM)"				},
	{ 	name = "Begging",							reason = "Do not beg for loans / money."			},
	{ 	name = "Flaming",							reason = "Flaming"								},
	{ 	name = "All caps in OOC",					reason = "All Caps in OOC"						},
	{ 	name = "Complaining in OOC",				reason = "Don't QQ in OOC"						},
	{ 	name = "Shitty driving/parking",			reason = "Bad Parking/Driving"						},
	
}

ASS_Config["ban_times"] = {

	{ 	time = 1,		name = "1 Min"		},
	{ 	time = 5,		name = "5 Min"		},
	{ 	time = 15,		name = "15 Min"		},
	{ 	time = 30,		name = "30 Min" 	},
	{ 	time = 45,		name = "45 Min" 	},
	{ 	time = 60,		name = "1 Hour"		},
	{ 	time = 60 * 2,		name = "2 Hours"	},
	{ 	time = 60 * 3,		name = "3 Hours"	},
	{ 	time = 60 * 4,		name = "4 Hours"	},
	{ 	time = 60 * 6,		name = "6 Hours"	},
	{ 	time = 60 * 12,		name = "12 Hours"	},
	{ 	time = 60 * 24 * 1,	name = "1 Day"		},
	{ 	time = 60 * 24 * 2,	name = "2 Days"		},
	{ 	time = 60 * 24 * 3,	name = "3 Days"		},
	{ 	time = 60 * 24 * 4,	name = "4 Days"		},
	{ 	time = 60 * 24 * 5,	name = "5 Days"		},
	{ 	time = 60 * 24 * 7,	name = "1 Week"		},
	{ 	time = 60 * 24 * 14,	name = "2 Weeks"	},
	{ 	time = 60 * 24 * 21,	name = "3 Weeks"	},
	{ 	time = 60 * 24 * 31,	name = "1 Month"	},
	{ 	time = 0,		name = "Perma"		},

}

ASS_Config["temp_admin_times"] = {

	{ 	time = 5,		name = "5 Min"		},
	{ 	time = 15,		name = "15 Min"		},
	{ 	time = 30,		name = "30 Min" 	},
	{ 	time = 60,		name = "1 Hour"		},
	{ 	time = 120,		name = "2 Hours"	},
	{ 	time = 240,		name = "4 Hours"	},

}

ASS_Config["fixed_notices"] = {

	{	duration = 10,		text = "Welcome to %hostname%. Please play nice!"			},
	{	duration = 10,		text = "Running %gamemode% on %map%"					},
	{	duration = 10,		text = "%assmod% - If you're an admin, bind a key to +ASS_Menu"		},

}
		
ASS_Config["rcon"] = {

	{	cmd = "sv_voiceenable 1"	},
	{	cmd = "sv_voiceenable 0"	},
	{	cmd = "sv_noclipaccelerate 10" 	},
	{	cmd = "sv_noclipaccelerate 6" 	},
	
	
}
