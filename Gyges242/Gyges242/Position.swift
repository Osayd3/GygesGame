//
//  Position.swift
//  Gyges242
//
//  Created by Osayd on 4/2/16.
//  Copyright © 2016 Osayd3. All rights reserved.
//

func == (left: Position, right: Position) -> Bool {
    return left.equals(right)
}
func != (left: Position, right: Position) -> Bool {
    return !left.equals(right)
}

struct  Position{
    var row:Int
    var col:Int
    init () {
        self.row = -1000000
        self.col = -1000000
    }
    init (row:Int, col:Int){
        self.row = row
        self.col = col
    }
    
    func row_diff(other: Position) -> Int {
        return self.row - other.row
    }
    
    func row_diff(other: Int) -> Int {
        return self.row - other
    }
    
    func col_diff(other: Position) -> Int {
        return self.col - other.col
    }
    
    func col_diff(other: Int) -> Int {
        return self.col - other
    }
    
    func equals(other: Position) -> Bool {
        return self.row == other.row && self.col == other.col
    }
    
    func print_pos() {
        print("("+String(self.row)+", "+String(self.col)+") ", terminator:"")
    }
    
}