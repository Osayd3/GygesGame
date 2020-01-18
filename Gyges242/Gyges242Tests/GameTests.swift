//
//  MoveTests.swift
//  Gyges242
//
//  Created by Osayd on 4/4/16.
//  Copyright © 2016 Osayd3. All rights reserved.
//

import Foundation


import XCTest
@testable import Gyges242

class GameTests: XCTestCase {
    
    var single_game:Game?
    var double_game:Game?
    
    override func setUp() {
        super.setUp()
        self.single_game = Game(single_player_mode: true)
        self.double_game = Game(single_player_mode: false)
    }
    
    func test_valid_move_single_player_AI_second() {
        //moving piece with one step
        var moved = self.single_game!.move_piece(from_row: 0, from_col: 0, to_row: 1, to_col: 0)
        assert(moved.state == .VALID_MOVE, "The piece at (0,0) should have moved to (1,0)")
        //moving piece with three step
        moved = self.single_game!.move_piece(from_row: 0, from_col: 3, to_row: 3, to_col: 3)
        assert(moved.state == .VALID_MOVE, "The piece at (5,0) should have moved to (3,1)")
        //moving piece with two step
        moved = self.single_game!.move_piece(from_row: 0, from_col: 1, to_row: 2, to_col: 1)
        assert(moved.state == .VALID_MOVE, "The piece at (0,1) should have moved to (2,1)")
        
        let (from_pos, to_pos, _, _) = self.single_game!.undo()
        let msg = "The Undo move must match the previous move taken"
        assert(from_pos == Position(row: 0, col: 1) && to_pos == Position(row: 2, col: 1), msg)
        moved = self.single_game!.move_piece(from_row: 0, from_col: 1, to_row: 2, to_col: 1)
        assert(moved.state == .VALID_MOVE, "The piece at (0,1) should have moved to (2,1)")

    }
    
    func test_invalid_move_single_player_AI_second() {
        //out of bound
        var moved = self.single_game!.move_piece(from_row: -2, from_col: -1, to_row: 1, to_col: -1)
        assert(moved.state == .INVALID_MOVE, "Out of bound positions")
        
        //Not closest row to red
        moved = self.single_game!.move_piece(from_row: 5, from_col: 0, to_row: 4, to_col: 0)
        assert(moved.state == .INVALID_MOVE, "Not closest row to red")
        
        //Invalid number of steps
        moved = self.single_game!.move_piece(from_row: 0, from_col: 0, to_row: 2, to_col: 0)
        assert(moved.state == .INVALID_MOVE, "Invalid number of steps")
    }
    
    func test_valid_move_single_player_AI_first_red() {
        self.single_game = Game(single_player_mode: true, first_player: .RED, AI_color: .RED)
        var moved = self.single_game!.make_first_move()
        assert(moved.state == .VALID_MOVE, "The AI should be able to move first")
        
        //moving piece with one step
        moved = self.single_game!.move_piece(from_row: 5, from_col: 0, to_row: 4, to_col: 0)
        assert(moved.state == .VALID_MOVE, "The piece at (0,0) should have moved to (1,0)")
        //moving piece with three step
        moved = self.single_game!.move_piece(from_row: 5, from_col: 3, to_row: 2, to_col: 3)
        assert(moved.state == .VALID_MOVE, "The piece at (5,0) should have moved to (3,1)")
        //moving piece with two step
        moved = self.single_game!.move_piece(from_row: 5, from_col: 1, to_row: 3, to_col: 1)
        assert(moved.state == .VALID_MOVE, "The piece at (0,1) should have moved to (2,1)")
    }
    
    func test_valid_move_single_player_AI_first_blue() {
        self.single_game = Game(single_player_mode: true, first_player: .BLUE, AI_color: .BLUE)
        var moved = self.single_game!.make_first_move()
        assert(moved.state == .VALID_MOVE, "The AI should be able to move first")
        
        //moving piece with one step
        moved = self.single_game!.move_piece(from_row: 0, from_col: 5, to_row: 1, to_col: 5)
        assert(moved.state == .VALID_MOVE, "The piece at (0,0) should have moved to (1,0)")
        //moving piece with three step
        moved = self.single_game!.move_piece(from_row: 0, from_col: 3, to_row: 3, to_col: 3)
        assert(moved.state == .VALID_MOVE, "The piece at (5,0) should have moved to (3,1)")
        //moving piece with two step
        moved = self.single_game!.move_piece(from_row: 0, from_col: 1, to_row: 2, to_col: 1)
        assert(moved.state == .VALID_MOVE, "The piece at (0,1) should have moved to (2,1)")
    }
    
