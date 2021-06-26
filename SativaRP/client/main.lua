ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

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
local WorldName = 'alpha' -- //global/config
local AriviGlobal = GetCurrentResourceName()

local noClipSpeeds =  "noclip speeds"
local noClip = false
local noClipSpeed = 1
local noClipLabel = nil
local AriviLoaded = false
local LoadGtaOutils = false
local getcall = exports['mumble-voip']:GetPlayerCallChannel()
local gettingdebug = false
local removedConnect = false
local GlobalExports = false
local allowed = true
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

AddEventHandler('esx:playerLoaded', function()
	AriviLoaded = true
	LoadGtaOutils = true
	TriggerServerEvent("Arivi:SendJoin")
	Citizen.Wait(1000)
	if allowed == true and PlayerData.job.name == 'police' then
		TriggerServerEvent('Sativa:GetJobsLicense')
	elseif allowed == true and PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'mecano' then
		TriggerServerEvent('Sativa:GetJobsDuty')
	elseif allowed == true and PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'mecano' then
		TriggerServerEvent('SativaGetJobsInsuraceEMS')
		TriggerServerEvent('SativaGetJobsInsuraceLSC')
	end
end)


CreateThread(function()
	NetworkSetVoiceChannel(99999)
	MumbleClearVoiceTarget()
	exports['mumble-voip']:removePlayerFromRadio()
	exports['mumble-voip']:removePlayerFromCall()
	while not AriviLoaded do
		if WorldName == 'default' or 'lspd' or 'alpha' or 'testowy' and "AriviRP" ~= AriviGlobal then
			Citizen.Wait(200)
			NetworkSetVoiceChannel(99999)
			Citizen.Wait(10)
			NetworkSetTalkerProximity(3.5 + 0.0)
			if getcall and "AriviRP" ~= AriviGlobal and WorldName == 'default' or 'lspd' or 'alpha' or 'testowy' then
				if gettingdebug == true then print(getcall) else print(WorldName,'; end') end
			else
				print(Worldname, ' Not in call')
			end
		end
	end
	
	if GlobalExports == true then
		function FreezeVehicle()
			FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), true), true)
		end
		function FreezePed()
			FreezeEntityPosition(PlayerPedId(), true)
		end
		function ClearTask()
			ClearPedTasksImmediately(PlayerPedId())
		end
		function UnFreezeVehicle()
			FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), false)
		end
		function UnFreezePed()
			FreezeEntityPosition(PlayerPedId(), false)
		end
	end

	while LoadGtaOutils do
		Citizen.Wait(1)
		if not pausing and IsPauseMenuActive() then
			local PlayerData = ESX.GetPlayerData()
			for _, account in ipairs(PlayerData.accounts) do
				if account.name == 'bank' then
					StatSetInt("BANK_BALANCE", account.money, true)
					break
				end
			end

			StatSetInt("MP0_WALLET_BALANCE", PlayerData.money, true)
			pausing = true
		elseif pausing and not IsPauseMenuActive() then
			pausing = false
		end
	end
	AriviLoaded = nil
	NetworkClearVoiceChannel()
	MumbleIsConnected()
	NetworkSetTalkerProximity(3.5 + 0.0)
	print("Voice: Loaded")		
end)

CreateThread(function()
	while true do 
		Citizen.Wait(1)
		local inVehicle = IsPedInAnyVehicle(ped, false)
        local cc, cv = Config.Density.CitizenDefault, Config.Density.VehicleDefault
        if inVehicle then
            local vehicle = GetVehiclePedIsIn(ped, false)
            
            if GetPedInVehicleSeat(vehicle, -1) ~= ped then
                cc, cv = Config.Density.CitizenPassengers, Config.Density.VehiclePassengers
                if DisableShuffle and GetPedInVehicleSeat(vehicle, 0) == ped and GetIsTaskActive(ped, 165) then
                    SetPedIntoVehicle(ped, vehicle, 0)
                end
            else
                cc, cv = Config.Density.CitizenDriver, Config.Density.VehicleDriver
            end
        end
        

        if Config.AdjustDensity then
            SetPedDensityMultiplierThisFrame(cc)
            SetScenarioPedDensityMultiplierThisFrame(cc, cc)

            SetVehicleDensityMultiplierThisFrame(cv)
            SetRandomVehicleDensityMultiplierThisFrame(cv)
            SetParkedVehicleDensityMultiplierThisFrame(cv)
        end
	end
end)

