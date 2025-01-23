function EndFancyGayIntro()

	TS.FancyGayIntro = false;
	TS.HorseyMapView = false;
	HideMouse();

end
usermessage.Hook( "EFGI", EndFancyGayIntro );

--Receive item data, cept for description
function RecItemData( msg )

	local name = msg:ReadString();
	local model = msg:ReadString();
	local price = msg:ReadString();
	local lookat = msg:ReadVector();
	local campos = msg:ReadVector();
	local fov = msg:ReadShort();
	local w = msg:ReadShort();
	local h = msg:ReadShort();
	local flags = msg:ReadString();
	
	local id = string.sub( name, 1, string.find( name, ":" ) - 1 );
	name = string.sub( name, string.find( name, ":" ) + 1 );
	
	TS.ItemsData[id] = { Name = name, Model = model, Desc = "", Price = price, LookAt = lookat, CamPos = campos, Fov = fov, Width = w, Height = h, Flags = flags };

end
usermessage.Hook( "RID", RecItemData );

function RecDescPiece( msg )

	local id = msg:ReadString();
	local desc = msg:ReadString();
	
	TS.ItemsData[id].Desc = TS.ItemsData[id].Desc .. desc;

end
usermessage.Hook( "RDP", RecDescPiece );

function RecItemHUDInfo( msg )

	local id = msg:ReadShort();
	local name = msg:ReadString();
	
	local ent = ents.GetByIndex( tonumber( id ) );
	
	--nil error fix
	if( not ent or not ent:IsValid() ) then return; end
	
	ent.ItemName = name;

end
usermessage.Hook( "RIHI", RecItemHUDInfo );

LetterContent = "";

if( WritingVGUI ) then

	if( WritingVGUI.Menu ) then 
		WritingVGUI.Menu:Remove();
		WritingVGUI.Menu = nil;
	end	

	WritingVGUI:Remove();

end

WritingVGUI = nil;
PreviewLetterOn = false;
LetterCache = "";
UnfLetterContent = "";
LetterContent = "";

function LetterWritingPrompt( msg )

	local content = msg:ReadString();
	
	LetterCache = LetterCache .. content;
	
	WritingVGUI = vgui.Create( "Panel" );
	
	if( ScrH() > 600 ) then
		WritingVGUI:SetPos( ScrW() / 2 - 300, 100 );
	else
		WritingVGUI:SetPos( ScrW() / 2 - 300, 0 );
	end
	
	WritingVGUI:SetSize( 600, 600 );
	
	WritingVGUI.Paint = function()
	
		draw.RoundedBox( 0, 0, 0, WritingVGUI:GetWide(), WritingVGUI:GetTall(), Color( 255, 255, 255, 200 ) );
		
	end
	
	local x, y = WritingVGUI:GetPos();
	
	WritingVGUI.TextEntry = vgui.Create( "DTextEntry", WritingVGUI );
	WritingVGUI.TextEntry:SetPos( x + 5, y + 5 );
	WritingVGUI.TextEntry:SetSize( 590, 590 );
	WritingVGUI.TextEntry:SetText( WritingVGUI.TextEntry:GetValue() .. LetterCache );
	WritingVGUI.TextEntry:SetMultiline( true );
	WritingVGUI.TextEntry:MakePopup();

	local function Finish()
	
		WritingVGUI:SetVisible( false ); 
		WritingVGUI.TextEntry:SetVisible( false );
		WritingVGUI.Menu:SetVisible( false );
		PreviewLetterOn = false;
	
		local parts = math.ceil( string.len( WritingVGUI.TextEntry:GetValue() ) / 200 );

		RunConsoleCommand( "eng_sl", "" );
		
		local delay = 0;
		
		for n = 1, parts do
		
			timer.Simple( delay, RunConsoleCommand, "eng_slp", string.gsub( string.sub( WritingVGUI.TextEntry:GetValue(), ( n - 1 ) * 200 + 1, n * 200 ), "\n", "@n" ) );
			delay = delay + .3;
			
		end
		
		timer.Simple( delay, RunConsoleCommand, "eng_el", "" );
	
	end

	local _, y = WritingVGUI:GetPos();

	WritingVGUI.Menu = CreateBPanel( "Menu", ScrW() / 2 + 300, y, 100, 110 );
	WritingVGUI.Menu:CanSeeTitle( false );
	WritingVGUI.Menu:AddButton( "Edit", 5, 5, function() WritingVGUI:SetVisible( true ); WritingVGUI.TextEntry:SetVisible( true ); PreviewLetterOn = false; end );
	WritingVGUI.Menu:AddButton( "Preview", 5, 30, function() WritingVGUI:SetVisible( false ); WritingVGUI.TextEntry:SetVisible( false ); PreviewLetterOn = true; gui.EnableScreenClicker( true ); LetterContent = FormatLine( WritingVGUI.TextEntry:GetValue(), "LetterFont", 580 ); end );
	WritingVGUI.Menu:AddButton( "Close", 5, 55, function() WritingVGUI:SetVisible( false ); WritingVGUI.TextEntry:SetVisible( false ); WritingVGUI.Menu:SetVisible( false ); PreviewLetterOn = false; HideMouse(); end );
	WritingVGUI.Menu:AddButton( "Finish", 5, 80, Finish );
	
