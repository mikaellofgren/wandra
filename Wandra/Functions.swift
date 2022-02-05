//
//  Functions.swift
//  Wandra
//
//  Created by Mikael Löfgren on 2021-02-24.
//

import Foundation
import SwiftUI
import CoreWLAN
import CoreLocation

func hideWindowButtons() {
    // Hide window buttons and remove tabbing and fullscreen
       for window in NSApplication.shared.windows {
        window.standardWindowButton(NSWindow.ButtonType.zoomButton)?.isHidden = true
        window.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(NSWindow.ButtonType.closeButton)?.isHidden = true
        window.backgroundColor = NSColor.white
        window.collectionBehavior = .fullScreenNone
        NSWindow.allowsAutomaticWindowTabbing = false
        }
}

func getSSIDName () -> String {
    let ssid = CWWiFiClient.shared().interface(withName: nil)?.ssid() ?? ""
    return ssid
    }

func getSignalToNoiseRatio () -> (snr: Int, snrText: String, snrColor: Color){
    var noise = CWWiFiClient.shared().interface()?.noiseMeasurement() ?? 0
    noise = abs(noise)
    let snr = noise-getStrength().strength
    var snrText = ""
    var snrColor = Color("LightGreen")

switch snr {
        case 0...9 :
            snrText = "Very poor signal"
            snrColor = Color("Red")
        case 10...15 :
            snrText = "Very low signal"
            snrColor = Color("Orange")
        case 16...25 :
            snrText = "Low signal"
            snrColor = Color("Yellow")
        case 26...40 :
            snrText = "Very good signal"
            snrColor = Color("LightGreen")
        case 41...100 :
            snrText = "Excellent signal"
            snrColor = Color("DarkGreen")
        default :
            print("Cant scalculate snr signal")
        }
    
    return (snr, snrText, snrColor)
}

func getStrength () -> (strength: Int, strengthText: String, strengthColor: Color) {
    var strength = CWWiFiClient.shared().interface()?.rssiValue() ?? 0
    strength = abs(strength)
    var strengthText = ""
    var strengthColor = Color("LightGreen")
    
    switch strength {
        case 0...49 :
                strengthText = "Maximum signal"
                strengthColor = Color("DarkGreen")
        case 50...59 :
                strengthText = "Excellent signal"
                strengthColor = Color("DarkGreen")
        case 60...67 :
                strengthText = "Very good signal"
                strengthColor = Color("LightGreen")
        case 68...70 :
                strengthText = "Low signal"
                strengthColor = Color("Yellow")
        case 71...79 :
                strengthText = "Very low signal"
                strengthColor = Color("Orange")
        case 80...100 :
                strengthText = "Very poor signal"
                strengthColor = Color("Red")
            default :
                print("Cant calculate strength signal")
            }
    return (strength, strengthText, strengthColor)
}

func normalise(macString: String) -> String {
    // https://developer.apple.com/forums/thread/50302
    return String(macString
        .uppercased()
        .split(separator: ":")
        .map{("00" + $0).suffix(2)}
        .joined(separator: ":")
    )
}

func getBSSIDName () -> String {
    // Signing and Capabilities - App Sandbox Location is needed for BSSID and Outgoing connections client and import CoreLocation
    CLLocationManager().requestWhenInUseAuthorization()
    let locationEnableStatus = CLLocationManager.locationServicesEnabled()
   
    var bssid = CWWiFiClient.shared().interface()?.bssid() ?? ""
    bssid = normalise(macString: bssid)
    if locationWarningHasBeenShown == 0 {
        if locationEnableStatus == false || bssid.isEmpty && !getSSIDName().isEmpty {
        print("Location services disabled")
        
        let info = NSAlert()
        info.icon = NSImage(systemSymbolName: "location.slash.fill", accessibilityDescription: nil)
        info.addButton(withTitle: "OK")
        info.alertStyle = NSAlert.Style.informational
        info.messageText = "Please enable location services"
        info.informativeText = "By pressing OK button locations setting will open. Unlock and then enable locations services and also make sure to allow this app from the list. Otherwise the app cannot retrieve the BSSID."
        info.runModal()
        locationWarningHasBeenShown += 1
        
        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Location")!)
    }
    }
return bssid
}

func timeNowString () -> String {
let formatter = DateFormatter()
formatter.timeStyle = .medium
    return formatter.string(from: Date())
}

func dateNowString () -> String {
let formatter = DateFormatter()
formatter.dateStyle = .short
    return formatter.string(from: Date())
}

func saveMeasuredData (_ stringToBeSaved: String) {
            // Save Dialog
            let dialog = NSSavePanel();
            dialog.showsResizeIndicator  = true;
            dialog.showsHiddenFiles      = false;
            dialog.canCreateDirectories  = true;
            // Default Save value, add .csv
            dialog.nameFieldStringValue = "measured_data_\(dateNowString()).csv"
          
           
           if (dialog.runModal() == NSApplication.ModalResponse.OK) {
               let result = dialog.url // Pathname of the file
               if (result != nil) {
                   let path = result!.path
                   
                    let documentDirURL = URL(fileURLWithPath: path)
                   // Save data to file
                   let fileURL = documentDirURL
                   let writeString = stringToBeSaved
                   do {
                       // Write to the file
                       try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
                   } catch let error as NSError {
                       print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
                    let info = NSAlert()
                        info.icon = NSImage (named: NSImage.cautionName)
                        info.addButton(withTitle: "OK")
                        info.alertStyle = NSAlert.Style.informational
                        info.messageText = "Something went wrong when saving file to"
                        info.informativeText = "\(path)"
                        info.runModal()
                   }
               
                   let info = NSAlert()
                       info.icon = NSImage(systemSymbolName: "doc.plaintext", accessibilityDescription: nil)
                       info.addButton(withTitle: "OK")
                       info.alertStyle = NSAlert.Style.informational
                       info.messageText = "Successfully saved file to"
                       info.informativeText = "\(path)"
                       info.runModal()
               }
           } else {
            // User clicked on "Cancel"
               return
           }
           // End Save Dialog
}

extension NSTextField {
    // Workaround to remove textfield focus ring around textfield
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
