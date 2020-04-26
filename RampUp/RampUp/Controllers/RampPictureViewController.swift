//
//  RampPictureViewController.swift
//  RampUp
//
//  Created by Chris Mercer on 26/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import UIKit
import SceneKit

class RampPictureViewController: UIViewController, UIGestureRecognizerDelegate {

    var sceneView: SCNView!
    var size: CGSize!
    weak var rampPlacerVC: RampPlacerViewController!
    
    init(size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.size = size
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = CGRect(origin: CGPoint.zero, size: size)
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.insertSubview(sceneView, at: 0)
        
        let scene = SCNScene(named: "art.scnassets/ramps.scn")!
        sceneView.scene = scene
        
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene.rootNode.camera = camera
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tap)
        
        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.01 * Double.pi), z: 0, duration: 0.1))
        
        let pipe = SCNScene(named: "art.scnassets/pipe.dae")
        let pipeNode = pipe?.rootNode.childNode(withName: "pipe", recursively: true)
        pipeNode?.runAction(rotate)
        pipeNode?.scale = SCNVector3Make(0.0012, 0.0012, 0.0012)
        pipeNode?.position = SCNVector3Make(0.1, 0.8, 0)
        scene.rootNode.addChildNode(pipeNode!)
        
        let pyramid = SCNScene(named: "art.scnassets/pyramid.dae")
        let pyramidNode = pyramid?.rootNode.childNode(withName: "pyramid", recursively: true)
        pyramidNode?.runAction(rotate)
        pyramidNode?.scale = SCNVector3Make(0.0032, 0.0032, 0.0032)
        pyramidNode?.position = SCNVector3Make(0.1, -0.1, 0)
        scene.rootNode.addChildNode(pyramidNode!)
        
        let quarter = SCNScene(named: "art.scnassets/quarter.dae")
        let quarterNode = quarter?.rootNode.childNode(withName: "quarter", recursively: true)
        quarterNode?.runAction(rotate)
        quarterNode?.scale = SCNVector3Make(0.0032, 0.0032, 0.0032)
        quarterNode?.position = SCNVector3Make(0.1, -1.3, 0)
        scene.rootNode.addChildNode(quarterNode!)
        
        preferredContentSize = size
//        view.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        view.layer.borderWidth = 3.0
    }
    
    @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        let p = gestureRecognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(p, options: [:])
        if hitResults.count > 0 {
            let node = hitResults[0].node
            print(node.name!)
            rampPlacerVC.onRampSelected(node.name!)
        }
        dismiss(animated: true, completion: nil)
    }
}
