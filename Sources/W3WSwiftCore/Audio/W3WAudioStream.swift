//
//  VoiceApi.swift
//  VoiceApiDemo
//
//  Created by Dave Duprey on 23/04/2020.
//  Copyright © 2020 What3Words. All rights reserved.
//


import AVKit
import AVFAudio


public struct W3WSampleData {
  public let buffer: W3WSampleDataBuffer
  public let sampleRate: Int
  
  let avBuffer: AVAudioPCMBuffer?
  
  public func numberOfSamples() -> UInt {
    return buffer.numberOfSamples()
  }

  
  public func asAVAudioPCMBuffer() -> AVAudioPCMBuffer? {
    return avBuffer
  }

  public init(buffer: W3WSampleDataBuffer, sampleRate: Int, avBuffer: AVAudioPCMBuffer?) {
    self.buffer = buffer
    self.sampleRate = sampleRate
    self.avBuffer = avBuffer
  }
  
}


public enum W3WSampleDataBuffer {
  case pcm_f32le(UnsafeBufferPointer<Float>)
  case pcm_s16le(UnsafeBufferPointer<Int16>)
  
  public func numberOfSamples() -> UInt {
    switch self {
    case .pcm_s16le(let sample):
      return UInt(sample.count)
    case .pcm_f32le(let sample):
      return UInt(sample.count)
    }
  }
  
}


open class W3WAudioStream {

  /// the sample rate
  public var sampleRate: Int = 44100
  
  /// the audio encoding format
  public var encoding: W3WEncoding = .pcm_f32le
  
  /// callback for when the mic has new audio data
  public var sampleArrived: (UnsafeBufferPointer<Float>) -> () = { _ in }
  
  /// expermental new callback for multi-format buffers
  public var onSamples: (W3WSampleData) -> () = { _ in }
  
  /// callback for the UI to update/animate any graphics showing microphone volume/amplitude
  public var volumeUpdate: (Double) -> () = { _ in }
  
  /// callback for when the voice recognition stopped
  public var listeningUpdate: ((W3WVoiceListeningState) -> ()) = { _ in }
  
  /// error callback
  public var onError: (W3WError) -> () = { _ in }


  /// base class for audio streaming
  public init(sampleRate: Int, encoding:W3WEncoding) {
    self.sampleRate = sampleRate
    self.encoding   = encoding
  }

  
  /// base class for audio streaming
  public init() {
  }
  

  public func add(samples: UnsafeBufferPointer<Float>) {
    sampleArrived(samples)
  }
  
  
  public func endSamples() {
  }
  
}

