//
//  partyMemberCell.swift
//  HuntTrack
//
//  Created by Evan Weisbrod on 5/1/16.
//  Copyright © 2016 Evan Weisbrod. All rights reserved.
//

import Foundation
import UIKit

class partyMemberCell: UITableViewCell
{
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
}