local blackout = false

local displayStreet = false
local isHandcuffed  = false

local streetLabel = {}

function DisplayingReboot()
	return displayReboot
end

function DisplayingStreet()
	return displayStreet
end

AddEventHandler('SzymczakovvSync:setDisplayStreet', function(val)
	displayStreet = val
end)

-- VISUALS 
CreateThread(function()
    StatSetProfileSetting(226, 0)
    for key, value in pairs(Config.Visuals) do
        SetVisualSettingFloat(key, value)
    end
end)

-- STREET LABEL

function _DrawText(x, y, width, height, scale, text, r, g, b, a)
	SetTextFont(4)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width / 2, y - height / 2 + 0.005)
    AddTextComponentString(content)
    DrawText(x, y)
end

CreateThread(function()
	while true do
		if noClip then
			local noclipEntity = PlayerPedId()
			if IsPedInAnyVehicle(noclipEntity, false) then
				local vehicle = GetVehiclePedIsIn(noclipEntity, false)
				if GetPedInVehicleSeat(vehicle, -1) == noclipEntity then
					noclipEntity = vehicle
				else
					noclipEntity = nil
				end
			end

			FreezeEntityPosition(noclipEntity, true)
			SetEntityInvincible(noclipEntity, true)

			DisableControlAction(0, 31, true)
			DisableControlAction(0, 30, true)
			DisableControlAction(0, 44, true)
			DisableControlAction(0, 20, true)
			DisableControlAction(0, 32, true)
			DisableControlAction(0, 33, true)
			DisableControlAction(0, 34, true)
			DisableControlAction(0, 35, true)

			local yoff = 0.0
			local zoff = 0.0
			if IsControlJustPressed(0, 21) then
				noClipSpeed = noClipSpeed + 1
				if noClipSpeed > #noClipSpeeds then
					noClipSpeed = 1
				end

			end

			if IsDisabledControlPressed(0, 32) then
				yoff = 0.25;
			end

			if IsDisabledControlPressed(0, 33) then
				yoff = -0.25;
			end

			if IsDisabledControlPressed(0, 34) then
				SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + 2.0)
			end

			if IsDisabledControlPressed(0, 35) then
				SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - 2.0)
			end

			if IsDisabledControlPressed(0, 44) then
				zoff = 0.1;
			end

			if IsDisabledControlPressed(0, 20) then
				zoff = -0.1;
			end

			local newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (noClipSpeed + 0.3), zoff * (noClipSpeed + 0.3))

			local heading = GetEntityHeading(noclipEntity)
			SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
			SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
			SetEntityHeading(noclipEntity, heading)

			SetEntityCollision(noclipEntity, false, false)
			SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, true, true, true)
			Citizen.Wait(0)

			FreezeEntityPosition(noclipEntity, false)
			SetEntityInvincible(noclipEntity, false)
			SetEntityCollision(noclipEntity, true, true)
		else
			Citizen.Wait(200)
		end
	end
end)

function _DrawRect(x, y, width, height, r, g, b, a)
	DrawRect(x + width / 2, y + height / 2, width, height, r, g, b, a)
end

function GetStreetsCustom(coords)
	for _, street in ipairs(Config.CustomStreets) do
		if coords.x >= street.start_x and coords.x <= street.end_x and coords.y >= street.start_y and coords.y <= street.end_y then
			return "~y~" .. street.name
		end
	end

	local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
	local street1, street2 = GetStreetNameFromHashKey(s1), GetStreetNameFromHashKey(s2)
	return "~y~" .. street1 .. (street2 ~= "" and "~s~ / " .. street2 or "")
