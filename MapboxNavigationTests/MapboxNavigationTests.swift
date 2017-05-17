import XCTest
import FBSnapshotTestCase
@testable import MapboxDirections
@testable import MapboxNavigation
@testable import MapboxCoreNavigation

class MapboxNavigationTests: FBSnapshotTestCase {
    
    var shieldImage: UIImage {
        get {
            let bundle = Bundle(for: MapboxNavigationTests.self)
            return UIImage(named: "80px-I-280", in: bundle, compatibleWith: nil)!
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        recordMode = false
        isDeviceAgnostic = true
    }
    
    func storyboard() -> UIStoryboard {
        return UIStoryboard(name: "Navigation", bundle: Bundle.navigationUI)
    }
    
    func testManeuverViewMultipleLines() {
        let controller = storyboard().instantiateViewController(withIdentifier: "RouteManeuverViewController") as! RouteManeuverViewController
        XCTAssert(controller.view != nil)
        
        controller.distance = nil
        controller.streetLabel.text = "This should be multiple lines"
        controller.turnArrowView.isEnd = true
        controller.shieldImage = shieldImage
        
        FBSnapshotVerifyView(controller.view)
    }
    
    func testManeuverViewSingleLine() {
        let controller = storyboard().instantiateViewController(withIdentifier: "RouteManeuverViewController") as! RouteManeuverViewController
        XCTAssert(controller.view != nil)
        
        controller.distance = 1000
        controller.streetLabel.text = "This text should shrink"
        controller.turnArrowView.isEnd = true
        controller.shieldImage = shieldImage
        
        FBSnapshotVerifyView(controller.view)
    }
    
    func testManeuverViewAbbrevation() {
        let controller = storyboard().instantiateViewController(withIdentifier: "RouteManeuverViewController") as! RouteManeuverViewController
        XCTAssert(controller.view != nil)
        
        let json = Fixture.JSONFromFileNamed(name: "route")

        let waypoints = json["waypoints"] as! [[String: Any]]
        let firstCoordinate = waypoints[0]["location"] as! [CLLocationDegrees]
        let secondCoordinate = waypoints[1]["location"] as! [CLLocationDegrees]
        
        let options = RouteOptions(coordinates: [
            CLLocationCoordinate2D(latitude: firstCoordinate[1], longitude: firstCoordinate[0]),
            CLLocationCoordinate2D(latitude: secondCoordinate[1], longitude: secondCoordinate[0]),
        ])
        
        let response = options.response(json)
        
        guard let route = response.1?.first else {
            XCTAssert(false, "Unable to parse route")
            return
        }
        
        let routeController = RouteController(route: route)
        
        controller.turnArrowView.isEnd = true
        controller.step = routeController.routeProgress.currentLegProgress.currentStep
        controller.notifyDidChange(routeProgress: routeController.routeProgress, secondsRemaining: 0)
        controller.shieldImage = shieldImage
        
        FBSnapshotVerifyView(controller.view)
    }
}
