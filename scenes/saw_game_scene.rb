require "gosu"
require_relative "../utils/global.rb"
require_relative "../utils/util.rb"
require_relative "../utils/board.rb"
require_relative "../utils/score.rb"

def saw_gen_box(game_state, font_title, font_text)
    bounding_box = []

    bounding_box << [
        [10, 10],
        [10 + font_text.text_width("Back"), 10 + font_text.height]
    ]
    cell_size = [font_text.text_width("XX"), font_text.height].max()
    top_margin = GameSettings::SCREEN_HEIGHT * 0.1 + font_title.height * 1
    x_offset = (GameSettings::SCREEN_WIDTH - cell_size * game_state.width) / 2.0
    y_offset = (GameSettings::SCREEN_HEIGHT - top_margin - cell_size * game_state.height) / 2.0 + top_margin
    for i in 1..game_state.height
        for j in 1..game_state.width
            bounding_box << [
                [x_offset, y_offset],
                [x_offset + cell_size, y_offset + cell_size]
            ]

            x_offset += cell_size
        end

        x_offset = (GameSettings::SCREEN_WIDTH - cell_size * game_state.width) / 2.0
        y_offset += cell_size
    end
    bounding_box << Scene::SAW

    return bounding_box
end

def draw_instruction(font_text)
    font_text.draw_text(
        "Left click to open a cell",
        GameSettings::SCREEN_WIDTH / 2.0 - font_text.text_width("Left click to open a cell") - 20,
        GameSettings::SCREEN_HEIGHT - font_text.height - 10,
        ZOrder::TOP,
        1.0,
        1.0,
        GameSettings::COLOR["black_600"]
    )

    font_text.draw_text(
        "Right click to set a flag",
        GameSettings::SCREEN_WIDTH / 2.0 + 20,
        GameSettings::SCREEN_HEIGHT - font_text.height - 10,
        ZOrder::TOP,
        1.0,
        1.0,
        GameSettings::COLOR["black_600"]
    )
end

def saw_game_draw(game_state, font_title, font_text, button_bounding_box, mouse_x, mouse_y)
    remainingFlagsText = "Remaining Mines: #{game_state.remaining_mines}"
    timerText = "Time: #{format_duration(get_duration(game_state.start_time))}"

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

    font_title.draw_text(
        remainingFlagsText,
        GameSettings::SCREEN_WIDTH / 2.0 - font_title.text_width(remainingFlagsText) - 20,
        GameSettings::SCREEN_HEIGHT * 0.1,
        ZOrder::TOP,
        1.0,
        1.0,
        GameSettings::COLOR["black_600"]
    )
    font_title.draw_text(
        timerText,
        GameSettings::SCREEN_WIDTH / 2.0 + 20,
        GameSettings::SCREEN_HEIGHT * 0.1,
        ZOrder::TOP,
        1.0,
        1.0,
        GameSettings::COLOR["black_600"]
    )

    draw_board(
        game_state.width, game_state.height,
        game_state.board, game_state.mask,
        font_text, button_bounding_box.slice(1..-1),
        mouse_x, mouse_y
    )

    draw_instruction(font_text)
end

def saw_game_input(game, game_state, key_id)
    flag = false

    if key_id == 0
        game.change_scene(Scene::MENU)
        flag = true
    elsif key_id
        cell_x = (key_id.abs() - 1) % game_state.width
        cell_y = (key_id.abs() - 1).div(game_state.width)

        # right click -> open a cell
        if key_id > 0 && game_state.mask[cell_y][cell_x] == 0
            if open_cell(cell_x, cell_y, game_state)
                game_state.remaining_mines -= 1
                if game_state.remaining_mines == 0
                    game_state.score = get_duration(game_state.start_time)
                    file = (
                        GameRules::BOARD_OPTIONS[game_state.mode].filter() {|board|
                            board[3] == game_state.mines
                        }
                    )[0][0]
                    update_scoreboard(file, game_state.score)
                    game.change_scene(Scene::FINISH)
                end
            else
                game_state.start_time = game_state.start_time - GameRules::SAW_PENALTY_DURATION
            end
            flag = true
        # left click -> flag a cell
        elsif key_id < 0 && game_state.mask[cell_y][cell_x] != 1
            game_state.flags = flag_cell(
                cell_x, cell_y,
                game_state.flags, game_state.mask
            )
            flag = true
        end
    end

    return flag
end

def saw_game_process(game, game_state, key_id)
   saw_game_input(game, game_state, key_id)
end
