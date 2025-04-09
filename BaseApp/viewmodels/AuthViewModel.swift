//
//  AuthViewModel.swift
//  BaseApp
//
//  Created by Ehab on 13/03/2024.
//

import Foundation
import Combine
import UIKit

class AuthViewModel: NSObject {
            
    @Published var loading: Bool = false
    @Published var forgetPasswordLoading: Bool = false
    @Published var loggedIn: User?
    @Published var checkIfMobileNumberExists: AppResponse?
    @Published var checkIfUserNameExists: AppResponse?
    @Published var verifyOtp: AppResponse?
    @Published var resendOtp: AppResponse?
    @Published var error: Error?
    @Published var updatedUser:User?
    @Published var newPassword:User?
    @Published var resetPassword:ResetPassword?
    

    func login(playerId:String , mobile:String , password:String){
        self.loading = true
        AuthControllerAPI.login(playerId: playerId, mobile: mobile, password: password) { data, error in
            self.loading = false
            if let data {
                self.loggedIn = data
            }else {
                self.error = error
            }
        }
    }
    
    
    func newUser(username:String , mobile:String, password:String , playerId:String){
        self.loading = true
        AuthControllerAPI.createAccount(username: username, mobile: mobile, password: password, playerId: playerId) { data, error in
            self.loading = false
            if let data {
                self.loggedIn = data
            }else {
                self.error = error
            }
        }
    }
    
    
    func checkIfMobileNumberExists(phoneNumber:String, otpRequired:Bool = false){
        self.loading = true
        AuthControllerAPI.checkIfMobileNumberExists(phoneNumber: phoneNumber, otpRequired: otpRequired) { data, error in
            self.loading = false
            if let data {
                self.checkIfMobileNumberExists = data
            }else {
                self.error = error
            }
        }
    }
    
    
    func checkIfUserNameExists(username:String){
        self.loading = true
        AuthControllerAPI.checkIfUserNameExists(username: username) { data, error in
            self.loading = false
            if let data {
                self.checkIfUserNameExists = data
            }else {
                self.error = error
            }
        }
    }
    
    
    
    func verifyOtp(body:OtpVerificationBody){
        print(body.convertToString ?? "")
        self.loading = true
        AuthControllerAPI.verifyOtp(body: body) { data, error in
            self.loading = false
            if let data {
                self.verifyOtp = data
            }else {
                self.error = error
            }
        }
    }
    
    
    
    func resendOtp(body:OtpVerificationBody){
        self.loading = true
        AuthControllerAPI.resendOtp(body: body) { data, error in
            self.loading = false
            if let data {
                self.resendOtp = data
            }else {
                self.error = error
            }
        }
    }
    
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
    
    
    func resetPassword(mobile:String){
        forgetPasswordLoading = true
        AuthControllerAPI.resetPassword(mobile: mobile){ data, error in
            self.forgetPasswordLoading = false
            if error != nil {
                self.error = error
            }else{
                self.resetPassword = data
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
                self.newPassword = data
            }
        }
    }
    
    
    func dinit() {
        loading = false
        loggedIn = nil
        checkIfMobileNumberExists = nil
        checkIfUserNameExists = nil
        verifyOtp = nil
        error = nil
    }
    
    
}
