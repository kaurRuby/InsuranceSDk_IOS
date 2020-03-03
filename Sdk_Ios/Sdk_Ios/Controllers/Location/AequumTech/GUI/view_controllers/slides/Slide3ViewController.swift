//
//  Slide3ViewController.swift
//  AequumPOCFramework
//
//  Created by Aleksandar Matijaca on 2019-11-14.
//  Copyright © 2019 Polyorb Inc. All rights reserved.
//

import UIKit

class Slide3ViewController: UIViewController {

    @IBOutlet var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        
        // Do any additional setup after loading the view.
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
