Config                            = {}
Config.DrawDistance               = 10.0

Config.Blips = {
	['org1'] = vector3(2704.56, 3459.4, 55.34),
	['org2'] = vector3(184.77, 1247.56, 225.45),
	['org3'] = vector3(108.2, 2340.53, 89.25),
	['org4'] = vector3(828.47, 2189.47, 54.68),
	['org5'] = vector3(1387.42, 1142.12, 87.57),
	['org6'] = vector3(666.56, 6472.29, 268.18),
	['org7'] = vector3(-128.23, 983.59, 317.72),
	['org8'] = vector3(-1462.52, -31.99, 54.68),
	['org9'] = vector3(180.54, 2782.05, 45.96),
	['org10'] = vector3(384.14, 5.01, 91.27),
	['org11'] = vector3(2672.08, 3519.06, 52.71),
	['org12'] = vector3(939.57, -1492.33, 30.09),
	['org13'] = vector3(-591.1, -1630.4, 26.54),
	['org14'] = vector3(-1890.91, 2046.36, 140.86), 
	['org15'] = vector3(2343.52, 3136.79, 48.21),
	['org16'] = vector3(816.72, -3087.51, 5.9),
	['org17'] = vector3(1533.29, 2232.02, 77.7),
	['org18'] = vector3(-2654.42, 1324.34, 147.44),
	['org19'] = vector3(-87.78, 835.24, 235.92),
	['org20'] = vector3(717.28, -796.84, 16.47),
	['org21'] = vector3(155.55, 3126.94, 42.5),
	['org22'] = vector3(-1527.25, 855.87, 181.6),
	['org23'] = vector3(180.54, 2782.05, 45.96),
	['org24'] = vector3(-241.69, 2591.18, 52.67),
        ['org25'] = vector3(735.88, -1291.24, 26.3),
        ['org26'] = vector3(-1567.42, 31.93, 59.03),
        ['org27'] = vector3(37.2, 6455.14, 31.43),
        ['org28'] = vector3(-1133.15, 380.45, 70.75),
        ['org29'] = vector3(-1806.41, 449.62, 128.51),
        ['org30'] = vector3(158.79, 3133.91, 43.53),
    	['org31'] = vector3(-823.77, 176.42, 71.13),
    	['org32'] = vector3(1548.77, 3512.11, 35.99),
	['org33'] = vector3(-1527.48, 139.01, 55.65),
	['org34'] = vector3(-1038.72, 313.45, 67.08),
	['org35'] = vector3(388.7, 2.43, 91.42),
	['org36'] = vector3(-749.49, 818.45, 213.44), 
	['org37'] = vector3(-823.9, 806.29, 202.78),
	['org38'] = vector3(-931.58, 807.88, 184.78),
	['org39'] = vector3(-1540.22, 418.14, 109.72), 
	['org40'] = vector3(-1743.37, 364.3, 88.73),
	['org41'] = vector3(2734.94, 4279.72, 48.41),
	['org42'] = vector3(2880.19, 4491.86, 48.11),
	['org43'] = vector3(-848.72, -26.82, 39.59),
	['org44'] = vector3(826.65, -2333.23, 30.41),
	['org45'] = vector3(88.51, -223.23, 54.66)
}


Config.List = {
	[1] = 'SNS',
	[2] = 'snspistol',
	[3] = 'SNS MK2',
	[4] = 'snspistol_mk2',
	[5] = 'Pistolet',
	[6] = 'pistol',
	[7] = 'Pistolet MK2',
	[8] = 'pistol_mk2',
	[9] = 'Vintage',
	[10] = 'vintagepistol',
}   

