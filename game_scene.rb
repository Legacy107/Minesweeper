require "gosu"
require "./global.rb"
require "./minesweeper.rb"
require "./util.rb"
require "./board.rb"
require "./score.rb"

def game_gen_box(game, font_title, font_text)
    bounding_box = []

    bounding_box << [
        [10, 10],
        [10 + font_text.text_width("Back"), 10 + font_text.height]
    ]
    cell_size = [font_text.text_width("XX"), font_text.height].max()
    top_margin = $screen_height * 0.1 + font_title.height * 1
    x_offset = ($screen_width - cell_size * game.width) / 2.0
    y_offset = ($screen_height - top_margin - cell_size * game.height) / 2.0 + top_margin
    for i in 1..game.height
        for j in 1..game.width
            bounding_box << [
                [x_offset, y_offset],
                [x_offset + cell_size, y_offset + cell_size]
            ]

            x_offset += cell_size
        end

        x_offset = ($screen_width - cell_size * game.width) / 2.0
        y_offset += cell_size
    end
    bounding_box << Scene::GAME

    return bounding_box
end

def draw_instruction(font_text)
    font_text.draw_text(
        "Left click to open a cell",
        $screen_width / 2.0 - font_text.text_width("Left click to open a cell") - 20,
        $screen_height - font_text.height - 10,
        ZOrder::TOP,
        1.0,
        1.0,
        Gosu::Color::BLACK
    )

    font_text.draw_text(
        "Right click to set a flag",
        $screen_width / 2.0 + 20,
        $screen_height - font_text.height - 10,
        ZOrder::TOP,
        1.0,
        1.0,
        Gosu::Color::BLACK
    )
end

def game_draw(game, font_title, font_text, button_bounding_box, mouse_x, mouse_y)
    remainingFlagsText = "Remaining Flags: #{game.mines - game.flags}"
    timerText = "Time: #{format_duration(get_duration(game.start_time))}"

    # Back button
    if mouse_over_button(mouse_x, mouse_y, button_bounding_box[0])
        Gosu.draw_rect(
            button_bounding_box[0][0][0] - $button_padding,
            button_bounding_box[0][0][1] - $button_padding,
            button_bounding_box[0][1][0] - button_bounding_box[0][0][0] + $button_padding * 2,
            button_bounding_box[0][1][1] - button_bounding_box[0][0][1] + $button_padding * 2,
            Gosu::Color::YELLOW,
            ZOrder::MIDDLE,
            mode=:default
        )
    end
    font_text.draw_text(
        "Back",
        button_bounding_box[0][0][0],
        button_bounding_box[0][0][1],
        ZOrder::TOP,
        1.0,
        1.0,
        Gosu::Color::BLACK
    )

    font_title.draw_text(
        remainingFlagsText,
        $screen_width / 2.0 - font_title.text_width(remainingFlagsText) - 20,
        $screen_height * 0.1,
        ZOrder::TOP,
        1.0,
        1.0,
        Gosu::Color::BLACK
    )
    font_title.draw_text(
        timerText,
        $screen_width / 2.0 + 20,
        $screen_height * 0.1,
        ZOrder::TOP,
        1.0,
        1.0,
        Gosu::Color::BLACK
    )

    draw_board(
        game.width, game.height,
        game.board, game.mask,
        font_text, button_bounding_box.slice(1..-1),
        mouse_x, mouse_y
    )

    draw_instruction(font_text)
end

def game_input(game, key_id)
    flag = false

    if key_id == 0
        save_board(
            game.width, game.height, game.mines, game.seed,
            game.flags, get_duration(game.start_time), game.mask
        )
        game.change_scene(Scene::MENU)
        flag = true
    elsif key_id
        cell_x = (key_id.abs() - 1) % game.width
        cell_y = (key_id.abs() - 1).div(game.width)

        # right click -> open a cell
        if key_id > 0 && game.mask[cell_y][cell_x] == 0
            if open_cell(
                cell_x, cell_y,
                game.width, game.height,
                game.board, game.mask
            )
                game.score = get_duration(game.start_time)
                game.change_scene(Scene::FINISH)
            end
            flag = true
        # left click -> flag a cell
        elsif key_id < 0 && game.mask[cell_y][cell_x] != 1
            game.flags = flag_cell(
                cell_x, cell_y,
                game.flags, game.mask
            )
            flag = true
        end
    end

    return flag
end

def game_process(game, key_id)
    if Time.new().to_i() % 2 == 0
        if next_move(game)
            if check_win(
                game.flags, game.mines,
                game.width, game.height,
                game.board, game.mask
            )
                game.score = get_duration(game.start_time)
                file = (
                    $board_options[game.mode].filter() {|board|
                        board[3] == game.mines
                    }
                )[0][0]
                update_scoreboard(file, game.score)
                game.change_scene(Scene::FINISH)
            end
        end
    end
    if game_input(game, key_id)
        if check_win(
            game.flags, game.mines,
            game.width, game.height,
            game.board, game.mask
        )
            game.score = get_duration(game.start_time)
            file = (
                $board_options[game.mode].filter() {|board|
                    board[3] == game.mines
                }
            )[0][0]
            update_scoreboard(file, game.score)
            game.change_scene(Scene::FINISH)
        end
    end
end