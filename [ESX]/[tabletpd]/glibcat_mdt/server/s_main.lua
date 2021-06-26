ESX = nil
timer = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('playerDropped', function()	
	local playerId = source
	if Config.useOnDutyTime then
		if playerId then
			local xPlayer = ESX.GetPlayerFromId(playerId)
			if xPlayer then
				local job = xPlayer.getJob()

				if job.name == Config.jobName then
					local identifier = xPlayer.getIdentifier()
					local currentTime = os.time()
					local timeOnline = currentTime - timer[identifier]

					MySQL.Async.execute('UPDATE user_police_time SET time = time + @timeOnline WHERE identifier=@identifier', 
					{
						['@identifier'] = identifier,
						['@timeOnline'] = timeOnline,         
					})

					timer[identifier] = nil
				end
			end
		end
	end
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	else
		if Config.useOnDutyTime then
			local xPlayers = ESX.GetPlayers()
			
			for i=1, #xPlayers, 1 do
				local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
				local job = xPlayer.getJob()
				
				if job.name == Config.jobName then
					local identifier = xPlayer.getIdentifier()
					local currentTime = os.time()
						
					timer[identifier] = currentTime
					
					SetTimeout(Config.timeOnlineRefresh, function()
						updateTime(identifier) 
					end)
				end	
			end
		end
	end
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	else
		if Config.useOnDutyTime then
			local xPlayers = ESX.GetPlayers()
			for i=1, #xPlayers, 1 do
				local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
				local job = xPlayer.getJob()
				if job.name == Config.jobName then
					local identifier = xPlayer.getIdentifier()
					local currentTime = os.time()
					local timeOnline = currentTime - timer[identifier]
					
					MySQL.Sync.execute('UPDATE user_police_time SET time = time + @timeOnline WHERE identifier = @identifier', 
					{
						['@identifier'] = identifier,
						['@timeOnline'] = timeOnline,         
					})

					timer[identifier] = nil
				end	
			end
		end
	end
end)

function updateTime(identifier)
	local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
	if xPlayer then 
		local job = xPlayer.getJob()

		if job.name == Config.jobName then
			local currentTime = os.time()
			if timer[identifier] then
				local timeOnline = currentTime - timer[identifier]
				
				MySQL.Async.execute('UPDATE user_police_time SET time = time + @timeOnline WHERE identifier=@identifier', 
				{
					['@identifier'] = identifier,
					['@timeOnline'] = timeOnline,         
				})

				timer[identifier] = currentTime
				SetTimeout(Config.timeOnlineRefresh, function()
					updateTime(identifier) 
				end)
			end
		end
	end
end

RegisterNetEvent('glibcat_mdt:startTimer')
AddEventHandler('glibcat_mdt:startTimer', function(xPlayer)
	local playerId = source

	local currentTime = os.time()

	MySQL.Async.fetchAll('SELECT * FROM user_police_time WHERE identifier = @identifier',
	{
		['@identifier'] = xPlayer.identifier,
	}, 
	function(result)
		if not result[1] then
			MySQL.Async.insert('INSERT INTO user_police_time (identifier) VALUES (@identifier) ',
			{
				['@identifier'] = xPlayer.identifier,
			})	
		end
	end)
		
	timer[xPlayer.identifier] = currentTime

	SetTimeout(Config.timeOnlineRefresh, function()
		updateTime(xPlayer.identifier) 
	end)
end)

RegisterNetEvent('glibcat_mdt:timerHire')
AddEventHandler('glibcat_mdt:timerHire', function(identifier)
	local currentTime = os.time()

	MySQL.Async.fetchAll('SELECT * FROM user_police_time WHERE identifier = @identifier',
	{
		['@identifier'] = identifier,
	}, 
	function(result)
		if not result[1] then
			MySQL.Async.insert('INSERT INTO user_police_time (identifier) VALUES (@identifier) ',
			{
				['@identifier'] = identifier,
			})	
		end
	end)

	timer[identifier] = currentTime
	SetTimeout(Config.timeOnlineRefresh, function()
		updateTime(identifier) 
	 end)
end)

RegisterNetEvent('glibcat_mdt:dutyStart')
AddEventHandler('glibcat_mdt:dutyStart', function(playerId, job)
	if job == Config.offDutyJobName then	
		local xPlayer = ESX.GetPlayerFromId(playerId)
		local identifier = xPlayer.getIdentifier()
		local currentTime = os.time()

		timer[identifier] = currentTime
		SetTimeout(Config.timeOnlineRefresh, function()
			updateTime(identifier) 
	   end)
	end
end)

RegisterNetEvent('glibcat_mdt:dutyStop')
AddEventHandler('glibcat_mdt:dutyStop', function(playerId, job)
	if job == Config.jobName then	
		local xPlayer = ESX.GetPlayerFromId(playerId)
		local identifier = xPlayer.getIdentifier()

		local currentTime = os.time()
		local timeOnline = currentTime - timer[identifier]
		
		MySQL.Async.execute('UPDATE user_police_time SET time = time + @timeOnline WHERE identifier=@identifier', 
		{
			['@identifier'] = identifier,
			['@timeOnline'] = timeOnline,           
		})
		
		timer[identifier] = nil
	end
end)

------------- URUCHOMIENIE TABLETU -------------
ESX.RegisterServerCallback('glibcat_mdt:startingCallback', function(playerId, cb)
	local czas = os.time()
	
	if Config.loginMethod == "PASSWORD" then
		local xPlayer = ESX.GetPlayerFromId(playerId)
		local identifier = xPlayer.getIdentifier()
		local name = GetCharacterName(playerId, identifier)
		name = splitString(name)

		MySQL.Async.fetchAll('SELECT * FROM tablet_accounts WHERE firstname = @firstname AND lastname = @lastname',
		{
			['@firstname'] = name[1],
			['@lastname'] = name[2],
		}, 
		function(result)
			if result[1] then
				cb(czas, konto)
			else
				cb(czas, nil)
			end
		end)
	else
		cb(czas, nil)
	end

	TriggerClientEvent('glibcat_mdt:nearbyPlayers', playerId, playerId)
end)

-- logowanie odciskiem palca
ESX.RegisterServerCallback('glibcat_mdt:fingerprintUser', function(playerId, cb)

	local xPlayer = ESX.GetPlayerFromId(playerId)
	local identifier = xPlayer.getIdentifier()
	local name = GetCharacterName(playerId, identifier)
	
	if Config.useBadges then
		MySQL.Async.fetchAll('SELECT odznaka FROM police_odznaki WHERE identifier = @identifier',
		{
			['@identifier'] = xPlayer.getIdentifier(),
		}, 
		function(result)
			if result[1] then
				name = name .. " " .. result[1].odznaka
			end
		end)
	end

	cb(name, identifier)
end)

ESX.RegisterServerCallback('glibcat_mdt:getDispatchLink', function(playerId, cb)
	cb(Config.dispatchLink)
end)

