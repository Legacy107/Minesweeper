require "gosu"
require "./global.rb"
require "./minesweeper.rb"
require "./util.rb"
require "./board.rb"

def update_timer(game)
    print("Time: #{format_duration(get_duration(game.start_time))}")
end

def draw_instruction()
    puts("Move (arrow kes)")
    puts("Open (O)")
    puts("Flag (F)")
    puts("Save and exit (M)")
end

def game_draw(game)
    print("Remaining Flags: #{game.mines - game.flags}\t")
    update_timer(game)
    puts()
    puts()

    draw_board(
        game.width, game.height,
        game.board, game.mask,
        game.cursor
    )

    puts()
    draw_instruction()
end

def game_input(game, key_id)
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
                game.change_scene(Scene::FINISH)
                game.score = get_duration(game.start_time)
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
        save_board(
            game.width, game.height, game.mines, game.seed,
            game.flags, get_duration(game.start_time), game.mask
        )
        game.change_scene(Scene::MENU)
        flag = true
    end

    return flag
end

def game_process(game, key_id)
    if game_input(game, key_id)
        if check_win(
            game.flags, game.mines,
            game.width, game.height,
            game.board, game.mask
        )
            game.change_scene(Scene::FINISH)
        end
    end
    update_timer(game)
end