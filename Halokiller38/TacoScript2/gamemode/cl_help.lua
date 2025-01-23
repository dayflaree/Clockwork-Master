if( TS2HelpPanel ) then
	
	TS2HelpPanel:Remove();

end

TS2HelpPanel = nil;

local CurPos = 0;

HelpSelectedLink = 1;

-- Formatting functions

local function SetHeader( text )
	
	local label = TS2HelpPanel.RightPane:AddLabel( text, "GiantChatFont", 10, CurPos, Color( 255, 255, 255, 255 ) );
	
	CurPos = CurPos + label:GetTall();

end

local function SetBody( text )

	text = FormatLine( text, "NewChatFont", 565 );
	
	local label = TS2HelpPanel.RightPane:AddLabel( text, "NewChatFont", 10, CurPos + 10, Color( 255, 255, 255, 255 ) );
	
	CurPos = CurPos + label:GetTall();
	
end

local function SetList( text )

	text = FormatLine( text, "NewChatFont", 535 );
	
	local dash = TS2HelpPanel.RightPane:AddLabel( "-", "NewChatFont", 20, CurPos + 10, Color( 255, 255, 255, 255 ) );
	
	local label = TS2HelpPanel.RightPane:AddLabel( text, "NewChatFont", 30, CurPos + 10, Color( 255, 255, 255, 255 ) );
	
	CurPos = CurPos + label:GetTall();
	
end

local function SetIndent( text )

	text = FormatLine( text, "NewChatFont", 525 );
	
	local label = TS2HelpPanel.RightPane:AddLabel( text, "NewChatFont", 50, CurPos + 15, Color( 255, 255, 255, 255 ) );
	
	CurPos = CurPos + label:GetTall() + 5;
	
end

local function SetBreak()

	CurPos = CurPos + 15;
	
end

-- Help functions

local function Introduction()

	SetHeader("Half-Life 2 - Introduction");
	
	SetBody("Welcome to the Orwellian nightmare that is the Half-Life universe. You are about to take on the role of an oppressed and downtrodden citizen in City 8 (formerly Tokyo, Japan), garbed in a standard issue uniform and semi-regularly fed bland, rationed gruel. You are sterile; a great, electrostatic field has made conception impossible. You spend your days working on an assembly line or in the recycling centers that keep life sustainable in the barren wasteland that earth has become outside of its municipal regions, and you spend every other waking moment being barraged by propaganda, searched, beaten, starved, and broken. The year is 2018, two years before the events of Half-Life 2, and fourteen years after the \"Portal Storms\", the dimensional rift that ripped its way through the planet and left millions of alien beings roaming its surface, and the vast migration of the earth's population into martial-ruled urban centers for protection from the dangerous beasts.");
	
	SetBreak();
	
	SetBody("It is also eight years after the arrival of the Universal Union, an intelligent alien race that transforms planets and species into tools of war, who took notice of Earth after the expansive amount of energy released by the Portal Storms. They came in impossibly large numbers, using cybernetic weapons forged from the vestigial forms of other races that fell to them, and enacted their regime after a war that lasted only seven hours. Dr. Wallace Breen, the former administrator of Black Mesa--the once secret scientific facility that beckoned in the Portal Storms with their experiments in teleportation--was the man to sign the future of humanity into the Union's hands, and, as such, was inaugurated unquestionable puppet dictator, the human face of oppression. You are insignificant, cattle to serve your new Gods, and you are dying.");
	
end

