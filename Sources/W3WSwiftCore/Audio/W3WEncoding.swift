//
//  W3WEncoding.swift
//  
//
//  Created by Dave Duprey on 04/04/2023.
//
//  Naming from this kind of thing (copied maybe from ffmpeg's style?):
//
//  s means "signed" (for the integer representations), u would mean "unsigned"
//  16 means 16 Bits per sample
//  le means "little endian" coding for the samples
//
//  alaw     PCM A-law
//  f32be    PCM 32-bit floating-point big-endian
//  f32le    PCM 32-bit floating-point little-endian
//  f64be    PCM 64-bit floating-point big-endian
//  f64le    PCM 64-bit floating-point little-endian
//  mulaw    PCM mu-law
//  s16be    PCM signed 16-bit big-endian
//  s16le    PCM signed 16-bit little-endian
//  s24be    PCM signed 24-bit big-endian
//  s24le    PCM signed 24-bit little-endian
//  s32be    PCM signed 32-bit big-endian
//  s32le    PCM signed 32-bit little-endian
//  s8       PCM signed 8-bit
//  u16be    PCM unsigned 16-bit big-endian
//  u16le    PCM unsigned 16-bit little-endian
//  u24be    PCM unsigned 24-bit big-endian
//  u24le    PCM unsigned 24-bit little-endian
//  u32be    PCM unsigned 32-bit big-endian
//  u32le    PCM unsigned 32-bit little-endian
//  u8       PCM unsigned 8-bit
//

/// defines different audio encodings
public enum W3WEncoding : String {
  case pcm_f32le = "pcm_f32le"
  case pcm_s16le = "pcm_s16le"
}

