require 'gosu'
require './global.rb'

def is_valid_cell(x, y, width, height)
    return (0 <= x && x < width && 0 <= y && y < height)
end

def manhattan_distance(x1, y1, x2, y2)
    return ((x1 - x2).abs() + (y1 - y2).abs())
end

def nearby_mines(x, y, width, height, board)
    count = 0
    for i in (y - 1)..(y + 1)
        for j in (x - 1)..(x + 1)
            if is_valid_cell(j, i, width, height) && board[i][j] == -1
                count += 1
            end
        end
    end

    return count
end

def gen_mines(board, width, height, mines, seed, x, y)
    srand((Time.new().to_f() * 1000000).to_i())
    if !seed
        # embed first open inside seed
        seed = (rand() * (10 ** 16)).round() * 100 + x * 10 + y
    end

    cells = []
    for i in 0..(height - 1)
        for j in 0..(width - 1)
            # The first cell and 9 cells around it must not contain mines
            if Math.sqrt((j - x) ** 2 + (i - y) ** 2) < 2.0
                next
            end

            cells << [i, j]
        end
    end

    cells.shuffle!(random: Random.new(seed))

    for i in 0..(mines - 1)
        board[cells[i][0]][cells[i][1]] = -1
    end

    return seed
end

def gen_board(board, width, height, mines, seed, x, y)
    seed = gen_mines(board, width, height, mines, seed, x, y)

    for i in 0..(height - 1)
        for j in 0..(width - 1)
            if board[i][j] != -1
                board[i][j] = nearby_mines(j, i, width, height, board)
            end
        end
    end

    return seed
end

def saw_gen_board(board, width, height, mines, seed, x, y)
    drow = [-1, 0, 0, 1]
    dcol = [0, -1, 1, 0]
    cell_queue = Queue.new()

    seed = gen_mines(board, width, height, mines, seed, x, y)

    for i in 0..(height - 1)
        for j in 0..(width - 1)
            if board[i][j] == -1
                cell_queue << [i, j]
            end
        end
    end

    while !cell_queue.empty?()
        cell = cell_queue.pop()
        y = cell[0]
        x = cell[1]

        for i in 0..3
            row = y + drow[i]
            col = x + dcol[i]

            if is_valid_cell(col, row, width, height) && board[row][col] == 0
                if board[y][x] == -1
                    board[row][col] = 1
                else
                    board[row][col] = board[y][x] + 1
                end

                cell_queue << [row, col]
            end
        end
    end

    return seed
end

def open_cell(x, y, game_state)
    if game_state.seed == nil
        populate_board(game_state, x, y)
    end

    if game_state.board[y][x] == -1
        game_state.mask[y][x] = 1
        return true
    end
    if game_state.board[y][x] == 0
        mass_open(x, y, game_state.width, game_state.height, game_state.board, game_state.mask)
    else
        game_state.mask[y][x] = 1
    end
    return false
end

def flag_cell(x, y, flags, mask)
    if mask[y][x] == -1
        mask[y][x] = 0
        flags -= 1
    else
        mask[y][x] = -1
        flags += 1
    end

    return flags
end

def mass_open(x, y, width, height, board, mask)
    drow = [-1, -1, -1, 0, 0, 1, 1, 1]
    dcol = [-1, 0, 1, -1, 1, -1, 0, 1]

    mask[y][x] = 1

    if board[y][x] != 0
        return
    end

    for i in 0..7
        row = y + drow[i]
        col = x + dcol[i]
        if is_valid_cell(col, row, width, height) && board[row][col] != -1 && mask[row][col] == 0
            mass_open(col, row, width, height, board, mask)
        end
    end
end

def check_win(flags, mines, width, height, board, mask)
    if flags != mines
        return false
    end

    for row in 0..(height - 1)
        for column in 0..(width - 1)
            if mask[row][column] == 0 && board[row][column] != -1
                return false
            end
        end
    end

    return true
