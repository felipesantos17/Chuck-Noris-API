import UIKit

class OneJokeViewController: UIViewController {
    
    @IBOutlet weak var lblOneCategoryJoke: UILabel!
    
    @IBOutlet weak var lblOneJokeThisCategory: UILabel!
    
    var selectedCategory: String?
    
    var joke: OneJoke?
    
    private let baseURL = "https://api.chucknorris.io/jokes"
    
    func getJokeOneCategoryFromURL(callback: @escaping(Result<Any, ServiceError>) -> Void) {
        
        let pathOneCategory = "/random?category=\(selectedCategory!)"
        
        guard let urlCategory = URL(string: baseURL + pathOneCategory) else {
            callback(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlCategory) { data, response, error in
            guard let data = data else {
                callback(.failure(.network(error)))
                return
            }
            
            // aqui nesse caso estou decodificando os dados (data) do jeito que eu defini no struct OneJoke
            // e coloquei dentro de um "do" "catch" para verificar quando der erro
            do {
                let oneJoke = try JSONDecoder().decode(OneJoke.self, from: data)
                callback(.success(oneJoke))
            } catch {
                callback(.failure(.decodeFail(error)))
            }
            
        }
        
        task.resume()
    }
    
    @IBAction func btnMoreOneJoke() {
        getJokeOneCategoryFromURL(callback: ({ oneJokeResult in
            DispatchQueue.main.async {
                switch oneJokeResult {
                    case let .failure(error):
                        print(error)
                    case let .success(data):
                        print(data)
                        self.joke = data as? OneJoke
                        self.lblOneJokeThisCategory.text = self.joke?.value
                        self.view.addSubview(self.lblOneJokeThisCategory)
                }
            }
        }))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblOneCategoryJoke.text = "The selected category was \((selectedCategory)!)"
        self.view.addSubview(lblOneCategoryJoke)
        
        getJokeOneCategoryFromURL(callback: ({ oneJokeResult in
            DispatchQueue.main.async {
                switch oneJokeResult {
                    case let .failure(error):
                        print(error)
                    case let .success(data):
                        print(data)
                        self.joke = data as? OneJoke
                        self.lblOneJokeThisCategory.text = self.joke?.value
                        self.view.addSubview(self.lblOneJokeThisCategory)
                }
            }
        }))
        
    }

}