end
usermessage.Hook( "LWP", LetterWritingPrompt );

function StartLetter( msg )

	UnfLetterContent = "";
	LetterContent = "";

end
usermessage.Hook( "SL", StartLetter );

if( LetterVGUI ) then
	
	if( LetterVGUI.Menu ) then
		LetterVGUI.Menu:Remove();
	end

	LetterVGUI:Remove();
	
end

LetterVGUI = nil;

function DisplayLetter( msg )
	
	if( LetterVGUI ) then
		LetterVGUI:Remove();
	end
	
	local y = 0;

	if( ScrH() > 600 ) then
		y = 100;
	end

	LetterVGUI = vgui.Create( "Panel" );
	LetterVGUI:SetPos( ScrW() / 2 - 300, y );
	LetterVGUI:SetSize( 600, 600 );
	LetterVGUI.Paint = function()
	
		draw.RoundedBox( 0, 0, 0, LetterVGUI:GetWide(), LetterVGUI:GetTall(), Color( 255, 255, 255, 200 ) );
		draw.DrawText( LetterContent, "LetterFont", 5, 5, Color( 0, 0, 0, 255 ) );
	
	end
	
	LetterVGUI.Menu = CreateBPanel( "Menu", ScrW() / 2 + 300, y, 100, 30 );
	LetterVGUI.Menu:CanSeeTitle( false );
	LetterVGUI.Menu:AddButton( "Close", 5, 5, function() LetterVGUI:SetVisible( false ); LetterVGUI.Menu:SetVisible( false ); HideMouse(); end );
	
	gui.EnableScreenClicker( true );
	
end
usermessage.Hook( "DL", DisplayLetter );

function SendLetterPiece( msg )

	UnfLetterContent = UnfLetterContent .. string.gsub( msg:ReadString(), "@n", "\n" );
	
	LetterContent = FormatLine( UnfLetterContent, "LetterFont", 580 );

end
usermessage.Hook( "SLP", SendLetterPiece );

ActionMenuOn = false;
ActionMenuTitle = "";
ActionMenuOptions = { }
ActionMenuPos = Vector( 0, 0, 0 );
ActionMenuLongest = 0;
ActionMenuChoice = 0;

function ActionMenu( msg )

	ActionMenuOn = true;
	ActionMenuLongest = 0;

	ActionMenuFade = 1;

	ActionMenuTitle = msg:ReadString();
	ActionMenuPos = msg:ReadVector();
	local n = msg:ReadShort();
	local options = { }
	
	for j = 1, n do
	
		table.insert( options, { Name = msg:ReadString(), Command = msg:ReadString(), ID = msg:ReadShort() } );
		
		surface.SetFont( "NewChatFont" );
		local w = surface.GetTextSize( options[j].Name );
		
		if( w > ActionMenuLongest ) then
			ActionMenuLongest = w;
		end
	
	end
	
	ActionMenuLongest = math.Clamp( ActionMenuLongest, 100, 9999 );
	
	if( ActionMenuLongest > 100 ) then
		ActionMenuLongest = ActionMenuLongest + 6;
	end
	
	ActionMenuOptions = options;
	
