-- {steamID, points, source}
local players = {}

-- {steamID}
local waiting = {}

-- {steamID}
local connecting = {}

-- Points initiaux (prioritaires ou négatifs)
local prePoints = Config.Points;

-- Emojis pour la loterie
local EmojiList = Config.EmojiList
WhiteList = {}
WhitelistStatus = true

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

StopResource('hardcap')

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if GetResourceState('hardcap') == 'stopped' then
			StartResource('hardcap')
		end
	end
end)

-- Connexion d'un client
AddEventHandler("playerConnecting", function(name, reject, def)
	local source	= source
	local steamID = GetSteamID(source)


	-- pas de steam ? ciao
	if not steamID then
		reject(Config.NoSteam)
		CancelEvent()
		return
	end

    if #WhiteList == 0 then
		reject("Whitelist'a nie została jeszcze załadowana")
		CancelEvent()
		return
	end

	-- Lancement de la rocade, 
	-- si cancel du client : CancelEvent() pour ne pas tenter de co.
	if not Rocade(steamID, def, source) then
		CancelEvent()
	end
end)

-- Fonction principale, utilise l'objet "deferrals" transmis par l'evenement "playerConnecting"
function Rocade(steamID, def, source)
	def.defer()
    if WhitelistStatus then
        def.update("Trwa sprawdzanie whitelist'y...")
        local wl = CheckWhitelist(steamID)
        while wl == nil do
            Citizen.Wait(100)
        end
        if wl == 2 then
            def.done('Nie znajdujesz się na allow liscie. Aplikuj na discord.gg/sativarp')
            CancelEvent()
            return
        elseif wl ~= 1 then
            def.done(ticket)
            CancelEvent()
            return
        end
    end

	-- faire patienter un peu pour laisser le temps aux listes de s'actualiser
	AntiSpam(def)

	-- retirer notre ami d'une éventuelle liste d'attente ou connexion
	Purge(steamID)

	-- l'ajouter aux players
	-- ou actualiser la source
	AddPlayer(steamID, source)

	-- le mettre en file d'attente
	table.insert(waiting, steamID)

	-- tant que le steamID n'est pas en connexion
	local stop = false
	repeat

		for i,p in ipairs(connecting) do
			if p == steamID then
				stop = true
				break
			end
		end

	-- Hypothèse: Quand un joueur en file d'attente a un ping = 0, ça signifie que la source est perdue

	-- Détecter si l'user clique sur "cancel"
	-- Le retirer de la liste d'attente / connexion
	-- Le message d'accident ne devrait j'amais s'afficher
		for j,sid in ipairs(waiting) do
			for i,p in ipairs(players) do
				-- Si un joueur en file d'attente a un ping = 0
				if sid == p[1] and p[1] == steamID and (GetPlayerPing(p[3]) == 0) then
					-- le purger
					Purge(steamID)
					-- comme il a annulé, def.done ne sert qu'à identifier un cas non géré
					def.done(Config.Accident)

					return false
				end
			end
		end

		-- Mettre à jour le message d'attente
		def.update(GetMessage(steamID))

		Citizen.Wait(Config.TimerRefreshClient * 1000)

	until stop
	
	-- quand c'est fini, lancer la co
	def.done()
	return true
end

-- Vérifier si une place se libère pour le premier de la file
Citizen.CreateThread(function()
	local maxServerSlots = GetConvarInt('sv_maxclients', 250)
	
	while true do
		Citizen.Wait(Config.TimerCheckPlaces * 1000)

		CheckConnecting()

		-- si une place est demandée et disponible
		if #waiting > 0 and #connecting + #GetPlayers() < maxServerSlots then
			ConnectFirst()
		end
	end
end)

-- Mettre régulièrement les points à jour
Citizen.CreateThread(function()
	while true do
		UpdatePoints()

		Citizen.Wait(Config.TimerUpdatePoints * 1000)
	end
end)

