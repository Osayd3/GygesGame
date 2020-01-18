//
//  Game.swift
//  Gyges242
//
//  Created by Osayd on 4/4/16.
//  Copyright © 2016 Osayd3. All rights reserved.
//

import Foundation
import CoreData


class Game {
    
    enum Game_state {
        case VALID_MOVE
        case INVALID_MOVE
        case GAME_ACTIVE
        case BLUE_WON
        case RED_WON
    }
    enum Player {
        //Red player's moves from row 0
        case RED
        //Blue player's  moves from row 5
        case BLUE
        func opposite_player() -> Player{
            if self == .RED {
                return .BLUE
            }
            else {
                return .RED
            }
        }
    }
    
    private let board: Board
    private let height, width: Int
    private var occupied_matrix: [[Bool]]
    private var current_player: Player
    private var current_available_moves: [Move]?
    private var AI: AIAgent?
    private var AI_first = false
    private var state: Game_state
    private var moves_history = Stack<Move>()
    
    //By default the game is a 2 players mode
    init(random: Bool = false) {
        self.board = Board(random: random)
        self.height = 6
        self.width = 6
        self.occupied_matrix = Array(count: self.height, repeatedValue: Array(count: self.width, repeatedValue: false))
        self.current_player = .RED
        self.state = .GAME_ACTIVE
        fill_occupied_matrix()
    }
    
    init(single_player_mode: Bool, first_player: Player = .RED, AI_color: Player = .BLUE, random: Bool = false) {
        self.board = Board(random: random)
        self.height = 6
        self.width = 6
        self.occupied_matrix = Array(count: self.height, repeatedValue: Array(count: self.width, repeatedValue: false))
        self.current_player = first_player
        self.state = .GAME_ACTIVE
        fill_occupied_matrix()
        if single_player_mode {
            self.AI = AIAgent()
            if first_player == AI_color {
                AI_first = true
            }
        }
    }
    
    /**
     *  Moves a piece from the position "from" to the position "to" and return the game state. 
     *  If the game is single it also moves the AI piece and return the from and to position the
     *  AI agent took. (this function is just a wrapper to the next function with Position 
     *  parameters instead of rows and columns).
     */
    func move_piece(from: Position, to: Position) -> (state: Game_state, from: Position?, to: Position?) {
        let from_row = from.row
        let from_col = from.col
        let to_row   = to.row
        let to_col   = to.col
        return move_piece(from_row: from_row, from_col: from_col, to_row: to_row, to_col: to_col)
    }
    
    /**
     *  Moves a piece from the position (from_row, from_col) to the position "(to_row, to_col) 
     *  and return the game state. If the game is single it also moves the AI piece and return 
     *  the from and to position the AI agent took.
     */
    func move_piece(from_row from_row: Int, from_col: Int, to_row: Int, to_col: Int) -> (state: Game_state, from: Position?, to: Position?) {
        if self.AI_first {
            return (.INVALID_MOVE, nil, nil)
        }
        let next_state = move_piece_in_the_board(from_row: from_row, from_col: from_col, to_row: to_row, to_col: to_col)
        switch next_state {
            case .INVALID_MOVE, .BLUE_WON, .RED_WON:
                return (next_state, nil, nil)
            default:
                break
        }
        
        let from_1 = Position(row: from_row, col: from_col)
        let to_1   = Position(row: to_row, col: to_col)
        self.moves_history.push(Move(from: from_1, to: to_1))
        
        if let _ = self.AI {
           let (AI_next_state, from, to) =  move_AI_piece()
            if from == Position() {
                return (AI_next_state, nil, nil)
            }
            self.moves_history.push(Move(from: from, to: to))
            return (AI_next_state, from, to)
        }
        
        return (next_state, nil, nil)
    }
    
    /**
     *  Makes a move to the AI agent if and only if it is the first move in the game and 
     *  the AI agent suppose to move first.
     */
    func make_first_move() -> (state: Game_state, from: Position?, to: Position?) {
        if self.AI_first {
            self.AI_first = false
            let moved = move_AI_piece()
            return (moved.state, moved.from, moved.to)
        }
        return (.INVALID_MOVE, nil, nil)
    }
    