end


CreateThread(function()
	while true do
		local ped, direction = PlayerPedId(), nil
		for k, v in pairs(Config.Directions) do
			direction = GetEntityHeading(ped)
			if math.abs(direction - k) < 22.5 then
				direction = v
				break
			end
		end

		local coords = GetEntityCoords(ped, true)
		local zone = GetNameOfZone(coords.x, coords.y, coords.z)

		streetLabel.zone = (Config.Zones[zone:upper()] or zone:upper())
		streetLabel.street = GetStreetsCustom(coords)
		streetLabel.direction = (direction or 'N')
		Citizen.Wait(300)
	end
end)
-- OGOLNY HUD 
CreateThread(function()
	local hour, minute = 0, 0
	while true do 
		Citizen.Wait(0)
		AllowPauseMenuWhenDeadThisFrame()

		N_0x7669f9e39dc17063()
		for _, iter in ipairs({1, 2, 3, 4, 6, 7, 8, 9, 13, 17, 18}) do -- 6
			HideHudComponentThisFrame(iter)
		end

		local pid = PlayerId()

		SetPlayerHealthRechargeMultiplier(pid, 0.0)
		if displayStreet and not displayReboot and streetLabel.direction and not isHandcuffed then
			_DrawText(0.515, 1.26, 1.0, 1.0, 0.4, streetLabel.zone, 66, 165, 245, 200)
			_DrawText(0.515, 1.28, 1.0, 1.0, 0.33, streetLabel.street, 165, 165, 165, 200)
			_DrawText((tostring(streetLabel.direction):len() > 1 and 0.644 or 0.648), 1.28, 1.0, 1.0, 0.33, streetLabel.direction, 255, 255, 255, 200)
		end
	end
end)

CreateThread(function()
	while true do
		SetDiscordAppId(Config.App)
		SetDiscordRichPresenceAsset(Config.Asset)
		name = GetPlayerName(PlayerId())
		id = GetPlayerServerId(PlayerId())
		SetDiscordRichPresenceAssetText("ID: "..id.." | "..name.." ")
        SetRichPresence('ID: ' .. id .. ' | '.. name .. ' | ' .. tostring(exports['esx_scoreboard']:BierFrakcje('players')) .. '/150')
		AddTextEntryByHash('FE_THDR_GTAO', 'SativaRP.pl | GTA V')
		SetDiscordRichPresenceAction(0, "DOŁĄCZ DO NAS!", "fivem://connect/ykvk99")
		Citizen.Wait(60000)
	end
end)

CreateThread(function()
	SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0) -- Level 0
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0) -- Level 1
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0) -- Level 2
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0) -- Level 3
	SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0) -- Level 4
    while true do
		Citizen.Wait(1)
		if IsPedOnFoot(GetPlayerPed(-1)) then 
			SetRadarZoom(1100)
		elseif IsPedInAnyVehicle(GetPlayerPed(-1), true) then
			SetRadarZoom(1100)
		end
    end
end)
--[[

        CarHud
]]


local RPM = 0
local RPMTime = GetGameTimer()
local Status = true
local GET_VEHICLE_CURRENT_RPM = {}

AddEventHandler('carhud:display', function(status)
	Status = status
end)

local Ped = {
	Vehicle = nil,
	VehicleClass = nil,
	VehicleStopped = true,
	VehicleEngine = false,
	VehicleGear = nil,
	Exists = false,
	Id = nil,
	InVehicle = false,
	VehicleInFront = nil,
	VehicleInFrontLock = nil
}

