for i = 0, ragdoll:GetPhysicsObjectCount() -1 do
	local bone = target:GetPhysicsObjectNum(i)
	if physBone:IsValid() then
		//Do stuff here
	end
end