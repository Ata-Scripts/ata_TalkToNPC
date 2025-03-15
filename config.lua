
----------- SALAM MILAD ------------
----------- SALAM ATA ------------


Config = {}



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
			{text = "notification", serverSide = false, event = "ataTalkToNpc:notification", 
			args = {title = "notification", message = "Would you like to proceed with opening a new account?", options = "Open Account", 
			icon = "fas fa-university", Clickevent = "ataTalkToNpc:example"}},
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
			{label = "Bread", name = "bread", price = 100},
			{label = "Water", name = "water", price = 100},
		},
        BuyItem = { -- if you using ata_talktonpc:buyItems you need to add items here
			{label = "Pistol", name = "weapon_pistol", price = 100},
			{label = "Assault Rifle", name = "weapon_assaultrifle", price = 100},
		},

		jobs = {},
	},
		{
		npc = 'a_m_m_salton_03',
		name = 'Mohammad Salah',	
        textUI = '[E] Talk With Mohammad',
		StartDialog = 'Hey, how can I help you?',
		coordinates = vector3(346.1, -977.82, 28.37),
		heading = 274.12,				
		options = {			
			{
                text = "Who are you ?",
                event = "ata_talktonpc:addChat",
                serverSide = false,
                args = {"text", "I'm a just a normal citizen, I can help you with your banking needs."},
                followUp = {
                    {
                        text = "Tell me about sora",
                        event = "ata_talktonpc:addChat",
                        serverSide = false,
                        args = {"text", "Sora is a very good person, he is a good citizen and he is a good person. WHO ARE YOU ??"},
						followUp = {
							{
								text = "nvm me , what is happing for sora ?",
								event = "ata_talktonpc:addChat", 
								serverSide = false,
								args = {"text", "Sora is dead , please don't talk about him"}
							},
						}
                    },
                    {
                        text = "What is your name ?",
                        event = "ata_talktonpc:addChat",
                        serverSide = false,
                        args = {"text", "My name is Mohammad."}
                    },
                    {
                        text = "What is your job ?",
                        event = "ata_talktonpc:addChat",
                        serverSide = false,
                        args = {
							"text", "I'm a just a normal citizen, can you go please i dont want to talk with you."
                        },
						followUp = {
							{
								text = "can you help me for find sora ? ",
								event = "ata_talktonpc:addChat", 
								serverSide = false,
								args = {"text", "sora is dead BI**CH , if kill you if you again talking about sora !!!"},
								followUp = {
									{
										text = "okkk , i will not talk about sora",
										event = "ata_talktonpc:addChat", 
										serverSide = false, 
										args = {"text", "Thank you for your cooperation."}
									},
								}
							},
						}
                    }
                }
            },
			{text = "I want to buy some of items from you", event = "ata_talktonpc:buyItems", serverSide = false},										
			{text = "Do you have any items for sell?", event = "ata_talktonpc:sellItems", serverSide = false},	
			{text = "Can you help me with where can i find gold ?", serverSide = false, event = "ata_talktonpc:notification", 
			args = {title = "notification", message = "I attach a GPS to the location of the gold you can find on the map with red color ways", options = "Add to GPS", 
			icon = "fas fa-location-dot", Clickevent = "Anything:Youwant_to_set_here :)) "}},
		},
		SellItem = {
			{label = "Lock Pick", name = "lockpick", price = 520},
			{label = "Tuner Chip", name = "tunerchip", price = 100},
			{label = "USB Device", name = "usb_device", price = 100},
			{label = "Weapon Knife", name = "weapon_knife", price = 10000},
			{label = "Weapon Wrench", name = "weapon_wrench", price = 100},
			{label = "Cocaine Baggy", name = "cocaine_baggy", price = 100},
		},
        BuyItem = {
			{label = "Handcuffs", name = "handcuffs", price = 3250},
			{label = "Gold Chain", name = "goldchain", price = 46000},
			{label = "Weed Brick", name = "weed_brick", price = 3658},
			{label = "Jerry Can", name = "jerry_can", price = 1362},
		},
        jobs = {},
	},
		{
		npc = 's_m_y_cop_01',
		name = 'Police Officer',	
        textUI = '[E] Talk With Police Officer',
		StartDialog = 'Hey, how can I help you?',
		coordinates = vector3(459.8, -990.66, 29.69),
		heading = 84.01,				
		options = {			
			{
                text = "Hello , everybody can buy and sell items here ?",
                event = "ata_talktonpc:addChat",
                serverSide = false,
                args = {"text", "No just police officer ambulance bcso can buy and sell items here"},
				followUp = {}
            },
			{text = "i have items , i want to buy it", event = "ata_talktonpc:buyItems", serverSide = false},										
			{text = "i want to sell some of items", event = "ata_talktonpc:sellItems", serverSide = false},	
			{text = "i want to open MDT", serverSide = false, event = "ata_talktonpc:notification", 
			args = {title = "notification", message = "I attach a GPS to the location of the gold you can find on the map with red color ways", options = "POLICE MDT", 
			icon = "fas fa-user-shield", Clickevent = "ata_store:openMDT"}}, ---- ata_store:openMDT is event name you can change it to anything you want 
		},
		SellItem = {
			{label = "Blood", name = "blood", price = 520},
			{label = "Bandage", name = "bandage", price = 100},
		},
        BuyItem = {
			{label = "weapon_pistol", name = "weapon_pistol", price = 3250},
			{label = "weapon_smg", name = "weapon_smg", price = 46000},
			{label = "weapon_assaultrifle", name = "weapon_assaultrifle", price = 3658},
			{label = "weapon_pistol", name = "weapon_pistol", price = 1362},
		},
        jobs = {
			'police',
			'ambulance',
			'bcso',
		},
	},
}


---------------------------------------------------------------------------------------------------------
---- Some Of Examples Events
---------------------------------------------------------------------------------------------------------	

-- RegisterNetEvent('ata_store:openMDT')
-- AddEventHandler('ata_store:openMDT', function()
--     TriggerEvent('ata_talktonpc:addChat', "text", 'Ok now i opened MDT for you')
-- 	Wait(1000)
-- 	print('open MDT')
-- 	TriggerEvent('ata_talktonpc:closeUI')
-- end)





