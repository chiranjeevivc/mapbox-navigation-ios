import UIKit
import MapboxDirections
import MapboxCoreNavigation

class RouteManeuverViewController: UIViewController {

    @IBOutlet var separatorViews: [SeparatorView]!
    @IBOutlet weak var stackViewContainer: UIView!
    @IBOutlet fileprivate weak var distanceLabel: UILabel!
    @IBOutlet weak var turnArrowView: TurnArrowView!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak fileprivate var shieldImageView: UIImageView!
    @IBOutlet var laneViews: [LaneArrowView]!
    
    let distanceFormatter = DistanceFormatter(approximate: true)
    let routeStepFormatter = RouteStepFormatter()
    
    weak var step: RouteStep!
    
    public func notifyDidChange(routeProgress: RouteProgress, secondsRemaining: TimeInterval) {
        let stepProgress = routeProgress.currentLegProgress.currentStepProgress
        let distanceRemaining = stepProgress.distanceRemaining
        
        distance = secondsRemaining > 5 ? distanceRemaining : nil
        
        if routeProgress.currentLegProgress.alertUserLevel == .arrive {
            distance = nil
            streetLabel.text = routeStepFormatter.string(for: routeStepFormatter.string(for: routeProgress.currentLegProgress.upComingStep))?.abbreviated(toFit: availableStreetLabelBounds, font: streetLabel.font)
        } else if let upComingStep = routeProgress.currentLegProgress?.upComingStep {
            if let name = upComingStep.names?.first {
                streetLabel.text = name.abbreviated(toFit: availableStreetLabelBounds, font: streetLabel.font!)
            } else if let destinations = upComingStep.destinations?.joined(separator: "\n") {
                streetLabel.text = destinations.abbreviated(toFit: availableStreetLabelBounds, font: streetLabel.font!)
            } else {
                streetLabel.text = upComingStep.instructions.abbreviated(toFit: availableStreetLabelBounds, font: streetLabel.font)
                streetLabel.text = routeStepFormatter.string(for: upComingStep)?.abbreviated(toFit: availableStreetLabelBounds, font: streetLabel.font)
            }
            
            // TODO: Factor out and recalculate bounds after shield has been updated
            //updateShield(for: controller)
            
            showLaneView(step: upComingStep)
            
            // TODO: fix animation
            //            if !controller.isPagingThroughStepList {
            //                let initialPaddingForOverviewButton:CGFloat = controller.stackViewContainer.isHidden ? -30 : -20 + controller.laneViews.first!.frame.maxY
            //                UIView.animate(withDuration: 0.5, animations: {
            //                    self.overviewButtonTopConstraint.constant = initialPaddingForOverviewButton + controller.stackViewContainer.frame.maxY
            //                })
            //            }
        }
        
        turnArrowView.step = routeProgress.currentLegProgress.upComingStep
    }
    
    public func updateStreetNameForStep() {
        if let name = step?.names?.first {
            streetLabel.text = name.abbreviated(toFit: availableStreetLabelBounds, font: streetLabel.font)
        } else if let destinations = step?.destinations?.joined(separator: "\n") {
            streetLabel.text = destinations.abbreviated(toFit: availableStreetLabelBounds, font: streetLabel.font)
        } else if let step = step {
            streetLabel.text = routeStepFormatter.string(for: step)?.abbreviated(toFit: availableStreetLabelBounds, font: streetLabel.font)
        }
    }
    
    var distance: CLLocationDistance? {
        didSet {
            if let distance = distance {
                distanceLabel.isHidden = false
                distanceLabel.text = distanceFormatter.string(from: distance)
                streetLabel.numberOfLines = 1
            } else {
                distanceLabel.isHidden = true
                distanceLabel.text = nil
                streetLabel.numberOfLines = 2
            }
        }
    }
    
    var shieldImage: UIImage? {
        didSet {
            shieldImageView.image = shieldImage
        }
    }
    
    var availableStreetLabelBounds: CGRect {
        return CGRect(origin: .zero, size: maximumAvailableStreetLabelSize)
    }
    
    /** 
     Returns maximum available size for street label with padding, turnArrowView
     and shieldImage taken into account. Multiple lines will be used if distance
     is nil.
     
     width = | -8- TurnArrowView -8- availableWidth -8- shieldImage -8- |
     */
    var maximumAvailableStreetLabelSize: CGSize {
        get {
            let size = ("|" as NSString).size(attributes: [NSFontAttributeName: streetLabel.font])
            let lines: CGFloat = distance == nil ? 2 : 1
            let padding: CGFloat = 8*4
            return CGSize(width: view.bounds.width-padding-shieldImageView.bounds.width, height: size.height*lines)
        }
    }
    
    var isPagingThroughStepList = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        turnArrowView.backgroundColor = .clear
    }
    
    func showLaneView(step: RouteStep) {
        if let allLanes = step.intersections?.first?.approachLanes, let usableLanes = step.intersections?.first?.usableApproachLanes {
            for (i, lane) in allLanes.enumerated() {
                guard i < laneViews.count else {
                    return
                }
                stackViewContainer.isHidden = false
                let laneView = laneViews[i]
                laneView.isHidden = false
                laneView.lane = lane
                laneView.maneuverDirection = step.maneuverDirection
                laneView.isValid = usableLanes.contains(i as Int)
                laneView.setNeedsDisplay()
            }
        } else {
            stackViewContainer.isHidden = true
        }
    }
}
