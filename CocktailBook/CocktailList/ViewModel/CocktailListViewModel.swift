//
//  CocktailListViewModel.swift
//  CocktailBook
//
//  Created by Ramakrishna.Goparapu on 10/04/25.
//

import Foundation
import Combine
import XMLCoder

class CocktailListViewModel: ObservableObject {
    @Published var cocktailsResponse = [CocktailModel]()
    @Published var cocktails = [CocktailModel]()
    private let cocktailsAPI: CocktailsAPI = FakeCocktailsAPI()
    let fileExtension = "cocktails.xml"
    var cancell: AnyCancellable?
    
    func fetchCocktails() {
        cancell = cocktailsAPI.cocktailsPublisher
            .decode(type: [CocktailModel].self, decoder: JSONDecoder())
            .sink { sub in
                switch sub{
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("error \(error)")
                }
                
            } receiveValue: { [weak self] models in
                DispatchQueue.main.async {
                    self?.sortCockTails(models: models)
                }
            }
    }
    
    func sortCockTails(models: [CocktailModel]) {
        let sorted = models.sorted(by: {$0.name < $1.name})
        cocktailsResponse = sorted.map({ model in
            var cocktail = model
            cocktail.isFav = false
            return cocktail
        })
        let localCocktails = loadCocktailsFromXML(fileName: fileExtension)
        if localCocktails.count > 0 {
            let filteredCocktails = localCocktails.filter({$0.isFav! == true })
            for cocktail in filteredCocktails {
                if let index = cocktailsResponse.firstIndex(where: {$0.id == cocktail.id}) {
                    cocktailsResponse[index].isFav = cocktail.isFav
                }
            }
        }
        
        let filte1 = cocktailsResponse.filter({$0.isFav == true})
        if filte1.count > 0 {
            let sorted1 = filte1.sorted(by: {$0.name < $1.name})
            let filte2 = cocktailsResponse.filter({$0.isFav == false})
            let sorted2 = filte2.sorted(by: {$0.name < $1.name})
            cocktailsResponse = sorted1 + sorted2
        }
        
        cocktails = cocktailsResponse
    }
    
    func filterCocktails(of type: String) {
        if type == "All" {
            cocktails = cocktailsResponse
        }
        else {
            cocktails = cocktailsResponse.filter({ $0.type.lowercased() == type.lowercased() })
        }
    }
    
    func favouriteUnfavourite(isFavourited: Bool, for cocktailID: String) {
        if let index = cocktailsResponse.firstIndex(where: {$0.id == cocktailID}) {
            cocktailsResponse[index].isFav = isFavourited
            reformCocktailsList()
        }
    }
    
    func reformCocktailsList() {
        let filte1 = cocktailsResponse.filter({$0.isFav == true})
        if filte1.count > 0 {
            let sorted1 = filte1.sorted(by: {$0.name < $1.name})
            let filte2 = cocktailsResponse.filter({$0.isFav == false})
            let sorted2 = filte2.sorted(by: {$0.name < $1.name})
            cocktailsResponse = sorted1 + sorted2
        }
        saveCocktailsToXML(cocktailsResponse, fileName: fileExtension)
        cocktails = cocktailsResponse
    }
    
    func saveCocktailsToXML(_ cocktails: [CocktailModel], fileName: String) {
        let encoder = XMLEncoder()
        encoder.outputFormatting = [.prettyPrinted]

        do {
            let data = try encoder.encode(cocktails, withRootKey: "cocktails", rootAttributes: nil)
            let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            try data.write(to: url)
            print("✅ Saved XML to: \(url.path)")
        } catch {
            print("❌ Encoding failed: \(error)")
        }
    }
 
    func loadCocktailsFromXML(fileName: String) -> [CocktailModel] {
        let decoder = XMLDecoder()
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        do {
            let data = try Data(contentsOf: url)
            let cocktails = try decoder.decode([CocktailModel].self, from: data)
            return cocktails
        } catch {
            print("❌ Decoding failed: \(error)")
            return []
        }
    }
}
