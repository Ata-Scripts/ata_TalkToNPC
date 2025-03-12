Config = {}

Config.Framework = "esx"
Config.Inventory = "ox_inventory" 

-- Target System
Config.Target = 'ox-target' -- 'ox-target', 'qb-target', or 'default'

-- Text UI Settings (used when Target is set to 'default')
Config.TextUI = {
    Type = 'default', -- 'okok' or 'default'
    Position = 'left-center', -- Position of the text UI (for okokTextUI)
    Style = 'dark',  -- Style of the text UI (for okokTextUI)
    TimeOut = 5000,  -- How long the text UI should stay (in ms)
}

-- Interaction Settings
Config.InteractionDistance = 2.0  -- Distance to interact with NPCs
Config.InteractionKey = 38       -- E key by default (only used with default TextUI)
Config.InteractionText = {
    Press = "Press ~INPUT_CONTEXT~ to talk with", -- Text shown when near NPC (only used with default TextUI)
    Talking = "Talking with",                     -- Text shown when talking
}

-- Sound Settings
Config.Sounds = {
    Enabled = true,
    Volume = 0.5,
    TypeSpeed = 70,
}

-- Chat Settings
Config.Chat = {
    CoolDown = 1500,     -- Chat cooldown in ms
    ScrollSpeed = 1000,  -- Chat scroll animation speed
} 

Config.AutoCamPosition = true -- If true it'll set the camera position automatically

Config.CameraAnimationTime = 1000 -- Camera animation time: 1000 = 1 second


Config.NPCinteraction = 'default' -- 'target' or 'default'

Config.TalkToNPC = {
	{
		npc = 'cs_bankman', 								
		name = 'Pacific Bank', 								
        textUI = 'Talk With Banker',
		dialog = 'Hey, how can I help you?',				
		coordinates = vector3(254.17, 222.8, 105.3), 		
		heading = 160.0,						
		options = {			
			{text = "I want to buy some of items from you", event = "ataTalkToNpc:buyItems", serverSide = false},										
			{text = "sell Items", event = "ataTalkToNpc:sellItems", serverSide = false},									
			{
                text = "Tell me about your banking services",
                event = "ataTalkToNpc:addChat",
                serverSide = false,
                args = {"text", "We offer various banking services. What would you like to know about?"},
                followUp = {
                    {
                        text = "Tell me about loans",
                        event = "ataTalkToNpc:addChat",
                        serverSide = false,
                        args = {"text", "We offer competitive interest rates starting from 5% APR..."},
						followUp = {
							{
								text = "Tell me more about interest rates",
								event = "ataTalkToNpc:addChat", 
								serverSide = false,
								args = {"text", "Our current loan interest rates range from 5-12% APR depending on your credit score and loan term. We offer both fixed and variable rate options to suit your needs."}
							},
						}
                    },
                    {
                        text = "Tell me about savings accounts",
                        event = "ataTalkToNpc:addChat",
                        serverSide = false,
                        args = {"text", "Our savings accounts offer up to 3% interest annually..."}
                    },
                    {
                        text = "I'd like to open an account",
                        event = "ataTalkToNpc:addChat",
                        serverSide = false,
                        args = {
                            title = "Banking Services",
                            message = "Would you like to proceed with opening a new account?",
                            options = "Open Account",
                            event = "ataTalkToNpc:addChat",
                            serverSide = false,
							args = {"text", "Our current loan interest rates range from 5-12% APR depending on your credit score and loan term. We offer both fixed and variable rate options to suit your needs."}
                        }
                    }
                }
            }
		},
		SellItem = { -- if you using ataTalkToNpc:sellItems you need to add items here
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
		},
        BuyItem = { -- if you using ataTalkToNpc:buyItems you need to add items here
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
		},

		jobs = {													-- Jobs that can interact with the NPC
			
		},
	},
	{
		npc = 'cs_bankman', 								
		name = 'Pacific Bank', 								
        textUI = 'Talk With Banker',
		dialog = 'Hey, how can I help you?',				
		coordinates = vector3(254.175827, 227.815384, 105.283569), 		
		heading = 20.0,							
		options = {			
			{text = "I want to buy some of items from you", event = "ataTalkToNpc:buyItems", serverSide = false},										
			{text = "sell Items", event = "ataTalkToNpc:sellItems", serverSide = false},									
			{
                text = "Tell me about your banking services",
                event = "ataTalkToNpc:addChat",
                serverSide = false,
                args = {"text", "We offer various banking services. What would you like to know about?"},
                followUp = {
                    {
                        text = "Tell me about loans",
                        event = "ataTalkToNpc:addChat",
                        serverSide = false,
                        args = {"text", "We offer competitive interest rates starting from 5% APR..."},
						followUp = {
							{
								text = "Tell me more about interest rates",
								event = "ataTalkToNpc:addChat", 
								serverSide = false,
								args = {"text", "Our current loan interest rates range from 5-12% APR depending on your credit score and loan term. We offer both fixed and variable rate options to suit your needs."}
							},
						}
                    },
                    {
                        text = "Tell me about savings accounts",
                        event = "ataTalkToNpc:addChat",
                        serverSide = false,
                        args = {"text", "Our savings accounts offer up to 3% interest annually..."}
                    },
                    {
                        text = "I'd like to open an account",
                        event = "ataTalkToNpc:addChat",
                        serverSide = false,
                        args = {
                            title = "Banking Services",
                            message = "Would you like to proceed with opening a new account?",
                            options = "Open Account",
                            event = "ataTalkToNpc:addChat",
                            serverSide = false,
							args = {"text", "Our current loan interest rates range from 5-12% APR depending on your credit score and loan term. We offer both fixed and variable rate options to suit your needs."}
                        }
                    }
                }
            }
		},
		SellItem = { -- if you using ataTalkToNpc:buyItems or ataTalkToNpc:sellItems you need to add items here
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
		},
        BuyItem = { -- if you using ataTalkToNpc:buyItems or ataTalkToNpc:sellItems you need to add items here
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
			{label = "Weapon Pistol", name = "weapon_pistol", price = 100},
		},

            jobs = {'police'},
	},

}
