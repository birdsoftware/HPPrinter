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
        
        var patients = [[String]]()
        
        let headers = [
            "authorization": token,
            "cache-control": "no-cache",
            "postman-token": "5b46169a-a62b-bd4a-e93f-5056ff0b508a"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://carepointe.cloud:4300/api/patients")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest,
                                        completionHandler: { (data, response, error) -> Void in
                                            if (error != nil) {
                                                print("Error:\n\(error)")
                                                return
                                            } else {
                                                
                                                do {//http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                                                    if let data = data,  //go from a Data? type (optional Data) to a non-optional Data
                                                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                                                        let patientsJSON = json["data"] as? [[String: Any]] {
                                                        if(patientsJSON.isEmpty == false){
                                                            for patient in patientsJSON {
                                                                let patientID = patient["Patient_ID"] as? Int ?? -1 //------
                                                                let patientUniqid = patient["patient_uniqid"] as? String ?? ""
                                                                let firstName = patient["FirstName"] as? String ?? ""
                                                                let lastName = patient["LastName"] as? String ?? ""
                                                                let gender = patient["Gender"] as? String ?? ""
                                                                let ethnicity = patient["Ethnicity"] as? String ?? ""
                                                                let ssn = patient["SSN"] as? String ?? ""
                                                                let patientRAF = patient["patient_RAF"] as? String ?? ""
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
                                                                let primaryPhysician = patient["PrimaryPhysician"] as? String ?? ""
                                                                let physicianContact = patient["PhysicianContact"] as? String ?? ""
                                                                let additionalPhysicians = patient["AdditionalPhysicians"] as? String ?? ""
                                                                let referrerOrigin = patient["ReferrerOrigin"] as? String ?? ""
                                                                let initialDischarge = patient["InitialDischarge"] as? String ?? ""
                                                                let timeLineCount = patient["TimeLineCount"] as? Int ?? -1 //------
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
                                                                let organization = patient["organization"] as? Int ?? -1 //------
                                                                
                                                                let pid = String(patientID)
                                                                let tlc = String(timeLineCount)
                                                                let cb = String(createdBy)
                                                                let up = String(updatedby)
                                                                let cu = String(cscUser)
                                                                let org = String(organization)
                                                                
                                                                patients.append([pid, patientUniqid, firstName, lastName, gender, ethnicity, ssn, patientRAF,
                                                                                 dob, emailID, primaryLanguage, patientAddNotes, homeAddress, city, state,
                                                                                 zip, Phone, cell, additionalContact, contactRelationship, contactPhone,
                                                                                 contactNotes, primarySource, pS_Account, medicaid, medicare, primaryCommercial,
                                                                                 pC_Account, secondaryCommercial, sC_Account, insurance, financeInfoAddNotes, patientSummary,
                                                                                 primaryPhysician, physicianContact, additionalPhysicians, referrerOrigin, initialDischarge,
                                                                                 tlc, isActive, pstatus, cb, createdDateTime, up, updatedDateTime, careteam, profileImage, cu,
                                                                                 pharmacyNCPDP, org])
                                                            }
                                                            print(patients)
                                                            
                                                            let patientIDColumn = patients.getColumn(column: 0)
                                                            UserDefaults.standard.set(patientIDColumn, forKey:"RESTPatientsPatientIDs")
                                                            UserDefaults.standard.set(patients, forKey: "RESTPatients")
                                                            UserDefaults.standard.synchronize()
                                                            
                                                            print("finished GET Patient")
                                                            dispachInstance.leave()
                                                            
                                                        }
                                                    }
                                                } catch {
                                                    print("Error deserializing Patients JSON: \(error)")
                                                }
                                                
                                                //                let httpResponse = response as? HTTPURLResponse
                                                //                
                                                //                
                                                //                print("Status Code : \(httpResponse!.statusCode)")
                                                //                
                                                //let httpData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                                //                print("Response String :\(httpData)")
                                                
//                                                print(patients)
//                                                
//                                                let patientIDColumn = patients.getColumn(column: 0)
                                                
                                                DispatchQueue.main.async {
                                                    
//                                                    UserDefaults.standard.set(patientIDColumn, forKey:"RESTPatientsPatientIDs")
//                                                    UserDefaults.standard.set(patients, forKey: "RESTPatients")
//                                                    UserDefaults.standard.synchronize()
                                                    
                                                    
                                                }
                                                
                                            }
        })
        
        dataTask.resume()
        
    }
    
}

