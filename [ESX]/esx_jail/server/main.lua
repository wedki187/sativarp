ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- jail command
TriggerEvent('es:addGroupCommand', 'jail', 'best', function(source, args, user)
	if args[1] and GetPlayerName(args[1]) ~= nil and args[2] and args[3] and args[4] then
		TriggerEvent('esx_jailerinosss:sendToPierdleElo320Cotam', source, tonumber(args[1]), tonumber(args[2] * 60), tostring(args[3]), tonumber(args[4]))
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^5DREAM-CITY', 'Prawidlowe użycie: /jail [ID] [CZAS] [POWOD] [GRZYWNA]' } } )
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^5DREAM-CITY', 'Niewystarczające uprawnienia.' } })
end, {help = "Umieść gracza w więzieniu", params = {{name = "id", help = "ID gracza"}, {name = "time", help = "czas więzienia w minutach"}, {name = "powod", help = "powód"}, {name = "grzywna", help = "grzywna"}}})

-- unjail
TriggerEvent('es:addGroupCommand', 'unjail', 'best', 'moderator', function(source, args, user)
	if args[1] then
		if GetPlayerName(args[1]) ~= nil then
			TriggerEvent('esx_jailerinos:unjailQuest', tonumber(args[1]))
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^5DREAM-CITY', 'Nieprawidłowy identyfikator gracza!' } } )
		end
	else
		TriggerEvent('esx_jailerinos:unjailQuest', source)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^5DREAM-CITY', 'Niewystarczające uprawnienia.' } })
end, {help = "Uwolnij ludzi z więzienia", params = {{name = "id", help = "ID gracza"}}})

-- send to jail and register in database
RegisterServerEvent('esx_jailerinosss:sendToPierdleElo320Cotam')
AddEventHandler('esx_jailerinosss:sendToPierdleElo320Cotam', function(source, target, jailTime)
	local xPlayerSource = ESX.GetPlayerFromId(source)
	local xPlayer = ESX.GetPlayerFromId(target)
	local identifier = GetPlayerIdentifiers(target)[1]
	if xPlayerSource.job.name == 'police' then
		MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier = @identifier', {
			['@identifier'] = identifier
		}, function(result)
			if result[1] then
				MySQL.Async.execute('UPDATE jail SET jail_time = @jail_time WHERE identifier = @identifier', {
					['@identifier'] = identifier,
					['@jail_time'] = jailTime
				})
			else
				MySQL.Async.execute('INSERT INTO jail (identifier, jail_time) VALUES (@identifier, @jail_time)', {
					['@identifier'] = identifier,
					['@jail_time'] = jailTime
				})
			end
		end)

		local name = GetCharacterName(target)
		TriggerClientEvent('esx_policejob:unrestrain', target)
		TriggerClientEvent('esx_jailerinos:jailerinos', target, jailTime)
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^5DREAM-CITY', 'Musisz być policjantem żeby to zrobić!' } } )
	end
end)

-- should the player be in jail?
RegisterServerEvent('esx_jailerinos:checkJail')
AddEventHandler('esx_jailerinos:checkJail', function()
	local _source = source -- cannot parse source to client trigger for some weird reason
	local identifier = GetPlayerIdentifiers(_source)[1] -- get steam identifier

	MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] ~= nil then
			TriggerClientEvent('esx_jailerinos:jailerinos', _source, tonumber(result[1].jail_time))
		end
	end)
end)

-- unjail via command
RegisterServerEvent('esx_jailerinos:unjailQuest')
AddEventHandler('esx_jailerinos:unjailQuest', function(source)
	if source ~= nil then
		unjail(source)
	end
end)

-- unjail after time served
RegisterServerEvent('esx_jailerinos:unjailTime')
AddEventHandler('esx_jailerinos:unjailTime', function()
	unjail(source)
	local name = GetCharacterName(source)
	TriggerClientEvent('chat:addMessage', -1, {
		template = '<div style="padding: 0.4vw; margin-top: 0.3vw; margin-right: 0.8vw; margin-right: 0.8vw; background-color: rgba(255, 50, 50, 0.7); border-radius: 4px;"><b>👨‍⚖️ SĘDZIA</b> | &nbsp;{0}</div>',
		args = {_U('unjailed', name) }
	})
end)

-- keep jailtime updated
RegisterServerEvent('esx_jailerinos:updateRemaining')
AddEventHandler('esx_jailerinos:updateRemaining', function(jailTime)
	local identifier = GetPlayerIdentifiers(source)[1]
	MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			MySQL.Async.execute('UPDATE jail SET jail_time = @jailTime WHERE identifier = @identifier', {
				['@identifier'] = identifier,
				['@jailTime'] = jailTime
			})
		end
	end)
end)

function unjail(target)
	local identifier = GetPlayerIdentifiers(target)[1]
	MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			MySQL.Async.execute('DELETE from jail WHERE identifier = @identifier', {
				['@identifier'] = identifier
			})
		end
	end)

	TriggerClientEvent('esx_jailerinos:unjail', target)
end

function GetCharacterName(source)
	-- fetch identity in sync
	local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
	{
		['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] ~= nil and result[1].firstname ~= nil and result[1].lastname ~= nil then
		return result[1].firstname .. ' ' .. result[1].lastname
	else
		return GetPlayerName(source)
	end
end

function round(x)
	return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

