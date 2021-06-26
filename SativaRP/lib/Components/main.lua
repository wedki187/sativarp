ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

CreateThread(function() while true do Citizen.Wait(1) HideHudComponentThisFrame(14) HideHudComponentThisFrame(1) HideHudComponentThisFrame(2) HideHudComponentThisFrame(3) HideHudComponentThisFrame(4) HideHudComponentThisFrame(5) HideHudComponentThisFrame(6) HideHudComponentThisFrame(7) HideHudComponentThisFrame(8) HideHudComponentThisFrame(9) HideHudComponentThisFrame(13) HideHudComponentThisFrame(17) N_0x4757f00bc6323cfe(-1553120962, 0.0) end end)
CreateThread(function() while true do Citizen.Wait(1) N_0x4757f00bc6323cfe(GetHashKey('WEAPON_PISTOL'), 0.52) N_0x4757f00bc6323cfe(GetHashKey('WEAPON_UNARMED'), 0.63) N_0x4757f00bc6323cfe(GetHashKey('WEAPON_COMBATPISTOL'), 0.52) N_0x4757f00bc6323cfe(GetHashKey('WEAPON_COMPACTRIFLE'), 0.53) N_0x4757f00bc6323cfe(GetHashKey('WEAPON_PISTOL_MK2'), 0.46) N_0x4757f00bc6323cfe(GetHashKey('WEAPON_SNSPISTOL_MK2'), 0.41)N_0x4757f00bc6323cfe(GetHashKey('WEAPON_HEAVYPISTOL'), 0.68) N_0x4757f00bc6323cfe(GetHashKey('WEAPON_VINTAGEPISTOL'), 0.52) N_0x4757f00bc6323cfe(GetHashKey('WEAPON_SNSPISTOL'), 0.43) end end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
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
                end
            end

end) --  pierwsza kamera