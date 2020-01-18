//
//  SettingsView.swift
//  Gyges242
//
//  Created by Osayd Abdu on 4/20/16.
//  Copyright © 2016 Osayd3. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    private var settings: Settings
    
    @IBOutlet weak var blue_first: UILabel!
    @IBOutlet weak var switch_blue_first: UISwitch!
    @IBOutlet weak var single_player_blue: UILabel!
    @IBOutlet weak var switch_single_player_blue: UISwitch!
    @IBOutlet weak var random: UILabel!
    @IBOutlet weak var switch_random: UISwitch!
    
    
    required init?(coder aDecoder: NSCoder) {
        self.settings = Settings()
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        self.settings = Settings()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /**
     *  Setting the defualt swtiches to the current settings and setting the font width
     *  to true (so it adjust to be smaller if the screen is smaller.
     */
    override func viewDidLoad() {
        blue_first.adjustsFontSizeToFitWidth = true
        single_player_blue.adjustsFontSizeToFitWidth = true
        random.adjustsFontSizeToFitWidth = true
        switch_blue_first.on = settings.get_first_player_color() == .BLUE
        switch_single_player_blue.on = settings.get_AI_color() == .RED
        switch_random.on = settings.is_random()
    }
    
    /**
     * Action listner to the first switch
     */
    @IBAction func first_player_changed(sender: AnyObject) {
        let switch_object = sender as! UISwitch
        self.settings.set_first_player_color(switch_object.on ? .BLUE : .RED)
    }
    
    /**
     * Action listner to the second switch
     */
    @IBAction func AI_color_changed(sender: AnyObject) {
        let switch_object = sender as! UISwitch
        self.settings.set_AI_color(switch_object.on ? .RED : .BLUE)
    }
    
    /**
     * Action listner to the third switch
     */
    @IBAction func random_game_changed(sender: AnyObject) {
        let switch_object = sender as! UISwitch
        self.settings.set_random(switch_object.on)
    }
    
    func get_settings() -> Settings {
        return self.settings
    }
    
    func set_settings(setting: Settings) {
        self.settings = setting
    }
    

    
}