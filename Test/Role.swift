//
//  RoleModel.swift
//  Test
//
//  Created by Chuck Krutsinger on 8/14/18.
//  Copyright © 2018 Countermind, LLC. All rights reserved.
//

import Foundation

protocol Role: Hashable {
    
    var roleName: String? { get set }

//    var hashValue: Int { get }
    
}

extension RoleDB: Role {
    

}
