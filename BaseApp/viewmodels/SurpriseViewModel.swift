//
//  SurpriseViewModel.swift
//  BaseApp
//
//  Created by Ihab yasser on 28/10/2024.
//

import Foundation
import Combine


class SurpriseViewModel: ObservableObject {
    
    @Published var loading: Bool = false
    @Published var error: Error?
    @Published var intro: SurpriseIntro?
    @Published var state: SurpriseState?
    @Published var signupResponse: AppResponse?
    @Published var verifyCodeResponse: AppResponse?
    @Published var revive: AppResponse?
    @Published var question: Question?
    @Published var answer: SubmitAnswer?
    private var cancellables = Set<AnyCancellable>()
    
    func getIntro(){
        loading = true
        SurpriseControllerAPI.intro { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.intro = data
            }
        }
    }
    
    
    func getState(){
        loading = true
        SurpriseControllerAPI.state { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.state = data
            }
        }
    }
    
    
    func signUp(date:String, name:String, mobile:String, additionalinfo:String){
        loading = true
        SurpriseControllerAPI.signup(date: date, name: name, mobile: mobile, additionalinfo: additionalinfo) { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.signupResponse = data
            }
        }
    }
    

    
    func verifyAndGetState(code: String) {
        loading = true
        verifyCode(code: code)
            .handleEvents(receiveOutput: { response in
                self.verifyCodeResponse = response
            })
            .flatMap { response -> AnyPublisher<SurpriseState?, Error> in
                if let response = response, response.status?.string.lowercased() == "success".lowercased() {
                    return self.getState()
                } else {
                    return Empty().eraseToAnyPublisher()
                }
            }
            .sink(receiveCompletion: { completion in
                self.loading = false
                if case let .failure(apiError) = completion {
                    self.error = apiError
                }
            }, receiveValue: { stateData in
                self.state = stateData
            })
            .store(in: &cancellables)
    }
    
    private func verifyCode(code:String) -> AnyPublisher<AppResponse?, Error> {
        return Future { promise in
            SurpriseControllerAPI.verifyCode(code: code) { data, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(data))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func getState() -> AnyPublisher<SurpriseState?, Error> {
        return Future { promise in
            SurpriseControllerAPI.state { data, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(data))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    func getQuestion(){
        loading = true
        SurpriseControllerAPI.getQuestion() { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.question = data
            }
        }
    }
    
    
    func revive(code:String){
        loading = true
        SurpriseControllerAPI.revive(code: code) { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.revive = data
            }
        }
    }
    
    
    func answerQuestion(answer:String , questionid:String , wrong:String , correct:String , skip:String , wasta:String , fiftyfifty:String){
        loading = true
        SurpriseControllerAPI.submitAnswer(answer: answer, questionid: questionid, wrong: wrong, correct: correct, skip: skip, wasta: wasta, fiftyfifty: fiftyfifty) { data, error in
            self.loading = false
            if let error = error {
                self.error = error
            }else if let data = data {
                self.answer = data
            }
        }
    }
    
    
    
}
