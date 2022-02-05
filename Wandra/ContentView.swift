//
//  ContentView.swift
//  Wandra
//
//  Created by Mikael Löfgren on 2021-02-23.
//

import SwiftUI
import AVKit

// basestationsArray contains only unique basestations ID, is used to get all custom names from basestationsWithNameArray
var basestationsArray = Set<String>()
var basestationsWithNameArray = [String: String]()
var ssidArray = [SSID]()
var timeInterval: Double = 2
var baseStationIDFirstTime = true
var rssiFirstTime = true
var locationWarningHasBeenShown = 0

struct SSID {
    var ssid: String
    var bssid: String
    var apname: String
    var snr: Int
    var strength: Int
    var time: String
}

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var ssidName: String = ""
    @State private var snrValue: Float = 0
    @State private var snr: Int = 0
    @State private var snrText: String = ""
    @State private var rssiValue: Float = 0
    @State private var strength: Int = 0
    @State private var strengthText: String = ""
    @State private var basestationID: String = ""
    @State private var baseStationTextFieldName: String = ""
    @State private var stepperValue = timeInterval
    @State private var timer = Timer.publish(every: TimeInterval(timeInterval), on: .main, in: .common).autoconnect()
    @State private var buttonPressed: Bool = true
    @State private var buttonImage = "pause.fill"
    @State private var soundImage = "speaker.slash.fill"
    @State private var soundMuted: Bool = true

    
    
var body: some View {
    ZStack(alignment: .top) {
            Spacer()
            .background(colorScheme == .dark ? Color.black : Color.white)
                .edgesIgnoringSafeArea(.all)
                .frame(width: 250, height: 715)
                
            VStack {
                SSIDView(ssidname: self.$ssidName)
                SNRView(signalToNoise: self.$snrValue, snr: self.$snr, snrText: self.$snrText )
                RSSIView(rssi: self.$rssiValue, strength: self.$strength, strengthText: self.$strengthText, isSoundMuted: self.$soundMuted )
                BasestationView(baseStationID: self.$basestationID)
                BasestationTextFieldView(baseStationName: self.$baseStationTextFieldName, baseStationID: self.$basestationID)
                .onReceive(timer) { _ in
                        withAnimation {
                            self.runApp()
                            }
                        }
                Divider().frame(width: 200).padding(.bottom, 5)
                Button(action: {
                    self.buttonStartStop()
                   }){
                    Image(systemName: self.buttonImage)
                        .font(.largeTitle)
                        .frame(width: 50, height:50)
                        .foregroundColor(Color.white)
                        .background(Color("DarkGreen"))
                        .clipShape(Circle())
                    }.buttonStyle(PlainButtonStyle())
                     .padding(.bottom, 5)
                     .help(buttonHelp)
                     .contextMenu {
                  Button(action: {
                    // Get every items from array and add in to csvString
                     var csvString = "ssid, bssid, apname, snr, strength, time\n"
                        for every in ssidArray {
                            csvString += ("\(every.ssid), \(every.bssid), \(every.apname), \(every.snr), \(every.strength), \(every.time)\n")
                         }
                    
                    // Add the custom basestations name to the whole csv string, otherwise it will output only right name from when name was entered to Array, using wildcard for matching
                    for basestations in basestationsArray {
                        csvString = csvString.replacingOccurrences(of: "\(basestations)(,)(.*?)(,)", with: "\(basestations), \(basestationsWithNameArray[basestations] ?? ""),",
                                                                   options: .regularExpression)
                    }
                    saveMeasuredData(csvString)
                    }) {
                    Text("Save as .csv file")
                    }
               }
                
                Stepper("Measure interval: \(stepperValue, specifier: "%g") in seconds",
                    onIncrement: {
                    stepperValue += 1
                    if stepperValue >= 10 { stepperValue = 10 }
                        timeInterval = stepperValue
                        self.stopTimer()
                        self.startTimer()
                            }, onDecrement: {
                                stepperValue -= 1
                                if stepperValue <= 1 { stepperValue = 1 }
                                timeInterval = stepperValue
                                self.stopTimer()
                                self.startTimer()
                            })
                
                Button(action: {
                    soundButtonStartStop ()
                }){
                    Image(systemName: self.soundImage)
                }.help(soundHelp)
                    }
    }
                }
    
