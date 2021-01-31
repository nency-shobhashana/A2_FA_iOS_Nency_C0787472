//
//  ProductListViewController.swift
//  A2_FA_iOS_Nency_C0787472
//
//  Created by Nency on 30/01/21.
//

import UIKit
import CoreData

class DashboardViewController: UITableViewController {
    
    @IBOutlet weak var productSearchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var isProviderShowing = false
    var productList: [Product] = []
    var providerList: [Provider] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        if productList.count == 0 {
            // add static data if product list empty(for demo purpose)
            staticDataEntry()
        }
        productSearchBar.delegate = self
        navigationItem.rightBarButtonItem = editButtonItem
        title = "Products"
        
        //MARK: - pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadData(_:)), for: .valueChanged)
        //MARK: - to dispaly first product
        //        let indexPath = IndexPath(row: 0, section: 0)
        //        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        //        performSegue(withIdentifier: "productDetail", sender: self)
    }
    
    //MARK: - toggle between Products and Providers
    @IBAction func listChangedClicked(_ sender: UIBarButtonItem) {
        isProviderShowing = !isProviderShowing
        if isProviderShowing {
            sender.title = "Show Products"
            title = "Providers"
        } else {
            sender.title = "Show Providers"
            title = "Products"
        }
        setEditing(false, animated: true)
        loadData()
    }
    
    
    // MARK: - load Data
    @objc func loadData(_ sender: Any? = nil){
        if isProviderShowing {
            loadProviderData()
        } else {
            loadProductData()
        }
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    //MARK: - data manipulation core data
    func filterData(searchText: String){
        if isProviderShowing {
            filterProviderData(searchText: searchText)
        } else {
            filterProductData(searchText: searchText)
        }
        tableView.reloadData()
    }
    
    //MARK: - Save Data in Core Data and fetch new latest data
    func updateDataList(){
        do {
            try context.save()
            loadData()
        } catch {
            print("Error loading prodcuts \(error.localizedDescription)")
        }
    }
    
    //MARK: - show alert for edit button
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing{
        let alert = UIAlertController(title: "Edit mode", message: "Click on product / provider to edit product / provider detail(s).", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
        
        self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - tableView delegate to detect selected row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isProviderShowing{
            if tableView.isEditing {
                showEditProviderAlert(provider: providerList[indexPath.row])
            } else {
                performSegue(withIdentifier: "providersProduct", sender: self)
            }
        } else {
            if tableView.isEditing {
                performSegue(withIdentifier: "editProduct", sender: self)
            } else {
                performSegue(withIdentifier: "productDetail", sender: self)
            }
        }
    }
    
    //MARK: - tableView delegate to detect editstyle change
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isProviderShowing {
                deleteProvider(providerList[indexPath.row])
            } else {
                deleteProduct(productList[indexPath.row])
            }
        }
    }
    
    
    // MARK: - Navigation
    // transfer data between screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "providersProduct" {
            let destination = segue.destination as! ProvidersProductListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destination.selectedProvider = providerList[indexPath.row]
            }
        } else {
            let destination = segue.destination as! ProductViewController
            destination.delegate = self
            if segue.identifier == "productDetail" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    destination.product = productList[indexPath.row]
                    destination.isEdit = false
                }
            }else if segue.identifier == "editProduct" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    destination.product = productList[indexPath.row]
                    destination.isEdit = true
                }
            }else if segue.identifier == "addProduct" {
                destination.product = Product(context: context)
                destination.isEdit = true
            }
        }
    }
    
    // table view delagate method for number of row going to be in table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isProviderShowing{
            return providerList.count
        } else {
            return productList.count
        }
    }
    
    //create a table cell for product and provider
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isProviderShowing {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListViewCell", for: indexPath) as! ProductListViewCell
            let product = productList[indexPath.row]
            cell.initCell(product)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProviderListViewCell", for: indexPath) as! ProviderListViewCell
            let provider = providerList[indexPath.row]
            cell.initCell(provider)
            return cell
        }
    }
    
    // MARK: - Static data entry
    func staticDataEntry(){
        deleteProvider()
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
        product.price = 9.5
        product.provider = provider2
        productList.append(product)
        
        product = Product(context: context)
        product.id = 5
        product.name = "Fifth Product"
        product.desc = "Small description for Fifth Pro1"
        product.price = 35.7
        product.provider = provider1
        productList.append(product)
        
        product = Product(context: context)
        product.id = 6
        product.name = "Six Product"
        product.desc = "Small description for Six Prod1"
        product.price = 16.9
        product.provider = provider1
        productList.append(product)
        
        product = Product(context: context)
        product.id = 7
        product.name = "Seven Product"
        product.desc = "Small description for Seven Produ1"
        product.price = 1.52
        product.provider = provider2
        productList.append(product)
        
        product = Product(context: context)
        product.id = 8
        product.name = "Eight Product"
        product.desc = "Small description for Eight Pro1"
        product.price = 50.7
        product.provider = provider1
        productList.append(product)
        
        product = Product(context: context)
        product.id = 9
        product.name = "Nine Product"
        product.desc = "Small description for Nine Prod1"
        product.price = 24.90
        product.provider = provider1
        productList.append(product)
        
        product = Product(context: context)
        product.id = 10
        product.name = "Ten Product"
        product.desc = "Small description for Ten Produ1"
        product.price = 31.15
        product.provider = provider2
        productList.append(product)
        
        do {
            try context.save()
            tableView.reloadData()
        } catch {
            print("Error saving products \(error.localizedDescription)")
        }
    }
    
    // delete old providers
    func deleteProvider(){
        print("number of provider :")
        let request: NSFetchRequest<Provider> = Provider.fetchRequest()
        
        do {
            let providerList = try context.fetch(request)
            providerList.forEach { (provider) in
                context.delete(provider)
            }
        } catch {
            print("Error loading providers \(error.localizedDescription)")
        }
    }
}

