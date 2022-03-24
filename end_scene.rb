require "gosu"
require "./global.rb"
require "./minesweeper.rb"
require "./util.rb"
require "./score.rb"
require "./board.rb"

def end_draw(game)
    if game.mode == 1 || check_win(
        game.flags, game.mines,
        game.width, game.height,
        game.board, game.mask
    )
        highscore = 0
        file = game.mines + (game.mode == 1 ? 100 : 0)

        update_scoreboard(file, game.score)
        highscore = get_highscore(file)

        game.cursor = [-1, -1]

        puts("==========")
        puts(" You win! ")
        puts("==========")
        puts()
        puts("Score: #{format_duration(game.score)}\tHighscore: #{format_duration(highscore)}")
    else
        puts("===========")
        puts(" You lose! ")
        puts("===========")
    end

    puts()
    draw_board(
        game.width, game.height,
        game.board, game.mask,
        game.cursor
    )

    puts("< Menu (M)")
end

def end_input(game, key_id)
    if key_id == Gosu::KB_M
        game.change_scene(Scene::MENU)
        return true
    end
    return false
end

def end_process(game, key_id)
    for row in 0..(game.height - 1)
        for column in 0..(game.width - 1)
            game.mask[row][column] = 1
        end
    end

    end_input(game, key_id)
end
