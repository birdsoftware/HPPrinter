//
//  TokBoxVC.swift
//  CarePointe
//
//  Created by Brian Bird on 6/20/17.
//  Copyright © 2017 Mogul Pro Media. All rights reserved.
//

import UIKit
import OpenTok


//info.plist add: Privacy - Camera Usage Description
//                  Privacy - Microphone
// Replace with your OpenTok API key
var kApiKey = "45689742"
// Replace with your generated session ID
var kSessionId = "1_MX40NTY4OTc0Mn5-MTQ5NzAzMDg5NzA5OH5EZnl2YkNHbGtadmMwbnMzaGhqa3dsSUt-fg"
// Replace with your generated token
var kToken = /*"T1==cGFydG5lcl9pZD00NTY4OTc0MiZzaWc9ZmQwMDlkODMzMDg2Y2YzYTc1MGRkMjM3YTVlMmFjMDBmMWEyOTg3YjpzZXNzaW9uX2lkPTFfTVg0ME5UWTRPVGMwTW41LU1UUTVOekF6TURnNU56QTVPSDVFWm5sMllrTkhiR3RhZG1Nd2JuTXphR2hxYTNkc1NVdC1mZyZjcmVhdGVfdGltZT0xNDk4MDAxMjM4Jm5vbmNlPTAuNjkwOTc0MDU0ODg2MzQ3JnJvbGU9c3Vic2NyaWJlciZleHBpcmVfdGltZT0xNTAwNTkzMjM3"*/"T1==cGFydG5lcl9pZD00NTY4OTc0MiZzaWc9MTU2ODllM2UwMjI5N2U1ZTZkYjIwZThlNjA2MTE1ZTJmNzY5NDFlZTpzZXNzaW9uX2lkPTFfTVg0ME5UWTRPVGMwTW41LU1UUTVOekF6TURnNU56QTVPSDVFWm5sMllrTkhiR3RhZG1Nd2JuTXphR2hxYTNkc1NVdC1mZyZjcmVhdGVfdGltZT0xNDk4MDAxMDk5Jm5vbmNlPTAuODE4OTg5MjcwNTU0MDIxMiZyb2xlPXB1Ymxpc2hlciZleHBpcmVfdGltZT0xNTAwNTkzMDk5" //publisher

var panGesture       = UIPanGestureRecognizer()//make dragable
var tapGesture       = UITapGestureRecognizer()
var videoView = UIView()//make dragable
var toggle = true

class TokBoxVC: UIViewController/*, UICollectionViewDataSource*/ {

    //buttons videoFeedBox.jpg
    @IBOutlet weak var endCallButton: UIButton!
    @IBOutlet weak var swapCameraButton: UIButton!
    @IBOutlet weak var muteMicButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    
    //label
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var publisherCameraPositionLabel: UILabel!
    
//    var subscribers: [IndexPath: OTSubscriber] = [:]
//    
//    lazy var session: OTSession = {
//        return OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self as? OTSessionDelegate)!
//    }()
    lazy var publisher: OTPublisher = {
        let settings = OTPublisherSettings()
        settings.name = UIDevice.current.name
        return OTPublisher(delegate: self, settings: settings)!
    }()
    
    //let textChat = OTKTextChatComponent
    
    var error: OTError?
    
    var session: OTSession?
    //var publisher: OTPublisher?//see your self
    var subscriber: OTSubscriber?//see someone else, subscribe to other clients' streams
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        muteButton.isEnabled = false

        // Do any additional setup after loading the view.
        userName.text = UIDevice.current.name
        
        getOpenTokSessionId()
        
