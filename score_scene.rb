require "gosu"
require "./global.rb"
require "./util.rb"
require "./score.rb"
require "./board.rb"

def score_get_buttons()
    return ["Back"]
end

def score_gen_box(game_state, font_title, font_text)
    bounding_box = []

    bounding_box << [
        [10, 10],
        [10 + font_text.text_width(score_get_buttons.last()), 10 + font_text.height]
    ]
    bounding_box << Scene::SCORE

    return bounding_box
end

def score_draw(game_state, font_title, font_text, button_bounding_box, mouse_x, mouse_y)
    font_title.draw_text(
        "High Score",
        center_text(font_title, "High Score", GameSettings::SCREEN_WIDTH),
        GameSettings::SCREEN_HEIGHT * 0.1,
        ZOrder::TOP,
        1.0,
        1.0,
        GameSettings::COLOR["black_600"]
    )

    button_bg = Gosu::Image.new(GameSettings::SPRITE["button"])
    button_hover_bg = Gosu::Image.new(GameSettings::SPRITE["button_hover"])
    score_get_buttons().each_with_index() do |button, index|
        font_text.draw_text(
            button,
            button_bounding_box[index][0][0],
            button_bounding_box[index][0][1],
            ZOrder::TOP,
            1.0,
            1.0,
            GameSettings::COLOR["black_600"]
        )
        button_bg.draw_as_quad(
            button_bounding_box[index][0][0] - GameSettings::BUTTON_PADDING, button_bounding_box[index][0][1] - GameSettings::BUTTON_PADDING, GameSettings::COLOR["white_600"],
            button_bounding_box[index][1][0] + GameSettings::BUTTON_PADDING, button_bounding_box[index][0][1] - GameSettings::BUTTON_PADDING, GameSettings::COLOR["white_600"],
            button_bounding_box[index][1][0] + GameSettings::BUTTON_PADDING, button_bounding_box[index][1][1] + GameSettings::BUTTON_PADDING, GameSettings::COLOR["white_600"],
            button_bounding_box[index][0][0] - GameSettings::BUTTON_PADDING, button_bounding_box[index][1][1] + GameSettings::BUTTON_PADDING, GameSettings::COLOR["white_600"],
            ZOrder::MIDDLE,
        )

        if mouse_over_button(mouse_x, mouse_y, button_bounding_box[index])
            button_hover_bg.draw_as_quad(
                button_bounding_box[index][0][0] - GameSettings::BUTTON_PADDING, button_bounding_box[index][0][1] - GameSettings::BUTTON_PADDING, GameSettings::COLOR["white_600"],
                button_bounding_box[index][1][0] + GameSettings::BUTTON_PADDING, button_bounding_box[index][0][1] - GameSettings::BUTTON_PADDING, GameSettings::COLOR["white_600"],
                button_bounding_box[index][1][0] + GameSettings::BUTTON_PADDING, button_bounding_box[index][1][1] + GameSettings::BUTTON_PADDING, GameSettings::COLOR["white_600"],
                button_bounding_box[index][0][0] - GameSettings::BUTTON_PADDING, button_bounding_box[index][1][1] + GameSettings::BUTTON_PADDING, GameSettings::COLOR["white_600"],
                ZOrder::MIDDLE,
            )
        end
    end

    x_offset = 30
    font_subtitle = Gosu::Font.new(20, { :name => GameSettings::FONT["title"] })
    for i in 0..(GameRules::BOARD_OPTIONS.length - 1)
        score_board_width = (GameSettings::SCREEN_WIDTH - (GameRules::BOARD_OPTIONS[i].length + 1) * 30) / GameRules::BOARD_OPTIONS[i].length
        for j in 0..(GameRules::BOARD_OPTIONS[i].length - 1)
            scores = get_scores(GameRules::BOARD_OPTIONS[i][j][0])
            y_offset = GameSettings::SCREEN_HEIGHT * 0.2 + font_text.height * 11.5 * i

            font_subtitle.draw_text(
                "#{GameRules::BOARD_OPTIONS[i][j][0]} scoreboard",
                x_offset,
                y_offset,
                ZOrder::TOP,
                1.0,
                1.0,
                GameSettings::COLOR["black_600"]
            )
            Gosu.draw_rect(
                x_offset - GameSettings::BUTTON_PADDING,
                y_offset - GameSettings::BUTTON_PADDING,
                score_board_width + GameSettings::BUTTON_PADDING * 2,
                font_text.height * 1.5 * 6 + GameSettings::BUTTON_PADDING * 2,
                GameSettings::COLOR["yellow_200"],
                ZOrder::MIDDLE
            )
            y_offset += font_text.height * 1.5

            for id in 0..(GameSettings::SCORE_LIMIT - 1)
                text = "#{id + 1}. "
                if id < scores.length
                    text = text.concat(format_duration(scores[id]).to_s())
                end

                font_text.draw_text(
                    text,
                    x_offset,
                    y_offset,
                    ZOrder::TOP,
                    1.0,
                    1.0,
                    GameSettings::COLOR["black_600"]
                )
                y_offset += font_text.height * 1.5
            end

            x_offset += score_board_width + 30
        end
        x_offset = 30
    end
end

def score_input(game, key_id)
    if key_id == 0
        game.change_scene(Scene::MENU)
        return true
    end
    return false
end

def score_process(game, game_state, key_id)
    score_input(game, key_id)
end
