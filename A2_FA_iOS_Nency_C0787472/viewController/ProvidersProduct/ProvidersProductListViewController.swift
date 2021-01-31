//
//  ProvidersProductListViewController.swift
//  A2_FA_iOS_Nency_C0787472
//
//  Created by Nency on 31/01/21.
//

import UIKit
import CoreData

class ProvidersProductListViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var productList: [Product] = []
    var selectedProvider: Provider! {
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    func loadData(){
        self.title = selectedProvider.name
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.predicate = NSPredicate(format: "provider.name ==  %@", selectedProvider.name ?? "")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            productList = try context.fetch(request)
        } catch {
            print("Error loading product \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProvidersProductViewCell", for: indexPath) as! ProvidersProductViewCell
        let product = productList[indexPath.row]
        cell.initCell(product)
        return cell
        
    }
    
}