    func is_single_game() -> Bool {
        if let _ = self.AI {
            return true
        }
        return false
    }
    
    
    /**
     *  Moves a piece in the board that the AI agent chooses if the AI agent is defined.
     */
    private func move_AI_piece() -> (state: Game_state, from: Position, to: Position) {
        if let agent = self.AI {
            let AI_move = agent.choose_a_move(self.board.copy(), cur_turn: self.current_player, depth: 3)
            let AI_state = move_piece_in_the_board(from_row: AI_move.src.row, from_col: AI_move.src.col, to_row: AI_move.dst.row, to_col: AI_move.dst.col)
            return (AI_state, AI_move.src, AI_move.dst)
        }
        return (self.state, Position(), Position())
    }
    
    /**
     * Moves a piece from (from_row, from_col) to (to_row, to_col), and return the state of the game.
     */
    private func move_piece_in_the_board(from_row from_row: Int, from_col: Int, to_row: Int, to_col: Int) -> Game_state {
        if self.state == .BLUE_WON  || self.state == .RED_WON{
            return self.state
        }
        if !is_valid_row(from_row) {
            return .INVALID_MOVE
        }
        let from = Position(row: from_row, col: from_col)
        let to   = Position(row: to_row  , col: to_col)
        let move = Move(from: from, to: to, row_verifier: verify_row, col_verifier: verify_col)
        set_available_moves_to_current_player()
        if self.current_available_moves!.indexOf({move.equals($0)}) != nil {
            let moved_val = board.make_move(move)
            if moved_val == 1 {
                board.print_board()
                self.current_available_moves = nil
                self.current_player = self.current_player.opposite_player()
                update_occupied_matrix(from, to: to)
                return .VALID_MOVE
            }
            else if moved_val == 2 {
                board.print_board()
                print("Player \(self.current_player) is the winner of this game.")
                self.state = self.current_player == .RED ? .RED_WON : .BLUE_WON
                return self.state
            }
        }
        return .INVALID_MOVE
    }
    
    /**
     * check if the from_row parameter is the nearest row the current player of which he has piece.
     */
    private func is_valid_row(from_row:Int) -> Bool {
        if from_row >= self.height || from_row < 0 {
            return false
        }
        let range = self.current_player == .RED ? (0 ... from_row).reverse().reverse() : (0 ..< self.height).reverse()
        for row in range {
            for col in 0 ..< self.width {
                if occupied_matrix[row][col] {
                    return row == from_row
                }
            }
        }
        return false
    }
    
    /**
     *  Undo the last move. If it is a single game mode, then two moves will be undone. The first
     *  being the AI agent move and the second being the human move. If it is a two player mode, 
     *  then, the game change the player's turn.
     */
    func undo() -> (human_from: Position?, human_to: Position?, AI_from: Position?, AI_to: Position?) {
        if moves_history.empty() {
            return (nil, nil, nil, nil)
        }
        
        if let _ = self.AI {
            let AI_move = moves_history.pop()
            board.make_reverse_move(AI_move)
            var human_move: Move
            if moves_history.empty() {
                return (nil, nil, AI_move.dst, AI_move.src)
            }
    
            human_move = moves_history.pop()
            board.make_reverse_move(human_move)
            board.print_board()
            return (human_move.dst, human_move.src, AI_move.dst, AI_move.src)
        }
        else {
            let human_move = moves_history.pop()
            board.make_reverse_move(human_move)
            self.current_player = self.current_player.opposite_player()
            board.print_board()
            return (human_move.dst, human_move.src, nil, nil)
        }
        
    }
    
    func get_copy_of_board() -> Board {
        return self.board.copy()
    }
    
    private func set_available_moves_to_current_player() {
        if let _ = self.current_available_moves {
            return
        }
        self.current_available_moves = board.set_available_moves(self.current_player)
    }

