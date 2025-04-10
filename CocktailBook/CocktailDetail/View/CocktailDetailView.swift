//
//  CocktailDetailView.swift
//  CocktailBook
//
//  Created by Ramakrishna.Goparapu on 10/04/25.
//

import SwiftUI

struct CocktailDetailView: View {
    var cocktailData: CocktailModel!
    @State var isFavorited: Bool = false
    var filterType: String = ""
    @ObservedObject var viewModel: CocktailListViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text(cocktailData.name)
                        .padding(.leading, 10)
                    Spacer()
                    Button(action: {
                        isFavorited.toggle()
                        viewModel.favouriteUnfavourite(isFavourited: isFavorited, for: cocktailData.id)
                        
                    }) {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .font(.title2)
                    }
                    .padding(5)
                }
                
                HStack{
                    Image(systemName: "timer")
                        .frame(width: 20, height: 20)
                        .aspectRatio(contentMode: .fit)
                        .padding(5)
                    Text("\(cocktailData.preparationMinutes) minitues")
                }
                Image(cocktailData.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text(cocktailData.longDescription)
                    .padding(5)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                Text("Ingredients")
                    .padding()
                    .font(.title)
                ForEach(cocktailData.ingredients, id: \.self) { name in
                    HStack{
                        Image(systemName: "arrow.right.circle.fill")
                            .frame(width: 20, height: 20)
                            .aspectRatio(contentMode: .fit)
                        Text(name)
                    }
                    .padding(.leading, 10)
                    
                }
            }
            
        }
        .onAppear(perform: {
            isFavorited = cocktailData.isFav!
        })
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text(filterType + " Cocktails")
                    }
                }
            }
        }
    }
}

#Preview {
    CocktailDetailView( viewModel: CocktailListViewModel())
}
