//
//  Board.swift
//  Gyges242
//
//  Created by Osayd on 4/3/16.
//  Copyright © 2016 Osayd3. All rights reserved.
//

import Foundation

class Board {
    
    private var board:[[Cell]]
    private let height: Int
    private let width: Int
    
    init(random: Bool = false){
        self.board  = Array()
        self.height = 6
        self.width  = 6
        if random {
            init_random_board()
        }
        else {
            init_defualt_board()
        }
        
        
    }
    init(width: Int, height: Int){
        self.board  = Array()
        self.height = height
        self.width  = width
        init_defualt_board()
    }
    func get_height() -> Int {
        return self.height
    }
    func get_width() -> Int {
        return self.width
    }
    func copy() -> Board {
        let new_board = Board(width: self.width, height: self.height)
        for row in 0 ..< self.height {
            for col in 0 ..< self.width {
                new_board.board[row][col] = self.board[row][col].copy()
            }
        }
        return new_board
    }
    /**
     * Make a move on the board. (this functio deos check for the validity of the move unlike the reverse move function).
     */
    func make_move(move:Move) -> Int {
        let from_row = move.src.row
        let from_col = move.src.col
        let to_row   = move.dst.row
        let to_col   = move.dst.col
        if to_row == -1 || to_row == 6 {
            return 2
        }
        else if board[from_row][from_col].get_piece() == 0 || board[to_row][to_col].occupied {
            return 0
        } else {
            let piece_to_be_moved = board[from_row][from_col].get_piece_obj()
            board[to_row][to_col].set_piece(new_piece: piece_to_be_moved)
            board[from_row][from_col].set_piece(new_piece: nil)
            return 1
        }
    }
    /**
     * Reversing a move (from dst to src), the caller has to make sure the move is safe to be reversed.
     * (only use this to actually reverse a move that alrady been taken.
     */
    func make_reverse_move(move: Move) {
        let from_row = move.dst.row
        let from_col = move.dst.col
        let to_row   = move.src.row
        let to_col   = move.src.col
        let piece_to_be_moved = self.board[from_row][from_col].get_piece_obj()
        board[to_row][to_col].set_piece(new_piece: piece_to_be_moved)
        board[from_row][from_col].set_piece(new_piece: nil)
    }
    /**
     * return the piece type (steps size) that at cell (row, col) and 0 if it is an empty cell.
     */
    func get_piece_at(row row: Int, col: Int) -> Int {
        return board[row][col].get_piece()
    }
    
    func is_occupied(row row: Int, col: Int) -> Bool {
        return board[row][col].occupied
    }
    
    func get_possible_destinations(source from:Position, row_verifier:(Int)->(Bool), col_verifier:(Int)->(Bool), occupied_matrix:[[Bool]]) -> [Move]? {
        let row = from.row
        let col = from.col
        return board[row][col].get_possible_destinations(row_verifier: row_verifier, col_verifier: col_verifier, occupied_matrix:occupied_matrix)
    }
    /**
     * returun the nearest row.
     */
    func get_nearest_row(low low: Bool) -> [Position] {
        var nearest_row_positions = Array<Position>()
        var found_piece = false
        let range = low ? (0 ..< self.height).reverse().reverse() : (0 ..< self.height).reverse()
        for row in range {
            if found_piece {
                break
            }
            for col in 0 ..< self.width {
                if board[row][col].occupied {
                    found_piece = true
                    nearest_row_positions.append(Position(row: row, col: col))
                }
            }
        }
        return nearest_row_positions
    }
    
    /**
     * initilizing the default board with cells. The default board looks like this:
     *              -------------------------
     *              | 1 | 2 | 3 | 3 | 2 | 1 |
     *              -------------------------
     *              |   |   |   |   |   |   |
     *              -------------------------
     *              |   |   |   |   |   |   |
     *              -------------------------
     *              |   |   |   |   |   |   |
     *              -------------------------
     *              |   |   |   |   |   |   |
     *              -------------------------
     *              | 1 | 2 | 3 | 3 | 2 | 1 |
     *              -------------------------
     */
    private func init_defualt_board() {
        create_board_cells()
        
        self.board[0][0].set_piece(new_piece: OnePiece())
        self.board[0][5].set_piece(new_piece: OnePiece())
        self.board[0][1].set_piece(new_piece: TwoPiece())
        self.board[0][4].set_piece(new_piece: TwoPiece())
        self.board[0][2].set_piece(new_piece: ThreePiece())
        self.board[0][3].set_piece(new_piece: ThreePiece())
        
        self.board[5][0].set_piece(new_piece: OnePiece())
        self.board[5][5].set_piece(new_piece: OnePiece())
        self.board[5][1].set_piece(new_piece: TwoPiece())
        self.board[5][4].set_piece(new_piece: TwoPiece())
        self.board[5][2].set_piece(new_piece: ThreePiece())
        self.board[5][3].set_piece(new_piece: ThreePiece())
    }
    