    private func fill_occupied_matrix() {
        for i in 0 ..< self.width {
            self.occupied_matrix[0][i] = true
            self.occupied_matrix[self.height-1][i] = true
        }
    }
    
    private func update_occupied_matrix(from: Position, to: Position) {
        occupied_matrix[from.row][from.col] = false
        occupied_matrix[to.row][to.col]     = true
    }
    
    private func set_occupied_matrix() {
        for row in 0 ..< self.height {
            for col in 0 ..< self.width {
                self.occupied_matrix[row][col] = board.is_occupied(row: row, col: col)
            }
        }
    }
    
    private func verify_row(row: Int) -> Bool{
        return row >= 0 && row < self.width
    }
    
    private func verify_col(col: Int) -> Bool{
        return col >= 0 && col < self.height
    }
    
    func get_all_pieces() -> (piece_steps: Array<Int>, locations: Array<Position>) {
        return self.board.get_all_pieces()
    }
    
    func save(managed_context: NSManagedObjectContext) {
        clear(managed_context)
        save_board(managed_context)
        save_turn(managed_context)
    }
    
    func clear(managed_context: NSManagedObjectContext) {
        clear_board(managed_context)
        clear_turn(managed_context)
    }
    
    func load(managed_context: NSManagedObjectContext) -> Bool{
        return load_board(managed_context) && load_turn(managed_context)
    }
    
    /**
     * Loading the turn board configuration into disk.
     */
    private func save_board(managed_context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("BoardConfiguration", inManagedObjectContext: managed_context)
        let (pieces, locations) = board.get_all_pieces()
        
        for i in 0 ..< pieces.count {
            let piece = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managed_context)
            piece.setValue(pieces[i], forKey: "steps")
            piece.setValue(locations[i].row, forKey: "row")
            piece.setValue(locations[i].col, forKey: "column")
        }
        
        do {
            try managed_context.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    /**
     * Saving the turn info into disk.
     */
    private func save_turn(managed_context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Turn", inManagedObjectContext: managed_context)
        let settings = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managed_context)
        settings.setValue(self.current_player == .RED, forKey: "red_turn")
        if let _ = self.AI {
            settings.setValue(true, forKey: "single_player_mode")
        }
        else {
            settings.setValue(false, forKey: "single_player_mode")
        }
        
        do {
            try managed_context.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    /**
     * clearing the board configuration in disk.
     */
    private func clear_board(managed_context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest(entityName: "BoardConfiguration")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managed_context.executeRequest(deleteRequest)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    /**
     * clearing the turn info in disk.
     */
    private func clear_turn(managed_context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest(entityName: "Turn")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managed_context.executeRequest(deleteRequest)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    /**
     * Loading the board configuration from disk.
     */
    private func load_board(managed_context: NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest(entityName: "BoardConfiguration")
        do {
            let results = try managed_context.executeFetchRequest(fetchRequest)
            let array_of_pieces = results as! [NSManagedObject]
            var pieces_steps = Array<Int>()
            var locations = Array<Position>()
            
            for i in 0 ..< array_of_pieces.count {
                let steps = array_of_pieces[i].valueForKey("steps") as! Int
                let row   = array_of_pieces[i].valueForKey("row") as! Int
                let col   = array_of_pieces[i].valueForKey("column") as! Int
                pieces_steps.append(steps)
                locations.append(Position(row: row, col: col))
            }
            
            if pieces_steps.count == 0 {
                return false
            }

            self.board.set_all_pices(pieces_steps, locations: locations)
            set_occupied_matrix()
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
    /**
     * Loading the turn info from disk.
     */
    private func load_turn(managed_context: NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest(entityName: "Turn")
        do {
            let turn_array = try managed_context.executeFetchRequest(fetchRequest)
            let results = turn_array as! [NSManagedObject]
            if results.count == 0 {
                return false
            }
            let red_turn = results[0].valueForKey("red_turn") as! Bool
            let sinlge_player_mode = results[0].valueForKey("single_player_mode") as! Bool
            self.current_player = red_turn ? .RED : .BLUE
            self.AI = sinlge_player_mode ? AIAgent() : nil
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
    
}