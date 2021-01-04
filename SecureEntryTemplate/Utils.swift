//
//  Utils.swift
//  SecureEntryTemplate
//
//  Created by Ацкий Станислав on 01.01.2021.
//

import UIKit
import CryptoKit

extension UIViewController {
    func embededInNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}

extension UIView {
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: self, options: nil)?.first as! T
    }
}

extension UIButton {
    func setDeleteButtonAppearence() {
        let trianglePath = UIBezierPath()
        let triangleLayer = CAShapeLayer()
        trianglePath.move(to: CGPoint(x: 0, y: 15))
        trianglePath.addLine(to: CGPoint(x: 14, y: 0))
        trianglePath.addLine(to: CGPoint(x: 39, y: 0))
        trianglePath.addLine(to: CGPoint(x: 39, y: 29))
        trianglePath.addLine(to: CGPoint(x: 14, y: 29))
        trianglePath.addLine(to: CGPoint(x: 0, y: 14))
        triangleLayer.path = trianglePath.cgPath
        triangleLayer.strokeColor = UIColor.lightGray.cgColor
        
        let trianglePathBorder = UIBezierPath()
        let triangleLayerBorder = CAShapeLayer()
        trianglePathBorder.move(to: CGPoint(x: 0, y: 15))
        trianglePathBorder.addLine(to: CGPoint(x: 15, y: 0))
        trianglePathBorder.addLine(to: CGPoint(x: 40, y: 0))
        trianglePathBorder.addLine(to: CGPoint(x: 40, y: 30))
        trianglePathBorder.addLine(to: CGPoint(x: 15, y: 30))
        trianglePathBorder.addLine(to: CGPoint(x: 0, y: 15))
        triangleLayerBorder.path = trianglePath.cgPath
        triangleLayerBorder.strokeColor = UIColor.lightGray.cgColor
        triangleLayerBorder.lineWidth = 0.3
        triangleLayerBorder.fillColor = UIColor.clear.cgColor
        
        layer.masksToBounds = true
        layer.addSublayer(triangleLayerBorder)
        layer.mask = triangleLayer
    }
}

extension String {
    func md5Hash() -> String? {
        guard let data = self.data(using: .utf8) else {return nil}
        return Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
    }
}
