ESX = nil
OrganizationBlip = {}
local PlayerData, CurrentAction = {}
local currentjoblocation = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
  	end
  
  	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	refreshBlip()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setHiddenJob')
AddEventHandler('esx:setHiddenJob', function(hiddenjob)
	PlayerData.hiddenjob = hiddenjob
	deleteBlip()
	refreshBlip()
end)

CreateThread(function()
	while true do 
		Citizen.Wait(10000)
		deleteBlip()
		Citizen.Wait(100)
		refreshBlip()
	end
end)


CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _, iter in ipairs({1, 2, 3, 4, 6, 7, 8, 9, 13, 17, 18}) do
			HideHudComponentThisFrame(iter)
		end

		local ped = PlayerPedId()

		local inVehicle = IsPedInAnyVehicle(ped, false)
		if not show then
			HideHudComponentThisFrame(14)
			local aiming, shooting = IsControlPressed(0, 25), IsPedShooting(ped)
			if aiming or shooting then
				if shooting and not aiming then
					isShooting = true
					aimTimer = 0
				else
					isShooting = false
				end

				if not isAiming then
					isAiming = true

					lastCamera = GetFollowPedCamViewMode()
					if lastCamera ~= 4 then
						SetFollowPedCamViewMode(4)
					end
				elseif GetFollowPedCamViewMode() ~= 4 then
					SetFollowPedCamViewMode(4)
				end
			elseif isAiming then
				local off = true
				if isShooting then
					off = false
					aimTimer = aimTimer + 20
					if aimTimer == 3000 then
						isShooting = false
						aimTimer = 0
						off = true
					end
				end

				if off then
					isAiming = false
					if lastCamera ~= 4 then
						SetFollowPedCamViewMode(lastCamera)
					end
				end
			elseif not inVehicle then
				DisableControlAction(0, 24, true)
				DisableControlAction(0, 140, true)
				DisableControlAction(0, 141, true)
				DisableControlAction(0, 142, true)
				DisableControlAction(0, 257, true)
				DisableControlAction(0, 263, true)
				DisableControlAction(0, 264, true)
			end
		end

		if inVehicle then
			local vehicle = GetVehiclePedIsIn(ped, false)
			if DoesVehicleHaveWeapons(vehicle) == 1 then
				local vehicleWeapon, vehicleWeaponHash = GetCurrentPedVehicleWeapon(playerped)
				if vehicleWeapon == 1 then
					DisableVehicleWeapon(true, vehicleWeaponHash, vehicle, playerPed)
					SetCurrentPedVehicleWeapon(playerPed, `WEAPON_UNARMED`)
				end
			end

			DisableControlAction(0, 354, true)
			DisableControlAction(0, 351, true)
			DisableControlAction(0, 350, true)
			DisableControlAction(0, 357, true)
		end
	end
end)


function refreshBlip()
	if PlayerData.hiddenjob ~= nil and Config.Blips[PlayerData.hiddenjob.name] then
		local blip = AddBlipForCoord(Config.Blips[PlayerData.hiddenjob.name])
		SetBlipSprite (blip, 84)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.8)
		SetBlipColour (blip, 6)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Dom organizacji")
		EndTextCommandSetBlipName(blip)
		table.insert(OrganizationBlip, blip)
	end
end

function deleteBlip()
	if OrganizationBlip[1] ~= nil then
		for i=1, #OrganizationBlip, 1 do
			RemoveBlip(OrganizationBlip[i])
			table.remove(OrganizationBlip, i)
		end
	end
end

