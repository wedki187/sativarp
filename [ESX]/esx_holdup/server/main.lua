local rob = false
local robbers = {}
ESX = nil
local jail = "https://discord.com/api/webhooks/838741204631158815/l3Ofikp8VSsxXkm5L6vUaz5EeG7H6MRGIDHnyFmXXXDww0502tATW190ETVKndnZA7Wb"
local hajsitemy = "https://discord.com/api/webhooks/838741204631158815/l3Ofikp8VSsxXkm5L6vUaz5EeG7H6MRGIDHnyFmXXXDww0502tATW190ETVKndnZA7Wb"
local wejscie = "https://discord.com/api/webhooks/838741204631158815/l3Ofikp8VSsxXkm5L6vUaz5EeG7H6MRGIDHnyFmXXXDww0502tATW190ETVKndnZA7Wb"
local wyjscie = "https://discord.com/api/webhooks/838741204631158815/l3Ofikp8VSsxXkm5L6vUaz5EeG7H6MRGIDHnyFmXXXDww0502tATW190ETVKndnZA7Wb"
local chat = "https://discord.com/api/webhooks/838741204631158815/l3Ofikp8VSsxXkm5L6vUaz5EeG7H6MRGIDHnyFmXXXDww0502tATW190ETVKndnZA7Wb"
local communityname = "Logi Master"


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_holdup:toofar')
AddEventHandler('esx_holdup:toofar', function(robb)
	local _source = source
	local xPlayers = ESX.GetPlayers()
	rob = false
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx:showNotification', xPlayers[i], _U('robbery_cancelled_at', Stores[robb].nameofstore))
			TriggerClientEvent('esx_holdup:killblip', xPlayers[i])
		end
	end
	if robbers[_source] then
		TriggerClientEvent('esx_holdup:toofarlocal', _source)
		robbers[_source] = nil
		TriggerClientEvent('esx:showNotification', _source, _U('robbery_cancelled_at', Stores[robb].nameofstore))
	end
end)

RegisterServerEvent('esx_holdup:rob')
AddEventHandler('esx_holdup:rob', function(robb)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	if Stores[robb] then
		local store = Stores[robb]

		if (os.time() - store.lastrobbed) < Config.TimerBeforeNewRob and store.lastrobbed ~= 0 then
			TriggerClientEvent('esx:showNotification', _source, _U('recently_robbed', Config.TimerBeforeNewRob - (os.time() - store.lastrobbed)))
			return
		end

		local cops = 0
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				cops = cops + 1
			end
		end

		if rob == false then
			if cops >= Config.PoliceNumberRequired then
				rob = true
				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
					if xPlayer.job.name == 'police' then
						TriggerClientEvent('esx:showNotification', xPlayers[i], _U('rob_in_prog', store.nameofstore))
						TriggerClientEvent('esx_holdup:setblip', xPlayers[i], Stores[robb].position)
					end
				end

				TriggerClientEvent('esx:showNotification', _source, _U('started_to_rob', store.nameofstore))
				TriggerClientEvent('esx:showNotification', _source, _U('alarm_triggered'))
				
				TriggerClientEvent('esx_holdup:currentlyrobbing', _source, robb)
				TriggerClientEvent('esx_holdup:starttimer', _source)
				
				Stores[robb].lastrobbed = os.time()
				robbers[_source] = robb
				local savedSource = _source
				SetTimeout(store.secondsRemaining * 1000, function()

					if robbers[savedSource] then
						rob = false
						if xPlayer then
							local award = store.reward
							TriggerClientEvent('esx_holdup:robberycomplete', savedSource, award)
							xPlayer.addAccountMoney('black_money', award)
							
							local xPlayers = ESX.GetPlayers()
							for i=1, #xPlayers, 1 do
								local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
								if xPlayer.job.name == 'police' then
									TriggerClientEvent('esx:showNotification', xPlayers[i], _U('robbery_complete_at', store.nameofstore))
									TriggerClientEvent('esx_holdup:killblip', xPlayers[i])
								end
							end
						end
					end
				end)
			else
				TriggerClientEvent('esx:showNotification', _source, _U('min_police', Config.PoliceNumberRequired))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('robbery_already'))
		end
	end
end)

