//
//  AppDelegate.swift
//  SpotifyPlayerSample
//
//  Created by Yusuke Ariyoshi on 2016/09/24.
//  Copyright © 2016年 ariiyu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SPTAudioStreamingDelegate {
    
    var window: UIWindow?
    
    let kClientId = "YOUR_CLIENT_ID"
    let kRedirectUrl = NSURL(string: "YOUR_REDIRECT_URL")
    
    var session: SPTSession?
    var player: SPTAudioStreamingController?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // set up Spotofy
        SPTAuth.defaultInstance().clientID = kClientId
        SPTAuth.defaultInstance().redirectURL = kRedirectUrl
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope] as [AnyObject]
        let loginUrl = SPTAuth.defaultInstance().loginURL
        application.openURL(loginUrl)
        
        return true
    }
    
    // handle auth
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if SPTAuth.defaultInstance().canHandleURL(url) {
            SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url, callback: { error, session in
                if error != nil {
                    print("*** Auth error: \(error)")
                }                
                // Call the -loginUsingSession: method to login SDK
                self.loginUsingSession(session)
            })
            return true
        }
        
        return false
    }
    
    func loginUsingSession(session: SPTSession) {
        // Get the player Instance
        player = SPTAudioStreamingController.sharedInstance()
        if let player = player {
            player.delegate = self
            // start the player (will start a thread)
            try! player.startWithClientId(kClientId)
            // Login SDK before we can start playback
            player.loginWithAccessToken(session.accessToken)
        }
    }
    
    // MARK: SPTAudioStreamingDelegate.
    
    func audioStreamingDidLogin(audioStreaming: SPTAudioStreamingController!) {
        let urlStr = "spotify:track:6ZSvhLZRJredt15aJiBQqv" // track available in Japan
        player!.playSpotifyURI(urlStr, startingWithIndex: 0, startingWithPosition: 0, callback: { error in
            if error != nil {
                print("*** failed to play: \(error)")
                return
            } else {
                print("play")
            }
        })
    }
}