local function FAQs()

	SetHeader("Half-Life 2 - FAQs");
	
	SetBody("Why don't I have a Tool-Gun? How do I get one?");
	
	SetIndent("New players do not start with the Tool-Gun because it is easily abusable. It is necessary to have Tool-Trust before you are can use a Tool-Gun. To get Tool-Trust, you must get the recommendation of two to four administrators. One basic-admin equates two super-admins in term of Tool-Trust recommendations. You must post these recommendations on the forums before you are approved for Tool-Trust.");
	
	SetBreak();
	
	SetBody("I'm seeing errors. How do I get rid of them?");
	
	SetIndent("To get rid of errors and view the correct models, it is necessary to download the 'TnB Megapack' from our forums. This contains many resources required for this server.");
	
	SetBreak();
	
	SetBody("How do I unholster my weapon/fists?");
	
	SetIndent("The console command 'rp_toggleholster' is used to unholster weapons. Many players bind this to a key like so: 'bind x rp_toggleholster'.");
	
	SetBreak();
	
	SetBody("How do I become a Civil Protection officer?");
	
	SetIndent("Civil Protection applications are available on our forums when the Civil Protection Command sees it fit. When Civil Protection applications are open, they remain open for at least a week, giving plenty of time for applicants to fairly adjust their applications before they are reviewed. There are also many more positions your character may apply for on the forums. Many groups, however, are purely in character and do not use forums for admittance.");
	
	SetBreak();
	
	SetBody("What is a CID? How do I get one?");
	
	SetIndent("CID is short for Civil Identification. It is a number assigned to residents of Combine-ruled cities. To set your character's CID, type this into chat: '/cid #####'. Replace '#####' with a five-digit number.");
	
	SetBreak();
	
	SetBody("How do I get a special model?");
	
	SetIndent("Most custom player models are donated for. More information can be found in our 'Donations' page.");
	
end

local function Rules()

	SetHeader("Half-Life 2 - Rules");
	
	SetBody("1. Metagaming, or using OOC information IC, is not allowed.");
	
	SetBreak();
	
	SetBody("2. Deathmatching is forbidden. Your character must have a valid reason to kill someone.");
	
	SetBreak();
	
	SetBody("3. If your character dies, you must follow the New Life Rule, meaning you must forget anything that lead to your character's death.");
	
	SetBreak();
	
	SetBody("4. Flaming, or deliberately offending someone, is not tolerated in our community.");
	
	SetBreak();
	
	SetBody("5. Ignoring role play is punishable.");
	
	SetBreak();
	
	SetBody("6. Prop surfing is bannable.");
	
	SetBreak();
	
	SetBody("7. Abusing your phys gun/tool gun will result in their removal.");
	
	SetBreak();
	
	SetBody("8. All fights must be role played. Do not overuse the fist SWEP.");
	
	SetBreak();
	
	
end

local function Chatting()

	SetHeader("TacoScript 2 - Chatting");
	
	SetBody("TacoScript 2 has many chat commands for role playing and interacting with other players. Here are the basics of chatting with other players:");
	
	SetBreak();
	
	SetList("/y [text] - Yell to those around you.");
	SetList("/w [text] - Whisper to those close to you.");
	SetList("/me [text] - Your character will perform an action.");
	SetList("/it [text] - Narrate your surroundings.");
	SetList("/r [text] - Speak into the radio if you have one.");
	SetList("[[ [text] - Speak in Local OOC.");
	SetList("// [text] - Speak in Global OOC.");
	SetList("!a [text] - Speak to admins.");
	
	SetBreak();
	
	SetBody("For a more extensive list, check the 'Commands' section.");
	
end

local function ChatCommands()

	SetHeader("TacoScript 2 - Chat Commands");
	
	SetList("/title [text] - Set your character's first description.");
	SetList("/title2 [text] - Set your character's second description.");
	SetList("/cid [number] - Set your character's Civil ID.");
	SetList("/sd [text] - Set a prop's description.");
	SetList("/givemoney [amt] - Give the player you're looking at Tokens.");
	SetList("/giveweapon - Give the player you're looking at the weapon you're holding.");
	SetList("/dropweapon - Drop the weapon you're holding.");
	SetList("/r, /ry, /rw [text] - Speak into your radio.");
	SetList("/buy, /sell - Buy or sell a door.");
	SetList("/lock, /unlock - Lock or unlock a door.");
	SetList("/cp, /ow, /ca - Flag up as Civil Protection, OverWatch, or Civil Administration. You must have the correct Combine flags to do this.");
	SetList("/vort - Flag up as a Vortigaunt. You need the correct Player flags to do this.");
	SetList("/search - Search the player you're looking at.");
	SetList("/cr, /crw [text] - Talk or whisper into Civil Request device.");
	SetList("/ev [text] - Create an event.");
	SetList("/rdis [text] - Have Dispatch say something over radio.");
	SetList("/write - Write on paper (if you have paper).");
	SetList("/adv - Advertise something. Costs 15 tokens.");
	SetList("/getup -  Get up from being unconscious.");
	SetList("/pm [part of player name] [message] - PM a player.");
	SetList("/lean - Lean against a wall.");
	SetList("/sitground - Sit on the ground.");
	SetList("/sit - Sit on a chair.");
	SetList("/stand - Stand from sitting/leaning.");
	
