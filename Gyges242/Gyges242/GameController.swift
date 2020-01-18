//
//  GameController.swift
//  Gyges242
//
//  Created by Osayd Abdu on 4/25/16.
//  Copyright © 2016 Osayd3. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class GameController {
    
    private var game: Game
    private var converter: CoordsPosition
    private var source: Position
    private var cur_player: Game.Player
    private var single_game: Bool
    private var settings: Settings?
    private var game_loaded: Bool
    private var game_ended: Bool
    
    init(height: CGFloat, width: CGFloat, random: Bool = false) {
        self.game = Game(random: random)
        self.converter = CoordsPosition(height: height, width: width)
        self.source = Position()
        self.cur_player = .RED
        self.single_game = false
        self.game_loaded = false
        self.game_ended = false
    }

    
    
    /**
     *  Creating a new default game model based on the current settings object.
     */
    func new_game() {
        let first_player = self.settings?.get_first_player_color()
        let AI_color = self.settings?.get_AI_color()
        if let setting = self.settings {
            let random = setting.is_random()
            self.game = Game(single_player_mode: self.single_game, first_player: first_player!, AI_color: AI_color!, random: random)
        }
        else {
            self.game = Game(single_player_mode: self.single_game, first_player: first_player!, AI_color: AI_color!)
        }
        self.game_ended = false
    }
    
    // A bunch of setters and getters for the instance variables.
    
    func set_height_and_width(height height: CGFloat, width:CGFloat) {
        self.converter = CoordsPosition(height: height, width: width)
    }
    
    func set_game(game: Game) {
        self.game = game
    }
    
    func set_source(x x: Int, y: Int) {
        self.source = Position(row: y, col: x)
    }
    
    func set_game_ended(status: Bool) {
        self.game_ended = status 
    }
    
    func set_single_game(is_single: Bool) {
        self.single_game = is_single
    }
    
    func get_source() -> (x: Int, y: Int) {
        return (self.source.col, self.source.row)
    }
    
    func get_source_converted() -> (x: CGFloat, y: CGFloat) {
        let (x, y) = get_source()
        return self.converter.coordinate_to_position(x: x, y: y)
    }
    
    func get_all_pieces() -> (piece_steps: Array<Int>, locations: Array<Position>) {
        return self.game.get_all_pieces()
    }
    
    func is_game_ended() -> Bool {
        return self.game_ended
    }
    
    func is_single_game() -> Bool {
        return self.single_game
    }
    
    func coordinate_to_position(x x: Int, y: Int) -> (x: CGFloat, y: CGFloat) {
        return self.converter.coordinate_to_position(x: x, y: y)
    }
    
    func position_to_coordinate(x x: CGFloat, y: CGFloat) -> (x: Int, y: Int) {
        return self.converter.position_to_coordinate(x: x, y: y)
    }
    
    func get_cell_size() -> CGFloat {
        return self.converter.get_cell_size()
    }
    
    func change_player() {
        self.cur_player = self.cur_player.opposite_player()
    }
    
    func make_first_move() -> (state: Game.Game_state, from: Position?, to: Position?) {
        return self.game.make_first_move()
    }
    
    func set_single_game_mode(first_player: Game.Player, AI_color: Game.Player) {
        self.set_single_game(true)
        self.game = Game(single_player_mode: true, first_player: first_player, AI_color: AI_color)
    }
    
    func undo() -> (human_from: Position?, human_to: Position?, AI_from: Position?, AI_to: Position?) {
        if self.game_ended {
            return (nil, nil, nil, nil)
        }
        return self.game.undo()
    }
    
    /**
     *  When view is about to disappear, this method is called to decide whether to save
     *  the current game (if it hasn't ended yet) or not.
     */
    func handle_view_will_disappear(managed_context: NSManagedObjectContext){
        if !self.game_ended {
            self.game.save(managed_context)
            self.settings!.save(managed_context)
        }
        else {
            self.game.clear(managed_context)
        }
    }
    
    /**
     * Moves a piece in the game_model
     */
    func move_source_to(to_row to_row: Int, to_col: Int) -> (state: Game.Game_state, from: Position?, to: Position?) {
        return self.game.move_piece(Position(row: self.source.row, col: self.source.col), to: Position(row: to_row, col: to_col))
    }
    
    /**
     *  Setting the settings of the game by creating a game_model ojbect with these settings.
     */
    func set_settings(setting: Settings, single_player: Bool?, resume: Bool = false) {
        self.settings = setting
        if let vs_AI = single_player {
            self.single_game = vs_AI
        }
        else {
            self.single_game = setting.is_single_player()!
        }
        let first_player = settings?.get_first_player_color()
        let AI_color = settings?.get_AI_color()
        let random = settings?.is_random()
        if !resume {
            self.game = Game(single_player_mode: self.single_game, first_player: first_player!, AI_color: AI_color!, random: random!)
        }
    }
    
}