//
//  Piece.swift
//  Gyges242
//
//  Created by Osayd on 4/2/16.
//  Copyright © 2016 Osayd3. All rights reserved.
//

import Foundation


protocol Piece {
    var steps:Int {get}
    func copy() -> Piece

    
}

extension Piece {
    /**
     * Return all the possible destination the current piece can go to (in terms of the number of steps they have).
     */
    internal func possible_destinations(source from:Position, row_verifier: (Int) -> (Bool), col_verifier: (Int) -> (Bool), occupied_matrix:[[Bool]]) -> [Move] {
        var moves:[Move] = Array()
        var current_path = Array<Position>()
        current_path.append(Position(row: from.row, col: from.col))
        find_destinations(from, current_pos: from, row_verifier: row_verifier, col_verifier:col_verifier, current_path: &current_path, steps: &moves, remaining_steps: self.steps, occupied_matrix: occupied_matrix)
        return moves
    }
    /**
     * Find the actual destinations.
     */
    private func find_destinations(from: Position, current_pos: Position, row_verifier: (Int) -> (Bool), col_verifier: (Int) -> (Bool), inout current_path:[Position], inout steps: [Move], remaining_steps: Int, occupied_matrix: [[Bool]]){
        
        let current_row = current_pos.row
        let current_col = current_pos.col
        
        if remaining_steps == 0 {
            if row_verifier(current_row) && col_verifier(current_col) {
                let current_move = Move(from: from, to: current_pos, row_verifier: row_verifier, col_verifier: col_verifier)
                let temp = steps.indexOf({current_move.equals($0)})
                if temp == nil {
                    steps.append(current_move)
                }
            }
            return
        }
        
        let up    = Position(row: current_row + 1 , col: current_col    )
        let down  = Position(row: current_row - 1 , col: current_col    )
        let left  = Position(row: current_row     , col: current_col - 1)
        let right = Position(row: current_row     , col: current_col + 1)
        
        var temp = current_path.indexOf({up == $0})
        if temp == nil {
            current_path.append(up)
            find_destinations(from, current_pos: up, row_verifier: row_verifier, col_verifier:col_verifier, current_path: &current_path, steps: &steps, remaining_steps: remaining_steps-1, occupied_matrix: occupied_matrix)
            current_path.removeLast()
        }
        
        temp = current_path.indexOf({down == $0})
        if temp == nil {
            current_path.append(down)
            find_destinations(from, current_pos: down, row_verifier: row_verifier, col_verifier:col_verifier, current_path: &current_path, steps: &steps, remaining_steps: remaining_steps-1, occupied_matrix: occupied_matrix)
            current_path.removeLast()
        }
        
        temp = current_path.indexOf({left == $0})
        if temp == nil {
            current_path.append(left)
            find_destinations(from, current_pos: left , row_verifier: row_verifier, col_verifier:col_verifier, current_path: &current_path, steps: &steps, remaining_steps: remaining_steps-1, occupied_matrix: occupied_matrix)
            current_path.removeLast()
        }
        
        temp = current_path.indexOf({right == $0})
        if temp == nil {
            current_path.append(right)
            find_destinations(from, current_pos: right, row_verifier: row_verifier, col_verifier:col_verifier, current_path: &current_path, steps: &steps, remaining_steps: remaining_steps-1, occupied_matrix: occupied_matrix)
            current_path.removeLast()
        }
    }

}