//
//  ProviderListViewCell.swift
//  A2_FA_iOS_Nency_C0787472
//
//  Created by Nency on 30/01/21.
//

import UIKit

class ProviderListViewCell: UITableViewCell{
    
    @IBOutlet weak var providerName: UITextField!
    @IBOutlet weak var productCount: UITextField!
   
   func initCell(_ provider: Provider){
       providerName.text = provider.name
    productCount.text = String(format: "%d", provider.products?.count ?? 0)
   }
}