-------------------- Mandat --------------------
RegisterNetEvent('glibcat_mdt:giveTicket')
AddEventHandler('glibcat_mdt:giveTicket', function(target, fp, reason, fine, name, odznaka)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)

	if sourceXPlayer.job.name == Config.jobName and tonumber(fine) <= Config.maxTicket then
		local targetXPlayer = ESX.GetPlayerFromId(target)
		local identifier = targetXPlayer.getIdentifier()
		local nametosend = getIdentity(target)
		nametosend = nametosend.firstname .. " " .. nametosend.lastname

		local fpname = getIdentity(_source)
		fpname = fpname.firstname .. " " .. fpname.lastname
		local mandat = tonumber(fine)

		targetXPlayer.removeAccountMoney('bank', mandat)
		sourceXPlayer.addAccountMoney('bank', math.floor(mandat * Config.officerReward))

		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
			account.addMoney(math.floor(mandat * (1 - Config.officerReward)))
		end)

		--TriggerClientEvent('chat:addMessage', -1, {args = {_U('mandat'), _U('mandat_msg', name, mandat, reason, fp)}, color = {0, 153, 204}})--]]

		--Instead of paying directly, add an invoice.
		TriggerEvent("fakturkies:sendBillSource", _source, target, "society_police", "LSPD | " .. reason, mandat)
		--TriggerClientEvent('chat:addMessage', -1, {args = {_U('mandat'), _U('mandat_msg', nametosend, mandat, reason, fpname)}, color = {0, 153, 204}})--]]

		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding: 0.4vw; margin-top: 0.3vw; margin-right: 0.8vw; margin-right: 0.8vw; background-color: rgba(0, 153, 204, 0.7); border-radius: 4px;"><b>👨‍⚖️ SĘDZIA</b> | &nbsp;{0}</div>',
			args = { _U('mandat_msg', nametosend, mandat, reason, fpname) }
		})

		if Config.useWebhooks then
			mandatWebhook(fp, fine, name, reason, _source)
		end
	else
		-- TU ZRÓB CO CHCESZ - WEBHOOK/KICK/BAN/COKOLWIEK
	end
end)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']

		}
	else
		return nil
	end
end

-------------------- Więzienie --------------------
RegisterNetEvent('glibcat_mdt:sendToJail')
AddEventHandler('glibcat_mdt:sendToJail', function(target, fp, reason, fine, years, name, odznaka)
    local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)

	if sourceXPlayer.job.name == Config.jobName and tonumber(fine) <= Config.maxTicket and tonumber(years) <= Config.maxJailTime then
		local targetXPlayer = ESX.GetPlayerFromId(target)
		local identifier = targetXPlayer.getIdentifier()
		local mandat = tonumber(fine)
		local jailTime = years

		print(nametosend)
		local nametosend = getIdentity(target)
		nametosend = nametosend.firstname .. " " .. nametosend.lastname

		local fpname = getIdentity(_source)
		fpname = fpname.firstname .. " " .. fpname.lastname

		if Config.multiplyJailTime then
			jailTime = jailTime * Config.jailTimeMultiplier
		end

		targetXPlayer.removeAccountMoney('bank', mandat)
		sourceXPlayer.addAccountMoney('bank', math.floor(mandat * Config.officerReward))

		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
			account.addMoney(math.floor(mandat * (1 - Config.officerReward)))
		end)

		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding: 0.4vw; margin-top: 0.3vw; margin-right: 0.8vw; margin-right: 0.8vw; background-color: rgba(0, 153, 204, 0.7); border-radius: 4px;"><b>👨‍⚖️ SĘDZIA</b> | &nbsp;{0}</div>',
			args = { _U('jailed_msg', nametosend, years, reason, mandat, fpname) }
		})
		TriggerEvent(Config.jailTriggerName, _source, target, jailTime)

		if Config.useWebhooks then
			jailWebhook(fp, fine, name, reason, years, _source)
		end
	else
		-- TU ZRÓB CO CHCESZ - WEBHOOK/KICK/BAN/COKOLWIEK
    end
end)

-------------------- Ogłoszenia --------------------
RegisterServerEvent('glibcat_mdt:announcementAdd')
AddEventHandler('glibcat_mdt:announcementAdd', function(fp, ogloszenie, data)
	local _source = source

	MySQL.Async.insert('INSERT INTO tablet_ogloszenia (ogloszenie, policjant, data) VALUES (@ogloszenie, @policjant, @data)',
	{ 
		['@ogloszenie'] = ogloszenie,
		['@policjant'] = fp,
		['@data'] = data,
	},
	function(insertId)
		TriggerClientEvent('glibcat_mdt:sendNewAnnouncement', -1, insertId, ogloszenie, fp, data)
	end)
		
	if Config.useWebhooks then
		announcementWebhook(fp, ogloszenie, _source)
	end
end)

-------------------- Raporty --------------------
RegisterServerEvent('glibcat_mdt:raportAdd')
AddEventHandler('glibcat_mdt:raportAdd', function(identifier, fp, raport, data)
	local _source = source

	MySQL.Async.insert('INSERT INTO tablet_raporty (identifier, raport, policjant, data) VALUES (@identifier, @raport, @policjant, @data)',
	{ 
		['@identifier'] = identifier,
		['@raport'] = raport,
		['@policjant'] = fp,
		['@data'] = data,
	},
	function(insertId)
		TriggerClientEvent('glibcat_mdt:syncRaports', -1, insertId, raport, data, fp)
	end)
	
	if Config.useWebhooks then
		raportWebhook(fp, raport, _source)
	end
end)

-------------------- Inne --------------------
function GetCharacterName(playerId, identifier)

	local result

	if Config.EnableESXIdentity then
		local xPlayer = ESX.GetPlayerFromId(playerId)

		if xPlayer then
			result = xPlayer.getName()
		end
	else
		result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
		{
			['@identifier'] = identifier
		})

		if result[1].firstname and result[1].lastname then
			result = result[1].firstname .. ' ' .. result[1].lastname
		end
	end
	
	if result then
		return result
	else
		return GetPlayerName(playerId)
	end
end

--zapisywanie czasu
ESX.RegisterServerCallback('glibcat_mdt:getTime', function(source, cb)
	result = os.time()
	cb(result)
end)

-- pobieranie imiona i nazwiska
ESX.RegisterServerCallback('glibcat_mdt:getPlayerNames', function(source, cb, players)
	players[source] = nil

	for playerId,v in pairs(players) do
		local xPlayer = ESX.GetPlayerFromId(playerId)

		if xPlayer then
			players[playerId] = GetCharacterName(playerId, xPlayer.getIdentifier())
		else
			players[playerId] = nil
		end
	end

	cb(players)
end)


ESX.RegisterServerCallback('glibcat_mdt:getName', function(playerId, cb, id)

	local xPlayer = ESX.GetPlayerFromId(playerId)
	local identifier = xPlayer.getIdentifier()
	result = GetCharacterName(playerId, identifier)

	cb(result)
end)

