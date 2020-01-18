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

class MoveTests: XCTestCase {
    
    var test_move: Move?
    
    override func setUp() {
        super.setUp()
        let src = Position(row: 2, col: 2)
        let dst = Position(row: 3, col: 2)
        self.test_move = Move(from: src, to: dst, row_verifier: verify_x, col_verifier: verify_y)
    }
    
    
    func test() {
        
    }
    
    private func verify_x(x: Int) -> Bool{
        return x >= 0 && x < 6
        
    }
    private func verify_y(y: Int) -> Bool{
        return y >= 0 && y < 6
    }
    
    
    
}