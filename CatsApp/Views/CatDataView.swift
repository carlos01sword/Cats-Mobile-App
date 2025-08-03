//
//  ContentView.swift
//  CatsApp
//
//  Created by Carlos Costa on 01/08/2025.
//

import SwiftUI

struct CatDataView: View {
    var body: some View {
        Text("Loading data...")
            .task {
                await CatAPIService().fetchCatsData()
            }
    }
}