        //connectToAnOpenTokSession()
        //session.connect(withToken: kToken, error: &error)
    }
    
    func getOpenTokSessionId(){
        
        let signin = DispatchGroup(); signin.enter()
        
        let savedUserEmail = UserDefaults.standard.object(forKey: "email") as? String ?? "-"
        let savedUserPassword = UserDefaults.standard.object(forKey: "password") as? String ?? "-"
        
        POSTSignin().signInUser(userEmail: savedUserEmail, userPassword: savedUserPassword, dispachInstance: signin)
        
        signin.notify(queue: DispatchQueue.main) {
        
            let getToken = DispatchGroup(); getToken.enter()
            
            GETToken().signInCarepoint(dispachInstance: getToken)
            
            getToken.notify(queue: DispatchQueue.main) {
                let token = UserDefaults.standard.string(forKey: "token")
                
                let getEvent = DispatchGroup(); getEvent.enter()
                
                GETEvents().byRandKey(tokenSignIn: token!, randomKey: "nHm9B", dispachInstance: getEvent)
                
                getEvent.notify(queue: DispatchQueue.main) {
                    let event = UserDefaults.standard.object(forKey: "RESTEventByRandKey") as? Dictionary<String,String> ?? Dictionary<String,String>()
                    
                    kSessionId = event["sessionid"]!
                    kToken = event["token"]!
                    
                    self.connectToAnOpenTokSession()
                }
            }
        }
    }
    
    func connectToAnOpenTokSession() {
        session = OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self)
        var error: OTError?
        session?.connect(withToken: kToken, error: &error)
        if error != nil {
            print(error!)
        }
    }
    
    func movePublisherView(to: String) {
    
        guard let publisherView = publisher.view else {
            return
        }
        let screenBounds = UIScreen.main.bounds
        //https://stackoverflow.com/questions/17332622/how-get-bottom-y-coordinate
        switch to {
        case "center":
            publisherView.frame = CGRect(x: screenBounds.width/2 - 100, y: screenBounds.height/2 - 100, width: 200, height: 200)
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        case "bottum_left":
            publisherView.frame = CGRect(x: 10, y: screenBounds.height - 230, width: 150, height: 150)
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        default:
            publisherView.frame = CGRect(x: screenBounds.width - 300, y: screenBounds.height - 450 - 20, width: 200, height: 200)
        }

    }
    
    
    //
    // MARK: - Button Actions
    //
    @IBAction func backButtonAction(_ sender: Any) {
        session?.disconnect(&error)
    }
    
    @IBAction func muteSubscriberAction(_ sender: Any) {
        subscriber?.subscribeToAudio = !(subscriber?.subscribeToAudio ?? true)
        
        let buttonImage: UIImage  = {
            if !(subscriber?.subscribeToAudio ?? true) {
                return UIImage(named: "subscriber_speaker_mute-35")!
            } else {
                return UIImage(named: "subscriber_speaker-35")!
            }
        }()
        
        muteButton.setImage(buttonImage, for: .normal)
    }
    
    @IBAction func swapCameraAction(_ sender: Any) {
        if publisher.cameraPosition == .front {
            publisher.cameraPosition = .back
            publisherCameraPositionLabel.text = "back"
        } else {
            publisher.cameraPosition = .front
            publisherCameraPositionLabel.text = "front"
        }
    }
    
    @IBAction func muteMicAction(_ sender: Any) {
        publisher.publishAudio = !publisher.publishAudio
        
        let buttonImage: UIImage  = {
            if !publisher.publishAudio {
                return UIImage(named: "mic_muted-24")!
            } else {
                return UIImage(named: "mic-24")!
            }
        }()
        
        muteMicButton.setImage(buttonImage, for: .normal)
    }
    @IBAction func endCallAction(_ sender: Any) {
        session?.disconnect(&error)
        //muteButton.isEnabled = false
    }

//    func reloadCollectionView() {
//        collectionView.isHidden = subscribers.count == 0
//        collectionView.reloadData()
//    }
    
    // MARK: - Collection View
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return subscribers.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subscriberCell", for: indexPath) as! SubscriberCollectionCell
//        cell.subscriber = subscribers[indexPath]
//        return cell
//    }

}


