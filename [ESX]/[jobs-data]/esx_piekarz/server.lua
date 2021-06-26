ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

PlayerZbieranie1, PlayerPrzerabianieMaka, PlayerPrzerabianieChleb = {}, {}, {}

function Zbieraj1(source)
    SetTimeout(1, function()
        if PlayerZbieranie1[source] == true then 
            local _source = source
            local xPlayer = ESX.GetPlayerFromId(_source)
            local ezz   = xPlayer.getInventoryItem('zboze')   
            if ezz.limit ~= -1 and ezz.count >= ezz.limit then 
                TriggerClientEvent('krawiec:freeze', source)
                TriggerClientEvent('esx:showNotification', source, 'Masz już przy sobie wystarczająco zboża.')
            else
                Citizen.Wait(5000)
                xPlayer.addInventoryItem('zboze', 1)
                Zbieraj1(source)
            end
        end
    end)
end
function PrzerabiajMaka(source)
    SetTimeout(1, function()
        if PlayerPrzerabianieMaka[source] == true then 
            local _source = source
            local xPlayer = ESX.GetPlayerFromId(_source)
            local ezz   = xPlayer.getInventoryItem('maka')   
                if ezz.limit ~= -1 and ezz.count >= ezz.limit then 
                    TriggerClientEvent('krawiec:freeze', source)
                    TriggerClientEvent('esx:showNotification', source, 'Masz już przy sobie wystarczająco mąki.')
                else
                    if xPlayer.getInventoryItem('zboze').count >= 3 then
                        xPlayer.removeInventoryItem('zboze', 3)
                        xPlayer.addInventoryItem('maka', 1)
                        Citizen.Wait(3000)
                        PrzerabiajMaka(source)
                    else
                        TriggerClientEvent('krawiec:freeze', source)
                        TriggerClientEvent('esx:showNotification', source, 'Nie posiadasz przy sobie wystarczającęj ilości zboża.')
                    end
                end
        end
    end)
end

function PrzerabiajChleb(source)
    SetTimeout(1, function()
        if PlayerPrzerabianieChleb[source] == true then 
            local _source = source
            local xPlayer = ESX.GetPlayerFromId(_source)
            local ezz   = xPlayer.getInventoryItem('chleb')   
                if ezz.limit ~= -1 and ezz.count >= ezz.limit then 
                    TriggerClientEvent('krawiec:freeze', source)
                    TriggerClientEvent('esx:showNotification', source, 'Masz już przy sobie wystarczająco chleba.')
                else
                    if xPlayer.getInventoryItem('maka').count >= 2 then
                        xPlayer.removeInventoryItem('maka', 2)
                        xPlayer.addInventoryItem('chleb', 1)
                        Citizen.Wait(1000)
                        PrzerabiajChleb(source)
                    else
                        TriggerClientEvent('krawiec:freeze', source)
                        TriggerClientEvent('esx:showNotification', source, 'Nie posiadasz przy sobie wystarczającęj ilości mąki.')
                    end
                end
        end
    end)
end
RegisterNetEvent('welna:stop')
AddEventHandler('welna:stop', function()
    local _source = source
    PlayerZbieranie1[_source] = false
    PlayerPrzerabianieMaka[_source] = false
    PlayerPrzerabianieChleb[_source] = false

end)
RegisterNetEvent('piekarz:2')
AddEventHandler('piekarz:2', function()
    local _source = source
    PlayerPrzerabianieMaka[_source] = true
    PrzerabiajMaka(source)
end)
RegisterServerEvent('piekarz:1')
AddEventHandler('piekarz:1', function()
    local _source = source
    PlayerZbieranie1[_source] = true
    Zbieraj1(_source)
end)
RegisterServerEvent('piekarz:3')
AddEventHandler('piekarz:3', function()
    local _source = source
    PlayerPrzerabianieChleb[_source] = true
    PrzerabiajChleb(_source)
end)

RegisterNetEvent('piekarz:sprzedaj')
AddEventHandler('piekarz:sprzedaj', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem('chleb').count == 25 then
        xPlayer.removeInventoryItem('chleb', 25)
        local zaplata = 50000
        xPlayer.addMoney(zaplata)
        TriggerClientEvent('esx:showNotification', source, 'Otrzymano: $'..zaplata)
    else
        TriggerClientEvent('esx:showNotification', source, 'Nie posiadasz przy sobie wystarczającej ilości chleba.')
    end
end)