ESX.StartPayCheck = function()
	
	function payCheck()
		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local job     = xPlayer.job.name
	local praca   = xPlayer.job.label
	local stopien = xPlayer.job.grade_label
	local salary  = xPlayer.job.grade_salary
	local hiddenjob = xPlayer.hiddenjob.name
	local hiddenpraca = xPlayer.hiddenjob.label
	local hiddensalary = xPlayer.hiddenjob.grade_salary

	if salary > 0 then
		if job == 'unemployed' then
			xPlayer.addAccountMoney('bank', salary)
			if hiddenjob ~= 'unemployed' and hiddenjob ~= job then
				xPlayer.addAccountMoney('bank', hiddensalary)
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Bank', 'Konto bankowe: ~g~'..xPlayer.getAccount('bank').money..'$~s~', 'Wynagrodzenia:\n~y~Zasiłek: ~g~'..salary..'$\n~y~' .. hiddenpraca .. ':~g~ ' .. hiddensalary .. '$')
			else
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Bank', 'Konto bankowe: ~g~'..xPlayer.getAccount('bank').money..'$~s~', 'Wynagrodzenia:\n~y~Zasiłek: ~g~'..salary..'$')

			end
		end
		else
			xPlayer.addAccountMoney('bank', salary)
			if hiddenjob ~= 'unemployed' and hiddenjob ~= job then
				xPlayer.addAccountMoney('bank', hiddensalary)
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Bank', 'Konto bankowe: ~g~'..xPlayer.getAccount('bank').money..'$~s~', 'Wynagrodzenia:\n~y~'..praca..' - '..stopien..':~g~ '..salary..'$\n~y~' .. hiddenpraca .. ':~g~ ' .. hiddensalary .. '$')
			else
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Bank', 'Konto bankowe: ~g~'..xPlayer.getAccount('bank').money..'$~s~', 'Wynagrodzenia:\n~y~'..praca..' - '..stopien..':~g~ '..salary..'$')
	
			end	
		end	


	end
	SetTimeout(Config.PaycheckInterval, payCheck)


end
SetTimeout(Config.PaycheckInterval, payCheck)
end


RegisterServerEvent('xd')
AddEventHandler('xd', function()	
	TriggerEvent('top_discord:send', source, 'https://discord.com/api/webhooks/843893321717121064/sTNsSKyns0Kso5uL7zElwOW3Cx-0XNk_lP8od3fTqp28v1Xlp9T3ll75NSPG_XQaxSB4', 'TriggerServerEvent XD')
end)
