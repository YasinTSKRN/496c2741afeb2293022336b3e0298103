//
//  ViewController.swift
//  496c2741afeb2293022336b3e0298103
//
//  Created by yasintaskiran on 27.03.2022.
//

import UIKit

class SetupViewController: UIViewController {
    
    private var viewModel = SetupViewModel()

    @IBOutlet weak var leftPointsLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var enduranceSlider: UISlider!
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var capacitySlider: UISlider!
    @IBOutlet weak var continueButton: UIButton!
    
    private let totalLimit: Float = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        leftPointsLabel.layer.borderColor = UIColor.black.cgColor
        leftPointsLabel.layer.borderWidth = 3.0
        nameField.layer.borderColor = UIColor.black.cgColor
        nameField.layer.borderWidth = 3.0
        enduranceSlider.minimumValue = 0
        enduranceSlider.maximumValue = totalLimit
        enduranceSlider.setValue(1, animated: false)
        speedSlider.minimumValue = 0
        speedSlider.maximumValue = totalLimit
        speedSlider.setValue(1, animated: false)
        capacitySlider.minimumValue = 0
        capacitySlider.maximumValue = totalLimit
        capacitySlider.setValue(1, animated: false)
        self.valuesUpdated()
        nameField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    private func valuesUpdated() {
        let leftPoints = totalLimit - (enduranceSlider.value.rounded() + speedSlider.value.rounded() + capacitySlider.value.rounded())
        leftPointsLabel.text = "\(Int(leftPoints))"
        checkContinueState()
    }

    private func checkContinueState() {
        if nameField.text == nil || nameField.text == "" {
            continueButton.isEnabled = false
            continueButton.setTitle("Isim Giriniz", for: .normal)
            return
        }
        let leftPoints = totalLimit - (enduranceSlider.value.rounded() + speedSlider.value.rounded() + capacitySlider.value.rounded())
        if leftPoints != 0 {
            continueButton.isEnabled = false
            continueButton.setTitle("Bütün Puanları Dağıtınız", for: .normal)
            return
        }
        if enduranceSlider.value.rounded() == 0 || speedSlider.value.rounded() == 0 || capacitySlider.value.rounded() == 0 {
            continueButton.isEnabled = false
            continueButton.setTitle("En Az Bir Puan Veriniz", for: .normal)
            return
        }
        continueButton.isEnabled = true
        continueButton.setTitle("Devam Et", for: .normal)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        checkContinueState()
    }

    @IBAction func sliderUpdated(_ sender: UISlider) {
        self.valuesUpdated()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        self.performSegue(withIdentifier: "OpenTabbar", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "OpenTabbar") {
            if let tabbar = segue.destination as? UITabBarController,
               let stationController = tabbar.viewControllers?.first as? StationsViewController {
                let ship = SpaceShip(name: nameField.text ?? "",
                                     speed: Int(speedSlider.value.rounded()),
                                     capacity: Int(capacitySlider.value.rounded()),
                                     endurance: Int(enduranceSlider.value.rounded()))
                stationController.spaceShip = ship
            }
        }
    }
}

