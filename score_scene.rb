require "gosu"
require "./global.rb"
require "./minesweeper.rb"
require "./util.rb"
require "./score.rb"
require "./board.rb"

$SCORE_LIMIT = 5
$OFFSET = 100

def score_draw(game)
    puts("============")
    puts(" High Score ")
    puts("============")
    puts()

    for i in 0..($board_options.length - 1)
        for j in 0..($board_options[i].length - 1)
            scores = get_scores($board_options[i][j][3] + i * $OFFSET)
            puts("#{$board_options[i][j][0]} scoreboard")
            for id in 0..($SCORE_LIMIT - 1)
                print("#{id + 1}. ")

                if id < scores.length
                    print(format_duration(scores[id]))
                end
                puts()
            end

            puts()
        end
    end

    puts("< Menu (M)")
end

def score_input(game, key_id)
    if key_id == Gosu::KB_M
        game.change_scene(Scene::MENU)
        return true
    end
    return false
end

def score_process(game, key_id)
    score_input(game, key_id)
end
