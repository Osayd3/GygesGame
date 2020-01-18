//
//  BoardTests.swift
//  Gyges242
//
//  Created by Osayd on 4/3/16.
//  Copyright © 2016 Osayd3. All rights reserved.
//

import Foundation

import XCTest
@testable import Gyges242

class BoardTests: XCTestCase {
    
    var board:Board = Board()
    override func setUp() {
        super.setUp()
      self.board = Board()
    }

    
    func test_height_width() {
        assert(self.board.get_height() == 6, "height should be 6")
        assert(self.board.get_width() == 6, "width should be 6")
        let temp_board = Board(width: 10, height: 20)
        assert(temp_board.get_height() == 20, "height should be 20")
        assert(temp_board.get_width() == 10, "width should be 10")
    }
    
    func test_make_move_and_reverse_move() {
        let temp_move = Move(from: Position(row: 0, col: 0), to: Position(row: 1, col: 0), row_verifier: verify_x, col_verifier: verify_y)
        board.make_move(temp_move)
        assert(!board.is_occupied(row: 0, col: 0), "(0,0) should not be occupied ")
        assert(board.is_occupied(row: 1, col: 0), "(1, 0) should be occupied")
        board.make_reverse_move(temp_move)
        assert(board.is_occupied(row: 0, col: 0), "(0,0) should be occupied ")
        assert(!board.is_occupied(row: 1, col: 0), "(1, 0) should not be occupied")
    }
    
   // func test_(){
    private func verify_x(x: Int) -> Bool{
        return x >= 0 && x < 6
        
    }
    private func verify_y(y: Int) -> Bool{
        return y >= 0 && y < 6
    }
    
}