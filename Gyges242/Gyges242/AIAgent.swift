//
//  File.swift
//  Gyges242
//
//  Created by Osayd on 4/7/16.
//  Copyright © 2016 Osayd3. All rights reserved.
//

import Foundation

class AIAgent {
    var board: Board
    var turn : Game.Player
    var available_moves:[Move]
    private var counter: Int
    
    init() {
        self.counter = 0
        self.board = Board()
        self.turn = .RED
        self.available_moves = Array()
    }
    /**
     * Return a move to be perfurmoed, which represent the best move for the current configureation (as thought by the agent).
     */
    func choose_a_move(board: Board, cur_turn: Game.Player, depth: Int) -> Move {
        self.board = board
        self.turn  = cur_turn
        let alpha = Int.min
        let beta  = Int.max
        let ret_val = choose_move_alpha_beta(self.turn, depth: depth, alpha_par: alpha, beta_par: beta)
        if let best_move = ret_val.best_move {
            print(String(self.counter))
            self.counter = 0
            return best_move
        }
        else {
            print(String(self.counter))
            self.counter = 0
            return Move()
        }
    }
       /**
     * Finding the move recursively using the alpha beta pruning method.
     */
    private func choose_move_alpha_beta(cur_turn: Game.Player, depth: Int, alpha_par: Int, beta_par: Int) -> (utility:Int, best_move: Move?) {
        var minimax_utility = cur_turn == .RED ? Int.min : Int.max
        var alpha = alpha_par
        var beta = beta_par
        self.counter += 1
        if depth == 0 {
            //board.print_board()
            return (utility(cur_turn), nil)
        }
        let cur_valid_moves = board.set_available_moves(cur_turn)
        var cur_move = Move()
        var cur_best_move = Move()
        var next_move:(utility: Int, best_move: Move?) = (0, Move())
        for move in cur_valid_moves {
            cur_move = move
            if board.make_move(move) == 2 {
                return (cur_turn == .RED ? Int.max : Int.min, cur_move)
            }
            next_move = choose_move_alpha_beta(cur_turn.opposite_player(), depth: depth-1, alpha_par: alpha, beta_par: beta)
            if cur_turn == .RED {
                minimax_utility = max(minimax_utility, next_move.utility)
                if minimax_utility == next_move.utility {
                    cur_best_move = cur_move
                }
                if minimax_utility > beta {
                    board.make_reverse_move(cur_move)
                    return (next_move.utility, cur_best_move)
                }
                alpha = max(alpha, minimax_utility)
            }
            else {
                minimax_utility = min(minimax_utility, next_move.utility)
                if minimax_utility == next_move.utility {
                    cur_best_move = cur_move
                }
                if minimax_utility < alpha {
                    board.make_reverse_move(cur_move)
                    return (next_move.utility, cur_best_move)
                }
                beta = min(beta, minimax_utility)
            }
            board.make_reverse_move(cur_move)
            //board.print_board()
        }
        return (next_move.utility , cur_best_move)
        
    }
    
