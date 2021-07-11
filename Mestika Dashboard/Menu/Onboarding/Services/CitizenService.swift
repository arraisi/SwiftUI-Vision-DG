//
//  CitizenService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 25/11/20.
//

import Foundation
import SwiftyRSA

class CitizenService {
    
    private init() {}
    
    static let shared = CitizenService()
    
    func checkNIK(
        nik: String,
        phone: String,
        isNasabah: Bool,
        alamat: String,
        jenisKelamin: String,
        kecamatan: String,
        kelurahan: String,
        kewarganegaraan: String,
        nama: String,
        namaIbu: String,
        rt: String,
        rw: String,
        statusKawin: String,
        tanggalLahir: String,
        tempatLahir: String, completion: @escaping(Result<CheckNIKResponse, ErrorResult>) -> Void) {
        
        guard let url = URL.urlCitizen() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        let body: [String: Any] = [
          "nik": nik,
          "personalAlamat": alamat,
          "personalJenisKelamin": jenisKelamin,
          "personalKecamatan": kecamatan,
          "personalKelurahan": kelurahan,
          "personalKewarganegaraan": kewarganegaraan,
          "personalNama": nama,
          "personalNamaIbuKandung": namaIbu,
          "personalRtRw": "\(rt)/\(rw)",
          "personalStatusPerkawinan": statusKawin,
          "personalTanggalLahir": tanggalLahir,
          "personalTempatLahir": tempatLahir
        ]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        let finalUrlExisting = url.appending("phoneNumber", value: isNasabah ? phone : "")
        
        var request = URLRequest(finalUrlExisting)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            print("response: \(String(describing: response))")
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    let citizenResponse = try? JSONDecoder().decode(CheckNIKResponse.self, from: data)
                    completion(.success(citizenResponse!))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    _ = try? JSONDecoder().decode(Status.self, from: data)
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
        
    }
}
