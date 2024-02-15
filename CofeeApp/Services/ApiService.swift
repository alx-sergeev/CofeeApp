//
//  ApiService.swift
//  CofeeApp
//
//  Created by Сергеев Александр on 09.02.2024.
//

import Foundation
import Alamofire

final class ApiService {
    static let shared = ApiService()
    private init() {}
    
    
    private let userDefaults = UserDefaults.standard
    private let authTokenSalt = "Bearer "
    private let authTokenKey = "token"
    
    
    func registrationAction(login: String, psw: String, completion: @escaping (AuthResponse) -> ()) {
        let parameters = AuthParameters(login: login, password: psw)
        let headers: HTTPHeaders = [.contentType("application/json")]
        
        AF.request(ApiService.ApiPath.registration,
                   method: .post,
                   parameters: parameters,
                   encoder: .json,
                   headers: headers
        )
        .responseDecodable(of: AuthResponse.self) { response in
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func loginAction(login: String, psw: String, completion: @escaping (AuthResponse) -> ()) {
        let parameters = AuthParameters(login: login, password: psw)
        let headers: HTTPHeaders = [.contentType("application/json")]
        
        AF.request(ApiService.ApiPath.login,
                   method: .post,
                   parameters: parameters,
                   encoder: .json,
                   headers: headers
        )
        .responseDecodable(of: AuthResponse.self) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let value):
                let token = self.authTokenSalt + value.token
                self.userDefaults.set(token, forKey: self.authTokenKey)
                
                completion(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getLocationList(completion: @escaping ([Cafe]) -> ()) {
        guard let authToken = userDefaults.string(forKey: authTokenKey) else { return }
        
        let headers: HTTPHeaders = [.contentType("application/json"), .authorization(authToken)]

        AF.request(ApiService.ApiPath.locations,
                   method: .get,
                   headers: headers
        )
        .responseDecodable(of: [Cafe].self) { response in
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getMenuByID(_ id: Int, completion: @escaping ([Product]) -> ()) {
        guard let authToken = userDefaults.string(forKey: authTokenKey) else { return }
        
        let headers: HTTPHeaders = [.contentType("application/json"), .authorization(authToken)]
        let additionalApiPath = "\(id)/menu"
        
        AF.request(ApiService.ApiPath.menu + additionalApiPath,
                   method: .get,
                   headers: headers
        )
        .responseDecodable(of: [Product].self) { response in
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - ApiPath
extension ApiService {
    struct ApiPath {
        static let url: String = "http://147.78.66.203:3210"
        
        static let registration = url + "/auth/register"
        static let login = url + "/auth/login"
        static let locations = url + "/locations"
        static let menu = url + "/location/"
    }
}
