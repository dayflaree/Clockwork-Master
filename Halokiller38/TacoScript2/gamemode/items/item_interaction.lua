function TS.CreateItemProp( item, pos, ang )

	if( not item or not TS.ItemsData[item] or not pos ) then
		return;
	end

	local ent = ents.Create( "ts2_item" );
	ent:AttachItem( item );
	ent:SetPos( pos );
	ent:SetAngles( ang or Angle( 0, 0, 0 ) );
	ent:Spawn();
	
	if( TS.ItemsData[item].Flags and ( string.find( TS.ItemsData[item].Flags, "c" ) or string.find( TS.ItemsData[item].Flags, "C" ) or ( string.find( TS.ItemsData[item].Flags, "W" ) ) ) ) then

		TS.ItemToContainer( ent.ItemData );
		
		if( ent.ItemData.FillContainer ) then
			ent.ItemData.FillContainer( ent.ItemData );
		end
		
	end
	
	if( ent.ItemData.PostProcess ) then
		ent.ItemData.PostProcess( ent.ItemData, ent );
	end
	
	return ent;

end