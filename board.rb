require 'io/console'
require 'colorize'
require 'gosu'

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

def gen_mines(board, width, height, mines, seed)
    srand((Time.new().to_f() * 1000000).to_i())
    if !seed
        seed = (rand() * (10 ** 16)).round()
    end

    cells = []
    for i in 0..(height - 1)
        for j in 0..(width - 1)
            cells << [i, j]
        end
    end

    cells.shuffle!(random: Random.new(seed))

    for i in 0..(mines - 1)
        board[cells[i][0]][cells[i][1]] = -1
    end

    return seed
end

def gen_board(board, width, height, mines, seed)
    seed = gen_mines(board, width, height, mines, seed)

    for i in 0..(height - 1)
        for j in 0..(width - 1)
            if board[i][j] != -1
                board[i][j] = nearby_mines(j, i, width, height, board)
            end
        end
    end

    return seed
end

def saw_gen_board(board, width, height, mines, seed)
    drow = [-1, 0, 0, 1]
    dcol = [0, -1, 1, 0]
    cell_queue = Queue.new()

    gen_mines(board, width, height, mines, seed)

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

def open_cell(x, y, width, height, board, mask)
    if board[y][x] == -1
        mask[y][x] = 1
        return true
    end
    if board[y][x] == 0
        mass_open(x, y, width, height, board, mask)
    else
        mask[y][x] = 1
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

def draw_board(width, height, board, mask, cursor)
    print("  ")
    for column in 1..width
        print("#{column} ".colorize(:color => :cyan))
    end
    puts()

    for row in 0..(height - 1)
        print("#{row + 1} ".colorize(:color => :cyan))

        for column in 0..(width - 1)
            background = (cursor[0] == column && cursor[1] == row) ? :light_black : :default

            if mask[row][column] == -1
                print("F ".colorize(:color => :light_yellow, :background => background))
            elsif mask[row][column] == 0
                print('- '.colorize(:color => :light_white, :background => background))
            elsif board[row][column] == -1
                print('* '.colorize(:color => :light_red, :background => background))
            elsif board[row][column] == 0
                print("#{board[row][column]} ".colorize(:color => :white, :background => background))
            else
                print("#{board[row][column]} ".colorize(:color => :light_green, :background => background))
            end
        end
        puts()
    end
    puts()
end

def save_board(width, height, mines, seed, flags, duration, mask)
    File.open("board.txt", "w") do |file|
        file.write("#{width} #{height} #{mines} #{seed} #{flags} #{duration}\n")
        
        for i in 0..(height - 1)
            for j in 0..(width - 1)
                file.write("#{mask[i][j]}\t")
            end
            file.write("\n")
        end
    end
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
    draw_board(2, 2, board, mask, [0, 1])
end

if __FILE__ == $0
    board()
end
