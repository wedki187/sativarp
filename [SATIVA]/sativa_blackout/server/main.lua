
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('arivi_blackout:dzwon')
AddEventHandler('arivi_blackout:dzwon', function(list, damage)	
	local _source = source
	for k,v in pairs(list) do
		TriggerClientEvent('arivi_blackout:dzwon', v, damage)
	end
	
	TriggerClientEvent('arivi_blackout:dzwon', _source, damage)
end)

RegisterServerEvent('arivi_blackout:impact')
AddEventHandler('arivi_blackout:impact', function(list, speedBuffer, velocityBuffer)
	local _source = source
	for k,v in pairs(list) do
		TriggerClientEvent('arivi_blackout:impact', v, speedBuffer, velocityBuffer)
	end
	
	TriggerClientEvent('arivi_blackout:impact', _source, speedBuffer, velocityBuffer)
end)