function OpenOrganisationActionsMenu()
    ESX.UI.Menu.CloseAll()
	local elements = {}
	if PlayerData.hiddenjob.grade >= Config.Interactions[PlayerData.hiddenjob.name].handcuffs then
		table.insert(elements, { label = 'Kajdanki', value = 'handcuffs' })
	end
	if PlayerData.hiddenjob.grade >= Config.Interactions[PlayerData.hiddenjob.name].repair then
		table.insert(elements, { label = 'Napraw pojazd', value = 'repair' })
	end
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'organisation_actions',
    {
        title    = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Label,
        align    = 'center',
        elements = elements
	}, function(data, menu)
		if data.current.value == 'handcuffs' then
			menu.close()
			exports['sativa_kajdanki']:HandcuffsAction()
		elseif data.current.value == 'repair' then
			menu.close()
			exports['esx_mecanojob']:whyuniggarepairingme()
		elseif data.current.value == 'gwizdek' then
			TriggerEvent('foriv:zadzwonelop')
		end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenWeaponsMenu(station)
	ESX.UI.Menu.CloseAll()
	local elements = {
		{ label = 'Włóż broń', value = 'deposit' },
		{ label = 'Wyciągnij broń', value = 'withdraw' },
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory',
	{
		title    = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Label,
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'withdraw' then
			ESX.TriggerServerCallback('szymczakovv_stocks:getStock', function(inventory)
				local elements = {}
				for i=1, #inventory.weapons, 1 do
					local weapon = inventory.weapons[i]
					table.insert(elements, {
						label = ESX.GetWeaponLabel(weapon.name) .. ' [' .. weapon.ammo .. ']',
						type  = 'item_weapon',
						value = weapon.name,
						ammo  = weapon.ammo
					})
				end
			
				ESX.UI.Menu.Open(
				  'default', GetCurrentResourceName(), 'armory_get_weapon',
				  {
					title    = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Label,
					align    = 'center',
					elements = elements,
				  },
				  function(data, menu)
					menu.close()
					TriggerServerEvent('szymczakovv_stocks:getWeaponInStock', data.current.value, data.current.ammo, station)
					ESX.SetTimeout(500, function()
						OpenWeaponsMenu(station)
					end)
				  end,
				  function(data, menu)
					menu.close()
				  end
				)
			  end, station)
		else
			local elements   = {}
			local playerPed  = GetPlayerPed(-1)
			local weaponList = ESX.GetWeaponList()
			for i=1, #weaponList, 1 do
				local weaponHash = GetHashKey(weaponList[i].name)
				if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
				local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
				table.insert(elements, {label = weaponList[i].label .. " [" .. ammo .. "]", value = weaponList[i].name, ammo = ammo})
				end
			end
			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'armory_put_weapon',
				{
				title    = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Label,
				align    = 'center',
				elements = elements,
				},
				function(data, menu)
					if data.current.ammo <= 1 then
						menu.close()
						TriggerServerEvent('szymczakovv_stocks:putWeaponInStock', data.current.value, data.current.ammo, station)
						ESX.SetTimeout(500, function()
							OpenWeaponsMenu(station)
						end)
					else
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'put_item_count', {
							title = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Label,
						}, function(data2, menu2)
							local quantity = tonumber(data2.value)
		
							if quantity == nil then
								ESX.ShowNotification("~r~Nieprawidłowa ilość")
							else
								if quantity <= data.current.ammo then
									menu.close()
									menu2.close()
									TriggerServerEvent('szymczakovv_stocks:putWeaponInStock', data.current.value, tonumber(data2.value), station)
									ESX.SetTimeout(500, function()
										OpenWeaponsMenu(station)
									end)
								else
									ESX.ShowNotification("~r~Nie masz tyle amunicji")
								end
							end
						end, function(data2, menu2)
							menu2.close()
						end)
					end
				end,
				function(data, menu)
				menu.close()
				end
			)
		end
	end, function(data, menu)
		menu.close()
		if isUsing then
			isUsing = false
			TriggerServerEvent('szymczakovv_organizations:setStockUsed', 'society_'..PlayerData.hiddenjob.name, 'weapons', false)
		end
	end)
end

