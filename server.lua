ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('myBell:bell')
AddEventHandler('myBell:bell', function(name, job)
    -- print('try')
    TriggerClientEvent('myBell:bell_cl', -1, name, job)
end)
