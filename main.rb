require "io/console"
require "gosu"
require "./minesweeper.rb"
require "./global.rb"
require "./menu_scene.rb"
require "./chooser_scene.rb"
require "./game_scene.rb"
require "./end_scene.rb"
require "./score_scene.rb"
require "./saw_game_scene.rb"

$screen_width = 720
$screen_height = 480

class GameWindow < Gosu::Window
    def initialize()
        super($screen_width, $screen_height, false)
        self.caption = "Minesawyer"

        @prev_key = nil
        @game = Minesweeper.new()
        @game.add_scene(Scene::MENU, method(:menu_scene), method(:menu_draw))
        @game.add_scene(Scene::CHOOSER, method(:chooser_scene), method(:chooser_draw))
        @game.add_scene(Scene::FINISH, method(:end_scene), method(:end_draw))
        @game.add_scene(Scene::GAME, method(:game_scene), method(:game_draw))
        @game.add_scene(Scene::SAW, method(:saw_game_scene), method(:saw_game_draw) )
        @game.add_scene(Scene::SCORE, method(:score_scene), method(:score_draw))
    end
  
    def needs_cursor?()
        true
    end

    def update()
        if @game.process(nil)
            $stdout.clear_screen()
            close()
        end
    end
  
    def draw()
        $stdout.clear_screen()
        @game.draw()
    end

    def button_down(id)
        if id == Gosu::KB_ESCAPE
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

# def main()
    # Initialize
    # SetConsoleTitle("Minesawyer");
    
    # show_cursor(false);

    # // Cleanup
    # system("cls")
    # show_cursor(true)
# end