function OpenInventoryMenu(station)
	ESX.UI.Menu.CloseAll()
	local elements = {
		{label = "Włóż", value = 'deposit'},
		{label = "Wyciągnij", value = 'withdraw'},
		{label = "Włóż brudne", value = 'deposit_black'},
		{label = "Wyciągnij brudne", value = 'withdraw_black'}
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory',
	{
		title    = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Label,
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'withdraw' then
			ESX.TriggerServerCallback('szymczakovv_stocks:getSharedInventoryInJob', function(inventory)
				local elements = {}
				for i=1, #inventory.items, 1 do
					local item = inventory.items[i]
					if item.count > 0 then
					table.insert(elements, {
						label = item.label .. ' x' .. item.count,
						type = 'item_standard',
						value = item.name
					})
					end
				end
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'stocks_menu',
					{
					title    = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Label,
					align    = 'center',
					elements = elements
					},
					function(data, menu)
					local itemName = data.current.value
					ESX.UI.Menu.Open(
						'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
						{
						title = "Ilość",
						},
						function(data2, menu2)
							local count = tonumber(data2.value)
							if count == nil then
								ESX.ShowNotification("~r~Nieprawidłowa wartość!")
							else
								menu2.close()
								menu.close()
								TriggerServerEvent('szymczakovv_stocks:getItemInStock', data.current.type, data.current.value, count, station)
								ESX.SetTimeout(500, function()
									OpenInventoryMenu(station)
								end)
							end
						end,
						function(data2, menu2)
							menu2.close()
						end
					)
					end,
					function(data, menu)
						menu.close()
					end
				)
			end, station)
		elseif data.current.value == 'despoit' then
			ESX.TriggerServerCallback('szymczakovv_stocks:getPlayerInventory', function(inventory)
				local elements = {}
				for i=1, #inventory.items, 1 do
					local item = inventory.items[i]
					if item.count > 0 then
					table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
					end
				end
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'stocks_menu',
					{
					title    = "Ekwipunek",
					align    = 'center',
					elements = elements
					},
					function(data2, menu2)
					local itemName = data2.current.value
					local itemType = data2.current.type
					ESX.UI.Menu.Open(
						'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
						{
						title = "Ilość"
						},
						function(data3, menu3)
							local count = tonumber(data3.value)
							if count == nil then
								ESX.ShowNotification("~r~Nieprawidłowa wartość!")
							else
								menu2.close()
								menu.close()
								TriggerServerEvent('szymczakovv_stocks:putItemInStock', itemType, itemName, count, station)
								ESX.SetTimeout(500, function()
									OpenInventoryMenu(station)
								end)
							end
						end,
						function(data3, menu3)
						menu3.close()
						end
					)
					end,
					function(data2, menu2)
					menu2.close()
					end
				)
			end)
		elseif data.current.value == 'deposit_black' then
			ESX.TriggerServerCallback('neey_dev:getPlayerInventory', function(inventory)
				local elements = {}
				if inventory.blackMoney > 0 then
					table.insert(elements, {
						label = 'Brudne pieniądze '.. ESX.Math.GroupDigits(inventory.blackMoney) .. '$',
						type = 'item_account',
						value = 'black_money'
					})
				end
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'stocks_menu',
					{
					title    = "Ekwipunek",
					align    = 'center',
					elements = elements
					},
					function(data2, menu2)
					local itemName = data2.current.value
					local itemType = data2.current.type
					ESX.UI.Menu.Open(
						'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
						{
						title = "Ilość"
						},
						function(data3, menu3)
							local count = tonumber(data3.value)
							if count == nil then
								ESX.ShowNotification("~r~Nieprawidłowa wartość!")
							else
								menu2.close()
								menu3.close()
								TriggerServerEvent('neey_dev:putBlack', PlayerData.hiddenjob.name, itemType, itemName, count)
								ESX.SetTimeout(500, function()
									OpenInventoryMenu(station)
								end)
							end
						end,
						function(data3, menu3)
						menu3.close()
						end
					)
					end,
					function(data2, menu2)
						menu2.close()
					end
				)
			end)
		elseif data.current.value == 'withdraw_black' then
			ESX.TriggerServerCallback('neey:getStockBlack', function(inventory)
				local elements = {}
				if inventory.blackMoney > 0 then
					table.insert(elements, {
						label = 'Brudne pieniądze '.. ESX.Math.GroupDigits(inventory.blackMoney) .. '$',
						type = 'item_account',
						value = 'black_money'
					})
				end

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'stocks_menu',
					{
					title    = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Label,
					align    = 'center',
					elements = elements
					},
					function(data2, menu2)
					local itemName = data2.current.value
					ESX.UI.Menu.Open(
						'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
						{
						title = "Ilość",
						},
						function(data3, menu3)
							local count = tonumber(data3.value)
							if count == nil then
								ESX.ShowNotification("~r~Nieprawidłowa wartość!")
							else
								menu2.close()
								menu3.close()
								TriggerServerEvent('neey_dev:getBlack', PlayerData.hiddenjob.name, data2.current.type, data2.current.value, count)
								ESX.SetTimeout(500, function()
									OpenInventoryMenu(station)
								end)
							end
						end,
						function(data3, menu3)
							menu3.close()
						end
					)
					end,
					function(data2, menu2)
						menu2.close()
					end
				)
			end, PlayerData.hiddenjob.name)
		end
	end, function(data, menu)
		menu.close()
		if isUsing then
			isUsing = false
			TriggerServerEvent('szymczakovv_organizations:setStockUsed', 'society_'..PlayerData.hiddenjob.name, 'inventory', false)
		end
	end)
