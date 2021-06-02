//
//  URL+Extensions.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 20/10/20.
//

import Foundation

extension URL {

    func appending(_ queryItem: String, value: String?) -> URL {

        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        return urlComponents.url!
    }
}

extension URL {
    
    static func urlForSliderAssets() -> URL? {
        return URL(string: "https://my-json-server.typicode.com/primajatnika271995/dummy-json/assets-landing")
    }
    
    static func urlMobileVersion() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/version/mobile/find-by-osType")
    }
    
    static func urlUserNew() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/user/new")
    }
    
    static func urlUser() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/user")
    }
    
    static func urlOTP() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/otp")
    }
    
    static func urlPINValidation() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/user/validatePin")
    }
    
    static func urlPINValidationNasabahExisting() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/user/validatePinExistingCustomer")
    }
    
    static func urlPasswordValidation() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/password/validation")
    }
    
    static func urlCitizen() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/citizen/nik")
    }
    
    static func urlSheduleInterview() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/schedule")
    }
    
    static func urlSheduleInterviewNasabahExisting() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/user/scheduleVCExistingCustomer")
    }
    
    static func urlSheduleInterviewFindById() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/schedule/find-byid")
    }
    
    static func urlSheduleInterviewSubmit() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/user?type=scheduleVC")
    }
    
    static func urlAddProductATM() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/user/card");
    }
    
    static func urlCheckFreeze() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/user/checkFreeze")
    }
    
    static func urlGetListATM() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/content/content-find-atm2");
    }
    
    static func urlFindListATM() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/content/debitCardDesigns");
    }
    
    static func urlGetListATMDesign(type: String) -> URL? {
        return URL(string: AppConstants().BASE_URL + "/content/content-find-atm-design2?type=\(type)");
    }
    
    static func urlFindListATMDesign() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/content/debitCardTypes");
    }
    
//    static func urlGetListJenisTabungan() -> URL? {
//        return URL(string: AppConstants().BASE_URL + "/product/getAll");
//    }
    
    static func urlGetListJenisTabungan() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/product/mainProducts");
    }
    
