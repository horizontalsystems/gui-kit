import UIKit
import UIExtensions

public struct ChartTimelineItem {
    let text: String
    let timestamp: TimeInterval

    public init(text: String, timestamp: TimeInterval) {
        self.text = text
        self.timestamp = timestamp
    }

}

class TimelineChart: Chart {
    private var texts = [ChartText]()

    private var timelineTexts = [String]()
    private var timelinePositions = [CGPoint]()


    private var configuration: ChartConfiguration?

    init(configuration: ChartConfiguration? = nil) {
        super.init(frame: .zero)

        apply(configuration: configuration)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @discardableResult func apply(configuration: ChartConfiguration?) -> Self {
        self.configuration = configuration

        return self
    }

    func set(texts: [String], positions: [CGPoint]) {
        self.texts.forEach { $0.layer.removeFromSuperlayer() }
        self.texts.removeAll()

        self.timelineTexts = texts
        self.timelinePositions = positions

        texts.forEach {
            let text = ChartText()
            text.set(text: $0)
            if let configuration = configuration {
                text.textColor = configuration.timelineTextColor
                text.font = configuration.timelineFont
            }
            self.texts.append(text)
            add(text)
        }
    }

    func updateTextInsets() {
        guard let configuration = configuration else {
            return
        }

        for i in (0..<timelineTexts.count).reversed() {
            var currentPosition = ShapeHelper.convertRelative(point: timelinePositions[i], size: bounds.size, padding: .zero)
            var insets = configuration.timelineInsets

            if i == texts.count - 1 { // check last element position

                // check text does not go beyond bounds
                let textSize = timelineTexts[i].size(containerWidth: layer.bounds.width, font: configuration.timelineFont)

                let width = textSize.width + configuration.timelineInsets.left + configuration.timelineInsets.right
                if (currentPosition.x + width) > layer.bounds.width {
                    currentPosition.x = layer.bounds.width - width
                }

                insets.left += currentPosition.x
                insets.top += currentPosition.y
            } else {
                let nextPositionX = texts[i + 1].insets.left

                insets.left += currentPosition.x
                insets.top += currentPosition.y
                insets.right += bounds.size.width - nextPositionX
            }

            texts[i].insets = insets
        }
    }

    func setTexts(hidden: Bool) {
        texts.forEach { $0.layer.isHidden = hidden }
    }

    override func layoutSubviews() {
        updateTextInsets()

        super.layoutSubviews()
    }
}
