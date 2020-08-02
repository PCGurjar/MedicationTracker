//
//  HistoryViewController.swift
//  MedicationTracker
//
//  Created by Poonamchand on 01/08/20.
//  Copyright © 2020 Poonamchand. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, HistoryVMDelegate {

    @IBOutlet weak var tbleHistory: UITableView!
    
    
    var historyVM = HistoryVM()
    
    // MARK:- ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.historyVM.delegate = self
        self.historyVM.initialSetUps()
        
        self.setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Medication History"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    // Set table view initial properties
    func setTableView() {
        self.tbleHistory.delegate = self
        self.tbleHistory.dataSource = self
        self.tbleHistory.rowHeight = UITableView.automaticDimension
        self.tbleHistory.estimatedRowHeight = 100
    }


    // MARK:- Delegate method of view model
    func didDataFoundReloadTable() {
        DispatchQueue.main.async {
            self.tbleHistory.reloadData()
        }
    }
}


// TableView Methods
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyVM.arrMedicationHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as? HistoryTableViewCell {
            let model = self.historyVM.arrMedicationHistory[indexPath.row]
            cell.setData(model: model)
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    
    // This is used to get next page value
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (self.historyVM.arrMedicationHistory.count - 1 == indexPath.row) {
            self.historyVM.getPreviousMonthArray()
        }
    }
    

}
