//
//  MainView.swift
//  Gyges242
//
//  Created by Osayd on 4/11/16.
//  Copyright © 2016 Osayd3. All rights reserved.
//

import Foundation
import UIKit



class MainViewController: UIViewController {
    
    @IBOutlet weak var single_player: UIButton!
    @IBOutlet weak var two_players: UIButton!
    @IBOutlet weak var resume: UIButton!
    private var settings: Settings
    private var loaded_game: Game?
    
    required init?(coder aDecoder: NSCoder) {
        self.settings = Settings()
        super.init(coder: aDecoder)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managed_context = appDelegate.managedObjectContext
        self.settings.load(managed_context)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        self.settings = Settings()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managed_context = appDelegate.managedObjectContext
        self.settings.load(managed_context)
        
    }
    
    /**
     *  Action listener to the single_button. It starts the segue to move to the gameView.
     */
    @IBAction func single_button_clicked(sender: AnyObject) {
        performSegueWithIdentifier("single_game", sender: nil)
    }
    
    /**
     *  Action listener to the two_button. It starts the segue to move to the gameView.
     */
    @IBAction func two_button_clicked(sender: AnyObject) {
        performSegueWithIdentifier("two_game", sender: nil)
        
    }
    
    /**
     *  Action listener to the to unwind from the GameView (It is there so the unwind happens)
     *  form the back button in the GameView (Nothing should happen here).
     */
    @IBAction func prepareForUnwindFromGame(segue: UIStoryboardSegue) {

    }
    
    /**
     *  Action listener to the to unwind from the SettingsView (It is there so the unwind happens)
     *  form the back button in the SettingsView. It sets the self.settings to the settings from 
     *  the settingsView.
     */
    @IBAction func prepareForUnwindFromSettings(segue: UIStoryboardSegue) {
        let source_veiw = segue.sourceViewController as! SettingsViewController
        self.settings = source_veiw.get_settings()
    }
    
    /**
     *  Overriding this function is important to make it possible for the other view to unwind to
     *  this view.
     */
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        return true
    }
    
    /**
     *  This defines whether a specific segue should be perfurmed or not. This returns true for all
     *  the segues except the resume because it needs to check the CoreData of whether a previous 
     *  game exist or not. If no game exits, it will show a warning message to the user.
     */
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "resume" {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managed_context = appDelegate.managedObjectContext
            
            let temp_game = Game()
            if temp_game.load(managed_context) {
                self.loaded_game = temp_game
                return true
            }
            else {
                let alert = UIAlertController(title: "Warning", message: "There is no previous unfinished game to be resumed!!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)

                return false
            }
        }
        return true
    }
    
    /**
     *  Preparing the segue by setting the destination view's appropriate values (aka sending
     *  info to the destination view). The resume, single_game, and two_game segues are prepared
     *  by setting the GameView game_controller object to the appropriate values. The settings
     *  segue is prepared by setting the setting as the current setting (so the previous chosen
     *  settings are not lost).
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "resume" {
            let target_nav = segue.destinationViewController as! UINavigationController
            let target_view = target_nav.viewControllers.first as! GameView
            let single_player = self.loaded_game!.is_single_game()
            target_view.set_game_controller(self.loaded_game!, setting: self.settings,
                                            single_player: single_player, resume: true)
        }
        else if segue.identifier == "single_game" {
            let target_nav = segue.destinationViewController as! UINavigationController            
            let target_view = target_nav.viewControllers.first as! GameView
            target_view.set_game_controller(nil, setting: self.settings, single_player: true)
        }
        else if segue.identifier == "two_game" {
            let target_nav = segue.destinationViewController as! UINavigationController
            let target_view = target_nav.viewControllers.first as! GameView
            target_view.set_game_controller(nil, setting: self.settings, single_player: false)
        }
        else if segue.identifier == "settings" {
            let target_nav = segue.destinationViewController as! UINavigationController
            let target_view = target_nav.viewControllers.first as! SettingsViewController
            target_view.set_settings(self.settings)
        }
    }
}