-------------------- ZARZĄDZANIE --------------------
-- zmiana rangi pracownika
ESX.RegisterServerCallback('glibcat_mdt:employeeGradeChange', function(source, cb, identifier, grade, name)
	local xPlayer = ESX.GetPlayerFromIdentifier(identifier)

	if xPlayer and (xPlayer.job.name == Config.jobName or xPlayer.job.name == Config.offDutyJobName) then
		xPlayer.setJob(xPlayer.job.name, grade)
	end

	if Config.useBadges and Config.badgesType == "JOBGRADE" then
		local splitName = splitString(name)
		
		MySQL.Async.fetchAll('SELECT odznaka FROM police_odznaki WHERE identifier = @identifier',
		{
			['@identifier'] = identifier,
		}, 
		function(result)
			if result[1] then
				odznaka = result[1].odznaka
				local odznakaLen = string.len(odznaka) - 2
				odznaka = string.sub(odznaka, odznakaLen, -2)
				odznaka = _U(tonumber(grade), odznaka)
				name = tostring(splitName[1] .. " " .. splitName[2] .. " " .. odznaka)
				cb(name)
				MySQL.Async.execute('UPDATE police_odznaki SET odznaka = @odznaka WHERE identifier = @identifier',
				{
					['@identifier'] = identifier,
					['@odznaka'] = odznaka,
				})
			end
		end)
	else
		cb(name)
	end

	MySQL.Async.execute('UPDATE users SET job_grade = @job_grade WHERE identifier = @identifier',
	{
		['@job_grade']  = grade,
		['@identifier'] = identifier,
	})

end)

-------------------- ODZNAKI --------------------
-- STANDARD

RegisterServerEvent('glibcat_mdt:badgeAdd')
AddEventHandler('glibcat_mdt:badgeAdd', function(id, odznaka)
	if Config.badgesType == "JOBGRADE" then
		local xPlayer = ESX.GetPlayerFromIdentifier(id)
		if xPlayer then
			job = xPlayer.getJob()
			job = job.grade
		else
			job = MySQL.Sync.fetchAll('SELECT job_grade FROM users WHERE identifier = @identifier',
			{
				['@identifier'] = id
			})

			job = job[1].job_grade
		end
		
		odznaka = tonumber(odznaka)

		if odznaka < 10 then
			odznaka = "0" .. odznaka
		end

		odznaka = _U(tonumber(job), odznaka)

		MySQL.Sync.insert('INSERT INTO police_odznaki (identifier, odznaka) VALUES (@identifier, @odznaka)',
		{
			['@identifier'] = id,
			['@odznaka'] = odznaka,
		})
	else
		MySQL.Sync.insert('INSERT INTO police_odznaki (identifier, odznaka) VALUES (@identifier, @odznaka)',
		{
			['@identifier'] = id,
			['@odznaka'] = "[" .. odznaka .. "]",
		})
	end
end)

RegisterServerEvent('glibcat_mdt:badgeRemove')
AddEventHandler('glibcat_mdt:badgeRemove', function(id)
	MySQL.Sync.execute('DELETE FROM police_odznaki WHERE identifier = @identifier',
	{
		['@identifier'] = id,
	})
end)

RegisterServerEvent('glibcat_mdt:employeeFireFULL')
AddEventHandler('glibcat_mdt:employeeFireFULL', function(id)
	local sourceXPlayer = ESX.GetPlayerFromId(source)

	if sourceXPlayer.job.name == Config.jobName or sourceXPlayer.job.name == Config.offDutyJobName then
		local xPlayer = ESX.GetPlayerFromIdentifier(id)

		if xPlayer then
			xPlayer.setJob("unemployed", 0)
		end

		MySQL.Async.execute('DELETE FROM police_odznaki WHERE identifier = @identifier',
		{
			['@identifier'] = id,
		})

		if Config.loginMethod == "PASSWORD" then
			MySQL.Async.execute('DELETE FROM tablet_accounts WHERE identifier = @identifier',
			{
				['@identifier'] = id,
			})
		end
	end
end)

RegisterServerEvent('glibcat_mdt:badgeChange')
AddEventHandler('glibcat_mdt:badgeChange', function(id, odznaka)
	if Config.badgesType == "JOBGRADE" then
		local xPlayer = ESX.GetPlayerFromIdentifier(id)

		if xPlayer then
			job = xPlayer.getJob()
			job = job.grade
		else
			job = MySQL.Sync.fetchAll('SELECT job_grade FROM users WHERE identifier = @identifier',
			{
				['@identifier'] = id
			})

			job = job[1].job_grade
		end
		
		odznaka = tonumber(odznaka)

		if odznaka < 10 then
			odznaka = "0" .. odznaka
		end

		odznaka = _U(tonumber(job), odznaka)

		MySQL.Sync.execute('UPDATE police_odznaki SET odznaka = @odznaka WHERE identifier = @identifier',
		{
			['@identifier'] = id,
			['@odznaka'] = odznaka,
		})
	else
		MySQL.Sync.execute('UPDATE police_odznaki SET odznaka = @odznaka WHERE identifier = @identifier',
		{
			['@identifier'] = id,
			['@odznaka'] = "[" .. odznaka .. "]",
		})
	end
end)

RegisterServerEvent('glibcat_mdt:badgeJobGradeChange')
AddEventHandler('glibcat_mdt:badgeJobGradeChange', function(id)
	if Config.badgesType == "JOBGRADE" then
		local odznaka = MySQL.Sync.fetchAll('SELECT odznaka FROM police_odznaki WHERE identifier = @identifier',
		{
			['@identifier'] = id
		})

		if odznaka[1] then
			local xPlayer = ESX.GetPlayerFromIdentifier(id)
			local odznakaLen = string.len(odznaka[1].odznaka) - 2
			odznaka = string.sub(odznaka[1].odznaka, odznakaLen, -2)
			Wait(3000)

			if xPlayer then
				job = xPlayer.getJob()
				job = job.grade
			else
				job = MySQL.Sync.fetchAll('SELECT job_grade FROM users WHERE identifier = @identifier',
				{
					['@identifier'] = id
				})
	
				job = job[1].job_grade
			end

			odznaka = _U(tonumber(job), odznaka)

			MySQL.Async.execute('UPDATE police_odznaki SET odznaka = @odznaka WHERE identifier = @identifier',
			{
				['@identifier'] = id,
				['@odznaka'] = odznaka,
			})
		end
	end
end)

-- CALLBACKI
ESX.RegisterServerCallback('glibcat_mdt:badgeAddCB', function(playerId, cb, id, odznaka)
	if Config.badgesType == "JOBGRADE" then
		local xPlayer = ESX.GetPlayerFromIdentifier(id)
		local job

		if xPlayer then
			job = xPlayer.getJob()
			job = job.grade
		else
			job = MySQL.Sync.fetchAll('SELECT job_grade FROM users WHERE identifier = @identifier',
			{
				['@identifier'] = id
			})

			job = job[1].job_grade
		end
		
		odznaka = tonumber(odznaka)

		if odznaka < 10 then
			odznaka = "0" .. odznaka
		end

		odznaka = _U(tonumber(job), odznaka)

		MySQL.Async.insert('INSERT INTO police_odznaki (identifier, odznaka) VALUES (@identifier, @odznaka)',
		{
			['@identifier'] = id,
			['@odznaka'] = odznaka,
		})
		cb(odznaka)
	else
		MySQL.Async.insert('INSERT INTO police_odznaki (identifier, odznaka) VALUES (@identifier, @odznaka)',
		{
			['@identifier'] = id,
			['@odznaka'] = "[" .. odznaka .. "]",
		})
		cb("[" .. odznaka .. "]")
	end
end)

