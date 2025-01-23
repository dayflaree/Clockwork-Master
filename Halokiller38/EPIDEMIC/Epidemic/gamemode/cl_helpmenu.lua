
ChatCmdListing = 
{

	"// /a /ooc - Speak globally (otherwise known as out of character)",
	".// [[ - Speak in local-OOC",
	"/y /yell - Yell in character",
	"/w /whisper - Whisper in character",
	"/me <action> - Narrate your in character actions",
	"/r - Send a message through your radio",
	"/passout - Forcefully ragdoll yourself",
	"/getup - Get up from being passed out",
	
};

surface.CreateFont( "Type-Ra", 16, 400, true, false, "HelpList" );

HelpMenu =
{

	Panel = nil,

}

function event.ToggleHelpMenu()

	if( HelpMenu.Panel and HelpMenu.Panel:IsValid() ) then
	
		HelpMenu.Panel:Remove();
		HelpMenu.Panel = nil;
		HideMouse();
	
	else
	
		CreateHelpMenu();
		gui.EnableScreenClicker( true );
	
	end

end

function HelpMenu.DoInfo()

	HelpMenu.Panel.Content:AddLabel( "Epidemic is an RP gamemode developed by Rick Dark and Disseminate.\n\nhttp://exocannibal-rp.com", "NewChatFont", 5, 5, Color( 255, 255, 255, 255 ), true );

end

function HelpMenu.DoCredits()

	HelpMenu.Panel.Content:EnableScrolling( true );

	str = "Credits - \n\n";
	str = str .. "Rick Dark - Developing Epidemic (March 09 to January 2010).\n\n";
	str = str .. "Disseminate - Continuing Epidemic (February 2010).\n\n";
	str = str .. "Atee - Web development.\n\n";
	str = str .. "Fennec_Fox - Mapping.\n\n";
	str = str .. "Epsilon - Mapping.\n\n";
	
	str = str .. "Necropolis - for the good times.";
	
	HelpMenu.Panel.Content:AddLabel( str, "NewChatFont", 5, 5, Color( 255, 255, 255, 255 ), true );

end

function HelpMenu.DoFKeys()

	HelpMenu.Panel.Content:AddLabel( "These are the F- keys for Epidemic.\n\nF1 - Help menu (what you're looking at)\n\nF2 - Unused\n\nF3 - Player menu\n\nF4 - If you're staring at a player, you will 'recognize' that player.  If you are staring at an item, it will do a quick-pickup.", "NewChatFont", 5, 5, Color( 255, 255, 255, 255 ), true );
	
end


function HelpMenu.DoContext()

	HelpMenu.Panel.Content:AddLabel( "Epidemic has its own unique context menu that you can bring up when you have anything but the tool-gun out.\n\nTo get to the menu, simply press 'C' or whatever your context menu bind is and the menu will pop up in the center of your screen.  Select options with your mouse.  This menu allows you easier access to some commands like /passout, animation commands, etc..", "NewChatFont", 5, 5, Color( 255, 255, 255, 255 ), true );
	
end

function HelpMenu.DoRecognition()

	HelpMenu.Panel.Content:AddLabel( "Epidemic has a recognition system meaning you can only see a player's physical description and not their name until you 'recognize' them.  Recognizing a player is simply the process of pressing F4 while looking at them.  However, they have to recognize you back before you can see their name.", "NewChatFont", 5, 5, Color( 255, 255, 255, 255 ), true );
	
end

function HelpMenu.DoHealthDamage()

	HelpMenu.Panel.Content:AddLabel( "Epidemic has an intricate health system, featuring everything from your lifeline to your sprintbar, to your armor and limbhealth.\n\n- Your lifeline in the bottom left-hand corner is a measure of your health, how fast it goes is how fast your heart is beating, which has no effect on you.\n\n- The sprint bar next to the lifeline is an orange bar that shows you how much can you jog or sprint.  This will replenish very slowly.\n\n- Your consciousness bar indicates how conscious you are.  It is located behind the lifeline display as the black/gray bar.  The lower this is, the blurrier your vision will become, and the slower and delayed your movements will be.\n", "NewChatFont", 5, 5, Color( 255, 255, 255, 255 ), true );
	HelpMenu.Panel.Content:AddLabel( "- When you are being damaged or when you are bleeding, indicators will show up in the top left-hand corner of your view to specify your damage; these are self-explanatory.  As your arms get more damaged, so does your ability to handle weapons.  As your legs are damaged, your ability to run or sprint will be crippled.  If you are losing blood, you will eventually lose consciousness if you lose enough blood, and even health if it becomes too low.\n\n- In the bottom right-hand corner of your screen there will be a weapon HUD display, which will tell you how much ammo you currently have, the ammo type, and your weapon's health bar will be right above it. If the bar becomes low, there will be a higher chance of it jamming.", "NewChatFont", 5, nil, Color( 255, 255, 255, 255 ), true );
	
