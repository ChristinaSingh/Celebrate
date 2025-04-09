//
//  FriendsViewModel.swift
//  BaseApp
//
//  Created by Ihab yasser on 15/05/2024.
//

import Foundation
import Combine

class FriendsViewModel:NSObject {
    @Published var loading: Bool = false
    @Published var unfriendLoading: Bool = false
    @Published var error: Error?
    @Published var friends: Friends?
    @Published var _Friends: Friends?
    @Published var requests: Friends?
    @Published var _Likes: [Product]?
    @Published var likes: [Product]?
    @Published var _Requests: Friends?
    @Published var unfriend: AppResponse?
    @Published var _FriendAddresses: [FriendProfileAddress]?
    @Published var friendAddresses: [FriendProfileAddress]?
    
    let dispatchGroup = DispatchGroup()
    let friendDispatchGroup = DispatchGroup()
    
    
    func getFriends(isPullToRefresh:Bool = false){
        loading = !isPullToRefresh
        getMyFriends()
        getMyFriendRequests()
        dispatchGroup.notify(queue: DispatchQueue.main){
            self.loading = false
            if let friends = self._Friends {
                self.friends = friends
            }
            if let requests = self._Requests {
                self.requests = requests
            }
        }
    }
    
    private func getMyFriends(){
        dispatchGroup.enter()
        FriendsControllerAPI.friends() { data, error in
            if error != nil {
                self.error = error
            }else{
                self._Friends = data
            }
            self.dispatchGroup.leave()
        }
    }
    
    
    private func getMyFriendRequests(){
        dispatchGroup.enter()
        FriendsControllerAPI.friendsRequests() { data, error in
            if error != nil {
                self.error = error
            }else{
                self._Requests = data
            }
            self.dispatchGroup.leave()
        }
    }
    
    
    func findFriend(name:String){
        loading = true
        FriendsControllerAPI.findFriends(name: name) { data, error in
            self.loading = false
            if error != nil {
                self.error = error
            }else{
                self.friends = data?.toFriends()
            }
        }
    }
    
    
    func addFriend(friendId:String , callback: @escaping ((AppResponse? , Error?) async -> Void)){
        FriendsControllerAPI.addFriend(friendId: friendId) { data, error in
            Task{
                await callback(data , error)
            }
        }
    }
    

    func acceptRejectFriendRequest(friendId:String, status:String , callback: @escaping ((AppResponse? , Error?) async -> Void)){
        FriendsControllerAPI.acceptRejectFriend(friendId: friendId, status: status) { data, error in
            Task{
                await callback(data , error)
            }
        }
    }
    
    
    func getFriendProfile(friendId:String){
        loading = true
        getFriendLikes(friendId: friendId)
        getAddresses(friendId: friendId)
        self.friendDispatchGroup.notify(queue: DispatchQueue.main){
            self.loading = false
            self.likes = self._Likes
            self.friendAddresses = self._FriendAddresses
        }
    }
    
    func getFriendLikes(friendId:String){
        friendDispatchGroup.enter()
        FriendsControllerAPI.friendLikes(friendId: friendId) { data, error in
            if error != nil {
                self.error = error
            }else{
                self._Likes = data?.data
            }
            self.friendDispatchGroup.leave()
        }
    }
    
    
    func unfriend(friendId: String, callback: @escaping ((AppResponse?, Error?) -> Void)) {
        FriendsControllerAPI.unfriend(friendId: friendId, completion: callback)
    }
    
    
    func friendBirthDayReminder(friendId:String, status:Int, callback: @escaping ((AppResponse?, Error?) -> Void)) {
        FriendsControllerAPI.friendBirthDayReminder(friendId: friendId, status:status, completion: callback)
    }
        
    
    func getAddresses(friendId: String) {
        friendDispatchGroup.enter()
        FriendsControllerAPI.friendAddress(friendId: friendId) { data, error in
            if error != nil {
                self.error = error
            }else{
                self._FriendAddresses = data?.addresses
            }
            self.friendDispatchGroup.leave()
        }
    }
    
}