    func test_invalid_move_single_player_AI_first_red() {
        self.single_game = Game(single_player_mode: true, first_player: .RED, AI_color: .RED)
        //AI should go first
        var moved = self.single_game!.move_piece(from_row: 5, from_col: 5, to_row: 4, to_col: 5)
        assert(moved.state == .INVALID_MOVE, "The AI should be able to move first")
        
        //AI moving
        moved = self.single_game!.make_first_move()
        assert(moved.state == .VALID_MOVE, "The AI should be able to move first")
        
        //out of bound
        moved = self.single_game!.move_piece(from_row: -2, from_col: -1, to_row: 1, to_col: -1)
        assert(moved.state == .INVALID_MOVE, "Out of bound positions")
        
        //Not closest row to blue
        moved = self.single_game!.move_piece(from_row: 0, from_col: 0, to_row: 1, to_col: 0)
        assert(moved.state == .INVALID_MOVE, "Not closest row to red")
        
        //Invalid number of steps
        moved = self.single_game!.move_piece(from_row: 5, from_col: 5, to_row: 2, to_col: 0)
        assert(moved.state == .INVALID_MOVE, "Invalid number of steps")
    }
    
    func test_invalid_move_single_player_AI_first_blue() {
        self.single_game = Game(single_player_mode: true, first_player: .BLUE, AI_color: .BLUE)
        //AI should go first
        var moved = self.single_game!.move_piece(from_row: 0, from_col: 0, to_row: 1, to_col: 0)
        assert(moved.state == .INVALID_MOVE, "The AI should be able to move first")
        
        //AI moving
        moved = self.single_game!.make_first_move()
        assert(moved.state == .VALID_MOVE, "The AI should be able to move first")
        
        //out of bound
        moved = self.single_game!.move_piece(from_row: -2, from_col: -1, to_row: 1, to_col: -1)
        assert(moved.state == .INVALID_MOVE, "Out of bound positions")
        
        //Not closest row to red
        moved = self.single_game!.move_piece(from_row: 5, from_col: 5, to_row: 4, to_col: 5)
        assert(moved.state == .INVALID_MOVE, "Not closest row to red")
        
        //Invalid number of steps
        moved = self.single_game!.move_piece(from_row: 0, from_col: 0, to_row: 2, to_col: 0)
        assert(moved.state == .INVALID_MOVE, "Invalid number of steps")
    }
    
    func test_valid_move_double_players() {
        //player .RED mvoes from (0,0) to (1,0)
        var moved = self.double_game!.move_piece(from_row: 0, from_col: 0, to_row: 1, to_col: 0)
        assert(moved.state == .VALID_MOVE, "The piece at (0,0) should have moved to (1,0)")
        
        //player .BLUE moves from (5,5) to (4,4)
        moved = self.double_game!.move_piece(from_row: 5, from_col: 5, to_row: 4, to_col: 3)
        assert(moved.state == .VALID_MOVE, "The piece at (5,0) should have moved to (3,1)")
    }
    
    func test_invalid_move_double_players() {
        //not player .BLUE turn
        var moved = self.double_game!.move_piece(from_row: 5, from_col: 0, to_row: 4, to_col: 0)
        assert(moved.state == .INVALID_MOVE, "The piece at (5,0) should not have moved to (4,0)")
        
        //not the closest row
        moved = self.double_game!.move_piece(from_row: 0, from_col: 0, to_row: 1, to_col: 0)
        assert(moved.state == .VALID_MOVE, "The piece at (0,0) should have moved to (1,0)")
        moved = self.double_game!.move_piece(from_row: 5, from_col: 0, to_row: 4, to_col: 0)
        assert(moved.state == .VALID_MOVE, "The piece at (5,0) should have moved to (4,0)")
        moved = self.double_game!.move_piece(from_row: 1, from_col: 0, to_row: 0, to_col: 0)
        assert(moved.state == .INVALID_MOVE, "The piece at (1,0) should have moved to (0,0)")
    }
    
}