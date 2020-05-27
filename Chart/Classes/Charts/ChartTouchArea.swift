import UIKit

protocol ITouchAreaDelegate: class {
    func touchDown()
    func select(at: Int)
    func touchUp()
}

class ChartTouchArea: Chart {
    private var gestureRecognizer: UILongPressGestureRecognizer?
    private var verticalLine = ChartGridLines()
    private var points = [CGPoint]()
    private var last: Int?

    weak var delegate: ITouchAreaDelegate?

    init(configuration: ChartConfiguration? = nil) {
        super.init(frame: .zero)

        createPanGestureRecognizer()
        add(verticalLine)

        if let configuration = configuration {
            apply(configuration: configuration)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @discardableResult func apply(configuration: ChartConfiguration) -> Self {
        verticalLine.lineWidth = configuration.touchLineWidth
        verticalLine.strokeColor = configuration.touchLineColor
        verticalLine.gridType = .vertical
        verticalLine.retinaCorrected = false

        return self
    }

    // The Pan Gesture
    private func createPanGestureRecognizer() {
        gestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(handlePanGesture(gesture:)))
        if let gestureRecognizer = gestureRecognizer {
            self.addGestureRecognizer(gestureRecognizer)
            gestureRecognizer.minimumPressDuration = 0
            gestureRecognizer.delaysTouchesBegan = false
        }
    }

    func set(points: [CGPoint]) {
        self.points = points
    }

    @objc private func handlePanGesture(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: self)

        switch gesture.state {
        case .began:
            delegate?.touchDown()
            update(at: location)
        case .changed:
            update(at: location)
        default:
            stop()
        }
    }

    private func findNearest(position: CGFloat) -> Int? {
        guard bounds.width > 0 else { return nil }

        let position = position / bounds.width
        for i in 0..<points.count {
            if position == points[i].x {                    // x equal point.x . Return point
                return i
            }
            if position < points[i].x {                     // x less than point.x
                guard (i - 1) >= 0 else {                   // When no previous point, return current
                    return i
                }
                                                            // calculate which point is nearest to x
                let halfInterval = (points[i].x - points[i - 1].x) / 2
                let nearPrevious = (points[i - 1].x + halfInterval) > position

                return nearPrevious ? (i - 1) : i
            }
            guard (i + 1) < points.count else {             // When x more than point.x and no next point, return current
                return i
            }
                                                            // else go next loop
        }
        return nil
    }

    private func update(at location: CGPoint) {
        guard let index = findNearest(position: location.x), last != index else {
            return
        }
        last = index

        verticalLine.set(points: [CGPoint(x: points[index].x, y: 1)], animated: false)
        delegate?.select(at: index)
    }

    private func stop() {
        last = nil

        verticalLine.set(points: [])
        delegate?.touchUp()
    }

}

extension ChartTouchArea: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        true
    }

}
