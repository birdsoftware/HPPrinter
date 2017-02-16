//
//  AddContainerViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/3/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit

class AddContainerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    /*weak*/ //var delegate : AvailabilityParentProtocol?
    //var delegate : addAvailDelegate?
    
//picker labels
    @IBOutlet weak var selectDay: UIPickerView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    //button
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelGoBackButton: UIButton!
    
    //public class vars
    let rangeSlider = RangeSlider(frame: CGRect.zero)
    var dayList = ["Monday", "Tuesday", "Wednessday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var addAvailability: [AnyObject] = Array()
    var availDay = "Monday"
    var availFromTime = "8 AM"
    var availToTime = "5 PM"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegates
        selectDay.delegate = self
        selectDay.dataSource = self
        
        // UI setup
        dayLabel.text = dayList[0]
        addButton.layer.cornerRadius = 5
        self.view.layer.backgroundColor = UIColor.black.withAlphaComponent(0.7).cgColor
        
        //Custom Range Slider
        //rangeSlider.backgroundColor = UIColor.red
        view.addSubview(rangeSlider)
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged), for: .valueChanged)
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 40.0
        let width = view.bounds.width - 2.0 * margin
        rangeSlider.frame = CGRect(x: margin, y: margin + topLayoutGuide.length + 370,
                                   width: width, height: 31.0)
    }
    
    //
    // #MARK - helper functions
    //
    
    func rangeSliderValueChanged() { //rangeSlider: RangeSlider
        var fromStr = "7 AM"
        var toStr = "6 PM"
        
        switch rangeSlider.lowerValue {
        case 0 ... 0.0370:
            fromStr = "6 AM"
        case 0.0371 ... 0.0741:
            fromStr = "6:30 AM"
        case 0.0742 ... 0.1111:
            fromStr = "7 AM"
        case 0.1112 ... 0.1481:
            fromStr = "7:30 AM"
        case 0.1482 ... 0.1852:
            fromStr = "8 AM"
        case 0.1853 ... 0.2222:
            fromStr = "8:30 AM"
        case 0.2223 ... 0.2593:
            fromStr = "9 AM"
        case 0.2594 ... 0.2963:
            fromStr = "9:30 AM"
        case 0.2964 ... 0.3333:
            fromStr = "10 AM"
        case 0.3334 ... 0.3704:
            fromStr = "10:30 AM"
        case 0.3705 ... 0.4074:
            fromStr = "11 AM"
        case 0.4075 ... 0.4444:
            fromStr = "11:30 AM"
        case 0.4445 ... 0.4815:
            fromStr = "12 PM"
        case 0.4816 ... 0.5185:
            fromStr = "12:30 PM"
        case 0.5186 ... 0.5556:
            fromStr = "1 PM"
        case 0.5557 ... 0.5926:
            fromStr = "1:30 PM"
        case 0.5927 ... 0.6296:
            fromStr = "2 PM"
        case 0.6297 ... 0.6667:
            fromStr = "2:30 PM"
        case 0.6668 ... 0.7037:
            fromStr = "3 PM"
        case 0.7038 ... 0.7407:
            fromStr = "3:30 PM"
        case 0.7408 ... 0.7778:
            fromStr = "4 PM"
        case 0.7779 ... 0.8148:
            fromStr = "4:30 PM"
        case 0.8149 ... 0.8519:
            fromStr = "5 PM"
        case 0.852 ... 0.8889:
            fromStr = "5:30 PM"
        case 0.889 ... 0.9259:
            fromStr = "6 PM"
        case 0.926 ... 0.9630:
            fromStr = "6:30 PM"
        case 0.9631 ... 1.0:
            fromStr = "7 PM"
        default:
            fromStr = "7 AM"
            break
        }
        
        switch rangeSlider.upperValue {
        case 0 ... 0.0370:
            toStr = "6 AM"
        case 0.0371 ... 0.0741:
            toStr = "6:30 AM"
        case 0.0742 ... 0.1111:
            toStr = "7 AM"
        case 0.1112 ... 0.1481:
            toStr = "7:30 AM"
        case 0.1482 ... 0.1852:
            toStr = "8 AM"
        case 0.1853 ... 0.2222:
            toStr = "8:30 AM"
        case 0.2223 ... 0.2593:
            toStr = "9 AM"
        case 0.2594 ... 0.2963:
            toStr = "9:30 AM"
        case 0.2964 ... 0.3333:
            toStr = "10 AM"
        case 0.3334 ... 0.3704:
            toStr = "10:30 AM"
        case 0.3705 ... 0.4074:
            toStr = "11 AM"
        case 0.4075 ... 0.4444:
            toStr = "11:30 AM"
        case 0.4445 ... 0.4815:
            toStr = "12 PM"
        case 0.4816 ... 0.5185:
            toStr = "12:30 PM"
        case 0.5186 ... 0.5556:
            toStr = "1 PM"
        case 0.5557 ... 0.5926:
            toStr = "1:30 PM"
        case 0.5927 ... 0.6296:
            toStr = "2 PM"
        case 0.6297 ... 0.6667:
            toStr = "2:30 PM"
        case 0.6668 ... 0.7037:
            toStr = "3 PM"
        case 0.7038 ... 0.7407:
            toStr = "3:30 PM"
        case 0.7408 ... 0.7778:
            toStr = "4 PM"
        case 0.7779 ... 0.8148:
            toStr = "4:30 PM"
        case 0.8149 ... 0.8519:
            toStr = "5 PM"
        case 0.852 ... 0.8889:
            toStr = "5:30 PM"
        case 0.889 ... 0.9259:
            toStr = "6 PM"
        case 0.926 ... 0.9630:
            toStr = "6:30 PM"
        case 0.9631 ... 1.0:
            toStr = "7 PM"
        default:
            toStr = "7 AM"
            break
        }
        
        timeLabel.text = fromStr + " - " + toStr
        availFromTime = fromStr
        availToTime = toStr
        
        print("Range slider value changed: \(rangeSlider.lowerValue) \(rangeSlider.upperValue) ")//(\(rangeSlider.lowerValue) \(rangeSlider.upperValue))
    }
    
    func appendAvailabilityObject()
    {
        //Get up to date array to append to
        let arrayAvailability = UserDefaults.standard.object(forKey: "availabilityArray")
        
        //check arrayAvailability !nil
        if let arrayAvailability = arrayAvailability {
            addAvailability = arrayAvailability as! [AnyObject]
        }
        
        let newAvailability = Availability(withDay: dayLabel.text!, andFromTime: availFromTime, andToTime: availToTime)
        
        let encodeNewAvail = NSKeyedArchiver.archivedData(withRootObject: newAvailability)
        addAvailability.append(encodeNewAvail as AnyObject)
        
        //save entire array for this new availability to defaults
        UserDefaults.standard.set(addAvailability, forKey: "availabilityArray")
        UserDefaults.standard.synchronize()
    }
    

    //
    // #MARK: - Buttons
    //
    
  
    
    @IBAction func addButtonTapped(_ sender: Any) {
        //delegate?.addAvailabilityToTable()
        view.superview?.isHidden = true //removeFromSuperview()
        appendAvailabilityObject()
        //self.dismiss(animated: true, completion: nil) closes the view
        
        
    }
    
    @IBAction func cancelGoBackButtonTapped(_ sender: Any) {
        view.superview?.isHidden = true //removeFromSuperview()
    }
    
    //
    // #MARK: - Picker View
    //
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // returns the number of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return dayList.count
    }
    // returns data to display in care team picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dayList[row]
    }
    // picker value selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        dayLabel.text = dayList[row]
        availDay = dayList[row]
    }


}
