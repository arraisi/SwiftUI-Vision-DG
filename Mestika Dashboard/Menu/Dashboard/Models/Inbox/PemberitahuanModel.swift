//
//  PemberitahuanModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 23/04/21.
//

import Foundation

struct PemberitahuanModel: Hashable {
    var date: String
    var contents: [PemberitahuanItemModel]
}

extension PemberitahuanModel {
    static func all() -> [PemberitahuanModel] {
        
        return [
            PemberitahuanModel(date: "Oktober 2020", contents: [
                PemberitahuanItemModel(date: "20 Oktober 2020", content: "slider_pic_1"),
                PemberitahuanItemModel(date: "20 Oktober 2020", content: "slider_pic_2"),
                PemberitahuanItemModel(date: "20 Oktober 2020", content: "slider_pic_3")
            ]),
            PemberitahuanModel(date: "November 2020", contents: [
                PemberitahuanItemModel(date: "20 November 2020", content: "slider_pic_1")
            ]),
            PemberitahuanModel(date: "Desember 2020", contents: [
                PemberitahuanItemModel(date: "20 Desember 2020", content: "slider_pic_3")
            ])
        ]
    }
}

struct PemberitahuanItemModel: Hashable {
    var date: String
    var content: String
}
