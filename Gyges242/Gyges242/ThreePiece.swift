//
//  ThreePiece.swift
//  Gyges242
//
//  Created by Osayd on 4/2/16.
//  Copyright © 2016 Osayd3. All rights reserved.
//

import Foundation

class ThreePiece: Piece {
    
    let steps:Int = 3
    
    func copy() -> Piece {
        return ThreePiece()
    }
}