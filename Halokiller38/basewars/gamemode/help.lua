
HELP_CATEGORY_CHATCMD = 1;
HELP_CATEGORY_CONCMD = 2;
HELP_CATEGORY_ADMINTOGGLE = 3;
HELP_CATEGORY_ADMINCMD = 4;

HelpCategories = { }
HelpLabels = { }

function AddHelpCategory( id, name )
	Msg("makingacategory\n")
end

function ChangeHelpLabel( id, text )
	Msg("changelabel\n")
end

function AddHelpLabel( id, category, text, constant )
	Msg("addlabel ".. tostring(text) .." \n")
end

function NetworkHelpLabels( ply )
	Msg("spammingtheplayerwithfail\n")
end

function GenerateChatCommandHelp()
	Msg("buildingthespam\n")
end
