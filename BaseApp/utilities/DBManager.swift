//
//  Helper+DB.swift
//  Celebrate
//
//  Created by ehab on 02/05/2021.
//

import Foundation
import UIKit
import CoreData

class DBManager {
    static let shared = DBManager()
    private var appDel:AppDelegate!
    private var context:NSManagedObjectContext!
    
    init() {
        appDel = UIApplication.shared.delegate as? AppDelegate
        context = appDel.persistentContainer.newBackgroundContext()
    }
    
    func saveAreas(_ cities: Areas) {
        do {
            let citiesEntity = NSEntityDescription.insertNewObject(forEntityName: "Cities", into: context)
            citiesEntity.setValue(cities.convertToString, forKey: "cities")
            citiesEntity.setValue(Date(), forKey: "date")
            try context.save()
        } catch {
            print("saveCitiesError \(error.localizedDescription) ")
        }
    }
    
    
    
    
    func lastCitiesStorationDate() -> Date? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cities")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                return data.value(forKey: "date") as? Date
            }
        } catch {
            print("Fetching data Failed")
        }
        return nil
    }
    
    func deleteAllCities(entity: String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do{
            let results = try context.fetch(fetchRequest)
            for managedObject in results{
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    func fetchCities() -> String?{
        print("Fetching Data..")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cities")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                return data.value(forKey: "cities") as? String
            }
        } catch {
            print("Fetching data Failed")
        }
        return nil
    }
    
    /////////////////////////////////////////////////////////////////////////////
    func saveSearchTxt(searchHistory: SearchHistory) {
        context.perform {
            self.fetchSearchHistory { history in
                do {
                    if history?.isEmpty == true { return }
                    if history?.contains(where: { $0.productId == searchHistory.productId }) == true {
                        return
                    }
                    let citiesEntity = NSEntityDescription.insertNewObject(forEntityName: "Search", into: self.context)
                    citiesEntity.setValue(searchHistory.searchTxt, forKey: "searchTxt")
                    if let img = searchHistory.img {
                        citiesEntity.setValue(img, forKey: "img")
                    }
                    citiesEntity.setValue(searchHistory.uuid, forKey: "id")
                    citiesEntity.setValue(searchHistory.productId, forKey: "productId")
                    try self.context.save()
                } catch {
                    print("saveCitiesError \(error.localizedDescription) ")
                }
            }
        }
    }
    
    
    func fetchSearchHistory(callback: @escaping ([SearchHistory]?) -> Void){
        context.perform {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Search")
            request.returnsObjectsAsFaults = false
            do {
                let result = try self.context.fetch(request)
                var history: [SearchHistory] = []
                for data in result as! [NSManagedObject] {
                    if let text = data.value(forKey: "searchTxt") as? String, let uuid = data.value(forKey: "id") as? UUID, let productId = data.value(forKey: "productId") as? String{
                        history.append(SearchHistory(uuid: uuid, productId: productId , searchTxt: text, img: data.value(forKey: "img") as? String))
                    }
                }
                callback(history.reversed())
                 
            } catch {
                print("Fetching data Failed")
            }
        }
    }
    
    func deleteHistoryItem(id: UUID){
        context.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Search")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            do{
                let results = try self.context.fetch(fetchRequest)
                if let itemToDelete = results.first as? NSManagedObject{
                    self.context.delete(itemToDelete)
                    try self.context.save()
                    print("Item deleted successfully.")
                } else {
                    print("Item not found.")
                }
            } catch let error as NSError {
                print("Detele all data in error : \(error) \(error.userInfo)")
            }
        }
    }
    
}
