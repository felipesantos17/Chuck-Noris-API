import UIKit


class JokeCategoriesTableViewController: UITableViewController {
    
    @IBOutlet weak var lblTitleApp: UILabel!
    
    var categories: [String] = []

    private let pathCategories: String = "categories"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        
    }
    
    func fetch() {
        ChuckAPI.getAPI(urlSent: pathCategories, expecting: [String].self, callback: (
            { categoriesJokeResult in
                DispatchQueue.main.async {
                    switch categoriesJokeResult {
                    case let .failure(error):
                        print(error)
                    case let .success(data):
                        print(data)
                        self.categories = data
                        self.tableView.reloadData()
                    }
                }
            }
        ))
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