// MARK: - OTSessionDelegate callbacks
extension TokBoxVC: OTSessionDelegate {
    func sessionDidConnect(_ session: OTSession) {
        print("The client connected to the OpenTok session.")
        self.view.makeToast("Connected to TeleConnect.", duration: 1.1, position: .bottom)
//        let settings = OTPublisherSettings()
//        settings.name = UIDevice.current.name
//        guard let publisher = OTPublisher(delegate: self, settings: settings) else {
//            return
//        }
        
        var error: OTError?
        session.publish(publisher, error: &error)
        guard error == nil else {
            print(error!)
            return
        }
        
        guard let publisherView = publisher.view else {
            return
        }
//
//        let screenBounds = UIScreen.main.bounds
//        publisherView.frame = CGRect(x: 10, y: screenBounds.height - 230, width: 150, height: 150)
        self.movePublisherView(to: "center")
        //make dragable
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(TokBoxVC.draggedView(_:)))//make dragable
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(TokBoxVC.tappedView(_:)))//handle tap
        publisherView.isUserInteractionEnabled = true//make dragable
        publisherView.addGestureRecognizer(panGesture)//make dragable
        publisherView.addGestureRecognizer(tapGesture)//make dragable
        
        view.addSubview(publisherView)
        videoView = publisherView//make dragable
    }
    
    //dragable
    func draggedView(_ sender:UIPanGestureRecognizer){
        self.view.bringSubview(toFront: videoView)
        let translation = sender.translation(in: self.view)
        videoView.center = CGPoint(x: videoView.center.x + translation.x, y: videoView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }//make dragable
    func tappedView(_ sender:UITapGestureRecognizer){
        if toggle == true{
            videoView.frame.size = CGSize(width: 300, height: 300)
        } else {
            videoView.frame.size = CGSize(width: 150, height: 150)
        }
        toggle = !toggle
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        print("The client disconnected from the OpenTok session.")
        self.view.makeToast("Disconnected from TeleConnect.", duration: 1.1, position: .bottom)
        self.movePublisherView(to: "center")
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("The client failed to connect to the OpenTok session: \(error).")
        self.view.makeToast("Failed to connect: \(error).", duration: 1.1, position: .bottom)
    }
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("A stream was created in the session.")
        self.view.makeToast("A caller is connecting.", duration: 1.1, position: .bottom)
        
        subscriber = OTSubscriber(stream: stream, delegate: self)
        guard let subscriber = subscriber else {
            return
        }
        
        var error: OTError?
        session.subscribe(subscriber, error: &error)
        guard error == nil else {
            print(error!)
            return
        }
        
        guard let subscriberView = subscriber.view else {
            return
        }
        subscriberView.frame = UIScreen.main.bounds
        view.insertSubview(subscriberView, at: 0)
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("A stream was destroyed in the session.")
        self.view.makeToast("Caller left.", duration: 1.1, position: .bottom)
        self.movePublisherView(to: "center")
        muteButton.isEnabled = false
    }
}

// MARK: - OTPublisherDelegate callbacks
extension TokBoxVC: OTPublisherDelegate {
    func publisher(_ publisher: OTPublisherKit, streamCreated stream: OTStream) {
    }
    
    func publisher(_ publisher: OTPublisherKit, streamDestroyed stream: OTStream) {
    }
    
    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        print("The publisher failed: \(error)")
        self.view.makeToast("The publisher failed: \(error)", duration: 1.1, position: .bottom)
    }
}

// MARK: - OTSubscriberDelegate callbacks
extension TokBoxVC: OTSubscriberDelegate {
    public func subscriberDidConnect(toStream subscriber: OTSubscriberKit) {
        print("The subscriber did connect to the stream.")
        self.view.makeToast("Caller connected.", duration: 1.1, position: .bottom)
        self.movePublisherView(to: "bottum_left")
        muteButton.isEnabled = true
    }
    
    public func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print("The subscriber failed to connect to the stream.")
        self.view.makeToast("Caller failed to connect.", duration: 1.1, position: .bottom)
    }
}


//extension TokBoxVC: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return subscribers.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subscriberCell", for: indexPath) as! SubscriberCollectionCell
//        cell.subscriber = subscribers[indexPath]
//        return cell
//    }
//}



// MARK: - Subscriber Cell

//class SubscriberCollectionCell: UICollectionViewCell {
//    @IBOutlet weak var muteButton: UIButton!
//    
//    var subscriber: OTSubscriber?
//    

//
//    override func layoutSubviews() {
//        if let sub = subscriber, let subView = sub.view {
//            subView.frame = bounds
//            contentView.insertSubview(subView, belowSubview: muteButton)
//            
//            muteButton.isEnabled = true
//            muteButton.isHidden = false
//        }
//    }
//}

