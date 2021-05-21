//
//  AuthService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/01/21.
//

import Foundation

class AuthService {
    private init() {}
    
    static let shared = AuthService()
    
    // MARK: - LOGIN
    func login(
        password: String,
        phoneNumber: String,
        fingerCode: String,
        completion: @escaping(Result<LoginCredentialResponse, ErrorResult>) -> Void) {
        // Body
        let body: [String: Any] = [
            "pwd": password
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        guard let url = URL.urlAuthLogin() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    let loginResponse = try? JSONDecoder().decode(LoginCredentialResponse.self, from: data)
                    completion(.success(loginResponse!))
                }
                
                if (httpResponse.statusCode == 206) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - LOGIN NEW DEVICE
    func loginNewDevice(
        password: String,
        phoneNumber: String,
        completion: @escaping(Result<LoginCredentialResponse, ErrorResult>) -> Void) {
        // Body
        let body: [String: Any] = [
            "pwd": password,
            "phoneNumber": phoneNumber
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        guard let url = URL.urlAuthLoginNewDevice() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    let loginResponse = try? JSONDecoder().decode(LoginCredentialResponse.self, from: data)
                    completion(.success(loginResponse!))
                }
                
                if (httpResponse.statusCode == 206) {
                    let loginResponse = try? JSONDecoder().decode(LoginCredentialResponse.self, from: data)
                    completion(Result.failure(ErrorResult.customWithStatus(code: httpResponse.statusCode, codeStatus: loginResponse!.code)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - LOGIN CHANGE DEVICE
    func loginChangeDevice(
        password: String,
        phoneNumber: String,
        atmPin: String,
        cardNo: String,
        completion: @escaping(Result<LoginCredentialResponse, ErrorResult>) -> Void) {
        // Body
        let body: [String: Any] = [
            "pwd": password,
            "phoneNumber": phoneNumber,
            "atmPin": atmPin,
            "cardNo": cardNo
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        guard let url = URL.urlAuthChangeDevice() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    let loginResponse = try? JSONDecoder().decode(LoginCredentialResponse.self, from: data)
                    completion(.success(loginResponse!))
                }
                
                if (httpResponse.statusCode == 206) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 302) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 503) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - LOGOUT
    func logout(completion: @escaping(Result<String, ErrorResult>) -> Void) {
        
        guard let url = URL.urlAuthLogout() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let _ = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    completion(.success("Success"))
                }
                
                //                if (httpResponse.statusCode == 200) {
                //                    let loginResponse = try? JSONDecoder().decode(LoginCredentialResponse.self, from: data)
                //                    completion(.success(loginResponse!))
                //                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - VALIDATE PIN
    func validatePinVerf(
        accountNumber: String,
        pinTrx: String,
        completion: @escaping(Result<Status, ErrorResult>) -> Void) {
        
        // Body
        let body: [String: Any] = [
            "cardNo": accountNumber,
            "pin": pinTrx
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        guard let url = URL.urlAuthValidationPin() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    let validateResponse = try? JSONDecoder().decode(Status.self, from: data)
                    completion(.success(validateResponse!))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - VALIDATE PIN TRX
    func validatePinTrx(
        accountNumber: String,
        pinTrx: String,
        completion: @escaping(Result<Status, ErrorResult>) -> Void) {
        
        // Body
        let body: [String: Any] = [
            "accountNumber": accountNumber,
            "pinTrx": pinTrx
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        guard let url = URL.urlAuthValidationPinTrx() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    let validateResponse = try? JSONDecoder().decode(Status.self, from: data)
                    completion(.success(validateResponse!))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - SET PWD
    func setPassword(
        pwd: String,
        accountNumber: String,
        nik: String,
        pinTrx: String,
        completion: @escaping(Result<Status, ErrorResult>) -> Void) {
        // Body
        let body: [String: Any] = [
            "nik": nik,
            "accountNumber": accountNumber,
            "pinTrx": pinTrx,
            "pwdSet": pwd,
        ]
        
        print(pwd)
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        guard let url = URL.urlAuthSetPassword() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    let validateResponse = try? JSONDecoder().decode(Status.self, from: data)
                    completion(.success(validateResponse!))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 400) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - FORGOT PASSWORD WIHTOUT PIN TRX
    func forgotPassword(
        newPwd: String,
        cardNo: String,
        pinAtm: String,
        completion: @escaping(Result<Status, ErrorResult>) -> Void) {
        // Body
        let body: [String: Any] = [
            "cardNo": cardNo,
            "newPwd": newPwd,
            "pinAtm": pinAtm,
        ]
        
        print(newPwd)
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        guard let url = URL.urlAuthForgotPassword() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    let validateResponse = try? JSONDecoder().decode(Status.self, from: data)
                    completion(.success(validateResponse!))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 400) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - GENERATE FINGER PRINT
    func enableBiometricLogin(completion: @escaping(Result<GenerateFingerPrintResponseModel, ErrorResult>) -> Void) {
        
        guard let url = URL.urlAuthGenarateFingerPrint() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(.failure(ErrorResult.parser(string: "No Data")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("enableBiometricLogin \(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 201) {
                    let fingerPrintResponse = try? JSONDecoder().decode(GenerateFingerPrintResponseModel.self, from: data)
                    if let response = fingerPrintResponse {
                        print("finger print code : \(response.fingerprintCode)")
                        completion(.success(response))
                    }
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 400) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - DISABLE FINGER PRINT
    func disableBiometricLogin(completion: @escaping(Result<Int, ErrorResult>) -> Void) {
        
        guard let url = URL.urlAuthClearFingerPrint() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                print("disableBiometricLogin => \(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    completion(.success(httpResponse.statusCode))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - CHANGE PASSWORD
    func changePassword(currentPwd: String, newPwd: String, completion: @escaping(Result<Status, ErrorResult>) -> Void) {
        
        // Body
        let body: [String: Any] = [
            "currentPwd": currentPwd,
            "newPwd": newPwd
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        guard let url = URL.urlAuthChangePassword() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\n\n\nHTTP RESPONSE CHANGE PASSWORD => \(httpResponse.statusCode)\n\n\n")
                
                if (httpResponse.statusCode == 201) {
                    let status = try? JSONDecoder().decode(Status.self, from: data)
                    if let response = status {
                        print("\n\(String(describing: response.code))\n")
                        print("\n\(String(describing: response.message))\n")
                        
                        completion(.success(response))
                    }
                }
                
                if httpResponse.statusCode == 400 {
                    let status = try? JSONDecoder().decode(Status.self, from: data)
                    if let response = status {
                        print("\n\(String(describing: response.code))\n")
                        print("\n\(String(describing: response.message))\n")
                        
                        if response.code == "406" {
                            completion(Result.failure(ErrorResult.custom(code: 406)))
                        }
                        
                    } else {
                        completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                    }
                }
                
                if (httpResponse.statusCode == 406) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - CHANGE PIN TRANSAKSI
    func changePinTransaksi(currentPinTrx: String, newPinTrx: String, completion: @escaping(Result<Status, ErrorResult>) -> Void) {
        
        // Body
        let body: [String: Any] = [
            "currentPinTrx": currentPinTrx,
            "newPinTrx": newPinTrx
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        guard let url = URL.urlAuthChangePinTrx() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\n\n\nHTTP RESPONSE CHANGE PIN TRX => \(httpResponse.statusCode)\n\n\n")
                
                if (httpResponse.statusCode == 201) {
                    let status = try? JSONDecoder().decode(Status.self, from: data)
                    if let response = status {
                        print("\n\(String(describing: response.code))\n")
                        print("\n\(String(describing: response.message))\n")
                    }
                    completion(.success(status!))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - FORGOT PIN TRANSAKSI
    func forgotPinTransaksi(cardNo: String, pin: String, newPinTrx: String, completion: @escaping(Result<Status, ErrorResult>) -> Void) {
        
        // Body
        let body: [String: Any] = [
            "cardNo": cardNo,
            "pin": pin,
            "newPinTrx": newPinTrx
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        guard let url = URL.urlAuthForgotPinTrx() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\n\n\nHTTP RESPONSE FORGOT PIN TRX => \(httpResponse.statusCode)\n\n\n")
                
                if (httpResponse.statusCode == 201) {
                    let status = try? JSONDecoder().decode(Status.self, from: data)
                    if let response = status {
                        print("\n\(String(describing: response.code))\n")
                        print("\n\(String(describing: response.message))\n")
                    }
                    completion(.success(status!))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - PASSWORD PARAM
    func passwordParam(completion: @escaping(Result<PasswordParamResponse, ErrorResult>) -> Void) {
        
        guard let url = URL.urlGetPasswordParam() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        let finalUrl = url.appending("maximumUserIdleTimeOut", value: "40")
        
        var request = URLRequest(finalUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    let validateResponse = try? JSONDecoder().decode(PasswordParamResponse.self, from: data)
                    completion(.success(validateResponse!))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 400) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
}
