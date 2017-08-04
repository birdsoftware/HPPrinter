//
//  RESTGETPatients.swift
//  CarePointe
//
//  Created by Brian Bird on 3/23/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

//
//  RESTPatients.swift
//  testRestAPI
//
//  Created by Brian Bird on 3/21/17.
//  Copyright © 2017 Brian Bird. All rights reserved.
//

import Foundation
//import UIKit

class GETPatients {
    
    func getPatients(token: String, dispachInstance: DispatchGroup) {
        
        //var patients = [[String]]()
        var patients = Array<Dictionary<String,String>>()
        //var patientNameID:Array<Dictionary<String,String>> = []
        
        let headers = [
            "authorization": token,
            "cache-control": "no-cache"
           // "postman-token": "5b46169a-a62b-bd4a-e93f-5056ff0b508a"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: Constants.Patient.patients)! as URL,//"http://carepointe.cloud:4300/api/patients/"
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)//http://carepointe.cloud:4300/api/patients/status/active
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest,
            completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print("Error when Attempting to GET Patients\(String(describing: error))")
                    dispachInstance.leave()
                    return
                } else {
                    
                    do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                        if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                            let patientsJSON = json["data"] as? [[String: Any]] {
                            if(patientsJSON.isEmpty == false){

                                for patient in patientsJSON {
                                    
                                    let patientID = patient["Patient_ID"] as? Int ?? -1 //------
                                    //let prefix = patient["prefix"] as? String ?? ""
                                    //let suffix = patient["suffix"] as? String ?? ""
                                    //let patientUniqid = patient["patient_uniqid"] as? String ?? ""
                                    let firstName = patient["FirstName"] as? String ?? ""
                                    let lastName = patient["LastName"] as? String ?? ""
                                    let gender = patient["Gender"] as? String ?? ""
                                    let ethnicity = patient["Ethnicity"] as? String ?? ""
                                    let ssn = patient["SSN"] as? String ?? ""
                                    //let patientRAF = patient["patient_RAF"] as? String ?? ""
                                    let dob = patient["DOB"] as? String ?? ""
                                    let emailID = patient["EmailID"] as? String ?? ""
                                    let primaryLanguage = patient["PrimaryLanguage"] as? String ?? ""
                                    let patientAddNotes = patient["PatientAddNotes"] as? String ?? ""
                                    let homeAddress = patient["HomeAddress"] as? String ?? ""
                                    let city = patient["City"] as? String ?? ""
                                    let state = patient["State"] as? String ?? ""
                                    let zip = patient["Zip"] as? String ?? ""
                                    let Phone = patient["Phone"] as? String ?? ""
                                    let cell = patient["Cell"] as? String ?? ""
                                    let additionalContact = patient["AdditionalContact"] as? String ?? ""
                                    let contactRelationship = patient["ContactRelationship"] as? String ?? ""
                                    let contactPhone = patient["ContactPhone"] as? String ?? ""
                                    let contactNotes = patient["ContactNotes"] as? String ?? ""
                                    let primarySource = patient["PrimarySource"] as? String ?? ""
                                    let pS_Account = patient["PS_Account"] as? String ?? ""
                                    let medicaid = patient["Medicaid"] as? String ?? ""
                                    let medicare = patient["Medicare"] as? String ?? ""
                                    let primaryCommercial = patient["PrimaryCommercial"] as? String ?? ""
                                    let pC_Account = patient["PC_Account"] as? String ?? ""
                                    let secondaryCommercial = patient["SecondaryCommercial"] as? String ?? ""
                                    let sC_Account = patient["SC_Account"] as? String ?? ""
                                    let insurance = patient["insurance"] as? String ?? ""
                                    let financeInfoAddNotes = patient["FinanceInfoAddNotes"] as? String ?? ""
                                    let patientSummary = patient["PatientSummary"] as? String ?? ""
                                    //let primaryPhysician = patient["PrimaryPhysician"] as? String ?? ""
                                    //let physicianContact = patient["PhysicianContact"] as? String ?? ""
                                    //let additionalPhysicians = patient["AdditionalPhysicians"] as? String ?? ""
                                    //let referrerOrigin = patient["ReferrerOrigin"] as? String ?? ""
                                    //let initialDischarge = patient["InitialDischarge"] as? String ?? ""
                                    //let timeLineCount = patient["TimeLineCount"] as? Int ?? -1 //------
                                    let isActive = patient["IsActive"] as? String ?? ""
                                    let pstatus = patient["pstatus"] as? String ?? ""
                                    let createdBy = patient["CreatedBy"] as? Int ?? -1 //------
                                    let createdDateTime = patient["CreatedDateTime"] as? String ?? "" //2017-03-22T17:14:22.000Z "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                                    let updatedby = patient["Updatedby"] as? Int ?? -1 //------
                                    let updatedDateTime = patient["UpdatedDateTime"] as? String ?? ""
                                    let careteam = patient["careteam"] as? String ?? ""
                                    let profileImage = patient["profile_image"] as? String ?? ""
                                    let cscUser = patient["csc_user"] as? Int ?? -1 //------
                                    let pharmacyNCPDP = patient["pharmacy_NCPDP"] as? String ?? ""
                                    let organization = patient["organization"] as? String ?? "" //AZPC
                                    let CarePrograms = patient["CarePrograms"] as? String ?? ""
                                    
                                    let pid = String(patientID)
                                    //let tlc = String(timeLineCount)
                                    let cb = String(createdBy)
                                    let up = String(updatedby)
                                    let cu = String(cscUser)
                                    //let org = String(organization)
                                    let firstLastName = firstName + " " + lastName
                                    
                                    //define dictionary literals
                                    //http://stackoverflow.com/questions/30418101/find-key-value-pair-in-an-array-of-dictionaries
                                    patients.append(["Patient_ID":pid, //"patient_uniqid":patientUniqid,
                                                     "patientName":firstLastName, /*"FirstName":firstName, "LastName":lastName, */
                                                     "Gender":gender, "Ethnicity":ethnicity, "SSN":ssn, //"patient_RAF":patientRAF,
                                                     "DOB":dob, "EmailID":emailID, "PrimaryLanguage":primaryLanguage, "PatientAddNotes":patientAddNotes,
                                                     "HomeAddress":homeAddress, "City":city, "State":state, "Zip":zip, "Phone":Phone, "Cell":cell,
                                                     "AdditionalContact":additionalContact, "ContactRelationship":contactRelationship, "ContactPhone":contactPhone,
                                                     "ContactNotes":contactNotes, "PrimarySource":primarySource, "PS_Account":pS_Account, "Medicaid":medicaid, "Medicare":medicare,
                                                     "PrimaryCommercial":primaryCommercial, "PC_Account":pC_Account, "SecondaryCommercial":secondaryCommercial,
                                                     "SC_Account":sC_Account, "insurance":insurance, "FinanceInfoAddNotes":financeInfoAddNotes,
                                                     "PatientSummary":patientSummary, //"PrimaryPhysician":primaryPhysician, "PhysicianContact":physicianContact,
                                                     //"AdditionalPhysicians":additionalPhysicians, "ReferrerOrigin":referrerOrigin, "InitialDischarge":initialDischarge, "TimeLineCount":tlc, 
                                                     "IsActive":isActive, "pstatus":pstatus, "CreatedBy":cb, "CreatedDateTime":createdDateTime,
                                                     "Updatedby":up, "UpdatedDateTime":updatedDateTime, "careteam":careteam, "profile_image":profileImage, "csc_user":cu,
                                                     "pharmacy_NCPDP":pharmacyNCPDP, "organization":organization, "CarePrograms":CarePrograms])
                                    
                                    //patientNameID.append(["Patient_ID":pid,"patientName":firstLastName,"CreatedDateTime":createdDateTime, "pstatus":pstatus, "organization":organization])

                                }
//                                                            let patientIDColumn =  patients.getColumn(column: 0)
//                                                            let patientFirstName = patients.getColumn(column: 2)
//                                                            let patientLastName = patients.getColumn(column: 3)
//                                                            
//                                                            var patientNameID = [[String]]()
//                                                            for Iterator in 0..<(patients.count){
//                                                                patientNameID.append(["\(patientFirstName[Iterator])" + " " + "\(patientLastName[Iterator])", "\(patientIDColumn[Iterator])"])
//                                                            }
                                //UserDefaults.standard.set(patientNameID, forKey:"RESTPatientsPatientIDs")
                                UserDefaults.standard.set(patients, forKey: "RESTPatients")
                                UserDefaults.standard.synchronize()
                                
                                print("finished GET Patient")
                                dispachInstance.leave()
                                
                            }
                        }
                    } catch {
                        print("Error deserializing Patients JSON: \(error)")
                        dispachInstance.leave()
                    }
                    
                    //                let httpResponse = response as? HTTPURLResponse
                    //                print("Status Code : \(httpResponse!.statusCode)")
                    //      let httpData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    //                print("Response String :\(httpData)")

//                                                DispatchQueue.main.async {
//                                                }
                    
                }
})
        
        dataTask.resume()
        
    }
    
}

