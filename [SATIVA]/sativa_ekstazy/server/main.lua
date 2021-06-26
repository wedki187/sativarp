ESX 						   = nil
local CopsConnected       	   = 0
local PlayersHarvestingMorf    = {}
local PlayersTransformingMorf  = {}
local PlayersSellingMorf       = {}

function sendToDiscord (name,message,color)
    local DiscordWebHook = "https://discord.com/api/webhooks/841329869828390932/LTG-9dbyxKL2SjmTOWcjIx0ZoR5yOZsRho5zSyKHE9B8PD_xVfgmhWnFvl-64pZWTbVs"

  local embeds = {
      {
          ["title"]=message,
          ["type"]="rich",
          ["color"] =color,
          ["footer"]=  {
              ["text"]= "UZYTO EKSTAZE",
         },
      }
  }

    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CountCops()
	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()

--morfina
local function HarvestMorf(source)
	if CopsConnected < Config.RequiredCopsMorf then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMorf))
		return
	end

	SetTimeout(Config.TimeToFarm, function()
		if PlayersHarvestingMorf[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local morf = xPlayer.getInventoryItem('ekstazy')

			if morf.limit ~= -1 and morf.count >= morf.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_morf'))
			else
				xPlayer.addInventoryItem('ekstazy', 1)
				HarvestMorf(source)
			end
		end
	end)
end

RegisterServerEvent('esx_morf:startHarvestMorf')
AddEventHandler('esx_morf:startHarvestMorf', function()
	local _source = source

	if not PlayersHarvestingMorf[_source] then
		PlayersHarvestingMorf[_source] = true

		TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))
		HarvestMorf(_source)
	else
		print(('esx_morf: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('esx_morf:stopHarvestMorf')
AddEventHandler('esx_morf:stopHarvestMorf', function()
	local _source = source

	PlayersHarvestingMorf[_source] = false
end)

local function TransformMorf(source)
	if CopsConnected < Config.RequiredCopsMorf then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMorf))
		return
	end

	SetTimeout(Config.TimeToProcess, function()
		if PlayersTransformingMorf[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local morfQuantity = xPlayer.getInventoryItem('ekstazy').count
			local pooch = xPlayer.getInventoryItem('ekstazy1')

			if pooch.limit ~= -1 and pooch.count >= pooch.limit then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
			elseif morfQuantity < 5 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_morf'))
			else
				xPlayer.removeInventoryItem('ekstazy', 5)
				xPlayer.addInventoryItem('ekstazy1', 1)

				TransformMorf(source)
			end
		end
	end)
end

RegisterServerEvent('esx_morf:startTransformMorf')
AddEventHandler('esx_morf:startTransformMorf', function()
	local _source = source

	if not PlayersTransformingMorf[_source] then
		PlayersTransformingMorf[_source] = true

		TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))
		TransformMorf(_source)
	else
		print(('esx_morf: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('esx_morf:stopTransformMorf')
AddEventHandler('esx_morf:stopTransformMorf', function()
	local _source = source

	PlayersTransformingMorf[_source] = false
end)

RegisterServerEvent('esx_morf:GetUserInventory')
AddEventHandler('esx_morf:GetUserInventory', function(currentZone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('esx_morf:ReturnInventory',
		_source,
		xPlayer.getInventoryItem('ekstazy').count,
		xPlayer.getInventoryItem('ekstazy1').count,
		xPlayer.job.name,
		currentZone
	)
end)

ESX.RegisterUsableItem('ekstazy1', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = GetPlayerName(source)

	xPlayer.removeInventoryItem('ekstazy1', 1)

	TriggerClientEvent('esx_morf:onPot', _source)
	TriggerClientEvent('esx:showNotification', _source, ('Spaliłeś globusa!!!'))
	sendToDiscord (('Uzyto Ekstazy!'), "Gracz " .. identifier .. " " .. " uzyl ekstazy licka gracza: " .. xPlayer.identifier .. " i otrzymal 15% armora") 
end)