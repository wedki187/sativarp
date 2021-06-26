local GUI                     = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentGarage           = nil
local PlayerData              = {}
local CurrentAction           = nil
local IsInShopMenu            = false

local pCoords 				  = nil
ESX                           = nil
GUI.Time                      = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setHiddenJob')
AddEventHandler('esx:setHiddenJob', function(hiddenjob)
	PlayerData.hiddenjob = hiddenjob
end)

function getGridChunk(x, size)
	return math.floor((x + 8192) / size)
end

function getGridBase(x, size)
	return (x * 128) - size
end

function toChannel(v)
	return (v.x << 8) | v.y
end

function getZone(coords)
	return toChannel(vec2(getGridChunk(Config.Garages.x, 1536), getGridChunk(Config.Garages.y, 1536)))
end

-- Create Blips
Citizen.CreateThread(function()
	for i=1, #Config.Garages do
		if Config.Garages[i].Blip == true then
			local blip = AddBlipForCoord(Config.Garages[i].Marker)
			SetBlipSprite (blip, Config.Blip[1])
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.5)
			SetBlipColour (blip, 38)
			SetBlipAsShortRange(blip, true)		
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('garage_blip'))
			EndTextCommandSetBlipName(blip)
		end
	end
	for i=1, #Config.Impound, 1 do
		local blip2 = AddBlipForCoord(Config.Impound[i])
		SetBlipSprite (blip2, Config.Blip[2])
		SetBlipDisplay(blip2, 4)
		SetBlipScale  (blip2, 0.6)
		SetBlipColour (blip2, 1)
		SetBlipAsShortRange(blip2, true)		
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('impound_blip'))
		EndTextCommandSetBlipName(blip2)
	end

end)

--RegisterCommand('garageblips', function(source, args, raw) creategaragesblip() end)


Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		pCoords = GetEntityCoords(playerPed)
		Citizen.Wait(400)
	end
end)

RegisterNetEvent('esx_giveownedcar:spawnVehicle')
AddEventHandler('esx_giveownedcar:spawnVehicle', function(model, playerID, playerName, type)
	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)
	local carExist  = false

	ESX.Game.SpawnVehicle(model, coords, 0.0, function(vehicle) --get vehicle info
		if DoesEntityExist(vehicle) then
			carExist = true
			SetEntityVisible(vehicle, false, false)
			SetEntityCollision(vehicle, false)
			
			local newPlate     = exports.esx_vehicleshop:GeneratePlate()
			local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
			vehicleProps.plate = newPlate
			TriggerServerEvent('esx_giveownedcar:setVehicle', vehicleProps, playerID)
			ESX.Game.DeleteVehicle(vehicle)	
			if type ~= 'console' then
				ESX.ShowNotification(_U('gived_car', model, newPlate, playerName))
			else
				local msg = ('addCar: ' ..model.. ', plate: ' ..newPlate.. ', toPlayer: ' ..playerName)
				TriggerServerEvent('esx_giveownedcar:printToConsole', msg)
			end				
		end		
	end)
	
	Wait(1000)
	if not carExist then
		if type ~= 'console' then
			ESX.ShowNotification(_U('unknown_car'))
		else
			TriggerServerEvent('esx_giveownedcar:printToConsole', "ERROR: unknown car")
		end		
	end
end)

RegisterNetEvent('esx_giveownedcar:spawnVehiclePlate')
AddEventHandler('esx_giveownedcar:spawnVehiclePlate', function(model, plate, playerID, playerName, type)
	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)
	local generatedPlate = string.upper(plate)
	local carExist  = false

	ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function (isPlateTaken)
		if not isPlateTaken then
			ESX.Game.SpawnVehicle(model, coords, 0.0, function(vehicle) --get vehicle info	
				if DoesEntityExist(vehicle) then
					carExist = true
					SetEntityVisible(vehicle, false, false)
					SetEntityCollision(vehicle, false)	
					
					local newPlate     = string.upper(plate)
					local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
					vehicleProps.plate = newPlate
					TriggerServerEvent('esx_giveownedcar:setVehicle', vehicleProps, playerID)
					ESX.Game.DeleteVehicle(vehicle)
					if type ~= 'console' then
						ESX.ShowNotification(_U('gived_car',  model, newPlate, playerName))
					else
						local msg = ('addCar: ' ..model.. ', plate: ' ..newPlate.. ', toPlayer: ' ..playerName)
						TriggerServerEvent('esx_giveownedcar:printToConsole', msg)
					end				
				end
			end)
		else
			carExist = true
			if type ~= 'console' then
				ESX.ShowNotification(_U('plate_already_have'))
			else
				local msg = ('ERROR: this plate is already been used on another vehicle')
				TriggerServerEvent('esx_giveownedcar:printToConsole', msg)
			end					
		end
	end, generatedPlate)
	
	Wait(1000)
	if not carExist then
		if type ~= 'console' then
			ESX.ShowNotification(_U('unknown_car'))
		else
			TriggerServerEvent('esx_giveownedcar:printToConsole', "ERROR: unknown car")
		end		
	end	
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)