ESX.RegisterServerCallback('glibcat_mdt:badgeChangeCB', function(playerId, cb, id, odznaka)
	if Config.badgesType == "JOBGRADE" then
		local xPlayer = ESX.GetPlayerFromIdentifier(id)

		if xPlayer then
			job = xPlayer.getJob()
			job = job.grade
		else
			job = MySQL.Sync.fetchAll('SELECT job_grade FROM users WHERE identifier = @identifier',
			{
				['@identifier'] = id
			})

			job = job[1].job_grade
		end
		
		odznaka = tonumber(odznaka)

		if odznaka < 10 then
			odznaka = "0" .. odznaka
		end

		odznaka = _U(tonumber(job), odznaka)

		MySQL.Async.execute('UPDATE police_odznaki SET odznaka = @odznaka WHERE identifier = @identifier',
		{
			['@identifier'] = id,
			['@odznaka'] = odznaka,
		})
		cb(odznaka)
	else
		MySQL.Async.execute('UPDATE police_odznaki SET odznaka = @odznaka WHERE identifier = @identifier',
		{
			['@identifier'] = id,
			['@odznaka'] = "[" .. odznaka .. "]",
		})
		cb("[" .. odznaka .. "]")
	end
end)

-------------------- WEBHOOOOOOOOOOOOKI --------------------
function sendWebhook(message, color, channel)
	PerformHttpRequest(
		Config.webhooks[channel], 
		function(err, text, headers) end, 
		'POST', json.encode({
		username = Config.username, 
		embeds = {{
			["color"] = color, 
			["author"] = {["name"] = Config.fractionName,
			["icon_url"] = Config.fractionLogo}, 
			["description"] = "".. message .."",
			["footer"] = {["text"] = os.date("%Y-%m-%d %X"),},}}, avatar_url = Config.avatar}), { ['Content-Type'] = 'application/json' 
		})
end

-- LICENSES
function removedLicenseWebhook(name, typ, target, source)
	local _source = source
	
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)

		if identifiers.discord then
			discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
		else
			discordID = ""
		end
	else
		discordID = ""
	end
	
	local funkcjonariusz = "\n**Podpis: **" .. name
	sendWebhook('**' .. target .. '** traci ' .. changekLicenseName(typ) .. funkcjonariusz .. '' .. discordID, Config.removeLicense, 'licencja')
end

function addLicenseWebhook(name, typ, target, source)
	local _source = source

	if Config.discordTag then
		local identifiers = getIdentifiers(_source)

		if identifiers.discord then
			discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
		else
			discordID = ""
		end
	else
		discordID = ""
	end
	
	local funkcjonariusz = "\n**Podpis: **" .. name
	sendWebhook('**' .. target  .. '** otrzymuje ' .. changekLicenseName(typ) .. funkcjonariusz .. '' .. discordID, Config.addLicense, 'licencja')
end

-- MANDAT
function mandatWebhook(name, fine, target, reason, source)
	local _source = source
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)

		if identifiers.discord then
			discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
		else
			discordID = ""
		end
	else
		discordID = ""
	end
	
	local funkcjonariusz = "\n**Podpis: **" .. name
	local powod = "\n**Powód: **" .. reason
	sendWebhook('**' .. target  .. '** otrzymuje mandat w wysokosci $' .. fine .. powod ..funkcjonariusz .. '' .. discordID, Config.mandatColor, 'mandat')
end

-- JAIL
function jailWebhook(name, fine, target, reason, years, source)
	local _source = source
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)

		if identifiers.discord then
			discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
		else
			discordID = ""
		end
	else
		discordID = ""
	end
	
	local funkcjonariusz = "\n**Podpis: **" .. name
	local powod = "\n**Powod: **" .. reason
	local grzywna = "\n**Grzywna: **" .."$" .. fine 
	sendWebhook('**' .. target  .. '** trafia do wiezienia na ' .. years .. " lat" .. powod .. grzywna .. funkcjonariusz .. '' .. discordID, Config.jailColor, 'mandat')
end

-- ANNOUNCEMENT
function announcementWebhook(name, text)
	local tresc = "\n**Treść: **" .. text
	sendWebhook('**' .. name  .. '** dodał ogłoszenie ' .. tresc, Config.announcementColor, 'ogloszenia')
end

-- RAPORTY
function raportWebhook(name, text, source)
	local _source = source
	
	
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
				
		if identifiers.discord then
			discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
		else
			discordID = ""
		end
	else
		discordID = ""
	end
	
	local tresc = "\n**Treść: **" .. text
	
	sendWebhook('**' .. name  .. '** dodał raport ' .. tresc .. discordID, Config.raportColor, 'raport')
end

function raportRemoveWebhook(name, text, source)
	local _source = source
	
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
				
		if identifiers.discord then
			discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
		else
			discordID = ""
		end
	else
		discordID = ""
	end
	
	local tresc = "\n**Treść: **" .. text
	
	sendWebhook('**' .. name  .. '** zmienił status raportu ' .. tresc .. discordID, Config.raportColor, 'raport')
end

-- SUSPECT
function addSuspectWebhook(name, car, target, reason, source)
	local _source = source
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
				
		if identifiers.discord then
			discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
		else
			discordID = ""
		end
	else
		discordID = ""
	end
	
	local funkcjonariusz = "\n**Podpis: **" .. name
	local powod = "\n**Powód: **" .. reason
	local auto = "\n**Pojazd: **" .. car
	sendWebhook('**' .. target  .. '** jest poszukiwany' .. powod .. auto ..funkcjonariusz .. '' .. discordID, Config.suspectAddColor, 'poszukiwani')
end

function removeSuspectWebhook(name, target, source)
	local _source = source
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
				
		if identifiers.discord then
			discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
		else
			discordID = ""
		end
	else
		discordID = ""
	end
	
	local funkcjonariusz = "\n**Podpis: **" .. name
	sendWebhook('**' .. target  .. '** nie jest już poszukiwany'..funkcjonariusz .. '' .. discordID, Config.suspectRemoveColor, 'poszukiwani')
end

-- LOGS
function removeNoteWebhook(name, target, text, source)
	local _source = source
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
				
		if identifiers.discord then
			discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
		else
			discordID = ""
		end
	else
		discordID = ""
	end
	
	local tresc= "\n**Treść: **" .. text
	sendWebhook('**' .. name  .. '** usunal notatke, w kartotece obywatela: ' .. target .. tresc .. discordID, Config.logColor, 'logs')
end

function addNoteWebhook(name, target, text, source)
	local _source = source
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
				
		if identifiers.discord then
			discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
		else
			discordID = ""
		end
	else
		discordID = ""
	end
	
	local tresc= "\n**Treść: **" .. text
	sendWebhook('**' .. name  .. '** dodaje notatke, w kartotece obywatela: ' .. target .. tresc .. discordID, Config.logColor, 'logs')
end

function removeKartotekaWebhook(name, target, reason, fine, jail, source)
	local _source = source
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
				
		if identifiers.discord then
			discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
		else
			discordID = ""
		end
	else
		discordID = ""
	end
	
	local tresc = "\n**Powód: **" .. reason
	local grzywna = "\n**Grzywna: **" .. fine
	local wiezienie = "\n**Więzienie: **" .. jail
	sendWebhook('**' .. name  .. '** usunal wpis z kartoteki obywatela: ' .. target .. tresc .. grzywna .. wiezienie .. discordID, Config.logColor, 'logs')
end

