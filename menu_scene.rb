require "gosu"
require "./global.rb"
require "./minesweeper.rb"
require "./util.rb"

def menu_get_buttons()
    return ["NEW GAME", "CONTINUE", "SCOREBOARD", "MINESAWYER", "CREDIT", "EXIT"]
end

def menu_gen_box(game, font_title, font_text)
    bounding_box = []
    y_offset = GameSettings::SCREEN_HEIGHT * 0.25 + font_title.height * 2.5 # below game title

    menu_get_buttons().each() do |button|
        x_start = center_text(font_text, button, GameSettings::SCREEN_WIDTH)
        bounding_box << [
            [x_start, y_offset],
            [x_start + font_text.text_width(button), y_offset + font_text.height]
        ]
        y_offset += font_text.height * 2.5
    end
    bounding_box << Scene::MENU

    return bounding_box
end

def menu_draw(game, font_title, font_text, button_bounding_box, mouse_x, mouse_y)
    title_image = Gosu::Image.new(GameSettings::SPRITE["title"])
    title_image.draw(
        center_image(title_image, 0.8, GameSettings::SCREEN_WIDTH),
        GameSettings::SCREEN_HEIGHT * 0.2,
        ZOrder::TOP,
        0.8,
        0.8
    )

    button_bg = Gosu::Image.new(GameSettings::SPRITE["button"])
    button_hover_bg = Gosu::Image.new(GameSettings::SPRITE["button_hover"])
    menu_get_buttons().each_with_index() do |button, index|
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
end

def menu_input(game, key_id)
    if key_id == 0
        game.mode = 0
        game.change_scene(Scene::CHOOSER)
        return true
    end
    if key_id == 1
        game.mode = 0;
        if !game.load_board()
            return false
        end
        game.change_scene(Scene::GAME)
        return true
    end
    if key_id == 2
        game.change_scene(Scene::SCORE)
        return true
    end
    if key_id == 3
        game.mode = 1
        game.change_scene(Scene::CHOOSER)
        return true
    end
    if key_id == 4
        game.change_scene(Scene::CREDIT)
        return true
    end
    if key_id == 5
        game.change_scene(Scene::EXIT)
        return true
    end

    return false
end

def menu_process(game, key_id)
    menu_input(game, key_id)
end
