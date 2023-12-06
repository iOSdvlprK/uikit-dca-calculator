//
//  CalculatorTableViewController.swift
//  uikit-dca-calculator
//
//  Created by joe on 2023/12/06.
//

import UIKit

class CalculatorTableViewController: UITableViewController {
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var asset: Asset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        symbolLabel.text = asset?.searchResult.symbol
        nameLabel.text = asset?.searchResult.name
    }
}
