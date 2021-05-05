//
//  MainVC.swift
//  schoolmeal
//
//  Created by 김부성 on 2021/05/05.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var mealView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
