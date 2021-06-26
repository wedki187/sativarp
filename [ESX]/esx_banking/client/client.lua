ESX				= nil
inMenu			= true
local showblips	= true
local atbank	= false

function playAnim(animDict, animName, duration)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
	TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
	RemoveAnimDict(animDict)
end

local banks = {
	{name="Bank", id=108, x=150.266, y=-1040.203, z=29.374, principal = true},
	{name="Bank", id=108, x=-1212.980, y=-330.841, z=37.787, principal = true},
	{name="Bank", id=108, x=-2962.582, y=482.627, z=15.703, principal = true},
	{name="Bank", id=108, x=-112.202, y=6469.295, z=31.626, principal = true},
	{name="Bank", id=108, x=314.187, y=-278.621, z=54.170, principal = true},
	{name="Bank", id=108, x=-351.534, y=-49.529, z=49.042, principal = true},
	{name="Pacyfik", id=108, x=241.727, y=220.706, z=106.286, principal = true},
	{name="Bank", id=108, x=1175.0643310547, y=2706.6435546875, z=38.094036102295, principal = true}
}	

-- ATM Object Models
local ATMs = {
    {o = -870868698, c = 'blue'}, 
    {o = -1126237515, c = 'blue'}, 
    {o = -1364697528, c = 'red'}, 
    {o = 506770882, c = 'green'}
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local nearSth = nearBankOrATM()
		if nearSth ~= nil then
			if nearSth.type == "BANK" then
				DisplayHelpText("Naciśnij ~INPUT_PICKUP~ aby skorzystać z banku ~b~")

				if IsControlJustPressed(1, 38) then
					playAnim('mp_common', 'givetake1_a', 2500)
					Citizen.Wait(2500)
					inMenu = true
					SetNuiFocus(true, true)
					SendNUIMessage({type = 'openGeneral'})
					TriggerServerEvent('bank:balance')
				end
			elseif nearSth.type == 'ATM' then
				DisplayHelpText("Naciśnij ~INPUT_PICKUP~ aby skorzystać z bankomatu ~b~")

				if IsControlJustPressed(1, 38) then				
					local heading = isNearSomething.heading
					local newheading = 0
					if(heading >= 180) then
						newheading = heading + 360.0
					else
						newheading = heading - 360.0
					end
					SetEntityHeading(PlayerPedId(), newheading)

					playAnim('mp_common', 'givetake1_a', 2500)

					Citizen.Wait(2500)					

					inMenu = true
					SetNuiFocus(true, true)
					SendNUIMessage({type = 'openGeneral'})
					TriggerServerEvent('bank:balance')
				end
			end

			if IsControlJustPressed(1, 322) then
				inMenu = false
				SetNuiFocus(false, false)
				SendNUIMessage({type = 'close'})
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

function nearBankOrATM()
	local pCoords = GetEntityCoords(PlayerPedId())

	local nearObject = nil

	for i=1, #banks, 1 do
		local distance = GetDistanceBetweenCoords(banks[i].x, banks[i].y, banks[i].z, pCoords['x'], pCoords['y'], pCoords['z'], true)
		if distance < 3.0 then
			nearObject = {type = 'BANK'}
            break
        end
	end

	if nearObject == nil then
		for j=1, #ATMs, 1 do
			local getObject = GetClosestObjectOfType(pCoords, 0.6, ATMs[j].o, false)
			if DoesEntityExist(objHandle) then
                nearObject = {type = 'ATM', heading = GetEntityHeading(objHandle)}
                break
            end
		end
	end

	return nearObject
end

--[[function playerNearATM()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)

    for i = 1, #ATMs do
        local atm = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, ATMs[i].o, false, false, false)
        local atmPos = GetEntityCoords(atm)
        local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, atmPos.x, atmPos.y, atmPos.z, true)
        if dist < 1.5 then
            bankColor = ATMs[i].c
            return true
        end
    end
end

function nearBank()
	local player = GetPlayerPed(-1)
	local playerloc = GetEntityCoords(player, 0)
	
	for _, search in pairs(banks) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
		
		if distance <= 3 then
			return true
		end
	end
end]]

Citizen.CreateThread(function()
	if showblips then
		for k,v in ipairs(banks)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(blip, v.id)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		if v.principal ~= nil and v.principal then
			SetBlipColour(blip, 2)
		end
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(tostring(v.name))
		EndTextCommandSetBlipName(blip)
		end
	end
end)




RegisterNetEvent('currentbalance1')
AddEventHandler('currentbalance1', function(balance)
	local id = PlayerId()
	
	SendNUIMessage({
		type = "balanceHUD",
		balance = balance
		})
end)


RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('bank:deposit', tonumber(data.amount))
	TriggerServerEvent('bank:balance')
end)


RegisterNUICallback('withdrawl', function(data)
	TriggerServerEvent('bank:withdraw', tonumber(data.amountw))
	TriggerServerEvent('bank:balance')
end)


RegisterNUICallback('balance', function()
	TriggerServerEvent('bank:balance')
end)

RegisterNetEvent('balance:back')
AddEventHandler('balance:back', function(balance)
	SendNUIMessage({type = 'balanceReturn', bal = balance})
end)



RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('bank:transfer', data.to, data.amountt)
	TriggerServerEvent('bank:balance')
end)


RegisterNetEvent('bank:result')
AddEventHandler('bank:result', function(type, message)
	SendNUIMessage({type = 'result', m = message, t = type})
end)


RegisterNUICallback('NUIFocusOff', function()
	inMenu = false
	SetNuiFocus(false, false)
	playAnim('mp_common', 'givetake1_a', 2500)
	Citizen.Wait(2500)
	SendNUIMessage({type = 'closeAll'})
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end