require "gosu"
require "./global.rb"
require "./minesweeper.rb"

def chooser_draw(game)
    puts("================")
    puts(" Choose a board ")
    puts("================")
    puts()

    for i in 0..($board_options[game.mode].length - 1)
        print("#{i + 1}. ")
        print("#{$board_options[game.mode][i][0]} ")
        print("#{$board_options[game.mode][i][1]} x ")
        print("#{$board_options[game.mode][i][2]} ")
        print("#{$board_options[game.mode][i][3]} ")
        puts("mines (#{i + 1})")
    end

    if game.mode == 1
        puts()
        puts()
        puts("Minesawyer's rule:")
        print("Each cell has either a mine or a number indicating the Manhattan distance to the nearest mine.")
        puts("To win the game, you have to open all the cells that have mines inside.")
        puts("For each cell you open that does not contain a mine, a 30 seconds penalty will be applied.")
        puts("GLHF! :D")
        puts()
    end

    puts("< Menu (M)")
end

def chooser_input(game, key_id)
    keys = [Gosu::KB_1, Gosu::KB_2, Gosu::KB_3]
    for i in 0..($board_options[game.mode].length - 1)
        if key_id == keys[i]
            game.create_board(
                $board_options[game.mode][i][1],
                $board_options[game.mode][i][2],
                $board_options[game.mode][i][3]
            )

            if game.mode == 0
                game.change_scene(Scene::GAME)
            elsif game.mode == 1
                game.change_scene(Scene::SAW)
            end

            return true
        end
    end

    if key_id == Gosu::KB_M
        game.change_scene(Scene::MENU)
        return true
    end

    return false;
end

def chooser_process(game, key_id)
    chooser_input(game, key_id)
end
