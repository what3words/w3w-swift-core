//
//  File.swift
//  
//
//  Created by Dave Duprey on 26/06/2023.
//

import Foundation


public protocol W3WAudioStreamProtocol {
  
  /// the sample rate
  var sampleRate: Int { get }
  
  /// the audio encoding format
  var encoding: W3WEncoding { get }
  
  /// callback for when the mic has new audio data
  var sampleArrived: (UnsafeBufferPointer<Float>) -> () { get set }
  
  /// expermental new callback for multi-format buffers
  var onSamples: (W3WSampleData) -> ()  { get set }
  
  /// callback for the UI to update/animate any graphics showing microphone volume/amplitude
  var volumeUpdate: (Double) -> ()  { get set }
  
  /// callback for when the voice recognition stopped
  var listeningUpdate: ((W3WVoiceListeningState) -> ())  { get set }
  
  /// error callback
  var onError: (W3WError) -> ()  { get set }
  
  func add(samples: UnsafeBufferPointer<Float>)
  
  func endSamples()
  
}