end

AddEventHandler('esx_organisation:hasEnteredMarker', function(zone)
	print(zone)
	if zone == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć przebieralnie.')
		CurrentActionData = {}
	elseif zone == 'Inventory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć szafkę.')
		CurrentActionData = {station = station}
	elseif zone == 'Weapons' then
		CurrentAction     = 'menu_armory_weapons'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć zbrojownie.')
		CurrentActionData = {station = station}
	elseif zone == "BossMenu" then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = "~y~Naciśnij ~INPUT_PICKUP~ aby otworzyć panel zarządzania"
		CurrentActionData = {}
	elseif zone == "Contract" then
		CurrentAction     = 'menu_contract_actions'
		CurrentActionMsg  = "~ys~Naciśnij ~INPUT_PICKUP~ aby zakupić kontrakt na bron"
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_organisation:hasExitedMarker', function(zone)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	zoneName = nil
	CurrentAction = nil
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if PlayerData.hiddenjob ~= nil then
			if Config.Organisations[PlayerData.hiddenjob.name] then
				local playerPed = PlayerPedId()
				local isInMarker  = false
				local currentZone = nil
				local coords, letSleep = GetEntityCoords(playerPed), true
				
				for k,v in pairs(Config.Organisations[PlayerData.hiddenjob.name]) do
					if GetDistanceBetweenCoords(coords, v.coords, true) < Config.DrawDistance then
						letSleep = false
						DrawMarker(27, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 130, 204, 80, false, true, 2, false, false, false, false)
					end

					if(GetDistanceBetweenCoords(coords, v.coords, true) < 1.5) then
						isInMarker  = true
						currentZone = k
					end
				end

				if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
					HasAlreadyEnteredMarker = true
					LastZone                = currentZone
					TriggerEvent('esx_organisation:hasEnteredMarker', currentZone)
				end

				if not isInMarker and HasAlreadyEnteredMarker then
					HasAlreadyEnteredMarker = false
					TriggerEvent('esx_organisation:hasExitedMarker', LastZone)
				end

				if letSleep then
					Citizen.Wait(1000)
				end
			else
				Citizen.Wait(5000)
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(1)
		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)
			if IsControlJustReleased(0, 38) and PlayerData.hiddenjob and Config.Organisations[PlayerData.hiddenjob.name] then
				if CurrentAction == 'menu_armory' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestDistance > 3 or closestPlayer == -1 then
						ESX.TriggerServerCallback('szymczakovv_organizations:checkStock', function()
							if not isUsed then
								isUsing = true
								TriggerServerEvent('szymczakovv_organizations:setStockUsed', 'society_'..PlayerData.hiddenjob.name, 'inventory', true)
								zoneName = 'inventory'
								OpenInventoryMenu('society_' .. PlayerData.hiddenjob.name)
							else
								ESX.ShowNotification("~r~Ktoś właśnie używa tej szafki")
							end
						end, 'society_'..PlayerData.hiddenjob.name, 'inventory')
					else
						ESX.ShowNotification('Stoisz za blisko innego gracza!')
					end
				elseif CurrentAction == 'menu_armory_weapons' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestDistance > 3 or closestPlayer == -1 then
							OpenWeaponsMenu(CurrentActionData.station)
						else
							ESX.ShowNotification('Stoisz za blisko innego gracza!')
						end
					elseif CurrentAction == 'menu_cloakroom' then
						OpenOrganisationPrywatne()
						ESX.TriggerServerCallback('szymczakovv_stocks:getPlayerDressing', function(dressing)
							local elements = {}
				
							for i=1, #dressing, 1 do
								table.insert(elements, {
									label = dressing[i],
									value = i
								})
							end
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
								title = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Label,
								align    = 'center',
								elements = elements
							}, function(data2, menu2)
								TriggerEvent('skinchanger:getSkin', function(skin)
									ESX.TriggerServerCallback('szymczakovv_stocks:getPlayerOutfit', function(clothes)
										TriggerEvent('skinchanger:loadClothes', skin, clothes)
										TriggerEvent('esx_skin:setLastSkin', skin)
				
										TriggerEvent('skinchanger:getSkin', function(skin)
											TriggerServerEvent('esx_skin:save', skin)
										end)
									end, data2.current.value)
								end)
							end, function(data2, menu2)
								menu2.close()
							end)
						end)
					elseif CurrentAction == 'menu_boss_actions' then
						ESX.UI.Menu.CloseAll()
						OpenBossMenu(PlayerData.hiddenjob.name, Config.Organisations[PlayerData.hiddenjob.name].BossMenu.from)
					elseif CurrentAction == 'menu_contract_actions' then
						--if Config.Organisations[PlayerData.hiddenjob.name].Contract.from then
							OpenContractMenu()
						--end
					end
					CurrentAction = nil
				end
			end
			if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
				if IsControlJustReleased(0, 168) and GetEntityHealth(GetPlayerPed(-1)) > 100 and PlayerData.hiddenjob and Config.Interactions[PlayerData.hiddenjob.name] and not exports['esx_ambulancejob']:getDeathStatus() then
					OpenOrganisationActionsMenu(PlayerData.hiddenjob.name)
				end
			end
		end		
	end)
	

