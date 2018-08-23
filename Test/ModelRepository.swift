//
//  Repository.swift
//  Test
//
//  Created by Chuck Krutsinger on 8/15/18.
//  Copyright © 2018 Countermind, LLC. All rights reserved.
//

import Foundation
import CoreData

class ModelRepository {
    
    private var coreDataManager = CoreDataManager(modelName: "Model", storeType: NSSQLiteStoreType)

    func createRole(name: String, type: RoleType) -> Role {
        let newRole = RoleDB(context: coreDataManager.mainManagedObjectContext)
        newRole.roleName = name
        newRole.roleType = type
        return newRole
    }
    
    func createUserSession(username: String, roles: [Role]) -> UserSession {
        let session = UserSessionDB(context: coreDataManager.mainManagedObjectContext)
        session.username = username
        session.add(roles: roles)
        return session
    }
    
    func fetchAllUserSession() -> [UserSession] {
        let fetchRequest: NSFetchRequest<UserSessionDB> = UserSessionDB.fetchRequest()
        do {
            let results = try coreDataManager.mainManagedObjectContext.fetch(fetchRequest)
            return results
        } catch  {
            return []
        }
    }
    
    func save() {
        coreDataManager.saveChanges()
    }
}
