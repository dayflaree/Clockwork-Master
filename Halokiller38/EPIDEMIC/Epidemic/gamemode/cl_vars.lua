
function OnUpdatedPlayerHolstered( oldval, val )

	SetWeaponHolster( val );

end

function HackUpdatePlayerHolster( um )
	
	local b = um:ReadBool();
	SetWeaponHolster( b );
	
end
usermessage.Hook( "HackUpdatePlayerHolster", HackUpdatePlayerHolster );

function OnUpdatedPlayerConscious( oldval, val )

	ClientVars["Conscious"] = math.Clamp( math.floor( val ), 1, 100 );
	
end

function OnUpdatedPlayerPhysDesc( oldval, val )

	FormattedPhysDesc = FormatLine( val, "CharCreateEntry", ScrW() * .3 );

end
