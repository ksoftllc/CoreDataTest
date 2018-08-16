import CoreData

/**
 This class provides core data management using both a main UI thread context and a background thread
 context. The two are linked so that changes on the main thread will replicate to the other thread
 in the background without blocking the UI. Important to use the correct context when accessing or
 manipulating data.
 */
final class CoreDataManager {
    
    // MARK: - Properties
    
    private let modelName: String
    
    /** context for main queue for actions on UI */
    private(set) lazy var mainManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        //setting private background context as parent will cause changes to replicate
        managedObjectContext.parent = self.privateManagedObjectContext
        return managedObjectContext
    }()
    
    /** context for private background queue */
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        //these guard against a broken build and should not fail if built correctly
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Missing data model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load data model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption : true,
                NSInferMappingModelAutomaticallyOption : true
            ]
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: options)
        } catch {
            //should only happen if the store is incompatible or not correctly versioned after changes
            fatalError("Failed to add persistent store - \(error), \(error.localizedDescription)")
        }
        
        return persistentStoreCoordinator
    }()
    
    //MARK: - Public
    
    init(modelName: String) {
        self.modelName = modelName
        
        setupNotificationHandling()
    }
    
    @objc func saveChanges(_ notification: Notification) {
        saveChanges()
    }
    
    // MARK: - Private
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        
        saveChangesIfAppTerminating(notificationCenter)
        
        saveChangesIfAppEnteringBackground(notificationCenter)
    }
    
    fileprivate func saveChangesIfAppTerminating(_ notificationCenter: NotificationCenter) {
        notificationCenter.addObserver(self,
                                       selector: #selector(saveChanges(_:)),
                                       name: Notification.Name.UIApplicationWillTerminate,
                                       object: nil)
    }
    
    fileprivate func saveChangesIfAppEnteringBackground(_ notificationCenter: NotificationCenter) {
        notificationCenter.addObserver(self,
                                       selector: #selector(saveChanges(_:)),
                                       name: Notification.Name.UIApplicationDidEnterBackground,
                                       object: nil)
    }
    
    func saveChanges() {
        mainManagedObjectContext.performAndWait {
            do {
                if self.mainManagedObjectContext.hasChanges {
                    try self.mainManagedObjectContext.save()
                }
            } catch {
                print("Failed to save data changes")
                print("\(error), \(error.localizedDescription)")
            }
        }
        
        privateManagedObjectContext.perform {
            do {
                if self.privateManagedObjectContext.hasChanges {
                    try self.privateManagedObjectContext.save()
                }
            } catch {
                print("Unable to Save Changes of Private Managed Object Context")
                print("\(error), \(error.localizedDescription)")
            }
        }
    }
    
}
