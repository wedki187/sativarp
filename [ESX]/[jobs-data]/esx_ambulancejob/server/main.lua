ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


local deadPlayers = {}

RegisterServerEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		xPlayer.addMoney(Config.ReviveReward)
		TriggerClientEvent('esx_ambulancejob:revive', target)
	else
		TriggerEvent('top_discord:send', source, 'https://discord.com/api/webhooks/841326684597649479/TSV5muVi1oMfRirZ5BQipME5JVSVY0pyXqhbL4rgdPcPgl-J0rRIDibNNxYpSHNPbZ2X', 'Użył triggera na revive bez joba medyka')
	end
end)

RegisterServerEvent('esx_ambulancejob:firstSpawn')
AddEventHandler('esx_ambulancejob:firstSpawn', function()
	local _source    = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier=@identifier',
	{
		['@identifier'] = xPlayer.identifier
	}, function(isDead)
		if isDead then
			TriggerClientEvent('esx_ambulancejob:requestDeath', _source)
		end
	end)
end)


ESX.RegisterServerCallback('ali:getEms', function(source, cb, store)
    local ems = 0
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'ambulance' then
            ems = ems + 1
        end
    end
    
    if ems <= Config.maxDoctor then
        cb(true)
    else
        cb('no_ems')
    end

end)

RegisterServerEvent('esx_ambulance:skldaknnjdmljsaujhdahjk')
AddEventHandler('esx_ambulance:skldaknnjdmljsaujhdahjk', function(data, value)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'offambulance' then
		xPlayer.addInventoryItem(data, value)
	end
end)

RegisterNetEvent('esx_ambulancejob:giveItem')
AddEventHandler('esx_ambulancejob:giveItem', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local jebacpis = xPlayer.getInventoryItem(itemName).count
	if xPlayer.job.name ~= 'ambulance' then
		--print(('[esx_ambulancejob] [^2INFO^7] "%s" attempted to spawn in an item!'):format(xPlayer.identifier))
		return
	elseif (itemName ~= 'medikit' and itemName ~= 'bandage') then
		--print(('[esx_ambulancejob] [^2INFO^7] "%s" attempted to spawn in an item!'):format(xPlayer.identifier))
		return
	end
	if jebacpis == 100 then
		xPlayer.showNotification('~o~Masz przy sobie maksymalną ilość tego przedmiotu')
	else
	xPlayer.addInventoryItem(itemName, amount)
	end
end)


RegisterServerEvent('ambulance:jsdahbdhahudhahudhujashujdhahdhj')
AddEventHandler('ambulance:jsdahbdhahudhahudhujashujdhahdhj', function()
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		local mamczynie = xPlayer.getInventoryItem('stungun').count
	if xPlayer.job.name == 'ambulance' then
		if mamczynie <= 1 then
			xPlayer.addInventoryItem('stungun', 1)
		else
			xPlayer.showNotification('~o~Masz już przy sobie wystarczającą ilośc tego przedmiotu.')
		end
	end
end)

RegisterServerEvent('esx_lokalnydoktor:money')
AddEventHandler('esx_lokalnydoktor:money', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getMoney() >= Config.doctorPrice then
		xPlayer.removeMoney(Config.doctorPrice)
		TriggerClientEvent('esx:showNotification', source, '$'.. Config.doctorPrice ..' Zapłacono za leczenie u miejscowego lekarza.')
		end
end)

RegisterServerEvent('sdjaudajik')
AddEventHandler('sdjaudajik', function(data, ile)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.job.name == 'ambulance' then
		xPlayer.addInventoryItem(data, ile)
	end
end)
ESX.RegisterServerCallback('esx_lokalnydoktor:parakontrol', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.getAccount('bank').money >= Config.doctorPrice)
end)


RegisterServerEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:heal', target, type)
	else
	end
end)

RegisterServerEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:putInVehicle', target)
	else
		end
end)

TriggerEvent('esx_phone:registerNumber', 'ambulance', _U('alert_ambulance'), true, true)

TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if Config.RemoveCashAfterRPDeath then
		if xPlayer.getMoney() > 0 then
			xPlayer.removeMoney(xPlayer.getMoney())
		end

		if xPlayer.getAccount('black_money').money > 0 then
			xPlayer.setAccountMoney('black_money', 0)
		end
	end

	if Config.RemoveItemsAfterRPDeath then
		for i=1, #xPlayer.inventory, 1 do
			if xPlayer.inventory[i].count > 0 then
				xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
			end
		end
	end

	local playerLoadout = {}
	if Config.RemoveWeaponsAfterRPDeath then
		for i=1, #xPlayer.loadout, 1 do
			xPlayer.removeWeapon(xPlayer.loadout[i].name)
		end
	else -- save weapons & restore em' since spawnmanager removes them
		for i=1, #xPlayer.loadout, 1 do
			table.insert(playerLoadout, xPlayer.loadout[i])
		end

		-- give back wepaons after a couple of seconds
		Citizen.CreateThread(function()
			Citizen.Wait(5000)
			for i=1, #playerLoadout, 1 do
				if playerLoadout[i].label ~= nil then
					xPlayer.addWeapon(playerLoadout[i].name, playerLoadout[i].ammo)
				end
			end
		end)
	end

	cb()
