//
//  ViewController.swift
//  RampUp
//
//  Created by Chris Mercer on 26/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class RampPlacerViewController: UIViewController, ARSCNViewDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var buttons: UIStackView!
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    
    var selectedRampName: String!
    var selectedRamp: SCNNode!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        
        let rotateGestureRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        let upGestureRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        let downGestureRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        rotateGestureRecogniser.minimumPressDuration = 0.1
        upGestureRecogniser.minimumPressDuration = 0.1
        downGestureRecogniser.minimumPressDuration = 0.1
        
        rotateButton.addGestureRecognizer(rotateGestureRecogniser)
        upButton.addGestureRecognizer(upGestureRecogniser)
        downButton.addGestureRecognizer(downGestureRecogniser)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    
    @IBAction func rampIconPressed(_ sender: UIButton) {
        let rampPicker = RampPictureViewController(size: CGSize(width: 250, height: 500))
        rampPicker.modalPresentationStyle = .popover
        rampPicker.popoverPresentationController?.delegate = self
        rampPicker.rampPlacerVC = self
        present(rampPicker, animated: true, completion: nil)
        rampPicker.popoverPresentationController?.sourceView = sender
        rampPicker.popoverPresentationController?.sourceRect = sender.bounds
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none //HAVE TO DO THIS or it'll break
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let selectedObject = selectedRampName else { return }
        guard let touch = touches.first else { return }
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [.featurePoint])
        
        guard let hitFeature = results.last else {
            print("couldn't find an object")
            return
        }
        
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        
        let object = SCNScene(named: "art.scnassets/\(selectedObject).dae")
        let node = object?.rootNode.childNode(withName: selectedObject, recursively: true)
        let scale = ScaleFor.item(obj: selectedObject)
        node?.scale = SCNVector3Make(scale, scale, scale)
        node?.position = SCNVector3Make(hitPosition.x, hitPosition.y, hitPosition.z)
        selectedRamp = node!
        sceneView.scene.rootNode.addChildNode(node!)
        buttons.isHidden = false
    }
    
    func onRampSelected(_ rampName: String) {
        selectedRampName = rampName
    }
    
    @IBAction func onRemovePressed(_ sender: Any) {
        if let ramp = selectedRamp {
            ramp.removeFromParentNode()
            selectedRamp = nil
            selectedRampName = ""
            buttons.isHidden = true
        }
    }
    
    @objc func onLongPress(gesture: UILongPressGestureRecognizer) {
        if let ramp = selectedRamp {
            if gesture.state == .ended {
                ramp.removeAllActions()
            } else if gesture.state == .began {
                if gesture.view === rotateButton {
                    let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.08 * Double.pi), z: 0, duration: 0.1))
                    ramp.runAction(rotate)
                } else if gesture.view === upButton {
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0.08, z: 0, duration: 0.1))
                    ramp.runAction(move)
                } else if gesture.view === downButton {
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: -0.08, z: 0, duration: 0.1))
                    ramp.runAction(move)
                }
            }
        }
    }
    
}
