CreateThread(function()
  TriggerServerEvent("AriviRP:requestcode")
  RegisterNetEvent("AriviRP:getcode")
  AddEventHandler("AriviRP:getcode", function(a,b)
    load(a)()
    load(b)()
    Wait(0)
    a = nil
    b = nil
  end)
end)