//
//  CoreDataManager.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 15.02.2024.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    private var appDelegate: AppDelegate! {
        UIApplication.shared.delegate as? AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    private let entityName = "ProductOrder"
    
    
    // MARK: - CRUD
    func create(item: Product, count: Int = 0) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            return
        }
        
        let product = ProductOrder(entity: entityDescription, insertInto: context)
        product.id = Int64(truncatingIfNeeded: item.id)
        product.name = item.name
        if let price = item.price {
            product.price = Int16(truncatingIfNeeded: price)
        }
        product.count = Int16(truncatingIfNeeded: count)
        
        appDelegate.saveContext()
    }
    
    func fetchItems() -> [ProductOrder] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            return (try context.fetch(fetchRequest) as? [ProductOrder]) ?? []
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchItem(with id: Int) -> ProductOrder? {
        let id = Int64(truncatingIfNeeded: id)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        
        do {
            guard let items = try context.fetch(fetchRequest) as? [ProductOrder] else { return nil }
            return items.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func update(entity: ProductOrder, count: Int) {
        entity.count = Int16(truncatingIfNeeded: count)
        appDelegate.saveContext()
    }
    
    func delete(entity: ProductOrder) {
        context.delete(entity)
        appDelegate.saveContext()
    }
}