    private func init_random_board() {
        create_board_cells() 
        var pieces = [1, 1, 2, 2, 3, 3]
        var i = 0
        while pieces.count != 0 {
            let random_index = Int(arc4random_uniform(UInt32(pieces.count)))
            switch pieces[random_index] {
            case 1:
                self.board[0][i].set_piece(new_piece: OnePiece())
                self.board[5][i].set_piece(new_piece: OnePiece())
            case 2:
                self.board[0][i].set_piece(new_piece: TwoPiece())
                self.board[5][i].set_piece(new_piece: TwoPiece())
            case 3:
                self.board[0][i].set_piece(new_piece: ThreePiece())
                self.board[5][i].set_piece(new_piece: ThreePiece())
            default:
                break
            }
            i += 1
            pieces.removeAtIndex(random_index)
        }
        print_board()
    }
    
    private func create_board_cells() {
        for row in 0 ..< self.height {
            var temp_arr = Array<Cell>()
            for col in 0 ..< self.width {
                temp_arr.append(Cell(row: row, column: col))
            }
            self.board.append(temp_arr)
        }
    }
    /**
     * Printing the board as a string for debugging purposes. Formated like this:
     *              -------------------------
     *              |   | 2 | 3 |   | 2 | 1 |
     *              -------------------------
     *              | 1 |   |   |   |   |   |
     *              -------------------------
     *              |   |   |   |   |   |   |
     *              -------------------------
     *              |   |   |   | 3 |   |   |
     *              -------------------------
     *              | 1 |   | 2 |   |   |   |
     *              -------------------------
     *              |   |   | 3 | 3 | 2 | 1 |
     *              -------------------------
     */
    
    internal func print_board(){
        print("-------------------------")
        for row in (0..<6).reverse() {
            print("|", terminator: "")
            for col in 0..<6 {
                let cur_piece_steps = self.board[row][col].get_piece()
                if cur_piece_steps != 0 {
                    print(" " + String(cur_piece_steps) + " ", terminator: col != 5 ?"|" : "|\n")
                } else {
                    print("   ", terminator: col != 5 ?"|" : "|\n")
                }
            }
            print("-------------------------")
        }
    }
    
