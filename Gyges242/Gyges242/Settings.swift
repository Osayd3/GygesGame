//
//  mainNavigationController.swift
//  Gyges242
//
//  Created by Osayd Abdu on 4/20/16.
//  Copyright © 2016 Osayd3. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Settings {
    private var first_palyer: Game.Player
    private var AI_playing_color: Game.Player
    private var single_player: Bool?
    private var random: Bool = false
    
    init() {
        self.first_palyer = .RED
        self.AI_playing_color = .BLUE
    }
    
    init(first_player_color: Game.Player, AI_color: Game.Player) {
        self.first_palyer = first_player_color
        self.AI_playing_color = AI_color
    }
    
    func get_AI_color() -> Game.Player {
        return self.AI_playing_color
    }
    
    func set_AI_color(color: Game.Player) {
        self.AI_playing_color = color
    }
    
    func get_first_player_color() -> Game.Player {
        return self.first_palyer
    }
    
    func set_first_player_color(color: Game.Player) {
        self.first_palyer = color
    }
    
    func set_random(random: Bool) {
        self.random = random
    }
    
    func is_random() -> Bool {
        return self.random
    }
    
    func is_single_player() -> Bool? {
        return self.single_player
    }
    
    func change_mode(single_player single_player: Bool?) {
        self.single_player = single_player
    }
    
    /**
     * Saving the current settings in disk.
     */
    func save(managed_context: NSManagedObjectContext) {
    }
    
    /**
     * Clearing any saved settings in disk.
     */
    private func clear_turn(managed_context: NSManagedObjectContext) {

    }
    
    /**
     * Loading the most recent saved settings from disk.
     */
    func load(managed_context: NSManagedObjectContext) {
        self.single_player = true
    }
    
}