-- Display markers
Citizen.CreateThread(function()
	while PlayerData.job == nil or PlayerData.hiddenjob == nil do
		Citizen.Wait(100)
	end
	while true do
		Citizen.Wait(1)
		for i=1, #Config.Garages, 1 do
			if(GetDistanceBetweenCoords(pCoords, Config.Garages[i].Marker, true) < Config.DrawDistance) then
				if Config.Garages[i].Job[1] == nil then
					DrawMarker(Config.Marker[1], Config.Garages[i].Marker + 0.8, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				else
					for j=1, #Config.Garages[i].Job, 1 do
						if PlayerData.job.name == Config.Garages[i].Job[j] or PlayerData.hiddenjob.name == Config.Garages[i].Job[j] then
							DrawMarker(Config.Marker[1], Config.Garages[i].Marker, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
						end
					end
				end
			end
		end
		for i=1, #Config.Impound, 1 do
			if(GetDistanceBetweenCoords(pCoords, Config.Impound[i], true) < Config.DrawDistance) then
				DrawMarker(Config.Marker[1], Config.Impound[i] + 0.8, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColorImpound.r, Config.MarkerColorImpound.g, Config.MarkerColorImpound.b, 100, false, true, 2,false, false, false, false)
			end	
		end
		for i=1, #Config.PoliceImpound, 1 do
			if PlayerData.job.name == 'police' then
				if(GetDistanceBetweenCoords(pCoords, Config.PoliceImpound[i], true) < Config.DrawDistance) then
					DrawMarker(Config.Marker[1], Config.PoliceImpound[i] + 0.8, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end
		for i=1, #Config.SetSubowner, 1 do
			if(GetDistanceBetweenCoords(pCoords, Config.SetSubowner[i], true) < Config.DrawDistance) then
				DrawMarker(Config.MarkerType, Config.SetSubowner[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2,true, false, false, false)
			end	
		end
	end
end)
--[[
Citizen.CreateThread(function()
	local zone = getZone(Config.Garages)
	for i, v in ipairs(Config.Garages) do
		local zone = getZone(Config.Garages)
		if not Zones[zone] then
			table.insert(ZoneIds, zone)
			Zones[zone] = #ZoneIds
			zone = #ZoneIds
		else
			zone = Zones[zone]
		end

		if not v.Zone then
			Config.Garages[i].Zone = zone
		end

		if v.DisplayBlip then
			SpawnBlip(i)
			Citizen.Wait(0)
		end
	end

	ZonesLoaded = true
end)]]
-- Enter / Exit marker events
Citizen.CreateThread(function ()
  while PlayerData.job == nil do
	Citizen.Wait(100)
  end
  while true do
    Wait(1)
    local isInMarker  = false
    local currentZone = nil
	local playerPed = GetPlayerPed(-1)
    for i=1, #Config.Garages, 1 do
		if(GetDistanceBetweenCoords(pCoords, Config.Garages[i].Marker, true) < 5) then
			if Config.Garages[i].Job[1] == nil then
				if IsPedInAnyVehicle(playerPed) then
					isInMarker  = true
					currentZone = 'park_car'
					--ZonesLoaded = true
					CurrentGarage = Config.Garages[i].Marker
				elseif not IsPedInAnyVehicle(playerPed) then
					isInMarker = true
					currentZone = 'pullout_car'
					CurrentGarage = Config.Garages[i].Marker
				end
			else
				for j=1, #Config.Garages[i].Job, 1 do
					if PlayerData.job.name == Config.Garages[i].Job[j] then
						if IsPedInAnyVehicle(playerPed) then
							isInMarker  = true
							currentZone = 'park_car'
							CurrentGarage = Config.Garages[i].Marker
						elseif not IsPedInAnyVehicle(playerPed) then
							isInMarker = true
							currentZone = 'pullout_car'
							CurrentGarage = Config.Garages[i].Marker
						end
					end
				end
			end
		end
    end
	for i=1, #Config.Impound, 1 do
		if(GetDistanceBetweenCoords(pCoords, Config.Impound[i], true) < 5) then
			isInMarker  = true
			currentZone = 'impound_veh'
			CurrentGarage = Config.Impound[i]
		end
    end
	for i=1, #Config.SetSubowner, 1 do
		if(GetDistanceBetweenCoords(pCoords, Config.SetSubowner[i], true) < 5) then
			isInMarker  = true
			currentZone = 'subowner_veh'
			CurrentGarage = Config.SetSubowner[i]
		end
	end
	for i=1, #Config.PoliceImpound, 1 do
		if(GetDistanceBetweenCoords(pCoords, Config.PoliceImpound[i], true) < 5) then
			if PlayerData.job.name == 'police' then
				isInMarker  = true
				currentZone = 'police_impound_veh'
				CurrentGarage = Config.PoliceImpound[i]
			end
		end
    end
    if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
		HasAlreadyEnteredMarker = true
		LastZone = currentZone
		TriggerEvent('garages:hasEnteredMarker', currentZone)
    end
    if not isInMarker and HasAlreadyEnteredMarker then
		HasAlreadyEnteredMarker = false
		TriggerEvent('garages:hasExitedMarker', LastZone)
    end
  end
end)

function SpawnImpoundedVehicle(plate)
	TriggerServerEvent('garages:updateState', plate)
end

function OpenSellCarMenu()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'umowaelo',
		{
			title = "Czy na pewno chcesz zakupić umowę za 15 000$?",
			align = 'center',
			elements = {
				{label = "Nie", value = 'no'},
				{label = "Tak", value = 'yes'}
			}
		},
		function(data, menu)
			if data.current.value == 'yes' then
				TriggerServerEvent('garages:buyContract')
				menu.close()
			elseif data.current.value == 'no' then
				menu.close()
			end
		end,
		function(data, menu)
			menu.close()
		end
	)
end


function SubownerVehicle()
	ESX.UI.Menu.Open(
		'dialog', GetCurrentResourceName(), 'subowner_player',
		{
			title = 'Numer Tablicy Rejestracyjnej',
			align = 'center'
		},
		function(data, menu)
			local plate = string.upper(tostring(data.value))
			if string.len(plate) < 8 or string.len(plate) > 8 then
				ESX.ShowNotification(_U('no_veh'))
			else
				ESX.TriggerServerCallback('garages:checkIfPlayerIsOwner', function(isOwner)
					if isOwner then
						menu.close()
						ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'subowner_menu',
							{
								title = _U('owner_menu', plate),
								align = 'center',
								elements	= {
									{label = _U('set_sub'), value = 'give_sub'},
									{label = _U('manage_sub'), value = 'manage_sub'},
								}
							},
							function(data2, menu2)
								if data2.current.value == 'give_sub' then
									local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer ~= -1 and closestDistance <= 3.0 then
										TriggerServerEvent('garages:setSubowner', plate, GetPlayerServerId(closestPlayer))
									else
										ESX.ShowNotification(_U('no_players'))
									end
								elseif data2.current.value == 'manage_sub' then
									ESX.TriggerServerCallback('garages:getSubowners', function(subowners)
										if #subowners > 0 then
											ESX.UI.Menu.Open(
												'default', GetCurrentResourceName(), 'subowners',
												{
													title = _U('deleting_sub', plate),
													align = 'center',
													elements = subowners
												},
												function(data3, menu3)
													local subowner = data3.current.value
													ESX.UI.Menu.Open(
														'default', GetCurrentResourceName(), 'yesorno',
														{
															title = _U('sure_delete'),
															align = 'center',
															elements = {
																{label = _U('no'), value = 'no'},
																{label = _U('yes'), value = 'yes'}
															}
														},
														function(data4, menu4)
															if data4.current.value == 'yes' then
																TriggerServerEvent('garages:deleteSubowner', plate, subowner)
																menu4.close()
																menu3.close()
																menu2.close()
															elseif data4.current.value == 'no' then
																menu4.close()
															end
														end,
														function(data4, menu4)
															menu4.close()
														end
													)													
												end,
												function(data3, menu3)
													menu3.close()
												end
											)
										else
											ESX.ShowNotification(_U('no_subs'))
										end
									end, plate)
								end
							end,
							function(data2,menu2)
								menu2.close()
							end
						)
					else
						ESX.ShowNotification(_U('not_owner'))
					end
				end, plate)
			end
		end,
		function(data,menu)
			menu.close()
		end
	)
end
-- Key controls
Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(1)
		if CurrentAction ~= nil then
			if CurrentAction == 'park_car' then
				DisplayHelpText(_U('store_veh'))
			elseif CurrentAction == 'pullout_car' then
				DisplayHelpText(_U('release_veh'))
			elseif CurrentAction == 'tow_menu' then
				DisplayHelpText(_U('tow_veh'))
			elseif CurrentAction == 'police_impound_menu' then
				DisplayHelpText(_U('p_impound_veh'))
			elseif CurrentAction == 'subowner_veh' then
				DisplayHelpText(_U('subowner_veh'))
			elseif CurrentAction == 'contract' then
				DisplayHelpText(_U('contract'))
			end

			
			if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 300 then
				if CurrentAction == 'park_car' then
					local veh = GetVehiclePedIsUsing(GetPlayerPed(-1))
					local vehProperties = ESX.Game.GetVehicleProperties(veh)
					if GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
						local found = false
						for i = 1, 5, 1 do
						    print(GetPedInVehicleSeat(veh, i))
							if GetPedInVehicleSeat(veh, i) ~= 0 then
								found = true
								break
							end
						end
							local playerPed = GetPlayerPed(-1)
							local vehicle       = GetVehiclePedIsIn(playerPed)
							local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
							local name          = GetDisplayNameFromVehicleModel(vehicleProps.model)
							local plate         = vehicleProps.plate
							local health		= GetVehicleEngineHealth(vehicle)
							if health > Config.MinimumHealth and not found then
								ESX.TriggerServerCallback('garages:checkIfVehicleIsOwned', function (owned)
									if owned ~= nil then                    
										TriggerServerEvent("garages:updateOwnedVehicle", vehicleProps)
										TaskLeaveVehicle(playerPed, vehicle, 16)
										ESX.Game.DeleteVehicle(vehicle)
									else
										ESX.ShowNotification(_U('not_owner'))
									end
								end, vehicleProps.plate)
							else
								ESX.ShowNotification(_U('repair'))
							end
					end
				elseif CurrentAction == 'pullout_car' then
					SendNUIMessage({
						clearme = true
					})
					ESX.TriggerServerCallback('garages:getVehiclesInGarage', function(vehicles)
						for i=1, #vehicles, 1 do
							local _name = GetDisplayNameFromVehicleModel(vehicles[i].model)
							TriggerEvent('esx_vehicleshop:getVehicles', function(base)
								local found = false
							  
								for _, vehicle in ipairs(base) do
									if GetHashKey(vehicle.model) == vehicles[i].model then
										_name = vehicle.name
										found = true
										break
									end
								end
							  
								if not found then
									local label = GetLabelText(_name)
									if label ~= "NULL" then
										_name = label
									end
								end
				
								SendNUIMessage({
									addcar = true,
									number = i,
									model = vehicles[i].plate,
									name = "<span> [ Silnik:  " .. math.floor(vehicles[i].engineHealth / 10) .. "% | Karoseria:  " .. math.floor(vehicles[i].bodyHealth / 10) .. "% ]</span> <font color=#767676> [".. vehicles[i].plate .."] </font> " .. _name,
									engine = vehicles[i].engineHealth and math.floor(vehicles[i].engineHealth) or '??',
									body = vehicles[i].bodyHealth and math.floor(vehicles[i].bodyHealth) or '??'
								})
							end)
						end
					end)
					openGui()
				elseif CurrentAction == 'tow_menu' then
					SendNUIMessage({
						clearimp = true
					})
					ESX.TriggerServerCallback('garages:getVehiclesToTow', function(vehicles)
						for i=1, #vehicles, 1 do
							SendNUIMessage({
								impcar = true,
								number = i,
								model = vehicles[i].plate,
								name = "<span> [ Cena Odcholowania: $2500 ]</span> <font color=#767676> [".. vehicles[i].plate .."] </font> " ..  GetDisplayNameFromVehicleModel(vehicles[i].model),
								engine = vehicles[i].engineHealth and math.floor((vehicles[i].engineHealth - 500) / 5) or '??',
								body = vehicles[i].bodyHealth and math.floor(vehicles[i].bodyHealth / 10) or '??'
							})
						end
					end)
					openGui()
				elseif CurrentAction == 'police_impound_menu' then
					SendNUIMessage({
						clearpolice = true
					})
					ESX.TriggerServerCallback('garages:getTakedVehicles', function(vehicles)
						for i=1, #vehicles, 1 do
							SendNUIMessage({
								policecar = true,
								number = i,
								model = vehicles[i].plate,
								name = "<span> [ Silnik:  " .. vehicles[i].engineHealth / 10 .. "% | Karoseria:  " .. vehicles[i].bodyHealth / 10 .. "% ]</span> <font color=#767676> [".. vehicles[i].plate .."] </font> " ..  GetDisplayNameFromVehicleModel(vehicles[i].model),
								engine = vehicles[i].engineHealth and math.floor((vehicles[i].engineHealth - 500) / 5) or '??',
								body = vehicles[i].bodyHealth and math.floor(vehicles[i].bodyHealth / 10) or '??'
							})
						end
					end)
					openGui()
				elseif CurrentAction == 'subowner_veh' then
					if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
						SubownerVehicle()
					end
				elseif CurrentAction == 'contract' then
					if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
						OpenSellCarMenu()
					end
				end
				CurrentAction = nil
				GUI.Time      = GetGameTimer()
			end
		end
	end
end)

RegisterNetEvent('esx_department:SetSubowner')
AddEventHandler('esx_department:SetSubowner',function()
	SubownerVehicle()
end)
function isVehicleGood(vehicle)
	if GetVehicleEngineHealth(vehicle) < Config.EngineHealth then
		return false
	end

	if GetVehicleBodyHealth(vehicle) < Config.BodyHealth then
		return false
	end

	return true
end

Citizen.CreateThread(function()
	SetNuiFocus(false, false)
end)

-- Open Gui and Focus NUI
function openGui()
	SetNuiFocus(true, true)
	SendNUIMessage({openGarage = true})
end

-- Close Gui and disable NUI
function closeGui()
	SetNuiFocus(false)
	SendNUIMessage({openGarage = false})
end

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
	closeGui()
	cb('ok')
end)