end
usermessage.Hook( "AM", ActionMenu );

ProcessBars = { }

function CreateCustomProcessBar( msg )

	local bar = { }
	
	local id = msg:ReadString();

	bar.Title = msg:ReadString();
	bar.Time = msg:ReadFloat();
	bar.StartTime = CurTime();
	bar.EndTime = CurTime() + bar.Time;
	bar.Color = Color( msg:ReadShort(), msg:ReadShort(), msg:ReadShort(), msg:ReadShort() );
	
	ProcessBars[id] = bar;

end
usermessage.Hook( "CCPB", CreateCustomProcessBar );

function CreateProcessBar( msg )

	local bar = { }
	
	local id = msg:ReadString();

	bar.Title = msg:ReadString();
	bar.Time = msg:ReadFloat();
	bar.StartTime = CurTime();
	bar.EndTime = CurTime() + bar.Time;
	bar.Color = Color( 70, 70, 200, 90 );
	
	ProcessBars[id] = bar;

end
usermessage.Hook( "CPB", CreateProcessBar );

function RemoveProcessBar( msg )

	local id = msg:ReadString();
	
	ProcessBars[id] = nil;

end
usermessage.Hook( "RPB", RemoveProcessBar );

function RemoveAllProcessBars( msg )

	for k, v in pairs( ProcessBars ) do
	
		if( v ~= "spawnload" ) then
	
			ProcessBars[k] = nil;
			
		end
	
	end

end
usermessage.Hook( "RAPB", RemoveAllProcessBars );

FadeStart = 0;
FadeEnd = 0;
FIFOAlpha = 0;
FIFOWait = 0;

--Use only for intro
function FadeInFadeOut( msg )

	FadeStart = CurTime();
	FadeWait = msg:ReadFloat();
	FadeEnd = FadeWait / 2 + CurTime();
	FIFOAlpha = 0;

end
usermessage.Hook( "FIFO", FadeInFadeOut );

AdminSeeAll = false;

function SeeAll()

	AdminSeeAll = !AdminSeeAll;

end
usermessage.Hook( "SeeAll", SeeAll );

function UpdatePlayerTitle( msg )

	local ply = msg:ReadEntity();
	local title = msg:ReadString();
	
	if( not ply or not ply:IsValid() ) then return; end

	ply.PlayerTitle = title;

end
usermessage.Hook( "UDPT", UpdatePlayerTitle );

function UpdatePlayerTitle2( msg )

	local ply = msg:ReadEntity();
	local title2 = msg:ReadString();
	
	if( not ply or not ply:IsValid() ) then return; end

	ply.PlayerTitle2 = title2;

end
usermessage.Hook( "UDPT2", UpdatePlayerTitle2 );

function HolsterPos()

	local weap = LocalPlayer():GetActiveWeapon();
	
	if( weap:IsValid() and weap and weap.Primary ) then

		weap.Primary.PositionMode = 3;
		weap.Primary.PositionMul = 1;
		
	end
	
end
usermessage.Hook( "HPOS", HolsterPos );

--Too lazy to convert old shit to events.  Using events from now on.
function event.HorseyMapViewOn()

	TS.HorseyMapView = true;

end

function event.HorseyMapViewOff()

	TS.HorseyMapView = false;

end

WaterBlur =
{

	LastUpdate = 0,
	Add = 0,
	Draw = 0,
	Delay = 0,
	MaxAdd = .07,
	MaxDraw = .39,
	MaxDelay = 0.03,

}

--water bottle effect
function event.WaterBlur()

	WaterBlur.Add = math.Clamp( WaterBlur.Add + 0.014, 0, WaterBlur.MaxAdd );
	WaterBlur.Draw = math.Clamp( WaterBlur.Draw + .078, 0, WaterBlur.MaxDraw );
	WaterBlur.Delay = math.Clamp( WaterBlur.Delay + .006, 0, WaterBlur.MaxDelay );
	WaterBlur.LastUpdate = CurTime();

