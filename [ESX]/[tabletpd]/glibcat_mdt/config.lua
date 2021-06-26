Config              = {}
Config.Locale       = 'pl'

----- GŁÓWNE USTAWIENIA -----
-- Nazwa serwera, wyświetlająca się w lewym górnym rogu tabletu
-- Nazwe serwera musicie ustawić również w "client\html\scripts\alertify.js" linia 68
Config.serverName = "Los Santos Police Department"

-- Twój imgur Client ID
-- https://www.youtube.com/watch?v=AEHr_H4OMIU
Config.imgurApiKey = "386fdd6c66045e6"

-- Klawisz otwierający tablet
-- Dostępne klawisze znajdują się na górze pliku 'client.lua'
Config.openingKey = "DELETE"

-- Czas (w sekundach), po ktorym tablet zostanie automatycznie zrestartowany (domyslnie 2 minuty)
-- Czysci wszystkie zapisane wartosci + wymaga ponownego "zalogowania"
Config.restartTime = 600

-- Czas, po którym będzie aktualizował się czas online policjantów
-- Nie zalecamy ustawiania zbyt niskiego czasu (domyślnie 1800)
Config.timeOnlineRefresh = 10 * 1000

-- Nazwa joba na który ma działać tablet
Config.jobName = "police"

-- Nazwa offduty joba
Config.offDutyJobName = "offpolice"

----- WYSYŁKA DO WIĘZIENIA + MANDATY -----

-- Czy mnożyć ilość lat w więzieniu?
-- Musicie sprawdzić czy wasz plugin odpowiadający za więzienie liczy czas w minutach czy w sekundach
Config.multiplyJailTime = true

-- Razy ile ma zostać pomnożony czas w więzieniu (domyślnie 60)
Config.jailTimeMultiplier = 60

-- Jaka czesc mandatu ma otrzymac policjant (pozostała część trafia na policyjne konto)
Config.officerReward = 0.5

----- LOGOWANIE -----

-- Sposób logowania
-- "FINGERPRINT" - bez zmian ;P
-- "PASSWORD" - policjanci muszą logować się za pomocą loginu i hasła
-- w kolejnym punkcie ustalacie sposób tworzenia hasła
Config.loginMethod = "FINGERPRINT"

-- Sposób tworzenia hasła
-- "BOSS" - loginy i hasła tworzy szef LSPD (osoba mająca wiekszy JobGrade niż "Config.managementJobGrade"
-- "FIRST" - policjanci sami tworzą sobie hasła, przy pierwszym logowaniu
-- "NONE" - jeżeli korzystasz z logowania odciskiem palca
Config.passwordMethod = "NONE"

-- Ranga "BOSSa", której posiadacze, przy pierwszym uruchomieniu swojego tabletu
-- będą mogli utworzyć sobie konta, tak jak przy wybranej opcji FIRST
-- Ta opcja ma znaczenie tylko przy wybranej opcji "BOSS"
Config.bossPasswordBypass = 10

----- WYMAGANE RANGI -----

-- Minimalny jobgrade, żeby mieć dostęp do "zarządzania"
Config.managementJobGrade = 14

-- Minimalny jobgrade, żeby móc nadawać licencje
Config.licensesAddJobGrade = 6

-- Minimalny jobgrade, żeby móc usuwać licencje
Config.licensesRemoveJobGrade = 6

-- Minimalny jobgrade, żeby móc usuwać wpisy z kartoteki (historia kar)
Config.fileJobGrade = 10

-- Minimalny jobgrade, żeby móc zmieniać zdjęcia
Config.imageJobGrade = 6

-- Minimalny jobgrade, żeby móc zarządzać ogłoszeniami (dodawać, usuwać)
Config.announcementsJobGrade = 10

-- Minimalny jobgrade, żeby zarządzać raportami (czytać wszystkie, usuwać)
Config.raportJobGrade = 12

----- LIMITY -----

-- Maksymalna kwota mandatu
Config.maxTicket = 500000

-- Maksymalna ilość lat w więzieniu
Config.maxJailTime = 500

-- Ile razy moze zostac nabita kara w taryfikatorze
Config.maxTariff = 5

-- Maksymalna wynagrodzenie (zalecamy ustawić takie samo jak w esx_society)
Config.maxSalary = 1500

----- POBLISCY GRACZE -----

-- Czy w liście obywateli w okolicy ma pokazywać imiona i nazwiska obywateli, czy samo ID
-- NAME = Imię Nazwisko [ID]
-- ID = Obywatel [ID]
Config.nearbyPlayers = "NAME"
Config.EnableESXIdentity = true

-- Z jakiej odległośći ma dopisywać graczy przy wystawianiu mandatu/wysyłce do więzienia
Config.nearbyPlayersDistance = 10

----- ODZNAKI -----

-- Czy uzywac systemu odznak
Config.useBadges = true

-- Jaki system odznak ma byc uzywany
-- CUSTOM - wprowadzamy całe odznaki
-- JOBGRADE - ustalamy policjantowi cyferkę, a prefix jest dobierany na podstawie JOBGRADE [prefixy w locales]
-- NONE - jeżeli nie korzystasz z odznak
Config.badgesType = "CUSTOM"

---- Czas na służbie ----

-- Czy ma liczyć czas policjantów na służbie?
Config.useOnDutyTime = true

----- RAPORTY -----

-- Czy uzywac systemu raportow
Config.useRaports = true

----- DISPATCH -----

-- Czy chcesz uzywac dispatcha?
Config.useDispatch = true

-- Jeżeli po kilku uruchomieniach dispatch przestaje działać, ustaw wartość zmiennej poniżej na 1
-- Spodowuje to, że dispatch za każdym razem będzie wczytywał się na nowo
Config.dispatchProblem = 0

----- WEBHOOKI -----

-- Czy uzywac webhookow
Config.useWebhooks = true

-- Czy oznaczac w webhookach
Config.discordTag = true

-- nazwa bota
Config.username = "LSPD"

-- avatar bota
Config.avatar = "https://via.placeholder.com/30x30"

-- nazwa w embedzie
Config.fractionName = "LSPD"

-- ikona w embedzie
Config.fractionLogo = "https://via.placeholder.com/30x30"

--- Kolory ---

--https://www.mathsisfun.com/hexadecimal-decimal-colors.html
Config.removeLicense = "16711680"
Config.addLicense = "65280"
Config.mandatColor = "65466"
Config.jailColor = "23702"
Config.logColor = "0"
Config.announcementColor = "16580496"
Config.suspectAddColor = "16515072"
Config.suspectRemoveColor = "4352255"
Config.raportColor = "3139327"

