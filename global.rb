require "gosu"

module ZOrder
    BACKGROUND, MIDDLE, TOP = *0..2
end

module Scene
    MENU, CHOOSER, GAME, SAW, FINISH, SCORE, CREDIT, EXIT = *0..6
end

module GameSettings
    SCREEN_WIDTH = 960
    SCREEN_HEIGHT = 650
    BUTTON_PADDING = 10
    SCORE_LIMIT = 5
    TRACKS = {
        Scene::MENU => "./assets/Ludum Dare 38 - Track 1.m4a",
        Scene::GAME => "./assets/Ludum Dare 38 - Track 2.m4a",
        Scene::SAW => "./assets/Ludum Dare 38 - Track 2.m4a",
        "open" => "./assets/click1.ogg",
        "flag" => "./assets/click4.ogg",
    }
    SPRITE = {
        "title" => "./assets/title.png",
        "background" => "./assets/brown.png",
        "button" => "./assets/grey_button01.png",
        "button_hover" => "./assets/blue_button01.png",
    }
    FONT = {
        "title" => "./assets/FredokaOne-Regular.ttf",
    }
    COLOR = {
        "yellow_200" => Gosu::Color.rgba(255, 247, 154, 90),
        "yellow_400" => Gosu::Color.rgba(255, 247, 154, 255),
        "black_400" => Gosu::Color.rgba(54, 54, 57, 255),
        "black_600" => Gosu::Color::BLACK,
        "white_600" => Gosu::Color::WHITE,
        "gray_400" => Gosu::Color.rgba(143, 129, 125, 255),
        "red_400" => Gosu::Color.rgba(237, 28, 36, 255),
        "green_400" => Gosu::Color.rgba(30, 220, 123, 255),
        "blue_400" => Gosu::Color.rgba(0, 143, 212, 255),
        "blue_900" => Gosu::Color.rgba(55, 108, 129, 255),
    }
    CREDIT = {
        "Developed by" => ["Quoc Mai"],
        "Graphic" => ["Kenney at www.kenney.nl", "Pixel Frog"],
        "SFX & Music" => [
            "Kenney at www.kenney.nl",
            "Ludum Dare 38 - Track 1 & 2 by Abstraction at www.abstractionmusic.com",
        ],
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
            ["Beginner", 10, 10, 10, 0],
            ["Intermediate", 16, 16, 40, 0],
            ["Expert", 16, 16, 40, 180000],
        ],
        [
            ["Saw Beginner", 10, 10, 1, 0],
            ["Saw Intermediate", 16, 16, 4, 0],
            ["Saw Expert", 30, 16, 8, 0],
        ]
    ]
end    

