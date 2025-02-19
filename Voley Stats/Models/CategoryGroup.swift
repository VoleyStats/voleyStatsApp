//
//  CategoryGroup.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 25/5/24.
//

import SwiftUI

class CategoryGroup:Model{
    var name: String
    
    init(id: Int, name: String){
        self.name = name
        super.init(id: id)
        
    }
    
    override var description : String {
        return self.name
    }
}