end

def draw_board(width, height, board, mask, font_text, button_bounding_box, mouse_x, mouse_y)
    # Draw borders
    Gosu.draw_rect(
        button_bounding_box[0][0][0] - GameSettings::BUTTON_PADDING,
        button_bounding_box[0][0][1] - GameSettings::BUTTON_PADDING,
        button_bounding_box[-2][1][0] - button_bounding_box[0][0][0] + GameSettings::BUTTON_PADDING * 2,
        button_bounding_box[-2][1][1] - button_bounding_box[0][0][1] + GameSettings::BUTTON_PADDING * 2,
        GameSettings::COLOR["blue_900"],
        ZOrder::MIDDLE,
        mode=:default
    )

    for row in 0..(height - 1)
        for column in 0..(width - 1)
            index = row * width + column
            text = ""
            color = GameSettings::COLOR["gray_400"]
            background = GameSettings::COLOR["black_400"]

            if mask[row][column] == -1
                text = "F"
                color = GameSettings::COLOR["yellow_400"]
            elsif mask[row][column] == 0 || mask[row][column] > 1
            elsif board[row][column] == -1
                text = '*'
                color = GameSettings::COLOR["red_400"]
            elsif board[row][column] == 0
                text = board[row][column].to_s()
            else
                text = board[row][column].to_s()
                color = GameSettings::COLOR["green_400"]
            end

            if (
                mouse_over_button(mouse_x, mouse_y, button_bounding_box[index]) ||
                mask[row][column] > 1
            )
                background = GameSettings::COLOR["blue_400"]
            end
            
            Gosu.draw_rect(
                button_bounding_box[index][0][0],
                button_bounding_box[index][0][1],
                button_bounding_box[index][1][0] - button_bounding_box[index][0][0],
                button_bounding_box[index][1][1] - button_bounding_box[index][0][1],
                background,
                ZOrder::MIDDLE,
                mode=:default
            )
            font_text.draw_text(
                text,
                button_bounding_box[index][0][0],
                button_bounding_box[index][0][1],
                ZOrder::TOP,
                1.0,
                1.0,
                color
            )
            
        end
    end
end

def save_board(width, height, mines, seed, flags, duration, max_time, mask)
    File.open("board.txt", "w") do |file|
        file.write("#{width} #{height} #{mines} #{seed || -1} #{flags} #{duration} #{max_time}\n")
        
        for i in 0..(height - 1)
            for j in 0..(width - 1)
                file.write("#{mask[i][j]}\t")
            end
            file.write("\n")
        end
    end
end

def clear_flag(game_state)
    for row in 0..(game_state.height - 1)
        for column in 0..(game_state.width - 1)
            if game_state.mask[row][column] == -1
                game_state.mask[row][column] = 0
            end
        end
    end

    game_state.flags = 0
end

