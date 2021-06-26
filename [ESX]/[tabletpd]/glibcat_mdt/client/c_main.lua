local PoliceGUI, isOpened, isClosed, closedTime, variablesLoaded = false, false, true, nil, false
local tabletEntity, tabletModel, tabletDict, tabletAnim = nil, "glibcat_mdt_prop", "amb@world_human_seat_wall_tablet@female@base", "base"
local PlayerData = {}

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(0)
	end

	PlayerData = ESX.GetPlayerData()

	ESX.TriggerServerCallback('glibcat_mdt:getDispatchLink', function(link)
		Config.dispatchLink = link

		SetTimeout(5000, function()
			SendNUIMessage({
				type = 'variables',
				managementJobGrade = Config.managementJobGrade,
				licensesAddJobGrade = Config.licensesAddJobGrade,
				licensesRemoveJobGrade = Config.licensesRemoveJobGrade,
				fileJobGrade = Config.fileJobGrade,
				imageJobGrade = Config.imageJobGrade,
				announcementsJobGrade = Config.announcementsJobGrade,
				raportJobGrade = Config.raportJobGrade,
											
				maxTicket = Config.maxTicket,
				maxTariff = Config.maxTariff,
				maxJailTime = Config.maxJailTime,
				maxSalary = Config.maxSalary,
				
				serverName = Config.serverName,
				imgurApiKey = Config.imgurApiKey,
				loginMethod = Config.loginMethod,
				passwordMethod = Config.passwordMethod,
				bossPasswordBypass = Config.bossPasswordBypass,
				useDispatch = Config.useDispatch,
				useRaports = Config.useRaports,
				useOnDutyTime = Config.useOnDutyTime,
				dispatchLink = Config.dispatchLink,
				dispatchProblem = Config.dispatchProblem,
	
				useBadges = Config.useBadges,
				badgesType = Config.badgesType,
			})

			variablesLoaded = true
		end)
	end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	if Config.useOnDutyTime and (PlayerData.job.name == Config.jobName or PlayerData.job.name == Config.offDutyJobName) then
		TriggerServerEvent("glibcat_mdt:startTimer", xPlayer)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterCommand('mdt', function()
	if not variablesLoaded then return end
	if PlayerData.job.name == Config.jobName and not PoliceGUI then
		if isClosed and isOpened then
			ESX.TriggerServerCallback('glibcat_mdt:startingCallback', function(time, hasAccount)	
				if closedTime + Config.restartTime < time then
					SendNUIMessage({
						type = 'restart',
						account = hasAccount,
						bossCheck = PlayerData.job.grade,
					})
				else
					SendNUIMessage({type = 'open'})
				end	
			end)
		end

		SetNuiFocus(true, true)
		PoliceGUI = true
		startTabletAnimation()
		
		if not isOpened then
			isOpened = true
			
			checkAnnouncements()	
			
			if Config.useRaports then
				checkRaports()
			end	

			ESX.TriggerServerCallback('glibcat_mdt:startingCallback', function(time, hasAccount)
				SendNUIMessage({
					type = 'firstopen',
					account = hasAccount,
					bossCheck = PlayerData.job.grade,
				})
			end)
		end
		
		isClosed = false			
	else
		ESX.ShowNotification("~r~Nie jesteś na służbie!")
	end
end, false)

RegisterKeyMapping('mdt', 'Tablet policyjny', 'keyboard', Config.openingKey)

--logowanie odciskiem palca
RegisterNUICallback('fingerprintUser', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:fingerprintUser', function(name, identifier)
		SendNUIMessage({
			type = "user",
			name = name,
			identifier = identifier,
			jobGrade = PlayerData.job.grade,
		})
	end)
end)

RegisterNUICallback('NUIFocusOff', function()
	PoliceGUI = false
	isClosed = true

	ESX.TriggerServerCallback('glibcat_mdt:getTime', function(result)
		closedTime = result			
	end, source)
	
	stopTabletAnimation()
	SetNuiFocus(false,false)
	SendNUIMessage({type = 'close'})
end)

RegisterNUICallback('NUIFullFocusOff', function()
	isOpened = false
	isClosed = true
	PoliceGUI = false
	stopTabletAnimation()
	SetNuiFocus(false,false)
	SendNUIMessage({type = 'fullclose'})
end)

