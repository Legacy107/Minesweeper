def get_new_game_state()
    gameState = Struct.new(
        :mode,  # 0: minesweeper  1: minesawyer
        :seed,
        :width,
        :height,
        :board,
        :mask,
        :flags,
        :mines,
        :remaining_mines,  # for minesawyer mode
        :score,
        :auto,
        :tick,
        :start_time,
        :max_time,
    )
    return gameState.new(
        0,
        nil,
        0,
        0,
        [],
        [],
        0,
        0,
        0,
        nil,
        false,
        0,
        nil,
        0,
    )
end