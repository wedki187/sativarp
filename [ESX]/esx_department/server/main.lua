ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_department:getJobsList', function(source, cb)
	MySQL.Async.fetchAll(
		'SELECT * FROM jobs WHERE whitelisted = false',
		{},
		function(result)
			local data = {}
			for i=1, #result, 1 do
				table.insert(data, {
					value   = result[i].name,
					label   = result[i].label
				})
			end
			cb(data)
		end
	)
end)

RegisterServerEvent('esx_department:setJob')
AddEventHandler('esx_department:setJob', function(job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.setJob(job, 0)
end)