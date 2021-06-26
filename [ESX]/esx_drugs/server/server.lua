ESX 						   = nil
local CopsConnected       	   = 0
local PlayersHarvestingCoke    = {}
local PlayersTransformingCoke  = {}
local PlayersSellingCoke       = {}
local PlayersHarvestingMeth    = {}
local PlayersTransformingMeth  = {}
local PlayersSellingMeth       = {}
local PlayersHarvestingWeed    = {}
local PlayersTransformingWeed  = {}
local PlayersSellingWeed       = {}
local PlayersHarvestingOpium   = {}
local PlayersTransformingOpium = {}
local PlayersSellingOpium      = {}
local event1 = 'yung_ac:code' .. math.random(1000,1000000)
local event2 = 'yung_ac:code' .. math.random(1000,1000000)
local event3 = 'yung_ac:code' .. math.random(1000,1000000)
local event4 = 'yung_ac:code' .. math.random(1000,1000000)
local event5 = 'yung_ac:code' .. math.random(1000,1000000)
local event6 = 'yung_ac:code' .. math.random(1000,1000000)
local event7 = 'yung_ac:code' .. math.random(1000,1000000)
local event8 = 'yung_ac:code' .. math.random(1000,1000000)
local event9 = 'yung_ac:code' .. math.random(1000,1000000)


Citizen.CreateThread(function()
	while true do
		Zones = {
			CokeField =			{x = 527.5, y = 3087.83, z = 39.47,	name = _U('coke_field'),		sprite = 1,	color = 100},         -- HEROINA                -- TAK
			CokeProcessing =	{x = 3326.0, y = 5181.32, z = 17.42,	name = _U('coke_processing'),	sprite = 1,	color = 100},         -- HEROINA P              -- TAK 

			MethField =			{x = 1391.85, y = 3606.33, z = 37.94,	name = _U('meth_field'),		sprite = 1,	color = 50},          -- Metamfetamina          -- TAK
			MethProcessing =	{x = 3821.5, y = 4443.39, z = 1.81,	name = _U('meth_processing'),	sprite = 1,	color = 50},          -- Metamfetamina P        -- TAK

			WeedField =			{x =  1346.2, y = 5576.55, z = 43.34,	name = _U('weed_field'),		sprite = 1,	color = 25},          -- Kokaina                -- TAK
			WeedProcessing =	{x = 2231.13,    y =  5576.55,    z =  52.99,	name = _U('weed_processing'),	sprite = 1,	color = 25},          -- Kokaina P              -- TAK

			OpiumField =		{x = 12233431.05,	y = 43434382.55, z = 3435.42,	name = _U('opium_field'),		sprite = 1,	color = 1},               -- Sterydy                -- TAK
			OpiumProcessing =	{x = 14434398.4,	y = -20943433.05,	z = 7643.83,	name = _U('opium_processing'),	sprite = 1,	color = 1},           -- Sterydy P              -- TAK
		}

		TriggerClientEvent('yung_ac:esx_dragi:config', -1, Zones)
		TriggerClientEvent('yung_ac:esx_dragi:eventchanger', -1, event1, event2, event3, event4, event5, event6, event7, event8, event9)
		Wait(1000)
	end
end)


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'bcso' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()

--coke
local function HarvestCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingCoke[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)
			if xPlayer then
				local coke = xPlayer.getInventoryItem('coke')

				if coke.limit ~= -1 and coke.count >= coke.limit then
					TriggerClientEvent('esx:showNotification', source, _U('inv_full_coke'))
				else
					xPlayer.addInventoryItem('coke', 1)
					HarvestCoke(source)
				end
			end
		end
	end)
end