end

AlcoholBlur =
{

	LastUpdate = 0,
	Add = 0,
	Draw = 0,
	Delay = 0,
	HeadBob = 0,
	HeadBobPitchMul = 1,
	HeadBobYawMul = 1,
	HeadBobCosine = 0,
	MaxHeadBob = 1,
	MaxAdd = .21,
	MaxDraw = 1,
	MaxDelay = 0.09,
	ShiftedPitchYaw = false,

}

function event.HAlcoholBlur()

	AlcoholBlur.Add = math.Clamp( AlcoholBlur.Add + AlcoholBlur.MaxAdd * .14, 0, AlcoholBlur.MaxAdd );
	AlcoholBlur.Draw = math.Clamp( AlcoholBlur.Draw + AlcoholBlur.MaxDraw * .14, 0, AlcoholBlur.MaxDraw );
	AlcoholBlur.Delay = math.Clamp( AlcoholBlur.Delay + AlcoholBlur.MaxDelay * .14, 0, AlcoholBlur.MaxDelay );
	AlcoholBlur.LastUpdate = CurTime();

end

function event.HangOver()

	AlcoholBlur.Add = math.Clamp( AlcoholBlur.MaxAdd * .5, 0, AlcoholBlur.MaxAdd );
	AlcoholBlur.Draw = math.Clamp( AlcoholBlur.MaxDraw * .5, 0, AlcoholBlur.MaxDraw );
	AlcoholBlur.Delay = math.Clamp( AlcoholBlur.MaxDelay * .5, 0, AlcoholBlur.MaxDelay );

end

function event.NoDrunk()

	AlcoholBlur.Add = 0;
	AlcoholBlur.Draw = 0;
	AlcoholBlur.Delay = 0;

end

---------------------------------------
-- MOTD CREATION 
---------------------------------------

MOTDText = "";

if( MOTD ) then
	
	if( MOTD.TitleBar ) then

		MOTD.TitleBar:Remove();
		MOTD.TitleBar = nil;
		
	end
	
	MOTD:Remove();
	MOTD = nil;
	
end

function CreateMOTD()

	if( MOTD ) then
		MOTD:Remove();
		MOTD = nil;
	end

	MOTD = CreateBPanel( "Read This", ScrW() / 2 - 250, math.Clamp( ScrH() * .1 + 40, 180, 9999 ), 500, 400 );
	MOTD:SetBodyColor( Color( 30, 30, 30, 180 ) );
	MOTD:CanClose( false );
	MOTD:CanDrag( false );
	
	FillMOTD();

	gui.EnableScreenClicker( true );

end
usermessage.Hook( "MOTD", CreateMOTD );

function FillMOTD()

	if( MOTD.Text ) then
		MOTD.Text:Remove();
	end

	MOTD.Text = MOTD:AddLabel( TS.MOTD, "NewChatFont", 5, 5, Color( 255, 255, 255, 255 ) );

	MOTD:EnableScrolling( true );
	
	local function CloseMOTD()
	
		RunConsoleCommand( "rp_closemotd", "" );
		
		timer.Simple( 2, function()
		
			TS.FancyGayIntro = false;
			TS.HorseyMapView = false;
			
		end );
		
		MOTD.TitleBar:Remove();
		MOTD:Remove();
	
		HideMouse();
	
	end
	
	if( MOTD.ExitButton ) then
		MOTD.ExitButton:Remove();
	end
	
	MOTD.ExitButton = MOTD:AddButton( "Continue", 5, 370, CloseMOTD );

end

function GetItemData( msg )

	local items = { }
	
	items.ID = msg:ReadString();
	items.Name = msg:ReadString();
	items.Desc = msg:ReadString();
	items.Model = msg:ReadString();
	items.Price = msg:ReadString();
	items.Width = msg:ReadShort();
	items.Height = msg:ReadShort();
	items.FOV = msg:ReadShort();
	items.CamPos = msg:ReadVector();
	items.LookAt = msg:ReadVector();
	
	table.insert( TS.SpawnableItems, items );

