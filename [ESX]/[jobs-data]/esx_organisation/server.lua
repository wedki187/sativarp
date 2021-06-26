ESX = nil
OrganizationsTable = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

for job, data in pairs(Config.Organisations) do
	TriggerEvent('esx_society:registerSociety', job, data.Label, 'society_'..job, 'society_'..job, 'society_'..job, {type = 'private'})
end

RegisterServerEvent('szymczakovv_organizations:setStockUsed')
AddEventHandler('szymczakovv_organizations:setStockUsed', function(name, type, bool)
	for i=1, #OrganizationsTable, 1 do
		if OrganizationsTable[i].name == name and OrganizationsTable[i].type == type then
			OrganizationsTable[i].used = bool
			break
		end
	end
end)

RegisterServerEvent('szymczakovv_organizations')
AddEventHandler('szymczakovv_organizations', function(klameczka)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local ilemam = xPlayer.getAccount('bank').money
	--print('Wyniki:', ilemam, klameczka)
	if xPlayer.getAccount(Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Account).money >= Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Price then
		xPlayer.removeAccountMoney(Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Account, Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Price)
		Citizen.Wait(100)
		xPlayer.addInventoryItem(Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Weapon, 1)
		xPlayer.showNotification('~o~Zakupiłeś kontrakt na broń: '..Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Label)
	else
		xPlayer.showNotification('~r~Nie posiadasz wystarczającej ilości gotówki')
	end
end)

RegisterServerEvent('neey_dev:saveOutfit')
AddEventHandler('neey_dev:saveOutfit', function(label, skin, organizacja)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_datastore:getSharedDataStore', organizacja, function(store)
		local dressing = store.get('dressing')

		if dressing == nil then
			dressing = {}
		end

		table.insert(dressing, {
			label = label,
			skin  = skin
		})

		store.set('dressing', dressing)
	end)
end)

ESX.RegisterServerCallback('neey_dev:getPlayerDressing', function(source, cb, organizacja)
	local xPlayer  = ESX.GetPlayerFromId(source)
	if xPlayer then
		TriggerEvent('esx_datastore:getSharedDataStore', organizacja, function(store)
			local count  = store.count('dressing')
			local labels = {}

			for i=1, count, 1 do
				local entry = store.get('dressing', i)
				table.insert(labels, entry.label)
			end

			cb(labels)
		end)
	end
end)

ESX.RegisterServerCallback('neey_dev:getPlayerOutfit', function(source, cb, num, organizacja)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		TriggerEvent('esx_datastore:getSharedDataStore', organizacja, function(store)
			local outfit = store.get('dressing', num)
			cb(outfit.skin)
		end)
	end
end)

RegisterServerEvent('szymczakovv_stocks:Magazynek')
AddEventHandler('szymczakovv_stocks:Magazynek', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
		if xPlayer.getAccount(Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Account).money >= Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Price then
			xPlayer.removeAccountMoney(Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Account, Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Price)
			Citizen.Wait(100)
			xPlayer.addInventoryItem('pistol_ammo', Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Number)
			xPlayer.showNotification('~o~Zakupiłeś amunicję w ilości: '..Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Number.. ' ~g~za: $'..Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Price)

		else
			xPlayer.showNotification('~r~Nie posiadasz wystarczającej ilości gotówki')
		end
end)


ESX.RegisterServerCallback('szymczakovv_organizations:checkStock', function(source, cb, name, type)
	local check, found
	if #OrganizationsTable > 0 then
        for i=1, #OrganizationsTable, 1 do
			if OrganizationsTable[i].name == name and OrganizationsTable[i].type == type then
				check = OrganizationsTable[i].used
				found = true
				break
			end
		end
		if found == true then
			cb(check)
		else
			table.insert(OrganizationsTable, {name = name, type = type, used = true})
			cb(false)
		end
	else
		table.insert(OrganizationsTable, {name = name, type = type, used = true})
		cb(false)
	end
end)

ESX.RegisterServerCallback('szymczakovv_stocks:getPlayerDressing', function(source, cb)
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local count  = store.count('dressing')
		local labels = {}
		for i=1, count, 1 do
			local entry = store.get('dressing', i)
			table.insert(labels, entry.label)
		end

		cb(labels)
	end)
end)

ESX.RegisterServerCallback('szymczakovv_stocks:getPlayerOutfit', function(source, cb, num)
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier,  function(store)
		local outfit = store.get('dressing', num)
		cb(outfit.skin)
	end)
end)

RegisterServerEvent('szymczakovv_stocks:removeOutfit')
AddEventHandler('szymczakovv_stocks:removeOutfit', function(label)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier,  function(store)
		local dressing = store.get('dressing') or {}

		table.remove(dressing, label)
		store.set('dressing', dressing)
	end)
end)

RegisterServerEvent('szymczakovv_stocks:CheckHeadBag')
AddEventHandler('szymczakovv_stocks:CheckHeadBag', function()
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getInventoryItem('headbag').count >= 1 then
		TriggerClientEvent('esx_worek:naloz', _source)
	else
		TriggerClientEvent('esx:showNotification', _source, '~o~Nie posiadasz przedmiotu worek przy sobie aby rozpocząć interakcję z workiem.')
	end
end)

ESX.RegisterServerCallback('neey:getStockBlack', function(source, cb, org)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local blackMoney = 0
    
	TriggerEvent('esx_addonaccount:getSharedAccount', org ..'_black_money', function(account)
		blackMoney = account.money
	end)

	cb({
		blackMoney = blackMoney,
	})
end)


ESX.RegisterServerCallback('neey_dev:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local blackMoney = xPlayer.getAccount('black_money').money
	cb({
		blackMoney = blackMoney,
	})
end)

RegisterServerEvent('neey_dev:getBlack')
AddEventHandler('neey_dev:getBlack', function(organizacja, itemType, itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.hiddenjob.name == organizacja then
		if itemType == 'item_account' then
			TriggerEvent('esx_addonaccount:getSharedAccount', organizacja .. '_' .. itemName, function(account)
				local roomAccountMoney = account.money
	
				if roomAccountMoney >= count then
					account.removeMoney(count)
					xPlayer.addAccountMoney('black_money', count)
				else
					TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nieprawidłowa ilość!.')
				end
			end)
		end
	end
end)

RegisterServerEvent('neey_dev:putBlack')
AddEventHandler('neey_dev:putBlack', function(organizacja, itemType, itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.hiddenjob.name == organizacja then
		if itemType == 'item_account' then
			local playerAccountMoney = xPlayer.getAccount(itemName).money

			if playerAccountMoney >= count and count > 0 then
				xPlayer.removeAccountMoney(itemName, count)
				TriggerEvent('esx_addonaccount:getSharedAccount', organizacja .. '_' .. itemName, function(account)
					account.addMoney(count)
				end)
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nieprawidłowa ilość!.')
			end
		end
	end
end)


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("neey_gwizdek:checkUse")
AddEventHandler("neey_gwizdek:checkUse", function(coords)
    local xPlayer = ESX.GetPlayerFromId(source)
    for k, v in pairs(Config.Jobs) do
        if v == xPlayer.hiddenjob.name then
            TriggerClientEvent('neey_gwizdek:setBlip', -1, coords, xPlayer.hiddenjob.name)
            break
        end
    end
end)