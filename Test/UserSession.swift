//
//  UserSessionModel.swift
//  Test
//
//  Created by Chuck Krutsinger on 8/14/18.
//  Copyright © 2018 Countermind, LLC. All rights reserved.
//

import Foundation
import CoreData

protocol UserSession: PrimaryKey {
    
    var username: String? { get set }
    
    var roles: [Role]? { get }

    func add(role: Role)
    func add(roles: [Role])
    
    func remove(role: Role)
    func remove(roles: [Role])
    
}

extension UserSessionDB: UserSession {
  
    var roles: [Role]? {
        get {
            guard let rolesSet = rolesSet as? Set<RoleDB> else {
                return nil
            }
            let roles = Array(rolesSet)
            return roles
        }
    }
    
    func add(role: Role) {
        let roleToAdd = role as! RoleDB
        addToRolesSet(roleToAdd)
    }

    func add(roles: [Role]) {
        var rolesToAdd = Set<RoleDB>()
        for role in roles {
            let roleDB = role as! RoleDB
            rolesToAdd.insert(roleDB)
        }
        addToRolesSet(rolesToAdd as NSSet)
    }
    
    func remove(role: Role) {
        let roleToRemove = role as! RoleDB
        removeFromRolesSet(roleToRemove)
    }
    
    func remove(roles: [Role]) {
        var rolesToRemove = Set<RoleDB>()
        for role in roles {
            let roleDB = role as! RoleDB
            rolesToRemove.insert(roleDB)
        }
        removeFromRolesSet(rolesToRemove as NSSet)
    }

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = uniqueInt()
    }

}