-- NUI Callback Methods
RegisterNUICallback('pullCar', function(data, cb)
	local playerPed  = GetPlayerPed(-1)
	ESX.TriggerServerCallback('garages:checkIfVehicleIsOwned', function (owned)
		local spawnCoords  = {
			x = CurrentGarage.x,
			y = CurrentGarage.y,
			z = CurrentGarage.z,
		}
		ESX.Game.SpawnVehicle(owned.model, spawnCoords, GetEntityHeading(playerPed), function(veh)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			ESX.Game.SetVehicleProperties(veh, owned)
			SetVehicleEngineHealth(veh, owned.engineHealth)
			SetVehicleBodyHealth(veh, owned.bodyHealth)
			local networkid = NetworkGetNetworkIdFromEntity(veh)
			TriggerServerEvent('flux_garages:pullCar', owned, networkid)
			SetEntityAsMissionEntity(veh, true, true)
			SetVehicleHasBeenOwnedByPlayer(veh, true)
			local localVehPlate = string.lower(GetVehicleNumberPlateText(veh))
			local localVehLockStatus = GetVehicleDoorLockStatus(veh)
			TriggerEvent("ls:getOwnedVehicle", veh, localVehPlate, localVehLockStatus)
			TriggerServerEvent("garages:removeCarFromParking", owned.plate, networkid)
		end)
	end, data.model)
	closeGui()
	cb('ok')
end)

