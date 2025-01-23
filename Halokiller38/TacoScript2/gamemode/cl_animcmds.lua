function msgSnapOutOfStance( msg )

	local ent = msg:ReadEntity();
	
	if( not ent or not ent:IsValid() ) then return; end

	ent.ForcedAnimationMode = false;
	ent.ForcedAnimation = nil;

end
usermessage.Hook( "SOOS", msgSnapOutOfStance );

function msgSnapIntoStance(msg)
	local ent = msg:ReadEntity()
	local anim = msg:ReadLong()
	
	ent.ForcedAnimationMode = true
	ent.ForcedAnimation = anim
end
usermessage.Hook("SITS", msgSnapIntoStance)