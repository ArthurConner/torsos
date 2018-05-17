//
//  FirstViewController.swift
//  Virt You Torsos
//
//  Created by Arthur  on 5/17/18.
//  Copyright © 2018 Arthur . All rights reserved.
//

import UIKit

class InputHealthViewController: UIViewController {

    @IBAction func saveClicked(_ sender: Any) {
        
        guard let m = weightField.text,
        let weight = Int(m), weight > 100
        else {
            return
        }
        
        
        var addMe:[String:String] = [:]
        addMe["weight"] = m
        data.add(measure:addMe)
    }
    
    @IBAction func shareClicked(_ sender: Any) {
        
        guard let (_,_) = data.lastmeasure(), let path = data.filepath else {
            return
        }
        
        let fileURL = URL(fileURLWithPath: path)
        
        
            let objectsToShare = [fileURL]
            let activityController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            let excludedActivities = [UIActivityType.postToFlickr, UIActivityType.postToWeibo, UIActivityType.message, UIActivityType.mail, UIActivityType.print, UIActivityType.copyToPasteboard, UIActivityType.assignToContact, UIActivityType.saveToCameraRoll, UIActivityType.addToReadingList, UIActivityType.postToFlickr, UIActivityType.postToVimeo, UIActivityType.postToTencentWeibo]
            
            activityController.excludedActivityTypes = excludedActivities
            present(activityController, animated: true, completion: nil)
        
        
        if let popoverPresentationController = activityController.popoverPresentationController, let button = sender as? UIBarButtonItem {
            popoverPresentationController.barButtonItem = button
        }
        present(activityController, animated: true, completion: nil)
        
    }
    
    let data = MeasureModel.shared
    
    
    func loadData(){
        guard let (_,final) = data.lastmeasure() else {
            return
        }
        
        if let w = final["weight"] {
            weightField.text = w
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var weightField: UITextField!
    
}