RegisterNUICallback('towCar', function(data, cb)
	closeGui()
	cb('ok')
	ESX.TriggerServerCallback('garages:towVehicle', function(id)
		if id ~= nil then
			local entity = NetworkGetEntityFromNetworkId(tonumber(id))
			ESX.ShowNotification(_U('checking_veh'))
			Citizen.Wait(math.random(500, 4000))
			if entity == 0 then
				ESX.TriggerServerCallback('garages:checkMoney', function(hasMoney)
					if hasMoney then
						ESX.ShowNotification(_U('checking_veh'))
						Citizen.Wait(math.random(500, 4000))
						TriggerServerEvent('garages:pay')
						SpawnImpoundedVehicle(data.model)
						ESX.ShowNotification(_U('veh_impounded', data.model))
					else
						ESX.ShowNotification(_U('no_money'))
					end
				end)
			elseif entity ~= 0 and (GetVehicleNumberOfPassengers(entity) > 0 or not IsVehicleSeatFree(entity, -1)) then
				ESX.ShowNotification(_U('cant_impound'))
			else
				ESX.TriggerServerCallback('garages:checkMoney', function(hasMoney)
					if hasMoney then
						TriggerServerEvent('garages:pay')
						SpawnImpoundedVehicle(data.model)
						if entity ~= 0 then
							ESX.Game.DeleteVehicle(entity)
						end
						ESX.ShowNotification(_U('veh_impounded', data.model))
					else
						ESX.ShowNotification(_U('no_money'))
					end
				end)
			end
		else
			ESX.TriggerServerCallback('garages:checkMoney', function(hasMoney)
				if hasMoney then
					ESX.ShowNotification(_U('checking_veh'))
					Citizen.Wait(math.random(500, 4000))
					TriggerServerEvent('garages:pay')
					SpawnImpoundedVehicle(data.model)
					ESX.ShowNotification(_U('veh_impounded', data.model))
				else
					ESX.ShowNotification(_U('no_money'))
				end
			end)
		end
	end, data.model)
end)

