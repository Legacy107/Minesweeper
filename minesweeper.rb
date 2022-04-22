require "./global.rb"
require "./util.rb"

class Minesweeper
    attr_accessor :mode, :flags, :remaining_mines, :start_time, :score, :gen_bounding_box, :auto, :tick
    attr_reader :mines, :width, :height, :board, :mask, :seed, :current_scene

    def initialize        
        @process_scenes = {}
        @draw_scenes = {}
        @gen_bounding_box = {}
        @current_scene = Scene::MENU;
        @board = []
        @mask = []
        @width = 0
        @height = 0
        @mines = 0
        @remaining_mines = 0 # for minesawyer mode
        @seed = 0
        @flags = 0
        @mode = 0 # 0: minesweeper  1: minesawyer
        @start_time = 0
        @score = nil
        @auto = false
        @tick = 0
    end

    def add_scene(id, scene_process, scene_draw, scene_gen_bounding_box)
        @process_scenes[id] = scene_process
        @draw_scenes[id] = scene_draw
        @gen_bounding_box[id] = scene_gen_bounding_box
    end

    def process(key_id)
        if @current_scene != Scene::EXIT
            @process_scenes[@current_scene].call(self, key_id)
            return false
        end
        return true
    end

    def draw(font_title, font_text, button_bounding_box, mouse_x, mouse_y)
        if @current_scene != Scene::EXIT
            @draw_scenes[@current_scene].call(self, font_title, font_text, button_bounding_box, mouse_x, mouse_y)
        end
    end

    def change_scene(scene)
        @current_scene = scene
    end

    def reset_board()
        @flags = 0
        @board.clear()
        @mask.clear()
    end

    def get_blank_board(width, height, mines, seed)
        @width = width
        @height = height
        @mines = mines
        @seed = seed

        for i in 0..(height - 1)
            board_row = Array.new(width, 0)
            @board << board_row

            mask_row = Array.new(width, 0)
            @mask << mask_row
        end
    end

    def create_board(width, height, mines, seed = nil)
        reset_board()

        get_blank_board(width, height, mines, seed)

        if @mode == 0
            @seed = gen_board(@board, width, height, mines, seed)
        elsif @mode == 1
            @seed = saw_gen_board(@board, width, height, mines, seed)
            @remaining_mines = mines
        end

        @start_time = Time.new()
    end

    def load_board()
        duration = 0
        file = File.open("board.txt")

        # No board is found
        board_info = file.gets()
        if !board_info
            file.close()
            return false
        end
        board_info = board_info.split()
        board_info.map!() do |element|
            element.to_i()
        end
        
        # Read board
        width, height, mines, seed, flags, duration = board_info

        create_board(width, height, mines, seed)

        @flags = flags
        @start_time = Time.at(@start_time.to_f() - duration.to_f() / 10000.0)

        # Read mask
        for i in 0..(height - 1)
            mask_info = file.gets().split()
            mask_info.map!() do |element|
                element.to_i()
            end

            for j in 0..(width - 1)
                mask[i][j] = mask_info[j]
            end
        end

        file.close()

        return true
    end
end
