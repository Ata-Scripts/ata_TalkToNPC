fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'ata_TalkToNPC'
author 'By ATA.TEBEX.IO'
description 'resource for NPC interactions and dialogues'
version '1.0.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/*.css',
    'html/*.js',
    'html/images/*.png',
    'html/fonts/*.ttf'
}

shared_scripts {
    'config.lua',
    'locale.lua'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua'
}

dependencies {
    'ata_core'
}

escrow_ignore {
    'config.lua',
    'locale.lua'
}
