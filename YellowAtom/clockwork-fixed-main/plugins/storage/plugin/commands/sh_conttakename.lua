local COMMAND = Clockwork.command:New("ContTakeName")

COMMAND.tip = "Take a container's name."
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "o"

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor()

	if IsValid(trace.Entity) then
		if Clockwork.entity:IsPhysicsEntity(trace.Entity) then
			local model = string.lower(trace.Entity:GetModel())
--			local name = table.concat(arguments, " ")

			if cwStorage.containerList[model] then
				if not trace.Entity.inventory then
					cwStorage.storage[trace.Entity] = trace.Entity
					trace.Entity.inventory = {}
				end

				trace.Entity:SetNWString("Name", "")
			else
				Clockwork.player:Notify(player, "This is not a valid container!")
			end
		else
			Clockwork.player:Notify(player, "This is not a valid container!")
		end
	else
		Clockwork.player:Notify(player, "This is not a valid container!")
	end
end

COMMAND:Register()
