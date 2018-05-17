//
//  MeasureModel.swift
//  Virt You Torsos
//
//  Created by Arthur  on 5/17/18.
//  Copyright © 2018 Arthur . All rights reserved.
//

import Foundation

class MeasureModel {
    
    static  let shared = MeasureModel()
    
    let filepath:String?
    let numberFormatter = NumberFormatter()
    
    var details:[String:[String:String]]
    
    private init() {
        
        
        if let documentsPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as NSString? {
            //This gives you the string formed path
            let dirpath = documentsPathString.appendingPathComponent("modeldata")
            
            let fm = FileManager.default
            
            if !(fm.fileExists(atPath: dirpath as String)){
                try? fm.createDirectory(atPath: dirpath as String, withIntermediateDirectories: true, attributes: nil)
            }
            
            let epath  = (dirpath as NSString).appendingPathComponent("measure.json")
            filepath = epath
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: epath), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [String:[String:String]] {
                    details = jsonResult
                } else {
                     details = [:]
                }
                
            }catch  {
                details = [:]
            }
            
        } else {
            filepath = ""
            details = [:]
        }
        
        numberFormatter.usesSignificantDigits = true
        numberFormatter.maximumSignificantDigits = 19
        
        
    }
    
    private func save(){
        guard let path = filepath  else {
            print("can't create the file")
            return
        }
       
        let u = URL(fileURLWithPath: path)
        
        do {
             let  jsonData = try JSONSerialization.data(withJSONObject: details, options: JSONSerialization.WritingOptions())
            try jsonData.write(to: u)
       
        } catch {
            print("cannot save for some reason")
        }
    }
    
    func add(measure:[String:String]){
        guard let key = numberFormatter.string(from: NSNumber(floatLiteral: Date().timeIntervalSinceReferenceDate)) else {
            return
        }
        details[key] = measure
        save()
        
    }
    
    func lastmeasure() ->(Date,[String:String])?{
        
        guard let key = details.keys.max(),
            let f = details[key],
            let num = numberFormatter.number(from: key)
        
        else {
            return nil
        }
        
        let date = Date(timeIntervalSinceReferenceDate: num.doubleValue)
        
        return (date,f)
        
    }
    
}