// MARK: - OpenTok Methods
//extension TokBoxVC {
//    func doPublish() {
//        swapCameraButton.isEnabled = true
//        muteMicButton.isEnabled = true
//        endCallButton.isEnabled = true
//        
//        if let pubView = publisher.view {
//            let publisherDimensions = CGSize(width: view.bounds.size.width / 4, height: view.bounds.size.height / 6)
//            //let screenBounds = UIScreen.main.bounds
//            /*pubView.frame = CGRect(x: screenBounds.width - 300, y: screenBounds.height - 450 - 20, width: 200, height: 200)*/CGRect(origin: CGPoint(x:collectionView.bounds.size.width - publisherDimensions.width, y:collectionView.bounds.size.height - publisherDimensions.height + collectionView.frame.origin.y), size: publisherDimensions)
//            view.addSubview(pubView)
//            
//        }
//        
//        session.publish(publisher, error: &error)
//    }
//    
//    func doSubscribe(to stream: OTStream) {
//        if let subscriber = OTSubscriber(stream: stream, delegate: self) {
//            let indexPath = IndexPath(item: subscribers.count, section: 0)
//            subscribers[indexPath] = subscriber
//            session.subscribe(subscriber, error: &error)
//            
//            reloadCollectionView()
//        }
//    }
//    
//    func findSubscriber(byStreamId id: String) -> (IndexPath, OTSubscriber)? {
//        for (_, entry) in subscribers.enumerated() {
//            if let stream = entry.value.stream, stream.streamId == id {
//                return (entry.key, entry.value)
//            }
//        }
//        return nil
//    }
//    
//    func findSubscriberCell(byStreamId id: String) -> SubscriberCollectionCell? {
//        for cell in collectionView.visibleCells {
//            if let subscriberCell = cell as? SubscriberCollectionCell,
//                let subscriberOfCell = subscriberCell.subscriber,
//                (subscriberOfCell.stream?.streamId ?? "") == id
//            {
//                return subscriberCell
//            }
//        }
//        
//        return nil
//    }
//}

// MARK: - OTSession delegate callbacks
//extension TokBoxVC: OTSessionDelegate {
//    func sessionDidConnect(_ session: OTSession) {
//        print("Session connected")
//        doPublish()
//    }
//    
//    func sessionDidDisconnect(_ session: OTSession) {
//        print("Session disconnected")
//        subscribers.removeAll()
//        reloadCollectionView()
//    }
//    
//    func session(_ session: OTSession, streamCreated stream: OTStream) {
//        print("Session streamCreated: \(stream.streamId)")
//        if subscribers.count == 4 {
//            print("Sorry this sample only supports up to 4 subscribers :)")
//            return
//        }
//        doSubscribe(to: stream)
//    }
//    
//    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
//        print("Session streamDestroyed: \(stream.streamId)")
//        
//        guard let (index, subscriber) = findSubscriber(byStreamId: stream.streamId) else {
//            return
//        }
//        subscriber.view?.removeFromSuperview()
//        subscribers.removeValue(forKey: index)
//        reloadCollectionView()
//    }
//    
//    func session(_ session: OTSession, didFailWithError error: OTError) {
//        print("session Failed to connect: \(error.localizedDescription)")
//    }
//}
//
//// MARK: - OTPublisher delegate callbacks
//extension TokBoxVC: OTPublisherDelegate {
//    func publisher(_ publisher: OTPublisherKit, streamCreated stream: OTStream) {
//    }
//    
//    func publisher(_ publisher: OTPublisherKit, streamDestroyed stream: OTStream) {
//    }
//    
//    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
//        print("Publisher failed: \(error.localizedDescription)")
//    }
//}
//
//// MARK: - OTSubscriber delegate callbacks
//extension TokBoxVC: OTSubscriberDelegate {
//    func subscriberDidConnect(toStream subscriberKit: OTSubscriberKit) {
//        print("Subscriber connected")
//        reloadCollectionView()
//    }
//    
//    func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
//        print("Subscriber failed: \(error.localizedDescription)")
//    }
//    
//    func subscriberVideoDataReceived(_ subscriber: OTSubscriber) {
//    }
//}