function removeAnnouncementWebhook(name, text, source)
	local _source = source
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
				
		if identifiers.discord then
			discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
		else
			discordID = ""
		end
	else
		discordID = ""
	end
	
	local tresc = "\n**Treść: **" .. text
	sendWebhook('**' .. name  .. '** usunal ogloszenie:' .. tresc .. discordID, Config.logColor, 'logs')
end

function changeAvatarWebhook(name, target, avatarUrl, source, previous)
	local _source = source
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
				
		if identifiers.discord then
			discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
		else
			discordID = ""
		end
	else
		discordID = ""
	end
	
	local avatar = "\n**Zdjecie: **" .. avatarUrl
	local before = "\n**Poprzednie zdjecie: **" .. previous

	sendWebhook('**' .. name  .. '** zmienil zdjecie obywatela: ' .. target .. avatar .. before .. discordID, Config.logColor, 'logs')
end

function restartOnDutyTime(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local identifier = xPlayer.getIdentifier()
	local name = GetCharacterName(playerId, identifier)
	if Config.discordTag then
		local identifiers = getIdentifiers(playerId)
				
		if identifiers.discord then
			discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
		else
			discordID = ""
		end
	else
		discordID = ""
	end
	
	sendWebhook('**' .. name  .. '** wyzerował czasy na służbie' .. discordID, Config.logColor, 'logs')
end

function getIdentifiers(player)
    local identifiers = {}
    for i = 0, GetNumPlayerIdentifiers(player) - 1 do
        local raw = GetPlayerIdentifier(player, i)
        local tag, value = raw:match("^([^:]+):(.+)$")
        if tag and value then
            identifiers[tag] = value
        end
    end
    return identifiers
end

function changekLicenseName(licencja)
	local name = "";
	if(licencja == "drive_bike" ) then
		name = "prawo jazdy kat. A"
		return name
	elseif (licencja == "drive" ) then
		name = "prawo jazdy kat. B"
		return name
	elseif (licencja == "drive_truck" ) then
		name = "prawo jazdy kat. C"
		return name
	elseif (licencja == "weapon" ) then
		name = "licencję na broń krótką"
		return name
	elseif (licencja == "weapon_long") then
		name = "licencję na broń długą"
		return name
	end
end

function splitString(inputString)
	local t = {}
	for str in string.gmatch(inputString, "%S+") do
	   table.insert(t, str)
	end

	return t
end

-------------------- Sprawdź pojazd --------------------
ESX.RegisterServerCallback('glibcat_mdt:checkVehicle', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate',
	{
		['@plate'] = plate,
	}, 
	function(result)
		if result[1] then

			local decoded = json.decode(result[1].vehicle)

			local name = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
			{
				['@identifier'] = result[1].owner
			})

			cb(result, name[1].firstname, name[1].lastname, decoded["model"])
		else
			cb(nil)
		end
	end)
end)

-------------------- LOGOWANIE --------------------
-- rejestracja
ESX.RegisterServerCallback('glibcat_mdt:registerUser', function(playerId, cb, username, password)
	local testUsername = MySQL.Sync.fetchAll('SELECT * FROM tablet_accounts WHERE username = @username',
	{
		['@username'] = username,
	})

	if testUsername[1] then
		cb(nil)
	else
		local xPlayer = ESX.GetPlayerFromId(playerId)
		local job = xPlayer.getJob()
		local identifier = xPlayer.getIdentifier()
		local name = GetCharacterName(playerId, identifier)
		local splitName = splitString(name)
		local odznaka = ""

		MySQL.Async.insert('INSERT INTO tablet_accounts (username, password, firstname, lastname, identifier) VALUES (@username, MD5(@password), @firstname, @lastname, @identifier)',
		{
			['@username'] = username,
			['@password'] = password,
			['@firstname'] = splitName[1],
			['@lastname'] = splitName[2],
			['@identifier'] = identifier,
		})
	
		if Config.useBadges then
			odznaka = MySQL.Sync.fetchAll('SELECT odznaka FROM police_odznaki WHERE identifier = @identifier',
			{
				['@identifier'] = identifier,
			})
		end

		if odznaka[1] then
			name = name .. " " .. odznaka[1].odznaka
		end

		cb(name, identifier, job.grade)
	end
	
end)

-- logowanie hasłem
ESX.RegisterServerCallback('glibcat_mdt:signinUser', function(playerId, cb, username, password)
	local account = MySQL.Sync.fetchAll('SELECT * FROM tablet_accounts WHERE username = @username AND password = MD5(@password)',
	{
		['@username'] = username,
		['@password'] = password,
	})

	if account[1] then
		local name = account[1].firstname .. " " .. account[1].lastname
		local user = ""
		local odznaka = ""
	
		if Config.useBadges then
			user = MySQL.Sync.fetchAll('SELECT users.job_grade AS grade, police_odznaki.odznaka FROM users LEFT JOIN police_odznaki ON users.identifier = police_odznaki.identifier WHERE users.identifier = @identifier',
			{
				['@identifier'] = account[1].identifier,
			})
		else
			user = MySQL.Sync.fetchAll('SELECT job_grade AS grade FROM users WHERE identifier = @identifier',
			{
				['@identifier'] = account[1].identifier,
			})
		end

		if user[1].odznaka then
			name = name .. " " .. user[1].odznaka
		end

		cb(name, account[1].identifier, user[1].grade)
	else
		cb(nil)
	end
end)

-------------------- ZARZADZANIE --------------------
--- FINANSE ---

-- otwieranie
ESX.RegisterServerCallback('glibcat_mdt:openFinance', function(source, cb)
	local money

	TriggerEvent('esx_addonaccount:getSharedAccount', "society_police", function(account)
		money = account.money
	end)

	local salaries = MySQL.Sync.fetchAll('SELECT label, grade ,salary FROM job_grades WHERE job_name = @job_name ORDER BY grade',
	{
		['@job_name'] = Config.jobName,
	})

	if salaries[1] then
		cb(money, salaries)
	else
		cb(money, nil)
	end
end)

-- wpłacanie pieniedzy
ESX.RegisterServerCallback('glibcat_mdt:depositMoney', function(playerId, cb, amount)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	amount = ESX.Math.Round(tonumber(amount))

	if amount > 0 and xPlayer.getMoney() >= amount then
		TriggerEvent('esx_addonaccount:getSharedAccount', "society_police", function(account)
			xPlayer.removeMoney(amount)
			account.addMoney(amount)
		end)

		cb("success")
	else
		cb("error")
	end
end)

-- wypłacanie pieniedzy
ESX.RegisterServerCallback('glibcat_mdt:withdrawMoney', function(playerId, cb, amount)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer.job.name == Config.jobName then
		amount = ESX.Math.Round(tonumber(amount))

		TriggerEvent('esx_addonaccount:getSharedAccount', "society_police", function(account)
			if amount > 0 and account.money >= amount then
				account.removeMoney(amount)
				xPlayer.addMoney(amount)

				cb("success")
			else
				cb("error")
			end
		end)
	end
end)

-- pranie pieniędzy
ESX.RegisterServerCallback('glibcat_mdt:washMoney', function(playerId, cb, amount)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local account = xPlayer.getAccount('black_money')
	amount = ESX.Math.Round(tonumber(amount))
	if amount and amount > 0 and account.money >= amount then
		xPlayer.removeAccountMoney('black_money', amount)

		MySQL.Async.execute('INSERT INTO society_moneywash (identifier, society, amount) VALUES (@identifier, @society, @amount)', {
			['@identifier'] = xPlayer.identifier,
			['@society']    = Config.jobName,
			['@amount']     = amount
		}, function(rowsChanged)
			cb("success")
		end)
	else
		cb("error")
	end
end)

