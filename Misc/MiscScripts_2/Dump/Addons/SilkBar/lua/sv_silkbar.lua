if (CLIENT) then return end

Msg("==== Loading SilkBar (Server) ====\n")

function SB_Fling(entindex)
	Entity(entindex):GetPhysicsObject():SetVelocity(Vector(0, 0, 1000))
end
concommand.Add("SB_Fling", SB_Fling)

Msg("==== Finish Loading SilkBar (Server) ====\n")