RegisterNUICallback('impoundCar', function(data, cb)
	closeGui()
	cb('ok')
	local playerPed  = GetPlayerPed(-1)
	ESX.TriggerServerCallback('garages:checkVehProps', function(veh)
		ESX.ShowNotification(_U('checking_veh'))
		Citizen.Wait(math.random(500, 4000))
		local spawnCoords  = {
			x = CurrentGarage.x,
			y = CurrentGarage.y,
			z = CurrentGarage.z,
		}
		ESX.Game.SpawnVehicle(veh.model, spawnCoords, GetEntityHeading(playerPed), function(vehicle)
			TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
			ESX.Game.SetVehicleProperties(vehicle, veh)
			local networkid = NetworkGetNetworkIdFromEntity(vehicle)
			TriggerServerEvent("garages:removeCarFromPoliceParking", data.model, networkid)
		end)
	end, data.model)
	
end)

function DisplayHelpText(str)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentScaleform(str)
	EndTextCommandDisplayHelp(0, 0, 1, -1)
end



AddEventHandler('garages:hasEnteredMarker', function (zone)
	if zone == 'pullout_car' then
		CurrentAction = 'pullout_car'
	elseif zone == 'park_car' then
		CurrentAction = 'park_car'
	elseif zone == 'impound_veh' then
		CurrentAction = 'tow_menu'
	elseif zone == 'police_impound_veh' then
		CurrentAction = 'police_impound_menu'
	elseif zone == 'subowner_veh' then
		CurrentAction = 'subowner_veh'
	elseif zone == 'contract' then
		CurrentAction = 'contract'
	end
end)

