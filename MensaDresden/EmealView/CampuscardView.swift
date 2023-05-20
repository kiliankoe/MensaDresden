import Foundation
import SwiftUI
import UIKit

struct CampuscardView: View {
    var body: some View {
        ZStack(alignment: .topTrailing) {
            _CampuscardView()
                .aspectRatio(1.6, contentMode: .fit)
            Image(systemName: "fork.knife")
                .font(.system(size: 30))
                .foregroundColor(.white)
                .padding()
        }
    }
}

private struct _CampuscardView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        CampuscardUIView()
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct CampuscardView_Previews: PreviewProvider {
    static var previews: some View {
        CampuscardView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

private class CampuscardUIView: UIView {
    public enum ResizingBehavior: Int {
        case aspectFit
        /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill
        /// The content is proportionally resized to completely fill the target rectangle.
        case stretch
        /// The content is stretched to match the entire target rectangle.
        case center
        /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
            case .aspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .aspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .stretch:
                break
            case .center:
                scales.width = 1
                scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }

    override func draw(_ rect: CGRect) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!

        context.saveGState()
        let resizedFrame: CGRect = ResizingBehavior.aspectFit.apply(
            rect: CGRect(x: 0, y: 0, width: 800, height: 500), target: rect)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 800, y: resizedFrame.height / 500)

        //// Color Declarations
        let wheel1 = UIColor(red: 0.066, green: 0.366, blue: 0.540, alpha: 1.000)
        let wheel2 = UIColor(red: 0.262, green: 0.576, blue: 0.716, alpha: 1.000)
        let wheel3 = UIColor(red: 0.442, green: 0.813, blue: 0.923, alpha: 1.000)
        let wheel4 = UIColor(red: 0.006, green: 0.669, blue: 0.681, alpha: 1.000)
        let wheel5 = UIColor(red: 0.041, green: 0.709, blue: 0.556, alpha: 1.000)
        let wheel6 = UIColor(red: 0.535, green: 0.779, blue: 0.393, alpha: 1.000)
        let wheel7 = UIColor(red: 0.702, green: 0.823, blue: 0.207, alpha: 1.000)
        let wheel8 = UIColor(red: 0.000, green: 0.188, blue: 0.378, alpha: 1.000)

        //// bottom Drawing
        let bottomPath = UIBezierPath(rect: CGRect(x: 0, y: 406, width: 800, height: 99))
        UIColor.white.setFill()
        bottomPath.fill()

        //        //// serialnumberlabel Drawing
        //        let serialnumberlabelRect = CGRect(x: 459, y: 423, width: 283, height: 21)
        //        let serialnumberlabelTextContent = "Seriennummer / serial number"
        //        let serialnumberlabelStyle = NSMutableParagraphStyle()
        //        serialnumberlabelStyle.alignment = .left
        //        let serialnumberlabelFontAttributes = [
        //            .font: UIFont.systemFont(ofSize: UIFont.labelFontSize),
        //            .foregroundColor: UIColor.darkGray,
        //            .paragraphStyle: serialnumberlabelStyle,
        //        ] as [NSAttributedString.Key: Any]
        //
        //        let serialnumberlabelTextHeight: CGFloat = serialnumberlabelTextContent.boundingRect(with: CGSize(width: serialnumberlabelRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: serialnumberlabelFontAttributes, context: nil).height
        //        context.saveGState()
        //        context.clip(to: serialnumberlabelRect)
        //        serialnumberlabelTextContent.draw(in: CGRect(x: serialnumberlabelRect.minX, y: serialnumberlabelRect.minY + (serialnumberlabelRect.height - serialnumberlabelTextHeight) / 2, width: serialnumberlabelRect.width, height: serialnumberlabelTextHeight), withAttributes: serialnumberlabelFontAttributes)
        //        context.restoreGState()
        //
        //
        //        //// serialnumber Drawing
        //        let serialnumberRect = CGRect(x: 459, y: 444, width: 298, height: 34)
        ////        let serialnumberTextContent = "123-4567-8901-234-567"
        //        let serialnumberTextContent = serialNumber
        //        let serialnumberStyle = NSMutableParagraphStyle()
        //        serialnumberStyle.alignment = .left
        //        let serialnumberFontAttributes = [
        //            .font: UIFont.systemFont(ofSize: 24.5),
        //            .foregroundColor: UIColor.black,
        //            .paragraphStyle: serialnumberStyle,
        //        ] as [NSAttributedString.Key: Any]
        //
        //        let serialnumberTextHeight: CGFloat = serialnumberTextContent.boundingRect(with: CGSize(width: serialnumberRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: serialnumberFontAttributes, context: nil).height
        //        context.saveGState()
        //        context.clip(to: serialnumberRect)
        //        serialnumberTextContent.draw(in: CGRect(x: serialnumberRect.minX, y: serialnumberRect.minY + (serialnumberRect.height - serialnumberTextHeight) / 2, width: serialnumberRect.width, height: serialnumberTextHeight), withAttributes: serialnumberFontAttributes)
        //        context.restoreGState()

        //// w8 Drawing
        let w8Path = UIBezierPath()
        w8Path.move(to: CGPoint(x: 215, y: 316))
        w8Path.addLine(to: CGPoint(x: 269, y: -27))
        w8Path.addLine(to: CGPoint(x: 25, y: -27))
        w8Path.addLine(to: CGPoint(x: 215, y: 316))
        w8Path.close()
        wheel7.setFill()
        w8Path.fill()

        //// w7 Drawing
        let w7Path = UIBezierPath()
        w7Path.move(to: CGPoint(x: 215, y: 316))
        w7Path.addLine(to: CGPoint(x: 25.5, y: -26.5))
        w7Path.addLine(to: CGPoint(x: -85.5, y: -26.5))
        w7Path.addLine(to: CGPoint(x: -85.5, y: 216.5))
        w7Path.addLine(to: CGPoint(x: 215, y: 316))
        w7Path.close()
        wheel6.setFill()
        w7Path.fill()

        //// w6 Drawing
        let w6Path = UIBezierPath()
        w6Path.move(to: CGPoint(x: 215, y: 316))
        w6Path.addLine(to: CGPoint(x: 55, y: 406))
        w6Path.addLine(to: CGPoint(x: -19, y: 406))
        w6Path.addLine(to: CGPoint(x: -19, y: 238))
        w6Path.addLine(to: CGPoint(x: 215, y: 316))
        w6Path.close()
        wheel5.setFill()
        w6Path.fill()

        //// w5 Drawing
        let w5Path = UIBezierPath()
        w5Path.move(to: CGPoint(x: 215, y: 316))
        w5Path.addLine(to: CGPoint(x: 195, y: 406))
        w5Path.addLine(to: CGPoint(x: 55, y: 406))
        w5Path.addLine(to: CGPoint(x: 215, y: 316))
        w5Path.close()
        wheel4.setFill()
        w5Path.fill()

        //// w4 Drawing
        let w4Path = UIBezierPath()
        w4Path.move(to: CGPoint(x: 215, y: 316))
        w4Path.addLine(to: CGPoint(x: 289, y: 406))
        w4Path.addLine(to: CGPoint(x: 195, y: 406))
        w4Path.addLine(to: CGPoint(x: 215, y: 316))
        w4Path.close()
        wheel3.setFill()
        w4Path.fill()

        //// w3 Drawing
        let w3Path = UIBezierPath()
        w3Path.move(to: CGPoint(x: 215, y: 316))
        w3Path.addLine(to: CGPoint(x: 858, y: 355))
        w3Path.addLine(to: CGPoint(x: 858, y: 406))
        w3Path.addLine(to: CGPoint(x: 289, y: 406))
        w3Path.addLine(to: CGPoint(x: 215, y: 316))
        w3Path.close()
        wheel2.setFill()
        w3Path.fill()

        //// w2 Drawing
        let w2Path = UIBezierPath()
        w2Path.move(to: CGPoint(x: 215, y: 316))
        w2Path.addLine(to: CGPoint(x: 858, y: 355))
        w2Path.addLine(to: CGPoint(x: 832, y: -66))
        w2Path.addLine(to: CGPoint(x: 625, y: -27))
        w2Path.addLine(to: CGPoint(x: 215, y: 316))
        w2Path.close()
        wheel1.setFill()
        w2Path.fill()

        //// w1 Drawing
        let w1Path = UIBezierPath()
        w1Path.move(to: CGPoint(x: 215, y: 316))
        w1Path.addLine(to: CGPoint(x: 268.84, y: -26.5))
        w1Path.addLine(to: CGPoint(x: 624.5, y: -26.5))
        w1Path.addLine(to: CGPoint(x: 215, y: 316))
        w1Path.close()
        wheel8.setFill()
        w1Path.fill()

    }
}
