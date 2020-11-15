//
//  UserRegistrationService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 14/11/20.
//

import Foundation
import MultipartForm

class UserRegistrationService {
    
    private init() {}
    
    static let shared = UserRegistrationService()

    func postUser(completion: @escaping(Result<UserRegistrationResponse, NetworkError>) -> Void) {

        let imageURL = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("2.png")
        let imageData = try? Data(contentsOf: imageURL)

        guard let url = URL.urlRegister() else {
            return completion(.failure(.badUrl))
        }

        let userDetailsForm = "{\"firstName\":\"Sumarsono\",\"lastName\":\"Kaze\",\"productName\":\"Bank Mestika\",\"phone\":\"085317230820\",\"email\":\"sumarsono@gmail.com\",\"nik\":\"1231231231231234\",\"imageKtp\":null,\"imageSelfie\":null,\"hasNoNpwp\":true,\"imageNpwp\":null,\"purposeOfAccountOpening\":\"String\",\"sourcOfFunds\":\"String\",\"monthlyWithdrawalFrequency\":\"String\",\"monthlyWithdrawalAmount\":\"String\",\"monthlyDepositFrequency\":\"String\",\"monthlyDepositAmount\":\"String\",\"occupation\":\"String\",\"position\":\"String\",\"companyName\":\"String\",\"companyAddress\":\"String\",\"companyKecamatan\":\"String\",\"companyKelurahan\":\"String\",\"companyPostalCode\":\"String\",\"companyPhoneNumber\":\"String\",\"companyBusinessField\":\"String\",\"annualGrossIncome\":\"String\",\"hasOtherSourceOfIncome\":\"String\",\"otherSourceOfIncome\":\"String\",\"relativeRelationship\":\"String\",\"relativesName\":true,\"relativesAddress\":\"String\",\"relativesPostalCode\":\"String\",\"relativesKelurahan\":\"String\",\"relativesPhoneNumber\":\"String\",\"funderName\":\"String\",\"funderRelation\":\"String\",\"funderOccupation\":\"String\",\"isWni\":true,\"isAgreeTnc\":true,\"isAgreetoShare\":true,\"isAddressEqualToDukcapil\":true,\"correspondenceAddress\":\"String\",\"correspondenceRt\":\"String\",\"correspondenceRw\":\"String\",\"correspondenceKelurahan\":\"String\",\"correspondenceKecamatan\":\"String\",\"correspondencePostalCode\":\"String\"}"

        let form = MultipartForm(parts: [
            MultipartForm.Part(name: "image_ktp", data: imageData!, filename: "stevia_ktp.png", contentType: "image/png"),
            MultipartForm.Part(name: "image_npwp", data: imageData!, filename: "stevia_npwp.png", contentType: "image/png"),
            MultipartForm.Part(name: "image_selfie", data: imageData!, filename: "stevia_selfie.png", contentType: "image/png"),
            MultipartForm.Part(name: "userDetails", value: userDetailsForm)
        ])

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("21", forHTTPHeaderField: "X-Device-ID")
        request.addValue("*/*", forHTTPHeaderField: "accept")

        URLSession.shared.uploadTask(with: request, from: form.bodyData) { data, response, error in

            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
            }

            let userResponse = try? JSONDecoder().decode(UserRegistrationResponse.self, from: data)

            if userResponse == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(userResponse!))
            }

        }.resume()
    }
    
}