//    static func urlGetListJenisTabungan() -> URL? {
//        return URL(string: AppConstants().BASE_URL + "/content/content-find-product");
//    }
    
    static func urlGetSuggestionAddressResult() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/google-maps/address/results")
    }
    
    static func urlGetSuggestionAddress() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/google-maps/address/geoloc-results")
    }
    
    //-------------------- AUTH SERVICE ----------------------//
    
    static func urlAuthLogin() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/auth/login")
    }
    
    static func urlAuthLoginNewDevice() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/auth/login-change")
    }
    
    static func urlAuthLogout() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/auth/logout")
    }
    
    static func urlAuthRequestOTP() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/auth/requestOtp")
    }
    
    static func urlAuthValidationOTP() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/auth/validateOtp")
    }
    
    static func urlAuthValidationPin() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/auth/pinVerify")
    }
    
    static func urlAuthValidationPinTrx() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/auth/validatePinTrx")
    }
    
    static func urlAuthSetPassword() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/auth/setPwd")
    }
    
    static func urlAuthGenarateFingerPrint() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/auth/generateFinger")
    }
    
    static func urlAuthClearFingerPrint() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/auth/clearFinger")
    }
    
    static func urlAuthChangePassword() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/auth/changePwd")
    }
    
    static func urlAuthChangePinTrx() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/auth/changePinTrx")
    }
    
    static func urlAuthForgotPinTrx() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/auth/forgotPinTrx?channel=vlink")
    }
    
    static func urlAuthForgotPassword() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/auth/forgotPwd")
    }
    
    static func urlAuthChangeDevice() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/auth/login-change-atm-verification")
    }
    
    //-------------------- TRANSFER SERVICE ----------------------//
    
    static func urlLimitTransaction() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/card/card-profile")
    }
    
    static func urlBankReference() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/reference/bankwithcode")
    }
    
    static func urlTransferOverbookingInquiry() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/transper/overbookingInquiry")
    }
    
    static func urlTransferIbftInquiry() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/ibft/ibftInquiry")
    }
    
    static func urlTransferOverbooking() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/transper/overbooking")
    }
    
    static func urlTransferIbft() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/ibft/ibft")
    }
    
    static func urlTransferRtgs() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/transper/rtgs")
    }
    
    static func urlTransferSkn() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/transper/skn")
    }
    
    static func urlLastTransaction() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/channel/lastTransactionHistory")
    }
    
    //-------------------- PROFILE SERVICE ----------------------//
    
    static func urlGetProfile() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/user/profiles")
    }
    
    static func urlGetCustomerFromPhoenix() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/customer/fromPhoenix")
    }
    
    static func urlUpdateCustomerPhoenix() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/customer")
    }
    
    static func urlGetAccountBalance() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/user/getAccountBalance")
    }
    
    static func urlGetPasswordParam() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/password/pwd-param")
    }
    
    static func urlPostTrace() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/trace")
    }
    
    //-------------------- FAVORITE SERVICE ----------------------//
    
    static func urlGetListFavorite() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/favorit/transfer/get")
    }
    
    static func urlSaveFavorite() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/favorit/transfer/save")
    }
    
    static func urlUpdateFavorite() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/favorit/transfer/update")
    }
    
    static func urlRemoveFavorite() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/favorit/transfer/remove")
    }
    
    //-------------------- HISTORY SERVICE ----------------------//
    
    static func urlGetListHistory() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/channel/transactionHistory")
    }
    
    static func urlGetAllHistory() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/transactionLog")
    }
    
    //-------------------- KARTU-KU SERVICE ----------------------//
    
    static func urlGetListKartuKu() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/user/getBalance")
    }
    
    static func urlActivateKartuKu() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/channel/cardActivation")
    }
    
    static func urlBrokenKartuKu() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/channel/cardBroken")
    }
    
    static func urlBlockKartuKu() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/channel/cardBlocked")
    }
    
    static func urlChangePinKartuKu() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/channel/pinChange")
    }
    
    static func urlLimitKartuKu() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/card/personal-limit")
    }
    
    static func urlReplacementFee() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/card/card-replacement-fee")
    }
    
    //-------------------- SAVING ACCOUNT SERVICE ----------------------//
    
//    static func urlGetProductsSavingAccount() -> URL? {
//        return URL(string: AppConstants().BASE_URL + "/product/getOtherProducts")
//    }
    
    static func urlGetProductsSavingAccount() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/product/subProducts")
    }
    
    static func urlGetListBalanceAccount() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/user/accountBalance")
    }
    
    static func urlGetAccountsByCif() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/channel/inquiryAccountByCif")
    }
    
    static func urlGetProductDetail() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/product/getProductDetail")
    }
    
    static func urlSaveSavingAccount() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/channel/newAccountRegistration")
    }
    
    //-------------------- QRIS SERVICE ----------------------//
    
    static func urlParseQris() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/qris/parseQr")
    }
    
    static func urlPayQris() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/qris/payQr")
    }
    
    static func urlCheckStatusQris() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/qris/checkStatusQr")
    }
    
    //-------------------- TRX LIMIT SERVICE ----------------------//
    
    static func urlGlobalLimit() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/globalLimit")
    }
    
    static func urlUserLimit() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/userLimit")
    }
    
    //-------------------- MASTER ALAMAT SERVICE ----------------------//
    
    static func urlGetAllProvince() -> URL? {
        return URL(string: AppConstants().BASE_URL + "/master/province")
    }
    
    static func urlGetRegencyByIdProvince(idProvince: String) -> URL? {
        return URL(string: AppConstants().BASE_URL + "/master/regency/\(idProvince)/province")
    }
    
    static func urlGetDistrictByIdRegency(idRegency: String) -> URL? {
        return URL(string: AppConstants().BASE_URL + "/master/district/\(idRegency)/regency")
    }
    
    static func urlGetVilageByIdDistrict(idDistrict: String) -> URL? {
        return URL(string: AppConstants().BASE_URL + "/master/village/\(idDistrict)/district")
    }
}