--- TICKET ---
RegisterNUICallback('giveTicket', function(data, cb)
	TriggerServerEvent('glibcat_mdt:giveTicket', data.targetID, data.fp, data.mandatreason, data.mandatgrzywna, data.name)
	TriggerServerEvent('glibcat_mdt:addFile', data.targetID, data.fp, data.mandatreason, data.mandatgrzywna, "Brak")
	ESX.ShowNotification('~w~Wpłacono ~g~' .. math.floor(data.mandatgrzywna * Config.officerReward) .. '$ ~w~z mandatu na Twoje konto w banku')
	cb("ok")
end)

--- WIĘZIENIE ---
RegisterNUICallback('sendToJail', function(data, cb)
	TriggerServerEvent('glibcat_mdt:sendToJail', data.targetID, data.fp, data.jailreason, data.jailgrzywna, data.jailtime, data.name)
	TriggerServerEvent('glibcat_mdt:addFile', data.targetID, data.fp, data.jailreason, data.jailgrzywna, data.jailtime)
	ESX.ShowNotification('~w~Wpłacono ~g~' .. math.floor(data.jailgrzywna * Config.officerReward) .. '$ ~w~z mandatu na Twoje konto w banku')
	cb("ok")
end)

--- KARTOTEKA ---

-- HISTORIA
RegisterNUICallback('removeKartoteka', function(data, cb)
	TriggerServerEvent('glibcat_mdt:removeFile', data.id, data.numer, data.fp, data.target, data.reason, data.fine, data.jail)
	cb("ok")
end)

-- POSZUKIWANIA
RegisterNUICallback('removePoszukiwania', function(data, cb)
	TriggerServerEvent('glibcat_mdt:wantedRemove', data.id, data.numer, data.target, data.fp)
	cb("ok")
end)

-- NOTATKI
RegisterNUICallback('removeKartotekaNotatka', function(data, cb)
	TriggerServerEvent('glibcat_mdt:fileNoteRemove', data.id, data.numer, data.fp, data.target, data.text)
	cb("ok")
end)

-- Licencja
RegisterNUICallback('licencjaDodaj', function(data, cb)
	TriggerServerEvent('glibcat_mdt:licenseAdd', data.identifier, data.licencja, data.fp, data.target)
	cb("ok")
end)

RegisterNUICallback('licencjaUsun', function(data, cb)
	TriggerServerEvent('glibcat_mdt:licenseRemove', data.identifier, data.licencja, data.fp, data.target)
	cb("ok")
end)

-- Avatar
RegisterNUICallback('insertNewAvatar', function(data, cb)
	TriggerServerEvent('glibcat_mdt:insertNewAvatar', data.identifier, data.avatarUrl, data.fp, data.target, data.poprzednie)
	cb("ok")
end)

--- NOTATNIK ---
RegisterNUICallback('saveNotepad', function(data, cb)
	TriggerServerEvent('glibcat_mdt:saveUserNotepad', data.identifier, data.notatka)
	cb("ok")
end)

--- OGLOSZENIA ---
RegisterNUICallback('ogloszenieDodaj', function(data, cb)
	TriggerServerEvent('glibcat_mdt:announcementAdd', data.policjant, data.announcement, data.data)
	cb("ok")
end)

RegisterNUICallback('removeOgloszenie', function(data, cb)
	TriggerServerEvent('glibcat_mdt:announcementRemove', data.numer, data.fp, data.text)
	cb("ok")
end)

RegisterNUICallback('ogloszenieWyswietlone', function(data, cb)
	TriggerServerEvent('glibcat_mdt:announcementSeen', data.identifier)
	cb("ok")
end)

RegisterNetEvent('glibcat_mdt:sendNewAnnouncement')
AddEventHandler('glibcat_mdt:sendNewAnnouncement', function(id, ogloszenie, fp, data)
	if PlayerData.job ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.name == 'offpolice') then
		if isOpened and not isClosed then
			SendNUIMessage({
				type = 'insertOgloszenia',
				id = id,
				ogloszenie = ogloszenie,
				fp = fp,
				data = data,
			})
		
			SendNUIMessage({
				type = 'newOpenedOgloszenie',
			})
		else
			SendNUIMessage({
				type = 'insertOgloszenia',
				id = id,
				ogloszenie = ogloszenie,
				fp = fp,
				data = data,
			})
			
			SendNUIMessage({
				type = 'newTwojstaryOgloszenie',
			})
			
			TriggerServerEvent('glibcat_mdt:announcementNotification')
		end
	end
end)

