ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

local blips = Config.Blips

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    for k, v in pairs(blips) do
        if not v.members then blips[k].members = { } end
    end
end)

RegisterNetEvent('badBlips:server:registerPlayerBlipGroup')
AddEventHandler('badBlips:server:registerPlayerBlipGroup', function(source, group)
    local xPlayer = ESX.GetPlayerFromId(source)
    local userData = getPlayer(xPlayer.identifier)
    while userData == nil do
        Citizen.Wait(10)
    end

    if not blips[group] then
        blips[group] = { members = { } }
    end
    blips[group].members[source] = { is_member = true, data = userData, job_label = xPlayer.job.grade_label }
end)

RegisterNetEvent('szymczakovv:refreshGPS')
AddEventHandler('szymczakovv:refreshGPS', function()
    local _source = source
    --[[local xPlayer = ESX.GetPlayerFromId(_source)
    local gpsCount = xPlayer.getInventoryItem('gps').count

    if gpsCount > 0 then
        xPlayer.removeInventoryItem('gps', 1)
        Wait(1000)
        xPlayer.addInventoryItem('gps', 1)
        TriggerClientEvent('esx:showNotification', _source, '~g~Zrestartowano GPS')
    end]]
    local xPlayer = ESX.GetPlayerFromId(source)
    for blip_name, blip in pairs(blips) do
        for member_source, data in pairs(blip.members) do
            if source == member_source then
                blips[blip_name].members[source] = nil
            end
        end
    end
    local group = 'unknown'

    if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'mecano' then
        group = xPlayer.job.name
    end

    if xPlayer ~= nil then
        TriggerEvent('badBlips:server:registerPlayerBlipGroup', source, group)
        TriggerClientEvent('esx:showNotification', _source, '~g~Uruchomiono GPS')
    end
end)

RegisterNetEvent('szymczakovv:destroyGPS')
AddEventHandler('szymczakovv:destroyGPS', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local gpsCount = xPlayer.getInventoryItem('tgps').count

    if gpsCount > 0 then
        xPlayer.removeInventoryItem('tgps', 1)
        TriggerClientEvent('esx:showNotification', _source, '~r~Zniszczono GPS')
        local group = 'unknown'

        if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'mecano' then
            group = xPlayer.job.name
        end
        TriggerEvent('badBlips:server:removePlayerBlipGroup', _source, group)
    end
end)

RegisterNetEvent('badBlips:server:removePlayerBlipGroup')
AddEventHandler('badBlips:server:removePlayerBlipGroup', function(source, group)
    if blips[group].members[source] then
        blips[group].members[source] = nil
    end
end)

RegisterNetEvent('badBlips:server:registerPlayerTempBlipGroup')
AddEventHandler('badBlips:server:registerPlayerTempBlipGroup', function(source, group, time)
    TriggerEvent('badBlips:server:registerPlayerBlipGroup', source, 'police')
    SetTimeout(time, function()
        TriggerEvent('badBlips:server:removePlayerBlipGroup', source, 'police')
    end)
end)

AddEventHandler('playerDropped', function()
    local source = source

    for blip_name, blip in pairs(blips) do
        for member_source, data in pairs(blip.members) do
            if source == member_source then
                blips[blip_name].members[source] = nil
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.other_zone)

        for blip_name, blip in pairs(blips) do
            local blips_data = { }
            if blip._can_see then
                for _, can_see_group_name in pairs(blip._can_see) do
                    for source, data in pairs(blips[can_see_group_name].members) do
                        if data then
                            local ped = GetPlayerPed(source)
                            if DoesEntityExist(ped) then
                                local pos = GetEntityCoords(ped)
                                blips_data = appendBlipsPacket(blips_data, can_see_group_name, source, pos, blips[can_see_group_name].members[source].data, blips[can_see_group_name].members[source].job_label)
                            end
                        end
                    end
                end
            end

            for source, data in pairs(blip.members) do
                if data then
                    local ped = GetPlayerPed(source)
                    if DoesEntityExist(ped) then
                        local pos = GetEntityCoords(ped)
                        blips_data = appendBlipsPacket(blips_data, blip_name, source, pos, blips[blip_name].members[source].data, blips[blip_name].members[source].job_label)
                    end
                end
            end

            Citizen.CreateThread(function()
                for source, is_valid_member in pairs(blip.members) do
                    if is_valid_member then
                        TriggerClientEvent('badBlips:client:syncMyBlips', source, blips_data)
                        Citizen.Wait(100)
                    end
                end
            end)

            Citizen.Wait(Config.same_zone)
        end
    end
end)

function appendBlipsPacket(blips_data, blip_name, source, position, userData, jobLabel)
    local x, y, z = table.unpack(position)

    local firstname = userData.firstname
    local lastname = userData.lastname
    local plate = userData.number

    table.insert(blips_data, {
        x, -- [1]
        y, -- [2]
        z, -- [3]
        blip_name, -- [4]
        source, -- [5]
        plate, -- [6]
        firstname,
        lastname,
        jobLabel,
    })

    return blips_data
end

function getPlayer(identifier)
    local result = MySQL.Sync.fetchAll("SELECT firstname, lastname, odznaka FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
    if result[1] ~= nil then
        local identity = result[1]
        local badge = identity['odznaka']
        if badge == nil then
            badge = 'Brak'
        end
        return {
            firstname = identity['firstname'],
            lastname = identity['lastname'],
			number = identity['odznaka'],
        }
    else
        return {
            firstname = 'Brak',
            lastname = 'Brak',
            number = 'Brak',
       }
    end
end

function getID(steamid, callback)
	MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = @identifier",
	{
		['@identifier'] = steamid
	}, function(result)
		if result[1] ~= nil then
			local data = {
				identifier	= identifier,
				firstname	= result[1]['firstname'],
				lastname	= result[1]['lastname'],
				badge       = result[1]['odznaka']
			}
			
			callback(data)
		else	
			local data = {
				identifier 	= '',
				firstname 	= '',
				lastname 	= '',
				badge       = '',
			}
			
			callback(data)
		end
	end)
end

AddEventHandler('esx:onAddInventoryItem', function(source, item, count)
    if item == 'tgps' and count > 0 then
        local xPlayer = ESX.GetPlayerFromId(source)
        local group = 'unknown'

        if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'mecano' then
            group = xPlayer.job.name
        end

        if xPlayer ~= nil then
            TriggerEvent('badBlips:server:registerPlayerBlipGroup', source, group)
        end

        Citizen.Wait(500)
    end
end)

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
    if item == 'tgps' and count < 1 then
        local xPlayer = ESX.GetPlayerFromId(source)
        for blip_name, blip in pairs(blips) do
            for member_source, data in pairs(blip.members) do
                if source == member_source then
                    blips[blip_name].members[source] = nil
                end
            end
        end
        Citizen.Wait(500)

        if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance'  or xPlayer.job.name == 'mecano' then
            getID(xPlayer.identifier, function(data)
                if data ~= nil then
                    local xPlayers = ESX.GetPlayers()
                    for k,v in pairs(xPlayers) do
                        if v.job.name == 'police' or v.job.name == 'ambulance' then
                            TriggerClientEvent('szymczakovv:lostGPS', v.id, '[' .. data.badge .. '] '..data.firstname..' '..data.lastname, xPlayer.getCoords(true))
                        end
                    end
                end
            end)
        end
    end
end)

ESX.RegisterUsableItem('tgps', function(source)
	TriggerClientEvent('szymczakovv:openMenu', source)
	Citizen.Wait(100)
end)