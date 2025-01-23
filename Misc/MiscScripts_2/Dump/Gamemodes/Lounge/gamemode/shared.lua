GM.Name 		= "Lounge"
GM.Author 		= "_Undefined"
GM.Email 		= "admin@ubs-clan.co.uk"
GM.Website 		= "http://ubs-clan.co.uk"
GM.TeamBased 	= false

DeriveGamemode("sandbox")

TEAM_RP = 1
TEAM_BUILD = 2
TEAM_DM = 3

team.SetUp(TEAM_RP, "Roleplayers", Color(0, 179, 255, 255))
team.SetUp(TEAM_BUILD, "Builders", Color(255, 119, 0, 255))
team.SetUp(TEAM_DM, "Deathmatchers", Color(0, 188, 31, 255))

function plural(int, word)
	if ent == 1 then return word else return word.."s" end
end
