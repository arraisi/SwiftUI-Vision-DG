//
//  EStatementService.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 08/06/21.
//

import Foundation

class EStatementService {
    private init() {}
    static let shared = EStatementService()
    
    // MARK: - GET LIST ESTATEMENT
    func getListEStatement(accountNumber: String, completion: @escaping(Result<EStatementModel, ErrorResult>) -> Void) {
        
        guard let url = URL.urlGetEStateMent() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        print("account number =>")
        print(accountNumber)
        var request = URLRequest(url.appending("accountNumber", value: accountNumber))
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("\nGET LIST ESTATEMENT HTTP RESPONSE: \(httpResponse.statusCode)")

                if (httpResponse.statusCode == 200) {
                    if let responseBody = try? JSONDecoder().decode(EStatementModel.self, from: BlowfishEncode().decrypted(data: data)!) {
                        print("RESPONSE BODY GET LIST ESTATEMENT \(responseBody)")
                        completion(.success(responseBody))
                    }
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
    
    // MARK: - GET FILE ESTATEMENT
    func getFileEstatment(fileName: String, accountNumber: String, completion: @escaping(Result<String, ErrorResult>) -> Void) {
        
        guard let url = URL.urlGetFileEstatement(fileName: fileName) else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        print("filename =>")
        print(fileName)
        var request = URLRequest(url.appending("accountNumber", value: accountNumber))
        request.httpMethod = "GET"
        
        URLSession.shared.downloadTask(with: request) { tempLocalUrl, response, error in
            
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
            
            guard let tempLocalUrl = tempLocalUrl, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\nGET FILE ESTATEMENT HTTP RESPONSE: \(httpResponse.statusCode)")

                if (httpResponse.statusCode == 200) {
                    do {
                        
                        // Remove any existing document at file
                        if FileManager.default.fileExists(atPath: destinationURL.path) {
                            try FileManager.default.removeItem(at: destinationURL)
                        }
                        
                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationURL)
                        completion(.success("200"))
                    } catch (let writeError) {
                        print("error writing file \(destinationURL) : \(writeError)")
                    }
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
}
