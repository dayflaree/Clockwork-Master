--Sassilization by Sassafrass Models by Jaanus

GM.Name 	= "Sassilization"
GM.Author 	= "Sassafrass"

TEAM_JOINING = 0
TEAM_PLAYERS = 2

team.SetUp(TEAM_JOINING, "Initializing", Color(80, 80, 80, 255))
team.SetUp(TEAM_PLAYERS, "Players", Color(220, 20, 20, 255))

default_food = 120
default_gold = 70
default_iron = 75
default_supply = 3

victory_lead = 200 --Once you reach the victory goal you must be ahead by this much to win or reach the victory limit.
victory_goal = 800 --how much gold needs to be accumulated before winning
victory_limit = 1000 --how much gold to win no matter what
select_limit = 10 --how many armies can be selected at once. NOTICE: too many causes crashes.
unit_limit = select_limit * 3.5
ally_limit = 2 -- for Infinite Allies, use -1. 1 would allow two people to be grouped. 0 would mean no allies.

iron_tick = 1 --how much iron is gained each tick from each node
food_tick = 1.2 --how much food is gained each tick from each node
iron_income = 8
food_income = 8
supply_income = 1

resource_tick = 10 --delay in seconds between resource collection
minimap_tick = 20
scoreboard_tick = 12

gate_maxvary = 8 -- How jagged a wall can be to allow a gate on it.
wall_distance = 180 -- How far a spawned fence will check for neighboring fences
wall_spacing = 7.5 -- The distance between auto filled fences

allow_setup = false --If true, always allows players to create their resources when they start the game.