-- pobieranie pieniędzy
ESX.RegisterServerCallback('glibcat_mdt:getSocietyMoney', function(source, cb)
	local money

	TriggerEvent('esx_addonaccount:getSharedAccount', "society_police", function(account)
		money = account.money
	end)

	cb(money)
end)


--- PRACOWNICY ---

--otiweranie
ESX.RegisterServerCallback('glibcat_mdt:openEmployee', function(source, cb)

	local employee = MySQL.Sync.fetchAll('SELECT CONCAT_WS(" ",users.firstname, users.lastname, police_odznaki.odznaka) AS name, job_grades.label as stopien, CONCAT(count(user_kartoteka.grzywna), " ($" ,sum(user_kartoteka.grzywna),")") AS mandaty, user_police_time.time AS time, user_police_time.clear AS clear, users.identifier AS identifier FROM users LEFT JOIN police_odznaki ON users.identifier = police_odznaki.identifier LEFT JOIN job_grades ON users.job_grade = job_grades.grade AND job_grades.job_name = @job_name LEFT JOIN user_kartoteka ON user_kartoteka.policjant LIKE CONCAT(users.firstname," ",users.lastname,"%") LEFT JOIN user_police_time ON user_police_time.identifier = users.identifier WHERE users.job = @job_name OR users.job = @offjob_name GROUP BY users.identifier ORDER BY users.job_grade',
	{
		['@job_name'] = Config.jobName,
		['@offjob_name'] = Config.offDutyJobName
	})

	local jobLabels = MySQL.Sync.fetchAll('SELECT grade, label FROM job_grades WHERE job_name = @job_name ORDER BY grade',
	{
		['@job_name'] = Config.jobName,
	})

	if employee[1] then
		cb(employee, jobLabels)
	end
end)

-- zwolnienie pracownika
RegisterServerEvent('glibcat_mdt:employeeFire')
AddEventHandler('glibcat_mdt:employeeFire', function(identifier)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == Config.jobName then
		TriggerEvent("glibcat_mdt:employeeFireFULL", identifier)

		MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier',
		{
			['@job']        = 'unemployed',
			['@job_grade']  = 0,
			['@identifier'] = identifier,
		})
	end
end)

--- KONTA ---

--otwieranie
ESX.RegisterServerCallback('glibcat_mdt:openAccounts', function(source, cb)

	local accounts = MySQL.Sync.fetchAll('SELECT tablet_accounts.username AS login, CONCAT_WS(" ", users.firstname, users.lastname) AS name, users.identifier FROM users LEFT JOIN tablet_accounts ON users.identifier = tablet_accounts.identifier WHERE job = @job OR job = @offjob ORDER BY users.job_grade',
	{
		['@job'] = Config.jobName,
		['@offjob'] = Config.offDutyJobName
	})

	if accounts[1] then
		cb(accounts)
	end
end)

--usuwanie konta
RegisterServerEvent('glibcat_mdt:removeAccount')
AddEventHandler('glibcat_mdt:removeAccount', function(identifier)
	MySQL.Async.execute('DELETE FROM tablet_accounts WHERE identifier = @identifier',
	{
		['@identifier'] = identifier,
	})
end)

--tworzenie konta
ESX.RegisterServerCallback('glibcat_mdt:createAccount', function(playerId, cb, identifier, username, password, name)
	local testUsername = MySQL.Sync.fetchAll('SELECT * FROM tablet_accounts WHERE username = @username',
	{
		['@username'] = username,
	})

	if testUsername[1] then
		cb(nil)
	else
		local splitName = splitString(name)
		MySQL.Async.execute('INSERT INTO tablet_accounts (username, password, firstname, lastname, identifier) VALUES (@username, MD5(@password), @firstname, @lastname, @identifier)',
		{
            ['@username'] = username,
            ['@password'] = password,
            ['@firstname'] = splitName[1],
            ['@lastname'] = splitName[2],
            ['@identifier'] = identifier,
		},
		function(rowsChanged)
			cb("success")
		end)
	end
end)

--zapomnialem hasla
ESX.RegisterServerCallback('glibcat_mdt:forgotPassword', function(playerId, cb, username, password)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local identifier = xPlayer.getIdentifier()
	local name = GetCharacterName(playerId, identifier)
	local splitName = splitString(name)
	
	local testUsername = MySQL.Sync.fetchAll('SELECT * FROM tablet_accounts WHERE username = @username AND firstname = @firstname AND lastname = @lastname',
	{
		['@username'] = username,
		['@firstname'] = splitName[1],
		['@lastname'] = splitName[2],
	})

	if testUsername[1] then
		MySQL.Async.execute('UPDATE tablet_accounts SET password = MD5(@password) WHERE identifier = @identifier',
		{
			['@password']  = password,
			['@identifier'] = identifier,
		},
		function(rowsChanged)
			cb("success")
		end)
	else
		cb(nil)
	end
end)
--edytowanie konta
ESX.RegisterServerCallback('glibcat_mdt:changeAccount', function(playerId, cb, identifier, username, password)
	local testUsername = MySQL.Sync.fetchAll('SELECT * FROM tablet_accounts WHERE username = @username',
	{
		['@username'] = username,
	})

	if testUsername[1] then
		cb(nil)
	else
		MySQL.Async.execute('UPDATE tablet_accounts SET username = @username, password = MD5(@password) WHERE identifier = @identifier',
		{
			['@username']  = username,
			['@password']  = password,
			['@identifier'] = identifier,
		},
		function(rowsChanged)
			cb("success")
		end)
	end
end)

--zmiana hasła zarzadzanie
ESX.RegisterServerCallback('glibcat_mdt:changeManagePassword', function(playerId, cb, password, identifier)
	MySQL.Async.execute('UPDATE tablet_accounts SET password = MD5(@password) WHERE identifier = @identifier',
	{ 
		['@password']  = password,
		['@identifier'] = identifier,
	},
	function(affectedRows)
		if affectedRows == 1 then
			cb("success")
		else
			cb(nil)
		end
	end)
			
	
end)


--zmiana hasła
ESX.RegisterServerCallback('glibcat_mdt:changePassword', function(playerId, cb, oldpassword, password, identifier)

	MySQL.Async.fetchAll('SELECT * FROM tablet_accounts WHERE identifier = @identifier AND password = MD5(@password)',
	{
		['@identifier'] = identifier,
		['@password']  = oldpassword,
	}, 
	function(result)
		if result[1] then
			MySQL.Async.execute('UPDATE tablet_accounts SET password = MD5(@password) WHERE identifier = @identifier',
			{
				['@password']  = password,
				['@identifier'] = identifier,
			})
			
			cb("success")
		else
			cb()
		end
	end)
end)

