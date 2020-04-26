//
//  ScaleFor.swift
//  RampUp
//
//  Created by Chris Mercer on 26/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import Foundation

public class ScaleFor {
    
    static func item(obj: String) -> Float {
        switch obj {
            case "pipe": return 0.0012
            case "pyramid": return 0.0032
            case "quarter": return 0.0032
            default: return 0
        }
    }
}
