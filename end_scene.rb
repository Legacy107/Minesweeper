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
    top_margin = GameSettings::SCREEN_HEIGHT * 0.1 + font_title.height * 1
    x_offset = (GameSettings::SCREEN_WIDTH - cell_size * game.width) / 2.0
    y_offset = (GameSettings::SCREEN_HEIGHT - top_margin - cell_size * game.height) / 2.0 + top_margin
    for i in 1..game.height
        for j in 1..game.width
            bounding_box << [
                [x_offset, y_offset],
                [x_offset + cell_size, y_offset + cell_size]
            ]

            x_offset += cell_size
        end

        x_offset = (GameSettings::SCREEN_WIDTH - cell_size * game.width) / 2.0
        y_offset += cell_size
    end
    bounding_box << Scene::FINISH

    return bounding_box
end

def end_draw(game, font_title, font_text, button_bounding_box, mouse_x, mouse_y)
    button_bg = Gosu::Image.new(GameSettings::SPRITE["button"])
    button_hover_bg = Gosu::Image.new(GameSettings::SPRITE["button_hover"])
    # Back button
    font_text.draw_text(
        "Back",
        button_bounding_box[0][0][0],
        button_bounding_box[0][0][1],
        ZOrder::TOP,
        1.0,
        1.0,
        GameSettings::COLOR["black_600"]
    )
    button_bg.draw_as_quad(
        button_bounding_box[0][0][0] - GameSettings::BUTTON_PADDING, button_bounding_box[0][0][1] - GameSettings::BUTTON_PADDING, GameSettings::COLOR["white_600"],
        button_bounding_box[0][1][0] + GameSettings::BUTTON_PADDING, button_bounding_box[0][0][1] - GameSettings::BUTTON_PADDING, GameSettings::COLOR["white_600"],
        button_bounding_box[0][1][0] + GameSettings::BUTTON_PADDING, button_bounding_box[0][1][1] + GameSettings::BUTTON_PADDING, GameSettings::COLOR["white_600"],
        button_bounding_box[0][0][0] - GameSettings::BUTTON_PADDING, button_bounding_box[0][1][1] + GameSettings::BUTTON_PADDING, GameSettings::COLOR["white_600"],
        ZOrder::MIDDLE,
    )
    if mouse_over_button(mouse_x, mouse_y, button_bounding_box[0])
        button_hover_bg.draw_as_quad(
            button_bounding_box[0][0][0] - GameSettings::BUTTON_PADDING, button_bounding_box[0][0][1] - GameSettings::BUTTON_PADDING, GameSettings::COLOR["white_600"],
            button_bounding_box[0][1][0] + GameSettings::BUTTON_PADDING, button_bounding_box[0][0][1] - GameSettings::BUTTON_PADDING, GameSettings::COLOR["white_600"],
            button_bounding_box[0][1][0] + GameSettings::BUTTON_PADDING, button_bounding_box[0][1][1] + GameSettings::BUTTON_PADDING, GameSettings::COLOR["white_600"],
            button_bounding_box[0][0][0] - GameSettings::BUTTON_PADDING, button_bounding_box[0][1][1] + GameSettings::BUTTON_PADDING, GameSettings::COLOR["white_600"],
            ZOrder::MIDDLE,
        )
    end

    if game.mode == 1 || check_win(
        game.flags, game.mines,
        game.width, game.height,
        game.board, game.mask
    )
        file = (
            GameRules::BOARD_OPTIONS[game.mode].filter() {|board|
                board[3] == game.mines
            }
        )[0][0]
        highscore = get_highscore(file)
        highscore_text = "Score: #{format_duration(game.score)}     Highscore: #{format_duration(highscore)}"

        font_title.draw_text(
            "You win!",
            center_text(font_title, "You win!", GameSettings::SCREEN_WIDTH),
            GameSettings::SCREEN_HEIGHT * 0.05,
            ZOrder::TOP,
            1.0,
            1.0,
            GameSettings::COLOR["black_600"]
        )

        font_title.draw_text(
            highscore_text,
            center_text(font_title, highscore_text, GameSettings::SCREEN_WIDTH),
            GameSettings::SCREEN_HEIGHT * 0.05 + font_title.height * 1.5,
            ZOrder::TOP,
            1.0,
            1.0,
            GameSettings::COLOR["black_600"]
        )
    else
        font_title.draw_text(
            "You lose!",
            center_text(font_title, "You lose!", GameSettings::SCREEN_WIDTH),
            GameSettings::SCREEN_HEIGHT * 0.1,
            ZOrder::TOP,
            1.0,
            1.0,
            GameSettings::COLOR["black_600"]
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
