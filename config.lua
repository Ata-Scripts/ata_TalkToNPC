Config = {}

Config.Framework = "esx"
Config.Inventory = "ox_inventory" 

-- Target System
Config.Target = 'ox-target' -- 'ox-target', 'qb-target', or 'default'

-- Chat Settings
Config.Chat = {
    CoolDown = 1500,     -- Chat cooldown in ms
    ScrollSpeed = 1000,  -- Chat scroll animation speed
} 

Config.NPCinteraction = 'default' -- 'target' or 'default'

Config.TalkToNPC = {
	{
		npc = 'cs_bankman', 								
		name = 'Pacific Bank', 								
        textUI = 'Talk With Banker',
		StartDialog = 'Hey, how can I help you?',				
		coordinates = vector3(254.17, 222.8, 105.3), 		
		heading = 160.0,						
		options = {			
			{text = "I want to buy some of items from you", event = "ata_talktonpc:buyItems", serverSide = false},										
			{text = "sell Items", event = "ata_talktonpc:sellItems", serverSide = false},									
			{
                text = "Tell me about your banking services",
                event = "ata_talktonpc:addChat",
                serverSide = false,
                args = {"text", "We offer various banking services. What would you like to know about?"},
                followUp = {
                    {
                        text = "Tell me about loans",
                        event = "ata_talktonpc:addChat",
                        serverSide = false,
                        args = {"text", "We offer competitive interest rates starting from 5% APR..."},
						followUp = {
							{
								text = "Tell me more about interest rates",
								event = "ata_talktonpc:addChat", 
								serverSide = false,
								args = {"text", "Our current loan interest rates range from 5-12% APR depending on your credit score and loan term. We offer both fixed and variable rate options to suit your needs."}
							},
						}
                    },
                    {
                        text = "Tell me about savings accounts",
                        event = "ata_talktonpc:addChat",
                        serverSide = false,
                        args = {"text", "Our savings accounts offer up to 3% interest annually..."}
                    },
                    {
                        text = "I'd like to open an account",
                        event = "ata_talktonpc:addChat",
                        serverSide = false,
                        args = {
                            title = "Banking Services",
                            message = "Would you like to proceed with opening a new account?",
                            options = "Open Account",
                            event = "ata_talktonpc:addChat",
                            serverSide = false,
							args = {"text", "Our current loan interest rates range from 5-12% APR depending on your credit score and loan term. We offer both fixed and variable rate options to suit your needs."}
                        }
                    }
                }
            }
		},
		SellItem = { -- if you using ata_talktonpc:sellItems you need to add items here
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
		},
        BuyItem = { -- if you using ata_talktonpc:buyItems you need to add items here
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
		},

		jobs = {},
	},

		{
		npc = 'a_m_m_salton_03',
		name = 'Pacific Bank',	
        textUI = 'Talk With Banker',
		StartDialog = 'Hey, how can I help you?',
		coordinates = vector3(256.232971, 274.997803, 104.609497),
		heading = 337.32,				
		options = {			
			{text = "I want to buy some of items from you", event = "ata_talktonpc:buyItems", serverSide = false},										
			{text = "sell Items", event = "ata_test:GetJobsCanUse", serverSide = true, onClose = true},									
		},
		SellItem = {},
        BuyItem = {},
        jobs = {},
	},
}
