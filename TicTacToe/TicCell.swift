//
//  TicCell.swift
//  TicTacToe
//
//  Created by Anuraag Jain on 04/04/17.
//  Copyright © 2017 app. All rights reserved.
//

import UIKit
protocol TicProtocol{
    func didTapOnCell(cell:TicCell)
}
class TicCell: UICollectionViewCell {
   
    @IBOutlet weak var cellValue: UILabel!
    
    var delegate:TicProtocol? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func didTapOnCell(_ sender: Any) {
        if let _ = delegate{
            delegate?.didTapOnCell(cell: self)
        }
    }
}
