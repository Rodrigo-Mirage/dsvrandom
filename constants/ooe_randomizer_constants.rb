
NONRANDOMIZABLE_PICKUP_GLOBAL_IDS =
  [0x0, 0x37, 0x50, 0xE5, 0x100, 0x124, 0x139, 0x160] + # unequip dummy items (---)
  [0x161] + # unused vampire killer weapon
  (0x51..0x6E).to_a + # glyph unions
  (0xD7..0xE4).to_a + # no-damage medals
  [0xAE, 0xB6, 0xD6] # usable items with a hardcoded effect for quests

ITEMS_WITH_OP_HARDCODED_EFFECT = [0x123, 0x149] # queen of hearts, death ring

WEAPON_SWING_ANIM_NAMES = {
  0x00 => "Fast",
  0x01 => "Fast stab",
  0x02 => "Fast",
  0x03 => "Slow",
  0x04 => "Stab",
  0x05 => "Normal",
  0x06 => "Normal",
}

WEAPON_SUPER_ANIM_NAMES = {
  0x00 => "Generic",
  0x01 => "Generic",
  0x02 => "Sword",
  0x03 => "Rapier",
  0x04 => "Lance",
  0x05 => "Hammer",
  0x06 => "Bow",
  0x07 => "Axe",
  0x08 => "Sickle",
  0x09 => "Knife",
  0x0A => "Shield",
  0x0B => "Lapiste",
  0x0C => "Pneuma",
  0x0D => "Fire",
  0x0E => "Ice",
  0x0F => "Lightning",
  0x10 => "Holy",
  0x11 => "Dark",
  0x12 => "Nitesco",
  0x13 => "Dominus",
}

MAGICAL_TICKET_GLOBAL_ID = 0x7C

SPAWNER_ENEMY_IDS = [0x00, 0x01, 0x03, 0x06, 0x0B, 0x0F, 0x1B, 0x2B, 0x3E, 0x48, 0x60, 0x61, 0x65]

STOLAS_UNFRIENDLY_ENEMY_IDS = []

RANDOMIZABLE_BOSS_IDS = BOSS_IDS -
  [0x78] - # Remove the final boss, Dracula. 
  [0x6D, 0x76] - # Also remove Brachyura and Eligor since they need their own huge rooms.
  [0x71] # Remove Gravedorcus because he relies on code and objects specific to Oblivion Ridge.

ORIGINAL_BOSS_IDS_ORDER = [
  0x6C, # Arthroverta
  0x6B, # Giant Skeleton
  0x6D, # Brachyura
  0x6E, # Maneater
  0x6F, # Rusalka
  0x70, # Goliath
  0x71, # Gravedorcus
  0x72, # Albus
  0x73, # Barlowe
  0x75, # Blackmore
  0x76, # Eligor
  0x77, # Death
]

PATH_BLOCKING_BREAKABLE_WALLS = [
  {var_a: 2, var_b: 0},
  {var_a: 0, var_b: 0},
  {var_a: 3, var_b: 3},
  {var_a: 3, var_b: 4},
  {var_a: 8, var_b: 0},
  {var_a: 7, var_b: 4},
  {var_a: 3, var_b: 0},
  {var_a: 3, var_b: 1},
  {var_a: 3, var_b: 2},
  {var_a: 1, var_b: 0},
  {var_a: 1, var_b: 1},
  {var_a: 0, var_b: 1},
]

MAGICAL_TICKET_X_POS_OFFSET = 0x02037B10
MAGICAL_TICKET_Y_POS_OFFSET = 0x02037B04

INTRO_TEXT_ID = 0x660

BGM_RANDO_AVAILABLE_SONG_INDEXES = [
  0x0E, # An Empty Tome
  0x0E, # An Empty Tome
  0x10, # Malak's Labyrinth
  0x0E, # An Empty Tome
  0x0E, # An Empty Tome
  0x0F, # Ebony Wings
  0x12, # Tower of Dolls
  0x12, # Tower of Dolls
  0x0F, # Ebony Wings
  0x0D, # Ambience
  0x13, # The Colossus
  0x13, # The Colossus
  0x0E, # An Empty Tome
  0x03, # Serenade of the Hearth
  0x01, # A Prologue
  0x2E, # Riddle
  0x04, # Emerald Mist
  0x04, # Emerald Mist
  0x05, # A Clashing of Waves
  0x0A, # Wandering the Crystal Blue
  0x06, # Rhapsody of the Forsaken
  0x06, # Rhapsody of the Forsaken
  0x07, # Jaws of a Scorched Earth
  0x0B, # Edge of the Sky
  0x2E, # Riddle
  0x0C, # Hard Won Nobility
  0x0C, # Hard Won Nobility
  0x08, # Tragedy's Pulse
  0x08, # Tragedy's Pulse
  0x09, # Unholy Vespers
  0x02, # Chapel Hidden in Smoke
  0x2D, # Lone Challenger
  0x35, # Vampire Killer
  0x36, # Stalker
  0x37, # Wicked Child
  0x38, # Walking on the Edge
  0x39, # Heart of Fire
  0x3A, # Out of Time
  0x3B, # Nothing to Lose
  0x3C, # Black Night
]

LOAD_SPRITE_SINGLE_GFX_FUNC_PTR = 0x0203B5D0
LOAD_SPRITE_MULTI_GFX_FUNC_PTR = 0x0203B6D0

