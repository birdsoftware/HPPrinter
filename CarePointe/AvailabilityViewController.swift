//
//  AvailabilityViewController.swift
//  CarePointe
//
//  Created by Brian Bird on 2/3/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit


class AvailabilityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //picker
    @IBOutlet weak var selectDay: UIPickerView!         //tag 1
    @IBOutlet weak var selectToFromTime: UIPickerView!  //tag 2
    
    //labels
    @IBOutlet weak var timeLabel: UILabel!              //
    @IBOutlet weak var dayLabel: UILabel!               //
    
    //table
    @IBOutlet weak var availabilityTable: UITableView!
    
    //container view
    @IBOutlet weak var containerAdd: UIView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addViewBackground: UIView!
    
    
    //buttons
    @IBOutlet weak var acceptChanges: UIButton!//Complete Button
    @IBOutlet weak var addAvailability: UIButton!
    @IBOutlet weak var addButton: UIButton!             //
    @IBOutlet weak var cancelGoBackButton: UIButton!    //
    
    
    //class data
    var availabilitData = [
        ["Monday", "12:30 PM", "11:30 AM"],
        ["Monday", "12:30 PM", "11:30 AM"]
    ]
    
    //public class vars
    let rangeSlider = RangeSlider(frame: CGRect.zero)
    var dayList = ["Monday", "Tuesday", "Wednessday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var halfHourList: [String] = []
    
    //var addAvailability: [AnyObject] = Array()
    var availDay = "Monday"
    var availFromTime = "8 AM"
    var availToTime = "5 PM"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegation
        availabilityTable.delegate = self
        availabilityTable.dataSource = self
        
        selectDay.delegate = self
        selectDay.dataSource = self
        
        selectToFromTime.delegate = self
        selectToFromTime.dataSource = self
        
        //UI set up
        acceptChanges.layer.cornerRadius = 5 //Complete Button
        addAvailability.layer.cornerRadius = addAvailability.bounds.height / 2
        addButton.layer.cornerRadius = 5
        containerAdd.isHidden = true
        addView.isHidden = true
        addViewBackground.isHidden = true
        self.view.layer.backgroundColor = UIColor.black.withAlphaComponent(0.7).cgColor
        addViewBackground.layer.backgroundColor = UIColor.black.withAlphaComponent(0.7).cgColor
        halfHourList = generateHalfHourTimeSeries()
//        for to in halfHourList {
//            print(to)
//        }
    }
    
//    override func viewDidLayoutSubviews() {
//        let margin: CGFloat = 40.0
//        let width = view.bounds.width - 2.0 * margin
//        rangeSlider.frame = CGRect(x: margin, y: margin + topLayoutGuide.length + 370,
//                                   width: width, height: 31.0)
//    }
    
    //
    // #MARK - Helper functions
    //
    
    func generateHalfHourTimeSeries() -> [String]{
        
        var halfHourTimeArray: [String] = []
        halfHourTimeArray.append("0:00 AM")
        
        //Generate String Series: "0:30 AM", "1:00 AM", ... "11:00 PM", "11:30 PM"
        for i in 1 ... 47
        {
            
            let increment = Float(i)
            
            
            if i < 24 { //before noon
                if i % 2 == 0 { // is even
                    halfHourTimeArray.append( "\( Int( increment/2 ) )" + ":00 AM" )
                }
                else { // is odd
                    halfHourTimeArray.append( "\( Int( (increment/2) - 0.5 ) )" + ":30 AM" )
                }
            }
            else if i < 26 { //noon "12:00, 12:30" don't subtract 12 and is PM
                if i % 2 == 0 { // is even
                    halfHourTimeArray.append( "\( Int( increment/2 ) )" + ":00 PM" )
                }
                else { // is odd
                    halfHourTimeArray.append( "\( Int( (increment/2) - 0.5 ) )" + ":30 PM" )
                }
            }
            else {// after noon
                if i % 2 == 0 { // is even
                    halfHourTimeArray.append( "\( Int( increment/2 - 12 ) )" + ":00 PM" )
                }
                else { // is odd
                    halfHourTimeArray.append( "\( Int( (increment/2) - 12.5 ) )" + ":30 PM" )
                }
            }
        }
        
        return halfHourTimeArray
    }

    
    func addAvailabilityToTable() {
        availabilitData.append([availDay, availFromTime, availToTime])
        self.availabilityTable.beginUpdates()
        self.availabilityTable.insertRows(at: [IndexPath.init(row: self.availabilitData.count-1, section: 0)], with: .automatic)
        self.availabilityTable.endUpdates()
        addView.isHidden = true
        addViewBackground.isHidden = true
    }
    
    //
    // #MARK - Table View
    //
    
    // Need to sort alphabetically on the Day column
    
    // return number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(availabilitData.isEmpty == false){
            return availabilitData.count
        }
        else {
            return 0
        }
    }
    
    // return actual CELL to be displayed
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "availabilitycell") as! AvailabilityCell
        
        cell.day.text = availabilitData[indexPath.row][0]
        cell.startTime.text = availabilitData[indexPath.row][1]
        cell.endTime.text = availabilitData[indexPath.row][2]
        
        return cell
    }
    
    //DELETE row (the event) method
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //if (tableView == self.alertTableView)
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            //remove from local array
            availabilitData.remove(at: (indexPath as NSIndexPath).row)
                //line of code above is the same as 2 lines below:
                //alertData[0].remove(at: (indexPath as NSIndexPath).row)
                //alertData[1].remove(at: (indexPath as NSIndexPath).row)
            availabilityTable.reloadData()
            //update alert badge number
            //rightBarButtonAlert.addBadge(number: alertData.count)
        }
    }

    
    //
    // #MARK: - Button Actions
    //
    
    @IBAction func acceptChangesButtonTapped(_ sender: Any) {
        view.superview?.isHidden = true //removeFromSuperview()
        addView.isHidden = true
        addViewBackground.isHidden = true
    }
    
    //show the Add Availability pop with date picker and From To hour picker
    @IBAction func addAvailability(_ sender: Any) {

        
        addView.isHidden = false
        addViewBackground.isHidden = false
    }
    
    @IBAction func addAvailabilityButtonTapped(_ sender: Any) {
        //Insert new availability in table and close view
        addAvailabilityToTable()
        addView.isHidden = true
        addViewBackground.isHidden = true
    }
    
    @IBAction func cancelGoBackButtonTapped(_ sender: Any) {
        //close this view
        addView.isHidden = true
        addViewBackground.isHidden = true
    }
    
    
    
    //
    // #MARK: - Picker View
    //
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if pickerView.tag == 1 {
            return 1
        } else {
            return 2
        }
    }
    // returns the number of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if pickerView.tag == 1 {
            return dayList.count
        } else {
            return halfHourList.count
        }
    }
    // returns data to display in care team picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1 {
            return dayList[row]
        } else {
            if component == 0 {
               return "From: \(halfHourList[row])"
            } else {
                return "To: \(halfHourList[row])"
            }
        }
        //return "Other: \(row)"
    }
    
    // picker value selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        //var fromStr = "8 AM"
        //var toStr = "5 PM"
        
        if pickerView.tag == 1 {
            dayLabel.text = dayList[row]
            availDay = dayList[row]
        } else {
            if component == 0{
                availFromTime = halfHourList[row]
            }else if component == 1{
                availToTime = halfHourList[row]
                
            }
            timeLabel.text = availFromTime + " - " + availToTime
        }
    }
}





