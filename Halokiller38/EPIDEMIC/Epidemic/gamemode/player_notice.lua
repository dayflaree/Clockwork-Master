
local meta = FindMetaTable( "Player" );

function meta:NoticePlainWhiteEx( text )

	umsg.Start( "nPLAINWHITEEX", self );
		umsg.String( text );
	umsg.End();

end

function meta:NoticePlainWhite( text )

	umsg.Start( "nPLAINWHITE", self );
		umsg.String( text );
	umsg.End();

end

function meta:NoticeUsedItem( item )

	local text = "";
	
	if( string.find( item.Flags, "e" ) ) then
	
		text = "Ate " .. item.NicePhrase .. ".";
	
	elseif( string.find( item.Flags, "u" ) ) then
	
		text = "Used " .. item.NicePhrase .. ".";
	
	elseif( string.find( item.Flags, "d" ) ) then
	
		text = "Drank " .. item.NicePhrase .. ".";
	
	elseif( string.find( item.Flags, "s" ) ) then
	
		text = "Lit " .. item.NicePhrase .. ".";
	
	end

	umsg.Start( "nRECITEM", self );
		umsg.String( text );
	umsg.End();

end