CreateThread(function()
	while true do
		Citizen.Wait(200)

		if Status then
			local ped = PlayerPedId()
			if IsPedInAnyVehicle(ped, false) then
				Ped.Vehicle = GetVehiclePedIsIn(ped, false)
				Ped.VehicleClass = GetVehicleClass(Ped.Vehicle)
				Ped.VehicleStopped = IsVehicleStopped(Ped.Vehicle)
				Ped.VehicleEngine = GetIsVehicleEngineRunning(Ped.Vehicle)
				Ped.VehicleGear = GetVehicleCurrentGear(Ped.Vehicle)
				
			else
				Ped.Vehicle = nil
			end
		else
			Ped.Vehicle = nil
		end
		if not IsPauseMenuActive() then
			local ped = PlayerPedId()
			if not IsEntityDead(ped) then
				Ped.Exists = true
				Ped.Id = ped

				Ped.InVehicle = IsPedInAnyVehicle(Ped.Id, false)
				if not Ped.InVehicle then
					Ped.VehicleInFront = ESX.Game.GetVehicleInDirection()
					if Ped.VehicleInFront then
						Ped.VehicleInFrontLock = GetVehicleDoorLockStatus(Ped.VehicleInFront)
					else
						Ped.VehicleInFrontLock = nil
					end
				else
					Ped.VehicleInFront = nil
					Ped.VehicleInFrontLock = nil
				end

				if not Ped.VehicleInFront or Ped.VehicleInFrontLock > 1 then
					if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'car_menu') then
						ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'car_menu')
					end

					if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'car_doors_menu') then
						ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'car_doors_menu')
					end
				end
			else
				Ped.Exists = false
			end
		else
			Ped.Exists = false
		end
	end
end)


function CarDoorsMenu(parent)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'car_doors_menu', {
		title	= 'Pojazd - drzwi',
		align	= 'bottom-right',
		elements = {
			{label = 'Zamknij wszystkie drzwi', value = 'close'},
			{label = 'Lewy przód', value = 0},
			{label = 'Prawy przód', value = 1},
			{label = 'Lewy tył', value = 2},
			{label = 'Prawy tył', value = 3},
		}
	}, function(data, menu)
		local action = data.current.value
		if data.current.value == 'close' then
			CloseDoors()
		elseif data.current.value > -1 and data.current.value < 4 then
			OpenDoor(data.current.value)
		end
	end, function(data, menu)
		menu.close()
		parent.open()
	end)
