//
//  ProductViewController.swift
//  A2_FA_iOS_Nency_C0787472
//
//  Created by nency on 30/01/21.
//

import UIKit
import CoreData

class ProductViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    weak var delegate: DashboardViewController?
    var product: Product!
    var isEdit: Bool = false

    @IBOutlet weak var txtId: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var txtProvider: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtId.text = String(format:"%d",product.id)
        txtName.text = product.name
        txtDescription.text = product.desc
        if isEdit {
            txtPrice.text = String(format:"%.2f",product.price)
        } else {
            txtPrice.text = String(format:"$ %.2f",product.price)
        }
        txtProvider.text = product.provider?.name ?? ""
        txtDescription.layer.borderWidth = 1.0;
        txtDescription.layer.cornerRadius = 5.0;
        
        if isEdit {
            enableEdit()
        } else {
            disableEdit()
        }
        
        if isEdit && product.name?.isEmpty != false {
            title = "New Product"
        }
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func enableEdit(){
        txtId.borderStyle = .roundedRect
        txtName.borderStyle = .roundedRect
        txtProvider.borderStyle = .roundedRect
        txtPrice.borderStyle = .roundedRect

        txtDescription.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        
        txtId.isEnabled = true
        txtName.isEnabled = true
        txtDescription.isEditable = true
        txtProvider.isEnabled = true
        txtPrice.isEnabled = true
        
        btnSave.isHidden = false
    }
    
    func disableEdit(){
        txtId.borderStyle = .none
        txtName.borderStyle = .none
        txtProvider.borderStyle = .none
        txtPrice.borderStyle = .none
        
        txtDescription.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.0).cgColor
        
        txtId.isEnabled = false
        txtName.isEnabled = false
        txtDescription.isEditable = false
        txtProvider.isEnabled = false
        txtPrice.isEnabled = false
        
        btnSave.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isEdit && product.name?.isEmpty != false {
            context.delete(product)
        }
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        product.id = Int16(txtId.text ?? "0") ?? 0
        product.name = txtName.text
        product.price = Float(txtPrice.text ?? "") ?? 0
        product.desc = txtDescription.text
        
        product.provider = getOrCreateProvider(provider: txtProvider.text ?? "")
        delegate?.updateDataList()
        navigationController?.popViewController(animated: true)
    }
    
    func getOrCreateProvider(provider: String) -> Provider{
        let request: NSFetchRequest<Provider> = Provider.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", provider)
        do {
            let providerList = try context.fetch(request)
            if providerList.count > 0{
                return providerList[0]
            }
        } catch {
            print("Error loading provider \(error.localizedDescription)")
        }
        let newProvider = Provider(context: context)
        newProvider.name = provider
        return newProvider
    }
    
    
}