end
usermessage.Hook( "GID", GetItemData );

---------------------------------------
-- QUIZ SHIT
---------------------------------------

if( QuizFrame ) then

	if( QuizFrame.TitleBar ) then
	
		QuizFrame.TitleBar:Remove();
	
	end
	
	QuizFrame:Remove();

end

QuizFrame = nil;

function CreateQuiz()

	local QuizQuestions = {
	
		{ "Is this server Real Life or Half-Life 2 themed roleplay?" },
		{ "What does 'OOC' stand for?" },
		{ "What does 'IC' stand for?" },
		{ "Do you require a weapon to roleplay here?" },
		{ "Is building important for roleplaying?" },
		
	}

	gui.EnableScreenClicker( true );
	
	QuizFrame = CreateBPanel( "Newbie Quiz", ScrW() / 2 - 250, math.Clamp( ScrH() * .1 + 40, 180, 9999 ), 500, 290 );
	QuizFrame:SetBodyColor( Color( 30, 30, 30, 210 ) );
	QuizFrame:CanClose( false );
	QuizFrame:CanDrag( false );
	
	local QuestionX = 10;
	local QuestionY = 10;
	
	for k, v in pairs( QuizQuestions ) do
	
		QuizFrame:AddLabel( v[1], "NewChatFont", QuestionX, QuestionY, Color( 255, 255, 255, 255 ) );
	
		QuestionX = QuestionX + 0;

		if( QuestionX >= 10 ) then
	 
			QuestionY = QuestionY + 50;
			QuestionX = 10;
			
		end
	
	end
	
	------------------------------
	-- INCOMING SHITTY CODING
	------------------------------
	
	local ans1 = "";
	local ans2 = "";
	local ans3 = "";
	local ans4 = "";
	local ans5 = "";
	
	local AnswerChoice1 = vgui.Create( "DMultiChoice", QuizFrame );
	AnswerChoice1:SetPos( 10, 30 );
	AnswerChoice1:SetSize( 110, 20 );
	AnswerChoice1:AddChoice( "Real Life" );
	AnswerChoice1:AddChoice( "Half-Life 2" );
	
	AnswerChoice1.OnSelect = function( index, value, data )
		
		ans1 = data;
		
	end
	
	local AnswerChoice2 = vgui.Create( "DMultiChoice", QuizFrame );
	AnswerChoice2:SetPos( 10, 75 );
	AnswerChoice2:SetSize( 110, 20 );
	AnswerChoice2:AddChoice( "Out-Of-Character" );
	AnswerChoice2:AddChoice( "Out-Of-Context" );
	
	AnswerChoice2.OnSelect = function( index, value, data )
		
		ans2 = data;
		
	end
	
	local AnswerChoice3 = vgui.Create( "DMultiChoice", QuizFrame );
	AnswerChoice3:SetPos( 10, 130 );
	AnswerChoice3:SetSize( 110, 20 );
	AnswerChoice3:AddChoice( "In-Context" );
	AnswerChoice3:AddChoice( "In-Character" );
	
	AnswerChoice3.OnSelect = function( index, value, data )
		
		ans3 = data;
		
	end
	
	local AnswerChoice4 = vgui.Create( "DMultiChoice", QuizFrame );
	AnswerChoice4:SetPos( 10, 180 );
	AnswerChoice4:SetSize( 110, 20 );
	AnswerChoice4:AddChoice( "Yes" );
	AnswerChoice4:AddChoice( "No" );
	
	AnswerChoice4.OnSelect = function( index, value, data )
		
		ans4 = data;
		
	end
	
	local AnswerChoice5 = vgui.Create( "DMultiChoice", QuizFrame );
	AnswerChoice5:SetPos( 10, 230 );
	AnswerChoice5:SetSize( 110, 20 );
	AnswerChoice5:AddChoice( "Yes" );
	AnswerChoice5:AddChoice( "No" );
	
	AnswerChoice5.OnSelect = function( index, value, data )
		
		ans5 = data;
		
	end
	
	------------------------------
	-- END SHITTY CODING
	------------------------------
	
	local function CheckAns()
	
		if( ans1 == "" or ans2 == "" or ans3 == "" or ans4 == "" or ans5 == "" ) then
		
			CreateOkPanel( "Answers", "Please answer all of the questions!" );
			return;
			
		end
		
		RunConsoleCommand( "eng_checkquiz", ans1, ans2, ans3, ans4, ans5 );
	
	end
	
	QuizFrame:AddButton( "Check Answers", 10, 260, CheckAns );

