import XCTest
import CoreLocation
@testable import W3WSwiftCore

final class w3w_swift_typesTests: XCTestCase {

  func testDistance() throws {
    let distance = W3WBaseDistance(meters: 1000.0)
    
    XCTAssertEqual(distance.kilometers, 1)
    XCTAssertEqual(distance.miles, 0.621371192237334)
    XCTAssertEqual(distance.feet, 3280.839895013123)
    XCTAssertEqual(distance.furlongs, 4.970969537898672)
    XCTAssertEqual(distance.yards, 1093.6132983377079)
    XCTAssertEqual(distance.nauticalMiles, 0.5399568034557235)
    
    XCTAssertTrue(approximatelyEqual(W3WBaseDistance(miles: 0.621371192237334).kilometers, 1.0))
    XCTAssertTrue(approximatelyEqual(W3WBaseDistance(nauticalMiles: 0.5399568034557235).kilometers, 1.0))
    XCTAssertTrue(approximatelyEqual(W3WBaseDistance(feet: 3280.839895013123).kilometers, 1.0))
    XCTAssertTrue(approximatelyEqual(W3WBaseDistance(furlongs: 4.970969537898672).kilometers, 1.0))
    XCTAssertTrue(approximatelyEqual(W3WBaseDistance(yards: 1093.6132983377079).kilometers, 1.0))
    XCTAssertTrue(approximatelyEqual(W3WBaseDistance(nauticalMiles: 0.5399568034557235).kilometers, 1.0))
  }

  func approximatelyEqual(_ a: Double, _ b: Double) -> Bool {
    return abs(b - a) < 0.00000001
  }

  
  func testLangauge() {
    let language: W3WBaseLanguage = "mn_la"
    
    XCTAssertEqual(language.code, "mn")
    XCTAssertEqual(language.locale, "mn_la")
  }
  
  
  func testDeviceLangauges() {
    let languages = W3WBaseLanguage.english.getDeviceLanguages()
    print(languages)
    
    let assamese = languages.first(where: { lang in lang.locale == "as_IN" }) as? W3WBaseLanguage
    XCTAssertTrue(assamese!.name!.contains("Assamese"))
    XCTAssertTrue(assamese!.name!.contains("India"))
    XCTAssertTrue(assamese!.nativeName!.contains("অসমীয়া"))
    XCTAssertTrue(assamese!.code == "as")
  }
  
  
  func testLanguageNames() {
    let french = W3WBaseLanguage(locale: "fr_ca")
    XCTAssertTrue(french.name!.contains("French"))
    XCTAssertTrue(french.nativeName!.contains("français"))
    XCTAssertTrue(french.nativeName!.contains("Canada"))

    let frenchfrench = W3WBaseLanguage(locale: "fr")
    XCTAssertTrue(frenchfrench.name == "French")
    XCTAssertTrue(frenchfrench.nativeName == "français")
    
    XCTAssertTrue(W3WBaseLanguage.english.name!.contains("English"))
    XCTAssertTrue(W3WBaseLanguage.english.nativeName!.contains("English"))
  }
  
  
  func testOptions() throws {
    
    //let custom1  = W3WOption(key: "yyy", value: "yyy")
    //let custom2  = W3WOption(key: .custom("xxx"), value: .custom("xxx"))
    //let custom3  = W3WOption.custom(key: "zzz", value: "zzz")
    
    let language0 = W3WOption.language(W3WBaseLanguage(code: "en"))
    let language1 = W3WOption.language(W3WBaseLanguage(code: "en_gb"))

    let options = W3WOptions().language(W3WBaseLanguage(code: "en")).clip(to: W3WBaseCountry(code: "gb"))
    
    print(language0, language1)
    print(options)
    
    let o = accept(options: .inputType(.genericVoice).preferLand(true))
    
    XCTAssertEqual(o.options.count, 2)
  }
  
  func accept(options: W3WOptions) -> W3WOptions {
    return options
  }
  
  
  // maybe SDK only? as it has `contains`
//  func testPolygon() throws {
//    let polygon = W3WBasePolygon(points: [
//      CLLocationCoordinate2D(latitude:  2.0, longitude: 2.0),
//      CLLocationCoordinate2D(latitude:  0.0, longitude: 0.0),
//      CLLocationCoordinate2D(latitude:  2.0, longitude: -2.0),
//      CLLocationCoordinate2D(latitude: -2.0, longitude: -2.0),
//      CLLocationCoordinate2D(latitude: -2.0, longitude: 2.0),
//      CLLocationCoordinate2D(latitude:  2.0, longitude: 2.0),
//    ])
//
//    // inside
//    XCTAssertTrue(polygon.contains(point: CLLocationCoordinate2D(latitude: -1.0, longitude:  1.0)))
//    XCTAssertTrue(polygon.contains(point: CLLocationCoordinate2D(latitude:  0.0, longitude:  1.0)))
//    XCTAssertTrue(polygon.contains(point: CLLocationCoordinate2D(latitude: -1.0, longitude:  0.0)))
//    XCTAssertTrue(polygon.contains(point: CLLocationCoordinate2D(latitude: -1.0, longitude: -1.0)))
//    XCTAssertTrue(polygon.contains(point: CLLocationCoordinate2D(latitude:  0.0, longitude: -1.0)))
//
//    // outside
//    XCTAssertFalse(polygon.contains(point: CLLocationCoordinate2D(latitude: -3.0, longitude:  3.0)))
//    XCTAssertFalse(polygon.contains(point: CLLocationCoordinate2D(latitude:  0.0, longitude:  3.0)))
//    XCTAssertFalse(polygon.contains(point: CLLocationCoordinate2D(latitude:  3.0, longitude:  3.0)))
//    XCTAssertFalse(polygon.contains(point: CLLocationCoordinate2D(latitude: -3.0, longitude:  0.0)))
//    XCTAssertFalse(polygon.contains(point: CLLocationCoordinate2D(latitude:  2.0, longitude:  0.0)))
//    XCTAssertFalse(polygon.contains(point: CLLocationCoordinate2D(latitude: -3.0, longitude: -3.0)))
//    XCTAssertFalse(polygon.contains(point: CLLocationCoordinate2D(latitude:  0.0, longitude: -3.0)))
//    XCTAssertFalse(polygon.contains(point: CLLocationCoordinate2D(latitude:  3.0, longitude: -3.0)))
//  }
  
}

 
