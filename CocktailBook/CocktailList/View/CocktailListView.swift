//
//  CocktailListView.swift
//  CocktailBook
//
//  Created by Ramakrishna.Goparapu on 10/04/25.
//

import SwiftUI

struct CocktailListView: View {
    @StateObject var vm: CocktailListViewModel = CocktailListViewModel()
    @State var selectedFilter: String = "All"
    let filters = ["All", "Alcoholic", "Non-Alcoholic"]
    @State private var hasAppeared = false
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text(selectedFilter + " Cocktails")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                HStack {
                    ForEach(filters, id: \.self) { filter in
                        Text(filter)
                            .fontWeight(.medium)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 15)
                            .background(
                                selectedFilter == filter ? Color.gray.opacity(0.3) : Color.clear
                            )
                            .clipShape(Capsule())
                            .onTapGesture {
                                selectedFilter = filter
                                vm.filterCocktails(of: selectedFilter)
                            }
                            .foregroundStyle(.black)
                    }
                }
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding()
                
                List(vm.cocktails) { cocktail in
                    NavigationLink(destination: CocktailDetailView(cocktailData: cocktail, filterType: selectedFilter, viewModel: vm)) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(cocktail.name)
                                    .font(.headline)
                                    .foregroundStyle(cocktail.isFav! ? .blue : .black)
                                Spacer()
                                if cocktail.isFav! {
                                    Image(systemName: "heart.fill")
                                        .font(.title2)
                                        .foregroundStyle(.blue)
                                }
                            }
//                            Text(cocktail.name)
//                                .font(.headline)
                            Text(cocktail.shortDescription)
                                .font(.subheadline)
                        }
                    }
                }
                .onAppear {
                    if !hasAppeared {
                        vm.fetchCocktails()
                        hasAppeared = true
                    }
                }
            }
        }
        
    }
}

#Preview {
    CocktailListView()
}

