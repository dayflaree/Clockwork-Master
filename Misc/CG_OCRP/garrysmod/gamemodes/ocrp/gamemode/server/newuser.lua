--Let's create the player a new RP account as they don't have one.
function NewRPUser( ply )
	tmysql.query("INSERT INTO `ocrp_users` (`nick`, `org_id`, `org_rank`, `STEAM_ID`) VALUES('".. tmysql.escape(ply:Nick()) .."', '0', '0', '".. ply:SteamID() .."')")
	ply:SetOrg(0)
	ply:SetMoney(WALLET, 500)
	ply:SetMoney(BANK, 4500)
	ply.Loaded = true
	--[[local DMONEY = OCRPCfg["MoneyStart"]
	Msg( "OCRP: Creating ".. ply:Nick() .." a account.\n" )
	MySQLQuery(Site, "INSERT INTO `ocrp_users` (`nick`, `wallet`, `bank`, `bl_police`, `bl_medic`, `STEAM_ID`) VALUES('".. ply:Nick() .."', '250', '".. DMONEY .."', 'false', 'false', '".. ply:SteamID() .."')" )
	Msg( "OCRP: Created a account for ".. ply:Nick() ..".\n" )
	--Set defaults
	ply:SetMoney(BANK, DMONEY )
	ply:SetMoney(WALLET, 250)]]--
end