-- Lorsqu'un joueur est kick
-- lui retirer le nombre de points fourni en argument
RegisterServerEvent("rocademption:playerKicked")
AddEventHandler("rocademption:playerKicked", function(src, points)
	local sid = GetSteamID(src)

	Purge(sid)

	for i,p in ipairs(prePoints) do
		if p[1] == sid then
			p[2] = p[2] - points
			return
		end
	end

	local initialPoints = GetInitialPoints(sid)

	table.insert(prePoints, {sid, initialPoints - points})
end)

-- Quand un joueur spawn, le purger
RegisterServerEvent("rocademption:playerConnected")
AddEventHandler("rocademption:playerConnected", function()
	local sid = GetSteamID(source)

	Purge(sid)
end)

-- Quand un joueur drop, le purger
AddEventHandler("playerDropped", function(reason)
	local steamID = GetSteamID(source)

	Purge(steamID)
end)

-- si le ping d'un joueur en connexion semble partir en couille, le retirer de la file
-- Pour éviter un fantome en connexion
function CheckConnecting()
	for i,sid in ipairs(connecting) do
		for j,p in ipairs(players) do
			if p[1] == sid and (GetPlayerPing(p[3]) == 500) then
				table.remove(connecting, i)
				break
			end
		end
	end
end

-- ... connecte le premier de la file
function ConnectFirst()
	if #waiting == 0 then return end

	local maxPoint = 0
	local maxSid = waiting[1][1]
	local maxWaitId = 1

	for i,sid in ipairs(waiting) do
		local points = GetPoints(sid)
		if points > maxPoint then
			maxPoint = points
			maxSid = sid
			maxWaitId = i
		end
	end
	
	table.remove(waiting, maxWaitId)
	table.insert(connecting, maxSid)
end

-- retourne le nombre de kilomètres parcourus par un steamID
function GetPoints(steamID)
	for i,p in ipairs(players) do
		if p[1] == steamID then
			return p[2]
		end
	end
end

-- Met à jour les points de tout le monde
function UpdatePoints()
	for i,p in ipairs(players) do

		local found = false

		for j,sid in ipairs(waiting) do
			if p[1] == sid then
				p[2] = p[2] + Config.AddPoints
				found = true
				break
			end
		end

		if not found then
			for j,sid in ipairs(connecting) do
				if p[1] == sid then
					found = true
					break
				end
			end
		
			if not found then
				p[2] = p[2] - Config.RemovePoints
				if p[2] < GetInitialPoints(p[1]) - Config.RemovePoints then
					Purge(p[1])
					table.remove(players, i)
				end
			end
		end

	end
end

function AddPlayer(steamID, source)
	for i,p in ipairs(players) do
		if steamID == p[1] then
			players[i] = {p[1], p[2], source}
			return
		end
	end

	local initialPoints = GetInitialPoints(steamID)
	table.insert(players, {steamID, initialPoints, source})
end

function GetInitialPoints(steamID)
	local points = Config.RemovePoints + 1

	for n,p in ipairs(prePoints) do
		if p[1] == steamID then
			points = p[2]
			break
		end
	end

	return points
end

function GetPlace(steamID)
	local points = GetPoints(steamID)
	local place = 1

	for i,sid in ipairs(waiting) do
		for j,p in ipairs(players) do
			if p[1] == sid and p[2] > points then
				place = place + 1
			end
		end
	end
	
	return place
end

function GetMessage(steamID)
	local msg = ""
	local witam = "NIE" 
	local rodzajbiletu = 'Standardowy'
	if GetPoints(steamID) ~= nil then
		if GetPoints(steamID) > 150 then
			rodzajbiletu = 'Srebrny'
		end
		if GetPoints(steamID) > 200 then
			rodzajbiletu = 'Złoty'
		end
		if GetPoints(steamID) > 350 then
			rodzajbiletu = 'Diamentowy'
		end
		if GetPoints(steamID) > 400 then
			rodzajbiletu = 'Boostery'
		end
		if GetPoints(steamID) > 5500 then
			rodzajbiletu = 'Admin'
		end
		
		msg = '\n\n' .. Config.EnRoute .. " " .. " Rodzaj biletu: " .. rodzajbiletu ..".\n"

		msg = msg .. Config.Position .. GetPlace(steamID) .. "/".. #waiting .. " " .. ".\n"

		msg = msg .. "-- ( " .. Config.EmojiMsg

		local e1 = RandomEmojiList()
		local e2 = RandomEmojiList()
		local e3 = RandomEmojiList()
		local emojis = e1 .. e2 .. e3

		if( e1 == e2 and e2 == e3 ) then
			emojis = emojis .. Config.EmojiBoost
			LoterieBoost(steamID)
		end

		-- avec les jolis emojis
		msg = msg .. emojis .. " ) --"
	else
		msg = Config.Error
	end

	return msg
