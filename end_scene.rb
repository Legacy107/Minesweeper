require "gosu"
require "./global.rb"
require "./minesweeper.rb"
require "./util.rb"
require "./score.rb"
require "./board.rb"

def end_gen_box(game, font_title, font_text)
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
    bounding_box << Scene::FINISH

    return bounding_box
end

def end_draw(game, font_title, font_text, button_bounding_box, mouse_x, mouse_y)
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

    if game.mode == 1 || check_win(
        game.flags, game.mines,
        game.width, game.height,
        game.board, game.mask
    )
        file = (
            $board_options[game.mode].filter() {|board|
                board[3] == game.mines
            }
        )[0][0]
        highscore = get_highscore(file)
        highscore_text = "Score: #{format_duration(game.score)}     Highscore: #{format_duration(highscore)}"

        font_title.draw_text(
            "You win!",
            center_text(font_title, "You win!", $screen_width),
            $screen_height * 0.1,
            ZOrder::TOP,
            1.0,
            1.0,
            Gosu::Color::BLACK
        )

        font_title.draw_text(
            highscore_text,
            center_text(font_title, highscore_text, $screen_width),
            $screen_height * 0.1 + font_title.height * 1.5,
            ZOrder::TOP,
            1.0,
            1.0,
            Gosu::Color::BLACK
        )
    else
        font_title.draw_text(
            "You lose!",
            center_text(font_title, "You lose!", $screen_width),
            $screen_height * 0.1,
            ZOrder::TOP,
            1.0,
            1.0,
            Gosu::Color::BLACK
        )
    end

    draw_board(
        game.width, game.height,
        game.board, game.mask,
        font_text, button_bounding_box.slice(1..-1),
        -1, -1
    )
end

def end_input(game, key_id)
    if key_id == 0
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
