//
//  GameViewContrller.swift
//  Gyges242
//
//  Created by Osayd on 4/11/16.
//  Copyright © 2016 Osayd3. All rights reserved.
//


import Foundation
import UIKit

class GameView: UIViewController {
    
    private var game_controller: GameController
    
    required init?(coder aDecoder: NSCoder) {
        self.game_controller = GameController(height: 0, width: 0)
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        self.game_controller = GameController(height: 0, width: 0)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /**
     *  Action listner to the "New game" button. It shows a warning messege when the game
     *  is not ended. Otherwise, it just restarts the game.
     */
    @IBAction func new_game() {
        if self.game_controller.is_game_ended() {
            start_new_game(UIAlertAction())
        }
        else {
            let msg = "You are about to start a new game. The current game will be lost. Are you sure you want to start a new game?"
            let alert = UIAlertController(title: "Warning", message: msg , preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: start_new_game))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    /**
     *  Overriding viewDidLoad() so that the initial screen would contain the board cells and
     *  the background along with the pieces (instead of an empty screen).
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        let height = self.view.bounds.height
        let width  = self.view.bounds.width
        game_controller.set_height_and_width(height: height, width: width)
        let background = UIImage(named: "background.jpg")
        let background_view = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        background_view.image = background
        self.view.addSubview(background_view)
        
        // Creating the board cells.
        for i in 1 ..< 7 {
            for j in 0 ..< 6 {
                let (x, y) = self.game_controller.coordinate_to_position(x:j, y: i-1)
                let cell_size = self.game_controller.get_cell_size()
                
                let view = UIView(frame: CGRect(x: x, y: y, width: cell_size, height: cell_size))
                let dark_color  = UIColor(red: 0.9, green: 1.0, blue: 0.7, alpha: 0.65)
                let light_color = UIColor(red: 0.2, green: 1.0, blue: 0.8, alpha: 0.65)
                if j % 2 == 0 {
                    view.backgroundColor = i % 2 == 0  ? dark_color : light_color
                } else {
                    view.backgroundColor = i % 2 == 0  ? light_color : dark_color
                }
                self.view.addSubview(view)
            }
        }
        
        fill_winning_cell(0)
        fill_winning_cell(7)
        fill_player_info(0)
        fill_player_info(7)
        create_share_button()
        
        let (steps, locations) = self.game_controller.get_all_pieces()
        fill_images(steps, locations: locations)
        
    }
    
    /**
     *  Creating the facebook share button to be at the top of the screen.
     */
    func create_share_button() {
        
    }
    
    /**
     *  When a shake motion ends, this function will show a message to the user to decide whether to undo the
     *  last move or not. If the game ended, no undo move can happen (a reminder message will be shown).
     */
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            if self.game_controller.is_game_ended() {
                let alert = UIAlertController(title: "Warning", message: "You can't undo a finished game",
                                              preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK :(", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            let msg = "Are you sure you want to undo last move?"
            let alert = UIAlertController(title: "Warning", message: msg , preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: undo_move))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    /**
     *  The undo move happens here by using the return value of the undo function from the
     *  game_controller class and move the pieces accordingly.
     */
    private func undo_move(sender: UIAlertAction) {
        let (from_human, to_human, from_AI, to_AI) = self.game_controller.undo()
        if self.game_controller.is_single_game() {
            if from_AI != nil {
                move_piece_in_view(from_AI!, to: to_AI!)
            }
        }
        if from_human != nil {
            move_piece_in_view(from_human!, to: to_human!)
        }
        if from_human == nil && from_AI == nil {
            let msg = "There is no previous move to be undone"
            let alert = UIAlertController(title: "Warning", message: msg , preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

    }
    /**
     *  After the view appears, try to make a move by calling "make_first_move".
     */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        make_first_move()
    }
    
    /**
     *  This checks whether both the game mode is a single player and AI plays first.
     *  If both conditition are true, the game waits for one second and the make a
     *  move for the AI by caling "make_first_move()" (otherwise this method has no
     *  effect on the game).
     */
    private func make_first_move() {
        // Adopted from a stackoverflow thread:
        // http://stackoverflow.com/questions/27517632/how-to-create-a-delay-in-swift
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            //put your code which should be executed with a delay here
            let ret = self.game_controller.make_first_move()
            if ret.from != nil {
                self.move_piece_in_view(ret.from!, to: ret.to!)
            }
            
        }
    }
    
    
    /**
     *  Before the view disappear, this method saves the board on the CoreData if the game
     *  has not ended.
     */
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managed_context = appDelegate.managedObjectContext
        self.game_controller.handle_view_will_disappear(managed_context)
    }
    
    /**
     *  Add the two texts identifying each player's side (blue and red).
     */
    private func fill_player_info(row: Int) {
        
        let cell_size = self.game_controller.get_cell_size()
        let (x, y) = self.game_controller.coordinate_to_position(x: row == 0 ? 4 : 0, y: row-1)
        let view = UIView(frame: CGRect(x: x, y: y, width: cell_size*2, height: cell_size))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell_size*2, height: cell_size))
        
        let blue_string = "BLUE Player"
        let blue_color  = UIColor(red: 0.62, green: 0.85, blue: 0.94, alpha: 1.0)
        let red_string  = "RED Player"
        let red_color   = UIColor(red: 0.9, green: 0.15, blue: 0.05, alpha: 1.0)
        
        label.contentMode = .ScaleToFill
        label.text = row == 0 ? red_string : blue_string
        label.textColor = row == 0 ? red_color : blue_color
        label.textAlignment = .Center
        label.adjustsFontSizeToFitWidth = true
        label.font = label.font.fontWithSize(40)
        view.addSubview(label)
        self.view.addSubview(view)
    }
    
    /**
     *  Adding the trophy cell at the specific row (and the middle colum) to the view.
     */
    private func fill_winning_cell(row: Int) {
        let cell_size = self.game_controller.get_cell_size()
        let (x, y) = self.game_controller.coordinate_to_position(x:10, y: row-1)
        let image = UIImage(named: "Winner.png")
        let image_view = UIImageView(image: image)
        image_view.contentMode = .ScaleToFill
        image_view.frame = CGRect(x: x, y: y, width: cell_size, height: cell_size)
        self.view.addSubview(image_view)
    }
    
    /**
     *  Adding all the pieces images into the view using the two arrays argument that
     *  defines the locations of each piece (locations) and the type of each piece (steps).
     */
    private func fill_images(steps: Array<Int>, locations: Array<Position>) {
        
        for i in 0 ..< steps.count {
            let row = locations[i].row
            let col = locations[i].col
            switch steps[i] {
            case 1:
                fill_one_cell(x_coord: col, y_coord: row, file_name: "One.png")
            case 2:
                fill_one_cell(x_coord: col, y_coord: row, file_name: "Two.png")
            case 3:
                fill_one_cell(x_coord: col, y_coord: row, file_name: "Three.png")
            default:
                break
            }
        }
    }
    
    /**
     *  Loading the file_name image into the specific x_coord and y_coord (for the pieces).
     */
    private func fill_one_cell(x_coord x_coord: Int, y_coord: Int, file_name: String){
        let image  = UIImage(named: file_name)
        let (x, y) = self.game_controller.coordinate_to_position(x: x_coord, y: y_coord)
        let cell_size = self.game_controller.get_cell_size()
        let image_view = UIImageView(frame: CGRect(x: x, y: y, width: cell_size, height: cell_size))
        image_view.image = image
        image_view.contentMode = .ScaleToFill
        image_view.userInteractionEnabled = true
        
        image_view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePan)))
        self.view.addSubview(image_view)
    }
    
    
    /**
     * A guesture handler for draging a board piece.
     * Inspired from a stackoverflow thread:
     * http://stackoverflow.com/questions/33316965/dragging-images-around-the-screen-using-swift
     */
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        
        if let view = recognizer.view {
            //When the player start moving a piece, the position is stored in self.source
            if recognizer.state == .Began {
                let (x, y) = self.game_controller.position_to_coordinate(x: view.center.x, y: view.center.y)
                self.game_controller.set_source(x: x, y: y)
            }
            
            /**
             * When the player leaves the piece, the position is tried as destination along with the source from
             * the self.source (from the above condition) and either retrun the piece to its source location (if
             * the destination is an invalid move) or keep it in the destination (if the destination is a valid
             * location).
             */
            if recognizer.state == .Ended {
                let (x, y) = self.game_controller.position_to_coordinate(x: view.center.x, y: view.center.y)
                let game_status = game_controller.move_source_to(to_row: y, to_col: x)
                let game_state = game_status.state
                if  game_state == .VALID_MOVE  || game_state == .BLUE_WON || game_state == .RED_WON {
                    let (x_pos, y_pos) = self.game_controller.coordinate_to_position(x: x, y: y)
                    let cell_size = self.game_controller.get_cell_size()
                    if self.game_controller.is_single_game() && game_status.from != nil {
                        move_piece_in_view(game_status.from!, to: game_status.to!)
                    }
                    check_game_ending(state: game_state, x: x, y: y, view: view)
                    
                    if game_state == .VALID_MOVE {
                        self.game_controller.change_player()
                        view.center = CGPoint(x: x_pos + cell_size/2, y: y_pos + cell_size/2)
                    }
                }//End if
                else {
                    recognizer.enabled = false
                    let (x_pos, y_pos) = self.game_controller.get_source_converted()
                    view.center = CGPoint(x: CGFloat(x_pos) + view.bounds.size.width/2, y: CGFloat(y_pos) + view.bounds.size.height/2)
                    recognizer.setTranslation(CGPointZero, inView: self.view)
                    recognizer.enabled = true
                    return
                }//End else
            } //End if reconizer == .Ended
            
            view.center = CGPoint(x:view.center.x + translation.x, y:view.center.y + translation.y)
        }
        
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    /**
     *  Moving a piece in the view from the "from" position to the "to" position by finding thier
     *  corresponding x and y coordinates int the board space (which row and column).
     */
    private func move_piece_in_view(from: Position, to: Position) {
        let (src_x, src_y) = self.game_controller.coordinate_to_position(x: from.col, y: from.row)
        let (dst_x, dst_y) = self.game_controller.coordinate_to_position(x: to.col, y: to.row)
        let cell_size = self.game_controller.get_cell_size()
        let src_view = get_piece_at(x: src_x + cell_size/2, y: src_y + cell_size/2)
        let new_position = CGPoint(x: dst_x + src_view.bounds.size.width/2, y: dst_y + src_view.bounds.size.height/2)
        src_view.center = new_position
    }
    
    /**
     * Changing the dragging guesture from all the board pieces based on the "enabled" argument.
     */
    private func enable_pan(enabled: Bool) {
        let subviews = self.view.subviews
        for i in (subviews.count - 12 ..< subviews.count).reverse() {
            subviews[i].gestureRecognizers?.last!.enabled = enabled
        }
    }
    
    /**
     *  Returing the subview at the positiong (x,y) in the screen space (exact position). If finds it
     *  by checking each subview's center and comparing it against the given (x,y) with some tolerance
     *  (20% of cell size) so to avoid any round error or any other kind of error.
     */
    private func get_piece_at(x x: CGFloat, y: CGFloat) -> UIView {
        let subviews = self.view.subviews
        let tol = self.game_controller.get_cell_size() * 0.2
        for i in (subviews.count - 12 ..< subviews.count).reverse() {
            let x_actual = subviews[i].center.x
            let y_actual = subviews[i].center.y
            if (x_actual - tol <= x  && x_actual + tol >= x ) && (y_actual - tol <= y  && y_actual + tol >= y) {
                return subviews[i]
            }
        }
        return UIView()
    }
    
    /**
     *  Checking if the game should be ended and act accordingly. if the game is not ended, nothing
     *  happens. Otherwise, the dragging (pan) guesture would be disabled, the game_ended varibale
     *  the game_controller would be set to true, and a winning message show to congratulate the
     *  winner.
     */
    private func check_game_ending(state state: Game.Game_state, x: Int, y: Int, view: UIView) {
        if state == .BLUE_WON || state == .RED_WON  {
            let (x_pos, y_pos) = self.game_controller.coordinate_to_position(x: x, y: y)
            let cell_size = self.game_controller.get_cell_size()
            enable_pan(false)
            view.center = CGPoint(x: x_pos + cell_size/2, y: y_pos + cell_size/2)
            let winner = state == .RED_WON ? "The RED " : "The BLUE "
            let alert = UIAlertController(title: "Winner", message: winner + "Player won!!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Great", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            self.game_controller.set_game_ended(true)
        }
    }
    
    /**
     * Setting the game_controller object with a game, settings, mode, and a resuem_mode.
     */
    func set_game_controller(game: Game?, setting: Settings, single_player: Bool?, resume: Bool = false) {
        if let game_obj = game {
            self.game_controller.set_game(game_obj)
        }
        self.game_controller.set_settings(setting, single_player: single_player, resume: resume)
    }
    
    /**
     * Relocate the piece to their original places for a new game to start.
     */
    private func start_new_game(sender: UIAlertAction) {
        self.game_controller.new_game()
        let subviews = self.view.subviews
        
        for counter in subviews.count-12 ..< subviews.count {
            subviews[counter].removeFromSuperview()
        }
        
        let (steps, locations) = self.game_controller.get_all_pieces()
        for i in 0 ..< steps.count {
            let row = locations[i].row
            let col = locations[i].col
            switch steps[i] {
            case 1:
                fill_one_cell(x_coord: col, y_coord: row, file_name: "One.png")
            case 2:
                fill_one_cell(x_coord: col, y_coord: row, file_name: "Two.png")
            case 3:
                fill_one_cell(x_coord: col, y_coord: row, file_name: "Three.png")
            default:
                break
            }
        }
        enable_pan(true)
        make_first_move()
    }
    
    /**
     *  Changing the center of a "subview" to (to_x, to_y) where to_x, and to_y are in board
     *  coordinates space (they are integers of rows and columns within the limits of the board)
     *  to the middle of the corresponding location (so to position a piece into the center of
     *  a cell).
     */
    private func change_location_of_subveiw(subview: UIView, to_x: Int, to_y: Int) {
        let (x, y) = self.game_controller.coordinate_to_position(x: to_x, y: to_y)
        let cell_size = self.game_controller.get_cell_size()
        subview.center = CGPoint(x: x + cell_size/2, y: y + cell_size/2)
    }
    
    
}
