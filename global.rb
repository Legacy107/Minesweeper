module Scene
    MENU, CHOOSER, GAME, SAW, FINISH, SCORE, EXIT = *0..6
end

$saw_penalty_duration = 30

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
