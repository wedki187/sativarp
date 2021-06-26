local nazwaNarkotyku1 = 'weed_pooch'
local nazwaNarkotyku2 = 'coke_pooch'
local nazwaNarkotyku3 = 'meth_pooch'
local nazwaNarkotyku4 = 'opium_pooch'

local wynagrodzenieWeed = math.random(1000, 1200) --<< zakres wynagrodzenia za 1 sztuke narkotyku nr.1 (weed) | Domyslnie: od 200 - 400$ brudnego
local wynagrodzenieCoke = math.random(6000, 7000) --<< zakres wynagrodzenia za 1 sztuke narkotyku nr.2 (coke) | Domyslnie: od 400 - 600$ brudnego
local wynagrodzenieMeth = math.random(2000, 4000) --<< zakres wynagrodzenia za 1 sztuke narkotyku nr.3 (meth) | Domyslnie: od 600 - 800$ brudnego
local wynagrodzenieOpium = math.random(2000, 3000) --<< zakres wynagrodzenia za 1 sztuke narkotyku nr.4 (opium) | Domyslnie: od 600 - 800$ brudnego

local waitingForClient = 0

function sendToDiscord (name,message,color)
    local DiscordWebHook = "https://discord.com/api/webhooks/842029417467215873/HOWaIoDTNj0KPt1v3RpDuuwR_4JgZNj39OYo3t_02I2BO5j4SbWiiQN6yG1fzIJJTpG3"

  local embeds = {
      {
          ["title"]=message,
          ["type"]="rich",
          ["color"] =color,
          ["footer"]=  {
              ["text"]= "SPRZEDAZ NARKO",
         },
      }
  }

    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)


RegisterCommand('sprzedajnarko', function(source, rawCommand)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local Iweed = xPlayer.getInventoryItem(nazwaNarkotyku1).count
	local Icoke = xPlayer.getInventoryItem(nazwaNarkotyku2).count
	local Imeth = xPlayer.getInventoryItem(nazwaNarkotyku3).count

	local copsOnDuty = 0
    local Players = ESX.GetPlayers()

    for i = 1, #Players do
        local xPlayer = ESX.GetPlayerFromId(Players[i])

        if xPlayer["job"]["name"] == "police" then
            copsOnDuty = copsOnDuty + 1
        end
    end

    if copsOnDuty < 1 then
	TriggerClientEvent('esx:showNotification', _source, '~r~Potrzeba przynajmniej 2 LSPD.')
	Citizen.Wait(5000)
	print("WAIT")
	return
    end
	
	if waitingForClient == 1 then
	Citizen.Wait(5000)
	print("WAIT")
	TriggerClientEvent('esx:showNotification', _source, '~r~Jesteś już umówiony z klientem.')
        return
	end
	
	if Iweed > 4 then
	TriggerClientEvent("tostdrugs:getcustomer", _source)
	waitingForClient = 0
	elseif Icoke > 4 then
	TriggerClientEvent("tostdrugs:getcustomer", _source)
	waitingForClient = 1
	elseif Imeth > 4 then
	TriggerClientEvent("tostdrugs:getcustomer", _source)
	waitingForClient = 1
	else
	TriggerClientEvent('esx:showNotification', _source, '~r~Nie masz przy sobie żadnego narkotyku na sprzedaż.')
	Citizen.Wait(5000)
	print("WAIT")
	end
	
end)

RegisterServerEvent('tostdrugs:udanyzakup')
AddEventHandler('tostdrugs:udanyzakup', function(x, y, z)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = GetPlayerName(source)
    local Iweed = xPlayer.getInventoryItem(nazwaNarkotyku1).count
	local Icoke = xPlayer.getInventoryItem(nazwaNarkotyku2).count
	local Imeth = xPlayer.getInventoryItem(nazwaNarkotyku3).count
	
	local niezadowolenie = math.random(1,100)
	
	if niezadowolenie <= 5 then --<< 3% szans ze klient będzie niezadowolony i zwróci towar i nie zapłaci
	TriggerClientEvent('esx:showNotification', _source, '~r~Co to za gówno? Oczekiwałem dobrego towaru a to jakis syf, zabieraj to oszuście.')
	Citizen.Wait(5000)
	print("WAIT")
	waitingForClient = 0
	return
	end
	
	
	if Iweed > 4 then
	TriggerClientEvent('esx:showNotification', _source, '~g~Skutecznie sprzedajesz ~y~marihuanę~g~ za ~y~'..(wynagrodzenieWeed*5)..'$')
	xPlayer.removeInventoryItem(nazwaNarkotyku1, 5)
	xPlayer.addAccountMoney('black_money', (wynagrodzenieWeed)*5)
	sendToDiscord (('tostdrugs:udanyzakup'), "Gracz " .. identifier .. " " .. " sprzedal ".. nazwaNarkotyku1 .." licka gracza: " .. xPlayer.identifier .. " i zarobil " ..(wynagrodzenieWeed*5).. "$") 
	waitingForClient = 0
	elseif Icoke > 4 then
	TriggerClientEvent('esx:showNotification', _source, '~g~Skutecznie sprzedajesz ~y~kokainę~g~ za ~y~'..(wynagrodzenieCoke*5)..'$')
	xPlayer.removeInventoryItem(nazwaNarkotyku2, 5)
	xPlayer.addAccountMoney('black_money', (wynagrodzenieCoke*5))
	sendToDiscord (('tostdrugs:udanyzakup'), "Gracz " .. identifier .. " " .. " sprzedal ".. nazwaNarkotyku2 .." licka gracza: " .. xPlayer.identifier .. " i zarobil " ..(wynagrodzenieCoke*5).. "$") 
	waitingForClient = 0
	elseif Imeth > 4 then
	TriggerClientEvent('esx:showNotification', _source, '~g~Skutecznie sprzedajesz ~y~amfetaminę~g~ za ~y~'..(wynagrodzenieMeth*5)..'$')
	xPlayer.removeInventoryItem(nazwaNarkotyku3, 5)
	xPlayer.addAccountMoney('black_money', (wynagrodzenieMeth)*5)
	sendToDiscord (('tostdrugs:udanyzakup'), "Gracz " .. identifier .. " " .. " sprzedal ".. nazwaNarkotyku3 .." licka gracza: " .. xPlayer.identifier .. " i zarobil " ..(wynagrodzenieMeth*5).. "$") 
	waitingForClient = 0
	elseif Iopium > 4 then
	TriggerClientEvent('esx:showNotification', _source, '~g~Skutecznie sprzedajesz ~y~opium~g~ za ~y~'..(wynagrodzenieOpium*5)..'$')
	xPlayer.removeInventoryItem(nazwaNarkotyku4, 5)
	xPlayer.addAccountMoney('black_money', (wynagrodzenieOpium)*5)
	waitingForClient = 0
	else
	TriggerClientEvent('esx:showNotification', _source, '~r~Nie masz nic na sprzedaż po co to ogłoszenie oszuście?!')
	waitingForClient = 0
	end
	
	
	local infoPsy = math.random(1,100)
	
	if infoPsy <= 100 then --<< 30% ze zostanie wezwana policja
	TriggerClientEvent('tostdrugs:infoPolicja', -1, x, y, z)
	Wait(500)
	end
	
end)


RegisterServerEvent('tostdrugs:clientpassed')
AddEventHandler('tostdrugs:clientpassed', function()
waitingForClient = 0
end)