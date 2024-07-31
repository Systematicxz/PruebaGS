//
//  BreedsDAta.swift
//  PruebaGS
//
//  Created by PEDRO MENDEZ on 30/07/24.
//

import Foundation
///General model of data
/// add the protocol Decodable to do the conversion from the API JSON model to a data that Swift can read
struct BreedsDAta: Decodable {
    var current_page: Int
    var data: [Breed]
}
