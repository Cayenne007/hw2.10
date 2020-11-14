//
//  FilterViewController.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//

import UIKit

class FilterViewController: UIViewController {

    
    @IBOutlet var roverTypeSegmentControl: UISegmentedControl!
    @IBOutlet var photoDatePicker: UIDatePicker!
    
    var delegate: ResultsDidLoadDelegate!
    var filter: RoverFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roverTypeSegmentControl.selectedSegmentIndex = filter.roverType.rawValue
        photoDatePicker.date = filter.date.toDate ?? Date()
    }
    
    
    @IBAction func confirmNewFilter() {
        
        filter.roverType = RoverType.allCases[roverTypeSegmentControl.selectedSegmentIndex]
        filter.date = photoDatePicker.date.toString
        
        delegate.startAnimateLoadingProcess()
        NetworkManager.loadData(filter: filter, delegate: delegate)
        dismiss(animated: true, completion: nil)
        
    }
    
    

}
