ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('es_better_carwash:checkmoney')
AddEventHandler('es_better_carwash:checkmoney', function(price)
	local src = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if not costs then
        costs = 0
   	end
	
	if xPlayer.getMoney() >= 1 then
		xPlayer.removeMoney(costs)
		TriggerClientEvent('es_better_carwash:success', src)
	else
		TriggerClientEvent('es_better_carwash:notenoughmoney', src)
	end
end)