end

function HelpMenu.DoMiscKeys()

	HelpMenu.Panel.Content:AddLabel( "Jogging/Sprinting:  There's a difference between the two.  SHIFT + movement allows for jogging.  SHIFT + ALT + movement allows for sprinting, which is faster, but you waste more energy.\n\nHolster/unholster weapons: rp_toggleholster.  It's a good idea to bind this.\n\nConstant moving:  Movement + ALT.  Allows you constantly move in one direction so you can talk while moving or do something else.  Press ALT again to toggle it off.\n\n(NOTE!  When I refer to your ALT key, I mean whatever your 'Walk' bind is.)", "NewChatFont", 5, 5, Color( 255, 255, 255, 255 ), true );
	
end

function HelpMenu.DoHowUseRadio()

	HelpMenu.Panel.Content:AddLabel( "1)  You need the two-radio item.\n2)  Once you have the radio item, right click it in your inventory and set its frequency.\n3)  Once you have the frequency set, go to your chat's RADIO tab and click the frequency you want to use\n4)  Chat in your radio tab to radio chat, or use /r", "NewChatFont", 5, 5, Color( 255, 255, 255, 255 ), true );

end

function HelpMenu.DoWeaponMaintenance()

	HelpMenu.Panel.Content:AddLabel( "If you have a weapon that degrades out, there will be a green bar above the ammo count. This is how 'healthy' your weapon is; a green bar is 100% health. As you use the weapon, the bar goes down - the lower the bar, the higher chance that it will jam. After a certain point, the weapon becomes completely unusable.\n\nTo regain weapon health, you will need to use a Heavy Weapon Repair Kit or Light Weapon Repair kit, depending on what slot the weapon goes into. Drag and drop the repair kit from the inventory to the equipped weapon in the inventory.", "NewChatFont", 5, 5, Color( 255, 255, 255, 255 ), true );

end

HelpMenu.SideBarList =
{

	{ Str = "Info", Func = HelpMenu.DoInfo },
	{ Str = "Credits", Func = HelpMenu.DoCredits },
	{ Str = "The 'F' keys", Func = HelpMenu.DoFKeys },
	{ Str = "Context Menu", Func = HelpMenu.DoContext },
	{ Str = "Player Recognition", Func = HelpMenu.DoRecognition },
	{ Str = "Health and Damage", Func = HelpMenu.DoHealthDamage },
	{ Str = "Misc. Binds and Keys", Func = HelpMenu.DoMiscKeys },
	{ Str = "How to use radio", Func = HelpMenu.DoHowUseRadio },
	{ Str = "Weapon maintenance", Func = HelpMenu.DoWeaponMaintenance },

};

function HelpMenu.FillSideBar()

	for k, v in pairs( HelpMenu.SideBarList ) do
	
		local rd = function()
		
			HelpMenu.Panel.Content:Remove();
			HelpMenu.CreateContentPanel();
			v.Func();
			
		end
	
		HelpMenu.Panel.SideBar:AddLink( v.Str, "NewChatFont", 5, 5 + ( k - 1 ) * 16, Color( 200, 0, 0, 255 ), rd, Color( 255, 255, 255, 255 ) );	

	end

end

function HelpMenu.CreateContentPanel()

	HelpMenu.Panel.Content = CreateBPanel( nil, 170, 60, 415, 505 );
	HelpMenu.Panel.Content:SetParent( HelpMenu.Panel );	
	HelpMenu.Panel.Content.OutlineWidth = 1;	

end

function CreateHelpMenu()

	HelpMenu.Panel = CreateBPanel( "Help", ScrW() * .5 - 300, ScrH() * .5 - 300, 600, 600 );
	HelpMenu.Panel.SideBar = CreateBPanel( nil, 15, 60, 140, 505 );
	HelpMenu.Panel.SideBar:SetParent( HelpMenu.Panel );	
	HelpMenu.Panel.SideBar.OutlineWidth = 1;
	
	HelpMenu.CreateContentPanel();
	
	HelpMenu.Panel.PaintHook = function()
	
		draw.DrawText( "Epidemic.", "OpeningEpidemic", 10, 5, Color( 255, 255, 255, 255 ) );

	end
	
	HelpMenu.FillSideBar();
	
	HelpMenu.DoInfo();

end