//MARK: - extension for all Product related methos
extension DashboardViewController {
    //MARK: - load products from CoreData
    func loadProductData(){
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            productList = try context.fetch(request)
        } catch {
            print("Error loading products \(error.localizedDescription)")
        }
    }
    
    //MARK: - Delete product from core data
    func deleteProduct(_ product: Product){
        context.delete(product)
        updateDataList()
    }
    
    //MARK: - load filtered products from CoreData
    func filterProductData(searchText: String){
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        let titlePredicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        let descriptionPredicate = NSPredicate(format: "desc CONTAINS[cd] %@", searchText)
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, descriptionPredicate])
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            self.productList = try self.context.fetch(request)
        } catch {
            print("Error loading prodcuts \(error.localizedDescription)")
        }
    }
}

//MARK: - extension for all Provider related methos
extension DashboardViewController {
    //MARK: - load providers from CoreData
    func loadProviderData(){
        let request: NSFetchRequest<Provider> = Provider.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            providerList = try context.fetch(request)
        } catch {
            print("Error loading provider \(error.localizedDescription)")
        }
    }
    
    //MARK: - Delete provider from core data
    func deleteProvider(_ provider: Provider){
        let name = provider.name ?? "Provider"
        let alert = UIAlertController(title: "Delete \(name)", message: "If you delete Provider then it will also delete all product which is belong by this provider. Are you sure you want to delete provider?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
            self.context.delete(provider)
            self.updateDataList()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Show alert Box to get updated name of provider
    func showEditProviderAlert(provider: Provider) {
        let alert = UIAlertController(title: "Edit Provider Name", message: "Enter a text", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = provider.name
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            provider.name = textField?.text ?? ""
            self.updateDataList()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - load filtered providers from CoreData
    func filterProviderData(searchText: String){
        let request: NSFetchRequest<Provider> = Provider.fetchRequest()
        let titlePredicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        request.predicate = titlePredicate
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            providerList = try context.fetch(request)
        } catch {
            print("Error loading provider \(error.localizedDescription)")
        }
    }
}
extension DashboardViewController: UISearchBarDelegate {
    
    //MARK: - searchbar on click event
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filterData(searchText: searchBar.text!)
    }
    
    // detect searchText changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
