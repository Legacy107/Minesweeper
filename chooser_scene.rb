require "gosu"
require "./global.rb"
require "./minesweeper.rb"

def chooser_get_buttons(game)
    buttons = []

    $board_options[game.mode].each_with_index() do |board_option, index|
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
    y_offset = $screen_height * 0.15 + font_title.height * 3 # below the title

    chooser_get_buttons(game).each() do |button|
        x_start = center_text(font_text, button, $screen_width)
        bounding_box << [
            [x_start, y_offset],
            [x_start + font_text.text_width(button), y_offset + font_text.height]
        ]
        y_offset += font_text.height * 2
    end
    bounding_box << Scene::CHOOSER

    return bounding_box
end

def chooser_draw(game, font_title, font_text, button_bounding_box, mouse_x, mouse_y)
    font_title.draw_text(
        "Choose a board",
        center_text(font_title, "Choose a board", $screen_width),
        $screen_height * 0.15,
        ZOrder::TOP,
        1.0,
        1.0,
        Gosu::Color::BLACK
    )

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

        if mouse_over_button(mouse_x, mouse_y, button_bounding_box[index])
            Gosu.draw_rect(
                button_bounding_box[index][0][0] - $button_padding,
                button_bounding_box[index][0][1] - $button_padding,
                button_bounding_box[index][1][0] - button_bounding_box[index][0][0] + $button_padding * 2,
                button_bounding_box[index][1][1] - button_bounding_box[index][0][1] + $button_padding * 2,
                Gosu::Color::YELLOW,
                ZOrder::MIDDLE,
                mode=:default
            )

            if index == buttons.length - 1 && game.mode == 1
                y_offset = button_bounding_box[index][1][1] + font_text.height
                width = ($minesawyer_rules.map() {|rule| font_text.text_width(rule)}).max()

                Gosu.draw_rect(
                    ($screen_width - width) / 2.0 - $button_padding,
                    y_offset - $button_padding,
                    width + $button_padding * 2,
                    font_text.height * 1.5 * $minesawyer_rules.length + $button_padding * 2,
                    Gosu::Color::YELLOW,
                    ZOrder::MIDDLE,
                    mode=:default
                )

                $minesawyer_rules.each() do |rule|
                    font_text.draw_text(
                        rule,
                        center_text(font_text, rule, $screen_width),
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
    for i in 0..($board_options[game.mode].length - 1)
        if key_id == keys[i]
            game.create_board(
                $board_options[game.mode][i][1],
                $board_options[game.mode][i][2],
                $board_options[game.mode][i][3]
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
