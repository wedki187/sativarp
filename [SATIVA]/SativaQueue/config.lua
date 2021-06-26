Config = {}

----------------------------------------------------
-------- Intervalles en secondes -------------------
----------------------------------------------------

-- Temps d'attente Antispam / Waiting time for antispam
Config.AntiSpamTimer = math.random(5,10)

-- Vérification et attribution d'une place libre / Verification and allocation of a free place
Config.TimerCheckPlaces = 3

-- Mise à jour du message (emojis) et accès à la place libérée pour l'heureux élu / Update of the message (emojis) and access to the free place for the lucky one
Config.TimerRefreshClient = 1

-- Mise à jour du nombre de points / Number of points updating
Config.TimerUpdatePoints = 2

----------------------------------------------------
------------ Nombres de points ---------------------
----------------------------------------------------

-- Nombre de points gagnés pour ceux qui attendent / Number of points earned for those who are waiting
Config.AddPoints = 1

-- Nombre de points perdus pour ceux qui sont entrés dans le serveur / Number of points lost for those who entered the server
Config.RemovePoints = 1

-- Nombre de points gagnés pour ceux qui ont 3 emojis identiques (loterie) / Number of points earned for those who have 3 identical emojis (lottery)
Config.LoterieBonusPoints = 0

-- Accès prioritaires / Priority access
Config.Points = {
	{'steam:110000145846e9f', 10000}, -- foriiv
	{'steam:1100001459c1bff', 10000}, -- ceglaaa
    {'steam:110000117a75d53', 10000}, -- vamestmdog
    {'steam:110000134106078', 8000}, -- rajaner
	{'steam:11000010519106a', 8000}, -- lolek
	{'steam:11000011cff44e5', 8000}, -- akuku
    {'steam:110000113d0087c', 3000}, -- danny
    {'steam:11000013b60e673', 5000}, -- sota
    {'steam:11000010e01f85e', 3000}, -- zajac
	{'steam:110000131fc1dfa', 3000}, -- kubixo
	{'steam:110000117ccf9b3', 4300}, -- MAKSIK
	{'steam:11000010d14976d', 2500}, -- cooky
	{'steam:1100001456aa61f', 2500}, -- clusmy.agust
	{'steam:110000142867c4c', 2500}, --  wadsikk
	{'steam:110000134a8521a', 1500}, --  187kabi
	{'steam:11000013b80aa6d', 1500}, --  dlugy
	{'steam:11000011a44438', 1500}, -- leni(donator)

	{'steam:1100001402ec6e3', 400}, --  omni
	{'steam:110000136e780f0', 400}, -- depresja#2137

}

Config.NoSteam = "Aby otrzymać bilet na wyspę potrzebujesz STEAM"
Config.EnRoute = "Dołączanie..."
Config.PointsRP = " - priorytetowy bilet"
Config.Position = "Jesteś na pozycji "
Config.EmojiMsg = "Jeśli emotki nie ruszają się zrestartuj FiveM: "
Config.EmojiBoost = "" .. Config.LoterieBonusPoints .. " "
Config.PleaseWait_1 = "Proszę czekać "
Config.PleaseWait_2 = " sek."
Config.Accident = "BŁĄD"
Config.Error = " BŁĄD"

Config.EmojiList = {
	'💜', 
	'☂️',
	'✨',
	'🍇',
	'🔮',
	'🧱',
	'🍆',
	'💜',
	'🍇'
}
