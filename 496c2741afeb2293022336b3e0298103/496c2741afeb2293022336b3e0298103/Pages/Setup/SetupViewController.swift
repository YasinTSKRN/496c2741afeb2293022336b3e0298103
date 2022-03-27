//
//  ViewController.swift
//  496c2741afeb2293022336b3e0298103
//
//  Created by yasintaskiran on 27.03.2022.
//

import UIKit

class SetupViewController: UIViewController {
    
    private var viewModel = SetupViewModel()

    @IBOutlet weak var leftPoints: UILabel!
    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        leftPoints.layer.borderColor = UIColor.black.cgColor
        leftPoints.layer.borderWidth = 3.0
        nameField.layer.borderColor = UIColor.black.cgColor
        nameField.layer.borderWidth = 3.0
    }
    @IBAction func continueAction(_ sender: Any) {
        self.performSegue(withIdentifier: "OpenTabbar", sender: nil)
    }
}

