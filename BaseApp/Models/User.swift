//
//  User.swift
//  BaseApp
//
//  Created by Ihab yasser on 13/03/2024.
//

import Foundation

public class User: Codable {
    public var details: UserDetails?
    public let token: String?
    
    enum CodingKeys: String, CodingKey {
        case details, token
    }
    
    init(details: UserDetails? = nil, token: String? = nil) {
        self.details = details
        self.token = token
    }
    
    func save(){
        UserDefaults.standard.setValue(self.convertToString, forKey: "User")
        NotificationCenter.default.post(name: Notification.Name("user.updated"), object: nil)
    }
    
    func isSocail(){
        UserDefaults.standard.setValue(true, forKey: "isSocail")
    }
    
    func getIsSocail() -> Bool {
        return UserDefaults.standard.bool(forKey: "isSocail")
    }
    
    static func load() -> User? {
        let userString = UserDefaults.standard.string(forKey: "User") ?? ""
        let user = try? JSONDecoder().decode(User.self, from: userString.data(using: .utf8)!)
        return user
    }
    
    static func remove(){
        OcassionDate.shared.removeDate()
        OcassionLocation.shared.removeArea()
        UserDefaults.standard.removeObject(forKey: "User")
        UserDefaults.standard.setValue(false, forKey: "isSocail")
    }
}

