//
//  ProductViewController.swift
//  A2_FA_iOS_Nency_C0787472
//
//  Created by nency on 30/01/21.
//

import UIKit

class ProductViewController: UIViewController {
    
    weak var product: Product!

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var txtProvider: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtName.text = product.name
        txtDescription.text = product.desc
        txtPrice.text = String(format:"%.2f",product.price)
        txtProvider.text = product.provider?.name ?? ""
    }
}
