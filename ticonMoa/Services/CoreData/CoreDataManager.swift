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
    
    func insert(coupon: Coupon) -> Bool {
        let taskContext = self.newTaskContext()
        if isExist(barcode: coupon.barcode) {
            return false
        }
        let object = ManagedCoupon(context: taskContext)
        object.configure(coupon: coupon)
        do {
            try taskContext.save()
            return true
        } catch {
            print("core data save error")
            return false
        }
    }
    
    func fetchAll() -> [ManagedCoupon] {
        let fetchRequest: NSFetchRequest<ManagedCoupon> = ManagedCoupon.fetchRequest()
        return _fetch(with: fetchRequest)
    }
    
    func fetchAllCoupons() -> [Coupon] {
        let coupons: [ManagedCoupon] = fetchAll()
        return coupons.map { Coupon(coupon: $0) }
    }
    
    func isExist(barcode: String) -> Bool {
        let fetchRequest: NSFetchRequest<ManagedCoupon> = ManagedCoupon.fetchRequest()
        let barcodePredict = NSPredicate(format: "barcode == %@", barcode)
        fetchRequest.predicate = barcodePredict
        let ret = _fetch(with: fetchRequest)
        return ret.count > 0 ? true : false
    }
    
    func update(id: UUID, isUsed: Bool) {
        let fetchRequest: NSFetchRequest<ManagedCoupon> = ManagedCoupon.fetchRequest()
        let idPredict = NSPredicate(format: "identifier == %@", id as CVarArg)
        fetchRequest.predicate = idPredict
        let ret = _fetch(with: fetchRequest)
        ret.first?.isUsed = isUsed
        do {
            try mainContext.save()
        } catch {
            return
        }
    }
    
    private func _fetch(with request: NSFetchRequest<ManagedCoupon>) -> [ManagedCoupon] {
        do {
            return try mainContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func deleteAll() {
        let fetchRequest: NSFetchRequest<ManagedCoupon> = ManagedCoupon.fetchRequest()
        let obj = _fetch(with: fetchRequest)
        for o in obj {
            mainContext.delete(o)
        }
        do{
            try mainContext.save()
        }
        catch { print("c error") }
    }
    
    func delete(barcode: String) -> Bool {
        let fetchRequest: NSFetchRequest<ManagedCoupon> = ManagedCoupon.fetchRequest()
        let barcodePredict = NSPredicate(format: "barcode == %@", barcode)
        fetchRequest.predicate = barcodePredict
        let ret = _fetch(with: fetchRequest)
        for o in ret {
            mainContext.delete(o)
        }
        do{
            try mainContext.save()
            return true
        }
        catch {
            return false
        }
    }
}