end

local function ConsoleCommands()

	SetHeader("TacoScript 2 - Console Commands");
	
	SetList("rp_toggleholster - Holster or unholster your weapon or fists.");
	SetList("rp_changename [name] - Change your character's name.");
	SetList("rp_userlist - Display all connected players.");
	SetList("rp_deletesave [name] - Delete a character of yours.");
	SetList("rp_make [item] - For Civil Protection. Spawns 'ration', 'crdevice', 'bandage', or 'medkit'.");
	SetList("rp_setcombineflag [player] [flag] - Requires 'E' Combine flag. Change another player's Combine flags.");
	SetList("rp_citizens - For CP. List all citizens and their CIDs.");
	SetList("rp_dispatch [line] - For CP. Play a dispatch line to the server. Leave 'line' blank for a list of dispatch lines.");
	SetList("rp_cl_logging [0/1] - Enable/disable clientside logging. Logs are saved as both 'All', which includes all information, and 'IC', which logs only role play. (Default 0)");
	SetList("rp_cl_logging_per_char [0/1] - Enable/disable whether logs are saved as individual characters' names. (Default 0)");
	SetList("rp_cl_logging_per_date [0/1] - Enable/disable whether logs are saved as the date. (Default 1)");
	SetList("rp_cl_logging_per_date_format \"[date format]\" - Enable/disable whether logs are saved as the date. Y is year, m is month, d is day. For example, \"Y-m-d\" would save your logs as 2010-01-01. Do not use periods in your date format. (Default Y-m-d)");
	SetList("rp_cl_sadcolors [0/1] - Enable the color mod which induces a gloomy atmosphere.");
	SetList("rp_cl_ts1hud [0/1] - Sets the HUD similar to TS1's.");
	
	SetBreak();
	
	SetBody("Additionally, you can press F4 on certain objects (players and doors) to open the Action Menu. Pressing E on certain objects (containers and items) will also bring up an Action Menu.");
	
end

local function Stats()

	SetHeader("TacoScript 2 - Stats");
	
	SetList("Strength - Strength is based on how strong you are, and how hard you can hit others. A higher strength will give you the better ability to knock out and injure other players more easily and quicker. This can be raised by hitting other players with your fists and melee weapons.");
	SetList("Speed - This is a common stat in TS1 and TS2. Speed is determined how fast you can sprint. Having higher sprint will you give you the ability to run faster. Running around for long periods will raise this.");
	SetList("Endurance - Endurance is based on how long you can run for and how hard you take hits. The higher the stat is the less damage you will take and more time the spint bar will take to empty. Taking damage and hits from others will raise this.");
	SetList("Aim - This stat is based on how accurate and balanced you are with weaponry. The higher the stat is the more accurate your bullets will be. Firing your weapon at players, npcs and objects from long distances will raise this.");
	
	SetBreak();
	
	SetBody("Donating is a choice of option and is another way to raise your stats. Stat 'farming' is bannable; that is when you deliberatley try and raise your stats with no roleplay.");
	
end

local function Inventory()

	SetHeader("TacoScript 2 - Inventory");
	
	SetBody("TacoScript 2 uses a grid based inventory to store your character's items. These items are saved and loaded everytime you disconnect/select your character. The Inventory can be accessed in the Player Menu with the F3 key.");
	
	SetBreak();
	
	SetBody("To pick up an item, simply walk up to it, look at it, and press your action key (E by default). A menu will come up prompting which inventory to place it in. 'Pockets' is your default inventory.");
	
	SetBreak();
	
	SetBody("Once you pick up the item, it will appear in your inventory, simply click the item icon and some buttons will appear above it, as well as the item description in the middle box. These could be 'Use', 'Drop', 'Eat', etc. You can also drag an item by holding left click, and releasing the item into an empty slot.");
	
