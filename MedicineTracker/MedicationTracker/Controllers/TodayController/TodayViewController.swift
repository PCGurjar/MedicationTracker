//
//  TodayViewController.swift
//  MedicationTracker
//
//  Created by Poonamchand on 01/08/20.
//  Copyright © 2020 Poonamchand. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController, DatabaseManagerDelegates {

    var todayVM = TodayVM()
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var viewScore: UIView!
    @IBOutlet weak var btnMedicineTaken: UIButton!
    
    
    // MARK:- ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewScore.dropShadow()
        DatabaseManager.shared.delegate = self

        // Do any additional setup after loading the view.
        // set initial data
        self.todayVM.setUpInitialData { (isGetData) in
            // set data here
            self.setData()
        }
        
        self.lblTime.text = "Good \(self.todayVM.timeString.rawValue)"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Today's Medication"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    // Set data
    func setData() {
        if let data = self.todayVM.todaysMedicationData {
            self.lblScore.text = "\(data.score)"
            self.lblScore.textColor = UIUtils.getColorDependUponScore(value: Int(data.score))
        } else {
            self.lblScore.text = "0"
            self.lblScore.textColor = UIUtils.getColorDependUponScore(value: 0)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK:- Btn taken click
    @IBAction func btnMedicineTakenClick(_ sender: Any) {
        if !toCheckIsAbleToAdd(){
            return
        }
        
        if let currentTime = Date().getFormatttedCurrentTime() {
            var mTime: String?
            var aTime: String?
            var eTime: String?
            
            
            if (self.todayVM.todaysMedicationData != nil) {
                // update
                mTime = self.todayVM.todaysMedicationData!.morningTime
                aTime = self.todayVM.todaysMedicationData!.afternoonTime
                eTime = self.todayVM.todaysMedicationData!.eveningTime
                
                if self.todayVM.timeString == .morning {
                    mTime = currentTime
                }else if self.todayVM.timeString == .afternoon {
                    aTime = currentTime
                }else if self.todayVM.timeString == .evening {
                    eTime = currentTime
                }
            }else{
               // add
                if self.todayVM.timeString == .morning {
                    mTime = currentTime
                }else if self.todayVM.timeString == .afternoon {
                    aTime = currentTime
                }else if self.todayVM.timeString == .evening {
                    eTime = currentTime
                }
            }
            DatabaseManager.shared.saveCurrentdateMedicationdata(mTime: mTime, aTime: aTime, eTime: eTime)
            
            // Ignore todays notification depend upon time of medicine taken
            self.todayVM.ignoreTodaysNotificationDependUpontimeWhenSave(timeType: self.todayVM.timeString)
        }
    }
    
    // Database manager delegate method
    func didDataSaved() {
        DatabaseManager.shared.getTodaysMedicationData { (mData) in
            self.todayVM.todaysMedicationData = mData
            self.setData()
        }
    }
    
    // MARK:- To check is button enable or disable
    // Able to add medicine or not
    func toCheckIsAbleToAdd()-> Bool {
        if self.todayVM.timeString == .night {
            self.showAlert(message: "Time to sleep, this is not the right time to take medicine.")
            return false
        }
        if (self.todayVM.todaysMedicationData != nil) {
            if self.todayVM.timeString == .morning && self.todayVM.todaysMedicationData?.morningTime != nil {
                self.showAlert(message: "Already taken morning medicine.")
                return false
            }else if self.todayVM.timeString == .afternoon && self.todayVM.todaysMedicationData?.afternoonTime != nil {
                self.showAlert(message: "Already taken afternoon medicine.")
                return false
            }else if self.todayVM.timeString == .evening && self.todayVM.todaysMedicationData?.eveningTime != nil {
                self.showAlert(message: "Already taken evening medicine.")
                return false
            }else{
                return true
            }
        }else{
           return true
        }
    }
}
