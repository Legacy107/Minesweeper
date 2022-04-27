require "io/console"
require "gosu"
require "./util.rb"
require "./minesweeper.rb"
require "./global.rb"
require "./menu_scene.rb"
require "./chooser_scene.rb"
require "./game_scene.rb"
require "./end_scene.rb"
require "./score_scene.rb"
require "./saw_game_scene.rb"

class GameWindow < Gosu::Window
    def initialize()
        super($screen_width, $screen_height, false)
        self.caption = "Minesawyer"

        @background = Gosu::Color::WHITE
        @font_title = Gosu::Font.new(26)
        @font_text = Gosu::Font.new(20)
        @button_bounding_box = [-1]
        @prev_key = nil
        @game = Minesweeper.new()
        @game.add_scene(Scene::MENU, method(:menu_process), method(:menu_draw), method(:menu_gen_box))
        @game.add_scene(Scene::CHOOSER, method(:chooser_process), method(:chooser_draw), method(:chooser_gen_box))
        @game.add_scene(Scene::FINISH, method(:end_process), method(:end_draw), method(:end_gen_box))
        @game.add_scene(Scene::GAME, method(:game_process), method(:game_draw), method(:game_gen_box))
        @game.add_scene(Scene::SAW, method(:saw_game_process), method(:saw_game_draw), method(:saw_gen_box))
        @game.add_scene(Scene::SCORE, method(:score_process), method(:score_draw), method(:score_gen_box))
        @game.change_scene(Scene::MENU)

        @sfx_open = Gosu::Sample.new($tracks["open"])
        @sfx_flag = Gosu::Sample.new($tracks["flag"])
    end
  
    def needs_cursor?()
        true
    end

    def update()
        if @button_bounding_box.last() != @game.current_scene
            @button_bounding_box = @game.gen_bounding_box[@game.current_scene].call(@game, @font_title, @font_text)
        end

        if @game.process(nil)
            $stdout.clear_screen()
            close()
        end
    end
  
    def draw()
        Gosu.draw_rect(0, 0, $screen_width, $screen_height, @background, ZOrder::BACKGROUND, mode=:default)
        @game.draw(@font_title, @font_text, @button_bounding_box, mouse_x, mouse_y)
    end

    def button_down(id)
        case id
        when Gosu::MsLeft
            @button_bounding_box.each_with_index do |button, index|
                if mouse_over_button(mouse_x, mouse_y, button)
                    @sfx_open.play()
                    @game.process(index)
                end
            end
        when Gosu::KB_M
            @button_bounding_box.each_with_index do |button, index|
                if mouse_over_button(mouse_x, mouse_y, button)
                    @sfx_flag.play()
                    @game.process(-index)
                end
            end
        when Gosu::KB_ESCAPE
            close()
        else
            @game.process(id)
        end
    end
end

def main()
    window = GameWindow.new()
    window.show()
end

if __FILE__ == $0
    main()
end
