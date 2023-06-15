//
//  YelpStarRatingView.swift
//  CoffeeShop
//
//  Created by Solomon Ray on 5/20/23.
//


import SwiftUI
import Foundation
import Combine

struct YelpStarRatingView: View {
    let rating: Double
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= Int(rating) ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
        }
        .font(.headline)
    }
}

