//
//  OnePiece.swift
//  Gyges242
//
//  Created by Osayd on 4/2/16.
//  Copyright © 2016 Osayd3. All rights reserved.
//

import Foundation

class OnePiece: Piece {
    let steps:Int = 1
    
    func copy() -> Piece {
        return OnePiece()
    }
    
}
