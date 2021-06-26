ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('bagniak', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent('coskurwa:gwalt', source)
	xPlayer.removeInventoryItem('bagniak', 1)
	TriggerClientEvent('esx:showNotification', _source, ('Spaliłeś globus haze, HF!'))
end)