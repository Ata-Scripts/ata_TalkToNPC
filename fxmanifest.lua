fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'jadgal'
description 'ataTalkToNpc'

ui_page 'html/index.html'
 
files {
    'html/**/*',
}

shared_scripts {
    "shared/*.lua",
    "locale.lua",
}

client_scripts {
    'client.lua',
}

server_scripts {
    'server.lua',
}

dependencies {
    'ata_core',
}
