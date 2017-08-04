//
//  Constants.swift
//  CarePointe
//
//  Created by Brian Bird on 6/15/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import Foundation

var toggleSB = "sandbox." //Use to Toggel CP/SB. Empty string "" for carepointe, "sandbox." for sandbox API's

struct Constants {
    struct Authentication {
        static let signinURL = "http://"+toggleSB+"carepointe.cloud:4300/api/signin" // RESTSignIn.swift
        static let authToken = "http://"+toggleSB+"carepointe.cloud:4300/api/authenticate" // RESTGETToken.swift
    }
    struct Patient {
        static let patients = "http://"+toggleSB+"carepointe.cloud:4300/api/patients/status/active" // RESTGETPatients.swift
        static let patient = "http://"+toggleSB+"carepointe.cloud:4300/api/patients/patientId/"
        //rx - allergies
        static let patientAllergies = "http://"+toggleSB+"carepointe.cloud:4300/api/rx/allergy/patientId/" // GETCurAllergies.swift
        static let deleteAllergy = "http://"+toggleSB+"carepointe.cloud:4300/api/rx/allergy/allergyId/" //  DELETEAllergy.swift
        //rx - meds
        static let patientCurMeds = "http://"+toggleSB+"carepointe.cloud:4300/api/rx/curmeds/patientId/" // GETCurMeds.swift
        static let postMedication = "http://"+toggleSB+"carepointe.cloud:4300/api/rx/curmeds" //POSTMedication.swift
        static let deleteMedication = "http://"+toggleSB+"carepointe.cloud:4300/api/rx/curmeds/medId/"
        //rx - questionnaire
        static let patientQuestionnaire = "http://"+toggleSB+"carepointe.cloud:4300/api/rx/questionnaire/patientId/" // GETNewQuestionnaire.swift
        
        static let patientCareTeam = "http://"+toggleSB+"carepointe.cloud:4300/api/caseteam/patientId/" //RESTGETCareTeam.swift
        static let patientDisease = "http://"+toggleSB+"carepointe.cloud:4300/api/patientdisease/episodeId/" //RESTGETDisease.swift
        static let patientDocuments = "http://"+toggleSB+"carepointe.cloud:4300/api/documents/patientId/" //RESTGETDocuments.swift
        static let form = "http://"+toggleSB+"carepointe.cloud:4300/api/forms/episodeId/"
        static let patientLocation = "http://"+toggleSB+"carepointe.cloud:4300/api/location/patientId/" //RESTGETLocations.swift
        static let patientReferral = "http://"+toggleSB+"carepointe.cloud:4300/api/referrals/patientId/" //RESTGETPatientRefer.swift
        static let putReferral = "http://"+toggleSB+"carepointe.cloud:4300/api/referrals/careplanid/" //PUTReferrals.swift
        static let patientUpdates = "http://"+toggleSB+"carepointe.cloud:4300/api/patientsupdates/patientId/" //RESTGETPatientUpdates.swift
        static let postPatientUpdate = "http://"+toggleSB+"carepointe.cloud:4300/api/patientsupdates/userId/" //POSTPatientUpdates.swift
        static let patientVitals = "http://"+toggleSB+"carepointe.cloud:4300/api/patientvitals/patientId/" //RESTGETVitals.swift
        static let putVitals = "http://"+toggleSB+"carepointe.cloud:4300/api/patientvitals/patientId/" //RESTPUTVitals.swift
    }
    struct Case {
        static let patientCase = "http://"+toggleSB+"carepointe.cloud:4300/api/case/patientId/"
        static let episodeNotes = "http://"+toggleSB+"carepointe.cloud:4300/api/case/episodeNotes/episodeId/"
    }
    struct ED {
        static let visits = "http://"+toggleSB+"carepointe.cloud:4300/api/er/patientId/"
        static let visitCount = "http://"+toggleSB+"carepointe.cloud:4300/api/er/visits/patientId/"
    }
    struct Message {
        static let postNewMessage = "http://"+toggleSB+"carepointe.cloud:4300/api/inbox" //POSTInboxMessage.swift
        static let deleteFromInbox = "http://"+toggleSB+"carepointe.cloud:4300/api/inbox" // DELETEMessage.swift
        static let fromInbox = "http://"+toggleSB+"carepointe.cloud:4300/api/inbox/userId/" // GETInboxMessages.swift
        static let fromSent = "http://"+toggleSB+"carepointe.cloud:4300/api/inbox/sent/userId/" // GETSentMessages.swift
        static let inboxUsersList = "http://"+toggleSB+"carepointe.cloud:4300/api/inbox/users" //RESTGETUsers.swift
        static let isRead = "http://"+toggleSB+"carepointe.cloud:4300/api/inbox/messageId/" //GETUpdateIsRead.swift
    }
    struct User {
        static let globalAlerts = "http://"+toggleSB+"carepointe.cloud:4300/api/alerts" //RESTGETGlobalAlerts.swift
        static let allReferrals = "http://"+toggleSB+"carepointe.cloud:4300/api/referrals/userId/" //RESTGETReferrals.swift
        static let putProfile = "http://"+toggleSB+"carepointe.cloud:4300/api/user/updateProfile/" //
    }
    struct Tokbox {
        static let eventByRandomKey = "http://"+toggleSB+"carepointe.cloud:4300/api/eventtokbox/randomkey/" //EventsRandKey.swift
    }
    
    private init(){}
}

//UserDefaults.standard
//.set(true, forKey: Constants.Authentication.token)
