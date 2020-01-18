//
//  Move.swift
//  Gyges242
//
//  Created by Osayd on 4/3/16.
//  Copyright © 2016 Osayd3. All rights reserved.
//

import Foundation

class Move {
    
    let src:Position
    let dst:Position
    let row_verifier: (Int) -> (Bool)
    let col_verifier: (Int) -> (Bool)
    var middle_steps: Array<Position>
    var all_paths_to_dst: [[Position]]?
    
    init() {
        self.src = Position()
        self.dst = Position()
        self.col_verifier = arbitrary_verifier
        self.row_verifier = arbitrary_verifier
        self.middle_steps = Array()
    }
    init(from:Position, to:Position, row_verifier: (Int) -> (Bool) = arbitrary_verifier, col_verifier: (Int) -> (Bool) = arbitrary_verifier){
        self.src = from
        self.dst = to
        self.col_verifier = row_verifier
        self.row_verifier = col_verifier
        self.middle_steps = Array()
    }
   
    func add_middle_step(step: Position) {
        middle_steps.append(step)
    }
    func remove_middle_step() {
        if middle_steps.count > 0{
            middle_steps.removeLast()
        }
    }

    func get_all_middle_steps() -> [[Position]] {
        if let ret_arr = self.all_paths_to_dst {
            return ret_arr
        }
        //set_middle_steps()
        return self.all_paths_to_dst!
    }
    
    private func set_middle_steps(steps: Int){
        var middle_steps:[[Position]] = Array()
        if self.src == self.dst {
            self.all_paths_to_dst =  middle_steps
        } else {
            var temp_path = Array<Position>()
            temp_path.append(Position(row: self.dst.row, col: self.dst.col))
            generate_middle_steps(self.dst, current_path: &temp_path, steps: &middle_steps, remaining_steps: steps)
            self.all_paths_to_dst = middle_steps
        }
    }
    /**
     * Generate all possible paths from self.src to self.dst that have the same number of steps specified
     * by remaining_steps parameter. Each path is represented in an array of Positions from self.src to
     * self.dst and then each array is inserted into the steps parameter.
     * @parameter:
     */
    private func generate_middle_steps(current_pos: Position, inout current_path:[Position], inout steps: [[Position]], remaining_steps: Int) {
        let current_row = current_pos.row
        let current_col = current_pos.col
        
        
        if self.src == current_pos {
            if remaining_steps == 0 {
                steps.append(current_path.reverse())
                return
            } else {
                return
            }
        }
        
        if remaining_steps == 0 || !self.row_verifier(current_row) || !self.col_verifier(current_col) {
            return
        }
        
        let up    = Position(row: current_row + 1 , col: current_col    )
        let down  = Position(row: current_row - 1 , col: current_col    )
        let left  = Position(row: current_row     , col: current_col - 1)
        let right = Position(row: current_row     , col: current_col + 1)
        
        var temp = current_path.indexOf({$0 == up})
        if temp == nil {
            current_path.append(up)
            generate_middle_steps(up   , current_path: &current_path, steps: &steps, remaining_steps: remaining_steps-1)
            current_path.removeLast()
        }

        temp = current_path.indexOf({$0 == down})
        if temp == nil {
            current_path.append(down)
            generate_middle_steps(down , current_path: &current_path, steps: &steps, remaining_steps: remaining_steps-1)
            current_path.removeLast()
        }
        
        temp = current_path.indexOf({$0 == left})
        if temp == nil {
            current_path.append(left)
            generate_middle_steps(left , current_path: &current_path, steps: &steps, remaining_steps: remaining_steps-1)
            current_path.removeLast()
        }

        temp = current_path.indexOf({$0 == right})
        if temp == nil {
            current_path.append(right)
            generate_middle_steps(right, current_path: &current_path, steps: &steps, remaining_steps: remaining_steps-1)
            current_path.removeLast()
        }

    }

    func can_move(occupied_matrix occ_mat: [[Bool]]) -> Bool {
        //set_middle_steps()
        for path in 0 ..< self.all_paths_to_dst!.count {
            var can_move = true
            for step in 1 ..< self.all_paths_to_dst![path].count-1 {
                let row = self.all_paths_to_dst![path][step].row
                let col = self.all_paths_to_dst![path][step].col
                if occ_mat[row][col] {
                    can_move = false
                    break
                }
            }
            if can_move {
                return true
            }
        }
        
        return false
    }
    
    func print_move(){
        self.src.print_pos()
        print("-> ", terminator: "")
        self.dst.print_pos()
        print("")
    }
    func equals(other: Move) -> Bool {
        return (self.src == other.src) && (self.dst == other.dst)
    }
    
}

func arbitrary_verifier(temp: Int) -> Bool {
    return false
}