ESX = exports["es_extended"]:getSharedObject()

-- Check if ox_lib is available
local oxLibAvailable = GetResourceState('ox_lib') == 'started'


local zones = {}
local textUIShown = false

-- Classic marker system variables
local isNearBell = false
local isAtBell = false
local currentBell = nil

-- FRAMEWORK EVENTS
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local function setupMarker(coords)
	DrawMarker(
		Config.Marker.type,
		coords.x, coords.y, coords.z,
		0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
		Config.Marker.size.x, Config.Marker.size.y, Config.Marker.size.z,
		Config.Marker.color.r, Config.Marker.color.g, Config.Marker.color.b, Config.Marker.color.a,
		false, false, 2, false, false, false, false
	)
end

-- Initialize zones or markers on resource start
Citizen.CreateThread(function()
	if Config.UseOxLib and oxLibAvailable then
		-- Create ox_lib zones
		for k, v in pairs(Config.Bells) do
			zones[k] = lib.zones.box({
				coords = v.coords,
				size = v.size or vector3(2.0, 2.0, 2.0),
				rotation = v.rotation or 0.0,
				debug = v.debug or false,
				onEnter = function()
					if oxLibAvailable then
						lib.showTextUI(Config.BellInfobarOxLib)
						textUIShown = true
					end
				end,
				onExit = function()
					if oxLibAvailable and textUIShown then
						lib.hideTextUI()
						textUIShown = false
					end
				end,
				inside = function()
					setupMarker(v.coords)
					if IsControlJustReleased(0, 38) then -- E key
						TriggerServerEvent('myBell:bell', v.name, v.job)
					end
				end
			})
		end
	else
		-- Use classic marker system
		CreateThread(function()
			while true do
				local playerPos = GetEntityCoords(PlayerPedId())
				isNearBell = false
				isAtBell = false
				currentBell = nil

				for k, v in pairs(Config.Bells) do
					local dist = #(playerPos - v.coords)
					if dist <= 1.2 then
						isNearBell = true
						isAtBell = true
						currentBell = v
						break
					elseif dist <= 4.0 then
						isNearBell = true
						currentBell = v
					end
				end

				Wait(300)
			end
		end)

		-- Marker drawing and interaction thread
		CreateThread(function()
			while true do
				local sleep = 1000

				if isNearBell and currentBell then
					sleep = 0
					local coords = currentBell.coords
					DrawMarker(
						Config.Marker.type,
						coords.x, coords.y, coords.z,
						0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
						Config.Marker.size.x, Config.Marker.size.y, Config.Marker.size.z,
						Config.Marker.color.r, Config.Marker.color.g, Config.Marker.color.b, Config.Marker.color.a,
						false, false, 2, false, false, false, false
					)
				end

				if isAtBell and currentBell then
					sleep = 0
					showInfobar(Config.BellInfobar)
					if IsControlJustReleased(0, 38) then
						TriggerServerEvent('myBell:bell', currentBell.name, currentBell.job)
					end
				end

				Wait(sleep)
			end
		end)
	end
end)

RegisterNetEvent('myBell:bell_cl')
AddEventHandler('myBell:bell_cl', function(name, job)
	if ESX ~= nil and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == job then
		if Config.UseOxLibNotifications and oxLibAvailable then
			lib.notify({
				title = 'Bell',
				description = Config.BellMessageOxLib .. name,
				type = 'inform'
			})
		else
			ShowNotification(Config.BellMessage .. name)
		end
	end
end)

function ShowNotification(text)
	if Config.UseOxLibNotifications and oxLibAvailable then
		lib.notify({
			title = 'Bell',
			description = text,
			type = 'inform'
		})
	else
		SetNotificationTextEntry('STRING')
		AddTextComponentString(text)
		DrawNotification(false, true)
	end
end

function showInfobar(msg)
	BeginTextCommandDisplayHelp('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandDisplayHelp(0, false, true, -1)
end

-- Cleanup zones on resource stop
AddEventHandler('onResourceStop', function(resourceName)
	if GetCurrentResourceName() == resourceName then
		if Config.UseOxLib and oxLibAvailable then
			for k, zone in pairs(zones) do
				if zone then
					zone:remove()
				end
			end
			if textUIShown then
				lib.hideTextUI()
			end
		end
	end
end)
