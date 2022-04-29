module ZOrder
    BACKGROUND, MIDDLE, TOP = *0..2
end

module Scene
    MENU, CHOOSER, GAME, SAW, FINISH, SCORE, EXIT = *0..6
end

module GameSettings
    SCREEN_WIDTH = 840
    SCREEN_HEIGHT = 550
    BUTTON_PADDING = 3
    TRACKS = {
        Scene::MENU => "./assets/Ludum Dare 38 - Track 1.wav",
        Scene::GAME => "./assets/Ludum Dare 38 - Track 2.wav",
        Scene::SAW => "./assets/Ludum Dare 38 - Track 2.wav",
        "open" => "./assets/click1.ogg",
        "flag" => "./assets/click4.ogg",
    }
end

module GameRules
    SAW_PENALTY_DURATION = 30
    
    MINESAWYER_RULES = [
        "Minesawyer's rule:",
        "Each cell has either a mine or a number indicating the Manhattan distance to the nearest mine.",
        "To win the game, you have to open all the cells that have mines inside.",
        "For each cell you open that does not contain a mine, a 30 seconds penalty will be applied.",
        "GLHF! :D",
    ]
    
    BOARD_OPTIONS = [
        [
            ["Beginner", 10, 10, 10],
            ["Intermediate", 16, 16, 40],
            ["Expert", 30, 16, 99],
        ],
        [
            ["Saw Beginner", 10, 10, 1],
            ["Saw Intermediate", 16, 16, 4],
            ["Saw Expert", 30, 16, 8],
        ]
    ]
end    

