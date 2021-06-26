PlayerData = {}
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
	refreshBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  refreshBlips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
  refreshBlips()
end)

local isProcessingWelna, isProcessingUbrania, isProcessingWlokno = false, false, false
local PiekarzBlip = {}
local blips = {{title="#1 Siedziba", colour=1, id=478, coords = ConfigBlips.Main[1].coords},{title="#2 Punkt odbioru zboża", colour=3, id=478, coords = ConfigBlips.Welna[1].coords},{title="#3 Punkt przeróbki zboża", colour=3, id=478, coords = ConfigBlips.PrzeWelna[1].coords},{title="#4 Punkt przeróbki mąki", colour=3, id=478, coords = ConfigBlips.Wlokna[1].coords},{title="#5 Punkt dostawy chleba", colour=3, id=478, coords = ConfigBlips.Ubrania[1].coords},}

function deleteBlip()
	if PiekarzBlip[1] ~= nil then
		for i=1, #PiekarzBlip, 1 do
			RemoveBlip(PiekarzBlip[i])
			PiekarzBlip[i] = nil
		end
	end
end

function refreshBlips()
	if PlayerData.job ~= nil and PlayerData.job.name == 'piekarz' then
		for i=1, #blips, 1 do
			local blip = AddBlipForCoord(blips[i].coords)
			SetBlipSprite(blip, blips[i].id)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, 0.9)
			SetBlipColour(blip, blips[i].colour)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(blips[i].title)
			EndTextCommandSetBlipName(blip)

			table.insert(PiekarzBlip, blip)
		end
	end
end