end

local function BlackMarket()

	SetHeader("TacoScript 2 - Black Market");
	
	SetBody("In TacoScript 2, there is a Black Market system only accessible by players with the Black Market player flags. It allows you to spawn contraband, such as food, drinks, and light weaponry (Lite Black Market) and weapons (Heavy Black Market). Black market is able to be acquired through donation, provided the donor uses it to create role play in the server.");
	
	SetBreak();
	
	SetBody("If you have the Black Market player flags, you will notice a 'Black Market' button in your player menu. Open this to view the items you can 'buy' from the Black Market.");
	
end

local function Information()

	SetHeader("TacoScript 2 - Information");
	
	SetBody("TacoScript 2 is a role-playing gamemode, its base and major coding done by the creator of TacoScript and the ex founder of TnB, Rick Darkaliono. TacoScript 2's initial creation was started during November, 2008 and was to be released for the HL2 RP servers by 2009. The script's purpose was to replace the old and worn out TacoScript(1). However, the script was cancelled half way through development, and was released to the public. The script was then finished for TRP from Rick's release. The first beta occured on the 18th of January, 2010.");
	
	SetBreak();
	
	SetBody("The script is still in development stage and is undergoing constant updates by TnB's development team. TacoScript 2 is coded from scratch, using the latest Garry's Mod Lua functions, a new inventory, new item and weapon handling, as well as overall better optimization than TacoScript 1. Script development continued in November, 2010. Since then TacoScript 2's Half-Life 2 idea has been brought back to life and done, bringing TacoScript 2 closer to its original purpose.");
	
end

local function Credits()

	SetHeader("TacoScript 2 - Credits");
	
	SetList("Rick Dark - Creating TacoScript 2.");
	SetList("Horsey - Development of TacoScript 2.");
	SetList("Storm_Ninja - Development of TacoScript 2.");
	SetList("milk - Development of TacoScript 2.");
	SetList("Zaubermuffin - Development of TacoScript 2.");
	SetList("Freze - Base door system, shotgun base.");
	
	SetBreak();
	
	SetList("Ixius - Initial idea of TS2.");
	SetList("Dave Brown - Keeping TnB alive and taking the challenge of being head admin.");
	SetList("Snood - Creating the Radio and Backpack model.");
	SetList("FritoMaster - For making the ziptie model.");
	
	SetBreak();
	
	SetList("Testers - Matqo, Rat, Midas22, Flaky, JoJo, Killzone and Deathstrike.");
	
end

local function Flags()

	SetHeader("Player Flags");
	
	SetList("X - Heavy black market");
	SetList("Y - Light black market");
	SetList("V - Vortigaunt");
	SetList("Vs - Vortigaunt slave");
	SetList("M - Cannot speak in Global OOC");
	SetList("m - Don't change playermodel upon flagging");
	SetList("S - Short");
	SetList("T - Tall");
	
	SetBreak();
	
	SetHeader("Combine Flags");
	
	SetList("A - City Administrator");
	SetList("D - DvL");
	SetList("C - Command");
	SetList("E - Able to change combine flags via rp_setcombineflag");
	SetList("G - Ground unit");
	SetList("I - Intel unit");
	SetList("N - Nomad unit - can use /ev");
	SetList("O - Overwatch");
	SetList("Oe - Overwatch Elite");
	SetList("Op - Prison Guard");
	SetList("R - Recruit");
	SetList("Rs - Squadded recruit");
	SetList("T - Trench unit");
	
end