end
usermessage.Hook( "CQ", CreateQuiz );

function msgRemoveQuiz()

	if( QuizFrame ) then

		if( QuizFrame.TitleBar ) then
	
			QuizFrame.TitleBar:Remove();
	
		end
	
		QuizFrame:Remove();
		QuizFrame = nil;

	end

end
usermessage.Hook( "RQ", msgRemoveQuiz );

function ccSAS()

	RunConsoleCommand( "stopsounds" );

end
usermessage.Hook( "StopAllSounds", ccSAS );

function msgGetDescriptedProp( msg )

	local prop = msg:ReadEntity();
	local desc = msg:ReadString();
	
	if( not prop or not prop:IsValid() ) then return; end

	prop.Desc = desc;

end
usermessage.Hook( "UPD", msgGetDescriptedProp );

function DrawFlash( msg )
	TS.FlashEffect = true
	TS.FlashStartTime = CurTime()
	timer.Simple(10, function() TS.FlashEffect = false; end)
end
usermessage.Hook( "DF", DrawFlash );

function UpdateDoor( msg )

	local ent = msg:ReadEntity();
	local property = msg:ReadString();
	local name = msg:ReadString();
	local owned = msg:ReadBool();
	local combine = msg:ReadBool();
	local nexus = msg:ReadBool();
	local price = msg:ReadLong();
	local desc = msg:ReadString();
		
	ent.PropertyName = property;
	ent.DoorName = name;
	ent.Owned = owned;
	ent.OwnedByCombine = combine;
	ent.NexusDoor = nexus;
	ent.DoorPrice = price;
	ent.DoorDesc = desc;

	-- Update target info if necessary
	if TargetInfo[ent] then
		TargetInfo[ent].Text = ''
		TargetInfo[ent].TextColor = Color( 200, 200, 200, 255 );
		if nexus then
			TargetInfo[ent].TextColor =  Color( 38, 107, 255, 255 );
		elseif not owned and not combine then
			TargetInfo[ent].TextColor = Color( 200, 40, 40, 255 );
		end
	end
end
usermessage.Hook( "UDD", UpdateDoor );

function msgViewLua( msg )

	local cmd = msg:ReadShort();
	local reciever = msg:ReadLong();

	local ServerFolder = file.FindInLua( "autorun/*.lua" );
	local ClientFolder = file.FindInLua( "autorun/client/*.lua" );
	
	RunConsoleCommand( cmd, reciever, "*****Displaying user's Lua folder*****" );
	
	for k, v in pairs( ServerFolder ) do
	
		RunConsoleCommand( cmd, reciever, v );
	
	end
	
	for k, v in pairs( ClientFolder ) do
	
		RunConsoleCommand( cmd, reciever, v );
	
	end

end
usermessage.Hook( "VLI", msgViewLua );

function msgGetPropCreator( msg )

	local ent = msg:ReadEntity();
	local cs = msg:ReadString();
	
	if( not ent or not ent:IsValid() ) then return; end
	
	ent.CS = cs;

end
usermessage.Hook( "UPCS", msgGetPropCreator );

function msgUpdateUnholsterStatus( msg )

	local bool = msg:ReadBool();
	local ent = msg:ReadEntity();
	
	if( not ent or not ent:IsValid() ) then return; end
	
	ent.Unholstered = bool;

end
usermessage.Hook( "UNS", msgUpdateUnholsterStatus );

