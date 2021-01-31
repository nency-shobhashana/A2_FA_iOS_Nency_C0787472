//
//  ProvidersProductViewCell.swift
//  A2_FA_iOS_Nency_C0787472
//
//  Created by Nency on 31/01/21.
//

import UIKit

class ProvidersProductViewCell: UITableViewCell {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    
    func initCell(_ product: Product){
        txtName.text = product.name
        txtPrice.text = String(format: "$ %.2f", product.price)
    }
}
