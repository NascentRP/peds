Citizen.CreateThread(function()
    DecorRegister("ScriptedPed", false)
end)

function spawnPed(model, v, withTask)
	modelHash = GetHashKey(model)
	RequestModel(modelHash)
	while not HasModelLoaded(modelHash) do
		 Wait(1)
	end
	local created_ped = CreatePed(0, modelHash , v.x , v.y , v.z - 1,true)
	FreezeEntityPosition(created_ped, true)
	SetEntityHeading(created_ped,  v.w)
	SetEntityInvincible(created_ped, true)
	SetBlockingOfNonTemporaryEvents(created_ped, true)
	if withTask ~= nil then
		TaskStartScenarioInPlace(created_ped, withTask, 0, true)
	end
	DecorSetBool(created_ped, 'ScriptedPed', true)
	SetModelAsNoLongerNeeded(modelHash)
	return created_ped
end
exports('spawnPed', spawnPed)