function checkAnnouncements()
	ESX.TriggerServerCallback('glibcat_mdt:checkAnnouncementNotification', function(result)						
		if not result[1].seen then
			SendNUIMessage({
				type = 'newOgloszenie',
			})							
		end								
	end, source)
end

--- RAPORTY ---
RegisterNetEvent('glibcat_mdt:syncRaports')
AddEventHandler('glibcat_mdt:syncRaports', function(id, raport, data, fp)
	if PlayerData.job.grade >= Config.raportJobGrade then
		SendNUIMessage({
			type = 'insertSyncRaport',
			id = id,
			raport = raport,
			fp = fp,
			data = data,
			status = 0,
		})
	end	
end)

RegisterNUICallback('raportDodaj', function(data, cb)
	TriggerServerEvent('glibcat_mdt:raportAdd', data.identifier, data.policjant, data.raport, data.data)
	cb("ok")
end)

RegisterNUICallback('raportUsun', function(data, cb)
	TriggerServerEvent('glibcat_mdt:raportRemove', data.numer, data.fp, data.text)
	cb("ok")
end)

function checkRaports()
	if PlayerData.job.grade >= Config.raportJobGrade then
		ESX.TriggerServerCallback('glibcat_mdt:unseenRaport', function(result)						
			if not result[1].status then
				SendNUIMessage({
					type = 'unseenRaport',
				})						
			end							
		end)
	end
end

--- Pracownicy ---
RegisterNUICallback('employeeFire', function(data, cb)
	TriggerServerEvent('glibcat_mdt:employeeFire', data.identifier)
	cb("ok")
end)

--- KONTA ---
RegisterNUICallback('removeAccount', function(data, cb)
	TriggerServerEvent('glibcat_mdt:removeAccount', data.identifier)
	cb("ok")
end)

--- Odznaki ---
RegisterNUICallback('removeBadge', function(data, cb)
	TriggerServerEvent("glibcat_mdt:badgeRemove", data.identifier)
	cb("success")
end)

--- DOPISYWANIE POBLISKICH GRACZY ---
RegisterNetEvent('glibcat_mdt:nearbyPlayers')
AddEventHandler('glibcat_mdt:nearbyPlayers', function(id)
	local myId = id
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)

	local playersNearby = ESX.Game.GetPlayersInArea(playerCoords, Config.nearbyPlayersDistance)

	if #playersNearby > 0 then
		local players = {}

		for k,playerNearby in ipairs(playersNearby) do
			players[GetPlayerServerId(playerNearby)] = true
		end
		
		ESX.TriggerServerCallback('glibcat_mdt:getPlayerNames', function(returnedPlayers)
			for playerId,playerName in pairs(returnedPlayers) do
				SendNUIMessage({
					type = 'players',
					name = playerName,
					id = playerId,
				})
			end
		end, players)
	end
end)

function startTabletAnimation()
	Citizen.CreateThread(function()
		RequestAnimDict(tabletDict)
		while not HasAnimDictLoaded(tabletDict) do
			Citizen.Wait(1)
			RequestAnimDict(tabletDict)
		end
	
		TaskPlayAnim(PlayerPedId(), tabletDict, tabletAnim, 4.0, -4.0, -1, 50, 0, false, false, false)
		Citizen.Wait(200)
		attachObject()
	end)
end

function attachObject()
	if tabletEntity == nil then
		Citizen.CreateThread(function()
			RequestModel(tabletModel)
			while not HasModelLoaded(tabletModel) do
				Citizen.Wait(1)
				RequestModel(tabletModel)
			end
	
			tabletEntity = CreateObject(GetHashKey(tabletModel), 1.0, 1.0, 1.0, 1, 1, 0)
			AttachEntityToEntity(tabletEntity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.12, 0.10, -0.13, 25.0, 170.0, 160.0, true, true, false, true, 1, true)
		end)
	end
end

function stopTabletAnimation()
	if tabletEntity ~= nil then
		StopAnimTask(PlayerPedId(), tabletDict, tabletAnim ,4.0, -4.0, -1, 50, 0, false, false, false)
		DeleteEntity(tabletEntity)
		tabletEntity = nil
	end
end

--- LOGIN PAGE ---

--rejestracja
RegisterNUICallback('registerUser', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:registerUser', function(name, identifier, jobgrade)
		if name ~= nil then
			SendNUIMessage({
				type = "newUser",
				name = name,
				identifier = identifier,
				jobGrade = jobgrade,
			})
		else
			SendNUIMessage({type = "usernameUsed"})
		end
		cb("ok")
	end, data.username, data.password)
