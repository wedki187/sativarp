radioConfig = {
    Controls = {
        Activator = { -- Open/Close Radio
            Name = "INPUT_FRONTEND_RRIGHT", -- Control name
            Key = 194, -- BACKSPACE
        },
        Toggle = { -- Toggle radio on/off
            Name = "INPUT_CONTEXT", -- Control name
            Key = 51, -- E
        },
        Input = { -- Choose Frequency
            Name = "INPUT_FRONTEND_ACCEPT", -- Control name
            Key = 201, -- Enter
            Pressed = false,
        },
        ToggleClicks = { -- Toggle radio click sounds
            Name = "INPUT_SELECT_WEAPON", -- Control name
            Key = 37, -- Tab
        }
    },
    Frequency = {
        Private = { -- List of private frequencies
            [1] = true
        },
        Current = 1, -- Don't touch
        CurrentIndex = 1, -- Don't touch
        Min = 1, -- Minimum frequency
        Max = 80, -- Max number of frequencies
        List = {}, -- Frequency list, Don't touch
        Access = {
            [1] = {'org1'}, -- LCN
            [2] = {'org2'}, -- Flame Force
            [3] = {'org3'}, -- dt
            [4] = {'org4'}, -- gt
            [5] = {'org5'}, -- The Syndicate
            [6] = {'org6'}, -- Przyjemniaczki
            [7] = {'org7'}, -- OMEGA
            [8] = {'org8'}, -- aks
            [9] = {'org9'}, -- candyboyzzz
            [10] = {'org10'}, -- Brooklyn
            [11] = {'org11'}, -- FSG
            [12] = {'org12'}, -- NIT
            [13] = {'org13'}, -- CDP
            [14] = {'org14'}, -- CG
            [15] = {'org15'}, -- ZADYMIARZE
            [16] = {'org16'}, -- DLL
            [17] = {'org17'}, -- TEC
            [18] = {'org18'}, -- WW
            [19] = {'org19'}, -- Mejores Amigos
            [20] = {'org20'}, -- LV
            [22] = {'org22'}, -- Odjebancy
	    [23] = {'org23'}, -- AFRICA
            [24] = {'org24'}, -- HandleBoyz
            [25] = {'org25'}, -- FPS
	    [26] = {'org26'}, -- DESPERADOS
 	    [27] = {'org27'}, -- BRUSH
	    [28] = {'org28'}, -- PFC
	    [29] = {'org29'}, -- WOLOMIN
	    [30] = {'org30'}, -- Stacyjkowo
	    [31] = {'org31'}, -- OBH
	    [32] = {'org32'}, -- APEKI
	    [33] = {'org33'}, -- SWS
	    [34] = {'org34'}, -- DCA
	    [35] = {'org35'}, -- KGM
	    [36] = {'org36'}, -- 2115
            [37] = {'org37'}, -- urfrailty
	    [38] = {'org38'}, -- GDS
	    [39] = {'org39'}, -- EB
	    [40] = {'org40'}, -- FOH
	    [41] = {'org41'}, -- SCB
	    [42] = {'org42'}, -- ALCO
        [43] = {'police'}, -- PD Main Channel
        [44] = {'police'}, -- PD Taktyczny 1
        [45] = {'police'}, -- PD Taktyczny 2
        }
    },
    AllowRadioWhenClosed = true -- Allows the radio to be used when not open (uses police radio animation) 
}