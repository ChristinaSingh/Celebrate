//
//  ProfileViewModel.swift
//  BaseApp
//
//  Created by Ihab yasser on 24/05/2024.
//

import Foundation
import Combine


class ProfileViewModel:NSObject{
    
    @Published var loading: Bool = false
    @Published var updateloading: Bool = false
    @Published var error: Error?
    @Published var updatedUser:User?
    @Published var favoritesUpdated:AppResponse?
    @Published var likes:[Product]?
    @Published var avatars:[AvatarResponse]?
    
    
    
    func updateProfile(name:String? , email:String? , mobile:String? , birthday:String? , username:String? , ispublic:String?){
        loading = true
        ProfileControllerAPI.updateProfile(name: name, email: email, mobile: mobile, birthday: birthday, username: username, ispublic: ispublic) { data, error in
            self.loading = false
            if error != nil {
                self.error = error
            }else{
                self.updatedUser = data
            }
        }
    }
    
    
    func changePassword(password:String, mobile:String){
        loading = true
        ProfileControllerAPI.changePassword(password: password, mobile: mobile) { data, error in
            self.loading = false
            if error != nil {
                self.error = error
            }else{
                self.updatedUser = data
            }
        }
    }
    
    
    func getLikes(subCatId:String){
        loading = true
        ProfileControllerAPI.favorites(subCatId: subCatId) { data, error in
            self.loading = false
            if error != nil {
                self.error = error
            }else{
                self.likes = data?.products
            }
        }
    }
    
    
    func updateFavorites(ids:String, subCatIds:String){
        updateloading = true
        ProfileControllerAPI.updateFavorites(ids: ids, subCatIds:subCatIds) { data, error in
            self.updateloading = false
            if error != nil {
                self.error = error
            }else{
                self.favoritesUpdated = data
            }
        }
    }
    
    
    func getAvatars() {
        loading = true
        ProfileControllerAPI.getAvatars { data, error in
            self.loading = false
            if error != nil {
                self.error = error
            }else{
                self.avatars = data
            }
        }
    }
    
    func updateAvatar(avatarId:String) {
        updateloading = true
        ProfileControllerAPI.updateAvatar(avatarId: avatarId) { data, error in
            self.updateloading = false
            if error != nil {
                self.error = error
            }else{
                self.updatedUser = data
            }
        }
    }
    
}