--- ODZNAKI ---
ESX.RegisterServerCallback('glibcat_mdt:openBadges', function(source, cb)

	local badges = MySQL.Sync.fetchAll('SELECT CONCAT_WS(" ",users.firstname, users.lastname) AS name, police_odznaki.odznaka AS odznaka, job_grades.label as stopien, users.identifier AS identifier FROM users LEFT JOIN police_odznaki ON users.identifier = police_odznaki.identifier LEFT JOIN job_grades ON users.job_grade = job_grades.grade AND job_grades.job_name = @job_name WHERE users.job = @job_name OR users.job = @job_offname ORDER BY users.job_grade',
	{
		['@job_name'] = Config.jobName,
		['@job_offname'] = Config.offDutyJobName
	})

	if badges[1] then
		cb(badges)
	end
end)

-------------------- Kartoteka --------------------

ESX.RegisterServerCallback('glibcat_mdt:checkFile', function(playerId, cb, firstname, lastname)
	MySQL.Async.fetchAll('SELECT * FROM users WHERE firstname = @firstname AND lastname = @lastname',
	{
		['@firstname'] = firstname,
		['@lastname'] = lastname,
	}, 
	function(basic)
		if basic[1] and #basic == 1 then
			local id = basic[1].identifier
			
			local kartoteka = MySQL.Sync.fetchAll('SELECT * FROM user_kartoteka WHERE identifier = @identifier', {
				['@identifier'] = id,
			})
			
			local poszukiwania = MySQL.Sync.fetchAll('SELECT * FROM user_poszukiwania WHERE identifier = @identifier', {
				['@identifier'] = id,
			})
			
			local licenses = MySQL.Sync.fetchAll('SELECT * FROM user_licenses WHERE owner = @identifier', {
				['@identifier'] = id,
			})
			
			local cars = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier', {
				['@identifier'] = id,
			})
			
			local notatki = MySQL.Sync.fetchAll('SELECT * FROM kartoteka_notatki WHERE identifier = @identifier', {
				['@identifier'] = id,
			})
				
			cb(basic, false, kartoteka, poszukiwania, licenses, cars, notatki)
		elseif #basic > 1 then
			cb(basic, true)
		else
			cb(nil)
		end
	end)
end)

ESX.RegisterServerCallback('glibcat_mdt:checkFileByIdentifier', function(playerId, cb, identifier)
	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
	{
		['@identifier'] = identifier,
	}, 
	function(basic)
		if basic[1] then
			local kartoteka = MySQL.Sync.fetchAll('SELECT * FROM user_kartoteka WHERE identifier = @identifier', {
				['@identifier'] = identifier
			})
			
			local poszukiwania = MySQL.Sync.fetchAll('SELECT * FROM user_poszukiwania WHERE identifier = @identifier', {
				['@identifier'] = identifier
			})
			
			local licenses = MySQL.Sync.fetchAll('SELECT * FROM user_licenses WHERE owner = @identifier', {
				['@identifier'] = identifier
			})

			local cars = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier', {
				['@identifier'] = identifier
			})
			
			local notatki = MySQL.Sync.fetchAll('SELECT * FROM kartoteka_notatki WHERE identifier = @identifier', {
				['@identifier'] = identifier
			})
				
			cb(basic, kartoteka, poszukiwania, licenses, cars, notatki)
		else
			cb(nil)
		end
	end)
end)

-- HISTORIA
RegisterServerEvent('glibcat_mdt:addFile')
AddEventHandler('glibcat_mdt:addFile', function(id, fp, reason, fine, years)
	local sourceXPlayer = ESX.GetPlayerFromId(source)

	if sourceXPlayer.job.name == Config.jobName then
		local xPlayer = ESX.GetPlayerFromId(id)
		local identifier = xPlayer.getIdentifier()

		MySQL.Async.insert('INSERT INTO user_kartoteka (identifier, policjant, powod, grzywna, ilosc_lat) VALUES (@identifier, @policjant, @powod, @grzywna, @ilosc_lat) ',
		{
			['@identifier'] = identifier,
			['@policjant'] = fp,
			['@powod'] = reason,
			['@grzywna'] = fine,
			['@ilosc_lat'] = years,
		})
	end
end)

RegisterServerEvent('glibcat_mdt:removeFile')
AddEventHandler('glibcat_mdt:removeFile', function(id, numer, name, target, reason, fine, jail)
	local playerId = source
	
	local sourceXPlayer = ESX.GetPlayerFromId(playerId)

	if sourceXPlayer.job.name == Config.jobName then
		MySQL.Async.execute('DELETE FROM user_kartoteka WHERE identifier = @identifier AND id = @numer',
		{
			['@identifier'] = id,
			['@numer'] = numer,
		})
		
		if Config.useWebhooks then
			removeKartotekaWebhook(name, target, reason, fine, jail, playerId)
		end
	end
end)

ESX.RegisterServerCallback('glibcat_mdt:wantedAdd', function(playerId, cb, identifier, policjant, powod, pojazd, data, target)
	local sourceXPlayer = ESX.GetPlayerFromId(playerId)

	if sourceXPlayer.job.name == Config.jobName then
		MySQL.Async.insert('INSERT INTO user_poszukiwania (identifier, policjant, powod, pojazd, data) VALUES (@identifier, @policjant, @powod, @pojazd, @data)',
		{ 
			['@identifier'] = identifier,
			['@policjant'] = policjant,
			['@powod'] = powod,
			['@pojazd'] = pojazd,
			['@data'] = data,
		},
		function(insertId)
			cb(insertId)
		end)
		
		if Config.useWebhooks then
			addSuspectWebhook(policjant, pojazd, target, powod, playerId)
		end
	end
end)

RegisterServerEvent('glibcat_mdt:wantedRemove')
AddEventHandler('glibcat_mdt:wantedRemove', function(id, numer, target, policjant)
	local _source = source
	
	local sourceXPlayer = ESX.GetPlayerFromId(_source)

	if sourceXPlayer.job.name == Config.jobName then
		MySQL.Async.execute('DELETE FROM user_poszukiwania WHERE identifier = @identifier AND id = @numer',
		{
			['@identifier'] = id,
			['@numer'] = numer,
		})
		
		if Config.useWebhooks then
			removeSuspectWebhook(policjant, target, _source)
		end
	end
end)

-- Notatki
ESX.RegisterServerCallback('glibcat_mdt:fileNoteAdd', function(playerId, cb, id, fp, notatka, data, target)
	local sourceXPlayer = ESX.GetPlayerFromId(playerId)

	if sourceXPlayer.job.name == Config.jobName then
		MySQL.Async.insert('INSERT INTO kartoteka_notatki (identifier, note, policjant, data) VALUES (@identifier, @note, @policjant, @data)',
		{ 
			['@identifier'] = id,
			['@note'] = notatka,
			['@policjant'] = fp,
			['@data'] = data,
		},
		function(insertId)
			cb(insertId)
		end)
		
		if Config.useWebhooks then
			addNoteWebhook(fp, target, notatka, playerId)
		end
	end
end)

RegisterServerEvent('glibcat_mdt:fileNoteRemove')
AddEventHandler('glibcat_mdt:fileNoteRemove', function(id, numer, fp, target, text)
	local _source = source
	
	local sourceXPlayer = ESX.GetPlayerFromId(_source)

	if sourceXPlayer.job.name == Config.jobName then	
		MySQL.Async.execute('DELETE FROM kartoteka_notatki WHERE identifier = @identifier AND id = @numer',
		{
			['@identifier'] = id,
			['@numer'] = numer,
		})
		
		if Config.useWebhooks then
			removeNoteWebhook(fp, target, text, _source)
		end
	end
end)