    /**
     * Return an array of all the available moves for the current player
     */
    func set_available_moves(current_player: Game.Player) -> [Move] {
        var available_moves = Array<Move>()
        var found = false
        var org_moves = Array<Position>()
        let range = current_player == .RED ? (0 ..< self.height).reverse().reverse() : (0 ..< self.height).reverse()
        
        //adding all the pieces at the closest row to the current_player into the org_moves
        for row in range {
            if found {
                break
            }
            for col in 0 ..< self.width {
                if board[row][col].occupied {
                    found = true
                    org_moves.append(Position(row: row, col: col))
                }
            }
        }
        
        //for each move in the org_moves, explore all 4 directions
        for i in 0 ..< org_moves.count {
            let temp_pos = org_moves[i]
            let current_row = temp_pos.row
            let current_col = temp_pos.col
            var visited = Array<Position>()
            let up    = Position(row: current_row + 1 , col: current_col    )
            let up_move = Move(from: temp_pos, to: up, row_verifier: verify_row, col_verifier: verify_col)
            fill_available_moves(up_move, moves_remaining: board[current_row][current_col].get_piece()-1, visited: &visited, available_moves: &available_moves, current_player: current_player)
            
            let down  = Position(row: current_row - 1 , col: current_col    )
            let down_move = Move(from: temp_pos, to: down, row_verifier: verify_row, col_verifier: verify_col)
            fill_available_moves(down_move , moves_remaining: board[current_row][current_col].get_piece()-1, visited: &visited, available_moves: &available_moves, current_player: current_player)
            
            let left  = Position(row: current_row     , col: current_col - 1)
            let left_move = Move(from: temp_pos, to: left, row_verifier: verify_row, col_verifier: verify_col)
            fill_available_moves(left_move , moves_remaining: board[current_row][current_col].get_piece()-1, visited: &visited, available_moves: &available_moves, current_player: current_player)
            
            let right = Position(row: current_row     , col: current_col + 1)
            let right_move = Move(from: temp_pos, to: right, row_verifier: verify_row, col_verifier: verify_col)
            fill_available_moves(right_move, moves_remaining: board[current_row][current_col].get_piece()-1, visited: &visited, available_moves: &available_moves, current_player: current_player)
        }
        return available_moves
    }
    /**
     * Recursively explore all the four direction fo the curr_move with moves_remaining in mind to find fill the available_moves array with all the
     * possible moves.
     */
    func fill_available_moves(curr_move: Move, moves_remaining: Int, inout visited: [Position], inout available_moves: [Move], current_player: Game.Player){
        let current_row = curr_move.dst.row
        let current_col = curr_move.dst.col
        if moves_remaining == 0 && (current_player == .RED ? current_row == 6 : current_row == -1) {
            let temp = available_moves.indexOf({curr_move.equals($0)})
            if temp == nil{
                available_moves.append(curr_move)
            }
            return
        }
        if !verify_row(current_row) || !verify_col(current_col) || curr_move.src == curr_move.dst {
            return
        }
        //if there is an occupied position before finishing all the piece's moves, just ignore this path.
        if moves_remaining > 0 && board[current_row][current_col].occupied {
            return
        }
        //if the position to be explored have already been seen, just ingore it.
        if let _ = visited.indexOf({curr_move.dst == $0}) {
            return
        }
        visited.append(curr_move.dst)
        
        //if ther is no remaining steps and the current cell is occupied, explore all possible paths using current cell's steps number.
        if moves_remaining == 0 {
            if board[current_row][current_col].occupied {
                curr_move.add_middle_step(Position(row: current_row, col: current_col))
                
                let up    = Position(row: current_row + 1 , col: current_col    )
                let up_move = Move(from: curr_move.src, to: up, row_verifier: verify_row, col_verifier: verify_col)
                fill_available_moves(up_move, moves_remaining: board[current_row][current_col].get_piece()-1, visited: &visited, available_moves: &available_moves, current_player: current_player)
                
                let down  = Position(row: current_row - 1 , col: current_col    )
                let down_move = Move(from: curr_move.src, to: down, row_verifier: verify_row, col_verifier: verify_col)
                fill_available_moves(down_move , moves_remaining: board[current_row][current_col].get_piece()-1, visited: &visited, available_moves: &available_moves, current_player: current_player)
                
                let left  = Position(row: current_row     , col: current_col - 1)
                let left_move = Move(from: curr_move.src, to: left, row_verifier: verify_row, col_verifier: verify_col)
                fill_available_moves(left_move , moves_remaining: board[current_row][current_col].get_piece()-1, visited: &visited, available_moves: &available_moves, current_player: current_player)
                
                let right = Position(row: current_row     , col: current_col + 1)
                let right_move = Move(from: curr_move.src, to: right, row_verifier: verify_row, col_verifier: verify_col)
                fill_available_moves(right_move, moves_remaining: board[current_row][current_col].get_piece()-1, visited: &visited, available_moves: &available_moves, current_player: current_player)
                
                curr_move.remove_middle_step()
                
            } else {
                let temp = available_moves.indexOf({curr_move.equals($0)})
                if temp == nil {
                    available_moves.append(curr_move)
                }
            }
        }
            // Just go explore all four directions.
        else {
            
            let up    = Position(row: current_row + 1 , col: current_col    )
            let up_move = Move(from: curr_move.src, to: up, row_verifier: verify_row, col_verifier: verify_col)
            fill_available_moves(up_move, moves_remaining: moves_remaining-1, visited: &visited, available_moves: &available_moves, current_player: current_player)
            
            let down  = Position(row: current_row - 1 , col: current_col    )
            let down_move = Move(from: curr_move.src, to: down, row_verifier: verify_row, col_verifier: verify_col)
            fill_available_moves(down_move, moves_remaining: moves_remaining-1, visited: &visited, available_moves: &available_moves, current_player: current_player)
            
            let left  = Position(row: current_row     , col: current_col - 1)
            let left_move = Move(from: curr_move.src, to: left, row_verifier: verify_row, col_verifier: verify_col)
            fill_available_moves(left_move, moves_remaining: moves_remaining-1, visited: &visited, available_moves: &available_moves, current_player: current_player)
            
            let right = Position(row: current_row     , col: current_col + 1)
            let right_move = Move(from: curr_move.src, to: right, row_verifier: verify_row, col_verifier: verify_col)
            fill_available_moves(right_move, moves_remaining: moves_remaining-1, visited: &visited, available_moves: &available_moves, current_player: current_player)
            
        }
        visited.removeLast()
    }
    
    private func verify_row(row: Int) -> Bool{
        return row >= 0 && row < self.width
        
    }
    private func verify_col(col: Int) -> Bool{
        return col >= 0 && col < self.height
    }
    
    func get_all_pieces() -> (piece_steps: Array<Int>, locations: Array<Position>) {
        var steps = Array<Int>()
        var locations = Array<Position>()
        for row in 0 ..< self.height {
            for col in 0 ..< self.width {
                if is_occupied(row: row, col: col) {
                    steps.append(get_piece_at(row: row, col: col))
                    locations.append(Position(row: row, col: col))
                }
            }
        }
        return (steps, locations)
    }
    
    func set_all_pices(pices_steps: Array<Int>, locations: Array<Position>) {
        empty_all_cells()
        for i in 0 ..< pices_steps.count {
            let steps = pices_steps[i]
            let row = locations[i].row
            let col = locations[i].col
            switch steps {
            case 1:
                board[row][col].set_piece(new_piece: OnePiece())
            case 2:
                board[row][col].set_piece(new_piece: TwoPiece())
            case 3:
                board[row][col].set_piece(new_piece: ThreePiece())
            default:
                board[row][col].set_piece(new_piece: nil)
            }
            
        }
    }
    
    private func empty_all_cells() {
        for row in 0 ..< self.height {
            for col in 0 ..< self.width {
                board[row][col].set_piece(new_piece: nil)
            }
        }
    }
    
}