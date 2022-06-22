require "gosu"
require_relative "./utils/util.rb"
require_relative "./scenes/minesweeper.rb"
require_relative "./utils/game_state.rb"
require_relative "./utils/global.rb"
require_relative "./scenes/menu_scene.rb"
require_relative "./scenes/chooser_scene.rb"
require_relative "./scenes/game_scene.rb"
require_relative "./scenes/end_scene.rb"
require_relative "./scenes/score_scene.rb"
require_relative "./scenes/saw_game_scene.rb"
require_relative "./scenes/credit_scene.rb"

class GameWindow < Gosu::Window
    def initialize()
        super(GameSettings::SCREEN_WIDTH, GameSettings::SCREEN_HEIGHT, {fullscreen: false})
        self.caption = "Minesawyer"

        @background = Gosu::Image.new(GameSettings::SPRITE["background"], { :tileable => true })
        @font_title = Gosu::Font.new(35, { :name => GameSettings::FONT["title"] })
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
        @game.add_scene(Scene::CREDIT, method(:credit_process), method(:credit_draw), method(:credit_gen_box))
        @game.change_scene(Scene::MENU)
        @game_state = get_new_game_state()

        @sfx_open = Gosu::Sample.new(GameSettings::TRACKS["open"])
        @sfx_flag = Gosu::Sample.new(GameSettings::TRACKS["flag"])
    end
  
    def needs_cursor?()
        true
    end

    def update()
        # Get bounding boxes of all buttons in the current scene
        # so that button clicking can be tracked
        if (
            @button_bounding_box.last() != @game.current_scene &&
            @game.gen_bounding_box[@game.current_scene]
        )
            @button_bounding_box = @game.gen_bounding_box[@game.current_scene].call(@game_state, @font_title, @font_text)
        end

        if @game.process(@game_state, nil)
            close()
        end
    end

    def draw_background()
        # Repeat the sprite in a grid to form a background
        bg_x = 0
        while bg_x < GameSettings::SCREEN_WIDTH
            bg_y = 0
            while bg_y < GameSettings::SCREEN_HEIGHT
                @background.draw(
                    bg_x, bg_y,
                    ZOrder::BACKGROUND,
                    1, 1
                )
                bg_y += @background.height
            end
            bg_x += @background.width
        end
    end
  
    def draw()
        self.draw_background()
        @game.draw(@game_state, @font_title, @font_text, @button_bounding_box, mouse_x, mouse_y)
    end

    def button_down(id)
        case id
        when Gosu::MsLeft
            @button_bounding_box.each_with_index do |button, index|
                if mouse_over_button(mouse_x, mouse_y, button)
                    @sfx_open.play()
                    @game.process(@game_state, index)
                end
            end
        when Gosu::MsRight
            @button_bounding_box.each_with_index do |button, index|
                if mouse_over_button(mouse_x, mouse_y, button)
                    @sfx_flag.play()
                    @game.process(@game_state, -index)
                end
            end
        when Gosu::KB_F
            self.fullscreen = !self.fullscreen?
        when Gosu::KB_ESCAPE
            close()
        else
            @game.process(@game_state, nil)
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
