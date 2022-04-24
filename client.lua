local spawnedPeds = {}

function spawnPed(model, v, withTask)
	table.insert(spawnedPeds, {model=model, location=v, task=withTask, isSpawned=false, ped = nil})
	print(json.encode(spawnedPeds))
end

Citizen.CreateThread(function()
    DecorRegister("ScriptedPed", false)

	local range = 100.0
	local ped = PlayerPedId()
	while true do
		local coords = GetEntityCoords(ped)
		for k, v in pairs(spawnedPeds) do
			local diff = #(coords - vector3(v.location.x, v.location.y, v.location.z))
			if diff < range and not v.isSpawned then
				spawnedPeds[k].isSpawned = true
				spawnedPeds[k].ped = createNearbyPed(v.model, v.location, v.task)
			elseif v.isSpawned and diff > range then
				spawnedPeds[k].isSpawned = false
				destroyPed(spawnedPeds[k].ped)
				spawnedPeds[k].ped = nil
			end
		end
		Wait(500)
	end
end)

function createNearbyPed(model, v, withTask)
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

function destroyPed(id)
	if IsEntityAPed(id) then
		DeletePed(id)
	end
end
exports('spawnPed', spawnPed)
