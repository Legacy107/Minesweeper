$screen_width = 840
$screen_height = 550

module ZOrder
    BACKGROUND, MIDDLE, TOP = *0..2
end

module Scene
    MENU, CHOOSER, GAME, SAW, FINISH, SCORE, EXIT = *0..6
end

$saw_penalty_duration = 30

$minesawyer_rules = [
    "Minesawyer's rule:",
    "Each cell has either a mine or a number indicating the Manhattan distance to the nearest mine.",
    "To win the game, you have to open all the cells that have mines inside.",
    "For each cell you open that does not contain a mine, a 30 seconds penalty will be applied.",
    "GLHF! :D",
]

# struct board_option
# {
#     std::string name;
#     int width, height, mines;
# };

$board_options = [
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

$button_padding = 3
