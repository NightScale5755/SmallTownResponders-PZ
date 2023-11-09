-- by albion#0123
-- Thanks again, Albion!

local Overrides = require 'overrides/overrides'
local ItemOverrides = {}

ItemOverrides.itemSwaps = {
    ['Base.HolsterSimple'] = { -- item to replace
        Meade = 'Remove',
        RosewoodPrison = 'Remove',
        Rosewood = 'Remove',
        Riverside = 'Remove',
        Muldraugh = 'Remove',
        WestPoint = 'Remove',
        JeffersonSD = 'Remove',
        JeffersonPD = 'Remove',
        LouisvillePD = 'Remove',
        KSP = 'Remove',
        RavenCreek = 'Remove',
        RavenCreekPrison = 'Remove',
        Tandil = 'Remove',
        Greenport = 'Remove',
        Default = false, -- don't override if not in one of these zones
    },
    ['Base.Bag_DuffelBagTINT'] = { -- item to replace
        Meade = 'Remove',
        RosewoodPrison = 'Remove',
        Rosewood = 'Remove',
        Riverside = 'Remove',
        Muldraugh = 'Remove',
        WestPoint = 'Remove',
        JeffersonSD = 'Remove',
        JeffersonPD = 'Remove',
        LouisvillePD = 'Remove',
        Louisville = 'Remove',
        Jefferson = 'Remove',
        KSP = 'Remove',
        RavenCreek = 'Remove',
        RavenCreekPrison = 'Remove',
        Tandil = 'Remove',
        Greenport = 'Remove',
        Default = false, -- don't override if not in one of these zones
    },
    ['Base.Vest_BulletPolice'] = { -- item to replace
        Rosewood = 'STR.Vest_BulletPolice_Meade', -- zone = replacement item
        JeffersonSD = 'STR.Vest_BulletPolice_Meade',
        Meade = 'STR.Vest_BulletPolice_Meade',
        Default = false, -- don't override if not in one of these zones
    },
    ['Base.Boilersuit_Prisoner'] = { -- item to replace
        RosewoodPrison = {'STR.Boilersuit_MeadeGenPopPrisoner','STR.Boilersuit_MeadeLowRiskPrisoner','STR.Boilersuit_MeadeMaxPrisoner'},
        Louisville = {'STR.Boilersuit_JeffersonPrisoner'}, -- zone = replacement item
        Jefferson = {'STR.Boilersuit_JeffersonPrisoner'},
        RavenCreek = {'STR.Boilersuit_RavenCreekPrisoner'},
        Default = false, -- don't override if not in one of these zones
    },
    ['Base.Shirt_PrisonGuard'] = { -- item to replace
        Louisville = 'Remove', -- zone = replacement item
        Jefferson = 'Remove',
        Meade = {'STR.Shirt_DOC_Meade'},
        Default = false, -- don't override if not in one of these zones
    },
    ['Base.Trousers_PrisonGuard'] = { -- item to replace
        Louisville = 'Remove', -- zone = replacement item
        Jefferson = 'Remove',
        Meade = {'STR.Trousers_DOC_Meade'},
        Default = false, -- don't override if not in one of these zones
    },
    ['Base.Tshirt_PoliceGrey'] = { -- item to replace
        Meade = {'STR.TShirt_Police_Meade'},
        RosewoodPrison = {'STR.TShirt_DOC_Meade'},
        Rosewood = {'STR.TShirt_Police_Rosewood'},
        Riverside = {'STR.TShirt_Police_Riverside'},
        Muldraugh = {'STR.TShirt_Police_Muldraugh'},
        WestPoint = {'STR.TShirt_Police_WestPoint'},
        JeffersonSD = {'STR.TShirt_Police_JeffersonSD'},
        JeffersonPD = {'STR.TShirt_Police_JeffersonPD'},
        LouisvillePD = {'STR.TShirt_Police_Louisville'},
        KSP = {'STR.TShirt_PoliceKSP'},
        RavenCreek = {'STR.TShirt_Police_RavenCreek'},
        RavenCreekPrison = {'STR.TShirt_DOC_RavenCreek'},
        Tandil = {'STR.TShirt_Police_Tandil'},
        Greenport = {'STR.TShirt_Police_Greenport'},
        Default = false, -- don't override if not in one of these zones
    },
    ['Base.Tshirt_PoliceBlue'] = { -- item to replace
        Meade = {'STR.TShirt_Police_Meade'},
        RosewoodPrison = {'STR.TShirt_DOC_Meade'},
        Rosewood = {'STR.TShirt_Police_Rosewood'},
        Riverside = {'STR.TShirt_Police_Riverside'},
        Muldraugh = {'STR.TShirt_Police_Muldraugh'},
        WestPoint = {'STR.TShirt_Police_WestPoint'},
        JeffersonSD = {'STR.TShirt_Police_JeffersonSD'},
        JeffersonPD = {'STR.TShirt_Police_JeffersonPD'},
        LouisvillePD = {'STR.TShirt_Police_Louisville'},
        KSP = {'STR.TShirt_PoliceKSP'},
        RavenCreek = {'STR.TShirt_Police_RavenCreek'},
        RavenCreekPrison = {'STR.TShirt_DOC_RavenCreek'},
        Tandil = {'STR.TShirt_Police_Tandil'},
        Greenport = {'STR.TShirt_Police_Greenport'},
        Default = false, -- don't override if not in one of these zones
    },
    ['Base.Shirt_PoliceGrey'] = { -- item to replace
        Meade = {'STR.Shirt_Police_Meade'},
        RosewoodPrison = {'STR.Shirt_DOC_Meade'},
        Rosewood = {'STR.Shirt_Police_Rosewood'},
        Riverside = {'STR.Shirt_Police_Riverside'},
        Muldraugh = {'STR.Shirt_Police_Muldraugh'},
        WestPoint = {'STR.Shirt_Police_WestPoint'},
        JeffersonSD = {'STR.Shirt_Police_JeffersonSD'},
        JeffersonPD = {'STR.Shirt_Police_JeffersonPD'},
        LouisvillePD = {'STR.Shirt_Police_Louisville'},
        KSP = {'STR.Shirt_PoliceKSP'},
        RavenCreek = {'STR.Shirt_Police_RavenCreek'},
        RavenCreekPrison = {'STR.Shirt_DOC_RavenCreek'},
        Tandil = {'STR.Shirt_Police_Tandil'},
        Greenport = {'STR.Shirt_Police_Greenport'},
        Default = false, -- don't override if not in one of these zones
    },
    ['Base.Shirt_PoliceBlue'] = { -- item to replace
        Meade = {'STR.Shirt_Police_Meade'},
        RosewoodPrison = {'STR.Shirt_DOC_Meade'},
        Rosewood = {'STR.Shirt_Police_Rosewood'},
        Riverside = {'STR.Shirt_Police_Riverside'},
        Muldraugh = {'STR.Shirt_Police_Muldraugh'},
        WestPoint = {'STR.Shirt_Police_WestPoint'},
        JeffersonSD = {'STR.Shirt_Police_JeffersonSD'},
        JeffersonPD = {'STR.Shirt_Police_JeffersonPD'},
        LouisvillePD = {'STR.Shirt_Police_Louisville'},
        KSP = {'STR.Shirt_PoliceKSP'},
        RavenCreek = {'STR.Shirt_Police_RavenCreek'},
        RavenCreekPrison = {'STR.Shirt_DOC_RavenCreek'},
        Tandil = {'STR.Shirt_Police_Tandil'},
        Greenport = {'STR.Shirt_Police_Greenport'},
        Default = false, -- don't override if not in one of these zones
    },
    ['Base.Shirt_OfficerWhite'] = { -- item to replace
        Meade = {'STR.Shirt_Police_Meade'},
        RosewoodPrison = {'STR.Shirt_DOC_Meade'},
        Rosewood = {'STR.Shirt_Police_Rosewood'},
        Riverside = {'STR.Shirt_Police_Riverside'},
        Muldraugh = {'STR.Shirt_Police_Muldraugh'},
        WestPoint = {'STR.Shirt_Police_WestPoint'},
        JeffersonSD = {'STR.Shirt_Police_JeffersonSD'},
        JeffersonPD = {'STR.Shirt_Police_JeffersonPD'},
        LouisvillePD = {'STR.Shirt_Police_Louisville'},
        KSP = {'STR.Shirt_PoliceKSP'},
        RavenCreek = {'STR.Shirt_Police_RavenCreek'},
        RavenCreekPrison = {'STR.Shirt_DOC_RavenCreek'},
        Tandil = {'STR.Shirt_Police_Tandil'},
        Greenport = {'STR.Shirt_Police_Greenport'},
        Default = false, -- don't override if not in one of these zones
    },
    ['Base.Trousers_PoliceGrey'] = { -- item to replace
        Meade = {'STR.Trousers_Police_Meade'},
        RosewoodPrison = {'STR.Trousers_DOC_Meade'},
        Rosewood = {'STR.Trousers_Police_Rosewood'},
        Riverside = {'STR.Trousers_Police_Riverside'},
        Muldraugh = {'STR.Trousers_Police_Muldraugh'},
        WestPoint = {'STR.Trousers_Police_WestPoint'},
        JeffersonSD = {'STR.Trousers_Police_JeffersonSD'},
        JeffersonPD = {'STR.Trousers_Police_JeffersonPD'},
        LouisvillePD = {'STR.Trousers_Police_Louisville'},
        KSP = {'STR.Trousers_PoliceKSP'},
        RavenCreek = {'STR.Trousers_Police_RavenCreek'},
        RavenCreekPrison = {'STR.Trousers_DOC_RavenCreek'},
        Tandil = {'STR.Trousers_Police_Tandil'},
        Greenport = {'STR.Trousers_Police_Greenport'},
        Default = false, -- don't override if not in one of these zones
    },
    ['Base.Trousers_Police'] = { -- item to replace
        Meade = {'STR.Trousers_Police_Meade'},
        RosewoodPrison = {'STR.Trousers_DOC_Meade'},
        Rosewood = {'STR.Trousers_Police_Rosewood'},
        Riverside = {'STR.Trousers_Police_Riverside'},
        Muldraugh = {'STR.Trousers_Police_Muldraugh'},
        WestPoint = {'STR.Trousers_Police_WestPoint'},
        JeffersonSD = {'STR.Trousers_Police_JeffersonSD'},
        JeffersonPD = {'STR.Trousers_Police_JeffersonPD'},
        LouisvillePD = {'STR.Trousers_Police_Louisville'},
        KSP = {'STR.Trousers_PoliceKSP_Summer','STR.Trousers_PoliceKSP_Winter'},
        RavenCreek = {'STR.Trousers_Police_RavenCreek'},
        RavenCreekPrison = {'STR.Trousers_DOC_RavenCreek'},
        Tandil = {'STR.Trousers_Police_Tandil'},
        Greenport = {'STR.Trousers_Police_Greenport'},
        Default = false, -- don't override if not in one of these zones
    },
    ['Base.Jacket_Police'] = { -- item to replace
        Meade = {'STR.Jacket_Police_Meade'},
        RosewoodPrison = {'STR.Jacket_DOC_Meade'},
        Rosewood = {'STR.Jacket_Police_Rosewood'},
        Riverside = {'STR.Jacket_Police_Riverside'},
        Muldraugh = {'STR.Jacket_Police_Muldraugh'},
        WestPoint = {'STR.Jacket_Police_WestPoint'},
        JeffersonSD = {'STR.Jacket_Police_JeffersonSD'},
        JeffersonPD = {'STR.Jacket_Police_JeffersonPD'},
        LouisvillePD = {'STR.Jacket_Police_LouisvillePD'},
        KSP = {'STR.Jacket_PoliceKSP'},
        RavenCreek = {'STR.Jacket_Police_RavenCreek'},
        Tandil = {'STR.Jacket_Police_Tandil'},
        Greenport = {'STR.Jacket_Police_Greenport'},
        Default = false, -- don't override if not in one of these zones
    },
    ['Base.Hat_Police'] = { -- item to replace
        Meade = {'STR.Hat_Police_Meade'},
        RosewoodPrison = {'STR.Jacket_DOC_Meade'},
        Rosewood = {'STR.Hat_Police_Rosewood'},
        Riverside = {'STR.Hat_Police_Riverside'},
        Muldraugh = {'STR.Hat_Police_Muldraugh'},
        WestPoint = {'STR.Hat_Police_WestPoint'},
        JeffersonSD = {'STR.Hat_Police_JeffersonSD'},
        JeffersonPD = {'STR.Hat_Police_JeffersonPD'},
        LouisvillePD = {'STR.Hat_Police_Louisville'},
        KSP = {'STR.Hat_PoliceKSP'},
        RavenCreek = {'STR.Hat_Police_RavenCreek'},
        Tandil = {'STR.Hat_Police_Tandil'},
        Greenport = {'STR.Hat_Police_Greenport'},
        Default = false, -- don't override if not in one of these zones
    },
    ['Base.Hat_Police_Grey'] = { -- item to replace
        Meade = {'STR.Hat_Police_Meade'},
        RosewoodPrison = {'STR.Jacket_DOC_Meade'},
        Rosewood = {'STR.Hat_Police_Rosewood'},
        Riverside = {'STR.Hat_Police_Riverside'},
        Muldraugh = {'STR.Hat_Police_Muldraugh'},
        WestPoint = {'STR.Hat_Police_WestPoint'},
        JeffersonSD = {'STR.Hat_Police_JeffersonSD'},
        JeffersonPD = {'STR.Hat_Police_JeffersonPD'},
        LouisvillePD = {'STR.Hat_Police_Louisville'},
        KSP = {'STR.Hat_PoliceKSP'},
        RavenCreek = {'STR.Hat_Police_RavenCreek'},
        Tandil = {'STR.Hat_Police_Tandil'},
        Greenport = {'STR.Hat_Police_Greenport'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Bag_DuffelBag_Police_Meade'] = { -- item to replace
        Meade = {'STR.Bag_DuffelBag_Police_Meade'},
        Rosewood = {'STR.Bag_DuffelBag_Police_Rosewood'},
        RosewoodPrison = 'Remove',
        Riverside = {'STR.Bag_DuffelBag_Police_Black','STR.Bag_DuffelBag_Police_Navy','STR.Bag_DuffelBag_Police_Olive'},
        Muldraugh = {'STR.Bag_DuffelBag_Police_Black','STR.Bag_DuffelBag_Police_Navy','STR.Bag_DuffelBag_Police_Olive'},
        WestPoint = {'STR.Bag_DuffelBag_Police_Black','STR.Bag_DuffelBag_Police_Navy','STR.Bag_DuffelBag_Police_Olive'},
        JeffersonSD = {'STR.Bag_DuffelBag_Police_Black','STR.Bag_DuffelBag_Police_Navy','STR.Bag_DuffelBag_Police_Olive'},
        JeffersonPD = {'STR.Bag_DuffelBag_Police_Black','STR.Bag_DuffelBag_Police_Navy','STR.Bag_DuffelBag_Police_Olive'},
        LouisvillePD = {'STR.Bag_DuffelBag_Police_Black','STR.Bag_DuffelBag_Police_Navy','STR.Bag_DuffelBag_Police_Olive'},
        KSP = {'STR.Bag_DuffelBag_Police_KSP'},
        RavenCreek = {'STR.Bag_DuffelBag_Police_Black','STR.Bag_DuffelBag_Police_Navy','STR.Bag_DuffelBag_Police_Olive'},
        RavenCreekPrison = 'Remove',
        Tandil = {'STR.Bag_DuffelBag_Police_Black','STR.Bag_DuffelBag_Police_Navy','STR.Bag_DuffelBag_Police_Olive'},
        Greenport = {'STR.Bag_DuffelBag_Police_Black','STR.Bag_DuffelBag_Police_Navy','STR.Bag_DuffelBag_Police_Olive'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Chest_Walkie'] = { -- item to replace
        Meade = {'STR.Chest_Walkie'},
        Rosewood = {'STR.Chest_Walkie'},
        RosewoodPrison = 'Remove',
        Riverside = {'STR.Chest_Walkie'},
        Muldraugh = {'STR.Chest_Walkie'},
        WestPoint = {'STR.Chest_Walkie'},
        JeffersonSD = {'STR.Chest_Walkie'},
        JeffersonPD = {'STR.Chest_Walkie'},
        LouisvillePD = {'STR.Chest_Walkie'},
        KSP = {'STR.Chest_Walkie'},
        RavenCreek = {'STR.Chest_Walkie'},
        RavenCreekPrison = 'Remove',
        Tandil = {'STR.Chest_Walkie'},
        Greenport = {'STR.Chest_Walkie'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Gloves_Dress_White'] = { -- item to replace
        Meade = {'STR.Gloves_Dress_White'},
        Rosewood = {'STR.Gloves_Dress_White'},
        RosewoodPrison = 'Remove',
        Riverside = {'STR.Gloves_Dress_White'},
        Muldraugh = {'STR.Gloves_Dress_White'},
        WestPoint = {'STR.Gloves_Dress_White'},
        JeffersonSD = {'STR.Gloves_Dress_White'},
        JeffersonPD = {'STR.Gloves_Dress_White'},
        LouisvillePD = {'STR.Gloves_Dress_White'},
        KSP = {'STR.Gloves_Dress_White'},
        RavenCreek = {'STR.Gloves_Dress_White'},
        RavenCreekPrison = 'Remove',
        Tandil = {'STR.Gloves_Dress_White'},
        Greenport = {'STR.Gloves_Dress_White'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Police_Tandil_Dress'] = { -- item to replace
        Meade = 'Remove',
        Rosewood = 'Remove',
        RosewoodPrison = 'Remove',
        Riverside = 'Remove',
        Muldraugh = 'Remove',
        WestPoint = 'Remove',
        JeffersonSD = 'Remove',
        JeffersonPD = 'Remove',
        LouisvillePD = 'Remove',
        KSP = 'Remove',
        RavenCreek = 'Remove',
        RavenCreekPrison = 'Remove',
        Tandil = {'STR.Hat_Police_Tandil_Dress'},
        Greenport = 'Remove',
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Riot_Helmet_Meade'] = { -- item to replace
        Meade = {'STR.Hat_Riot_Helmet_Meade','STR.Hat_Riot_Helmet_Brown','STR.Hat_Riot_Helmet_Brown_Stripe'},
        Rosewood = {'STR.Hat_Riot_Helmet_Brown_Dark'},
        RosewoodPrison = 'Remove',
        Riverside = {'STR.Hat_Riot_Helmet_Blue','STR.Hat_Riot_Helmet_Blue_Stripe'},
        Muldraugh = {'STR.Hat_Riot_Helmet_Black'},
        WestPoint = {'STR.Hat_Riot_Helmet_Navy'},
        JeffersonSD = {'STR.Hat_Riot_Helmet_Brown_Dark_Stripe'},
        JeffersonPD = {'STR.Hat_Riot_Helmet_Navy_Stripe'},
        LouisvillePD = {'STR.Hat_Riot_Helmet_Louisville'},
        KSP = {'STR.Hat_Riot_Helmet_Grey'},
        RavenCreek = {'STR.Hat_Riot_Helmet_RavenCreek'},
        RavenCreekPrison = 'Remove',
        Tandil = {'STR.Hat_Riot_Helmet_Tandil'},
        Greenport = {'STR.Hat_Riot_Helmet_Blue_Stripe'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Riot_Helmet_Brown'] = { -- item to replace
        Meade = {'STR.Hat_Riot_Helmet_Meade', 'STR.Hat_Riot_Helmet_Brown', 'STR.Hat_Riot_Helmet_Brown_Stripe'},
        Rosewood = {'STR.Hat_Riot_Helmet_Brown_Dark'},
        RosewoodPrison = 'Remove',
        Riverside = {'STR.Hat_Riot_Helmet_Blue', 'STR.Hat_Riot_Helmet_Blue_Stripe'},
        Muldraugh = {'STR.Hat_Riot_Helmet_Black'},
        WestPoint = {'STR.Hat_Riot_Helmet_Navy'},
        JeffersonSD = {'STR.Hat_Riot_Helmet_Brown_Dark_Stripe'},
        JeffersonPD = {'STR.Hat_Riot_Helmet_Navy_Stripe'},
        LouisvillePD = {'STR.Hat_Riot_Helmet_Louisville'},
        KSP = {'STR.Hat_Riot_Helmet_Grey'},
        RavenCreek = {'STR.Hat_Riot_Helmet_RavenCreek'},
        RavenCreekPrison = 'Remove',
        Tandil = {'STR.Hat_Riot_Helmet_Tandil'},
        Greenport = {'STR.Hat_Riot_Helmet_Blue_Stripe'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Riot_Helmet_Brown_Stripe'] = { -- item to replace
        Meade = {'STR.Hat_Riot_Helmet_Meade','STR.Hat_Riot_Helmet_Brown','STR.Hat_Riot_Helmet_Brown_Stripe'},
        Rosewood = {'STR.Hat_Riot_Helmet_Brown_Dark'},
        RosewoodPrison = 'Remove',
        Riverside = {'STR.Hat_Riot_Helmet_Blue','STR.Hat_Riot_Helmet_Blue_Stripe'},
        Muldraugh = {'STR.Hat_Riot_Helmet_Black'},
        WestPoint = {'STR.Hat_Riot_Helmet_Navy'},
        JeffersonSD = {'STR.Hat_Riot_Helmet_Brown_Dark_Stripe'},
        JeffersonPD = {'STR.Hat_Riot_Helmet_Navy_Stripe'},
        LouisvillePD = {'STR.Hat_Riot_Helmet_Louisville'},
        KSP = {'STR.Hat_Riot_Helmet_Grey'},
        RavenCreek = {'STR.Hat_Riot_Helmet_RavenCreek'},
        RavenCreekPrison = 'Remove',
        Tandil = {'STR.Hat_Riot_Helmet_Tandil'},
        Greenport = {'STR.Hat_Riot_Helmet_Blue_Stripe'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Jacket_Dress_Police_Meade'] = { -- item to replace
        Meade = {'STR.Jacket_Dress_Police_Meade'},
        Rosewood = {'STR.Jacket_Dress_Police_Rosewood'},
        RosewoodPrison = 'Remove',
        Riverside = {'STR.Jacket_Dress_Police_Riverside'},
        Muldraugh = {'STR.Jacket_Dress_Police_Muldraugh'},
        WestPoint = {'STR.Jacket_Dress_Police_WestPoint'},
        JeffersonSD = {'STR.Jacket_Dress_Sheriff_Jefferson'},
        JeffersonPD = {'STR.Jacket_Dress_Police_Jefferson'},
        LouisvillePD = {'STR.Jacket_Dress_Police_Louisville'},
        KSP = {'STR.Jacket_Dress_Police_KSP'},
        RavenCreek = {'STR.Jacket_Dress_Police_RavenCreek'},
        RavenCreekPrison = 'Remove',
        Tandil = {'STR.Jacket_Dress_Police_Tandil'},
        Greenport = {'STR.Jacket_Dress_Police_Greenport'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Tie_Full_Police_Meade'] = { -- item to replace
        Meade = {'STR.Tie_Full_Police_Meade'},
        Rosewood = {'STR.Tie_Full_Police_Rosewood'},
        Riverside = {'STR.Tie_Full_Police_Riverside'},
        Muldraugh = {'STR.Tie_Full_Police_Muldraugh'},
        WestPoint = {'STR.Tie_Full_Police_WestPoint'},
        JeffersonSD = {'STR.Tie_Full_Sheriff_Jefferson'},
        JeffersonPD = {'STR.Tie_Full_Police_Jefferson'},
        LouisvillePD = {'STR.Tie_Full_Police_Louisville'},
        KSP = {'STR.Tie_Full_KSP'},
        RavenCreek = {'STR.Tie_Full_Police_RavenCreek'},
        Tandil = {'STR.Tie_Full_Police_Tandil'},
        Greenport = {'STR.Tie_Full_Police_Greenport'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Tie_Worn_Police_Meade'] = { -- item to replace
        Meade = {'STR.Tie_Worn_Police_Meade'},
        Rosewood = {'STR.Tie_Worn_Police_Rosewood'},
        Riverside = {'STR.Tie_Worn_Police_Riverside'},
        Muldraugh = {'STR.Tie_Worn_Police_Muldraugh'},
        WestPoint = {'STR.Tie_Worn_Police_WestPoint'},
        JeffersonSD = {'STR.Tie_Worn_Sheriff_Jefferson'},
        JeffersonPD = {'STR.Tie_Worn_Police_Jefferson'},
        LouisvillePD = {'STR.Tie_Worn_Police_Louisville'},
        KSP = {'STR.Tie_Worn_KSP'},
        RavenCreek = {'STR.Tie_Worn_Police_RavenCreek'},
        Tandil = {'STR.Tie_Worn_Police_Tandil'},
        Greenport = {'STR.Tie_Worn_Police_Greenport'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_BaseballCap_EMS_Meade'] = { -- item to replace
        Louisville = {'STR.Hat_BaseballCap_EMS_Louisville'}, -- zone = replacement item
        Jefferson = {'STR.Hat_BaseballCap_EMS_Jefferson'},
        Meade = {'STR.Hat_BaseballCap_EMS_Meade'},
        RavenCreek = {'STR.Hat_BaseballCap_EMS_RavenCreek'},
        Tandil = {'STR.Hat_BaseballCap_EMS_Tandil'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_BaseballCap_EMS_Jefferson'] = { -- item to replace
        Louisville = {'STR.Hat_BaseballCap_EMS_Louisville'}, -- zone = replacement item
        Jefferson = {'STR.Hat_BaseballCap_EMS_Jefferson'},
        Meade = {'STR.Hat_BaseballCap_EMS_Meade'},
        RavenCreek = {'STR.Hat_BaseballCap_EMS_RavenCreek'},
        Tandil = {'STR.Hat_BaseballCap_EMS_Tandil'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_BaseballCap_EMS_Louisville'] = { -- item to replace
        Louisville = {'STR.Hat_BaseballCap_EMS_Louisville'}, -- zone = replacement item
        Jefferson = {'STR.Hat_BaseballCap_EMS_Jefferson'},
        Meade = {'STR.Hat_BaseballCap_EMS_Meade'},
        RavenCreek = {'STR.Hat_BaseballCap_EMS_RavenCreek'},
        Tandil = {'STR.Hat_BaseballCap_EMS_Tandil'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_BaseballCap_EMS_RavenCreek'] = { -- item to replace
        Louisville = {'STR.Hat_BaseballCap_EMS_Louisville'}, -- zone = replacement item
        Jefferson = {'STR.Hat_BaseballCap_EMS_Jefferson'},
        Meade = {'STR.Hat_BaseballCap_EMS_Meade'},
        RavenCreek = {'STR.Hat_BaseballCap_EMS_RavenCreek'},
        Tandil = {'STR.Hat_BaseballCap_EMS_Tandil'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_BaseballCap_EMS_Tandil'] = { -- item to replace
        Louisville = {'STR.Hat_BaseballCap_EMS_Louisville'}, -- zone = replacement item
        Jefferson = {'STR.Hat_BaseballCap_EMS_Jefferson'},
        Meade = {'STR.Hat_BaseballCap_EMS_Meade'},
        RavenCreek = {'STR.Hat_BaseballCap_EMS_RavenCreek'},
        Tandil = {'STR.Hat_BaseballCap_EMS_Tandil'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Jacket_EMS_Meade'] = { -- item to replace
        Louisville = {'STR.Jacket_EMS_Louisville'}, -- zone = replacement item
        Jefferson = {'STR.Jacket_EMS_Jefferson'},
        Meade = {'STR.Jacket_EMS_Meade'},
        RavenCreek = {'STR.Jacket_EMS_RavenCreek'},
        Tandil = {'STR.Jacket_EMS_Tandil'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Jacket_EMS_Jefferson'] = { -- item to replace
        Louisville = {'STR.Jacket_EMS_Louisville'}, -- zone = replacement item
        Jefferson = {'STR.Jacket_EMS_Jefferson'},
        Meade = {'STR.Jacket_EMS_Meade'},
        RavenCreek = {'STR.Jacket_EMS_RavenCreek'},
        Tandil = {'STR.Jacket_EMS_Tandil'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Jacket_EMS_Louisville'] = { -- item to replace
        Louisville = {'STR.Jacket_EMS_Louisville'}, -- zone = replacement item
        Jefferson = {'STR.Jacket_EMS_Jefferson'},
        Meade = {'STR.Jacket_EMS_Meade'},
        RavenCreek = {'STR.Jacket_EMS_RavenCreek'},
        Tandil = {'STR.Jacket_EMS_Tandil'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Jacket_EMS_RavenCreek'] = { -- item to replace
        Louisville = {'STR.Jacket_EMS_Louisville'}, -- zone = replacement item
        Jefferson = {'STR.Jacket_EMS_Jefferson'},
        Meade = {'STR.Jacket_EMS_Meade'},
        RavenCreek = {'STR.Jacket_EMS_RavenCreek'},
        Tandil = {'STR.Jacket_EMS_Tandil'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Jacket_EMS_Tandil'] = { -- item to replace
        Louisville = {'STR.Jacket_EMS_Louisville'}, -- zone = replacement item
        Jefferson = {'STR.Jacket_EMS_Jefferson'},
        Meade = {'STR.Jacket_EMS_Meade'},
        RavenCreek = {'STR.Jacket_EMS_RavenCreek'},
        Tandil = {'STR.Jacket_EMS_Tandil'},
        Default = false, -- don't override if not in one of these zones
    },
    ['Base.Hat_Fireman'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_Black','STR.Hat_Fireman_Louisville_Red','STR.Hat_Fireman_Louisville_Yellow','STR.Hat_Fireman_Louisville_White','STR.Hat_Fireman_Louisville_Blue'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_Black','STR.Hat_Fireman_Rosewood_Red','STR.Hat_Fireman_Rosewood_Yellow','STR.Hat_Fireman_Rosewood_White'},
        Meade = {'STR.Hat_Fireman_Meade_Black','STR.Hat_Fireman_Meade_Red','STR.Hat_Fireman_Meade_Yellow','STR.Hat_Fireman_Meade_White'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Black','STR.Hat_Fireman_RavenCreek_Red','STR.Hat_Fireman_RavenCreek_Yellow','STR.Hat_Fireman_RavenCreek_Blue'},
        Tandil = {'STR.Hat_Fireman_Tandil_Black','STR.Hat_Fireman_Tandil_Red','STR.Hat_Fireman_Tandil_Yellow','STR.Hat_Fireman_Tandil_Blue'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Fireman_Meade_Black'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_Black'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_Black'},
        Meade = {'STR.Hat_Fireman_Meade_Black'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Black'},
        Tandil = {'STR.Hat_Fireman_Tandil_Black'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Fireman_Meade_Red'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_Red'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_Red'},
        Meade = {'STR.Hat_Fireman_Meade_Red'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Red'},
        Tandil = {'STR.Hat_Fireman_Tandil_Red'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Fireman_Meade_Yellow'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_Yellow'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_Yellow'},
        Meade = {'STR.Hat_Fireman_Meade_Yellow'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Yellow'},
        Tandil = {'STR.Hat_Fireman_Tandil_Yellow'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Fireman_Meade_White'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_White'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_White'},
        Meade = {'STR.Hat_Fireman_Meade_White'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Black'},
        Tandil = {'STR.Hat_Fireman_Tandil_Black'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Fireman_Rosewood_Black'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_Black'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_Black'},
        Meade = {'STR.Hat_Fireman_Meade_Black'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Black'},
        Tandil = {'STR.Hat_Fireman_Tandil_Black'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Fireman_Rosewood_Red'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_Red'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_Red'},
        Meade = {'STR.Hat_Fireman_Meade_Red'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Red'},
        Tandil = {'STR.Hat_Fireman_Tandil_Red'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Fireman_Rosewood_Yellow'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_Yellow'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_Yellow'},
        Meade = {'STR.Hat_Fireman_Meade_Yellow'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Yellow'},
        Tandil = {'STR.Hat_Fireman_Tandil_Yellow'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Fireman_Rosewood_White'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_White'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_White'},
        Meade = {'STR.Hat_Fireman_Meade_White'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Black'},
        Tandil = {'STR.Hat_Fireman_Tandil_Black'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Fireman_Louisville_Black'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_Black'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_Black'},
        Meade = {'STR.Hat_Fireman_Meade_Black'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Black'},
        Tandil = {'STR.Hat_Fireman_Tandil_Black'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Fireman_Louisville_Red'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_Red'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_Red'},
        Meade = {'STR.Hat_Fireman_Meade_Red'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Red'},
        Tandil = {'STR.Hat_Fireman_Tandil_Red'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Fireman_Louisville_Yellow'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_Yellow'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_Yellow'},
        Meade = {'STR.Hat_Fireman_Meade_Yellow'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Yellow'},
        Tandil = {'STR.Hat_Fireman_Tandil_Yellow'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Fireman_Louisville_White'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_White'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_White'},
        Meade = {'STR.Hat_Fireman_Meade_White'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Black'},
        Tandil = {'STR.Hat_Fireman_Tandil_Black'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Fireman_RavenCreek_Black'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_Black'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_Black'},
        Meade = {'STR.Hat_Fireman_Meade_Black'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Black'},
        Tandil = {'STR.Hat_Fireman_Tandil_Black'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Fireman_RavenCreek_Red'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_Red'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_Red'},
        Meade = {'STR.Hat_Fireman_Meade_Red'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Red'},
        Tandil = {'STR.Hat_Fireman_Tandil_Red'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Fireman_RavenCreek_Yellow'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_Yellow'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_Yellow'},
        Meade = {'STR.Hat_Fireman_Meade_Yellow'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Yellow'},
        Tandil = {'STR.Hat_Fireman_Tandil_Yellow'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Fireman_RavenCreek_White'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_White'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_White'},
        Meade = {'STR.Hat_Fireman_Meade_White'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Black'},
        Tandil = {'STR.Hat_Fireman_Tandil_Black'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Fireman_Tandil_Black'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_Black'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_Black'},
        Meade = {'STR.Hat_Fireman_Meade_Black'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Black'},
        Tandil = {'STR.Hat_Fireman_Tandil_Black'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Fireman_Tandil_Red'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_Red'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_Red'},
        Meade = {'STR.Hat_Fireman_Meade_Red'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Red'},
        Tandil = {'STR.Hat_Fireman_Tandil_Red'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Fireman_Tandil_Yellow'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_Yellow'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_Yellow'},
        Meade = {'STR.Hat_Fireman_Meade_Yellow'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Yellow'},
        Tandil = {'STR.Hat_Fireman_Tandil_Yellow'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Hat_Fireman_Tandil_White'] = { -- item to replace
        Louisville = {'STR.Hat_Fireman_Louisville_White'}, -- zone = replacement item
        Rosewood = {'STR.Hat_Fireman_Rosewood_White'},
        Meade = {'STR.Hat_Fireman_Meade_White'},
        RavenCreek = {'STR.Hat_Fireman_RavenCreek_Black'},
        Tandil = {'STR.Hat_Fireman_Tandil_Black'},
        Default = false, -- don't override if not in one of these zones
    },
    ['Base.Jacket_Fireman'] = { -- item to replace
        Louisville = {'STR.Jacket_Fireman_Louisville_Black','STR.Jacket_Fireman_Louisville_Khaki'}, -- zone = replacement item
        Rosewood = {'STR.Jacket_Fireman_Rosewood_Black','STR.Jacket_Fireman_Rosewood_Khaki'},
        Meade = {'STR.Jacket_Fireman_Meade_Black','STR.Jacket_Fireman_Meade_Khaki'},
        RavenCreek = {'STR.Jacket_Fireman_RavenCreek_Black','STR.Jacket_Fireman_RavenCreek_Khaki'},
        Tandil = {'STR.Jacket_Fireman_Tandil_Black','STR.Jacket_Fireman_Tandil_Khaki'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Jacket_Fireman_Meade_Black'] = { -- item to replace
        Louisville = {'STR.Jacket_Fireman_Louisville_Black'}, -- zone = replacement item
        Rosewood = {'STR.Jacket_Fireman_Rosewood_Black'},
        Meade = {'STR.Jacket_Fireman_Meade_Black'},
        RavenCreek = {'STR.Jacket_Fireman_RavenCreek_Black'},
        Tandil = {'STR.Jacket_Fireman_Tandil_Black'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Jacket_Fireman_Meade_Khaki'] = { -- item to replace
        Louisville = {'STR.Jacket_Fireman_Louisville_Khaki'}, -- zone = replacement item
        Rosewood = {'STR.Jacket_Fireman_Rosewood_Khaki'},
        Meade = {'STR.Jacket_Fireman_Meade_Khaki'},
        RavenCreek = {'STR.Jacket_Fireman_RavenCreek_Khaki'},
        Tandil = {'STR.Jacket_Fireman_Tandil_Khaki'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Jacket_Fireman_Rosewood_Black'] = { -- item to replace
        Louisville = {'STR.Jacket_Fireman_Louisville_Black'}, -- zone = replacement item
        Rosewood = {'STR.Jacket_Fireman_Rosewood_Black'},
        Meade = {'STR.Jacket_Fireman_Meade_Black'},
        RavenCreek = {'STR.Jacket_Fireman_RavenCreek_Black'},
        Tandil = {'STR.Jacket_Fireman_Tandil_Black'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Jacket_Fireman_Rosewood_Khaki'] = { -- item to replace
        Louisville = {'STR.Jacket_Fireman_Louisville_Khaki'}, -- zone = replacement item
        Rosewood = {'STR.Jacket_Fireman_Rosewood_Khaki'},
        Meade = {'STR.Jacket_Fireman_Meade_Khaki'},
        RavenCreek = {'STR.Jacket_Fireman_RavenCreek_Khaki'},
        Tandil = {'STR.Jacket_Fireman_Tandil_Khaki'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Jacket_Fireman_Louisville_Black'] = { -- item to replace
        Louisville = {'STR.Jacket_Fireman_Louisville_Black'}, -- zone = replacement item
        Rosewood = {'STR.Jacket_Fireman_Rosewood_Black'},
        Meade = {'STR.Jacket_Fireman_Meade_Black'},
        RavenCreek = {'STR.Jacket_Fireman_RavenCreek_Black'},
        Tandil = {'STR.Jacket_Fireman_Tandil_Black'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Jacket_Fireman_Louisville_Khaki'] = { -- item to replace
        Louisville = {'STR.Jacket_Fireman_Louisville_Khaki'}, -- zone = replacement item
        Rosewood = {'STR.Jacket_Fireman_Rosewood_Khaki'},
        Meade = {'STR.Jacket_Fireman_Meade_Khaki'},
        RavenCreek = {'STR.Jacket_Fireman_RavenCreek_Khaki'},
        Tandil = {'STR.Jacket_Fireman_Tandil_Khaki'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Jacket_Fireman_RavenCreek_Black'] = { -- item to replace
        Louisville = {'STR.Jacket_Fireman_Louisville_Black'}, -- zone = replacement item
        Rosewood = {'STR.Jacket_Fireman_Rosewood_Black'},
        Meade = {'STR.Jacket_Fireman_Meade_Black'},
        RavenCreek = {'STR.Jacket_Fireman_RavenCreek_Black'},
        Tandil = {'STR.Jacket_Fireman_Tandil_Black'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Jacket_Fireman_RavenCreek_Khaki'] = { -- item to replace
        Louisville = {'STR.Jacket_Fireman_Louisville_Khaki'}, -- zone = replacement item
        Rosewood = {'STR.Jacket_Fireman_Rosewood_Khaki'},
        Meade = {'STR.Jacket_Fireman_Meade_Khaki'},
        RavenCreek = {'STR.Jacket_Fireman_RavenCreek_Khaki'},
        Tandil = {'STR.Jacket_Fireman_Tandil_Khaki'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Jacket_Fireman_Tandil_Black'] = { -- item to replace
        Louisville = {'STR.Jacket_Fireman_Louisville_Black'}, -- zone = replacement item
        Rosewood = {'STR.Jacket_Fireman_Rosewood_Black'},
        Meade = {'STR.Jacket_Fireman_Meade_Black'},
        RavenCreek = {'STR.Jacket_Fireman_RavenCreek_Black'},
        Tandil = {'STR.Jacket_Fireman_Tandil_Black'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Jacket_Fireman_Tandil_Khaki'] = { -- item to replace
        Louisville = {'STR.Jacket_Fireman_Louisville_Khaki'}, -- zone = replacement item
        Rosewood = {'STR.Jacket_Fireman_Rosewood_Khaki'},
        Meade = {'STR.Jacket_Fireman_Meade_Khaki'},
        RavenCreek = {'STR.Jacket_Fireman_RavenCreek_Khaki'},
        Tandil = {'STR.Jacket_Fireman_Tandil_Khaki'},
        Default = false, -- don't override if not in one of these zones
    },
    ['Base.Trousers_Fireman'] = { -- item to replace
        Louisville = {'STR.Trousers_Fireman_Louisville_Black','STR.Trousers_Fireman_Louisville_Khaki'}, -- zone = replacement item
        Rosewood = {'STR.Trousers_Fireman_Rosewood_Black','STR.Trousers_Fireman_Rosewood_Khaki'},
        Meade = {'STR.Trousers_Fireman_Meade_Black','STR.Trousers_Fireman_Meade_Khaki'},
        RavenCreek = {'STR.Trousers_Fireman_RavenCreek_Black','STR.Trousers_Fireman_RavenCreek_Khaki'},
        Tandil = {'STR.Trousers_Fireman_Tandil_Black','STR.Trousers_Fireman_Tandil_Khaki'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Trousers_Fireman_Meade_Black'] = { -- item to replace
        Louisville = {'STR.Trousers_Fireman_Louisville_Black'}, -- zone = replacement item
        Rosewood = {'STR.Trousers_Fireman_Rosewood_Black'},
        Meade = {'STR.Trousers_Fireman_Meade_Black'},
        RavenCreek = {'STR.Trousers_Fireman_RavenCreek_Black'},
        Tandil = {'STR.Trousers_Fireman_Tandil_Black'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Trousers_Fireman_Meade_Khaki'] = { -- item to replace
        Louisville = {'STR.Trousers_Fireman_Louisville_Khaki'}, -- zone = replacement item
        Rosewood = {'STR.Trousers_Fireman_Rosewood_Khaki'},
        Meade = {'STR.Trousers_Fireman_Meade_Khaki'},
        RavenCreek = {'STR.Trousers_Fireman_RavenCreek_Khaki'},
        Tandil = {'STR.Trousers_Fireman_Tandil_Khaki'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Trousers_Fireman_Rosewood_Black'] = { -- item to replace
        Louisville = {'STR.Trousers_Fireman_Louisville_Black'}, -- zone = replacement item
        Rosewood = {'STR.Trousers_Fireman_Rosewood_Black'},
        Meade = {'STR.Trousers_Fireman_Meade_Black'},
        RavenCreek = {'STR.Trousers_Fireman_RavenCreek_Black'},
        Tandil = {'STR.Trousers_Fireman_Tandil_Black'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Trousers_Fireman_Rosewood_Khaki'] = { -- item to replace
        Louisville = {'STR.Trousers_Fireman_Louisville_Khaki'}, -- zone = replacement item
        Rosewood = {'STR.Trousers_Fireman_Rosewood_Khaki'},
        Meade = {'STR.Trousers_Fireman_Meade_Khaki'},
        RavenCreek = {'STR.Trousers_Fireman_RavenCreek_Khaki'},
        Tandil = {'STR.Trousers_Fireman_Tandil_Khaki'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Trousers_Fireman_Louisville_Black'] = { -- item to replace
        Louisville = {'STR.Trousers_Fireman_Louisville_Black'}, -- zone = replacement item
        Rosewood = {'STR.Trousers_Fireman_Rosewood_Black'},
        Meade = {'STR.Trousers_Fireman_Meade_Black'},
        RavenCreek = {'STR.Trousers_Fireman_RavenCreek_Black'},
        Tandil = {'STR.Trousers_Fireman_Tandil_Black'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Trousers_Fireman_Louisville_Khaki'] = { -- item to replace
        Louisville = {'STR.Trousers_Fireman_Louisville_Khaki'}, -- zone = replacement item
        Rosewood = {'STR.Trousers_Fireman_Rosewood_Khaki'},
        Meade = {'STR.Trousers_Fireman_Meade_Khaki'},
        RavenCreek = {'STR.Trousers_Fireman_RavenCreek_Khaki'},
        Tandil = {'STR.Trousers_Fireman_Tandil_Khaki'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Trousers_Fireman_RavenCreek_Black'] = { -- item to replace
        Louisville = {'STR.Trousers_Fireman_Louisville_Black'}, -- zone = replacement item
        Rosewood = {'STR.Trousers_Fireman_Rosewood_Black'},
        Meade = {'STR.Trousers_Fireman_Meade_Black'},
        RavenCreek = {'STR.Trousers_Fireman_RavenCreek_Black'},
        Tandil = {'STR.Trousers_Fireman_Tandil_Black'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Trousers_Fireman_RavenCreek_Khaki'] = { -- item to replace
        Louisville = {'STR.Trousers_Fireman_Louisville_Khaki'}, -- zone = replacement item
        Rosewood = {'STR.Trousers_Fireman_Rosewood_Khaki'},
        Meade = {'STR.Trousers_Fireman_Meade_Khaki'},
        RavenCreek = {'STR.Trousers_Fireman_RavenCreek_Khaki'},
        Tandil = {'STR.Trousers_Fireman_Tandil_Khaki'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Trousers_Fireman_Tandil_Black'] = { -- item to replace
        Louisville = {'STR.Trousers_Fireman_Louisville_Black'}, -- zone = replacement item
        Rosewood = {'STR.Trousers_Fireman_Rosewood_Black'},
        Meade = {'STR.Trousers_Fireman_Meade_Black'},
        RavenCreek = {'STR.Trousers_Fireman_RavenCreek_Black'},
        Tandil = {'STR.Trousers_Fireman_Tandil_Black'},
        Default = false, -- don't override if not in one of these zones
    },
    ['STR.Trousers_Fireman_Tandil_Khaki'] = { -- item to replace
        Louisville = {'STR.Trousers_Fireman_Louisville_Khaki'}, -- zone = replacement item
        Rosewood = {'STR.Trousers_Fireman_Rosewood_Khaki'},
        Meade = {'STR.Trousers_Fireman_Meade_Khaki'},
        RavenCreek = {'STR.Trousers_Fireman_RavenCreek_Khaki'},
        Tandil = {'STR.Trousers_Fireman_Tandil_Khaki'},
        Default = false, -- don't override if not in one of these zones
    },
}

ItemOverrides.overrideContainers = {
    all = { -- room name
        TruckBed = true, -- container type = true
        TruckBedOpen = true,
    },
    firestorage = { -- room name
        metal_shelves = true, -- container type = true
    },
    policestorage = { -- room name
        locker = 'loot', -- container type = true
    },
    locker = { -- room name
        locker = 'loot', -- container type = true
    },
    lockerroom = { -- room name
        locker = 'loot', -- container type = true
    },
    garage = { -- room name
        locker = 'loot', -- container type = true
    },
    garagestorage = { -- room name
        locker = 'loot', -- container type = true
    },
    prisoncells = { -- room name
        wardrobe = 'loot', -- container type = true
    },
    laundry = { -- room name
        clothingdryer = true, -- container type = true
        clothingdryerbasic = true, -- container type = true
        clothingwasher = true, -- container type = true
    },
    -- all is checked last, so you can override it like below
    CarLightsPolice = {
        TruckBed = 'police', -- use police zones instead of normal zones
        TruckBedOpen = 'police',
    },
    PickUpVanLightsFire = {
        TruckBed = true,
        TruckBedOpen = true,
    },
    VanAmbulance = {
        TruckBed = true,
        TruckBedOpen = true,
    },
}

local CarLightsPolice = ItemOverrides.overrideContainers.CarLightsPolice

ItemOverrides.overrideContainers.PickUpVanLightsPolice = CarLightsPolice -- reuse to save memory and less ugly code
ItemOverrides.overrideContainers['85vicsheriff'] = CarLightsPolice
ItemOverrides.overrideContainers['92crownvicPD'] = CarLightsPolice
ItemOverrides.overrideContainers['87capricePD'] = CarLightsPolice
ItemOverrides.overrideContainers['91blazerpd'] = CarLightsPolice

local PickUpVanLightsFire = ItemOverrides.overrideContainers.PickUpVanLightsFire

ItemOverrides.overrideContainers.PickUpTruckLightsFire = PickUpVanLightsFire -- reuse to save memory and less ugly code
ItemOverrides.overrideContainers['firepumper'] = PickUpVanLightsFire
ItemOverrides.overrideContainers['87c10fire'] = PickUpVanLightsFire

local VanAmbulance = ItemOverrides.overrideContainers.VanAmbulance

ItemOverrides.overrideContainers['80f350ambulance'] = VanAmbulance
ItemOverrides.overrideContainers['86econolineambulance'] = VanAmbulance

---@param container ItemContainer
ItemOverrides.overrideContainer = function(container, specialZones, zoneName)
    local parent = container:getParent()

    local zone
    if specialZones then
		if zoneName == 'police' then
			zone = Overrides.getZone(parent:getX(), parent:getY(), Overrides.zonesPolice)
		elseif zoneName == 'loot' then
			zone = Overrides.getZone(parent:getX(), parent:getY(), Overrides.zonesLoot)
		end
	else
		zone = Overrides.getZone(parent:getX(), parent:getY())
	end

    local items = container:getItems()
    local getItem = items.get
    for i = items:size()-1, 0, -1 do
        local item = getItem(items, i)

        local itemType = item:getFullType()
        if ItemOverrides.itemSwaps[itemType] then
			if zone ~= nil then
				local newType = ItemOverrides.itemSwaps[itemType][zone]
				if not newType then
					newType = ItemOverrides.itemSwaps[itemType].Default
				end

				if newType then
					if type(newType) == 'table' then
						newType = newType[ZombRand(#newType)+1]
					end
					container:Remove(item)
					if newType ~= 'Remove' then
						container:AddItem(newType)
					end
				end
			end
        end
    end
end

---@param roomType string
---@param containerType string
---@param container ItemContainer
ItemOverrides.OnFillContainer = function(roomType, containerType, container)
    --local zones = ItemOverrides.overrideContainers[roomType] and ItemOverrides.overrideContainers[roomType][containerType] or ItemOverrides.overrideContainers.all[containerType]
    local room = ItemOverrides.overrideContainers[roomType]
	if room then
		local conType = ItemOverrides.overrideContainers[roomType][containerType]
		local conTypeAll = ItemOverrides.overrideContainers.all[containerType]
		local zones = room and conType or conTypeAll
		if zones then
			if conType == 'police' or conTypeAll == 'police' then
				ItemOverrides.overrideContainer(container, zones == 'police', 'police')
			elseif conType == 'loot' or conTypeAll == 'loot' then
				ItemOverrides.overrideContainer(container, zones == 'loot', 'loot')
			elseif conType == true or conTypeAll == true then
				ItemOverrides.overrideContainer(container)
			end
		end
    end
end

ItemOverrides.OnInitGlobalModData = function()
	if SandboxVars.STR.TrunkOverrides then
		Events.OnFillContainer.Add(ItemOverrides.OnFillContainer)
	end
end
Events.OnInitGlobalModData.Add(ItemOverrides.OnInitGlobalModData)

return ItemOverrides