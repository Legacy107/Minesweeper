require "gosu"
require "./global.rb"
require "./minesweeper.rb"

def menu_draw(game)
    puts("============")
    puts(" MINESAWYER ")
    puts("============")
    puts()
    puts("NEW GAME (N)")
    puts("CONTINUE (C)")
    puts("SCOREBOARD (S)")
    puts("MINESAWYER (I)")
    puts("EXIT (E)")
    puts()
    puts("Press the key after each option to choose")
end

def menu_input(game, key_id)
    if key_id == Gosu::KB_N
        game.mode = 0
        game.change_scene(Scene::CHOOSER)
        return true
    end
    if key_id == Gosu::KB_C
        game.mode = 0;
        if (!game.load_board())
            return false
        end
        game.change_scene(Scene::GAME)
        return true
    end
    if key_id == Gosu::KB_S
        game.change_scene(Scene::SCORE)
        return true
    end
    if key_id == Gosu::KB_I
        game.mode = 1
        game.change_scene(Scene::CHOOSER)
        return true
    end
    if key_id == Gosu::KB_E
        game.change_scene(Scene::EXIT)
        return true
    end

    return false
end

def menu_scene(game, key_id)
    menu_input(game, key_id)
end
