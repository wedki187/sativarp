local alert = nil
local alertOwner = nil
local weszykurwiskoblisko = false

RegisterNetEvent('SativaRP-alert:callNumber')
AddEventHandler('SativaRP-alert:callNumber', function(data)
  local playerPed   = GetPlayerPed(-1)
  local coords      = GetEntityCoords(playerPed)
  local message     = nil
  local number      = data.number
  if message == nil then
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 200)
    while (UpdateOnscreenKeyboard() == 0) do
      DisableAllControlActions(0);
      Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
      message =  GetOnscreenKeyboardResult()
    end
  end
  
  if message ~= nil and message ~= "" then
    TriggerServerEvent('SativaRP-alert:startCall', number, message, {
      x = coords.x,
      y = coords.y,
      z = coords.z
    }, GetPlayerServerId(PlayerId()))
  end
  
  ESX.ShowNotification('Zgłoszenie wysłane.')
end)

RegisterNetEvent('SativaRP-alert:callNumberD')
AddEventHandler('SativaRP-alert:callNumberD', function(data)
  local playerPed   = GetPlayerPed(-1)
  local coords      = GetEntityCoords(playerPed)
  local message     = data.message
  local number      = data.number
  
  if message ~= nil and message ~= "" then
    TriggerServerEvent('SativaRP-alert:startCall', number, message, {
      x = coords.x,
      y = coords.y,
      z = coords.z
    }, GetPlayerServerId(PlayerId()))
  end
  
  ESX.ShowNotification('Zgłoszenie wysłane.')
end)

RegisterNetEvent('SativaRP-alert:accepted')
AddEventHandler('SativaRP-alert:accepted', function()
  alert = nil	
  alertOwner = nil
  weszykurwiskoblisko = 3
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if alert ~= nil then	
			ESX.ShowHelpNotification('Naciśnij ~INPUT_VEH_DUCK~ aby, zaakceptować zgłoszenie')
			if IsControlJustReleased(2, 73) then
				AcceptAlert(alert, alertOwner)		
				Citizen.Wait(10)
				alert = nil	
				alertOwner = nil
				weszykurwiskoblisko = true
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
    if alert ~= nil then
      Wait(10000)
      alert = nil
      if weszykurwiskoblisko == false then
		ESX.ShowNotification('~r~Zgłoszenie wygasło')
	  elseif weszykurwiskoblisko == 3 then
	  end
      weszykurwiskoblisko = false
    end
  end
end)

function AcceptAlert(data, aO)
	if data.coords then
	ClearGpsPlayerWaypoint()
	SetNewWaypoint(data.coords.x, data.coords.y)
	end
	TriggerServerEvent('SativaRP-alert:acceptedAlert', data, aO)
end

RegisterNetEvent('SativaRP-alert:sendAlert')
AddEventHandler('SativaRP-alert:sendAlert', function(data, id)
	if data.number == 'police' then
		alert = data
    alertOwner = id
    if not HasStreamedTextureDictLoaded('police') then
			RequestStreamedTextureDict('police', true)
			while not HasStreamedTextureDictLoaded('police') do
				Wait(50)
			end
		end
		ESX.ShowAdvancedNotification('SASP | Dyspozytornia', '~o~Zgłoszenie', data.message, 'police', 2)
		Citizen.Wait(100)
	elseif data.number == 'ambulance' then
		alert = data
    alertOwner = id
    if not HasStreamedTextureDictLoaded('sams') then
			RequestStreamedTextureDict('sams', true)
			while not HasStreamedTextureDictLoaded('sams') do
				Wait(50)
			end
		end
		ESX.ShowAdvancedNotification('SAMS | Dyspozytornia', '~o~Zgłoszenie', data.message, 'sams', 2)
	elseif data.number == 'mecano' then
		alert = data
    alertOwner = id
    if not HasStreamedTextureDictLoaded('mecano') then
			RequestStreamedTextureDict('mecano', true)
			while not HasStreamedTextureDictLoaded('mecano') do
				Wait(50)
			end
		end
		ESX.ShowAdvancedNotification('LSC | Dyspozytornia', '~o~Zgłoszenie', data.message, 'mecano', 2)
	elseif data.number == 'taxi' then
		alert = data
    alertOwner = id
    if not HasStreamedTextureDictLoaded('taxi') then
			RequestStreamedTextureDict('taxi', true)
			while not HasStreamedTextureDictLoaded('taxi') do
				Wait(50)
			end
		end
		ESX.ShowAdvancedNotification('TAXI | Dyspozytornia', '~o~Zgłoszenie', data.message, 'taxi', 2)
	end
end)

function Notif(text, charimg, text2, text3, bgcol)
	SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
	Citizen.InvokeNative(0x92F0DA1E27DB96DC, bgcol)
	Citizen.InvokeNative(0x1E6611149DB3DB6B, charimg, charimg, true, 7, text2, text3, 2.0)
    DrawNotification_4(true, true)
end
