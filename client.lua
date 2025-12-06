ESX = exports["es_extended"]:getSharedObject()

local isNearBell = false
local isAtBell = false
local currentBell 

-- FRAMEWORK EVENTS
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
	while true do

		local playerPos = GetEntityCoords(PlayerPedId())

		isNearBell = false
		isAtBell = false

		for k, v in pairs(Config.Bells) do
			
			local distStorage = #(playerPos - v.vec3)
			if distStorage <= 1.2 then
				
				isNearBell = true
				isAtBell = true
				currentBell = v
			elseif distStorage <= 4.0 then
			
				isNearBell = true
				currentBell = v
			end
		end


		Citizen.Wait(300)
	end
end)

Citizen.CreateThread(function()
    while true do

		if isNearBell then
			if currentBell ~= nil then
				DrawMarker(0, currentBell.vec3[1], currentBell.vec3[2], currentBell.vec3[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0*0.2, 1.0*0.2, 0.25, Config.Marker.color.r, Config.Marker.color.g, Config.Marker.color.b, Config.Marker.color.a, false, false, 2, false, false, false, false)
			end
		end

		if isAtBell then
			showInfobar(Config.BellInfobar)
			if IsControlJustReleased(0, 38) then
				-- ring ring
				TriggerServerEvent('myBell:bell', currentBell.name, currentBell.job)
			end
		end

		Citizen.Wait(1)
    end
end)

RegisterNetEvent('myBell:bell_cl')
AddEventHandler('myBell:bell_cl', function(name, job)
	-- print('angekommen')
	if ESX ~= nil and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == job then
		ShowNotification(Config.BellMessage .. name)
	end

end)


function ShowNotification(text)
	SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
	DrawNotification(false, true)
end

function showInfobar(msg)

	CurrentActionMsg  = msg
	SetTextComponentFormat('STRING')
	AddTextComponentString(CurrentActionMsg)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)

end