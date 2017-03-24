//
//  defualtsComments.swift
//  CarePointe
//
//  Created by Brian Bird on 2/2/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

/*
 
 
 
 UpdateProfileViewController
 
    // --save first, last name and title
    UserDefaults.standard.set(firstName, forKey: "profileName")
    UserDefaults.standard.set(lastName, forKey: "profileLastName")
    UserDefaults.standard.set(title, forKey: "title")
 
    // --profileNeedsUpdate
    UserDefaults.standard.set(true, forKey: "profileNeedsUpdate")
 
    // 3 --store imagePath to user defaults
    let imagePathText = imagePath
    let imagePathDefault = UserDefaults.standard
    imagePathDefault.setValue(imagePathText, forKey: "imagePathKey")
 
    UserDefaults.standard.set(true, forKey: "newPhotoWasSelected")
 
 RegiserViewController
 
    defaults.set(userEmail.text, forKey: "email")
    defaults.set(userPassword.text, forKey: "password")
 
 SignInViewController
 
    UserDefaults.standard.set(true, forKey: "isUserSignedIn")
 
 ViewController
 
    let didUpdateCalendarDate = UserDefaults.standard.bool(forKey: "didUpdateCalendarDate")
    UserDefaults.standard.setValue(strDate ,forKey: "newDate")
 
    IN override func prepare(for segue: UIStoryboardSegue, sender: Any?)
        UserDefaults.standard.set(filterAppointmentID, forKey: "filterAppointmentID")
     
        UserDefaults.standard.set(patientName, forKey: "patientNameMainDashBoard")
        UserDefaults.standard.set(selectedRow, forKey: "selectedRow")
        UserDefaults.standard.set(accepted, forKey: "sectionForSelectedRow")
 
 PTVTableViewController
 
    IN override func prepare(for segue: UIStoryboardSegue, sender: Any?)
        defaults.set(patientName, forKey: "patientName")
        defaults.set(patientID, forKey: "patientID")
        defaults.set(patientStatus, forKey: "patientStatus")
        defaults.set(patientStatus, forKey: "selectedRow")
        defaults.set(patientStatus, forKey: "sectionForSelectedRow")
 
    IN viewDidLoad()
        let onlyDoOnce = UserDefaults.standard.integer(forKey: "onlyDoOnce")
 
    IN setUpAppointmentData()
        UserDefaults.standard.set(appSec, forKey: "appSec")
        UserDefaults.standard.set(appID, forKey: "appID")
        UserDefaults.standard.set(appPat, forKey: "appPat")
        UserDefaults.standard.set(onlyDoOnceHere, forKey: "onlyDoOnce")
        UserDefaults.standard.synchronize()
 
 PTVDetailViewController
    
    IN viewDidLoad()
        // show specific patient Name from defaults i.e. "Ruth Quinonez" etc.
        let patientName = UserDefaults.standard.string(forKey: "patientName")
        let patientStatus = UserDefaults.standard.string(forKey: "patientStatus")
        updatePatientView(status: patientStatus!)
 
 
 
 PasswordChangeViewController
 
    defaults.set(password2.text, forKey: "password")
    defaults.set(true, forKey: "passwordReset")
 
 UpdateProfileViewController
 
    UserDefaults.standard.set(true, forKey: "newPhotoWasSelected")
    imagePathDefault.setValue(imagePathText, forKey: "imagePathKey")
 
    // --save first, last name and title
    UserDefaults.standard.set(firstName, forKey: "profileName")
    UserDefaults.standard.set(lastName, forKey: "profileLastName")
    UserDefaults.standard.set(title, forKey: "title")
    UserDefaults.standard.set(email, forKey: "email")
 
        firstNameField.placeholder =  UserDefaults.standard.string(forKey: "profileName")!
        lastNameField.placeholder = UserDefaults.standard.string(forKey: "profileLastName")!
        titleField.placeholder = UserDefaults.standard.string(forKey: "title")!
        emailField.placeholder = UserDefaults.standard.string(forKey: "email")!
 
    // --profileNeedsUpdate
    UserDefaults.standard.set(true, forKey: "profileNeedsUpdate")
    UserDefaults.standard.synchronize()
 
 SignatureViewController
 
    // --save didESign BOOL = true
    UserDefaults.standard.set(true, forKey: "didESign")
 
 TermsViewController
 
    let userDidESign = UserDefaults.standard.bool(forKey: "didESign")
 
 
 setUpPatientData
 
    UserDefaults.standard.set(appointmentIDs, forKey: "appID")
    UserDefaults.standard.set(patients, forKey: "appPat")
    UserDefaults.standard.set(times, forKey: "appTime")
    UserDefaults.standard.set(dates, forKey: "appDate")
    UserDefaults.standard.set(appointmentMessage, forKey: "appMessage")
    UserDefaults.standard.synchronize()
 
 inboxViewController
 
 RESTPatients.swift
 
    UserDefaults.standard.set(patients, forKey: "RESTPatients")
    UserDefaults.standard.synchronize()
 
 RESTGETToken.swift
    UserDefaults.standard.set(token, forKey: "token")
    UserDefaults.standard.synchronize()
 
 /*
 * Check if value Already Exists in user defaults
 *
 */
 func isKeyPresentInUserDefaults(key: String) -> Bool {
 return UserDefaults.standard.object(forKey: key) != nil
 }
 
 
 
 
 
 
 */


