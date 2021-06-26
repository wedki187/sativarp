
	
Citizen.CreateThread(function()
	local Keys = {
		["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
		["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
		["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
		["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
		["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
		["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
		["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
		["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
		["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
	}

	local cokeQTE       			= 0
	ESX 			    			= nil
	local coke_poochQTE 			= 0
	local weedQTE					= 0
	local weed_poochQTE 			= 0
	local methQTE					= 0
	local meth_poochQTE 			= 0
	local opiumQTE					= 0
	local opium_poochQTE 			= 0
	local myJob 					= nil
	local HasAlreadyEnteredMarker   = false
	local LastZone                  = nil
	local isInZone                  = false
	local CurrentAction             = nil
	local CurrentActionMsg          = ''
	local CurrentActionData         = {}

	local event1 = nil
	local event2 = nil
	local event3 = nil
	local event4 = nil
	local event5 = nil
	local event6 = nil
	local event7 = nil
	local event8 = nil
	local event9 = nil



	RegisterNetEvent('yung_ac:esx_dragi:config')
	AddEventHandler('yung_ac:esx_dragi:config', function(cossa)
		Config.Zones = cossa
	end)

	RegisterNetEvent('yung_ac:esx_dragi:eventchanger')
	AddEventHandler('yung_ac:esx_dragi:eventchanger', function(eve1, eve2, eve3, eve4, eve5, eve6, eve7, eve8, eve9)
		event1 = eve1
		event2 = eve2
		event3 = eve3
		event4 = eve4
		event5 = eve5
		event6 = eve6
		event7 = eve7
		event8 = eve8
		event9 = eve9
	end)

	Wait(1500)
	
	Citizen.CreateThread(function()
		while ESX == nil do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Citizen.Wait(0)
		end
	end)

	AddEventHandler('esx_drugs:hasEnteredMarker', function(zone)
		if myJob == 'police' or myJob == 'ambulance' or myJob == 'offpolice' or myJob == 'offambulance' then
			return
		end

		ESX.UI.Menu.CloseAll()
		
		if zone == 'exitMarker' then
			CurrentAction     = zone
			CurrentActionMsg  = _U('exit_marker')
			CurrentActionData = {}
		end
		
		if zone == 'CokeField' then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_collect_coke')
			CurrentActionData = {}
		end

		if zone == 'CokeProcessing' then
			if cokeQTE >= 5 then
				CurrentAction     = zone
				CurrentActionMsg  = _U('press_process_coke')
				CurrentActionData = {}
			end
		end


		if zone == 'MethField' then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_collect_meth')
			CurrentActionData = {}
		end

		if zone == 'MethProcessing' then
			if methQTE >= 5 then
				CurrentAction     = zone
				CurrentActionMsg  = _U('press_process_meth')
				CurrentActionData = {}
			end
		end


		if zone == 'WeedField' then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_collect_weed')
			CurrentActionData = {}
		end

		if zone == 'WeedProcessing' then
			if weedQTE >= 5 then
				CurrentAction     = zone
				CurrentActionMsg  = _U('press_process_weed')
				CurrentActionData = {}
			end
		end


		if zone == 'OpiumField' then
			CurrentAction     = zone
			CurrentActionMsg  = _U('press_collect_opium')
			CurrentActionData = {}
		end

		if zone == 'OpiumProcessing' then
			if opiumQTE >= 5 then
				CurrentAction     = zone
				CurrentActionMsg  = _U('press_process_opium')
				CurrentActionData = {}
			end
		end

	end)

	AddEventHandler('esx_drugs:hasExitedMarker', function(zone)
		CurrentAction = nil
		ESX.UI.Menu.CloseAll()

		TriggerServerEvent('esx_drugs:stopHarvestCoke')
		TriggerServerEvent('esx_drugs:stopTransformCoke')
		TriggerServerEvent('esx_drugs:stopSellCoke')
		TriggerServerEvent('esx_drugs:stopHarvestMeth')
		TriggerServerEvent('esx_drugs:stopTransformMeth')
		TriggerServerEvent('esx_drugs:stopSellMeth')
		TriggerServerEvent('esx_drugs:stopHarvestWeed')
		TriggerServerEvent('esx_drugs:stopTransformWeed')
		TriggerServerEvent('esx_drugs:stopSellWeed')
		TriggerServerEvent('esx_drugs:stopHarvestOpium')
		TriggerServerEvent('esx_drugs:stopTransformOpium')
		TriggerServerEvent('esx_drugs:stopSellOpium')
	end)

	-- Weed Effect
	RegisterNetEvent('esx_drugs:onPot')
	AddEventHandler('esx_drugs:onPot', function()
		RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
		while not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") do
			Citizen.Wait(0)
		end
		TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_SMOKING_POT", 0, true)
		Citizen.Wait(5000)
		DoScreenFadeOut(1000)
		Citizen.Wait(1000)
		ClearPedTasksImmediately(GetPlayerPed(-1))
		SetTimecycleModifier("spectator5")
		SetPedMotionBlur(GetPlayerPed(-1), true)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
		SetPedIsDrunk(GetPlayerPed(-1), true)
		DoScreenFadeIn(1000)
		Citizen.Wait(600000)
		DoScreenFadeOut(1000)
		Citizen.Wait(1000)
		DoScreenFadeIn(1000)
		ClearTimecycleModifier()
		ResetScenarioTypesEnabled()
		ResetPedMovementClipset(GetPlayerPed(-1), 0)
		SetPedIsDrunk(GetPlayerPed(-1), false)
		SetPedMotionBlur(GetPlayerPed(-1), false)
	end)

	-- Render markers
	Citizen.CreateThread(function()
		while true do

			Citizen.Wait(3)

			local coords = GetEntityCoords(GetPlayerPed(-1))
			local fps = true
			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance) then
					fps = false
					DrawMarker(Config.MarkerType, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 40, false, true, 2, false, false, false, false)
				end
			end
			if fps then
				if lastZone then
					TriggerEvent('esx_drugs:hasExitedMarker', lastZone)
					lastZone = nil
				end
				Wait(500)
			end
		end
	end)

	-- Create blips
	--Citizen.CreateThread(function()
	--	for k,v in pairs(Config.Zones) do
	--		local blip = AddBlipForCoord(v.x, v.y, v.z)

	--		SetBlipSprite (blip, v.sprite)
	--		SetBlipDisplay(blip, 4)
	--		SetBlipScale  (blip, 0.9)
	--		SetBlipColour (blip, v.color)
	--		SetBlipAsShortRange(blip, true)

	--		BeginTextCommandSetBlipName("STRING")
	--		AddTextComponentString(v.name)
	--		EndTextCommandSetBlipName(blip)
	--	end
	--end)

	-- RETURN NUMBER OF ITEMS FROM SERVER
	RegisterNetEvent('esx_drugs:ReturnInventory')
	AddEventHandler('esx_drugs:ReturnInventory', function(cokeNbr, cokepNbr, methNbr, methpNbr, weedNbr, weedpNbr, opiumNbr, opiumpNbr, jobName, currentZone)
		cokeQTE	   = cokeNbr
		coke_poochQTE = cokepNbr
		methQTE 	  = methNbr
		meth_poochQTE = methpNbr
		weedQTE 	  = weedNbr
		weed_poochQTE = weedpNbr
		opiumQTE	   = opiumNbr
		opium_poochQTE = opiumpNbr
		myJob		 = jobName
		TriggerEvent('esx_drugs:hasEnteredMarker', currentZone)
	end)

	-- Activate menu when player is inside marker
	Citizen.CreateThread(function()
		while true do

			Citizen.Wait(3)

			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.ZoneSize.x / 2) then
					isInMarker  = true
					currentZone = k
				end
			end

			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone				= currentZone
				TriggerServerEvent('esx_drugs:GetUserInventory', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_drugs:hasExitedMarker', lastZone)
			end

			if isInMarker and isInZone then
				TriggerEvent('esx_drugs:hasEnteredMarker', 'exitMarker')
			end
		end
	end)

	-- Key Controls
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(10)
			if CurrentAction ~= nil then
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustReleased(0, Keys['E']) then
					isInZone = true -- unless we set this boolean to false, we will always freeze the user
					if CurrentAction == 'exitMarker' then
						isInZone = false -- do not freeze user
						CreateThread(function()
							Wait(7000)
							TriggerEvent(event1, false)
						end)
						TriggerEvent('esx_drugs:hasExitedMarker', lastZone)

						ClearPedTasks(GetPlayerPed(-1))
						Citizen.Wait(2500)
					elseif CurrentAction == 'CokeField' then
						TriggerServerEvent(event2)
						TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
					elseif CurrentAction == 'CokeProcessing' then
						TriggerServerEvent(event3)
						TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
					elseif CurrentAction == 'MethField' then
						TriggerServerEvent(event4)
						TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
					elseif CurrentAction == 'MethProcessing' then
						TriggerServerEvent(event5)
						TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
					elseif CurrentAction == 'WeedField' then
						TriggerServerEvent(event6)
						TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
					elseif CurrentAction == 'WeedProcessing' then
						TriggerServerEvent(event7)
						TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
					elseif CurrentAction == 'OpiumField' then
						TriggerServerEvent(event8)
						TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
					elseif CurrentAction == 'OpiumProcessing' then
						TriggerServerEvent(event9)
						TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
					else
						isInZone = false -- not a esx_drugs zone
					end
					
					if isInZone then
						TriggerEvent(event1, true)
					end
					
					CurrentAction = nil
				end
			end
		end
	end)

	RegisterNetEvent(event1)
	AddEventHandler(event1, function(freeze)
		FreezeEntityPosition(GetPlayerPed(-1), freeze)
	end)
end)