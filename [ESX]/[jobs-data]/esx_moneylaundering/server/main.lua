ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

 RegisterServerEvent('esx_godirtyjob:pay')
  AddEventHandler('esx_godirtyjob:pay', function(amount)
 	local _source = source
 	local xPlayer = ESX.GetPlayerFromId(_source)
 	if amount > 1 then
 		local money = xPlayer.getAccount('black_money').money
 		if money > amount or money == amount then
 			xPlayer.addMoney(tonumber(amount)) -- Add Clean Money
 			xPlayer.removeAccountMoney('black_money', amount) -- Removes Dirty Money
 			TriggerClientEvent('esx:showNotification', _source, "~g~Wyprałeś: $" ..amount)
		local _source = source
			local steamid = xPlayer.identifier
			local name = GetPlayerName(source)
			wiadomosc = "Przepral : "..money.."\n[ID: "..source.." | Nazwa Steam: "..name.." | ROCKSTAR: "..steamid.." ]" 
			givelicka('SativaRP.pl', wiadomosc, 11750815)
 		else
 			TriggerClientEvent('esx:showNotification', _source, "~r~Nie posiadasz brudnej gotówki...")
 		end
 		if money < amount then
 			local money = xPlayer.getAccount('black_money').money
 			xPlayer.addMoney(tonumber(money)) -- Add Clean Money
 			xPlayer.removeAccountMoney('black_money', money) -- Removes Dirty Money
 			TriggerClientEvent('esx:showNotification', _source, "~g~Wyprałeś ~w~swoją całą kasę: $" ..money)
			local _source = source
			local steamid = xPlayer.identifier
			local name = GetPlayerName(source)
			wiadomosc = "Przepral : "..money.."\n[ID: "..source.." | Nazwa Steam: "..name.." | ROCKSTAR: "..steamid.." ]" 
			givelicka('SativaRP.pl', wiadomosc, 11750815)
 			retourcamion_oui()
 			isJobTrucker = false
 		end
 	end
end)

function givelicka(hook,message,color)
	local gigafajnywebhook223 = 'https://discord.com/api/webhooks/838701514788175873/5nSCWnhuiylUaCxAx-Ytynpa8KIOssp0fNxYhYvA_FlrfMrTshPDbbGOXYGKaGm80AcH'
	local embeds = {
				{
			["title"] = message,
			["type"] = "rich",
			["color"] = color,
			["footer"] = {
				["text"] = 'SativaRP.pl'
					},
				}
			}
	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(gigafajnywebhook223, function(err, text, headers) end, 'POST', json.encode({ username = hook,embeds = embeds}), { ['Content-Type'] = 'application/json' })
  end