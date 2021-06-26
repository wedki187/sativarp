local chatInputActive = false
local chatInputActivating = false
local kropki = false
RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:addSuggestions')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:clear')

-- internal events
RegisterNetEvent('__cfx_internal:serverPrint')

RegisterNetEvent('_chat:messageEntered')

--deprecated, use chat:addMessage
AddEventHandler('chatMessage', function(author, color, text)
  local args = { text }
  if author ~= "" then
    table.insert(args, 1, author)
  end
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = {
      color = color,
      multiline = true,
      args = args
    }
  })
end)

AddEventHandler('chat:display', function(status)
	SendNUIMessage({
		type = (status and 'show' or 'hide')
	})
end)

AddEventHandler('__cfx_internal:serverPrint', function(msg)
  print(msg)

  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = {
      templateId = 'print',
      multiline = true,
      args = { msg }
    }
  })
end)

AddEventHandler('chat:addMessage', function(message)
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = message
  })
end)

AddEventHandler('chat:addSuggestion', function(name, help, params)
  SendNUIMessage({
    type = 'ON_SUGGESTION_ADD',
    suggestion = {
      name = name,
      help = help,
      params = params or nil
    }
  })
end)

AddEventHandler('chat:addSuggestions', function(suggestions)
  for _, suggestion in ipairs(suggestions) do
    SendNUIMessage({
      type = 'ON_SUGGESTION_ADD',
      suggestion = suggestion
    })
  end
end)

AddEventHandler('chat:removeSuggestion', function(name)
  SendNUIMessage({
    type = 'ON_SUGGESTION_REMOVE',
    name = name
  })
end)

RegisterNUICallback('statuschatu', function(data, cb)
  if data.status == "on" then
    TriggerServerEvent('chat:kropeczki', '...')
  elseif data.status == "off" then
    TriggerServerEvent('chat:kropeczki', '')
  end
end)


AddEventHandler('chat:addTemplate', function(id, html)
  SendNUIMessage({
    type = 'ON_TEMPLATE_ADD',
    template = {
      id = id,
      html = html
    }
  })
end)

AddEventHandler('chat:clear', function(name)
  SendNUIMessage({
    type = 'ON_CLEAR'
  })
end)

RegisterNUICallback('focus', function(data, cb)
  SetNuiFocus(true, true)
end)

RegisterNUICallback('unfocus', function(data, cb)
  SetNuiFocus(true, false)
end)

RegisterNUICallback('chatResult', function(data, cb)
  chatInputActive = false
  SetNuiFocus(false)

  if not data.canceled then
    local id = PlayerId()

    --deprecated
    local r, g, b = 0, 0x99, 255

    if data.message:sub(1, 1) == '/' then
      ExecuteCommand(data.message:sub(2))
    else
      TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), { r, g, b }, data.message)
    end
  end

  cb('ok')
end)

local function refreshCommands()
  if GetRegisteredCommands then
    local registeredCommands = GetRegisteredCommands()

    local suggestions = {}

    for _, command in ipairs(registeredCommands) do
        if IsAceAllowed(('command.%s'):format(command.name)) then
            table.insert(suggestions, {
                name = '/' .. command.name,
                help = ''
            })
        end
    end

    TriggerEvent('chat:addSuggestions', suggestions)
  end
end

AddEventHandler('onClientResourceStart', function(resName)
  Wait(500)

  refreshCommands()
end)

RegisterNUICallback('loaded', function(data, cb)
  TriggerServerEvent('chat:init');

  refreshCommands()

  cb('ok')
end)

Citizen.CreateThread(function()
  SetTextChatEnabled(false)
  SetNuiFocus(false)

  while true do
    Wait(0)

    if not chatInputActive then
      if IsControlPressed(0, 245) --[[ INPUT_MP_TEXT_CHAT_ALL ]] then
        chatInputActive = true
        chatInputActivating = true

        SendNUIMessage({
          type = 'ON_OPEN'
        })
      end
    end

    if chatInputActivating then
      if not IsControlPressed(0, 245) then
        SetNuiFocus(true)

        chatInputActivating = false
      end
    end
  end
end)



local opisy = {}

function DrawText3DOpis(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov*0.6
    if onScreen then
        SetTextScale(0.0*scale, 1.05*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(230, 255, 255, 150)
        SetTextDropshadow(3, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        World3dToScreen2d(x,y,z, 0) --Added Here
        DrawText(_x,_y)
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(5)
        sleep = true
        for _, player in ipairs(GetActivePlayers()) do
            local playerserverid = GetPlayerServerId(player)
            if opisy[playerserverid] ~= nil and tostring(opisy[playerserverid]) ~= '' then
                --local playercoords =  GetEntityCoords(GetPlayerPed(player))
                local playercoords = GetPedBoneCoords(GetPlayerPed(player), 31086, 0, 0, 0)
                distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), playercoords,  true)
                if distance < 20.0 then
                    sleep = false
                    DrawText3DOpis(playercoords.x, playercoords.y, playercoords.z+0.35, opisy[playerserverid])
                end
            end
        end
        if sleep then
            Wait(1000)
        end
    end
end)

RegisterNetEvent('chat:opis')
AddEventHandler('chat:opis', function(player, opis)
    opisy[player] = opis
end)