end)

if Config.EarlyRespawnFine then
	ESX.RegisterServerCallback('esx_ambulancejob:checkBalance', function(source, cb)
		local xPlayer = ESX.GetPlayerFromId(source)
		local bankBalance = xPlayer.getAccount('bank').money

		cb(bankBalance >= Config.EarlyRespawnFineAmount)
	end)

	RegisterServerEvent('esx_ambulancejob:payFine')
	AddEventHandler('esx_ambulancejob:payFine', function()
		local xPlayer = ESX.GetPlayerFromId(source)
		local fineAmount = Config.EarlyRespawnFineAmount

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('respawn_bleedout_fine_msg', ESX.Math.GroupDigits(fineAmount)))
		xPlayer.removeAccountMoney('bank', fineAmount)
	end)
end

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

RegisterServerEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem(item, 1)

	if item == 'bandage' then
		TriggerClientEvent('esx:showNotification', _source, _U('used_bandage'))
	elseif item == 'medikit' then
		TriggerClientEvent('esx:showNotification', _source, _U('used_medikit'))
	end
end)


RegisterCommand('revive', function(source, args, user)
	if source == 0 then
		TriggerClientEvent('esx_ambulancejob:revive', tonumber(args[1]), true)
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if (xPlayer.group == 'best' or xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'mod' or xPlayer.group == 'support' or xPlayer.group == 'trialsupport') then
			if args[1] ~= nil then
				if GetPlayerName(tonumber(args[1])) ~= nil then
					TriggerClientEvent('esx_ambulancejob:revive', tonumber(args[1]), true)
					TriggerEvent('top_discord:send', source, 'https://discord.com/api/webhooks/843514786339618816/mn-XxGdvtmHqeY-V3qdL8LPqLZJ2fBn0UuxPP-B7ZAygNi79wOKNsH87lhdxDQIS5GAK', 'Użył komendy revive na : ' ..args[1])
				end
			else
				TriggerClientEvent('esx_ambulancejob:revive', source, true)
				TriggerEvent('top_discord:send', source, 'https://discord.com/api/webhooks/843514954429497394/PzuNAkAuIHnRwDuvsNcLRcai8dNS60poUE221tm-aXGjSaje29S0OhAWy51v4XFHGf09', 'Użył komendy revive na SOBIE')
			end
		else
			xPlayer.showNotification('~r~Nie posiadasz permisji')
		end
	end
end, false)

ESX.RegisterUsableItem('medikit', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('medikit', 1)

	TriggerClientEvent('esx_ambulancejob:heal', _source, 'big')
	TriggerClientEvent('esx:showNotification', _source, _U('used_medikit'))
end)

ESX.RegisterUsableItem('bandage', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('bandage', 1)

	TriggerClientEvent('esx_ambulancejob:heal', _source, 'small')
	TriggerClientEvent('esx:showNotification', _source, _U('used_bandage'))
end)


RegisterServerEvent('esx_ambulance:checkmydead')
AddEventHandler('esx_ambulance:checkmydead', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local result = MySQL.Sync.fetchAll('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier,
		['@is_dead'] = 'is_dead'
	})
	if result[1] == '1' then
		TriggerClientEvent('esx_ambulance:OnPlayerDeath')
	end
end)

RegisterNetEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(take)
	local xPlayer = ESX.GetPlayerFromId(source)
		MySQL.Sync.execute('UPDATE users SET is_dead = @is_dead WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier,
			['@is_dead'] = take
		})
end)

ESX.RegisterServerCallback('esx_ambulancejob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

function StartDistressSignal()
	Citizen.CreateThread(function()
		local timer = Config.BleedoutTimer

		while timer > 0 and IsDead do
			Citizen.Wait(2)
			timer = timer - 30

			SetTextFont(4)
			SetTextProportional(1)
			SetTextScale(0.45, 0.45)
			SetTextColour(185, 185, 185, 255)
			SetTextDropShadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName(_U('distress_send'))
			EndTextCommandDisplayText(0.175, 0.805)

			if IsControlPressed(0, Keys['G']) then

				SendDistressSignal()
				break

			end
		end
	end)
end