struct SSIDView: View {
    @Binding var ssidname: String
    var body: some View {
        VStack {
            Text("\(ssidname)")
                .frame(width: 165, height: 20)
                .background(RoundedRectangle(cornerRadius: 20.0).fill(Color.gray).opacity(0.3))
                .help(ssidHelp)
        }.padding(.bottom, 5)
    }
}

struct SNRView: View {
    @Binding var signalToNoise: Float
    @Binding var snr: Int
    @Binding var snrText: String
    @State private var showHelpPopover = false
    var body: some View {
        VStack {
            Divider().frame(width: 200)
            Text("Signal to Noise Ratio")
                .onTapGesture {
                    showHelpPopover = true
                }
                .popover(isPresented: $showHelpPopover, arrowEdge: .leading) {
                    ZStack {
                        Color("Yellow")
                            .scaleEffect(5)
                        Text(snrHelpPopover)
                            .foregroundColor(Color.black)
                            .padding(8)
                        }
                        }
            .help(snrHelp)
            .padding(.bottom, 20)
      
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.gray)
                
          Circle()
            .trim(from: 0.0, to: CGFloat(min(self.signalToNoise, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
            .foregroundColor(getSignalToNoiseRatio().snrColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
                .help(snrValueHelp)
            
            Text("\(self.snr)")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 20)
                
            Text("\(self.snrText)")
                .padding(.top, 20)
                .help(snrValueHelp)
        }  .frame(width: 150.0, height: 150.0)
           .padding(.bottom, 20)
        }
    }
}

struct RSSIView: View {
    @Binding var rssi: Float
    @Binding var strength: Int
    @Binding var strengthText: String
    @Binding var isSoundMuted: Bool
    @State var audioPlayer: AVAudioPlayer!
    @State var showHelpPopover = false
    var body: some View {
        ZStack {
            // Used only to get right space as BaseStation View
        }
        VStack {
           Divider().frame(width: 200)
           Text("Received Signal Strength Indicator")
            .onTapGesture {
                showHelpPopover = true
            }
            .popover(isPresented: $showHelpPopover, arrowEdge: .leading) {
                ZStack {
                    Color("Yellow")
                        .scaleEffect(5)
                    Text(rssiHelpPopover)
                        .foregroundColor(Color.black)
                        .padding(8)
                    }
                    }
            .help(rssiHelp)
            .padding(.bottom, 20)
            
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
          Circle()
            .trim(from: 0.0, to: CGFloat(min(self.rssi, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
            .foregroundColor(getStrength().strengthColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
                .help(rssiValueHelp)
           Text("-\(self.strength)")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
            .onChange(of: strength) {[strength] newValue in
                if rssiFirstTime == false {
                let strengthHigherThenLast = newValue-3
                    if strength < strengthHigherThenLast && isSoundMuted == false {
                    let sound = Bundle.main.path(forResource: "sonar", ofType: "mp3")
                    self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                    self.audioPlayer.play()
                }
                } else { rssiFirstTime = false }
            }
            Text("\(self.strengthText)")
                    .padding(.top, 20)
                    .help(rssiValueHelp)
        }  .frame(width: 150.0, height: 150.0)
        .padding(.bottom, 20)
    }
}
}

struct BasestationView: View {
    @Binding var baseStationID: String
    @State private var showingPopover = false
    @State private var showHelpPopover = false
    var body: some View {
        
        ZStack {
            // Used only for popover, couldnt have two popovers in same stack
        }
        .onChange(of: baseStationID) { newValue in
            // Dont show popover first time starting app or no ssid, and show only when we got a bssid
            if baseStationIDFirstTime == true {
                showingPopover = false
            if baseStationID != "" {
                baseStationIDFirstTime = false
            }
        } else {
            showingPopover = true
        }
        }
        .popover(isPresented: $showingPopover, arrowEdge: .leading) {
            ZStack {
                Color("DarkGreen")
                    .scaleEffect(5)
                Text("Roaming...")
                    .foregroundColor(Color.white)
                    .padding(8)
                    }
                }.offset(x: -82, y: 32)
                       
    VStack {
        Divider().frame(width: 200)
            .padding(.bottom, 5)
            Text("\(baseStationID)")
                .padding()
                .frame(width: 165, height: 20)
                .background(RoundedRectangle(cornerRadius: 20.0).fill(Color.gray).opacity(0.3))
                .help(bssidHelp)
            .onTapGesture {
                showHelpPopover = true
            }
            .popover(isPresented: $showHelpPopover, arrowEdge: .leading) {
                ZStack {
                    Color("Yellow")
                        .scaleEffect(5)
                    Text(bssidHelpPopover)
                        .foregroundColor(Color.black)
                        .padding(8)
                    }
                    }
                .contextMenu {
                    Button(action: {
                let pasteboard = NSPasteboard.general
                pasteboard.declareTypes([.string], owner: nil)
                pasteboard.setString("\(baseStationID)", forType: .string)
            }) {
            Text("Copy")
            }
            }
        }
    }
}

struct BasestationTextFieldView: View {
    @Binding var baseStationName: String
    @Binding var baseStationID: String
    
    var body: some View {
        VStack {
            // Set name to matching BaseStationID, disable textfield if BaseStationID is empty
            if baseStationID != "" {
            TextField("Access point name", text: $baseStationName, onCommit: {
                            basestationsWithNameArray["\(getBSSIDName())"] = "\(baseStationName)"
                        })
            .frame(width: 165, height: 20)
            .multilineTextAlignment(.center)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .help(apNameHelp)
            .onChange(of: baseStationID) { newValue in
                // Show custom ap name from matching BaseStationID
                    if let getMatchingName = basestationsWithNameArray[baseStationID] {
                        baseStationName = getMatchingName
                        NSApp.keyWindow?.makeFirstResponder(nil)
                    } else {
                        baseStationName = ""
                    }
               }
            } else {
                TextField("Access point name", text: $baseStationID).disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    .frame(width: 165, height: 20)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .help(apNameDisabledHelp)
                }
       }.padding(.bottom, 5)
       
        }
}


    func stopTimer() {
           self.timer.upstream.connect().cancel()
       }
       
    func startTimer() {
           self.timer = Timer.publish(every: TimeInterval(timeInterval), on: .main, in: .common).autoconnect()
       }
    
    func buttonStartStop() {
        if self.buttonPressed == true {
            self.stopTimer()
            self.resetValues()
            self.buttonPressed = false
            self.buttonImage = "play.fill"
        } else {
            self.buttonPressed = false
            self.startTimer()
            self.buttonPressed = true
            self.buttonImage = "pause.fill"
        }
    }
    
    func soundButtonStartStop () {
        if self.soundMuted == true {
            self.soundImage  = "speaker.3.fill"
            self.soundMuted = false
        } else {
            self.soundImage = "speaker.slash.fill"
            self.soundMuted = true
        }
    }
    
    func resetValues() {
        // reset all fields
        self.ssidName = ""
        self.snrValue = 0
        self.snr = 0
        self.snrText = ""
        self.rssiValue = 0
        self.strength = 0
        self.strengthText = ""
        self.basestationID = ""
        self.buttonPressed = true
        baseStationIDFirstTime = true
    }
    
    func runApp() {
        hideWindowButtons()

        if getSSIDName() == "" {
            self.buttonStartStop()
            // Show alert
           let info = NSAlert()
                info.icon = NSImage (named: NSImage.cautionName)
                info.addButton(withTitle: "OK")
                info.alertStyle = NSAlert.Style.informational
                info.messageText = "Wi-Fi seems disabled"
                info.informativeText = "Enable Wi-Fi, then press play button to try again"
                info.runModal()
            
            return
        }
        self.ssidName = getSSIDName()
        self.snrValue = Float(getSignalToNoiseRatio().snr)/100*2 // Better matching with scale of 50
        self.snr = getSignalToNoiseRatio().snr
        self.snrText = getSignalToNoiseRatio().snrText
        self.rssiValue = Float(getStrength().strength)/100 // Better matching with scale of 100
        self.strength = getStrength().strength
        self.strengthText = getStrength().strengthText
        self.basestationID = getBSSIDName()
        basestationsArray.insert(self.basestationID)
        
        // Get the baseStationTextFieldName, so its output correct name to ssidArray
        if basestationsWithNameArray.isEmpty {
            self.baseStationTextFieldName = ""
        } else {
            if let name = basestationsWithNameArray[getBSSIDName()] {
                self.baseStationTextFieldName = name
            } else {
                self.baseStationTextFieldName = ""
            }
        }
        
        // Append all data to ssidArray
        ssidArray.append(contentsOf:[SSID(ssid: self.ssidName, bssid: self.basestationID, apname: self.baseStationTextFieldName, snr: self.snr, strength: self.strength, time: timeNowString ())])
        }
       }



