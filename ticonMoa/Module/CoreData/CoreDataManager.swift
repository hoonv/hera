//
//  CoreDataManager.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/11.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared: CoreDataManager = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TiconMoaModel")
        container.loadPersistentStores { (_, error) in
            guard error == nil else {
                print("load error persistentStroe")
                return
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        
    }
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        return taskContext
    }
    
    func insert(gifticon: Gifticon) {
        let taskContext = self.newTaskContext()
        if isExist(gifticon: gifticon) {
            return
        }
        let object = Coupon(context: taskContext)
        object.configure(gifticon: gifticon)
        do {
            try taskContext.save()
        } catch {
            print("core data save error")
        }
    }
    
    func fetchAll() -> [Coupon] {
        let fetchRequest: NSFetchRequest<Coupon> = Coupon.fetchRequest()
        return _fetch(with: fetchRequest)
    }
    
    func fetchAll() -> [Gifticon] {
        let coupons: [Coupon] = fetchAll()
        return coupons.map { Gifticon(coupon: $0) }
    }
    
    func isExist(gifticon: Gifticon) -> Bool {
        let fetchRequest: NSFetchRequest<Coupon> = Coupon.fetchRequest()
        let barcode = gifticon.barcode
        let barcodePredict = NSPredicate(format: "barcode == %@", barcode)
        fetchRequest.predicate = barcodePredict
        let ret = _fetch(with: fetchRequest)
        return ret.count > 0 ? true : false
    }
    
    private func _fetch(with request: NSFetchRequest<Coupon>) -> [Coupon] {
        do {
            return try mainContext.fetch(request)
        } catch {
            return []
        }
    }
}
