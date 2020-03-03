//
//  AequumCommOperation.swift
//  AequumPOCFramework
//
//  Created by Aleksandar Matijaca on 2019-11-06.
//  Copyright © 2019 Polyorb Inc. All rights reserved.
//

import Foundation

class AequumCommOperation: Operation {
    
    override func main() {
        // starting Location Service Provider...
        print("starting comm provider")
        
        while(true) {
            sleep(10)
            print("comm tic/toc")
        }
    }
}