local function BasicAdmin()

	SetHeader("Basic Admin Commands");
	
	SetList("rpa_kick [player] [reason] - Kick a player from the server. (!kick)");
	SetList("rpa_ban [player] [time] [reason] - Ban a player from the server. (!ban)");
	SetList("rpa_slay [player] - Kill a player. (!slay)");
	SetList("rpa_slap [player] - Slap a player. (!slap)");
	SetList("rpa_search [term] - Search through all player's OOC/IC names and titles.");
	SetList("rpa_getinfo [player] - Get information for a specific player.");
	SetList("rpa_bring [player] - Bring a player to you. (!bring)");
	SetList("rpa_goto [player] - Teleport to a player. (!goto)");
	SetList("rpa_mute [player] - Mute a player from using OOC.");
	SetList("rpa_unmute [player] - Allow a muted player to use OOC.");
	SetList("rpa_maketall [player] - Temporarily make a player tall.");
	SetList("rpa_makeshort [player] - Temporarily make a player short.");
	SetList("rpa_makenormal [player] - Return the player to their normal height.");
	SetList("rpa_unown - Unown a door.");
	SetList("rpa_unlock - Unlock a door.");
	SetList("rpa_findowner - Print the owner of the door.");
	SetList("rpa_getlua [player] - Print a list of the player's Lua files.");
	SetList("rpa_weaponlist - Print a list of all weapon files in the server.");
	SetList("rpa_itemlist - Print a list of all item files in the server.");
	SetList("rpa_youtube [YouTube ID] - Play a YouTube video's sound. Be sure to rpa_killyoutube when finished.");
	SetList("rpa_killyoutube - Kill the YouTube panel.");
	SetList("rpa_playmusic [sound] - Play a sound to all players.");
	SetList("rpa_stopsounds - Stop all sounds.");
	SetList("rpa_cloak - Become invisible. (!cloak)");
	SetList("rpa_oocdelay [delay] - Set OOC delay.");
	SetList("rpa_seeall - Show all players' location on your HUD.");
	SetList("rpa_addtt [player] - Give a player tool trust.");
	SetList("rpa_removett [player] - Remove a player's tool trust.");
	SetList("rpa_banphysgun [player] - Ban a player's phys gun.");
	SetList("rpa_unbanphysgun [player] - Unban a player's phys gun.");
	SetList("rpa_forcef1 [player] - Force a player to look at the help menu.");
	SetList("rpa_selectnpc - Select traced NPC.");
	SetList("rpa_movenpc - Move selected NPC(s) to traced location.");
	
end

local function SuperAdmin()

	SetHeader("Super Admin Commands");
	
	SetList("rpa_pban [player] - Permanently ban a player.");
	SetList("rpa_banid \"[Steam ID]\" [time] - Ban a Steam ID. Must include quotation marks.");
	SetList("rpa_explode [player] - Explode a player. (!explode)");
	SetList("rpa_setplayerflag [player] [flag] - Set a player's player flag.");
	SetList("rpa_setcombineflag [player] [flag] - Set a player's Combine flag.");
	SetList("rpa_psetplayermodel [player] [model] - Permanently change a player's model.");
	SetList("rpa_setplayermodel [player] [model] - Temporarily change a player's model.");
	SetList("rpa_setscale [player] [scale] - Set a player's scale. (1 is default height.)");
	SetList("rpa_givemaxstats [player] - Give a player max stats.");
	SetList("rpa_setmoney [player] [amount] - Set a player's money.");
	SetList("rpa_observe - Go into observe mode.");
	SetList("rpa_createitem [item] - Create an item.");
	SetList("rpa_restartmap - Restart the map.");
	SetList("rpa_changemap [map] - Change maps.");
	
end

-- Create it all

local TS2HelpOptions = 
{

	{ Name = "- Half-Life 2", Func = function() end },
	{ Name = "   * Introduction", Func = Introduction },
	{ Name = "   * Rules", Func = Rules },
	{ Name = "   * FAQs", Func = FAQs },
	{ Name = "- Features", Func = function() end },
	{ Name = "   * Chatting", Func = Chatting },
	{ Name = "   * Chat Commands", Func = ChatCommands },
	{ Name = "   * Console Commands", Func = ConsoleCommands },
	{ Name = "   * Stats", Func = Stats },
	{ Name = "   * Inventory", Func = Inventory },
	{ Name = "   * Black Market", Func = BlackMarket },
	{ Name = "- Information", Func = Information },
	{ Name = "- Credits", Func = Credits },
	{ Name = "- Flags", Func = Flags },
	{ Name = "- Admin", Func = function() end },
	{ Name = "   * Basic Admin", Func = BasicAdmin },
	{ Name = "   * Super Admin", Func = SuperAdmin },
	
}

