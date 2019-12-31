board = [[" "," "," "],
         [" "," "," "],
         [" "," "," "]
]

coord = [[1,1],[1,2],[1,3],
         [2,1],[2,2], [2,3],
         [3,1],[3,2],[3,3]
]

current_player = "X"
winner = "None"


function display_board()
    println("  1   2   3")
    println("    |   |   ")
    println("1 " * board[1][1] * " | "  * board[1][2] * " | " * board[1][3])
    println("    |   |   ")
    println(" ---+---+---")
    println("    |   |   ")
    println("2 " * board[2][1] * " | "  * board[2][2] * " | " * board[2][3])
    println("    |   |   ")
    println(" ---+---+---")
    println("    |   |   ")
    println("3 " * board[3][1] * " | "  * board[3][2] * " | " * board[3][3])
    println("    |   |   ")
end

function main()
    again = "Y"
    while uppercase(again) == "Y"
        reset_game()
        starting_player = ("Human","AI")[rand(1:2)]
        while game_over() == false
            display_board()
            if starting_player == "Human"
              p1_move()
            else
              p2_move()
            end

            if game_over() == false
                change_player()
                display_board()
                if starting_player == "AI"
                  p1_move()
                else
                  p2_move()
                end

                if game_over() == false
                    change_player()
                end
            end
        display_board()
        print("Winner =", winner)
        again = input("Play again?: ")[1]
      end
    end
end

function p1_move()
  global current_player, board, coord

  update_coord()

  print("The current player is", current_player)
  while true
    #try
      row, col = split(input("Give a row and a column coordinate: "))
      row, col = parse(Int64,row), parse(Int64,col)
      if board[row][col] == " "
        board[row][col] = current_player
        break
      else
        print("Invalid move.")
      end
    #catch
    #  print("Invalid move.")
    #ends
  end
end

function p2_move()
  """
    If the AI can win on the next move, do so!
    If the user can win on his next move, block a winning spot!
    If a corner is open, take a random open corner.
    If the center is open, take the center.
    Otherwise, take a random open side space.
  """

  global board, coord

  update_coord()

  print("The current player is", current_player)

  # Win check
  for vals in coord
    board[vals[1]][vals[2]] = current_player
    if is_winner(current_player)
      return
    else
      board[vals[1]][vals[2]] = " "
    end
  end


  # Block check
  change_player()

  for vals in coord
    board[vals[1]][vals[2]] = current_player
    if is_winner(current_player)
      change_player()
      board[vals[1]][vals[2]] = current_player
      return
    else
      board[vals[1]][vals[2]] = " "
    end
  end

  change_player()

  # Corner check
  corners = [[1,1],[3,1],[1,3],[3,3]]

  while length(corners) > 1
    corner_choice = corners[rand(1:length(corners))]
    if corner_choice in coord
      board[corner_choice[1]][corner_choice[2]] = current_player
      return
    else
      deleteat!(corners, findfirst(isequal(corner_choice), corners))
    end
  end


  # Center check
  if [2,2] in coord
    board[2][2] = current_player
    return
  end

  # Side check
  side_choice = coord[rand(1:length(coord))]
  board[side_choice[1]][side_choice[2]] = current_player
end

function reset_game()
  global winner, current_player

  winner = "None"
  for i in 1:3
    board[i][1] = " "
    board[i][2] = " "
    board[i][3] = " "
  end
  current_player = (["X","O"])[rand(1:2)]
end

function is_winner(player)
  global winner
  for i in 1:3
    if board[i][1] == board[i][2] == board[i][3] == player
      return true
    elseif board[1][i] == board[2][i] == board[3][i] == player
      return true
    elseif board[1][1] == board[2][2] == board[3][3] == player || board[1][3] == board[2][2] == board[3][1] == player
        return true
    end
  end
  return false
end

function game_over()
  global winner
  if is_winner("X")
    winner = "X"
    return true
  elseif is_winner("O")
    winner = "O"
    return true
  else
    # return (" " in sublist for sublist in board) ? false : true
    return false
  end
end

function update_coord()
  global coord

  for i in 1:length(board)
    for j in 1:length(board[1])
      if board[i][j] == " " && !([i,j] in coord)
        coord.append([i,j])
      elseif board[i][j] != " " && [i,j] in coord
        deleteat!(coord, findfirst(isequal([i,j]), coord))
      end
    end
  end
end

function change_player()
    global current_player
    if current_player == "X"
      current_player = "O"
    else
      current_player = "X"
    end
end

main()