end

function LoterieBoost(steamID)
	for i,p in ipairs(players) do
		if p[1] == steamID then
			p[2] = p[2] + Config.LoterieBonusPoints
			return
		end
	end
end

function Purge(steamID)
	for n,sid in ipairs(connecting) do
		if sid == steamID then
			table.remove(connecting, n)
		end
	end

	for n,sid in ipairs(waiting) do
		if sid == steamID then
			table.remove(waiting, n)
		end
	end
end

function AntiSpam(def)
	for i=Config.AntiSpamTimer,0,-1 do
		def.update(Config.PleaseWait_1 .. i .. Config.PleaseWait_2)
		Citizen.Wait(1000)
	end
end

function RandomEmojiList()
	randomEmoji = EmojiList[math.random(#EmojiList)]
	return randomEmoji
end

-- Helper pour récupérer le steamID or false
function GetSteamID(src)
	local sid = GetPlayerIdentifiers(src)[1] or false

	if (sid == false or sid:sub(1,5) ~= "steam") then
		return false
	end

	return sid
end

CheckWhitelist = function(steamID)
	local found = 2

	for i=1, #WhiteList, 1 do
		local whitelist = WhiteList[i]
		if whitelist.steamID ~= nil then
			if string.match(whitelist.steamID, "steam:") then
				if steamID == whitelist.steamID:lower() then
					found = 1
				end
			end
		end
	end
	return found
end

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(6000)
	  loadWhiteList()
	end
end)

loadWhiteList = function()
	local PreWhiteList = {}

	MySQL.Async.fetchAll('SELECT * FROM whitelist', {}, function (player)
		for i=1, #player, 1 do
			table.insert(PreWhiteList, {
				steamID = tostring(player[i].identifier):lower(),
			})
		end

		while (#PreWhiteList ~= #player) do
			Citizen.Wait(10)
		end

		WhiteList = PreWhiteList
	end)
end

RegisterCommand('wlrefresh', function (source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.group == 'best' or xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'moderator' or xPlayer.group == 'support') then
		loadWhiteList(function()
		end)
        xPlayer.showNotification('Whitelist przeładowana!')
	else
		xPlayer.showNotification('Nie posiadasz permisji')
	end
end, false)


RegisterCommand('wladd', function (source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.group == 'best' or xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'mod' or xPlayer.group == 'support') then
		local steamID = 'steam:' .. args[1]:lower()

		if string.len(steamID) ~= 21 then
			TriggerEvent('esx_whitelist:sendMessage', source, '^1SYSTEM', 'Invalid steam ID length!')
			return
		end

		MySQL.Async.fetchAll('SELECT * FROM whitelist WHERE identifier = @identifier', {
			['@identifier'] = steamID
		}, function(result)
			if result[1] ~= nil then
				xPlayer.showNotification('Gracz ju¿ posiada whitelist!')
			else
				MySQL.Async.execute('INSERT INTO whitelist (identifier) VALUES (@identifier)', {
					['@identifier'] = steamID
				}, function (rowsChanged)
					table.insert(WhiteList, steamID)
					xPlayer.showNotification('Whitelist dodana!')
				end)
			end
		end)
	else
		xPlayer.showNotification('Nie posiadasz permisji')
	end
end, false)

AddEventHandler('esx_whitelist:sendMessage', function(source, title, message)
	if source ~= 0 then
		TriggerClientEvent('chat:addMessage', source, { args = { title, message } })
	else
	end
end)

MySQL.ready(function()
	loadWhiteList()
end)