function ShowHelp()

	if( not LocalPlayer():Alive() ) then return; end

	if( TS2HelpPanel and TS2HelpPanel:IsVisible() ) then
	
		TS2HelpPanel:Remove();
		HideMouse();
		return;
	
	end
	
	gui.EnableScreenClicker( true );

	TS2HelpPanel = CreateBPanel( "TacoScript 2 Help Menu", 140, 90, 795, 600 );
	TS2HelpPanel:SetBodyColor( Color( 50, 50, 50, 100 ) );
	
	TS2HelpPanel.LeftPane = CreateBPanel( nil, 5, 35, 200, 540 );
	TS2HelpPanel.LeftPane:SetParent( TS2HelpPanel );
	TS2HelpPanel.LeftPane:SetBodyColor( Color( 30, 30, 30, 240 ) );
	TS2HelpPanel.LeftPane.Links = {};
	
	local function CreateRightPane()
	
		if( TS2HelpPanel.RightPane ) then
			TS2HelpPanel.RightPane:Remove();
		end
	
		TS2HelpPanel.RightPane = CreateBPanel( nil, 210, 35, 580, 540 );
		TS2HelpPanel.RightPane:SetParent( TS2HelpPanel );
		TS2HelpPanel.RightPane:SetBodyColor( Color( 30, 30, 30, 240 ) );
		
	end
	
	for n = 1, #TS2HelpOptions do
	
		local SetLink = function()
		
			CreateRightPane();
			
			TS2HelpPanel.LeftPane.Links[HelpSelectedLink].NormalColor = Color( 255, 255, 255, 200 );
			TS2HelpPanel.LeftPane.Links[n].NormalColor = Color( 34, 182, 255, 255 );
			
			HelpSelectedLink = n;
			
			TS2HelpPanel.RightPane.PaintHook = nil;
			
			CurPos = 0;
			
			TS2HelpOptions[n].Func();
			
		end
		
		TS2HelpPanel.LeftPane.Links[n] = TS2HelpPanel.LeftPane:AddLink( TS2HelpOptions[n].Name, "NewChatFont", 3, 5 + ( n - 1 ) * 14, Color( 255, 255, 255, 200 ), SetLink );
		TS2HelpPanel.LeftPane.Links[n].HighlightColor = Color( 34, 182, 255, 255 );
		
	end
	
	-- Start off on 'Introduction'
	
	TS2HelpPanel.LeftPane.Links[2].Action();
	
	TS2HelpPanel.OnClose = function()
	
		HideMouse();
	
	end
	
	TS2HelpPanel.PaintHook = function()
	
		draw.DrawTextOutlined( "T", "GModToolName", 5, 5, Color( 255, 0, 0, 255 ), nil, nil, 2, Color( 0, 0, 0, 255 ) );
		draw.DrawTextOutlined( "aco", "GModToolName", 25, 5, Color( 255, 255, 255, 255 ), nil, nil, 2, Color( 0, 0, 0, 255 ) );
		draw.DrawTextOutlined( "S", "GModToolName", 95, 5, Color( 255, 0, 0, 255 ), nil, nil, 2, Color( 0, 0, 0, 255 ) );
		draw.DrawTextOutlined( "cript", "GModToolName", 120, 5, Color( 255, 255, 255, 255 ), nil, nil, 2, Color( 0, 0, 0, 255 ) );
		draw.DrawTextOutlined( "2", "GModToolName", 215, 5, Color( 255, 0, 0, 255 ), nil, nil, 2, Color( 0, 0, 0, 255 ) );
		
	end

end
usermessage.Hook( "SH", ShowHelp );
