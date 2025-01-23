

DeriveGamemode( "Gear" );
DeriveGamemode( "sandbox" )

include( "BananaVGUI/panel.lua" );
include( "BananaVGUI/scrolling.lua" );

include( "cl_openingscreen.lua" ); --Fancy intro screen
include( "cl_charactercreate.lua" ); --Character creation code
include( "cl_hud.lua" ); --HUD code
include( "cl_vgui.lua" ); --Handles the look of the VGUI and other related things
include( "cl_lifeline.lua" ); --Handles Lifeline bar code
include( "cl_effects.lua" ); --Misc effects during gameplay
include( "precache.lua" ); --precache of models etc
include( "cl_helpmenu.lua" ); --Help menu
include( "cl_chat.lua" ); --Chatbox
include( "cl_notice.lua" ); --Notices on top-right
include( "cl_progressbar.lua" ); --Progress bar
include( "cl_actionmenu.lua" ); --Action menu
include( "cl_radio.lua" ); --Interaction with the radio item
include( "cl_inventoryactionmenu.lua" ); --Action menu for item interaction in inventory

include( "cl_playermenu.lua" ); --Handles player menu code (F3)
include( "cl_inventory.lua" ); --Clientside inventory code
include( "cl_contextmenu.lua" ); --Context menu
include( "cl_propadmin.lua" ); --Prop admin vgui stuff
include( "cl_ammomenu.lua" ); --Ammo menu
include( "cl_scoreboard.lua" ); --Scoreboard
include( "cl_scoreboardplinfo.lua" ); --Scoreboard player info

include( "player_sounds.lua" ); -- Infected sound tables

include( "cl_umsg.lua" ); --Handles all the usermessage functions.

include( "cl_dev.lua" ); --Dev tools
include( "cl_weapons.lua" ); --Interaction with weapons
include( "cl_introcamerapositions.lua" ); --Self explanatory. 
include( "cl_util.lua" ); --Misc clientside functions
include( "cl_hooks.lua" ); --Clientside gamemode hooks such as CalcView, etc..
include( "cl_items.lua" ); --Item related code
include( "player_variables.lua" ); --Player variables
include( "cl_vars.lua" ); --Clientside updating of variables

include( "shared.lua" ); --Shared code
include( "playergroups_shd.lua" ); --Shared character create code
include( "playermodels_shd.lua" );

PostClientsideLoad(); --Handle some misc stuff after the gamemode is loaded clientside.

HUDItemInfo = { } --This is a table containing a list of items and their visible names, because players are sent item names on the fly, this contains the ones that were already sent.
HUDPropDesc = { } --Prop descs

hook.Remove( "CalcView", "GearCalcView" ); --Remove this hook because Epidemic supplies its own CalcView.
hook.Remove( "Think", "GearThink" ); 

if( not LoopingAmbiencePlayed and LocalPlayer():IsValid() ) then

	 LocalPlayer():EmitSound( "ambient/wind/wasteland_wind.wav", 20 );

end

LoopingAmbiencePlayed = true;


