CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100000)
	end
end)

local passengerDriveBy = false
Citizen.CreateThread(function()
	while true do
		Wait(25)
		playerPed = GetPlayerPed(-1)
		car = GetVehiclePedIsIn(playerPed, false)
		if car then
			if GetPedInVehicleSeat(car, -1) == playerPed then
				SetPlayerCanDoDriveBy(PlayerId(), false)
			elseif passengerDriveBy then
				SetPlayerCanDoDriveBy(PlayerId(), true)
			else
				SetPlayerCanDoDriveBy(PlayerId(), false)
			end
		end
	end
end)

local show3DText = true
local okay = true
RegisterNetEvent("pixel_antiCL:show")
AddEventHandler("pixel_antiCL:show", function()
    if show3DText then
        show3DText = true
    else
        show3DText = true
        if okay then
            if tonumber(okay) then
                Citizen.Wait(15000)
            else
                Citizen.Wait(15000)
            end
            show3DText = false
        end
    end
end)

RegisterNetEvent("pixel_anticl")
AddEventHandler("pixel_anticl", function(id, crds, identifier, reason)
    Display(id, crds, identifier, reason)
end)

function Display(id, crds, identifier, reason)
    local displaying = true

    CreateThread(function()
        Wait(20*1000)
        displaying = false
    end)
	
    CreateThread(function()
        while displaying do
            Wait(5)
            local pcoords = GetEntityCoords(PlayerPedId())
            if GetDistanceBetweenCoords(crds.x, crds.y, crds.z, pcoords.x, pcoords.y, pcoords.z, true) < 15.0 and show3DText then
                DrawText3DSecond(crds.x, crds.y, crds.z+0.15, "Gracz Wychodzi z Gry")
                DrawText3D(crds.x, crds.y, crds.z, "ID: "..id.." ("..identifier..")\nPowód: "..reason)
            else
                Citizen.Wait(2000)
            end
        end
    end)
end

function DrawText3DSecond(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.45, 0.45)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 0, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.45, 0.45)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

local firstSpawn = true
player = PlayerId()
AddEventHandler("playerSpawned", function()
    if firstSpawn then
    SetPlayerControl(player, false, 0)
    firstSpawn = false
    Wait(7000)
    TriggerServerEvent("esx:randylog")
    SetPlayerControl(player, true, 0)
    firstSpawn = false
    end
end)

RegisterCommand("voipfix", function(source, args, rawCommand)    
	print("Clearing Voice Target")
	exports['mumble-voip']:removePlayerFromRadio()
	exports['mumble-voip']:removePlayerFromCall()
	Citizen.Wait(50)
	NetworkClearVoiceChannel()
	MumbleIsConnected()
	NetworkSetTalkerProximity(3.5 + 0.0)
	print("Voice: Loaded")	
end)

local scaleform = nil

local IsWide = false

CreateThread(function()	
	while true do
		Citizen.Wait(1000)
        local res = GetIsWidescreen()
        if not res and not IsWide then
            ESX.TriggerServerCallback('SativaRP:checkBypass', function(bypass)
                if not bypass then
                    startTimer()
                    IsWide = true
                end
            end)
        elseif res and IsWide then
            IsWide = false
        end
	end
end)


function startTimer()
	local timer = 30

	CreateThread(function()
		while timer > 0 and IsWide do
			Citizen.Wait(1000)

			if timer > 0 then
                timer = timer - 1
                if timer == 0 then
                    TriggerServerEvent("SativaRP:dropplayer")
                end
			end
		end
	end)

	CreateThread(function()
		while true do
			Citizen.Wait(9000)
            if IsWide then
                PlaySound(-1, "SELECT", 'HUD_MINI_GAME_SOUNDSET', 0, 0, 1)
                PlaySound(-1, "SELECT", 'HUD_MINI_GAME_SOUNDSET', 0, 0, 1)
                PlaySound(-1, "SELECT", 'HUD_MINI_GAME_SOUNDSET', 0, 0, 1)
                ShowFreemodeMessage('~o~SativaRP.pl', 'Za 30 sekund dostaniesz bilet wylotu z powodu zbyt niskiego formatu obrazu - prosimy o zmianę na 16:9!', 30)
            else
                SetScaleformMovieAsNoLongerNeeded(scaleform)
            end
		end
	end)
end

function ShowFreemodeMessage(title, msg, sec)
    scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('MP_BIG_MESSAGE_FREEMODE')

	BeginScaleformMovieMethod(scaleform, 'SHOW_SHARD_WASTED_MP_MESSAGE')
	PushScaleformMovieMethodParameterString(title)
	PushScaleformMovieMethodParameterString(msg)
	EndScaleformMovieMethod()

	while sec > 0 do
		Citizen.Wait(1)
		sec = sec - 0.01

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end

	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

Citizen.CreateThread(function()
    while true do
        SetWeaponDamageModifier(-1553120962, 0.0)
        Wait(0)
    end
end)