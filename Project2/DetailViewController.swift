//
//  DetailViewController.swift
//  Project2
//
//  Created by SWUCOMPUTER on 2018. 6. 13..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    @IBOutlet var textName: UILabel!
    @IBOutlet var textDescription: UILabel!
    
    var selectedData: EvaluationData?
    var detailEvaluation: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let evaluation = detailEvaluation{
            textName.text = evaluation.value(forKey: "subj_Name") as? String
            textDescription.text = evaluation.value(forKey:"subj_Result") as? String
        }
    }
    
}