VIPBONUS = 1.25
INTERMISSION = 10 --Time between each round or map
ROUNDCHANGELIMIT = 1 --Number of rounds before the map changes
PLAYEDROUNDS = 1 --The current round (DON'T CHANGE THIS)
BONUSPOINTCOUNT = 20 --Number of points needed for a reward
BONUSCASH = 37 --Number of money for each bonus reward
STARTDELAY = 100 --The time before the game starts
ALLOWALL = false --No more store
ALLIANCES = true --No Alliances
ALLIEDRESOURCES = false --Should Allies share Resources
ALLIEDTERRITORIES = false --Should Allies share Territories
MONUMENTS = {}

local META = FindMetaTable( "Player" )
if (!META) then return end

function META:Nick()
	local nick = self:GetNWString("fakename")
	if nick and nick != "" then
		return nick
	else
		return SERVER and self:GetInfo("name") or self:GetName()
	end
end

function META:Mute( bWant )
	for _, pl in pairs( player.GetAll() ) do
		pl:SendLua( "IgnorePlayer( "..self:UserID()..", "..tostring(bWant).." )" )
	end
end

function META:GetMoney()
	return self:GetNWInt("money")
end

function META:HasClan()
	if self:GetNWString("clantag") then
		return self:GetNWString("clantag")
	end
	return false
end

META = nil

local META = FindMetaTable( "Entity" )
if (!META) then return end

function META:GetOverlord()
	return self.Overlord
end

function META:IsDead()
	local self = self.anim and self.anim or self
	if !self:GetNWBool("dead") then
		return false
	elseif self:GetNWBool("dead") and self:GetNWBool("spawning") then
		return false
	elseif self:GetNWBool("dead") then
		return true
	end
end

META = nil

function player.GetByUID( uid )
	if !uid then return false end
	for _, pl in pairs( player.GetAll() ) do
		if tostring(pl:UserID()) == tostring(uid) then
			return pl
		end
	end
	return false
end

MB_LEFT = 107
MB_RIGHT = 108
MB_MIDDLE = 109

MASK_SHOT			=	1174421507
MASK_DEADSOLID			=	65547
MASK_SOLID			=	33570827
MASK_PLAYERSOLID		=	33636363
MASK_ALL			=	-1
MASK_OPAQUE			=	16513
MASK_OPAQUE_AND_NPCS		=	33570944
MASK_SPLITAREAPORTAL		=	48
MASK_PLAYERSOLID_BRUSHONLY	=	81931
MASK_BLOCKLOS_AND_NPCS		=	33570880
MASK_VISIBLE			=	24705
MASK_NPCSOLID			=	33701899
MASK_BLOCKLOS			=	16449
MASK_NPCSOLID_BRUSHONLY		=	147467
MASK_NPCWORLDSTATIC		=	131083
MASK_WATERWORLD			=	147515
MASK_VISIBLE_AND_NPCS		=	33579136
MASK_CURRENT			=	16515072
MASK_SHOT_PORTAL		=	33570820
MASK_SHOT_HULL			=	100679691
MASK_SOLID_BRUSHONLY		=	16395
MASK_WATER			=	16432

MAPS = {}
MAPS.List = {
"sa_castlewar",
"sa_arabia_2",
"sa_orbit",
"sa_bridges",
"sa_olympia",
"sa_surf_remnants",
"sa_spoonage",
"sa_tropical",
"sa_losttemple",
"sa_castlebase",
"sa_valley",
}

for _, map in pairs( MAPS.List ) do resource.AddFile("maps/"..map..".bsp") end

function MAPS.GetNextMap()
	local PLAYERS = #player.GetAll()
	local CURRENTMAP = game.GetMap()
	local NEXTMAP = MAPS.List[1]
	local num = 0
	for i=1, #MAPS.List do
		if CURRENTMAP == MAPS.List[i] then
			NEXTMAP = MAPS.List[i+1]
			num = i+1
			if num > #MAPS.List then
				NEXTMAP = MAPS.List[1]
				num = 1
			end
			break
		end
	end
	return NEXTMAP
end

CivModels = {
"models/Humans/Group/Male_02.mdl",
"models/Humans/Group/male_04.mdl",
"models/Humans/Group/male_06.mdl",
"models/Humans/Group/Male_08.mdl"--,
--"models/Humans/Group/Female_02.mdl",
--"models/Humans/Group/Female_04.mdl",
--"models/Humans/Group/Female_07.mdl"
}

MalePainSoundsLight = {
Sound("vo/npc/male01/ow01.wav"),
Sound("vo/npc/male01/ow02.wav"),
Sound("vo/npc/male01/pain01.wav"),
Sound("vo/npc/male01/pain02.wav"),
Sound("vo/npc/male01/pain03.wav")
}

MalePainSoundsMed = {
Sound("vo/npc/male01/pain04.wav"),
Sound("vo/npc/male01/pain05.wav"),
Sound("vo/npc/male01/pain06.wav")
}

MalePainSoundsHeavy = {
Sound("vo/npc/male01/pain07.wav"),
Sound("vo/npc/male01/pain08.wav"),
Sound("vo/npc/male01/pain09.wav")
}

MaleDeathSounds = {
Sound("vo/npc/male01/no02.wav"),
Sound("vo/npc/Barney/ba_ohshit03.wav"),
Sound("vo/npc/Barney/ba_ohshit03.wav"),
Sound("vo/npc/Barney/ba_no01.wav"),
Sound("vo/npc/Barney/ba_no02.wav")
}

FemalePainSoundsLight = {
Sound("vo/npc/female01/pain01.wav"),
Sound("vo/npc/female01/pain02.wav"),
Sound("vo/npc/female01/pain03.wav")
}

FemalePainSoundsMed = {
Sound("vo/npc/female01/pain04.wav"),
Sound("vo/npc/female01/pain05.wav"),
Sound("vo/npc/female01/pain06.wav")
}

FemalePainSoundsHeavy = {
Sound("vo/npc/female01/pain07.wav"),
Sound("vo/npc/female01/pain08.wav"),
Sound("vo/npc/female01/pain09.wav")
}

FemaleDeathSounds = {
Sound("vo/npc/female01/no01.wav"),
Sound("vo/npc/female01/ow01.wav"),
Sound("vo/npc/female01/ow02.wav")
}

BUILDINGS = {}
BUILDINGS[1] = {
	name = "City",
	model = "models/jaanus/townhall.mdl",
	needSupply = false,
	health = 60,
	iron = 40,
	food = 40,
	gold = 32,
	angOff = Angle( 0, 0, 0 ),
	OBBMins = { x = -15.010999679565, y = -17.648258209229, z = -0.75334024429321 },
	OBBMaxs = { x = 16.55788230896, y = 17.648250579834, z = 49.51237487793 }
}
BUILDINGS[2] = {
	name = "Wall",
	model = "models/jaanus/tower.mdl",
	health = 100,
	iron = 1,
	food = .75,
	gold = .2,
	upright = true,
	angOff = Angle( 0, 0, 0 ),
	OBBMins = { x = -2.5, y = -2.5, z = 0 },
	OBBMaxs = { x = 2.5, y = 2.5, z = 8 },
	needSupply = true
}
BUILDINGS[3] = {
	name = "Gate",
	model = "models/jaanus/gate.mdl",
	health = 80,
	iron = 8,
	food = 1,
	gold = 5,
	angOff = Angle( 0, 0, 0 ),
	OBBMins = { x = -2.5, y = -2.5, z = 0 },
	OBBMaxs = { x = 2.5, y = 2.5, z = 8 },
	needSupply = true
}
BUILDINGS[4] = {
	name = "Tower",
	model = "models/jaanus/archertower_01.mdl",
	health = 20,
	iron = 9,
	food = 6,
	gold = 2,
	angOff = Angle( 0, 0, 0 ),
	OBBMins = { x = -10.70262336731, y = -7.5293755531311, z = -1.3580000400543 },
	OBBMaxs = { x = 3.9701254367828, y = 7.1432495117188, z = 35.826000213623 },
	needSupply = true
}
BUILDINGS[5] = {
	name = "ShieldMono",
	model = "models/jaanus/shieldmonolith.mdl",
	health = 30,
	iron = 25,
	food = 15,
	gold = 10,
	angOff = Angle( 0, 0, 0 ),
	OBBMins = { x = -10.70262336731, y = -7.5293755531311, z = -1.3580000400543 },
	OBBMaxs = { x = 3.9701254367828, y = 7.1432495117188, z = 35.826000213623 },
	needSupply = true
}
BUILDINGS[6] = {
	name = "Workshop",
	model = "models/jaanus/workshop_down.mdl",
	health = 90,
	iron = 80,
	food = 90,
	gold = 25,
	angOff = Angle( 0, 0, 0 ),
	OBBMins = { x = -8.2447509765625, y = -8.3442497253418, z = -0.6481841802597 },
	OBBMaxs = { x = 29.278125762939, y = 13.155378341675, z = 20.040674209595 },
	needSupply = true
}
BUILDINGS[7] = {
	name = "Horsie",
	model = "models/jaanus/horsie.mdl",
	supply = 12,
	health = 120,
	iron = 60,
	food = 120,
	gold = 60,
	angOff = Angle( 0, 0, 0 ),
	OBBMins = { x = -8.2447509765625, y = -8.3442497253418, z = -0.6481841802597 },
	OBBMaxs = { x = 29.278125762939, y = 13.155378341675, z = 20.040674209595 },
	needSupply = true
}
BUILDINGS[8] = {
	name = "Shrine",
	model = "models/jaanus/altar.mdl",
	health = 50,
	iron = 100,
	food = 100,
	gold = 25,
	angOff = Angle( 0, 0, 0 ),
	OBBMins = { x = -11.983499526978, y = -9.1932506561279, z = -0.9077499389648 },
	OBBMaxs = { x = 11.712874412537, y = 9.1932506561279, z = 7.5205001831055 },
	needSupply = true
}

UNITS = UNITS or {}
UNITS[0] = {
	name = "Peasant",
	model = "models/jaanus/peasant.mdl",
	supply = 0,
	health = 10,
	damage = 1,
	range = 6,
	minRange = 0,
	turning = 100,
	speed = 2.5,
	delay = 1,
	size = 3,
	OBBMins = { x = -1, y = -1, z = -1 },
	OBBMaxs = { x = 1, y = 1, z = 4 }
}
UNITS[1] = {
	name = "Swordsman",
	model = "models/jaanus/swordsman.mdl",
	iron = 8,
	food = 10,
	gold = 0,
	supply = 1,
	health = 15,
	damage = 1.5,
	range = 6.5,
	minRange = 0,
	turning = 100,
	speed = 2,
	delay = 1.2,
	size = 3,
	OBBMins = { x = -1, y = -1, z = -1 },
	OBBMaxs = { x = 1, y = 1, z = 4 }
}
UNITS[2] = {
	name = "Archer",
	model = "models/jaanus/crossbowman.mdl",
	iron = 11,
	food = 9,
	gold = 0,
	supply = 1,
	health = 9,
	damage = 2.8,
	range = 42,
	minRange = 0,
	turning = 100,
	speed = 1.7,
	delay = 3,
	size = 3,
	OBBMins = { x = -1, y = -1, z = -1 },     
	OBBMaxs = { x = 1, y = 1, z = 4 }
}
UNITS[3] = {
	name = "ScallyWag",
	model = "models/jaanus/scallywag_unbroken.mdl",
	iron = 17,
	food = 22,
	gold = 1,
	supply = 2,
	health = 16,
	damage = 2.4,
	range = 40,
	minRange = 2,
	turning = 20,
	speed = 1.8,
	delay = 2.5,
	upright = true,
	size = 16,
	OBBMins = { x = -20, y = -20, z = -1 },
	OBBMaxs = { x = 20, y = 20, z = 8 }
}
/*
UNITS[4] = {
	name = "Galleon",
	model = "models/jaanus/galleon_intact.mdl",
	waterbase = true,
	iron = 10,
	food = 15,
	gold = 1,
	supply = 3,
	health = 60,
	damage = 8,
	range = 80,
	minRange = 1.5,
	turning = 10,
	speed = 20,
	delay = 2.5,
	notex = true,
	size = 18,
	OBBMins = { x = -17, y = -17, z = 0 },
	OBBMaxs = { x = 17, y = 17, z = 8 }
}
*/
UNITS[4] = {
	name = "Catapult",
	model = "models/jaanus/catapult.mdl",
	iron = 38,
	food = 30,
	gold = 5,
	supply = 2,
	health = 35,
	damage = -1, --Projectile does the damage
	range = 40,
	minRange = 35,
	turning = 30,
	speed = 1.5,
	delay = 6,
	size = 13,
	OBBMins = { x = -12, y = -12, z = -1 },
	OBBMaxs = { x = 12, y = 12, z = 8 }
}
UNITS[5] = {
	name = "Ballista",
	model = "models/jaanus/ballista.mdl",
	iron = 30,
	food = 25,
	gold = 5,
	supply = 2,
	health = 30,
	damage = -1, --Projectile does the damage
	range = 40,
	minRange = 40,
	turning = 30,
	speed = 1.6,
	delay = 3,
	size = 13,
	OBBMins = { x = -12, y = -12, z = -1 },
	OBBMaxs = { x = 12, y = 12, z = 8 }
}
UNITS[7] = {
	name = "Horsie",
	model = "models/jaanus/horsie.mdl",
	supply = 10,
	health = 80,
	damage = -1, --Can't Attack
	turning = 10,
	speed = 1.9,
	delay = 6,
	size = 13,
	OBBMins = { x = -12, y = -12, z = 0 },
	OBBMaxs = { x = 12, y = 12, z = 8 }
}

Gibs_Wood = {
"models/gibs/furniture_gibs/FurnitureTable002a_Chunk03.mdl",
"models/gibs/wood_gib01a.mdl",
"models/gibs/wood_gib01b.mdl",
"models/gibs/wood_gib01c.mdl",
"models/gibs/wood_gib01d.mdl",
"models/gibs/wood_gib01e.mdl"
}
Gibs_Stone = {
"models/props_combine/breenbust_chunk05.mdl",
"models/props_combine/breenbust_chunk06.mdl",
"models/props_combine/breenbust_chunk07.mdl",
"models/jaanus/muchsmallerbrick.mdl",
"models/jaanus/muchsmallerbrick.mdl",
"models/jaanus/muchsmallerbrick.mdl",
"models/jaanus/muchsmallerbrick.mdl"
}

for k, v in pairs(Gibs_Wood) do
	util.PrecacheModel(v)
end
for k, v in pairs(Gibs_Stone) do
	util.PrecacheModel(v)
end

GIB_STONE = 1001
GIB_ALL = 1002
GIB_WOOD = 1003

SPELLSOUNDS = {
	{"sassilization/spells/gravitateCast.wav", 1},
	{"sassilization/spells/bombardCast.wav", 1},
	{"sassilization/spells/healCast.wav", 1},
	{"sassilization/spells/decimationCast.wav", 1},
	{"sassilization/spells/blastCast.wav", 1},
	{"sassilization/spells/paralysisCast.wav", 1},
	{"sassilization/spells/plummetCast.wav", 1},
	{"sassilization/spells/hydraCast.wav", 1},
	{"sassilization/spells/vortexCast.wav", 1},
	{"sassilization/spells/thunderStrikeCast.wav", 1},
	{"sassilization/spells/invisibilityCast.wav", 1},
	{"sassilization/spells/treasonCast.wav", 1},
	{"sassilization/spells/devastationCast.wav", 1},
	{"sassilization/spells/spawnCast.wav", 1},
	{"sassilization/spells/whirlwindCast.wav", 1},
	{"sassilization/spells/twisterCast.wav", 1}
}

for i=1, #SPELLSOUNDS do
	util.PrecacheSound(SPELLSOUNDS[i][1])
end

SPELLS = {}
SPELLS[1] = {
	name = "Gravitate",
	cost = 3,
	delay = 8,
	sound = SPELLSOUNDS[1][1]
}
SPELLS[2] = {
	name = "Bombard",
	cost = 6,
	delay = 12,
	sound = SPELLSOUNDS[2][1]
}
SPELLS[3] = {
	name = "Heal",
	cost = 2,
	delay = 4,
	sound = SPELLSOUNDS[3][1]
}
SPELLS[4] = {
	name = "Decimation",
	cost = 5,
	delay = 8,
	sound = SPELLSOUNDS[4][1]
}
SPELLS[5] = {
	name = "Blast",
	cost = 2,
	delay = 3,
	sound = SPELLSOUNDS[5][1]
}
SPELLS[6] = {
	name = "Paralysis",
	cost = 3,
	delay = 8,
	sound = SPELLSOUNDS[6][1]
}
SPELLS[7] = {
	name = "Plummet",
	cost = 10,
	delay = 25,
	sound = SPELLSOUNDS[7][1]
}

UNITMOVESOUNDS = {
	{"sassilization/units/Move1.wav", 1},
	{"sassilization/units/Move2.wav", 1.5},
	{"sassilization/units/Move3.wav", 2},
	{"sassilization/units/Move4.wav", .5},
	{"sassilization/units/Move5.wav", .5}
}
UNITSPAWNSOUNDS = {
	{"sassilization/units/Drop.wav", 1}
}
UNITATTACKSOUNDS = {
	"sassilization/units/building_hit01.wav",
	"sassilization/units/building_hit02.wav",
	"sassilization/units/building_hit03.wav",
	"sassilization/units/flesh_hit01.wav",
	"sassilization/units/flesh_hit02.wav",
	"sassilization/units/flesh_hit03.wav",
	"sassilization/units/arrowfire01.wav",
	"sassilization/units/arrowfire02.wav",
	"sassilization/units/ballista_fire01.wav",
	"sassilization/units/ballista_fire02.wav",
	"sassilization/units/fireCrossbow.wav",
	"sassilization/units/buildingbreak01.wav",
	"sassilization/units/buildingbreak02.wav",
	"sassilization/units/wallbreak01.wav",
	"sassilization/units/wallbreak02.wav"
}

MISCSOUNDS = {
	"sassilization/buildascend.wav",
	"sassilization/units/unitLost.wav",
	"sassilization/units/sacrificed.wav",
	"sassilization/templeComplete.wav",
	"sassilization/workshopComplete.wav",
	"sassilization/buildsound01.wav",
	"sassilization/buildsound02.wav",
	"sassilization/select.wav",
	"sassilization/warnmessage.wav",
	"sassilization/buildsound03.wav"
}

for i=1, #MISCSOUNDS do
	resource.AddFile("sound/"..MISCSOUNDS[i])
	util.PrecacheSound(MISCSOUNDS[i])
end
for i=1, #UNITSPAWNSOUNDS do
	resource.AddFile("sound/"..UNITSPAWNSOUNDS[i][1])
	util.PrecacheSound(UNITSPAWNSOUNDS[i][1])
end
for i=1, #SPELLSOUNDS do
	resource.AddFile("sound/"..SPELLSOUNDS[i][1])
end
for i=1, #UNITMOVESOUNDS do
	resource.AddFile("sound/"..UNITMOVESOUNDS[i][1])
	util.PrecacheSound(UNITMOVESOUNDS[i][1])
end
for i=1, #UNITATTACKSOUNDS do
	resource.AddFile("sound/"..UNITATTACKSOUNDS[i])
	util.PrecacheSound(UNITATTACKSOUNDS[i])
end
resource.AddFile( "sound/jetheme-01.mp3" )
util.PrecacheSound( "jetheme-01.mp3" )

for i=1, #BUILDINGS do
	util.PrecacheModel( BUILDINGS[i].model )
end

for i=1, #UNITS do
	util.PrecacheModel( UNITS[i].model )
end

ATTACKABLES = {"bldg_city","bldg_wall","bldg_tower","bldg_shrine","bldg_shieldmono","bldg_workshop","bldg_residence","bldg_horsie"}

FORMAT = {
	{"i", "I"},
	{"im", "I'm"},
	{"i'm", "I'm"},
	{"u", "you"}
}

function FormatString( text )
	text = string.Trim( text )
	local sep = string.Explode(" ", text)
	for _, word in pairs( sep ) do
		for k, v in pairs( FORMAT ) do
			if word == v[1] then
				sep[_] = v[2]
			end
		end
		if _ == 1 and #sep > 1 then
			if string.len(word) > 1 then
				sep[_] = string.upper( string.Left( word, 1 ) )..string.Right( word, string.len(word)-1 )
			else
				sep[_] = string.upper( word )
			end
		end
	end
	return string.Implode( " ", sep )
end

function rpairs( t )
	
	math.randomseed( os.time() )
	
	local keys = {}
	for k,_ in pairs( t ) do table.insert( keys, k ) end
	
	return function()
		if #keys == 0 then return nil end
		
		local i = math.random( 1, #keys )
		local k = keys[ i ]
		local v = t[ k ]
	
		table.remove( keys, i )
		return k, v
	end
	
end

texShop = {}

if CLIENT then
	surface.CreateFont("mangal", 48, 500, true, false, "heading01")
	surface.CreateFont("mangal", 24, 400, true, false, "heading02")
end

--Deathgrippe wrote these titles
Titles = {
{"Mighty", "Mighties"},
{"Dominator", "Dominators"},
{"Bloody", "Blood Bringers"},
{"Butcher", "Butchers"},
{"Conqueror", "Conquerors"},
{"Destroyer", "Destroyers"},
{"Undefeatable", "Undefeatables"},
{"Overlord", "Overlords"},
{"Ghoulmaker", "Ghoulmakers"},
{"Nightbringer", "Nightbringers"},
{"Deathbringer", "Deathbringers"},
{"Ultimate", "Unstoppables"},
{"Fearless", "Fearless Emperors"}
}

--Deathgrippe wrote these descriptions
Description = {
{"false gods who tried to take his rightful place as ruler of the world.", "false gods who tried to take their rightful place as rulers of the world."},
{"factions of the previous broken kingdom who failed to unite the land under one god.", "factions of the previous broken kingdom who tried to unite the land under one god."},
{"heretic kingdoms that challenged his divine right to rule the world.", "heretic kingdoms that challenged their divine right as rulers of the world."},
{"false gods.", "false gods."},
{"pagan gods who attempted to unite the land under the one true god.", "pagan gods who attempted to unite the land under the one true god."},
{"godless kingdoms that dared to deny his divinity.", "godless kingdoms that dared to deny their divinity."},
{"savage gods that attempted to destroy the last refuge of civilization.", "savage gods that attempted to destroy the last refuge of civilization."}
}