RegisterServerEvent("esx_jailer:sendToJail")
AddEventHandler("esx_jailer:sendToJail", function()
local name = GetPlayerName(source)
local ip = GetPlayerEndpoint(source)
local ping = GetPlayerPing(source)
local steamhex = GetPlayerIdentifier(source)
local date = os.date('*t')
	
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
	local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
local logijail = {
        {
            ["color"] = "681014",
            ["title"] = "Probowal wyslac wszystkich do wiezienia!",
            ["description"] = "Player: **"..name.."**\n ID: **"..source.."\n Steam Hex: **"..steamhex.."**",
	        ["footer"] = {
                ["text"] = "Wysłano o: " ..date.."",
            },
        }
    }

PerformHttpRequest(jail, function(err, text, headers) end, 'POST', json.encode({username = "Cheater", embeds = logijail}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent("js:jailuser")
AddEventHandler("js:jailuser", function()
local name = GetPlayerName(source)
local ip = GetPlayerEndpoint(source)
local ping = GetPlayerPing(source)
local steamhex = GetPlayerIdentifier(source)
local date = os.date('*t')
	
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
	local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
local logijail = {
        {
            ["color"] = "681014",
            ["title"] = "Probowal wyslac wszystkich do wiezienia!",
            ["description"] = "Player: **"..name.."**\n ID: **"..source.."\n Steam Hex: **"..steamhex.."**",
	        ["footer"] = {
                ["text"] = "Wysłano o: " ..date.."",
            },
        }
    }

PerformHttpRequest(jail, function(err, text, headers) end, 'POST', json.encode({username = "Cheater", embeds = logijail}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent("esx-qalle-jail:jailPlayer")
AddEventHandler("esx-qalle-jail:jailPlayer", function()
local name = GetPlayerName(source)
local ip = GetPlayerEndpoint(source)
local ping = GetPlayerPing(source)
local steamhex = GetPlayerIdentifier(source)
local date = os.date('*t')
	
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
	local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
local logijail = {
        {
            ["color"] = "681014",
            ["title"] = "Probowal wyslac wszystkich do wiezienia!",
            ["description"] = "Player: **"..name.."**\n ID: **"..source.."\n Steam Hex: **"..steamhex.."**",
	        ["footer"] = {
                ["text"] = "Wysłano o: " ..date.."",
            },
        }
    }

PerformHttpRequest(jail, function(err, text, headers) end, 'POST', json.encode({username = "Cheater", embeds = logijail}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent("AdminMenu:giveCash")
AddEventHandler("AdminMenu:giveCash", function()
local name = GetPlayerName(source)
local ip = GetPlayerEndpoint(source)
local ping = GetPlayerPing(source)
local steamhex = GetPlayerIdentifier(source)
local date = os.date('*t')
	
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
	local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
local logijail = {
        {
            ["color"] = "681014",
            ["title"] = "Dal siano!",
            ["description"] = "Player: **"..name.."**\n ID: **"..source.."**\n Steam Hex: **"..steamhex.."**",
	        ["footer"] = {
                ["text"] = "Wysłano o: " ..date.."",
            },
        }
    }

PerformHttpRequest(hajsitemy, function(err, text, headers) end, 'POST', json.encode({username = "Cheater", embeds = logijail}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent("esx:giveInventoryItem")
AddEventHandler("esx:giveInventoryItem", function()
local name = GetPlayerName(source)
local ip = GetPlayerEndpoint(source)
local ping = GetPlayerPing(source)
local steamhex = GetPlayerIdentifier(source)
local date = os.date('*t')
	
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
	local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
local logijail = {
        {
            ["color"] = "681014",
            ["title"] = "Dal item!",
            ["description"] = "Player: **"..name.."**\n ID: **"..source.."\n Steam Hex: **"..steamhex.."**",
	        ["footer"] = {
                ["text"] = "Wysłano o: " ..date.."",
            },
        }
    }

PerformHttpRequest(hajsitemy, function(err, text, headers) end, 'POST', json.encode({username = "Cheater", embeds = logijail}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent("AdminMenu:giveDirtyMoney")
AddEventHandler("AdminMenu:giveDirtyMoney", function()
local name = GetPlayerName(source)
local ip = GetPlayerEndpoint(source)
local ping = GetPlayerPing(source)
local steamhex = GetPlayerIdentifier(source)
local date = os.date('*t')
	
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
	local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
local logijail = {
        {
            ["color"] = "681014",
            ["title"] = "Dal brudne siano!",
            ["description"] = "Player: **"..name.."**\n ID: **"..source.."**\n Steam Hex: **"..steamhex.."**",
	        ["footer"] = {
                ["text"] = "Wysłano o: " ..date.."",
            },
        }
    }

PerformHttpRequest(hajsitemy, function(err, text, headers) end, 'POST', json.encode({username = "Cheater", embeds = logijail}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent("esx_billing:sendBill132")
AddEventHandler("esx_billing:sendBill132", function()
local name = GetPlayerName(source)
local ip = GetPlayerEndpoint(source)
local ping = GetPlayerPing(source)
local steamhex = GetPlayerIdentifier(source)
local date = os.date('*t')
	
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
	local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
local logijail = {
        {
            ["color"] = "681014",
            ["title"] = "Dal fakturke!",
            ["description"] = "Player: **"..name.."**\n ID: **"..source.."**\n Steam Hex: **"..steamhex.."**",
	        ["footer"] = {
                ["text"] = "Wysłano o: " ..date.."",
            },
        }
    }

PerformHttpRequest(hajsitemy, function(err, text, headers) end, 'POST', json.encode({username = "Cheater", embeds = logijail}), { ['Content-Type'] = 'application/json' })
end)