    /**
     * A utility function that desribe the current configuration of the game based on the positions of each piece,
     * the type of the piece. A positive number is added for each piece closer to the .RED player and a negative number
     * is added to each piece closer to the .BLEU player. Thus one player has to minize this utility to win, and the 
     * other has to maximize it to wind (thus the name minimax).
     */
    private func utility(cur_turn: Game.Player) -> Int{
        var utility = 0
        var board_pieces = Array<Position>()
        for row in 0 ..< self.board.get_height() {
            for col in 0 ..< self.board.get_width() {
                if self.board.is_occupied(row: row, col: col) {
                    board_pieces.append(Position(row: row, col: col))
                }
            }
        }
        
        for piece_pos in board_pieces {
            let row = piece_pos.row
            let col = piece_pos.col
            
            //pieces with one moves
            if board.get_piece_at(row: row, col: col) == 1 {
                //player .RED
                if row == 0 {
                    utility += 10
                }
                    // player .BLUE
                else if row == 5 {
                    utility -= 10
                }
            }
                //pieces with two moves
            else if board.get_piece_at(row: row, col: col) == 2 {
                //player .RED
                if row == 0 && ((col < 5 && !board.is_occupied(row: row, col: col+1)) || (col>0 && !board.is_occupied(row: row, col: col-1))) {
                    utility += 10
                }
                else if row == 1 && !board.is_occupied(row: row-1, col: col) {
                    utility += 10
                }
                else if row == 1 && board.is_occupied(row: row-1, col: col) {
                    utility += 5
                }
                else if row == 0 && ((col < 5 && board.is_occupied(row: row, col: col+1)) && (col>0 && board.is_occupied(row: row, col: col-1))){
                    utility += 5
                }
                
                // player .BLUE
                else if row == 5 && ((col < 5 && !board.is_occupied(row: row, col: col+1)) || (col>0 && !board.is_occupied(row:row, col: col-1))){
                    utility -= 10
                }
                else if row == 4 && !board.is_occupied(row: row-1, col: col) {
                    utility -= 10
                }
                else if row == 4 && board.is_occupied(row: row+1, col: col){
                    utility -= 5
                }
                else if row == 5 && ((col < 5 && board.is_occupied(row: row, col: col+1)) && (col>0 && board.is_occupied(row: row, col: col-1))){
                    utility -= 5
                }
                
            }

            /*
            if(y == 5 && ( (x<4 && !board[y][x+1].occupied && !board[y][x+2].occupied) ||(x>1 && !board[y][x-1].occupied && !board[y][x-2].occupied)))
            utility -= 10;
            else if(y == 5 && ( (x<4 && !board[y][x+1].occupied && board[y][x+2].occupied) ||(x>1 && !board[y][x-1].occupied && board[y][x-2].occupied)))
            utility -= 5;
            else if(y == 5 && ( (x<4 && board[y][x+1].occupied && board[y][x+2].occupied) ||(x>1 && board[y][x-1].occupied && board[y][x-2].occupied)))
            utility -= 1;
            if (y == 4 && ((x<5 && !board[y+1][x+1].occupied && (!board[y+1][x].occupied||!board[y+1][x+1].occupied)) ||  (x>0 && !board[y+1][x-1].occupied &&(!board[y+1][x].occupied || !board[y][x-1].occupied))))
            utility -= 10;
            if(y == 4 && !board[y+1][x].occupied && ((x<5 && !board[y][x+1].occupied) || (x>0 && !board[y][x-1].occupied)))
            utility -= 5;
            if (y == 3 && ( !board[y+1][x].occupied && !board[y+2][x].occupied)  )
            utility -= 10;
            else if (y==3)
            utility -= 3;
            
        }
                 */
        
                //pieces with three moves
            else if board.get_piece_at(row: row, col: col) == 3 {
                //Player .RED
                if row == 0 {
                    if col<4 && !board.is_occupied(row: row , col: col+1) && !board.is_occupied(row: row, col: col+2){
                        utility += 10
                    }
                    else if col>1 && !board.is_occupied(row: row , col: col-1) && !board.is_occupied(row: row, col: col-2){
                        utility += 10
                    }
                    else if (col<4 && !board.is_occupied(row: row , col: col+1) && board.is_occupied(row: row, col: col+2)) {
                        utility += 5
                    }
                    else if (col>1 && !board.is_occupied(row: row , col: col-1) && board.is_occupied(row: row, col: col-2)) {
                        utility += 5
                    }
                    else if (col<4 && board.is_occupied(row: row , col: col+1) && board.is_occupied(row: row, col: col+2)){
                        utility += 1
                    }
                    else if (col>1 && board.is_occupied(row: row , col: col-1) && board.is_occupied(row: row, col: col-2)) {
                        utility += 1
                    }
                }
                else if row == 1 {
                    if col < 5 && !board.is_occupied(row: row-1, col: col+1) && (!board.is_occupied(row: row-1, col: col) || !board.is_occupied(row: row-1, col: col+1)){
                        utility += 10
                    }
                    else if col > 0 && !board.is_occupied(row: row-1, col: col-1) && (!board.is_occupied(row: row-1, col: col) || !board.is_occupied(row: row, col: col-1)) {
                        utility += 10
                    }
                    else if (!board.is_occupied(row: row-1, col: col) && ((col < 5 && !board.is_occupied(row: row, col: col+1))) || (col > 0 && !board.is_occupied(row: row, col: col-1))) {
                        utility += 5
                    }
                }
                else if row == 2 {
                    if !board.is_occupied(row: row-1, col: col) && !board.is_occupied(row: row-2, col: col) {
                        utility += 10
                    }
                    else {
                        utility += 3
                    }
                }
                    
                    //Player .BLUE
                else if row == 5 {
                    if col<4 && !board.is_occupied(row: row , col: col+1) && !board.is_occupied(row: row, col: col+2) {
                        utility -= 10
                    }
                    else if col>1 && !board.is_occupied(row: row , col: col-1) && !board.is_occupied(row: row, col: col-2) {
                        utility -= 10
                    }
                    else if (col<4 && board.is_occupied(row: row , col: col+1) && !board.is_occupied(row: row, col: col+2)) {
                        utility -= 5
                    }
                    else if (col>1 && board.is_occupied(row: row , col: col-1) && !board.is_occupied(row: row, col: col-2)) {
                        utility -= 5
                    }
                    else if (col<4 && board.is_occupied(row: row , col: col+1) && board.is_occupied(row: row, col: col+2)) {
                        utility -= 1
                    }
                    else if (col>1 && board.is_occupied(row: row , col: col-1) && board.is_occupied(row: row, col: col-2)) {
                        utility -= 1
                    }
                }
                else if row == 1 {
                    if col < 5 && !board.is_occupied(row: row-1, col: col+1) && (!board.is_occupied(row: row-1, col: col) || !board.is_occupied(row: row-1, col: col+1)){
                        utility += 10
                    }
                    else if col > 0 && !board.is_occupied(row: row-1, col: col-1) && (!board.is_occupied(row: row-1, col: col) || !board.is_occupied(row: row, col: col-1)) {
                        utility += 10
                    }
                    else if (!board.is_occupied(row: row-1, col: col) && ((col < 5 && !board.is_occupied(row: row, col: col+1))) || (col > 0 && !board.is_occupied(row: row, col: col-1))) {
                        utility += 5
                    }
                }
                else if row == 4 {
                    if col < 5 && !board.is_occupied(row: row+1, col: col+1) && (!board.is_occupied(row: row+1, col: col) || !board.is_occupied(row: row+1, col: col+1)){
                        utility -= 10
                    }
                    else if col > 0 && !board.is_occupied(row: row+1, col: col-1) && (!board.is_occupied(row: row+1, col: col) || !board.is_occupied(row: row, col: col-1)) {
                        utility -= 10
                    }
                    else if (!board.is_occupied(row: row+1, col: col) && ((col < 5 && !board.is_occupied(row: row, col: col+1))) || (col > 0 && !board.is_occupied(row: row, col: col-1))) {
                        utility -= 5
                    }
                }
                else if row == 3 {
                    if !board.is_occupied(row: row+1, col: col) && !board.is_occupied(row: row+2, col: col) {
                        utility -= 10
                    }
                    else {
                        utility -= 3
                    }
                }
                
            }

            /*
            else if board.get_piece_at(row: row, col: col) == 3 {
                //Player .RED
                if row == 0 {
                    if col<4 && !board.is_occupied(row: row , col: col+1) && !board.is_occupied(row: row, col: col+2){
                        utility += 10
                    }
                    else if col>1 && !board.is_occupied(row: row , col: col-1) && !board.is_occupied(row: row, col: col-2){
                        utility += 10
                    }
                    else if (col<4 && !board.is_occupied(row: row , col: col+1) && board.is_occupied(row: row, col: col+2)) {
                        utility += 5
                    }
                    else if (col>1 && !board.is_occupied(row: row , col: col-1) && board.is_occupied(row: row, col: col-2)) {
                        utility += 5
                    }
                    else if (col<4 && board.is_occupied(row: row , col: col+1) && board.is_occupied(row: row, col: col+2)){
                        utility += 1
                    }
                    else if (col>1 && board.is_occupied(row: row , col: col-1) && board.is_occupied(row: row, col: col-2)) {
                        utility += 1
                    }
                }
                else if row == 1 {
                    if (!board.is_occupied(row: row-1, col: col) && ((col > 0 && !board.is_occupied(row: row-1, col: col-1)
                        || (col < 5 && !board.is_occupied(row: row-1, col: col+1))))) {
                        utility += 10
                    }
                    else if (col > 0 && !board.is_occupied(row: row, col: col-1) && !board.is_occupied(row: row-1, col: col-1))
                        || (col < 5 && !board.is_occupied(row: row, col: col+1) && !board.is_occupied(row: row-1, col: col+1)) {
                            utility += 10
                    }
                    else if (!board.is_occupied(row: row-1, col: col)) {
                        utility += 5
                    }
                }
                else if row == 2 {
                    if !board.is_occupied(row: row-1, col: col) && !board.is_occupied(row: row-2, col: col) {
                        utility += 10
                    }
                    else {
                        utility += 3
                    }
                }
                
                //Player .BLUE
                else if row == 5 {
                    if col<4 && !board.is_occupied(row: row , col: col+1) && !board.is_occupied(row: row, col: col+2) {
                        utility -= 10
                    }
                    else if col>1 && !board.is_occupied(row: row , col: col-1) && !board.is_occupied(row: row, col: col-2) {
                        utility -= 10
                    }
                    else if (col<4 && board.is_occupied(row: row , col: col+1) && !board.is_occupied(row: row, col: col+2)) {
                        utility -= 5
                    }
                    else if (col>1 && board.is_occupied(row: row , col: col-1) && !board.is_occupied(row: row, col: col-2)) {
                        utility -= 5
                    }
                    else if (col<4 && board.is_occupied(row: row , col: col+1) && board.is_occupied(row: row, col: col+2)) {
                        utility -= 1
                    }
                    else if (col>1 && board.is_occupied(row: row , col: col-1) && board.is_occupied(row: row, col: col-2)) {
                        utility -= 1
                    }
                }
                else if row == 4 {
                    if (!board.is_occupied(row: row+1, col: col) && ((col > 0 && !board.is_occupied(row: row+1, col: col-1)
                        || (col < 5 && !board.is_occupied(row: row+1, col: col+1))))) {
                        utility -= 10
                    }
                    else if (col > 0 && !board.is_occupied(row: row, col: col-1) && !board.is_occupied(row: row+1, col: col-1))
                        || (col < 5 && !board.is_occupied(row: row, col: col+1) && !board.is_occupied(row: row+1, col: col+1)) {
                            utility -= 10
                    }
                    else if (!board.is_occupied(row: row+1, col: col)) {
                        utility -= 5
                    }
                }
                else if row == 3 {
                    if !board.is_occupied(row: row+1, col: col) && !board.is_occupied(row: row+2, col: col) {
                        utility -= 10
                    }
                    else {
                        utility -= 3
                    }
                }
                
            }
             */
        }
        return utility
    }
}