OpenContractMenu = function()
	ESX.UI.Menu.CloseAll()
	local elements = {
		{label =  Config.Organisations[PlayerData.hiddenjob.name].Contract.Utils.Label..' $'..Config.Organisations[PlayerData.hiddenjob.name].Contract.Utils.Price, value = Config.Organisations[PlayerData.hiddenjob.name].Contract.Utils.Price},
		{label = 'Amunicja $'..Config.Organisations[PlayerData.hiddenjob.name].Contract.Utils.Ammo.Price, value = 'ammo'}
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'szymczakovv_jest_git', { title = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Label, align = 'center', elements = elements}, function(data, menu) if data.current.value == Config.Organisations[PlayerData.hiddenjob.name].Contract.Utils.Price then klameczka = Config.Organisations[PlayerData.hiddenjob.name].Contract.Utils.Weapon TriggerServerEvent('szymczakovv_organizations', klameczka) elseif data.current.value == 'ammo' then TriggerServerEvent('szymczakovv_stocks:Magazynek') end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenOrganisationPrywatne()
    ESX.UI.Menu.CloseAll()
	local elements = {
		{label = 'Ubrania Prywatne', value = 'player_dressing'},
		{label = 'Ubranie ogranizacyjne', value = 'dress_clothes'},
	}
	if PlayerData.hiddenjob.grade_name == 'boss' then
		table.insert(elements,	{label = 'Zapisywanie ubrania', value = 'save_clothes'})
	end

    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'organisation_actions',
    {
        title    = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Label,
        align    = 'center',
        elements = elements
	}, function(data, menu)
		if data.current.value == 'player_dressing' then
			ESX.TriggerServerCallback('szymczakovv_stocks:getPlayerDressing', function(dressing)
				local elements = {}
	
				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
					title = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Label,
					align    = 'center',
					elements = elements
				}, function(data2, menu2)
					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('szymczakovv_stocks:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)
	
							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
						end, data2.current.value)
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end
		if data.current.value == 'save_clothes' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'cloth_name', {
				title = 'Nazwa ubioru'
			}, function(data2, menu2)
				ESX.UI.Menu.CloseAll()

				TriggerEvent('skinchanger:getSkin', function(skin)
					TriggerServerEvent('neey_dev:saveOutfit', data2.value, skin, PlayerData.hiddenjob.name)
					ESX.ShowNotification('Pomyślnie zapisano ubiór o nazwie: ~y~' .. data2.value)
				end)
			end, function(data2, menu2)
				menu2.close()
			end)
		end

		if data.current.value == 'dress_clothes' then
			ESX.TriggerServerCallback('neey_dev:getPlayerDressing', function(dressing)
				elements = nil
				local elements = {}
				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'wszystkie_ubrania', {
					title    = ('Ubrania'),
					align    = 'top',
					elements = elements
				}, function(data2, menu2)
				
					local elements2 = {
						{ label = ('Ubierz ubranie'), value = 'dress_cloth' },
					}
					if PlayerData.hiddenjob.grade_name == 'boss' then
						table.insert(elements2, {
							label = ('Usuń ubranie'),
							value = 'remove_cloth' 
						})
					end
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'edit_cloth', {
					title    = ('Ubrania'),
					align    = 'top',
					elements = elements2
				}, function(data3, menu3)
						if data3.current.value == 'dress_cloth' then
							TriggerEvent('skinchanger:getSkin', function(skin)
								ESX.TriggerServerCallback('neey_dev:getPlayerOutfit', function(clothes)
									TriggerEvent('skinchanger:loadClothes', skin, clothes)
									TriggerEvent('esx_skin:setLastSkin', skin)
									ESX.ShowNotification('Pomyślnie zmieniłeś swój ubiór!')
									ClearPedBloodDamage(playerPed)
									ResetPedVisibleDamage(playerPed)
									ClearPedLastWeaponDamage(playerPed)
									ResetPedMovementClipset(playerPed, 0)
									TriggerEvent('skinchanger:getSkin', function(skin)
										TriggerServerEvent('esx_skin:save', skin)
									end)
								end, data2.current.value, PlayerData.hiddenjob.name)
							end)
						end
						if data3.current.value == 'usun_ubranie' then
							TriggerServerEvent('neey_crime:removeOutfit', data2.current.value, PlayerData.hiddenjob.name)
							ESX.ShowNotification('Pomyślnie usunąłeś ubiór o nazwie: ~y~' .. data2.current.label)
							menu3.close()
							menu2.close()
						end
					end, function(data3, menu3)
						menu3.close()
					end)
					
				end, function(data2, menu2)
					menu2.close()
				end)
			end, PlayerData.hiddenjob.name)
		end
    end, function(data, menu)
        menu.close()
    end)
