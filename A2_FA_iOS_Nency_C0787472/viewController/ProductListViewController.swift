//
//  ProductListViewController.swift
//  A2_FA_iOS_Nency_C0787472
//
//  Created by Nency on 30/01/21.
//

import UIKit
import CoreData

class ProductListViewController: UITableViewController {
    
    @IBOutlet weak var productSearchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var productList: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        deleteProvider()
        staticDataEntry()
        productSearchBar.delegate = self
        
    }
    
    // MARK: - load Data
    func deleteProvider(){
        print("number of provider :")
        let request: NSFetchRequest<Provider> = Provider.fetchRequest()
        
        do {
            let providerList = try context.fetch(request)
            providerList.forEach { (provider) in
                context.delete(provider)
            }
        } catch {
            print("Error loading products \(error.localizedDescription)")
        }
    }
    
    // MARK: - load Data
    func loadData(){
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            productList = try context.fetch(request)
        } catch {
            print("Error loading products \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    //MARK: - data manipulation core data
    func loadData(with request: NSFetchRequest<Product> = Product.fetchRequest(), predicates: [NSPredicate]){
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        do {
            productList = try context.fetch(request)
        } catch {
            print("Error loading prodcuts \(error.localizedDescription)")
        }
        
        tableView.reloadData()
        
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ProductViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.product = productList[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListViewCell", for: indexPath) as! ProductListViewCell
        let product = productList[indexPath.row]
        cell.initCell(product)
        return cell
    }
    
    func staticDataEntry(){
        productList.forEach { (product) in
            context.delete(product)
        }
        productList.removeAll()
        
        let provider1 = Provider(context: context)
        provider1.name = "HomeMade"
        
        let provider2 = Provider(context: context)
        provider2.name = "FactoryMade"
        
        var product = Product(context: context)
        product.id = 1
        product.name = "First Product"
        product.desc = "Small description for First Pr1"
        product.price = 10.6
        product.provider = provider1
        productList.append(product)
        
        product = Product(context: context)
        product.id = 2
        product.name = "Second Product"
        product.desc = "Small description for Second Pro1"
        product.price = 5.7
        product.provider = provider1
        productList.append(product)
        
        product = Product(context: context)
        product.id = 3
        product.name = "Third Product"
        product.desc = "Small description for Third Prod1"
        product.price = 6.9
        product.provider = provider1
        productList.append(product)
        
        product = Product(context: context)
        product.id = 4
        product.name = "Forth Product"
        product.desc = "Small description for Forth Produ1"
        product.price = 3.5
        product.provider = provider2
        productList.append(product)
        
        do {
            try context.save()
            tableView.reloadData()
        } catch {
            print("Error saving products \(error.localizedDescription)")
        }
        
    }
}

extension ProductListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let titlePredicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        let descriptionPredicate = NSPredicate(format: "desc CONTAINS[cd] %@", searchBar.text!)
        loadData(predicates: [titlePredicate, descriptionPredicate])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
          
        }
    }
}
