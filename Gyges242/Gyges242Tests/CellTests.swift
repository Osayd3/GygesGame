//
//  CellTests.swift
//  Gyges242
//
//  Created by Osayd on 4/3/16.
//  Copyright © 2016 Osayd3. All rights reserved.
//

import Foundation

import XCTest
@testable import Gyges242

class CellTests: XCTestCase {
  
    var cell:Cell?
    override func setUp() {
        super.setUp()
        cell = Cell(row: 0, column: 0)
    }
    
    func test_copy() {
        self.cell?.set_piece(new_piece: OnePiece())
        let copy_cell = self.cell!.copy()
        assert(copy_cell.get_piece() == self.cell?.get_piece(), "should have the same piece type")
        assert(copy_cell.get_piece_obj()!.steps == self.cell?.get_piece_obj()!.steps, "should have the same piece type")
        assert(copy_cell.get_position() == (self.cell?.get_position())!, "should have the same position")

    }
    

}