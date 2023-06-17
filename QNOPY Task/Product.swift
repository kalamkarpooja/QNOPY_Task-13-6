//
//  Product.swift
//  QNOPY Task
//
//  Created by Mac on 13/06/23.
//

import Foundation
struct WelCome: Codable {
    let product: [Product]
    let total, skip, limit: Int
}

// MARK: - Product
struct Product: Codable {
    let id: Int
    let title, description: String
    let price: Int
    let discountPercentage, rating: Double
    let stock: Int
    let brand, category: String
    let thumbnail: String
    let images: [String]
}
