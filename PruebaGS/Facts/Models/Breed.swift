//
//  Breed.swift
//  PruebaGS
//
//  Created by PEDRO MENDEZ on 30/07/24.
//

import Foundation

///General model of data
///add the protocol Decodable to do the conversion from the API JSON model to a data that Swift can read 
struct Breed: Decodable {
    var breed: String
    var country: String
    var origin: String
    var coat: String
    var pattern: String
}