end)

--logowanie hasło
RegisterNUICallback('signinUser', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:signinUser', function(name, identifier, jobgrade)
		if name ~= nil then
			SendNUIMessage({
				type = "user",
				name = name,
				identifier = identifier,
				jobGrade = jobgrade,
			})
		else
			SendNUIMessage({type = "wrongData"})
		end
		cb("ok")
	end, data.username, data.password)
end)

--- Sprawdz pojazd ---
RegisterNUICallback('sprawdzVehicle', function(data, cb)
	if(data.plate == "") then
		SendNUIMessage({
			type = 'zleDane',
		})
		cb("ok")
	else
		ESX.TriggerServerCallback('glibcat_mdt:checkVehicle', function(car, firstName, lastName, model)
			if car ~= nil then
				SendNUIMessage({
					type = 'showVehicle',
					owner = firstName .. " " .. lastName,
					model = GetLabelText(GetDisplayNameFromVehicleModel(model)),
				})
			else
				SendNUIMessage({type = 'brakPojazdu'})
			end
			cb("ok")
		end, data.plate)
	end
end)

--- Finanse ---

--otwieranie
RegisterNUICallback('openFinance', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:openFinance', function(money, salaries)
		SendNUIMessage({
			type = 'insertSocietyMoney',
			money = money,
		})
		for i=1, #salaries do
			SendNUIMessage({
				type = 'insertSalaries',
				label = salaries[i].label,
				grade = salaries[i].grade,
				salary = salaries[i].salary,
			})
		end
		cb("ok")
	end)
end)

--wplacanie pieniedzy
RegisterNUICallback('depositMoney', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:depositMoney', function(status)
		if (status == "success") then
			SendNUIMessage({
				type = 'successDepositMoney',
				amount = data.amount,
			})
		else
			SendNUIMessage({
				type = 'wrongMoney',
			})
		end
		cb("ok")
	end, data.amount)
end)

--wyplacanie pieniedzy
RegisterNUICallback('withdrawMoney', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:withdrawMoney', function(status)
		if (status == "success") then
			SendNUIMessage({
				type = 'successWithdrawMoney',
				amount = data.amount,
			})
		else
			SendNUIMessage({
				type = 'wrongMoney',
			})
		end
		cb("ok")
	end, data.amount)
end)

--pranie pieniedzy
RegisterNUICallback('washMoney', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:washMoney', function(status)
		if (status == "success") then
			SendNUIMessage({
				type = 'successWashMoney',
				amount = data.amount,
			})
		else
			SendNUIMessage({
				type = 'wrongMoney',
			})
		end
		cb("ok")
	end, data.amount)
end)

-- zmiana pensji
RegisterNUICallback('changeSalary', function(data, cb)
	ESX.TriggerServerCallback('esx_society:setJobSalary', function()
		cb("success")
	end, "police", data.grade, data.salary)
end)

-- pobieranie pieniedzy
RegisterNUICallback('getSocietyMoney', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:getSocietyMoney', function(money)
		SendNUIMessage({
			type = 'insertSocietyMoney',
			money = money,
		})
		cb("ok")
	end)
end)

--- Pracownicy ---

-- otwieranie
RegisterNUICallback('openEmployee', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:openEmployee', function(employee, grades)
		for i=1, #employee do
			SendNUIMessage({
				type = 'insertEmployees',
				name = employee[i].name,
				stopien = employee[i].stopien,
				mandaty = employee[i].mandaty,
				time = employee[i].time,
				clear = employee[i].clear,
				identifier = employee[i].identifier,
			})
		end

		for i=1, #grades do
			SendNUIMessage({
				type = 'insertJobGrades',
				label = grades[i].label,
				grade = grades[i].grade,
			})
		end
		cb("ok")
	end)
end)

-- zmiana rangi
RegisterNUICallback('employeeGradeChange', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:employeeGradeChange', function(name)
		cb(name)
	end, data.identifier, data.grade, data.name)
end)

-- restart czasu
RegisterNUICallback('resetOnDutyTime', function(data, cb)
	TriggerServerEvent('glibcat_mdt:resetOnDutyTime')
	cb("ok")
end)

-- NOTATKI
RegisterNUICallback('kartotekaNotatkaDodaj', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:fileNoteAdd', function(id)
		cb(id)
	end, data.identifier, data.policjant, data.notatka, data.data, data.target)	
