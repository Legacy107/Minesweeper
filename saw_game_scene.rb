require "gosu"
require "./global.rb"
require "./minesweeper.rb"
require "./util.rb"
require "./board.rb"

def update_timer(game)
    print("Time: #{format_duration(get_duration(game.start_time))}")
end

def saw_draw_instruction(game)
    puts("Minesawyer's rule:")
    puts("Each cell has either a mine or a number indicating the Manhattan distance to the nearest mine.")
    puts("To win the game, you have to open all the cells that have mines inside.")
    puts("For each cell you open that does not contain a mine, a 30 seconds penalty will be applied.")
    puts("GLHF! :D")

    puts("Move (arrow kes)")
    puts("Open (O)")
    puts("Flag (F)")
    puts("Exit (M)")
end

def saw_game_draw(game)
    print("Remaining Mines: #{game.remaining_mines}\t")
    update_timer(game)
    puts()

    draw_board(
        game.width, game.height,
        game.board, game.mask,
        game.cursor
    )
end

def saw_game_input(game, key_id)
    flag = false

    if key_id == Gosu::KB_UP
        if is_valid_cell(
            game.cursor[0], game.cursor[1] - 1,
            game.width, game.height
        )
            game.cursor[1] -= 1
            flag = true
        end
    elsif key_id == Gosu::KB_DOWN
        if is_valid_cell(
            game.cursor[0], game.cursor[1] + 1,
            game.width, game.height
        )
            game.cursor[1] += 1
            flag = true
        end
    elsif key_id == Gosu::KB_RIGHT
        if is_valid_cell(
            game.cursor[0] + 1, game.cursor[1],
            game.width, game.height
        )
            game.cursor[0] += 1
            flag = true
        end
    elsif key_id == Gosu::KB_LEFT
        if is_valid_cell(
            game.cursor[0] - 1, game.cursor[1],
            game.width, game.height
        )
            game.cursor[0] -= 1
            flag = true
        end
    elsif key_id == Gosu::KB_O
        if game.mask[game.cursor[1]][game.cursor[0]] == 0
            if open_cell(
                game.cursor[0], game.cursor[1],
                game.width, game.height,
                game.board, game.mask
            )
                game.remaining_mines -= 1
                if game.remaining_mines == 0
                    game.change_scene(Scene::FINISH)
                    game.score = get_duration(game.start_time)
                end
            else
                game.start_time = game.start_time - $saw_penalty_duration
            end
            flag = true
        end
    elsif key_id == Gosu::KB_F
        if game.mask[game.cursor[1]][game.cursor[0]] != 1
            flag_cell(
                game.cursor[0], game.cursor[1],
                game.flags, game.mask
            )
            flag = true
        end
    elsif key_id == Gosu::KB_M
        game.change_scene(Scene::MENU)
        flag = true
    end

    return flag
end

def saw_game_process(game, key_id)
   saw_game_input(game, key_id)
end