function msgPlayYouTube( msg )

	local song = msg:ReadString();
	
	YouTube = vgui.Create( "HTML" );
	YouTube:SetPos( 0, 0 );
	YouTube:SetSize( 0, 0 );
	YouTube:OpenURL( "http://www.youtube.com/v/" .. song .. "&autoplay=1" );

end
usermessage.Hook( "PYT", msgPlayYouTube );

function msgKillYouTube( msg )

	if YouTube then

		YouTube:Remove();
		
	end

end
usermessage.Hook( "KYT", msgKillYouTube );

function msgUpdateCID( msg )

	CID = msg:ReadString();

end
usermessage.Hook( "UDPC", msgUpdateCID );

function msgUpdateMoney( msg )

	Tokens = msg:ReadFloat();

end
usermessage.Hook( "UDPM", msgUpdateMoney );

function msgSelectCPModel()

	if( MFrame ) then
	
		MFrame:Remove()
		MFrame = nil;
		
	end

	local IconModels =
	{
	
		"models/purvis/male_01_metrocop.mdl",
		"models/purvis/male_24_metrocop.mdl",
		"models/purvis/male_03_metrocop.mdl",
		"models/purvis/male_04_metrocop.mdl",
		"models/purvis/male_05_metrocop.mdl",
		"models/purvis/male_06_metrocop.mdl",
		"models/purvis/male_07_metrocop.mdl",
		"models/purvis/male_08_metrocop.mdl",
		"models/purvis/male_18_metrocop.mdl",
		"models/purvis/male_12_metrocop.mdl",
		"models/purvis/male_25_metrocop.mdl",
		"models/c08cop.mdl",
		"models/police_female_blondecp.mdl",
		"models/c08cop_female.mdl",
		"models/police_female_finalcop.mdl",
		
	};
	
	MFrame = CreateBPanel( "Civil Protection Model Changer", ScrW()/2-150, ScrH()/2-173, 300, 347 );
	local GryBck = vgui.Create( "DPanelList", MFrame );
	local NoticeLabel = vgui.Create( "DLabel", MFrame );
	
	MFrame:SetBodyColor( Color( 30, 30, 30, 170 ) );
	MFrame:CanClose( true );
	MFrame:CanDrag( true );
	MFrame:MakePopup();
	
	GryBck:SetPadding( 4 );
	GryBck:SetPos( 10, 30 );
	GryBck:SetSize( 278, 280 );
	GryBck:EnableHorizontal( true );
	
	for k, v in pairs( IconModels ) do
	
		local Icon = vgui.Create( "SpawnIcon", MFrame );
		
		Icon:SetModel( v );
		GryBck:AddItem( Icon );
		
		Icon.DoClick = function( Icon )

			surface.PlaySound( "ui/buttonclickrelease.wav" );
			RunConsoleCommand( "rp_setcpmodel", v );
			
			MFrame:Remove();
			MFrame = nil;
			
		end 
		
	end
	
	NoticeLabel:SetPos( 15, 328 );
	NoticeLabel:SetText( "Click an icon to change your model." );
	NoticeLabel:SizeToContents();

end
usermessage.Hook( "SCPM", msgSelectCPModel );

function msgSessionStart()
	WriteClientAllLog("Session opened. " .. os.date(LoggingDateFormat()))
	WriteClientICLog("Session opened. " .. os.date(LoggingDateFormat()))
end
usermessage.Hook("CLSS", msgSessionStart)

function msgSessionEnd()
	WriteClientAllLog("Session closed: " .. os.date(LoggingDateFormat()))
	WriteClientICLog("Session closed: " .. os.date(LoggingDateFormat()))
end
usermessage.Hook("CLSE", msgSessionEnd)

function msgCanAccessBlackmarket(msg)
	LocalPlayer().CanAccessBM = msg:ReadBool()
end
usermessage.Hook("CABM", msgCanAccessBlackmarket)

function msgPlayDispatchLine(msg)
	
	local line = msg:ReadString();
	
	RunConsoleCommand( "play", line );
	
end
usermessage.Hook("PDL", msgPlayDispatchLine);

local function msgPlayerScale(msg)
	
end
usermessage.Hook("PSC", msgPlayerScale)