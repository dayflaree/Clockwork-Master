function _R.Entity:InViewCone( angle )
	local o = self:GetPos() - LocalPlayer():EyePos()
	local a = LocalPlayer():GetAimVector():Dot( o ) / o:Length()
	return math.acos( a ) < angle
end