Config.Organisations = {
	['org1'] = {
		Label = 'LCN',
		Cloakroom = {
			coords = vector3(2754.39, 3537.85, 33.77),
		},
		Inventory = {
			coords = vector3(2747.14, 3529.01, 39.74),
			from = 3,
		},
		BossMenu = {
			coords = vector3(2711.07, 3534.4, 39.74),
			from = 3
		},
	},
	['org2'] = {
		Label = 'RTA',
		Cloakroom = {
			coords = vector3(105.66, 1211.28, 207.17),
		},
		Inventory = {
			coords = vector3(89.25, 1236.99, 207.17),
			from = 3,
		},
		BossMenu = {
			coords = vector3(106.34, 1204.55, 207.17),
			from = 3
		},
	},
	['org3'] = {
		Label = 'DT',
		Cloakroom = {
			coords = vector3(114.94, 2346.75, 89.23),
		},
		Inventory = {
			coords = vector3(83.43, 2339.68, 86.23),
			from = 3,
		},
		BossMenu = {
			coords = vector3(111.06, 2342.26, 89.23),
			from = 3
		},
	},			
	['org4'] = {
		Label = 'GT',
		Cloakroom = {
			coords = vector3(977.57, 2071.57, 36.67),
		},
		Inventory = {
			coords = vector3(896.94, 2116.6, 41.41),
			from = 3,
		},
		BossMenu = {
			coords = vector3(939.29, 2074.16, 36.66),
			from = 3
		},
	},			
	['org5'] = {
		Label = 'The Syndicate',
		Cloakroom = {
			coords = vector3(1403.78, 1144.66, 114.34),
		},
		Inventory = {
			coords = vector3(1399.96, 1139.71, 114.34),
			from = 3,
		},
		BossMenu = {
			coords = vector3(1393.52, 1160.2, 114.34),
			from = 3
		},
	},
	['org6'] = {
		Label = 'KTM',
		Cloakroom = {
			coords = vector3(464.44, 6525.46, 13.74),
		},
		Inventory = {
			coords = vector3(544.15, 6526.64, 13.95),
			from = 3,
		},
		BossMenu = {
			coords = vector3(500.23, 6537.98, 13.73),
			from = 3
		},
	},			
	['org7'] = {
		Label = 'CEO',
		Cloakroom = {
			coords = vector3(-90.75, 994.12, 234.56),
		},
		Inventory = {
			coords = vector3(-85.46, 998.16, 230.61),
			from = 3,
		},
		BossMenu = {
			coords = vector3(-99.93, 1013.05, 235.8),
			from = 3
		},
	},		
	['org8'] = {
		Label = 'PM',
		Cloakroom = {
			coords = vector3(-1476.62, -38.32, 54.61),
		},
		Inventory = {
			coords = vector3(-1481.62, -36.77, 54.61),
			from = 3,
		},
		BossMenu = {
			coords = vector3(-1471.4, -32.79, 54.61),
			from = 3
		},
	},		
	['org9'] = {
		Label = 'CD',
		Cloakroom = {
			coords = vector3(180.54, 2782.05, 45.96),
		},
		Inventory = {
			coords = vector3(168.26, 2798.17, 45.96),
			from = 3,
		},
		BossMenu = {
			coords = vector3(173.57, 2799.98, 45.96),
			from = 3
		},
	},	
	['org10'] = {
		Label = 'FlameForce',
		Cloakroom = {
			coords = vector3(388.11, -13.33, 86.67),
		},
		Inventory = {
			coords = vector3(411.89, 4.1, 84.92),
			from = 3,
		},
		BossMenu = {
			coords = vector3(391.19, -9.57, 86.68),
			from = 3
		},
	},	
	['org11'] = {
		Label = 'FSG',
		Cloakroom = {
			coords = vector3(2682.21, 3508.28, 53.3),
		},
		Inventory = {
			coords = vector3(2684.43, 3515.69, 53.3),
			from = 3,
		},
		BossMenu = {
			coords = vector3(2676.01, 3499.82, 53.3),
			from = 3
		},
	},	
	['org12'] = {
		Label = 'SM',
		Cloakroom = {
			coords = vector3(930.7, -1462.79, 33.61),
		},
		Inventory = {
			coords = vector3(943.25, -1466.77, 30.01),
			from = 3,
		},
		BossMenu = {
			coords = vector3(946.51, -1463.92, 33.61),
			from = 3
		},
	},	
	['org13'] = {
		Label = 'SWS',
		Cloakroom = {
			coords = vector3(-579.0, -1623.75, 33.04),
		},
		Inventory = {
			coords = vector3(-587.28, -1611.15, 27.01),
			from = 3,
		},
		BossMenu = {
			coords = vector3(-624.39, -1628.83, 33.01),
			from = 3
		},
	},	
	['org14'] = {
		Label = 'CG',
		Cloakroom = {
			coords = vector3(-1887.29, 2069.95, 145.57),
		},
		Inventory = {
			coords = vector3(-1869.51, 2059.21, 135.43),
			from = 3,
		},
		BossMenu = {
			coords = vector3(-1875.93, 2061.03, 145.57),
			from = 3
		},
	},	
	['org15'] = {
		Label = 'zadymiarze',
		Cloakroom = {
			coords = vector3(2347.84, 3138.92, 48.21),
		},
		Inventory = {
			coords = vector3(2352.83, 3136.72, 48.21),
			from = 3,
		},
		BossMenu = {
			coords = vector3(2340.63, 3126.49, 48.21),
			from = 3
		},
	},	
	['org16'] = {
		Label = 'TBF',
		Cloakroom = {
			coords = vector3(908.0, -3183.45, -17.31),
		},
		Inventory = {
			coords = vector3(1013.17, -3242.93, -17.75),
			from = 3,
		},
		BossMenu = {
			coords = vector3(925.68, -3160.56, -17.34),
			from = 3
		},
	},	
	['org17'] = {
		Label = 'PM',
		Cloakroom = {
			coords = vector3(1547.65, 2228.65, 77.79),
		},
		Inventory = {
			coords = vector3(1537.69, 2234.67, 77.79),
			from = 3,
		},
		BossMenu = {
			coords = vector3(1542.56, 2224.58, 77.82),
			from = 3
		},
	},	
	['org18'] = {
		Label = 'WW',
		Cloakroom = {
			coords = vector3(-2670.21, 1336.15, 140.88),
		},
		Inventory = {
			coords = vector3(-2676.42, 1325.58, 144.26),
			from = 3,
		},
		BossMenu = {
			coords = vector3(-2670.85, 1335.25, 144.26),
			from = 3
		},
	},	
	['org19'] = {
		Label = '936',
		Cloakroom = {
			coords = vector3(-66.77, 826.46, 231.33),
		},
		Inventory = {
			coords = vector3(-100.06, 823.21, 227.88),
			from = 3,
		},
		BossMenu = {
			coords = vector3(-71.03, 834.39, 235.72),
			from = 3
		},
	},	
	['org20'] = {
		Label = 'LVN',
		Cloakroom = {
			coords = vector3(732.79, -795.29, 18.07),
		},
		Inventory = {
			coords = vector3(723.95, -790.83, 16.47),
			from = 3,
		},
		BossMenu = {
			coords = vector3(732.08, -800.4, 18.07),
			from = 3
		},
	},	
	['org22'] = {
		Label = 'CIS',
		Cloakroom = {
			coords = vector3(-1521.99, 830.13, 181.55),
		},
		Inventory = {
			coords = vector3(-1499.99, 835.7, 178.7),
			from = 3,
		},
		BossMenu = {
			coords = vector3(-1525.07, 842.13, 181.55),
			from = 3
		},
	},	
	['org23'] = {
		Label = 'GCV',
		Cloakroom = {
			coords = vector3(180.54, 2782.05, 45.96),
		},
		Inventory = {
			coords = vector3(168.26, 2798.17, 45.96),
			from = 3,
		},
		BossMenu = {
			coords = vector3(173.57, 2799.98, 45.96),
			from = 3
		},
	},	
	['org24'] = {
		Label = 'LFO',
		Cloakroom = {
			coords = vector3(-177.24, 2581.61, 35.57),
		},
		Inventory = {
			coords = vector3(-149.58, 2597.84, 32.57),
			from = 3,
		},
		BossMenu = {
			coords = vector3(-175.9, 2587.86, 35.57),
			from = 3
		},
	},	
	['org25'] = {
		Label = 'LCD',
		Cloakroom = {
			coords = vector3(753.66, -1298.96, 26.3),
		},
		Inventory = {
			coords = vector3(754.66, -1299.96, 26.3),
			from = 3,
		},
		BossMenu = {
			coords = vector3(762.93, -1293.69, 26.3),
			from = 3
		},
	},
	['org26'] = {
		Label = 'DOL',
		Cloakroom = {
			coords = vector3(-1580.39, 15.48, 64.89),
		},
		Inventory = {
			coords = vector3(-1569.98, 16.69, 56.4),
			from = 3,
		},
		BossMenu = {
			coords = vector3(-1566.08, 13.86, 64.89),
			from = 3
		},
	},	
	['org27'] = {
		Label = 'BRUSH',
		Cloakroom = {
			coords = vector3(42.25, 6467.16, 32.08),
		},
		Inventory = {
			coords = vector3(25.04, 6466.43, 31.43),
			from = 3,
		},
		BossMenu = {
			coords = vector3(37.19, 6463.67, 32.08),
			from = 3
		},
	},	
	['org28'] = {
		Label = 'PFC',
		Cloakroom = {
			coords = vector3(-1132.52, 365.36, 74.93),
		},
		Inventory = {
			coords = vector3(-1143.45, 369.0, 71.31),
			from = 3,
		},
		BossMenu = {
			coords = vector3(-1123.57, 361.53, 71.31),
			from = 3
		},
	},		
	['org29'] = {
		Label = 'wolomin',
		Cloakroom = {
			coords = vector3(-1800.82, 437.22, 128.71),
		},
		Inventory = {
			coords = vector3(-1811.39, 437.24, 128.71),
			from = 3,
		},
		BossMenu = {
			coords = vector3(-1805.02, 436.75, 128.83),
			from = 3
		},
	},
	['org30'] = {
		Label = 'TiltedFamily',
		Cloakroom = {
			coords = vector3(163.28, 3131.27, 43.58),
		},
		Inventory = {
			coords = vector3(156.44, 3129.1, 43.58),
			from = 3,
		},
		BossMenu = {
			coords = vector3(159.17, 3129.84, 43.58),
			from = 3
		},
	},		
	['org31'] = {
		Label = '223',
		Cloakroom = {
			coords = vector3(-811.75, 175.04, 76.75),
		},
		Inventory = {
			coords = vector3(-804.55, 177.47, 72.83),
			from = 3,
		},
		BossMenu = {
			coords = vector3(-807.74, 167.33, 76.74),
			from = 3
		},
	},	
	['org32'] = {
		Label = 'PRR',
		Cloakroom = {
			coords = vector3(1557.61, 3516.59, 36.05),
		},
		Inventory = {
			coords = vector3(1554.57, 3523.52, 35.86),
			from = 3,
		},
		BossMenu = {
			coords = vector3(1548.77, 3512.11, 35.99),
			from = 3
		},
	},	
	['org33'] = {
		Label = 'GJO',
		Cloakroom = {
			coords = vector3(-1522.51, 122.74, 48.65),
		},
		Inventory = {
			coords = vector3(-1518.29, 125.78, 48.65),
			from = 3,
		},
		BossMenu = {
			coords = vector3(-1545.49, 137.72, 55.65),
			from = 3
		},
	},	
	['org34'] = {
		Label = 'AIDS',
		Cloakroom = {
			coords = vector3(-1034.48, 313.85, 61.62),
		},
		Inventory = {
			coords = vector3(-1046.57, 296.48, 62.22),
			from = 3,
		},
		BossMenu = {
			coords = vector3(-1047.09, 303.17, 71.67),
			from = 3
		},
	},	
	['org35'] = {
		Label = 'DANDERO',
		Cloakroom = {
			coords = vector3(393.74, -11.27, 86.67),
		},
		Inventory = {
			coords = vector3(388.08, -10.47, 86.68),
			from = 3,
		},
		BossMenu = {
			coords = vector3(390.57, -10.07, 86.68),
			from = 3,
		},
	},	
	['org36'] = {
		Label = '2115',
		Cloakroom = {
			coords = vector3(-762.0, 804.08, 215.19),
		},
		Inventory = {
			coords = vector3(-763.59, 810.62, 213.51),
			from = 3,
		},
		BossMenu = {
			coords = vector3(-751.15, 815.99, 216.99),
			from = 3
		},
	},	
	['org37'] = {
		Label = 'urfrailty',
		Cloakroom = {
			coords = vector3(-823.58, 802.63, 206.2),
		},
		Inventory = {
			coords = vector3(-818.73, 803.44, 202.79),
			from = 3,
		},
		BossMenu = {
			coords = vector3(-823.73, 796.41, 202.65),
			from = 3
		},
	},	
	['org38'] = {
		Label = 'GDS',
		Cloakroom = {
			coords = vector3(-929.41, 811.61, 184.82),
		},
		Inventory = {
			coords = vector3(-932.98, 824.01, 184.4),
			from = 3,
		},
		BossMenu = {
			coords = vector3(-917.02, 817.7, 187.87),
			from = 3
		},
	},	
	['org39'] = {
		Label = 'HOOLS',
		Cloakroom = {
			coords = vector3(-1527.65, 416.97, 109.72),
		},
		Inventory = {
			coords = vector3(-1535.29, 412.69, 109.7),
			from = 3,
		},
		BossMenu = {
			coords = vector3(-1526.25, 420.72, 109.7),
			from = 3
		},
	},	
	['org40'] = {
		Label = 'DOP',
		Cloakroom = {
			coords = vector3(-1717.46, 383.09, 89.73),
		},
		Inventory = {
			coords = vector3(-1729.35, 359.41, 88.73),
			from = 3,
		},
		BossMenu = {
			coords = vector3(-1732.76, 353.49, 88.73),
			from = 3
		},
	},	
	['org41'] = {
		Label = 'SCB',
		Cloakroom = {
			coords = vector3(2736.66, 4285.33, 48.68),
		},
		Inventory = {
			coords = vector3(2735.18, 4287.04, 48.47),
			from = 3,
		},
		BossMenu = {
			coords = vector3(2740.27, 4289.52, 48.68),
			from = 3
		},
	},	
	['org42'] = {
		Label = '2010boyz',
		Cloakroom = {
			coords = vector3(2889.71, 4564.56, 32.34),
		},
		Inventory = {
			coords = vector3(2920.62, 4564.21, 32.34),
			from = 3,
		},
		BossMenu = {
			coords = vector3(2883.7, 4568.07, 32.34),
			from = 3
		},
	},	
	['org43'] = {
		Label = 'zwd',
		Cloakroom = {
			coords = vector3(-856.8, -38.61, 39.59),
		},
		Inventory = {
			coords = vector3(-846.93, -40.58, 39.44),
			from = 3,
		},
		BossMenu = {
			coords = vector3(-860.77, -41.47, 39.59),
			from = 3
		},
	},	
	['org44'] = {
		Label = 'tnh',
		Cloakroom = {
			coords = vector3(805.15, -2334.24, 30.46),
		},
		Inventory = {
			coords = vector3(816.22, -2314.84, 30.71),
			from = 3,
		},
		BossMenu = {
			coords = vector3(811.4, -2322.36, 30.46),
			from = 3
		},
	},	
	['org45'] = {
		Label = 'LaFamilia',
		Cloakroom = {
			coords = vector3(86.38, -223.83, 48.97),
		},
		Inventory = {
			coords = vector3(86.67, -218.7, 48.97),
			from = 3,
		},
		BossMenu = {
			coords = vector3(72.18, -223.97, 48.97),
			from = 3
		},
	},	
}

Config.Interactions = {
    ['org1'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org2'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org3'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org4'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org5'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org6'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org7'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org8'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org9'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org10'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org11'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org12'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org13'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org14'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org15'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org16'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org17'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org18'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org19'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org20'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org21'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org22'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org23'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org24'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org25'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org26'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org27'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org28'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org29'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org30'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org31'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org32'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org33'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org34'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org35'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org36'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org37'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org38'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org39'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org40'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org41'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org42'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org43'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org44'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org45'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
}

Config.BlipTime = 300 -- W sekundach
Config.Cooldown = 300 -- W sekundach

Config.Jobs = {
	'org1',
	'org2',
}
