require "gosu"
require "./global.rb"
require "./util.rb"

class Minesweeper
    attr_accessor :gen_bounding_box
    attr_reader :current_scene

    def initialize
        @process_scenes = {}
        @draw_scenes = {}
        @gen_bounding_box = {}
        @current_scene = nil;
        @track = nil
        @track_location = ""
    end

    def add_scene(id, scene_process, scene_draw, scene_gen_bounding_box)
        @process_scenes[id] = scene_process
        @draw_scenes[id] = scene_draw
        @gen_bounding_box[id] = scene_gen_bounding_box
    end

    def process(game_state, key_id)
        if @current_scene != Scene::EXIT
            @process_scenes[@current_scene].call(self, game_state, key_id)
            return false
        end
        return true
    end

    def draw(game_state, font_title, font_text, button_bounding_box, mouse_x, mouse_y)
        if @current_scene != Scene::EXIT
            @draw_scenes[@current_scene].call(game_state, font_title, font_text, button_bounding_box, mouse_x, mouse_y)
        end
    end

    def change_scene(scene)
        @current_scene = scene
        if (GameSettings::TRACKS[scene] && @track_location != GameSettings::TRACKS[scene])
            @track_location = GameSettings::TRACKS[scene]
            @track = Gosu::Song.new(@track_location)
            @track.volume = 0.25
            @track.play(looping=true)
        end
    end
end
