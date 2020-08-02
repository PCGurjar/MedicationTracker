//
//  HistoryTableViewCell.swift
//  MedicationTracker
//
//  Created by Poonamchand on 02/08/20.
//  Copyright © 2020 Poonamchand. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var viewInner: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblMorningTitle: UILabel!
    @IBOutlet weak var lblAfternoonTitle: UILabel!
    @IBOutlet weak var lblEveningTitle: UILabel!
    @IBOutlet weak var lblMorningTime: UILabel!
    @IBOutlet weak var lblEveningTime: UILabel!
    @IBOutlet weak var lblAfternoonTime: UILabel!
    @IBOutlet weak var lblNoMedicine: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        self.viewInner.dropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // Display Data on Table view cell
    func setData(model: ModelHistory) {
        self.lblDate.text = model.date
        self.lblScore.text = "0"
        self.lblScore.textColor = UIUtils.getColorDependUponScore(value: 0)
        self.lblNoMedicine.text = "No Medicine Taken"
        self.lblMorningTitle.text = ""
        self.lblAfternoonTitle.text = ""
        self.lblEveningTitle.text = ""
        self.lblMorningTime.text = ""
        self.lblEveningTime.text = ""
        self.lblAfternoonTime.text = ""
        
        if let medicationData = model.medicationData {
            self.lblScore.text = "\(medicationData.score)"
            self.lblScore.textColor = UIUtils.getColorDependUponScore(value: Int(medicationData.score))
            self.lblNoMedicine.text = ""
            if let mTime = medicationData.morningTime {
                self.lblMorningTitle.text = TimeFraction.morning.rawValue
                self.lblMorningTime.text = mTime
            }
            if let aTime = medicationData.afternoonTime {
                self.lblAfternoonTitle.text = TimeFraction.afternoon.rawValue
                self.lblAfternoonTime.text = aTime
            }
            if let eTime = medicationData.eveningTime {
                self.lblEveningTitle.text = TimeFraction.evening.rawValue
                self.lblEveningTime.text = eTime
            }
        }
    }

}