end)

-- POSZUKIWANIA
RegisterNUICallback('poszukiwaniaDodaj', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:wantedAdd', function(id)
		cb(id)
	end, data.identifier, data.policjant, data.powod, data.pojazd, data.data, data.target)	
end)

--- Odznaki ---

--otwieranie
RegisterNUICallback('openBadges', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:openBadges', function(badges)
		for i=1, #badges do
			SendNUIMessage({
				type = 'insertBadges',
				name = badges[i].name,
				odznaka = badges[i].odznaka,
				stopien = badges[i].stopien,
				identifier = badges[i].identifier,	
			})
		end
		cb("ok")
	end)
end)

--dodawnie
RegisterNUICallback('addBadge', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:badgeAddCB', function(badge)
		cb(badge)
	end, data.identifier, data.badge)	
end)

--zmiana
RegisterNUICallback('changeBadge', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:badgeChangeCB', function(badge)
		cb(badge)
	end, data.identifier, data.badge)	
end)

--- KONTA ---
RegisterNUICallback('openAccounts', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:openAccounts', function(accounts)
		for i=1, #accounts do
			SendNUIMessage({
				type = 'insertAccounts',
				name = accounts[i].name,
				login = accounts[i].login,
				identifier = accounts[i].identifier,	
			})
		end
		cb("ok")
	end)
end)

--tworzenie konta
RegisterNUICallback('createAccount', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:createAccount', function(status)
		if status == nil then
			cb("error")
		elseif status == "success" then
			cb("success")
		end
	end, data.identifier, data.username, data.password, data.name)
end)

--pobieranie imienia do przypomnienia konta
RegisterNUICallback('getName', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:getName', function(name)
		cb(name)
	end)
end)

--zapomnialem hasla
RegisterNUICallback('forgotPassword', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:forgotPassword', function(status)
		if status == nil then
			cb("error")
		elseif status == "success" then
			cb("success")
		end
	end, data.username, data.password)
end)

--zmiana konta
RegisterNUICallback('changeAccount', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:changeAccount', function(status)
		if status == nil then
			cb("error")
		elseif status == "success" then
			cb("success")
		end
	end, data.identifier, data.username, data.password)
end)

--zmiana hasla zarzadzanie
RegisterNUICallback('changeManagePassword', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:changeManagePassword', function(status)
		if status == nil then
			cb("error")
		elseif status == "success" then
			cb("success")
		end
	end, data.password, data.identifier)
end)

--zmiana hasla
RegisterNUICallback('changePassword', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:changePassword', function(status)
		if status == nil then
			cb("error")
		elseif status == "success" then
			cb("success")
		end
	end, data.oldpassword, data.password, data.identifier)
end)

--- OGLOSZENIA ---
RegisterNUICallback('openAnnouncements', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:getAnnouncements', function(announcements)
		for i=1, #announcements do
			SendNUIMessage({
				type = 'insertOgloszenia',
				id = announcements[i].id,
				ogloszenie = announcements[i].ogloszenie,
				fp = announcements[i].policjant,
				data = announcements[i].data,
			})
			cb("ok")
		end
	end)
end)

--- RAPORTY ---
RegisterNUICallback('openRaports', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:getRaports', function(raports)
		for i=1, #raports do
			SendNUIMessage({
				type = 'insertRaports',
				id = raports[i].id,
				raport = raports[i].raport,
				fp = raports[i].policjant,
				data = raports[i].data,
				status = raports[i].status,
			})
		end	
		cb("ok")
	end, data.identifier, Config.raportJobGrade, data.jobgrade)
end)


--- NOTATNIK ---
RegisterNUICallback('openNotepad', function(data, cb)
	ESX.TriggerServerCallback('glibcat_mdt:getUserNotepad', function(notepad)
		if notepad ~= nil then
			SendNUIMessage({
				type = 'insertNotepad',
				notepad = notepad[1].notatka,
			})
		end
		cb("ok")
	end, data.identifier)
end)

