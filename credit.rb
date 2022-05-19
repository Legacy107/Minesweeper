require "gosu"
require "./global.rb"
require "./util.rb"

def credit_gen_box(game, font_title, font_text)
    bounding_box = []

    bounding_box << [
        [10, 10],
        [10 + font_text.text_width("Back"), 10 + font_text.height]
    ]
    return bounding_box
end

def credit_draw(game, font_title, font_text, button_bounding_box, mouse_x, mouse_y)
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

    y_offset = GameSettings::SCREEN_HEIGHT * 0.15
    GameSettings::CREDIT.each() do |key, authors|
        font_title.draw_text(
            key,
            center_text(font_title, key, GameSettings::SCREEN_WIDTH),
            y_offset,
            ZOrder::TOP,
            1.0,
            1.0,
            GameSettings::COLOR["black_600"]
        )
        y_offset += font_title.height * 1.5
        
        authors.each() do |author|
            font_text.draw_text(
                author,
                center_text(font_text, author, GameSettings::SCREEN_WIDTH),
                y_offset,
                ZOrder::TOP,
                1.0,
                1.0,
                GameSettings::COLOR["black_600"]
            )
            y_offset += font_text.height * 1.5
        end

        y_offset += font_text.height * 1.5
    end
end

def credit_input(game, key_id)
    if key_id == 0
        game.change_scene(Scene::MENU)
        return true
    end
    return false
end

def credit_process(game, key_id)
    credit_input(game, key_id)
end
