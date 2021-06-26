local Keys = {
	["ESC"] = 322, ["BACKSPACE"] = 177, ["E"] = 38, ["ENTER"] = 18,	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173
}

local menuIsShowed 				 = false
local hasAlreadyEnteredMarker 	 = false
local lastZone 					 = nil
local isInJoblistingMarker 		 = false

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function ShowJobListingMenuMain(data)
	ESX.TriggerServerCallback('esx_department:getJobsList', function(data)
		local jobelements = {}
		for i = 1, #data, 1 do
			table.insert(
				jobelements,
				{label = data[i].label, value = data[i].value}
			)
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'joblisting',
		{
			title    = _U('job_center'),
			align    = 'center',
			elements = {
				{label = 'Wybierz Pracę', value = 'jobs'},
				{label = 'Wykaz Mieszkańców', value = 'players'},
				{label = 'Opłać Faktury', value = 'billing'},
				{label = 'Zarządzanie Garażem', value = 'garages'},
				{label = 'Zarządzanie Nieruchomościami', value = 'OpenSubownerMenu'},
			}
		}, function(data, menu)
		if data.current.value == 'jobs' then
			ShowJobListingMenu()
		elseif data.current.value == 'billing' then
			menu.close()
			TriggerEvent('esx_department:showbills')
		elseif data.current.value == 'garages' then
			menu.close()
			--TriggerEvent('esx:showNotification', 'Aby wyświetlić opcje garażu, podaj numer tablicy rejestracyjnej!')
			--TriggerEvent('esx_department:SetSubowner')
			--exports['arivi_garages']:OpenSellCarMenu()
			garages()
		elseif data.current.value == 'OpenSubownerMenu' then
			exports['esx_property']:OpenSubownerMenu()
		elseif data.current.value == 'players' then
			OpenPlayersMenu()
		end
		end, function(data, menu)
			menu.close()
		end)

	end)
end

function garages(data)
		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'joblisting',
		{
			title    = _U('job_center'),
			align    = 'center',
			elements = {
				{label = 'Wyświetl menu zarządzania pojazdami', value = 'gigga'},
				{label = 'Wystaw umowę sprzedaży pojazdu', value = 'nigga'},
			}
		}, function(data, menu)
		if data.current.value == 'gigga' then
			TriggerEvent('esx:showNotification', 'Aby wyświetlić opcje garażu, podaj numer tablicy rejestracyjnej!')
			TriggerEvent('esx_department:SetSubowner')
		elseif data.current.value == 'nigga' then
			exports['sativa_garages']:OpenSellCarMenu()
		end
		end, function(data, menu)
			ShowJobListingMenuMain(data)
		end)
end

function OpenPlayersMenu(data)
	local all = exports['esx_scoreboard']:BierFrakcje('players')
	local police = exports['esx_scoreboard']:BierFrakcje('police')
	local ambulance = exports['esx_scoreboard']:BierFrakcje('ambulance')
	local cardealer = exports['esx_scoreboard']:BierFrakcje('cardealer')
	local taxi = exports['esx_scoreboard']:BierFrakcje('taxi')
	local lsc = exports['esx_scoreboard']:BierFrakcje('mecano')

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'joblisting',
		{
			title    = _U('job_center'),
			align    = 'center',
			elements = {
				{label = 'Obywateli w mieście:<span style="color: #00eeff;"> '..all, value = 'all'},
				{label = 'LSPD w mieście:<span style="color: #00eeff;">  '..police, value = 'all'},
				{label = 'EMS w mieście:<span style="color: #00eeff;">  '..ambulance, value = 'all'},
				{label = 'TAXI w mieście:<span style="color: #00eeff;">  '..taxi, value = 'all'},
				{label = 'LSC w mieście:<span style="color: #00eeff;">  '..lsc, value = 'all'},
				{label = 'BROKER w mieście:<span style="color: #00eeff;">  '..cardealer, value = 'all'},
			}
		}, function(data, menu)
		if data.current.value == 'all' then
			--print(all, police, ambulance)
		end
		end, function(data, menu)
			ShowJobListingMenuMain(data)
		end)
end


function ShowJobListingMenu(data)
	ESX.TriggerServerCallback('esx_department:getJobsList', function(data)
		local elements = {}
		for i = 1, #data, 1 do
			table.insert(
				elements,
				{label = data[i].label, value = data[i].value}
			)
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'joblisting',
		{
			title    = _U('job_center'),
			align    = 'center',
			elements = elements
		}, function(data, menu)
			TriggerServerEvent('esx_department:setJob', data.current.value)
			ESX.ShowNotification(_U('new_job'))
			menu.close()
		end, function(data, menu)
			menu.close()
		end)

	end)
end

AddEventHandler('esx_department:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for i=1, #Config.Zones, 1 do
			if(GetDistanceBetweenCoords(coords, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z, true) < Config.DrawDistance) then
				DrawMarker(Config.MarkerType, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		isInJoblistingMarker  = false
		local currentZone = nil
		for i=1, #Config.Zones, 1 do
			if(GetDistanceBetweenCoords(coords, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z, true) < Config.ZoneSize.x) then
				isInJoblistingMarker  = true
				SetTextComponentFormat('STRING')
				AddTextComponentString(_U('access_job_center'))
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			end
		end
		if isInJoblistingMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
		end
		if not isInJoblistingMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_department:hasExitedMarker')
		end
	end
end)


Citizen.CreateThread(function()
	for i=1, #Config.Zones, 1 do
		local blip = AddBlipForCoord(Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z)
		SetBlipSprite (blip, 498)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.8)
		SetBlipColour (blip, 3)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('job_center'))
		EndTextCommandSetBlipName(blip)
	end
end)

-- Menu Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if IsControlJustReleased(0, Keys['E']) and isInJoblistingMarker and not menuIsShowed then
			ShowJobListingMenuMain()
		end
	end
end)