--- KARTOTEKA ---
RegisterNUICallback('checkFile', function(data, cb)
	if(data.firstName == nil or data.lastName == nil) then
		SendNUIMessage({
			type = 'zleDane',
		})
		cb("ok")
	else
		ESX.TriggerServerCallback('glibcat_mdt:checkFile', function(basic, multipleCharacters, kartoteka, poszukiwania, licenses, cars, notatki)
			if basic and not multipleCharacters then
				SendNUIMessage({
					type = 'openKartoteka',
					first = basic[1].firstname,
					last = basic[1].lastname,
					sex = basic[1].sex,
					birthDate = basic[1].dateofbirth,
					id = basic[1].identifier,
					kartoteka_avatar = basic[1].kartoteka_avatar,
					instant = false,
				})

				for i=1, #poszukiwania do
					SendNUIMessage({
						type = 'insertPoszukiwania',
						id = poszukiwania[i].id,
						fp = poszukiwania[i].policjant,
						reason = poszukiwania[i].powod,
						pojazd = poszukiwania[i].pojazd,
						data = poszukiwania[i].data,
					})
				end

				for i=1, #kartoteka do
					SendNUIMessage({
						type = 'insertKartoteka',
						id = kartoteka[i].id,
						fp = kartoteka[i].policjant,
						reason = kartoteka[i].powod,
						charge = kartoteka[i].grzywna,
						years = kartoteka[i].ilosc_lat,
						data = kartoteka[i].data,
					})
				end

				for i=1, #notatki do
					SendNUIMessage({
						type = 'insertNotatki',
						id = notatki[i].id,
						note = notatki[i].note,
						policjant = notatki[i].policjant,
						data = notatki[i].data,
					})
				end
				
				if poszukiwania[1] then
					SendNUIMessage({
						type = 'jestPoszukiwany',
					})
				end
				
				for i=1, #licenses do
					SendNUIMessage({
						type = 'insertLicenses',
						typ = licenses[i].type,
					})
				end
				
				for i=1, #cars do
					local decoded = json.decode(cars[i].vehicle)
					SendNUIMessage({
						type = 'insertCars',
						model = GetLabelText(GetDisplayNameFromVehicleModel(decoded["model"])),
						plate = cars[i].plate,
					})
				end
			elseif basic then
				SendNUIMessage({
					type = 'multipleCharacters',
					characters = basic,
				})
			else
				SendNUIMessage({type = 'brakUzytkownika'})
			end
			cb("ok")
		end, data.firstName, data.lastName)
	end
end)

RegisterNUICallback('checkFileByIdentifier', function(data, cb)
	if data.identifier == nil then
		SendNUIMessage({
			type = 'zleDane',
		})
		cb("ok")
	else
		ESX.TriggerServerCallback('glibcat_mdt:checkFileByIdentifier', function(basic, kartoteka, poszukiwania, licenses, cars, notatki)
			if basic then
				SendNUIMessage({
					type = 'openKartoteka',
					first = basic[1].firstname,
					last = basic[1].lastname,
					sex = basic[1].sex,
					birthDate = basic[1].dateofbirth,
					id = basic[1].identifier,
					kartoteka_avatar = basic[1].kartoteka_avatar,
					instant = true,
				})

				for i=1, #poszukiwania do
					SendNUIMessage({
						type = 'insertPoszukiwania',
						id = poszukiwania[i].id,
						fp = poszukiwania[i].policjant,
						reason = poszukiwania[i].powod,
						pojazd = poszukiwania[i].pojazd,
						data = poszukiwania[i].data,
					})
				end

				for i=1, #kartoteka do
					SendNUIMessage({
						type = 'insertKartoteka',
						id = kartoteka[i].id,
						fp = kartoteka[i].policjant,
						reason = kartoteka[i].powod,
						charge = kartoteka[i].grzywna,
						years = kartoteka[i].ilosc_lat,
						data = kartoteka[i].data,
					})
				end

				for i=1, #notatki do
					SendNUIMessage({
						type = 'insertNotatki',
						id = notatki[i].id,
						note = notatki[i].note,
						policjant = notatki[i].policjant,
						data = notatki[i].data,
					})
				end
				
				if poszukiwania[1] then
					SendNUIMessage({
						type = 'jestPoszukiwany',
					})
				end
				
				for i=1, #licenses do
					SendNUIMessage({
						type = 'insertLicenses',
						typ = licenses[i].type,
					})
				end
				
				for i=1, #cars do
					local decoded = json.decode(cars[i].vehicle)
					SendNUIMessage({
						type = 'insertCars',
						model = GetLabelText(GetDisplayNameFromVehicleModel(decoded["model"])),
						plate = cars[i].plate,
					})
				end
			else
				SendNUIMessage({type = 'brakUzytkownika'})
			end
			cb("ok")
		end, data.identifier)
	end
end)