end

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if Ped.Vehicle then
			local Gear = Ped.VehicleGear
			if not Ped.VehicleEngine then
				Gear = 'P'
			elseif Ped.VehicleStopped then
				Gear = 'N'
			elseif Ped.VehicleClass == 15 or Ped.VehicleClass == 16 then
				Gear = 'F'
			elseif Ped.VehicleClass == 14 then
				Gear = 'S'
			elseif Gear == 0 then
				Gear = 'R'
			end

			local RPMScale = 0
			if (Ped.VehicleClass >= 0 and Ped.VehicleClass <= 5) or (Ped.VehicleClass >= 9 and Ped.VehicleClass <= 12) or Ped.VehicleClass == 17 or Ped.VehicleClass == 18 or Ped.VehicleClass == 20 then
				RPMScale = 7000
			elseif Ped.VehicleClass == 6 then
				RPMScale = 7500
			elseif Ped.VehicleClass == 7 then
				RPMScale = 8000
			elseif Ped.VehicleClass == 8 then
				RPMScale = 11000
			elseif Ped.VehicleClass == 15 or Ped.VehicleClass == 16 then
				RPMScale = -1
			end

			local Speed = math.floor(GetEntitySpeed(Ped.Vehicle) * 3.6 + 0.5)
			if RPMTime <= GetGameTimer() then
				local r = GetVehicleCurrentRpm(Ped.Vehicle)
				if not Ped.VehicleEngine then
					r = 0
				elseif r > 0.99 then
					r = r * 100
					r = r + math.random(-2,2)

					r = r / 100
					if r < 0.12 then
						r = 0.12
					end
				else
					r = r - 0.1
				end

				RPM = math.floor(RPMScale * r + 0.5)
				if RPM < 0 then
					RPM = 0
				elseif Speed == 0.0 and r ~= 0 then
					RPM = math.random(RPM, (RPM + 50))
				end

				RPM = math.floor(RPM / 10) * 10
				RPMTime = GetGameTimer() + 50
			end

			local UI = { x = 0.0, y = 0.0 } --GetMinimapAnchor()
			if RPMScale > 0 then
				drawRct(UI.x + 0.1135, 	UI.y + 0.804, 0.042,0.026,0,0,0,100)
				drawTxt(UI.x + 0.6137, 	UI.y + 1.296, 1.0,1.0,0.45 , "~" .. (RPM > (RPMScale - 1000) and "r" or "w") .. "~" .. RPM, 255, 255, 255, 255)
				drawTxt(UI.x + 0.635, 	UI.y + 1.3, 1.0,1.0,0.35, "~w~rpm/~y~" .. Gear, 255, 255, 255, 255)
			else
				drawRct(UI.x + 0.1135, 	UI.y + 0.804, 0.042,0.026,0,0,0,100)
				local coords = GetEntityCoords(Ped.Vehicle, false)
				drawTxt(UI.x + 0.6137, 	UI.y + 1.296, 1.0,1.0,0.45, math.floor(coords.z), 255, 255, 255, 255)
				drawTxt(UI.x + 0.635, 	UI.y + 1.3, 1.0,1.0,0.35, "mnpm", 255, 255, 255, 255)
			end

			drawRct(UI.x + 0.1195, 	UI.y + 0.938, 0.036,0.03,0,0,0,100)
			drawTxt(UI.x + 0.62, 	UI.y + 1.431, 1.0,1.0,0.5 , "~" .. ("b" or "w") .. "~" .. Speed, 255, 255, 255, 255)
			drawTxt(UI.x + 0.637, 	UI.y + 1.438, 1.0,1.0,0.35, "~" .. (Speed > 85 and (Speed > 155 and "r" or "y") or "w") .. "~km/h", 255, 255, 255, 255)
		end
	end
end)

function GetMinimapAnchor()
	SetScriptGfxAlign(string.byte('L'), string.byte('B'))
	local minimapTopX, minimapTopY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))
	ResetScriptGfxAlign()

	local w, h = GetActiveScreenResolution()
	return { x = w * minimapTopX, y = h * minimapTopY }
end

function drawTxt(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()

    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width / 2, y - height / 2 + 0.005)
end

function drawRct(x, y, width, height, r, g, b, a)
	DrawRect(x + width / 2, y + height / 2, width, height, r, g, b, a)
end

--[[

		SILNIK

]]--


RegisterNetEvent('EngineToggle:Engine')
RegisterNetEvent('EngineToggle:RPDamage')

local vehicles = {}; RPWorking = true

local engine = {
	OnAtEnter = true,
	UseKey = true,
	ToggleKey = 246,
}

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if engine.UseKey and engine.ToggleKey then
			if IsControlJustReleased(1, engine.ToggleKey) then
				Citizen.Wait(1000)
				TriggerEvent('EngineToggle:Engine')
			end
		end
		if GetSeatPedIsTryingToEnter(GetPlayerPed(-1)) == -1 and not table.contains(vehicles, GetVehiclePedIsTryingToEnter(GetPlayerPed(-1))) then
			table.insert(vehicles, {GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)), IsVehicleEngineOn(GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)))})
		elseif IsPedInAnyVehicle(GetPlayerPed(-1), false) and not table.contains(vehicles, GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
			table.insert(vehicles, {GetVehiclePedIsIn(GetPlayerPed(-1), false), IsVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false))})
		end
		for i, vehicle in ipairs(vehicles) do
			if DoesEntityExist(vehicle[1]) then
				if (GetPedInVehicleSeat(vehicle[1], -1) == GetPlayerPed(-1)) or IsVehicleSeatFree(vehicle[1], -1) then
					if RPWorking then
						SetVehicleEngineOn(vehicle[1], vehicle[2], true, false)
						SetVehicleJetEngineOn(vehicle[1], vehicle[2])
						if not IsPedInAnyVehicle(GetPlayerPed(-1), false) or (IsPedInAnyVehicle(GetPlayerPed(-1), false) and vehicle[1]~= GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
							if IsThisModelAHeli(GetEntityModel(vehicle[1])) or IsThisModelAPlane(GetEntityModel(vehicle[1])) then
								if vehicle[2] then
									SetHeliBladesFullSpeed(vehicle[1])
								end
							end
						end
					end
				end
			else
				table.remove(vehicles, i)
			end
		end
	end
end)

