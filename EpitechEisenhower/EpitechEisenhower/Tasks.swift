//
//  Tasks.swift
//  EpitechEisenhower
//
//  Created by khaldor on 03/04/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import Foundation

class Task {
    var desc : String
    var important : Bool
    var urgent : Bool
    var label : String
    var date : String
    var id : String
    
    init (label : String, desc : String, date : String, urgent : Bool, important : Bool, id: String) {
        self.label = label
        self.desc = desc
        self.date = date
        self.urgent = urgent
        self.important = important
        self.id = id
    }
    
    func returnTaskAsDictionary() ->NSDictionary {
        let taskDictionary : NSDictionary = ["label" : label, "desc" : desc, "date" : date, "urgent" : urgent, "important" : important, "uid": id]
        return taskDictionary
    }
}
