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

local GUI                     = {}
GUI.Time                      = 0
local Instance                = {}
local InstanceInvite          = nil
local InstancedPlayers        = {}
local RegisteredInstanceTypes = {}
local InsideInstance          = false
ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
end)

function GetInstance()
	return Instance
end

function CreateInstance(type, data)
	TriggerServerEvent('instance:create', type, data)
end

function CloseInstance()
	Instance = {}
	TriggerServerEvent('instance:close')
	InsideInstance = false
end

function EnterInstance(instance)
	InsideInstance = true
	TriggerServerEvent('instance:enter', instance.host)

	if RegisteredInstanceTypes[instance.type].enter ~= nil then
		RegisteredInstanceTypes[instance.type].enter(instance)
	end
end

function LeaveInstance()
	if Instance.host ~= nil then

		if #Instance.players > 1 then
			TriggerEvent('esx:showNotification', _U('left_instance'))
		end

		if RegisteredInstanceTypes[Instance.type].exit ~= nil then
			RegisteredInstanceTypes[Instance.type].exit(Instance)
		end

		TriggerServerEvent('instance:leave', Instance.host)
	end

	InsideInstance = false
end

function InviteToInstance(type, player, data)
	TriggerServerEvent('instance:invite', Instance.host, type, player, data)
end

function RegisterInstanceType(type, enter, exit)
	RegisteredInstanceTypes[type] = {
		enter = enter,
		exit  = exit
	}
end

AddEventHandler('instance:get', function(cb)
	cb(GetInstance())
end)

AddEventHandler('instance:create', function(type, data)
	CreateInstance(type, data)
end)

AddEventHandler('instance:close', function()
	CloseInstance()
end)

AddEventHandler('instance:enter', function(instance)
	EnterInstance(instance)
end)

AddEventHandler('instance:leave', function()
	LeaveInstance()
end)

AddEventHandler('instance:invite', function(type, player, data)
	InviteToInstance(type, player, data)
end)

AddEventHandler('instance:registerType', function(name, enter, exit)
	RegisterInstanceType(name, enter, exit)
end)

RegisterNetEvent('instance:onInstancedPlayersData')
AddEventHandler('instance:onInstancedPlayersData', function(instancedPlayers)
	InstancedPlayers = instancedPlayers
end)

RegisterNetEvent('instance:onCreate')
AddEventHandler('instance:onCreate', function(instance)
	Instance = {}
end)

RegisterNetEvent('instance:onEnter')
AddEventHandler('instance:onEnter', function(instance)
	Instance = instance
end)

RegisterNetEvent('instance:onLeave')
AddEventHandler('instance:onClose', function(instance)
	Instance = {}
end)

RegisterNetEvent('instance:onClose')
AddEventHandler('instance:onClose', function(instance)
	Instance = {}
end)

RegisterNetEvent('instance:onPlayerEntered')
AddEventHandler('instance:onPlayerEntered', function(instance, player)
	Instance = instance
	local playerName = GetPlayerName(GetPlayerFromServerId(player))

	ESX.ShowNotification(_('entered_into', playerName))
end)

RegisterNetEvent('instance:onPlayerLeft')
AddEventHandler('instance:onPlayerLeft', function(instance, player)
	Instance = instance
	local playerName = GetPlayerName(GetPlayerFromServerId(player))

	ESX.ShowNotification(_('left_out', playerName))
end)

RegisterNetEvent('instance:onInvite')
AddEventHandler('instance:onInvite', function(instance, type, data)
	InstanceInvite = {
		type = type,
		host = instance,
		data = data
	}

	Citizen.CreateThread(function()
		Citizen.Wait(10000)

		if InstanceInvite ~= nil then
			ESX.ShowNotification(_U('invite_expired'))
			InstanceInvite = nil
		end
	end)
end)

RegisterInstanceType('default')

-- Input invites
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if InstanceInvite ~= nil then
			ESX.ShowHelpNotification(_U('press_to_enter'))
		else
			Citizen.Wait(500)
		end

	end
end)

-- Controls
Citizen.CreateThread(function()
	while true do
		if InstanceInvite ~= nil then
			Citizen.Wait(3)
			if IsControlPressed(0, Keys['E']) and (GetGameTimer() - GUI.Time) > 150 then
				EnterInstance(InstanceInvite)
				ESX.ShowNotification(_U('entered_instance'))
				InstanceInvite = nil
				GUI.Time = GetGameTimer()
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Instance players
local cache = {}
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(200)

    local tmp = {}
    for player, _ in pairs(InstancedPlayers) do
	  local pid = GetPlayerFromServerId(player)
	  if pid and pid ~= -1 then
        tmp[pid] = player
	  end
    end

    if Instance.host then
	  tmp[GetPlayerFromServerId(tonumber(Instance.host))] = nil
      for _, player in ipairs(Instance.players) do
	    local pid = GetPlayerFromServerId(player)
	    if pid and pid ~= -1 then
          tmp[pid] = nil
	    end
      end
	end

	local pid = PlayerId()
    for _, player in ipairs(GetActivePlayers()) do
      if player ~= pid then
	    local sid = tmp[player]
        if not sid then
		  local tid = GetPlayerServerId(player)
		  if tid and tid > 0 and cache[tid] then
			Citizen.InvokeNative(0xBBDF066252829606, player, false, false)
	        cache[tid] = nil
          end
		elseif not cache[sid] then
		  Citizen.InvokeNative(0xBBDF066252829606, player, true, false)
		  cache[sid] = true
		end
      end
	end

	for src, _ in pairs(cache) do
		local tid = GetPlayerFromServerId(src)
		if not tid or tid == -1 then
		  cache[src] = nil
		elseif not tmp[tid] then
		  Citizen.InvokeNative(0xBBDF066252829606, tid, false, false)
		  cache[src] = nil
		end
	end
  end
end)

Citizen.CreateThread(function()
	Citizen.Wait(3000)
	TriggerEvent('instance:loaded')
end)

-- Fix vehicles randomly spawning nearby the player inside an instance
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0) -- must be run every frame
		
		if InsideInstance then
			SetVehicleDensityMultiplierThisFrame(0.0)
			SetParkedVehicleDensityMultiplierThisFrame(0.0)

			local pos = GetEntityCoords(PlayerPedId())
			RemoveVehiclesFromGeneratorsInArea(pos.x - 900.0, pos.y - 900.0, pos.z - 900.0, pos.x + 900.0, pos.y + 900.0, pos.z + 900.0)
		else
			Citizen.Wait(5000)
		end
	end
end)