end


function OpenBossMenu(org, grade)
	if PlayerData.hiddenjob.grade >= grade then
		TriggerEvent('esx_society:organisationmenu', org, function(data, menu)
			menu.close()
		end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true })
	else
		TriggerEvent('esx_society:organisationmenu', org, function(data, menu)
			menu.close()
		end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = false })
	end
end

local Blips = {}
local lastUsed = 0

RegisterNetEvent('neey_gwizdek:setBlip')
AddEventHandler('neey_gwizdek:setBlip', function(coords, job)
    for k, v in pairs(Config.Jobs) do
        if v == PlayerData.hiddenjob.name then
            if next(Blips) == nil then
                lastUsed = GetGameTimer() + Config.Cooldown * 1000
                local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                SetBlipPriority(blip, 4)
                SetBlipScale(blip, 0.9)
                SetBlipSprite(blip, 126)
                SetBlipColour(blip, 2)
                SetBlipAlpha(blip, 250)
                SetBlipAsShortRange(blip, true)

                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('# Gwizdek ('.. string.upper(job) .. ')')
                EndTextCommandSetBlipName(blip)
                ESX.ShowNotification('~r~Organizacja '..string.upper(job)..' użyła gwizdka! ~g~Kieruj się na GPS!')
                table.insert(Blips, { blip_data = blip, job = PlayerData.hiddenjob.name })
                Citizen.CreateThread(function()
                    local alpha = 250
                    while alpha > 0 and DoesBlipExist(blip) do
                        Citizen.Wait(Config.BlipTime * 100)
                        SetBlipAlpha(blip, alpha)
                        alpha = alpha - 25

                        if alpha == 0 then
                            RemoveBlip(blip)
                            for i, b in ipairs(Blips) do
                                if b.blip_data == blip then
                                    table.remove(Blips, i)
                                    return
                                end
                            end

                            break
                        end
                    end
                end)
            else
                for i, b in ipairs(Blips) do
                    if b.job == PlayerData.hiddenjob.name then
                        ESX.ShowNotification('Twoja organizacja użyła już gwizdka!')
                        break 
                    else
                        lastUsed = GetGameTimer() + 300000
                        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                        SetBlipPriority(blip, 4)
                        SetBlipScale(blip, 0.9)
                        SetBlipSprite(blip, 126)
                        SetBlipColour(blip, 2)
                        SetBlipAlpha(blip, 250)
                        SetBlipAsShortRange(blip, true)
                
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString('# Gwizdek ('.. string.upper(job) .. ')')
                        EndTextCommandSetBlipName(blip)
                
                        table.insert(Blips, { blip_data = blip, job = PlayerData.hiddenjob.name })
                        ESX.ShowNotification('~r~Organizacja '..string.upper(job)..' użyła gwizdka! ~g~Kieruj się na GPS!')
                        Citizen.CreateThread(function()
                            local alpha = 250
                            while alpha > 0 and DoesBlipExist(blip) do
                                Citizen.Wait(Config.BlipTime  * 100)
                                SetBlipAlpha(blip, alpha)
                                alpha = alpha - 5
                
                                if alpha == 0 then
                                    RemoveBlip(blip)
                                    for i, b in ipairs(Blips) do
                                        if b[i].blip_data == blip then
                                            table.remove(Blips, i)
                                            return
                                        end
                                    end
                                    break
                                end
                            end
                        end)
                        break
                    end
                end
            end
        end
    end
end)

local lastUsedKey = 0

RegisterCommand('gwizdek', function()
	if GetGameTimer() > lastUsed then
		if GetGameTimer() > lastUsedKey then
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			TriggerServerEvent('neey_gwizdek:checkUse', coords)
			lastUsedKey = GetGameTimer() + 10000
		else
			ESX.ShowNotification('Nie tak szybko!')
		end
	else
		local time = lastUsed - GetGameTimer()
		ESX.ShowNotification('Odczekaj jeszcze: ' .. math.floor(time / 1000) .. 's!' )
	end
end)