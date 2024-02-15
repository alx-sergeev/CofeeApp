//
//  ProductOrder+CoreDataClass.swift
//  
//
//  Created by Сергеев Александр on 15.02.2024.
//
//

import Foundation
import CoreData

@objc(ProductOrder)
public class ProductOrder: NSManagedObject {}

extension ProductOrder {
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var price: Int16
    @NSManaged public var count: Int16
}

extension ProductOrder: Identifiable {}
