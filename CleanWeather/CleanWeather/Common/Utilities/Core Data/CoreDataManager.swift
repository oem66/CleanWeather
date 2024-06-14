//
//  CoreDataManager.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 14. 6. 2024..
//

import Foundation
import CoreData

final class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
    
    private let modelFileName = "CleanWeather"
    private let modelFileExtension = "momd"
    private let dbFilename = "CleanWeather.sqlite"
    
    private var storeIsNotLoad = true
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelFileName)
        return container
    }()
    
    lazy var mainMOC: NSManagedObjectContext = {
        let managedObjectContext = persistentContainer.viewContext
        managedObjectContext.automaticallyMergesChangesFromParent = true
        managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        managedObjectContext.undoManager = nil
        return managedObjectContext
    }()
    
    var writeMOC: NSManagedObjectContext {
        let backgroundMOC = persistentContainer.newBackgroundContext()
        backgroundMOC.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundMOC.undoManager = nil
        return backgroundMOC
    }
}

// MARK: - Public methods
extension CoreDataManager {
    func loadStores(completion: (() -> Void)? = nil) {
        guard storeIsNotLoad else {
            completion?()
            return
        }
        persistentContainer.loadPersistentStores { [weak self] (_, error) in
            guard let self = self else {
                completion?()
                return
            }
            if let error = error {
                fatalError(error.localizedDescription)
            }
            self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
            self.storeIsNotLoad = false
            completion?()
        }
    }
    
    func deleteAllEntities(exceptions: [String] = []) {
        persistentContainer.performBackgroundTask { [weak self] privateMOC in
            guard let self = self else { return }
            let entities = self.persistentContainer.managedObjectModel.entities
            for entity in entities {
                guard !exceptions.contains(entity.name!) else { continue }
                log.debug("Deleting Entity - \(String(describing: entity.name))")
                self.delete(entityName: entity.name!, moc: privateMOC)
            }
        }
    }
}

// MARK: - Private methods
private extension CoreDataManager {
    func delete(entityName: String, moc: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs

        do {
            let result = try moc.execute(deleteRequest)
            log.debug("Deleted Entity - \(entityName)")
            guard
                   let deleteResult = result as? NSBatchDeleteResult,
                   let ids = deleteResult.result as? [NSManagedObjectID]
            else { return }

            let changes = [NSDeletedObjectsKey: ids]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [mainMOC])
        } catch let error as NSError {
            log.debug("Delete ERROR \(entityName) - \(error.localizedDescription)")
        }
    }
}