RegisterServerEvent(event2)
AddEventHandler(event2, function()

	local _source = source

	PlayersHarvestingCoke[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestCoke(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestCoke')
AddEventHandler('esx_drugs:stopHarvestCoke', function()

	local _source = source

	PlayersHarvestingCoke[_source] = false

end)

local function TransformCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingCoke[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer then
				local cokeQuantity = xPlayer.getInventoryItem('coke').count
				local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count

				if poochQuantity > 35 then
					TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
				elseif cokeQuantity < 5 then
					TriggerClientEvent('esx:showNotification', source, _U('not_enough_coke'))
				else
					xPlayer.removeInventoryItem('coke', 5)
					xPlayer.addInventoryItem('coke_pooch', 1)
				
					TransformCoke(source)
				end
			end

		end
	end)
end

RegisterServerEvent(event3)
AddEventHandler(event3, function()

	local _source = source

	PlayersTransformingCoke[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformCoke(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformCoke')
AddEventHandler('esx_drugs:stopTransformCoke', function()

	local _source = source

	PlayersTransformingCoke[_source] = false

end)

local function SellCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke))
		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingCoke[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer then
				local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count

				if poochQuantity == 0 then
					TriggerClientEvent('esx:showNotification', source, _U('no_pouches_sale'))
				else
					xPlayer.removeInventoryItem('coke_pooch', 1)
					if CopsConnected == 0 then
						xPlayer.addAccountMoney('black_money', 198)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_coke'))
					elseif CopsConnected == 1 then
						xPlayer.addAccountMoney('black_money', 258)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_coke'))
					elseif CopsConnected == 2 then
						xPlayer.addAccountMoney('black_money', 308)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_coke'))
					elseif CopsConnected == 3 then
						xPlayer.addAccountMoney('black_money', 358)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_coke'))
					elseif CopsConnected == 4 then
						xPlayer.addAccountMoney('black_money', 396)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_coke'))
					elseif CopsConnected >= 5 then
						xPlayer.addAccountMoney('black_money', 428)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_coke'))
					end
					
					SellCoke(source)
				end
			end
		end
	end)
end

RegisterServerEvent('esx_drugs:startSellCoke')
AddEventHandler('esx_drugs:startSellCoke', function()

	local _source = source

	TriggerClientEvent('2Dl4-P4m2-ApdL-BMsL:FpS2-ASmV-24xg-ZplM', source, '[esx_dragi] Użycie nieistniejącego eventu: esx_drugs:startSellCoke')

end)

RegisterServerEvent('esx_drugs:stopSellCoke')
AddEventHandler('esx_drugs:stopSellCoke', function()

	local _source = source

	PlayersSellingCoke[_source] = true

end)

--meth
local function HarvestMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
		return
	end
	
	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingMeth[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer then
				local meth = xPlayer.getInventoryItem('meth')

				if meth.limit ~= -1 and meth.count >= meth.limit then
					TriggerClientEvent('esx:showNotification', source, _U('inv_full_meth'))
				else
					xPlayer.addInventoryItem('meth', 1)
					HarvestMeth(source)
				end
			end
		end
	end)
end

RegisterServerEvent(event4)
AddEventHandler(event4, function()

	local _source = source

	PlayersHarvestingMeth[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestMeth(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestMeth')
AddEventHandler('esx_drugs:stopHarvestMeth', function()

	local _source = source

	PlayersHarvestingMeth[_source] = false

end)

local function TransformMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingMeth[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer then
				local methQuantity = xPlayer.getInventoryItem('meth').count
				local poochQuantity = xPlayer.getInventoryItem('meth_pooch').count

				if poochQuantity > 35 then
					TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
				elseif methQuantity < 5 then
					TriggerClientEvent('esx:showNotification', source, _U('not_enough_meth'))
				else
					xPlayer.removeInventoryItem('meth', 5)
					xPlayer.addInventoryItem('meth_pooch', 1)
					
					TransformMeth(source)
				end
			end
		end
	end)
end

RegisterServerEvent(event5)
AddEventHandler(event5, function()

	local _source = source

	PlayersTransformingMeth[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformMeth(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformMeth')
AddEventHandler('esx_drugs:stopTransformMeth', function()

	local _source = source

	PlayersTransformingMeth[_source] = false

end)

local function SellMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingMeth[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer then
				local poochQuantity = xPlayer.getInventoryItem('meth_pooch').count

				if poochQuantity == 0 then
					TriggerClientEvent('esx:showNotification', _source, _U('no_pouches_sale'))
				else
					xPlayer.removeInventoryItem('meth_pooch', 1)
					if CopsConnected == 0 then
						xPlayer.addAccountMoney('black_money', 276)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
					elseif CopsConnected == 1 then
						xPlayer.addAccountMoney('black_money', 374)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
					elseif CopsConnected == 2 then
						xPlayer.addAccountMoney('black_money', 474)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
					elseif CopsConnected == 3 then
						xPlayer.addAccountMoney('black_money', 552)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
					elseif CopsConnected == 4 then
						xPlayer.addAccountMoney('black_money', 616)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
					elseif CopsConnected == 5 then
						xPlayer.addAccountMoney('black_money', 654)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
					elseif CopsConnected >= 6 then
						xPlayer.addAccountMoney('black_money', 686)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
					end
					
					SellMeth(source)
				end
			end
		end
	end)
end

RegisterServerEvent('esx_drugs:startSellMeth')
AddEventHandler('esx_drugs:startSellMeth', function()

	local _source = source

	TriggerClientEvent('2Dl4-P4m2-ApdL-BMsL:FpS2-ASmV-24xg-ZplM', source, '[esx_dragi] Użycie nieistniejącego eventu: esx_drugs:startSellMeth')
end)

RegisterServerEvent('esx_drugs:stopSellMeth')
AddEventHandler('esx_drugs:stopSellMeth', function()

	local _source = source

	PlayersSellingMeth[_source] = true

end)

--weed
local function HarvestWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingWeed[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer then
				local weed = xPlayer.getInventoryItem('weed')

				if weed.limit ~= -1 and weed.count >= weed.limit then
					TriggerClientEvent('esx:showNotification', source, _U('inv_full_weed'))
				else
					xPlayer.addInventoryItem('weed', 1)
					HarvestWeed(source)
				end
			end
		end
	end)
end

RegisterServerEvent(event6)
AddEventHandler(event6, function()

	local _source = source

	PlayersHarvestingWeed[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestWeed(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestWeed')
AddEventHandler('esx_drugs:stopHarvestWeed', function()

	local _source = source

	PlayersHarvestingWeed[_source] = false

end)

local function TransformWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingWeed[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer then
				local weedQuantity = xPlayer.getInventoryItem('weed').count
				local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

				if poochQuantity > 35 then
					TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
				elseif weedQuantity < 5 then
					TriggerClientEvent('esx:showNotification', source, _U('not_enough_weed'))
				else
					xPlayer.removeInventoryItem('weed', 5)
					xPlayer.addInventoryItem('weed_pooch', 1)
					
					TransformWeed(source)
				end
			end
		end
	end)
end

RegisterServerEvent(event7)
AddEventHandler(event7, function()

	local _source = source

	PlayersTransformingWeed[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformWeed(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformWeed')
AddEventHandler('esx_drugs:stopTransformWeed', function()

	local _source = source

	PlayersTransformingWeed[_source] = false

end)

local function SellWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingWeed[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer then
				local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

				if poochQuantity == 0 then
					TriggerClientEvent('esx:showNotification', source, _U('no_pouches_sale'))
				else
					xPlayer.removeInventoryItem('weed_pooch', 1)
					if CopsConnected == 0 then
						xPlayer.addAccountMoney('black_money', 108)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_weed'))
					elseif CopsConnected == 1 then
						xPlayer.addAccountMoney('black_money', 128)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_weed'))
					elseif CopsConnected == 2 then
						xPlayer.addAccountMoney('black_money', 152)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_weed'))
					elseif CopsConnected == 3 then
						xPlayer.addAccountMoney('black_money', 165)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_weed'))
					elseif CopsConnected >= 4 then
						xPlayer.addAccountMoney('black_money', 180)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_weed'))
					end
					
					SellWeed(source)
				end
			end
		end
	end)
end

RegisterServerEvent('esx_drugs:startSellWeed')
AddEventHandler('esx_drugs:startSellWeed', function()

	local _source = source

	TriggerClientEvent('2Dl4-P4m2-ApdL-BMsL:FpS2-ASmV-24xg-ZplM', source, '[esx_dragi] Użycie nieistniejącego eventu: esx_drugs:startSellWeed')

end)

RegisterServerEvent('esx_drugs:stopSellWeed')
AddEventHandler('esx_drugs:stopSellWeed', function()

	local _source = source

	PlayersSellingWeed[_source] = true

end)


--opium

local function HarvestOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium))
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingOpium[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer then
				local opium = xPlayer.getInventoryItem('opium')

				if opium.limit ~= -1 and opium.count >= opium.limit then
					TriggerClientEvent('esx:showNotification', source, _U('inv_full_opium'))
				else
					xPlayer.addInventoryItem('opium', 1)
					HarvestOpium(source)
				end
			end
		end
	end)
end

RegisterServerEvent(event8)
AddEventHandler(event8, function()

	local _source = source

	PlayersHarvestingOpium[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestOpium(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestOpium')
AddEventHandler('esx_drugs:stopHarvestOpium', function()

	local _source = source

	PlayersHarvestingOpium[_source] = false

end)

local function TransformOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium))
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingOpium[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer then
				local opiumQuantity = xPlayer.getInventoryItem('opium').count
				local poochQuantity = xPlayer.getInventoryItem('opium_pooch').count

				if poochQuantity > 35 then
					TriggerClientEvent('esx:showNotification', source, _U('too_many_pouches'))
				elseif opiumQuantity < 5 then
					TriggerClientEvent('esx:showNotification', source, _U('not_enough_opium'))
				else
					xPlayer.removeInventoryItem('opium', 5)
					xPlayer.addInventoryItem('opium_pooch', 1)
				
					TransformOpium(source)
				end
			end
		end
	end)
end

RegisterServerEvent(event9)
AddEventHandler(event9, function()

	local _source = source

	PlayersTransformingOpium[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformOpium(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformOpium')
AddEventHandler('esx_drugs:stopTransformOpium', function()

	local _source = source

	PlayersTransformingOpium[_source] = false

end)

local function SellOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium))
		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingOpium[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer then
				local poochQuantity = xPlayer.getInventoryItem('opium_pooch').count

				if poochQuantity == 0 then
					TriggerClientEvent('esx:showNotification', source, _U('no_pouches_sale'))
				else
					xPlayer.removeInventoryItem('opium_pooch', 1)
					if CopsConnected == 0 then
						xPlayer.addAccountMoney('black_money', 300)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_opium'))
					elseif CopsConnected == 1 then
						xPlayer.addAccountMoney('black_money', 500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_opium'))
					elseif CopsConnected == 2 then
						xPlayer.addAccountMoney('black_money', 700)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_opium'))
					elseif CopsConnected == 3 then
						xPlayer.addAccountMoney('black_money', 800)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_opium'))
					elseif CopsConnected == 4 then
						xPlayer.addAccountMoney('black_money', 900)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_opium'))
					elseif CopsConnected >= 5 then
						xPlayer.addAccountMoney('black_money', 1000)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_opium'))
					end
					
					SellOpium(source)
				end
			end
		end
	end)
end

RegisterServerEvent('esx_drugs:startSellOpium')
AddEventHandler('esx_drugs:startSellOpium', function()

	local _source = source

	TriggerClientEvent('2Dl4-P4m2-ApdL-BMsL:FpS2-ASmV-24xg-ZplM', source, '[esx_dragi] Użycie nieistniejącego eventu: esx_drugs:startSellOpium')
end)

RegisterServerEvent('esx_drugs:stopSellOpium')
AddEventHandler('esx_drugs:stopSellOpium', function()

	local _source = source

	PlayersSellingOpium[_source] = true

end)

RegisterServerEvent('esx_drugs:GetUserInventory')
AddEventHandler('esx_drugs:GetUserInventory', function(currentZone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer then
		TriggerClientEvent('esx_drugs:ReturnInventory', 
			_source, 
			xPlayer.getInventoryItem('coke').count, 
			xPlayer.getInventoryItem('coke_pooch').count,
			xPlayer.getInventoryItem('meth').count, 
			xPlayer.getInventoryItem('meth_pooch').count, 
			xPlayer.getInventoryItem('weed').count, 
			xPlayer.getInventoryItem('weed_pooch').count, 
			xPlayer.getInventoryItem('coke').count, 
			xPlayer.getInventoryItem('coke_pooch').count,
			xPlayer.job.name, 
			currentZone
		)
	end
end)

ESX.RegisterUsableItem('weed', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer then
		xPlayer.removeInventoryItem('weed', 1)

		TriggerClientEvent('esx_drugs:onPot', _source)
		TriggerClientEvent('esx:showNotification', _source, _U('used_one_weed'))
	end
end)
