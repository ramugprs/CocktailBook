import XCTest
import XMLCoder

@testable import CocktailBook

class CocktailBookTests: XCTestCase {
    var vm: CocktailListViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        vm = CocktailListViewModel()
        if let url = Bundle.main.url(forResource: "sample", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                print("Successfully loaded JSON data.")
                
                let decoder = JSONDecoder()
                vm.cocktailsResponse = try decoder.decode([CocktailModel].self, from: data)
                vm.cocktails = vm.cocktailsResponse
            } catch {
                print("Error loading or parsing JSON: \(error)")
            }
        } else {
            print("Failed to find JSON file.")
        }
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testSaveCocktails() {
        let fileName = "TestCocktails.xml"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
      
        vm.saveCocktailsToXML(vm.cocktailsResponse, fileName: fileName)
        XCTAssertTrue(FileManager.default.fileExists(atPath: fileURL.path), "Expected XML file to exist.")
    }
    
    func testFetchCocktails() {
        
        let testCocktails: [CocktailModel] = [CocktailModel(id: "0", name: "test1", type: "alcoholic", shortDescription: "testing1...", longDescription: "testing111.....", preparationMinutes: 5, imageName: "pinacolada", ingredients: ["test1","test2"], isFav: false)]
        let fileName = "TestCocktails.xml"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        let encoder = XMLEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        let data = try! encoder.encode(testCocktails, withRootKey: "cocktails", rootAttributes: nil)
        try! data.write(to: fileURL)
        
        let loadedCocktails = vm.loadCocktailsFromXML(fileName: fileName)
        
        XCTAssertEqual(loadedCocktails, testCocktails, "Loaded cocktails should match the ones saved.")
    }
}



