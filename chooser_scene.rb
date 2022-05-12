require "gosu"
require "./global.rb"
require "./minesweeper.rb"

def chooser_get_buttons(game)
    buttons = []

    GameRules::BOARD_OPTIONS[game.mode].each_with_index() do |board_option, index|
        button = ""
        button << "#{board_option[0]} "
        button << "#{board_option[1]} x "
        button << "#{board_option[2]} "
        button << "#{board_option[3]} mines"
        
        buttons << button
    end
    buttons << "Back to main menu"
    if (game.mode == 1)
        buttons << "Minesawyer's rules"
    end
    
    return buttons
end

def chooser_gen_box(game, font_title, font_text)
    bounding_box = []
    y_offset = GameSettings::SCREEN_HEIGHT * 0.15 + font_title.height * 2.5 # below the title

    chooser_get_buttons(game).each() do |button|
        x_start = center_text(font_text, button, GameSettings::SCREEN_WIDTH)
        bounding_box << [
            [x_start, y_offset],
            [x_start + font_text.text_width(button), y_offset + font_text.height]
        ]
        y_offset += font_text.height * 2.5
    end
    bounding_box << Scene::CHOOSER

    return bounding_box
end

def chooser_draw(game, font_title, font_text, button_bounding_box, mouse_x, mouse_y)
    font_title.draw_text(
        "Choose a board",
        center_text(font_title, "Choose a board", GameSettings::SCREEN_WIDTH),
        GameSettings::SCREEN_HEIGHT * 0.15,
        ZOrder::TOP,
        1.0,
        1.0,
        Gosu::Color::BLACK
    )

    button_bg = Gosu::Image.new(GameSettings::SPRITE["button"])
    button_hover_bg = Gosu::Image.new(GameSettings::SPRITE["button_hover"])
    buttons = chooser_get_buttons(game)
    buttons.each_with_index() do |button, index|
        font_text.draw_text(
            button,
            button_bounding_box[index][0][0],
            button_bounding_box[index][0][1],
            ZOrder::TOP,
            1.0,
            1.0,
            Gosu::Color::BLACK
        )
        button_bg.draw_as_quad(
            button_bounding_box[index][0][0] - GameSettings::BUTTON_PADDING, button_bounding_box[index][0][1] - GameSettings::BUTTON_PADDING, Gosu::Color::WHITE,
            button_bounding_box[index][1][0] + GameSettings::BUTTON_PADDING, button_bounding_box[index][0][1] - GameSettings::BUTTON_PADDING, Gosu::Color::WHITE,
            button_bounding_box[index][1][0] + GameSettings::BUTTON_PADDING, button_bounding_box[index][1][1] + GameSettings::BUTTON_PADDING, Gosu::Color::WHITE,
            button_bounding_box[index][0][0] - GameSettings::BUTTON_PADDING, button_bounding_box[index][1][1] + GameSettings::BUTTON_PADDING, Gosu::Color::WHITE,
            ZOrder::MIDDLE,
        )

        if mouse_over_button(mouse_x, mouse_y, button_bounding_box[index])
            button_hover_bg.draw_as_quad(
                button_bounding_box[index][0][0] - GameSettings::BUTTON_PADDING, button_bounding_box[index][0][1] - GameSettings::BUTTON_PADDING, Gosu::Color::WHITE,
                button_bounding_box[index][1][0] + GameSettings::BUTTON_PADDING, button_bounding_box[index][0][1] - GameSettings::BUTTON_PADDING, Gosu::Color::WHITE,
                button_bounding_box[index][1][0] + GameSettings::BUTTON_PADDING, button_bounding_box[index][1][1] + GameSettings::BUTTON_PADDING, Gosu::Color::WHITE,
                button_bounding_box[index][0][0] - GameSettings::BUTTON_PADDING, button_bounding_box[index][1][1] + GameSettings::BUTTON_PADDING, Gosu::Color::WHITE,
                ZOrder::MIDDLE,
            )

            if index == buttons.length - 1 && game.mode == 1
                y_offset = button_bounding_box[index][1][1] + font_text.height
                width = (GameRules::MINESAWYER_RULES.map() {|rule| font_text.text_width(rule)}).max()

                Gosu.draw_rect(
                    (GameSettings::SCREEN_WIDTH - width) / 2.0 - GameSettings::BUTTON_PADDING,
                    y_offset - GameSettings::BUTTON_PADDING,
                    width + GameSettings::BUTTON_PADDING * 2,
                    font_text.height * 1.5 * GameRules::MINESAWYER_RULES.length + GameSettings::BUTTON_PADDING * 2,
                    Gosu::Color::YELLOW,
                    ZOrder::MIDDLE,
                    mode=:default
                )

                GameRules::MINESAWYER_RULES.each() do |rule|
                    font_text.draw_text(
                        rule,
                        center_text(font_text, rule, GameSettings::SCREEN_WIDTH),
                        y_offset,
                        ZOrder::TOP,
                        1.0,
                        1.0,
                        Gosu::Color::BLACK
                    )

                    y_offset += font_text.height * 1.5
                end
            end
        end
    end

end

def chooser_input(game, key_id)
    keys = [0, 1, 2]
    for i in 0..(GameRules::BOARD_OPTIONS[game.mode].length - 1)
        if key_id == keys[i]
            game.init_board(
                GameRules::BOARD_OPTIONS[game.mode][i][1],
                GameRules::BOARD_OPTIONS[game.mode][i][2],
                GameRules::BOARD_OPTIONS[game.mode][i][3],
                GameRules::BOARD_OPTIONS[game.mode][i][4]
            )

            if game.mode == 0
                game.change_scene(Scene::GAME)
            elsif game.mode == 1
                game.change_scene(Scene::SAW)
            end

            return true
        end
    end

    if key_id == 3
        game.change_scene(Scene::MENU)
        return true
    end

    return false;
end

def chooser_process(game, key_id)
    chooser_input(game, key_id)
end
