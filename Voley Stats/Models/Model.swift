//
//  Model.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 7/3/24.
//

import SwiftUI
import AppIntents

class Model: Equatable{
    var id:Int
    static func ==(lhs: Model, rhs: Model) -> Bool {
        return lhs.id == rhs.id
    }
    var description : String {
        return ""
    }
    func toJSON()->Dictionary<String, Any>{
        return [:]
    }
    
    init(id: Int){
        self.id = id
    }
}