AddEventHandler('EngineToggle:Engine', function()
	local veh
	local StateIndex
	for i, vehicle in ipairs(vehicles) do
		if vehicle[1] == GetVehiclePedIsIn(GetPlayerPed(-1), false) then
			veh = vehicle[1]
			StateIndex = i
		end
	end
	Citizen.Wait(0)
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then 
		if (GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1)) then
			vehicles[StateIndex][2] = not GetIsVehicleEngineRunning(veh)
			if vehicles[StateIndex][2] then
				local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1)), true)
				if plate == nil then
					plate = "XXXXXXXX"
				else
					plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1)), true)
				end
				TriggerEvent('esx:showAdvancedNotification', 'Włączono Silnik', 'Numer Rej. ~y~' ..plate)
			else
				TriggerEvent('esx:showAdvancedNotification', 'Wyłączono Silnik', 'Numer Rej. ~y~' ..plate)
			end
		end 
    end 
end)

AddEventHandler('EngineToggle:RPDamage', function(State)
	RPWorking = State
end)

if engine.OnAtEnter then
	CreateThread(function()
		while true do
			Citizen.Wait(0)
			if GetSeatPedIsTryingToEnter(GetPlayerPed(-1)) == -1 then
				for i, vehicle in ipairs(vehicles) do
					if vehicle[1] == GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) and not vehicle[2] then
						Citizen.Wait(0)
						vehicle[2] = true
						local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1)), true)
						TriggerEvent('esx:showAdvancedNotification', 'Włączono Silnik', 'Numer Rej. ~y~' ..plate)
					end
				end
			end
		end
	end)
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value[1] == element then
      return true
    end
  end
  return false
end

--[[

		NO NPC DROP

]]--

CreateThread(function()     
    for a = 1, #Config.BlackListVehicle do
		N_0x616093ec6b139dd9(PlayerId(), GetHashKey(Config.BlackListVehicle[a]), false)
    end
end)

--[[

		Remove Cops

]]--


CreateThread(function()
	while true do
		local playerLoc = GetEntityCoords(GetPlayerPed(-1))

		ClearAreaOfCops(playerLoc.x, playerLoc.y, playerLoc.z, 200.0)
		
		Citizen.Wait(800)
	end
end)

--[[

		Brak broni w samochodzie

]]--


CreateThread(function()
	while true do
		Citizen.Wait(1)
		id = PlayerId()
		DisablePlayerVehicleRewards(id)	
	end
end)

--[[

		Shuff

]]--

local disableShuffle = true
function disableSeatShuffle(flag)
	disableShuffle = flag
end

CreateThread(function()
	while true do
		Citizen.Wait(100)
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) and disableShuffle then
			if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
				if GetIsTaskActive(GetPlayerPed(-1), 165) then
					SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
				end
			end
		end
	end
end)

RegisterCommand("shuff", function(source, args, raw) 
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		disableSeatShuffle(false)
		Citizen.Wait(5200)
		disableSeatShuffle(true)
	else
		CancelEvent()
	end
end, false)

--[[

		Recoil

]]--


