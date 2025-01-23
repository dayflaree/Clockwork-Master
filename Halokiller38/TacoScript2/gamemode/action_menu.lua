
ActiveActionMenuTitle = "";
ActiveActionMenuTarget = nil;
ActiveActionMenuPos = Vector( 0, 0, 0 );
ActiveActionMenuOptions = { }

function CreateActionMenu( title, ply, pos )
	
	ActiveActionMenuTitle = title;
	ActiveActionMenuTarget = ply;
	ActiveActionMenuPos = pos;
	ActiveActionMenuOptions = { }
	
end

function SetActionMenuEntity( ent )

	ActiveActionMenuTarget.ActionMenuTarget = ent;

end

function AddActionOption( name, cmd, id )

	table.insert( ActiveActionMenuOptions, { Name = name, Command = cmd, ID = id } );

end

function EndActionMenu()

	umsg.Start( "AM", ActiveActionMenuTarget );
		umsg.String( ActiveActionMenuTitle );
		umsg.Vector( ActiveActionMenuPos );
		umsg.Short( #ActiveActionMenuOptions );
		for n = 1, #ActiveActionMenuOptions do
			umsg.String( ActiveActionMenuOptions[n].Name );
			umsg.String( ActiveActionMenuOptions[n].Command );
			umsg.Short( ActiveActionMenuOptions[n].ID );
		end
	umsg.End();

end