//
//  BreedViewData.swift
//  PruebaGS
//
//  Created by PEDRO MENDEZ on 30/07/24.
//

import Foundation


///This model its unique bc there is not an ID it dosnt exist in the API, so this file its to create the ID
///beside we add the protocol Identifable
struct BreedViewData: Identifiable {
    let id: Int
    let breed: Breed
}
