//
//  Microphone.swift
//  SpeechmaticsDemo
//
//  Created by Dave Duprey on 22/10/2019.
//  Copyright © 2019 What3Words. All rights reserved.
//

import Foundation
import AVFoundation
import AVFAudio



//public enum W3WMicrophoneError : Error, CustomStringConvertible {
//  case noInputAvailable
//  case audioSystemFailedToStart
//  
//  public var description : String {
//    switch self {
//    case .noInputAvailable:         return "No audio inputs available"
//    case .audioSystemFailedToStart: return "The audio system failed to start"
//    }
//  }
//}


/// Manages the device microphone
@available(watchOS 4.0, tvOS 11.0, *)



open class W3WMicrophone: W3WAudioStream {
  
  /// CoreAudio interface
  private var audioEngine: AVAudioEngine!
  /// handle to a microphone
  private var mic: AVAudioInputNode!
  /// keep track as to whether 'mic' has been connected to the audio system
  private var audioIsTapped = false
  /// a current amplitude
  public var amplitude = 0.0
  /// the maximum amplitude so far
  public var maxAmplitude = W3WSettings.defaulMaxAmplitude
  /// the minimum amplitude so far
  public var minAmplitude = 0.0
  /// the smallest "max" volume for the amplitude normalization function
  private static let smallestMaxVolume = 0.25

  
  // MARK: Initialization

  override public init() {
    super.init()
    configure()
  }
  
  override public init(sampleRate: Int, encoding:W3WEncoding) {
    super.init(sampleRate: sampleRate, encoding: encoding)
    configure()
  }

    
  func configure() {
    audioEngine = AVAudioEngine()
    mic = audioEngine.inputNode
    
    do {
      #if canImport(UIKit)
      try AVAudioSession.sharedInstance().setCategory(.record)
      try AVAudioSession.sharedInstance().setActive(true)
      #endif
    } catch {
      print("Error using microphone")
    }
  }
  
  
  
  
  // MARK: Accessors
  
  /// get the current sample rate from the mic
  public func getSampleRate() -> Int {
    return Int(mic.inputFormat(forBus: 0).sampleRate)
  }

  /// set the sample rate to record at
  /// - Parameters:
  ///     - sampleRate: the requested sample rate
  /// - Returns: boolean indicates if it successully changed the sample rate
  public func set(sampleRate: Int) -> Bool {
    #if !os(watchOS) && !os(macOS)
    try? AVAudioSession.sharedInstance().setPreferredSampleRate(Double(sampleRate))
    #endif

    // figure out if the sample rate was changed and signal that back
    let newRate = self.getSampleRate()
    if newRate == sampleRate {
      self.sampleRate = newRate
      return true
    } else {
      return false
    }
  }
  
  /// returns whether the mic is live or idle
  public func isRecording() -> Bool {
    return audioIsTapped
  }
  
  
  public func isMicrophoneAvailable() -> Bool {
    return (mic.inputFormat(forBus: 0).channelCount > 0)
  }

  
  public func isInputAvailable() -> Bool {
    if mic.inputFormat(forBus: 0).sampleRate != 0 {
      return true
    } else {
      return false
    }
  }
  
  // MARK: start() stop()
  
  /// start the mic recording
  public func start() {
    
    start(convertingToSampleRate: sampleRate)

//    // make sure this hardware can record and mic is available
//    if !isInputAvailable() || !isMicrophoneAvailable() {
//      onError(W3WVoiceError.microphoneError(error: W3WMicrophoneError.noInputAvailable))
//
//    // all good to go, so tap the mic
//    } else {
//      var micFormat: AVAudioFormat!
//
//      if encoding == .pcm_s16le {
//        micFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: Double(sampleRate), channels: 1, interleaved: false)!
//      } else {
//        micFormat = mic.inputFormat(forBus: 0)
//      }
//
//      // make sure we got the right rate recorded
//      self.sampleRate = Int(micFormat.sampleRate)
//
//      if (audioIsTapped == false) {
//        audioIsTapped = true
//
//        listeningUpdate(.started)
//
//        mic.installTap(onBus: 0, bufferSize: 2048, format: micFormat) { (buffer: AVAudioPCMBuffer!, time: AVAudioTime!) in
//          self.micReturnedSamples(buffer: buffer, time: time)
//        }
//
//      } else {
//        //print("Warning: microphone was started twice")
//      }
//
//      // start the actual recording
//      do {
//        try audioEngine.start()
//      } catch {
//        onError(W3WVoiceError.microphoneError(error: W3WMicrophoneError.audioSystemFailedToStart))
//      }
//    }
    
  }
  
  
  /// start the mic recording, and return the data converted to a custom sampleRate
  @available(macOS 10.11, *)
  public func start(convertingToSampleRate: Int) {
    
    var outputFormat: AVAudioFormat!
    
    if encoding == .pcm_s16le {
      outputFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: Double(convertingToSampleRate), channels: 1, interleaved: false)!
    } else {
      outputFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: Double(convertingToSampleRate), channels: 1, interleaved: false)!
    }

    let micFormat    = mic.inputFormat(forBus: 0)
    if let converter    = AVAudioConverter(from: micFormat, to: outputFormat) {
      
      if (audioIsTapped == false) {
        audioIsTapped = true
        
        listeningUpdate(.started)
        
        mic.installTap(onBus: 0, bufferSize: 2048, format: micFormat) { (buffer, time) in
          
          let convertedBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: AVAudioFrameCount(outputFormat.sampleRate) * buffer.frameLength / AVAudioFrameCount(buffer.format.sampleRate))!
          
          var error: NSError? = nil
          let status = converter.convert(to: convertedBuffer, error: &error) { inNumPackets, outStatus in
            outStatus.pointee = AVAudioConverterInputStatus.haveData
            return buffer
          }
          
          assert(status != .error)
          
          self.micReturnedSamples(buffer: convertedBuffer, time: time)
        }
        
      } else {
        //print("Warning: microphone was started twice")
      }
      
    } else {
      onError(W3WError.message("The audio system failed to start"))
    }
      
    do {
      try audioEngine.start()
    } catch {
    }
  }

    
