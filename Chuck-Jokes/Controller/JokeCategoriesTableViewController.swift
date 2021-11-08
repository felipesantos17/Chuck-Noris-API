import UIKit

// criando uma tratativa para o tipo de erro
enum ServiceError: Error {
    case invalidURL
    case decodeFail(Error)
    case network(Error?)
}

class JokeCategoriesTableViewController: UITableViewController {
    
    @IBOutlet weak var lblTitleApp: UILabel!
    
    private let baseURL = "https://api.chucknorris.io/jokes"
    
    var categories: [String] = []
    
    func getJokeCategoriesFromURL(callback: @escaping(Result<Any, ServiceError>) -> Void) {
        
        let pathCategories = "/categories"
        
        guard let urlCategories = URL(string: baseURL + pathCategories) else {
            callback(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlCategories) { data, response, error in
            guard let data = data else {
                callback(.failure(.network(error)))
                return
            }
            
            do {
                let jokeCategories = try JSONSerialization.jsonObject(with: data) as! [String]
                callback(.success(jokeCategories))
            } catch {
                print(callback(.failure(.decodeFail(error))))
            }
            
        }
        
        task.resume()
    }
    
    // MARK: - Function that selects a category
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "oneJoke", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? OneJokeViewController,
            let indice = self.tableView.indexPathForSelectedRow?.row
            else { return }

            destination.selectedCategory = categories[indice]
            self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
         getJokeCategoriesFromURL(callback: ({ categoriesJokeResult in
            DispatchQueue.main.async {
                switch categoriesJokeResult {
                    case let .failure(error):
                        print(error)
                    case let .success(data):
                    self.lblTitleApp.text = "Select a category to see a joke"
                    self.categories = data as! [String]
                        print(data)
                    self.tableView.reloadData()
                }
            }
        }))
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryJokeCell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category
        
        return cell
    }

}
