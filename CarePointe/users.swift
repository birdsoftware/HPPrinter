//
//  users.swift
//  CarePointe
//
//  Created by Brian Bird on 3/29/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

class User {
    
    var firstLastName: String
    var company: String
    var id: String
    //var userName: String
    //var firstName: String
    //var lastName: String
    var roleType: String
    
    init(firstLastName: String/*firstName: String,
         lastName: String*/, company: String, id: String, /*userName: String,*/ roleType: String) {
        
        self.firstLastName = firstLastName
        //self.firstName = firstName
        //self.lastName = lastName
        self.company = company
        self.id = id
        //self.userName = userName
        self.roleType = roleType
    }
}

//var oldEmployes: [Employee] = [Employee(id: "1",pic:"Alice.png",name:"Alice Smith",position:"Nurse"),
//                               Employee(id:"2",pic:"brad.png",name:"Brad Smith MD",position:"Primary Doctor"),
//                               Employee(id:"12",pic:"bob.png",name:"Bob Smith PhD",position:"Hospital Coordinator")]
//
//var newEmployes: [Employee] = [Employee(id: "2", pic: "pic21.png", name: "Name21", position: "Position2"),
//                               Employee(id: "3", pic: "pic3.png", name: "Name3", position: "Position3")]
//
//for employee in newEmployes {
//    var isNew = true
//    for oldEmployee in oldEmployes {
//        if oldEmployee.id == employee.id {
//            oldEmployee.name = employee.name
//            oldEmployee.pic = employee.pic
//            oldEmployee.position = employee.position
//            isNew = false
//        }
//    }
//    if isNew {
//        oldEmployes.append(employee)
//    }
//}
//
//for employee in oldEmployes {
//    print("id: \(employee.id), \(employee.name), \(employee.pic), \(employee.position)")
//}