//  public override func endSamples() {
//    stop()
//  }
  
  
  /// stop the mic recording
  public func stop() {
    audioEngine.stop()
    audioEngine.reset()
    
    if (audioIsTapped == true) {
      audioIsTapped = false
      mic.removeTap(onBus: 0)
    } else {
      //print("Warning: microphone was stopped twice")
    }

    //endSamples()
    //close()
    
    listeningUpdate(.stopped)
  }
  
  
  // MARK: Events
  
  /// called when there are new data from the microphone
  private func micReturnedSamples(buffer: AVAudioPCMBuffer!, time: AVAudioTime!) {
    // fade the amplitude indicator quickly, but not imediately
    self.amplitude = self.amplitude * 0.3
    
    if encoding == .pcm_f32le {
      processFloatBuffer(buffer: buffer)
    }
    
    if encoding == .pcm_s16le {
      processIntBuffer(buffer: buffer)
    }
    
    // a code block to update amplitude for the UI;
    self.volumeUpdate(getNomralizedVolumeLevelForUI())
  }
  
  
  private func processIntBuffer(buffer: AVAudioPCMBuffer) {
    let sampleDataInt16 = UnsafeBufferPointer(start: buffer.int16ChannelData![0], count: Int(buffer.frameLength))

//    let arraySize = sampleDataInt16.count
//    let samples = Array<Int16>(UnsafeBufferPointer(start: sampleDataInt16.baseAddress, count:arraySize))
//    for sample in samples {
//      print(sample)
//    }

    
    // remember the max amplitude
    if let i = sampleDataInt16.max() {
      let m = Float(i) / Float(Int16.max)
      self.amplitude = Double(m)
      if m > abs(Float(self.maxAmplitude)) {
        self.maxAmplitude = abs(Double(m))
        print(self.maxAmplitude)
      }
    }

    // remember the min amplitude
    if let i = sampleDataInt16.max() {
      let m = Float(i) / Float(Int16.max)
      if m < abs(Float(self.minAmplitude)) {
        self.minAmplitude = abs(Double(m))
      }
    }
    
    self.onSamples(W3WSampleData(buffer: .pcm_s16le(sampleDataInt16), sampleRate: sampleRate, avBuffer: buffer))
  }
  
  
  private func processFloatBuffer(buffer: AVAudioPCMBuffer) {
    let sampleDataFloat = UnsafeBufferPointer(start: buffer.floatChannelData![0], count: Int(buffer.frameLength))
    
    // remember the max amplitude
    if let m = sampleDataFloat.max() {
      self.amplitude = Double(m)
      if m > abs(Float(self.maxAmplitude)) {
        self.maxAmplitude = abs(Double(m))
      }
    }
    
    // remember the min amplitude
    if let m = sampleDataFloat.min() {
      if m < abs(Float(self.minAmplitude)) {
        self.minAmplitude = abs(Double(m))
      }
    }
    
    self.onSamples(W3WSampleData(buffer: .pcm_f32le(sampleDataFloat), sampleRate: sampleRate, avBuffer: buffer))
    self.sampleArrived(sampleDataFloat)
  }
  


//  // override errors so we can stop the mic if nessesary
//  override func update(error: W3WVoiceError) {
//    stop()
//    super.update(error: error)
//  }
//
//  
//  // override suggestions so we can stop the mic if nessesary
//  override func update(suggestions: [W3WVoiceSuggestion]) {
//    stop()
//    callback?(suggestions, nil)
//  }

  
  
  // MARK: Util
  
  /// get a number somewhere approximately 0.0 to 1.0 (sometimes a little more or less) to represent the current volume
  public func getNomralizedVolumeLevelForUI() -> Double {
    // protect against divide by zero
    if (maxAmplitude == 0) {
      return 0.0
      
      // make the normalized volume a percent of the actual volume devided by the maximum recorded value, unless the max value is small
    } else {
      var normalizedLevel = amplitude / maxAmplitude
      
      if (maxAmplitude < W3WMicrophone.smallestMaxVolume) {
        normalizedLevel = amplitude
      }
      
      return normalizedLevel
    }
    
  }

  

}
