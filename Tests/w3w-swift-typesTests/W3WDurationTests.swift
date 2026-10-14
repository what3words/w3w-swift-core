//
//  W3WDurationTests.swift
//  w3w-swift-core
//
//  Created by Dave Duprey on 14/10/2026.
//

import Testing
@testable import W3WSwiftCore


struct W3WDurationTests {

  @Test func hoursDaysAndWeeksAreStoredInSeconds() {
    #expect(W3WDuration(hours: 1).seconds == 3_600)
    #expect(W3WDuration(days: 1).seconds == 86_400)
    #expect(W3WDuration(weeks: 1).seconds == 604_800)
  }


  @Test func secondsReadBackAsHoursDaysAndWeeks() {
    #expect(W3WDuration(seconds: 7_200).hours == 2)
    #expect(W3WDuration(seconds: 172_800).days == 2)
    #expect(W3WDuration(seconds: 1_209_600).weeks == 2)
  }


  @Test func settingHoursDaysAndWeeksUpdatesSeconds() {
    var duration = W3WDuration(seconds: 0)

    duration.hours = 3
    #expect(duration.seconds == 10_800)

    duration.days = 3
    #expect(duration.seconds == 259_200)

    duration.weeks = 3
    #expect(duration.seconds == 1_814_400)
  }


  @Test func unitsAreConsistentWithEachOther() {
    #expect(W3WDuration(days: 1).hours == 24)
    #expect(W3WDuration(weeks: 1).days == 7)
  }
}
