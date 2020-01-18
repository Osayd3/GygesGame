//
//  CoordsPosition.swift
//  Gyges242
//
//  Created by Osayd on 4/13/16.
//  Copyright © 2016 Osayd3. All rights reserved.
//

import Foundation
import UIKit

class CoordsPosition {
    private let nav_height: CGFloat
    private let height: CGFloat
    private let width: CGFloat
    private let side_margin: CGFloat
    private let up_down_margin: CGFloat
    private let cell_size: CGFloat
    
    
    init(height: CGFloat, width: CGFloat) {
        self.nav_height = CGFloat(64) + 15
        let up_down_margin = (height - self.nav_height) * 0.01
        let side_margin = width * 0.01
        self.height = (height - self.nav_height) - ( 2 * up_down_margin)
        self.width = width - (2 * side_margin)
        self.cell_size = min(self.width/6, self.height/8)
        self.side_margin = (width - cell_size * 6) / 2
        self.up_down_margin = nav_height + (height - cell_size * 8 - nav_height) / 2
    }
    
    func get_cell_size() -> CGFloat {
        return cell_size
    }
 
    /**
     *  Converting from board's space (rows and columns) into view's space (exact position in the
     *  screen).
     */
    func coordinate_to_position(x x: Int, y: Int) -> (x: CGFloat, y: CGFloat) {
        if x == 10 {
            return (side_margin + (2.5 * cell_size), up_down_margin + (CGFloat(y+1) * cell_size))
        }
        return (side_margin + (CGFloat(x) * cell_size), up_down_margin + (CGFloat(5-y+1) * cell_size))
    }
    
    /**
     *  Converting from view's space (exact position in the screen) into board's space
     *  (rows and columns).
     */
    func position_to_coordinate(x x: CGFloat, y:CGFloat) -> (x: Int, y: Int) {
        let ret_x = (x - side_margin) / cell_size
        let ret_y = (y - up_down_margin) / cell_size
        
        return (Int(floor(ret_x)), 5-Int(floor(ret_y-1)))
    }
    
}