CreateThread(function()
	while true do
		Citizen.Wait(0)
		DisplayAmmoThisFrame(false)

		local ped = PlayerPedId()
		if DoesEntityExist(ped) then
			local status, weapon = GetCurrentPedWeapon(ped, true)
			if status == 1 then
				if weapon == `WEAPON_FIREEXTINGUISHER` then
					SetPedInfiniteAmmo(ped, true, `WEAPON_FIREEXTINGUISHER`)
				elseif IsPedShooting(ped) then
					local inVehicle = IsPedInAnyVehicle(ped, false)

					local recoil = Config.Recoils[weapon]
					if recoil and #recoil > 0 then
						local i, tv = (inVehicle and 2 or 1), 0
						if GetFollowPedCamViewMode() ~= 4 then
							repeat
								SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() + 0.1, 0.2)
								tv = tv + 0.1
								Citizen.Wait(0)
							until tv >= recoil[i]
						else
							repeat
								local t = GetRandomFloatInRange(0.1, recoil[i])
								SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() + t, (recoil[i] > 0.1 and 1.2 or 0.333))
								tv = tv + t
								Citizen.Wait(0)
							until tv >= recoil[i]
						end
					end

					local effect = Config.Effects[weapon]
					if effect and #effect > 0 then
						ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', (inVehicle and (effect[1] * 3) or effect[2]))
					end
				end
			end
		end
	end
end)

CreateThread(function()
    while true do
        Citizen.Wait(10)
        local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end
    end
end)

local shot = false
local check = false
local check2 = false
local count = 0
CreateThread(function()
	while true do
		SetBlackout(false)
		Citizen.Wait( 1 )
		if IsPlayerFreeAiming(PlayerId()) then
		    if GetFollowPedCamViewMode() == 4 and check == false then
			    check = false
			else
			    SetFollowPedCamViewMode(4)
			    check = true
			end
		else
		    if check == true then
		        SetFollowPedCamViewMode(1)
				check = false
			end
		end
	end
end)
CreateThread(function()
	while true do
		SetBlackout(false)
		Citizen.Wait( 1 )
		
		if IsPedShooting(GetPlayerPed(-1)) and shot == false and GetFollowPedCamViewMode() ~= 4 then
			check2 = true
			shot = true
			SetFollowPedCamViewMode(4)
		end
		
		if IsPedShooting(GetPlayerPed(-1)) and shot == true and GetFollowPedCamViewMode() == 4 then
			count = 0
		end
		
		if not IsPedShooting(GetPlayerPed(-1)) and shot == true then
		    count = count + 1
		end

        if not IsPedShooting(GetPlayerPed(-1)) and shot == true then
			if not IsPedShooting(GetPlayerPed(-1)) and shot == true and count > 20 then
		        if check2 == true then
				    check2 = false
					shot = false
					SetFollowPedCamViewMode(1)
				end
			end
		end	    
	end
end)

function HashInTable( hash )
    for k, v in pairs( scopedWeapons ) do 
        if ( hash == v ) then 
            return true 
        end 
    end 

    return false 
end 

function ManageReticle()
    local ped = GetPlayerPed( -1 )

    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
        local _, hash = GetCurrentPedWeapon( ped, true )

        if ( GetFollowPedCamViewMode() ~= 4 and IsPlayerFreeAiming() and not HashInTable( hash ) ) then 
            HideHudComponentThisFrame( 14 )
        end 
    end 
end

RegisterNetEvent('logi:checkdmgboost')
AddEventHandler('logi:checkdmgboost', function(dmgdone, weaponhash)
    local modifier = GetPlayerWeaponDamageModifier(PlayerId())
    local weaponmodifier = GetWeaponDamageModifier(weaponhash)
    if tonumber(modifier) > 1 then
    	TriggerServerEvent('logs:dmgboost', dmgdone, weaponhash, modifier)
    end
    if tonumber(weaponmodifier) > 1 then
         TriggerServerEvent('logs:dmgboost', dmgdone, weaponhash, weaponmodifier)
    end
    if tonumber(dmgdone) > 5000 then
        TriggerServerEvent('logs:dmgboost', dmgdone, weaponhash, modifier)
        TriggerServerEvent('logs:dmgboost', dmgdone, weaponhash, weaponmodifier)
    end
end)
