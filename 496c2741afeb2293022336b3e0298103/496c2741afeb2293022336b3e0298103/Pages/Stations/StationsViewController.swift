//
//  StationsViewController.swift
//  496c2741afeb2293022336b3e0298103
//
//  Created by yasintaskiran on 27.03.2022.
//

import UIKit

class StationsViewController: UIViewController {

    private var viewModel = StationsViewModel()

    @IBOutlet weak var ugsValue: UILabel!
    @IBOutlet weak var eusValue: UILabel!
    @IBOutlet weak var dsValue: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var integrityValue: UILabel!
    @IBOutlet weak var timeValue: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var stationContainer: UIView!
    @IBOutlet weak var currentStationName: UILabel!
    @IBOutlet weak var destinationName: UILabel!
    @IBOutlet weak var destinationStock: UILabel!
    @IBOutlet weak var destinationCost: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        integrityValue.layer.borderColor = UIColor.black.cgColor
        integrityValue.layer.borderWidth = 3.0
        timeValue.layer.borderColor = UIColor.black.cgColor
        timeValue.layer.borderWidth = 3.0
        searchField.layer.borderColor = UIColor.black.cgColor
        searchField.layer.borderWidth = 3.0
        stationContainer.layer.borderColor = UIColor.black.cgColor
        stationContainer.layer.borderWidth = 2.0
        stationContainer.layer.cornerRadius = 15.0
    }

}
