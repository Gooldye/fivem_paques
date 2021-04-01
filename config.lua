Config = {}

-- ESX Config
Config.enableESX = true
Config.enableitemsESX = false
Config.enable_rewardmoney = true
Config.amount_rewardmoney = '5000'

-- Oeuf Config
Config.advanceCount = true
Config.coords = {
    {-75.219, -821.651, 326.175}, -- 1
    {-75.070, -816.703, 326.175}, -- 2
    {-77.634, -818.688, 326.175}, -- 3
    {-72.643, -818.987, 326.175}  -- 4
}
Config.models = {
    "prop_alien_egg_01",          -- 1
    "prop_alien_egg_01",          -- 2
    "prop_alien_egg_01",          -- 3
    "prop_alien_egg_01"           -- 4
}

-- Traduction Config
Config.locale = "fr"
Config.texts = {
    ["fr"] = {
        collected = "~b~Oeuf~s~ collecté",
        collected_all = "~g~Vous avez collecté tous les ~b~oeufs~s~ !",
        reward = "Vous avez terminé l'événement de ~f~Pâques~s~~n~Vous avez reçu "..Config.amount_rewardmoney.."~g~$"
    }
}