SOLID_BLOCKADE_TILE_INDEX_FOR_TILESET = {
  65 => { # Castle Entrance
    0x022CBF74 => 0x0010,
    0x022CDF6C => 0x00DB,
  },
  66 => { # Castle Entrance
    0x022C9A10 => 0x00E0,
    0x022CBA08 => 0x00DB,
  },
  68 => { # Underground Labyrinth
    0x022E1608 => 0x01C6,
    0x022E3600 => 0x01C6,
    0x022E55F8 => 0x01C6,
    0x022E75F0 => 0x0078,
  },
  69 => { # Library
    0x022D2F80 => 0x0001,
    0x022D4F78 => 0x0001,
    0x022D6F70 => 0x0010,
  },
  70 => { # Library
    0x022C89CC => 0x00A9,
    0x022CA9C4 => 0x00E0,
  },
  71 => { # Barracks
    0x022D3AA0 => 0x01CC,
  },
  72 => { # Mechanical Tower
    0x022D9A70 => 0x0008,
  },
  73 => { # Mechanical Tower
    0x022C72D0 => 0x0002,
  },
  76 => { # Arms Depot
    0x022D09B8 => 0x000D,
    0x022D29B0 => 0x007A,
  },
  77 => { # Forsaken Cloister
    0x022C9EEC => 0x0275,
  },
  74 => { # Final Approach
    0x022D0FBC => 0x0030,
    0x022D2FB4 => 0x03E7,
  },
  75 => { # Final Approach
    0x022C8248 => 0x00D0,
    0x022CA240 => 0x0001,
    0x022CC238 => 0x0011,
  },
  67 => { # Castle Entrance
    0x022C3738 => 0x0001,
    0x022C5730 => 0x0001,
  },
  40 => { # Wygol Village
    0x022C5CB8 => 0x0001,
    0x022C7CB0 => 0x0001,
    0x022C9CA8 => 0x0001,
  },
  41 => { # Wygol Village
    0x022C3CF4 => 0x0001,
  },
  42 => { # Ecclesia
    0x022CC4EC => 0x0006,
    0x022CE4E4 => 0x0010,
    0x022D04DC => 0x0001,
  },
  43 => { # Training Hall
    0x022C2894 => 0x0020,
  },
  44 => { # Ruvas Forest
    0x022C2FE0 => 0x00E0,
  },
  45 => { # Argila Swamp
    0x022C2FE0 => 0x0106,
  },
  46 => { # Kalidus Channel
    0x022C5208 => 0x00C1,
    0x022C7200 => 0x00D1,
  },
  47 => { # Kalidus Channel
    0x022C2FDC => 0x0001,
  },
  48 => { # Somnus Reef
    0x022C2FDC => 0x00C1,
    0x022C4FD4 => 0x00D1,
  },
  49 => { # Somnus Reef
    0x022C2FDC => 0x018C,
  },
  50 => { # Minera Prison Island
    0x022CD220 => 0x0270,
  },
  51 => { # Minera Prison Island
    0x022CD830 => 0x0113,
  },
  52 => { # Minera Prison Island
    0x022CB888 => 0x0270,
  },
  53 => { # Lighthouse
    0x022C58D4 => 0x000E,
  },
  54 => { # Tymeo Mountains
    0x022C37E0 => 0x0001,
  },
  55 => { # Tymeo Mountains
    0x022C3920 => 0x00D0,
  },
  56 => { # Tristis Pass
    0x022C37E0 => 0x0001,
  },
  57 => { # Tristis Pass
    0x022C4CD0 => 0x0050,
  },
  58 => { # Large Cavern
    0x022C265C => 0x0001,
  },
  59 => { # Giant's Dwelling
    0x022CEE6C => 0x0030,
    0x022D0E64 => 0x00E4,
  },
  60 => { # Mystery Manor
    0x022CBDB8 => 0x0030,
    0x022CDDB0 => 0x00B0,
    0x022CFDA8 => 0x0105,
  },
  61 => { # Misty Forest Road
    0x022CCF9C => 0x0002,
    0x022CEF94 => 0x0001,
  },
  62 => { # Oblivion Ridge
    0x022C46F8 => 0x0010,
  },
  63 => { # Oblivion Ridge
    0x022CCABC => 0x00C0,
    0x022CEAB4 => 0x00C0,
  },
  64 => { # Skeleton Cave
    0x022C9474 => 0x00D8,
    0x022CB46C => 0x0160,
  },
  78 => { # Monastery
    0x022D0568 => 0x0001,
    0x022D2560 => 0x0300,
    0x022D4558 => 0x0001,
  },
  79 => { # Monastery
    0x022C37E0 => 0x0001,
  },
  80 => { # Epilogue & Boss Rush Mode & Practice Mode
    0x022C2FDC => 0x000F,
  },
  81 => { # Epilogue & Boss Rush Mode & Practice Mode
    0x022C37E0 => 0x0001,
  },
  82 => { # Epilogue & Boss Rush Mode & Practice Mode
    0x022C2CE0 => 0x0010,
  },
  83 => { # Epilogue & Boss Rush Mode & Practice Mode
    0x022C37E0 => 0x0001,
  },
  84 => { # Epilogue & Boss Rush Mode & Practice Mode
    0x022C3D40 => 0x0018,
  },
  85 => { # Epilogue & Boss Rush Mode & Practice Mode
    0x022C37E0 => 0x0028,
  },
}
