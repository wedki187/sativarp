local mps = {

    tfs = 'Twenty Four Seven', robs = 'Robs Liquor',  ltd = 'LTD Gasoline', lspd = 'Komenda', lssd = 'Szeryfostwo', hypnonema = 'Kino Samochodowe', clotheshop = 'Sklep z Ubraniami', mcdonald = 'McDonald`s', gym = 'Siłownia', milk = 'Mleczarz', milk2 = 'Mleczarz #Pakowanie', milk3 = 'Mleczarz #Sprzedaż', court = 'Department of Justice', carzone = 'CarZone Garage', crouch = 'Kościół', bary = 'Bar', technik = 'Sklep Techniczny', repair = 'Stacja Naprawy', rybak = 'Rybak', rybaksell = 'Skup Ryb', benny = 'Warsztat "Benny`s"', weed = 'Plantacja Marihuany', mecanofajny = 'Mechanik', sad = 'Sad Jabłek',

    lspdc = 26, lssdc = 5, hypnonemac = 6, shopc = 2, gasolinec = 3, clotheshopc = 47, mcdonaldc = 46, gymc = 5, milkc = 64, courtc = 0, carzonec = 28, crouchc = 5, baryc = 1, technikc = 5, repairc = 47, rybakc = 1, rybaksellc = 5, bennyc = 2, weedc = 4, mecanofajnyc = 5, sadc = 4,

    lsb = 60, hypnonemab = 459, shopb = 52, gasolineb = 490, clotheshopb = 73, mcdonaldb = 78, gymb = 311, milkb = 285, courtb = 419, carzoneb = 523, crouchb = 305, baryb = 279, technikb = 459, repairb = 402, rybakb = 68, rybaksellb = 68, bennyb = 446, weedb = 140, mecanofajnyb = 72, sadb = 566,

    scale = 0.9, display = 4


}



local blips = {
--									  ['Police Stations']
    {title= mps.lspd , colour= mps.lspdc , id= mps.lsb , x=425.130, y=-979.558, z=30.711},
    {title= mps.lssd , colour= mps.lssdc , id= mps.lsb , x=391.44, y=-1619.65, z=29.29},  
    {title= mps.lssd , colour= mps.lssdc , id= mps.lsb , x = 1856.99, y = 3680.36, z = 33.82},
    {title= mps.lspd , colour= mps.lspdc , id= mps.lsb , x = 639.2009, y = 1.6311, z = 81.8369}, 
    {title= mps.lssd , colour= mps.lssdc , id= mps.lsb , x = -443.95, y = 6015.32, z = 33.82},
--										  ['Addons']
    {title= mps.hypnonema , colour= mps.hypnonemac , id= mps.hypnonemab , x = -1671.51, y = -902.78, z = 8.39},
    --{title= mps.benny , colour= mps.bennyc , id= mps.bennyb , x = -205.49, y = -1307.55, z = 31.26},
    {title= mps.mecanofajny , colour= mps.mecanofajnyc , id= mps.mecanofajnyb , x = 823.89, y = -880.80, z = 24.25},
    {title= mps.rybak , colour= mps.rybakc , id= mps.rybakb , x = 1693.59, y = 40.86, z = 161.77},
    {title= mps.rybaksell , colour= mps.rybaksellc , id= mps.rybaksellb , x = 1089.27, y = -774.54, z = 58.26},
    {title= mps.court, colour= mps.courtc, id= mps.courtb, x = 243.67, y = -1086.31, z = 28.840},
--										['CltoheSHOPS']
    {title= mps.clotheshop , colour= mps.clotheshopc , id= mps.clotheshopb , x = 72.254,    y = -1399.102, z = 28.376},
    {title= mps.clotheshop , colour= mps.clotheshopc , id= mps.clotheshopb , x = -703.776,  y = -152.258,  z = 36.415},
    {title= mps.clotheshop , colour= mps.clotheshopc , id= mps.clotheshopb , x = -167.863,  y = -298.969,  z = 38.733},
    {title= mps.clotheshop , colour= mps.clotheshopc , id= mps.clotheshopb , x = 428.694,   y = -800.106,  z = 28.491},
    {title= mps.clotheshop , colour= mps.clotheshopc , id= mps.clotheshopb , x = -829.413,  y = -1073.710, z = 10.328},
    {title= mps.clotheshop , colour= mps.clotheshopc , id= mps.clotheshopb , x = -1447.797, y = -242.461,  z = 48.820},
    {title= mps.clotheshop , colour= mps.clotheshopc , id= mps.clotheshopb , x = 11.632,    y = 6514.224,  z = 30.877},
    {title= mps.clotheshop , colour= mps.clotheshopc , id= mps.clotheshopb , x = 123.646,   y = -219.440,  z = 53.557},
    {title= mps.clotheshop , colour= mps.clotheshopc , id= mps.clotheshopb , x = 1696.291,  y = 4829.312,  z = 41.063},
    {title= mps.clotheshop , colour= mps.clotheshopc , id= mps.clotheshopb , x = 618.093,   y = 2759.629,  z = 41.088},
    {title= mps.clotheshop , colour= mps.clotheshopc , id= mps.clotheshopb , x = 1190.550,  y = 2713.441,  z = 37.222},
    {title= mps.clotheshop , colour= mps.clotheshopc , id= mps.clotheshopb , x = -1193.429, y = -772.262,  z = 16.324},
    {title= mps.clotheshop , colour= mps.clotheshopc , id= mps.clotheshopb , x = -3172.496, y = 1048.133,  z = 19.863},
    {title= mps.clotheshop , colour= mps.clotheshopc , id= mps.clotheshopb , x = -1108.441, y = 2708.923,  z = 18.107},
}
  
CreateThread(function()

    for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, mps.display)
        SetBlipScale(info.blip, mps.scale)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
        Citizen.Wait(1)
    end
end)