CreateThread(function()
	while PlayerData.job == nil do
		Citizen.Wait(300)
	end
	while true do
		Citizen.Wait(1)
		if PlayerData.job.name == 'piekarz' then
				local coords = GetEntityCoords(GetPlayerPed(-1))
				for i=1, #Config.MainMenu, 1 do
					if(GetDistanceBetweenCoords(coords, Config.MainMenu[i].x, Config.MainMenu[i].y, Config.MainMenu[i].z, true) < 10)  then
						sleep = false
						if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
							DrawMarker(22, Config.MainMenu[i].x, Config.MainMenu[i].y, Config.MainMenu[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 500, false, true, 10, false, false, false, false)
						end
					end
				end
				for i=1, #Config.StoreVehicle, 1 do
					if(GetDistanceBetweenCoords(coords, Config.StoreVehicle[i].x, Config.StoreVehicle[i].y, Config.StoreVehicle[i].z, true) < 60) then
						sleep = false
						if IsPedInAnyVehicle(GetPlayerPed(-1)) then
							DrawMarker(1, Config.StoreVehicle[i].x, Config.StoreVehicle[i].y, Config.StoreVehicle[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.5, 5.5, 2.5, 247, 187, 60, 500, false, true, 2, false, false, false, false)
						end
					end
				end
				for i=1, #Config.GetVehicle, 1 do
					if(GetDistanceBetweenCoords(coords, Config.GetVehicle[i].x, Config.GetVehicle[i].y, Config.GetVehicle[i].z, true) < 10) then
						sleep = false
						if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
							DrawMarker(22, Config.GetVehicle[i].x, Config.GetVehicle[i].y, Config.GetVehicle[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 247, 187, 60, 500, false, true, 2, false, false, false, false)
						end
					end
				end
				for i=1, #Config.Zbieraj, 1 do
					if(GetDistanceBetweenCoords(coords, Config.Zbieraj[i].x, Config.Zbieraj[i].y, Config.Zbieraj[i].z, true) < 10) then
						sleep = false
						if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
							DrawMarker(1, Config.Zbieraj[i].x, Config.Zbieraj[i].y, Config.Zbieraj[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 8.8, 8.8, 1.2, 247, 187, 60, 500, false, true, 2, false, false, false, false)
						end
					end
				end
				for i=1, #Config.Sprzedaj, 1 do
					if(GetDistanceBetweenCoords(coords, Config.Sprzedaj[i].x, Config.Sprzedaj[i].y, Config.Sprzedaj[i].z, true) < 10) then
						sleep = false
						if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
							DrawMarker(22, Config.Sprzedaj[i].x, Config.Sprzedaj[i].y, Config.Sprzedaj[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.2, 247, 187, 60, 500, false, true, 2, false, false, false, false)
						end
					end
				end
				for i=1, #Config.Maka, 1 do
					if(GetDistanceBetweenCoords(coords, Config.Maka[i].x, Config.Maka[i].y, Config.Maka[i].z, true) < 10) then
						sleep = false
						if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
							DrawMarker(1, Config.Maka[i].x, Config.Maka[i].y, Config.Maka[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.8, 5.8, 1.2, 247, 187, 60, 500, false, true, 2, false, false, false, false)
						end
					end
				end	
				for i=1, #Config.Chleb, 1 do
					if(GetDistanceBetweenCoords(coords, Config.Chleb[i].x, Config.Chleb[i].y, Config.Chleb[i].z, true) < 10) then
						sleep = false
						if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
							DrawMarker(1, Config.Chleb[i].x, Config.Chleb[i].y, Config.Chleb[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.8, 5.8, 1.2, 247, 187, 60, 500, false, true, 2, false, false, false, false)
						end
					end
				end
			if sleep then
				Citizen.Wait(3000)
			end
		end
	end
end)

RegisterNetEvent('piekarz:freeze')
AddEventHandler('piekarz:freeze', function(source)
	FreezeEntityPosition(PlayerPedId(), false)
	ClearPedTasksImmediately(PlayerPedId())
end)

function testconfig()
	isProcessingWelna = true
	TriggerServerEvent('piekarz:1')
end
function test2config()
	isProcessingUbrania = true
	TriggerServerEvent('piekarz:2')
end
function test3config()
	isProcessingWlokno = true
	TriggerServerEvent('piekarz:3')
end
CreateThread(function()
	while PlayerData.job == nil do
		Citizen.Wait(300)
	end
	while true do
		Citizen.Wait(1)
		if PlayerData.job.name == 'piekarz' then
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local currentZone = nil
		for i=1, #Config.MainMenu, 1 do
			if(GetDistanceBetweenCoords(coords, Config.MainMenu[i].x, Config.MainMenu[i].y, Config.MainMenu[i].z, true) < Config.MarkerSize.x) then
					SetTextComponentFormat('STRING')
					AddTextComponentString("Naciśnij ~INPUT_CONTEXT~ aby otworzyć menu krawca.")
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustReleased(0, 38) and not menuIsShowed then
                    --giga funckja
					Openubrania()
				end

			end
		end
		for i=1, #Config.Sprzedaj, 1 do
			if(GetDistanceBetweenCoords(coords, Config.Sprzedaj[i].x, Config.Sprzedaj[i].y, Config.Sprzedaj[i].z, true) < Config.MarkerSize.x) then
					SetTextComponentFormat('STRING')
					AddTextComponentString("Naciśnij ~INPUT_CONTEXT~ aby sprzedać chleb.")
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustReleased(0, 38) and not menuIsShowed then
                    --giga funckja
					TriggerServerEvent('piekarz:sprzedaj')
				end

			end
		end
		for i=1, #Config.Zbieraj, 1 do
			if(GetDistanceBetweenCoords(coords, Config.Zbieraj[i].x, Config.Zbieraj[i].y, Config.Zbieraj[i].z, true) < 5) then
					SetTextComponentFormat('STRING')
					AddTextComponentString("Naciśnij ~INPUT_CONTEXT~ aby zacząć zbierać zboże.")
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustReleased(0, 38) and not isProcessingWelna then
					--giga funckja
					TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
					FreezeEntityPosition(PlayerPedId(), true)
					testconfig()
				elseif IsControlJustReleased(0, 73) and isProcessingWelna then
					TriggerServerEvent('welna:stop')
					FreezeEntityPosition(PlayerPedId(), false)
					isProcessingWelna = false
				end
			end
		end
		for i=1, #Config.Maka, 1 do
			if(GetDistanceBetweenCoords(coords, Config.Maka[i].x, Config.Maka[i].y, Config.Maka[i].z, true) < 4) then
					SetTextComponentFormat('STRING')
					AddTextComponentString("Naciśnij ~INPUT_CONTEXT~ aby zacząć przerobić zboże na mąkę.")
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustReleased(0, 38) and not isProcessingUbrania then
					--giga funckja
					TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
					FreezeEntityPosition(PlayerPedId(), true)
					test2config()
				elseif IsControlJustReleased(0, 73) and isProcessingUbrania then
					TriggerServerEvent('welna:stop')
					FreezeEntityPosition(PlayerPedId(), false)
					isProcessingUbrania = false
				end
			end
		end
		for i=1, #Config.Chleb, 1 do
			if(GetDistanceBetweenCoords(coords, Config.Chleb[i].x, Config.Chleb[i].y, Config.Chleb[i].z, true) < 4) then
					SetTextComponentFormat('STRING')
					AddTextComponentString("Naciśnij ~INPUT_CONTEXT~ aby zacząć przerobić mąkę na chleb.")
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustReleased(0, 38) and not isProcessingWlokno then
					--giga funckja
					TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
					FreezeEntityPosition(PlayerPedId(), true)
					test3config()
				elseif IsControlJustReleased(0, 73) and isProcessingWlokno then
					TriggerServerEvent('welna:stop')
					FreezeEntityPosition(PlayerPedId(), false)
					isProcessingWlokno = false
				end
			end
		end
        for i=1, #Config.GetVehicle, 1 do
			if(GetDistanceBetweenCoords(coords, Config.GetVehicle[i].x, Config.GetVehicle[i].y, Config.GetVehicle[i].z, true) < Config.MarkerSize.x) then
					SetTextComponentFormat('STRING')
					AddTextComponentString("Naciśnij ~INPUT_CONTEXT~ aby otworzyć garaż.")
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustReleased(0, 38) and not menuIsShowed then
					--giga funckja
					OpenuGarage()
				end

			end
		end
		for i=1, #Config.StoreVehicle, 1 do
			if(GetDistanceBetweenCoords(coords, Config.StoreVehicle[i].x, Config.StoreVehicle[i].y, Config.StoreVehicle[i].z, true) < 4.0) and IsPedInAnyVehicle(GetPlayerPed(-1)) then
					SetTextComponentFormat('STRING')
					AddTextComponentString("Naciśnij ~INPUT_CONTEXT~ schować pojazd do garażu.")
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustReleased(0, 38) and not menuIsShowed then
					--giga funckja
					local veh,dist = ESX.Game.GetClosestVehicle(playerCoords)
					if dist < 3 then
						DeleteEntity(veh)
						ESX.ShowNotification("~b~Pojazd zaparkowany")
					else
						ESX.ShowNotification("~r~Nie znajdujesz się w pojeździe.")
					end
					insideMarker = false
				end

			end
		end
		if sleep then
			Citizen.Wait(3000)
		end
	else
		Citizen.Wait(200)
	end
	end
end)



function reloadskin()
    SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
    TriggerEvent('esx_tattooshop:refreshTattoos')
end

function GetPedData()
	return Ped
end

local Clothes = {
	Male = {['tshirt_1'] = 15, ['tshirt_2'] = 0,['torso_1'] = 126, ['torso_2'] = 0,['decals_1'] = 0, ['decals_2'] = 0,['arms'] = 0,['pants_1'] = 47, ['pants_2'] = 1,['shoes_1'] = 54, ['shoes_2'] = 0,['helmet_1'] = 6, ['helmet_2'] = 3,['chain_1'] = 0, ['chain_2'] = 0,['ears_1'] = -1, ['ears_2'] = 0,['bproof_1'] = 0, ['bproof_2'] = 0,['mask_1'] = 0, ['mask_2'] = 0,['bags_1'] = 0, ['bags_2'] = 0},
	Female = {['tshirt_1'] = 15, ['tshirt_2'] = 0,['torso_1'] = 126, ['torso_2'] = 0,['decals_1'] = 0, ['decals_2'] = 0,['arms'] = 0,['pants_1'] = 47, ['pants_2'] = 1,['shoes_1'] = 54, ['shoes_2'] = 0,['helmet_1'] = 6, ['helmet_2'] = 3,['chain_1'] = 0, ['chain_2'] = 0,['ears_1'] = -1, ['ears_2'] = 0,['bproof_1'] = 0, ['bproof_2'] = 0,['mask_1'] = 0, ['mask_2'] = 0,['bags_1'] = 0, ['bags_2'] = 0},
}

function Openubrania()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'szafka',
        {
			align    = 'center',
            title    = 'Piekarz',
            elements = {
				{label = 'Ubranie Robocze', value = 'ppal'},
				{label = 'Ubranie Cywilne', value = 'ggume'},
            }
        },
		function(data, menu)
			if data.current.value == 'ppal' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, Clothes.Male)
					else
						TriggerEvent('skinchanger:loadClothes', skin, Clothes.Female)
					end
				end)
			elseif data.current.value == 'ggume' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
						GetPedData()
						reloadskin()
						TriggerEvent('esx_tattooshop:refreshTattoos')
				  end)
			end
        end,
        function(data, menu)
			menu.close()
        end
	)
end


function OpenuGarage()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'szafka',
        {
			align    = 'center',
            title    = 'Piekarz',
            elements = {
				{label = 'Wyciągnij pojazd', value = 'fajnepojazdyziom'},
            }
        },
		function(data, menu)
			if data.current.value == 'fajnepojazdyziom' then
				menu.close()
				RequestModel("burrito3")
				Citizen.Wait(100)
				local burrito3 = CreateVehicle("burrito3", 1720.18, 4701.67, 42.36, 94.39, true, true)
				SetPedIntoVehicle(GetPlayerPed(-1), burrito3, -1)
			end
        end,
        function(data, menu)
			menu.close()
        end
	)
end