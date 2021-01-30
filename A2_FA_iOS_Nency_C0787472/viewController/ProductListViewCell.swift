//
//  ProductListViewCell.swift
//  A2_FA_iOS_Nency_C0787472
//
//  Created by Nency on 30/01/21.
//

import UIKit

class ProductListViewCell: UITableViewCell{
    
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productProvider: UITextField!
    
    func initCell(_ product: Product){
        productName.text = product.name
        productPrice.text = String(format: "%.2f", product.price)
        productProvider.text = product.provider?.name ?? ""
    }
}
