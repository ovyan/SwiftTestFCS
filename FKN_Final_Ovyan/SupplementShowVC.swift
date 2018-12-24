//
//  SupplementShowVC.swift
//  FKN_Final_Ovyan
//
//  Copyright © 2018 Mike Ovyan. All rights reserved.
//

import UIKit

final class SupplementShowVC: UIViewController {
    @IBOutlet var lbl: UILabel!
    @IBOutlet var descrLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        lbl.text = model!.title
        descrLabel.text = model!.Description
    }

    var model: TextModel?
}
