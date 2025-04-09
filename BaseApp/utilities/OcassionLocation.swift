//
//  OcassionLocation.swift
//  BaseApp
//
//  Created by Ihab yasser on 27/04/2024.
//

import Foundation
class OcassionLocation: NSObject {
    
    static let shared:OcassionLocation = OcassionLocation()
    
    
    func save(area:Area){
        let defaults = UserDefaults.standard
        if let encodedUser = try? JSONEncoder().encode(area) {
            defaults.set(encodedUser, forKey: "Area")
        }
    }
    
    func removeArea(){
        UserDefaults.standard.removeObject(forKey: "Area")
    }
    
    @MainActor func getAreaId() -> String {
        return getArea()?.id ?? ""
    }
    
 
    
    @MainActor func getArea() -> Area?{
        let defaults = UserDefaults.standard
        if let savedUserData = defaults.data(forKey: "Area") {
            if let loadedUser = try? JSONDecoder().decode(Area.self, from: savedUserData) {
                return loadedUser
            }
        }
        return nil
    }
    
    
    func loadAreas(callback:@escaping ((Areas?) -> ())){
//        if let citiesStorationDate = DBManager.shared.lastCitiesStorationDate() {
//            if DateFormatter.differnceBetweenDates(first: Date(), last: citiesStorationDate) >= 3 {
//                loadAreas(callback: callback)
//            }else {
                remoteAreas(callback: callback)
//            }
//        }else {
//            remoteAreas(callback: callback)
//        }
    }
    
    
    private func localAreas(callback:@escaping ((Areas?) -> ())){
        let decoder = JSONDecoder()
        do{
            if let citiesStr = DBManager.shared.fetchCities(), let data = citiesStr.data(using: .utf8) {
                let areas = try decoder.decode(Areas.self, from: data)
                callback(areas)
            }
        }catch{
            print("loadCitiesFromLocalStorageError \(error.localizedDescription)")
        }
    }
    
    
    private func remoteAreas(callback:@escaping ((Areas?) -> ())){
        AreasControllerAPI.areas { data, error in
            DispatchQueue.main.async {
                if let error = error {
                    MainHelper.handleApiError(error)
                }else if let data = data{
                    DBManager.shared.saveAreas(data)
                    callback(data)
                }
            }
        }
    }
    
}