AddEventHandler('garages:hasExitedMarker', function (zone)
  if IsInShopMenu then
    IsInShopMenu = false
    CurrentGarage = nil
  end
  if not IsInShopMenu then
	ESX.UI.Menu.CloseAll()
  end
  CurrentAction = nil
end)

RegisterNetEvent('garages:getVehicle')
AddEventHandler('garages:getVehicle', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local closestPlayer, playerDistance = ESX.Game.GetClosestPlayer()

	if closestPlayer ~= -1 and playerDistance <= 3.0 then
		local vehicle = ESX.Game.GetClosestVehicle(coords)
		local vehiclecoords = GetEntityCoords(vehicle)
		local vehDistance = GetDistanceBetweenCoords(coords, vehiclecoords, true)
		if DoesEntityExist(vehicle) and (vehDistance <= 3) then
			local vehProps = ESX.Game.GetVehicleProperties(vehicle)
			ESX.ShowNotification('Wypisywanie Kontraktu na samochod o numerach: '.. vehProps.plate)
			TriggerServerEvent('garages:sellVehicle', GetPlayerServerId(closestPlayer), vehProps.plate)
		else
			ESX.ShowNotification('Nie ma samochodu w pobliżu')
		end
	else
		ESX.ShowNotification('Nie ma nikogo w pobliżu')
	end
	
end)

RegisterNetEvent('garages:showAnim')
AddEventHandler('garages:showAnim', function(player)
	loadAnimDict('anim@amb@nightclub@peds@')
	TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_CLIPBOARD', 0, false)
	Citizen.Wait(20000)
	ClearPedTasks(PlayerPedId())
end)


function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end


