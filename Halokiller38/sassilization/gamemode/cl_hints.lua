
surface.CreateFont( "Verdana", 15, 600, true, false, "GModNotify" )

// A list of hints we've already done so we don't repeat ourselves`
ProcessedHints = {}



function UMSGSuppressHint( data )
	local hint = data:ReadString()
	GAMEMODE:SuppressHint( hint )
end
usermessage.Hook("SuppressHint", UMSGSuppressHint)

function UMSGAddHint( data )
	local hint = data:ReadString()
	local delay = data:ReadLong()
	GAMEMODE:AddHint( hint, delay )
end
usermessage.Hook("AddHint", UMSGAddHint)


local function ThrowHint( name )

	local show = LocalPlayer():GetNWInt("showhelp")
	if (show == 0) then return end

	local text = name

	if HintTranslation[ name ] then
		text = HintTranslation[ name ]
	end

	GAMEMODE:AddNotify( text, NOTIFY_HINT, 20 )

	surface.PlaySound( "ambient/water/drip"..math.random(1, 4)..".wav" )

end

function GM:AddHint( name, delay )

	if (ProcessedHints[ name ]) then return end

	timer.Create( "HintSystem_"..name, delay, 1, ThrowHint, name )
	ProcessedHints[ name ] = true
	
end

function GM:SuppressHint( name )

	timer.Destroy( "HintSystem_"..name )
	
end

// Show opening menu hint if they haven't opened the menu within 30 seconds
GM:AddHint( "OpenMenu", 30 )

// Tell them how to turn the hints off after 1 minute
GM:AddHint( "Annoy1", 60 )
GM:AddHint( "Annoy2", 61 )

GM:AddHint( "Tip1", 125 )
GM:AddHint( "Tip2", 126 )
GM:AddHint( "Tip3", 180 )

HintTranslation = {

	OpenMenu		=	"To open the build menu, hold the crouch key.",
	OpenMenu2		=	"Building units is done by holding the 'walk' key or 'alt'.",
	Annoy1			=	"You can turn off the hints in the scoreboard.",
	Annoy2			=	"Press and hold tab to view the scoreboard.",
	UnitSelect1		=	"Select units by holding Sprint+Primary Fire to drag a circle over them",
	UnitSelect2		=	"You can only select "..select_limit.." units at a time, use Sprint+Reload to deselect units",
	City1			=	"Cities will automatically grow and populate.",
	Tip1			=	"To win the round, be the first to get "..victory_limit.." gold.",
	Tip2			=	"1 gold is gained every 7 seconds for each city you have.",
	Tip3			= 	"Press F1 for detailed help. Similiarly, press F2 to open the store.",
	Upgrade			=	"Upgrade buildings by building the same one right next to it.",
	BuildTip1		=	"Hold 'Sprint' while building a wall and it won't make a connection.",
	Last			=	"."

}