//
//  Cell.swift
//  Gyges242
//
//  Created by Osayd on 4/2/16.
//  Copyright © 2016 Osayd3. All rights reserved.
//

import Foundation

class Cell {
    let location: Position
    var occupied: Bool
    private var piece: Piece?
    
    init(row:Int, column:Int){
        self.location = Position(row: row, col: column)
        self.occupied = false
    }
    /**
     * Return a new copy of Cell.
     */
    func copy() -> Cell {
        let new_cell = Cell(row: self.location.row, column: self.location.col)
        new_cell.occupied = self.occupied
        if let my_piece = self.piece {
            new_cell.piece = my_piece.copy()
        } else {
            new_cell.piece = nil
        }
        return new_cell
    }
    func get_position() -> Position {
        return self.location
    }
    /**
     * Return the piece's steps number.
     */
    func get_piece() -> Int {
        if let cur_piece = self.piece {
            return cur_piece.steps
        }
        return 0
    }
    /**
     * Return the actual pointer to piece.
     */
    func get_piece_obj() -> Piece? {
        return self.piece
    }

    func get_possible_destinations(row_verifier row_verifier: (Int) -> (Bool), col_verifier: (Int) -> (Bool), occupied_matrix:[[Bool]]) -> [Move]? {
        if let my_piece = self.piece {
            return my_piece.possible_destinations(source: location, row_verifier: row_verifier, col_verifier: col_verifier, occupied_matrix: occupied_matrix )
        }
        return nil
    }
    /**
     * Change what self.piece refers to.
     */
    func set_piece(new_piece new_piece: Piece?) {
        self.piece = new_piece
        self.occupied = new_piece == nil ? false : true
    }
    
}