# play the best move based on the current state
# return [x, y, action]
# action: 2 -> flag, 3 -> open
def get_next_move(game_state)
    # open middle cell on first move
    if game_state.seed == nil
        return [game_state.width / 2, game_state.height / 2, 3]
    end

    guess_factor = 2
    drow = [-1, -1, -1, 0, 0, 1, 1, 1]
    dcol = [-1, 0, 1, -1, 1, -1, 0, 1]
    weights = Array.new(game_state.height) { Array.new(game_state.width, 0) }

    for row in 0..(game_state.height - 1)
        for column in 0..(game_state.width - 1)
            # remove highlighting
            if game_state.mask[row][column] > 1
                game_state.mask[row][column] = 0
            end

            if game_state.mask[row][column] != 1 || game_state.board[row][column] == 0
                next
            end

            count_empty = 0.0
            count_flag = 0
            for i in 0..7
                a_row = row + drow[i]
                a_col = column + dcol[i]
                if is_valid_cell(a_col, a_row, game_state.width, game_state.height)
                    if game_state.mask[a_row][a_col] == 0
                        count_empty += 1
                    end

                    if game_state.mask[a_row][a_col] == -1
                        count_flag += 1 
                    end
                end
            end

            if count_flag >= game_state.board[row][column]
                weight = -Float::INFINITY
            else
                weight = (game_state.board[row][column] - count_flag) / (count_empty - 1.0)
            end

            for i in 0..7
                a_row = row + drow[i]
                a_col = column + dcol[i]
                if is_valid_cell(a_col, a_row, game_state.width, game_state.height) && game_state.mask[a_row][a_col] == 0
                    weights[a_row][a_col] += weight
                end
            end
        end
    end

    min = Float::INFINITY
    s_row = -1
    s_col = -1
    for row in 0..(game_state.height - 1)
        for column in 0..(game_state.width - 1)
            if game_state.mask[row][column] != 0
                next
            end

            if weights[row][column] == -Float::INFINITY
                min = weights[row][column]
                s_row = row
                s_col = column
                break
            end

            if weights[row][column] == Float::INFINITY
                return [column, row, 2]
            end

            if weights[row][column] < min
                min = weights[row][column]
                s_row = row
                s_col = column
            elsif (
                (weights[row][column] - min).abs() < Float::EPSILON &&
                Random.random_number(guess_factor) == 0
            )
                s_row = row
                s_col = column
            end
        end

        if weights[s_row][s_col] == -Float::INFINITY
            break
        end
    end

    return [s_col, s_row, 3]
end

def reset_board(game_state)
    game_state.flags = 0
    game_state.board.clear()
    game_state.mask.clear()
end

def get_blank_board(game_state, width, height, mines, max_time, seed)
    game_state.width = width
    game_state.height = height
    game_state.mines = mines
    game_state.max_time = max_time
    game_state.seed = seed

    for i in 0..(height - 1)
        board_row = Array.new(width, 0)
        game_state.board << board_row

        mask_row = Array.new(width, 0)
        game_state.mask << mask_row
    end
end

def init_board(game_state, width, height, mines, max_time, seed = nil)
    game_state.auto = false
    game_state.start_time = nil
    reset_board(game_state)
    get_blank_board(game_state, width, height, mines, max_time, seed)
end

def populate_board(game_state, x = -10, y = -10)
    case game_state.mode
    when 0
        game_state.seed = gen_board(game_state.board, game_state.width, game_state.height, game_state.mines, game_state.seed, x, y)
    when 1
        game_state.seed = saw_gen_board(game_state.board, game_state.width, game_state.height, game_state.mines, game_state.seed, x, y)
        game_state.remaining_mines = game_state.mines
    end

    game_state.start_time = Time.new()
end

def load_board(game_state)
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
    width, height, mines, seed, flags, duration, max_time = board_info
    seed = (seed == -1 ? nil : seed)

    init_board(game_state, width, height, mines, max_time, seed)
    if seed != nil
        x = seed % 100 / 10
        y = seed % 10
        populate_board(game_state, x, y)
    end

    game_state.flags = flags
    game_state.start_time = (
        seed ?
        Time.at(game_state.start_time.to_f() - duration.to_f() / 1000.0) :
        nil
    )

    # Read mask
    for i in 0..(height - 1)
        mask_info = file.gets().split()
        mask_info.map!() do |element|
            element.to_i()
        end

        for j in 0..(width - 1)
            game_state.mask[i][j] = mask_info[j]
        end
    end

    file.close()

    return true
end

def board()
    # Driver code for testing
    board = [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
    ]
    seed = 0

    gen_board(board, 4, 4, 5, seed)
    for i in 0..(board.length - 1)
        for j in 0..(board[0].length - 1)
            print("#{board[i][j]} ")
        end
        puts()
    end

    board = [[1, 2], [-1, -1]]
    mask = [[1, 0], [-1, 1]]
    draw_board(2, 2, board, mask)
end

if __FILE__ == $0
    board()
end