-- Licencje
RegisterServerEvent('glibcat_mdt:licenseAdd')
AddEventHandler('glibcat_mdt:licenseAdd', function(id, typ, fp, target)
	local _source = source
	
	local sourceXPlayer = ESX.GetPlayerFromId(_source)

	if sourceXPlayer.job.name == Config.jobName then
		MySQL.Async.insert('INSERT INTO user_licenses (owner, type) VALUES (@identifier, @type)',
		{
			['@identifier'] = id,
			['@type'] = typ,
		})
		
		if Config.useWebhooks then
			addLicenseWebhook(fp, typ, target, _source)
		end
	end
end)

RegisterServerEvent('glibcat_mdt:licenseRemove')
AddEventHandler('glibcat_mdt:licenseRemove', function(id, typ, fp, target)
	local _source = source
	
	local sourceXPlayer = ESX.GetPlayerFromId(_source)

	if sourceXPlayer.job.name == Config.jobName then
		MySQL.Async.execute('DELETE FROM user_licenses WHERE owner = @identifier AND type = @type',
		{
			['@identifier'] = id,
			['@type'] = typ,
		})
		
		if Config.useWebhooks then
			removedLicenseWebhook(fp, typ, target, _source)
		end
	end
end)

-- INNE

RegisterServerEvent('tablet:insertNewAvatar')
AddEventHandler('tablet:insertNewAvatar', function(id, url, fp, target)
    local _source = source

    MySQL.Sync.fetchAll('UPDATE users SET kartoteka_avatar = @url WHERE identifier = @identifier',
    {
        ['@identifier'] = id,
        ['@url'] = url,
    })
    if Config.useWebhooks then
        changeAvatarWebhook(name, target, url, _source)
    end
end)

--zerowanie czasu
RegisterServerEvent('glibcat_mdt:resetOnDutyTime')
AddEventHandler('glibcat_mdt:resetOnDutyTime', function()
	local _source = source
	
	local sourceXPlayer = ESX.GetPlayerFromId(_source)

	if sourceXPlayer.job.name == Config.jobName then
		MySQL.Async.execute('UPDATE user_police_time SET time = @time, clear = CURRENT_TIMESTAMP',
		{
			['@time'] = 0,
		})

		if Config.useWebhooks then
			restartOnDutyTime(_source)
		end
	end
end)

-------------------- Raporty --------------------
ESX.RegisterServerCallback('glibcat_mdt:getRaports', function(source, cb, identifier, minJobGrade, playerJobGrade)
	if playerJobGrade < minJobGrade then
		MySQL.Async.fetchAll('SELECT * FROM tablet_raporty WHERE identifier = @identifier',
		{
			['@identifier'] = identifier,
		}, 
		function(result)
			cb(result)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM tablet_raporty',{}, 
		function(result)
			cb(result)
		end)
	end
end)

RegisterServerEvent('glibcat_mdt:raportRemove')
AddEventHandler('glibcat_mdt:raportRemove', function(numer,name,text)
	local _source = source
	
	local sourceXPlayer = ESX.GetPlayerFromId(_source)

	if sourceXPlayer.job.name == Config.jobName then
		MySQL.Async.execute('UPDATE tablet_raporty SET status = @status WHERE id = @numer',
		{
			['@numer'] = numer,
			['@status'] = 1,
		})

		if Config.useWebhooks then
			raportRemoveWebhook(name, text, _source)
		end
	end
end)

ESX.RegisterServerCallback('glibcat_mdt:unseenRaport', function(playerId, cb)		
	MySQL.Async.fetchAll('SELECT status FROM tablet_raporty WHERE status = @status', {
		['@status'] = 0,
	}, function (result)
		if result[1] then
			cb(result)
		end
	end)
end)

-------------------- Ogłoszenia --------------------
ESX.RegisterServerCallback('glibcat_mdt:getAnnouncements', function(source, cb)

	MySQL.Async.fetchAll('SELECT * FROM tablet_ogloszenia',{},
	function(result)
		cb(result)
	end)

end)

RegisterServerEvent('glibcat_mdt:announcementRemove')
AddEventHandler('glibcat_mdt:announcementRemove', function(numer,name,text)
	local _source = source
	
	local sourceXPlayer = ESX.GetPlayerFromId(_source)

	if sourceXPlayer.job.name == Config.jobName then
		MySQL.Async.execute('DELETE FROM tablet_ogloszenia WHERE id = @numer',
		{
			['@numer'] = numer,
		})
		
		if Config.useWebhooks then
			removeAnnouncementWebhook(name, text, _source)
		end
	end
end)

RegisterServerEvent('glibcat_mdt:announcementNotification')
AddEventHandler('glibcat_mdt:announcementNotification', function()
	local _source = source
	
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = xPlayer.getIdentifier()

	MySQL.Async.fetchAll('SELECT seen FROM tablet_ogloszenia_seen WHERE identifier = @identifier',
	{
		['@identifier'] = identifier,
	}, 
	function(result)
		if result[1] then
			MySQL.Async.execute('UPDATE tablet_ogloszenia_seen SET seen = @seen WHERE identifier = @identifier',
			{
				['@identifier'] = identifier,
				['@seen'] = 0,
			})
		else
			MySQL.Async.insert('INSERT INTO tablet_ogloszenia_seen (identifier, seen) VALUES (@identifier, @seen)',
			{
				['@identifier'] = identifier,
				['@seen'] = 0,
			})
		end
	end)
end)

RegisterServerEvent('glibcat_mdt:announcementSeen')
AddEventHandler('glibcat_mdt:announcementSeen', function(identifier)	
	MySQL.Async.execute('UPDATE tablet_ogloszenia_seen SET seen = @seen WHERE identifier = @identifier',
	{
		['@identifier'] = identifier,
		['@seen'] = 1,
	})
end)

ESX.RegisterServerCallback('glibcat_mdt:checkAnnouncementNotification', function(playerId, cb)	
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local identifier = xPlayer.getIdentifier()
	
	MySQL.Async.fetchAll('SELECT seen FROM tablet_ogloszenia_seen WHERE identifier = @identifier', {
		['@identifier'] = identifier,
	}, function (result)
		if result[1] then
			cb(result)
		end
	end)
end)

-------------------- Notatnik --------------------
ESX.RegisterServerCallback('glibcat_mdt:getUserNotepad', function(source, cb, identifier)

	MySQL.Async.fetchAll('SELECT * FROM tablet_notatki WHERE identifier = @identifier',
	{
		['@identifier'] = identifier,
	}, 
	function(result)
		if not result[1] then
			MySQL.Async.insert('INSERT INTO tablet_notatki (identifier) VALUES (@identifier) ',
			{
				['@identifier'] = identifier,
			})

			cb(nil)	
		else
			cb(result)
		end
	end)

end)

RegisterServerEvent('glibcat_mdt:saveUserNotepad')
AddEventHandler('glibcat_mdt:saveUserNotepad', function(id, notatka)

	MySQL.Async.execute('UPDATE tablet_notatki SET notatka = @notatka WHERE identifier = @identifier',
	{
		['@identifier'] = id,
		['@notatka'] = notatka,
	})
end)

-- FUNKCJE

function splitString(inputString)
	local t = {}
	for str in string.gmatch(inputString, "%S+") do
	   table.insert(t, str)
	end

	return t
end

