require "./global.rb"
require "./util.rb"

# Read scores from a file
def get_scores(board)
    n = 0
    scores = [];
    file = File.open("score#{board}.txt")

    n = file.gets().to_i()

    for i in 0..(n - 1)
        scores << file.gets().to_i();
    end

    file.close()
    return scores;
end

def get_highscore(mines)
    scores = get_scores(mines)
    return scores[0]
end

# Insert new score and write to a file
def update_scoreboard(board, score)
    scores = get_scores(board)
    File.open("score#{board}.txt", "w") do |file|
        n = [GameSettings::SCORE_LIMIT, scores.length + 1].min()
        scores = scores.insert(upper_bound(scores, score), score)
        file.write("#{n}\n")
        for i in 0..(n - 1)
            file.write("#{scores[i]}\n")
        end
    end
end

# Testing
def score()
    scores = get_scores(10)
    scores.each() do |score|
        print("#{score} ")
    end
    puts()
    puts(get_highscore(10))

    update_scoreboard(10, 0)

    scores = get_scores(10)
    scores.each() do |score|
        print("#{score} ")
    end
end

if __FILE__ == $0
    score()
end
