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
    
    func insert(gifticon: Coupon) -> Bool {
        let taskContext = self.newTaskContext()
        if isExist(barcode: gifticon.barcode) {
            return false
        }
        let object = ManagedCoupon(context: taskContext)
        object.configure(gifticon: gifticon)
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
    
    func delete(gifticon: Coupon?) {
        guard let coupon = gifticon else { return }
        let fetchRequest: NSFetchRequest<ManagedCoupon> = ManagedCoupon.fetchRequest()
        let barcode = coupon.barcode
        let barcodePredict = NSPredicate(format: "barcode == %@", barcode)
        fetchRequest.predicate = barcodePredict
        let ret = _fetch(with: fetchRequest)
        for o in ret {
            mainContext.delete(o)
        }
        do{
            try mainContext.save()
        }
        catch { print("c error") }
    }
}
