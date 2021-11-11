import UIKit

class OneJokeViewController: UIViewController {
    
    @IBOutlet weak var lblOneCategoryJoke: UILabel!
    
    @IBOutlet weak var lblOneJokeThisCategory: UILabel!
    
    var selectedCategory: String!
    
    var joke: OneJoke?
    
    var screenJoke: OneJoke?
    
    func newURL(x: String) -> String {
        let newSentURL = "random?category=\(x)"
        return newSentURL
    }
    
    func fethJoke() {
        
        let sentCategorySelectedURL = newURL(x: selectedCategory)
        print(sentCategorySelectedURL)
        
        ChuckAPI.getAPI(urlSent: sentCategorySelectedURL, expecting: OneJoke.self, callback: (
            { categoriesJokeResult in
                DispatchQueue.main.async {
                    switch categoriesJokeResult {
                    case let .failure(error):
                        print(error)
                    case let .success(data):
                        print(data)
                        self.joke = data
                        self.lblOneJokeThisCategory.text = self.joke?.value
                        self.view.addSubview(self.lblOneJokeThisCategory)
                    }
                }
            }
        ))
    }


    @IBAction func btnMoreOneJoke() {
        fethJoke()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblOneCategoryJoke.text = "The selected category was \((selectedCategory) ?? "Random")"
        self.view.addSubview(lblOneCategoryJoke)
        
        fethJoke()
    }

}
