require "./util.rb"

$score_limit = 5

def get_scores(mines)
    n = 0
    scores = [];
    file = File.open("score#{mines}.txt")

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

def update_scoreboard(mines, score)
    scores = get_scores(mines)
    File.open("score#{mines}.txt", "w") do |file|
        n = [$score_limit, scores.length + 1].min()
        scores = scores.insert(upper_bound(scores, score), score)
        file.write("#{n}\n")
        for i in 0..(n - 1)
            file.write("#{scores[i]}\n")
        end
    end
end

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

c