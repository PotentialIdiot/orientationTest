//
//  GameViewController.swift
//  testScalingIssue
//
//  Created by Weng hou Chan on 20/4/18.
//  Copyright © 2018 Lemming. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    internal var lastWidthRatio:Float = 0.0
    internal var lastHeightRatio:Float = 0.1
    internal var widthRatio:Float = 0.0
    internal var heightRatio:Float = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // create and add a camera to the scene
        let listenerCamera = SCNNode()
        listenerCamera.position = SCNVector3Zero
        listenerCamera.camera = SCNCamera()
        
        let listener = SCNNode()
        listener.position = SCNVector3Zero
        listener.addChildNode(listenerCamera)
        scene.rootNode.addChildNode(listener)
        
        // place the camera
        listener.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        
//        ship.scale.x = 2
        ship.isHidden = true
//        scene.background.contents = UIColor.purple
        
        //1. ring path
        let radius: CGFloat = 5
        let ringPath = UIBezierPath()
        ringPath.addArc(withCenter: CGPoint(x: 0.0, y: 0.0), radius: radius*0.875, startAngle: 0.0, endAngle: CGFloat.pi*2, clockwise: true)
        let ring = SCNShape(path: ringPath, extrusionDepth: 0.1)
//        let displayNode = SCNNode()
//        displayNode.geometry = ring
//        displayNode.eulerAngles.x = -1.5708
//        scene.rootNode.addChildNode(displayNode)
        
        //2.
        //// Outer Circle Drawing
        let outerCirclePath = UIBezierPath()
        outerCirclePath.addArc(withCenter: CGPoint(x: 0.0, y: 0.0), radius: radius, startAngle: 0.0, endAngle: CGFloat.pi*2, clockwise: true)
        outerCirclePath.addLine(to: CGPoint(x: 0.0, y: 0.0))
        outerCirclePath.close()
        
        
        //// InnerCircle Drawing
        let innerCirclePath = UIBezierPath()
        innerCirclePath.addArc(withCenter: CGPoint(x: 0.0, y: 0.0), radius: radius*0.875, startAngle: 0.0, endAngle: CGFloat.pi*2, clockwise: true)
        innerCirclePath.addLine(to: CGPoint(x: 1.0, y: 1.0))
        innerCirclePath.close()
        
        // Clip out the innerCirclePath
        outerCirclePath.append(innerCirclePath)
        outerCirclePath.addClip()
        outerCirclePath.usesEvenOddFillRule = true;

        let ring2 = SCNShape(path: drawHollowCircle(rect: CGRect(x: 0, y: 0, width: 10, height: 10)), extrusionDepth: 0.1)
        
        let ring3 = SCNTorus(ringRadius: 3, pipeRadius: 1)
        ring3.firstMaterial?.diffuse.contents = UIImage(named: "uranus__rings_by_jcpag2010-d98olap")
//        ring3.firstMaterial?.diffuse.wrapT = .mirror
//        ring3.firstMaterial?.diffuse.wrapS = .mirror
//        ring3.firstMaterial?.isDoubleSided = true
        
        let tube = SCNTube(innerRadius: 1, outerRadius: 3, height: 0.1)
        tube.firstMaterial?.diffuse.contents = UIImage(named: "uranus__rings_by_jcpag2010-d98olap")
        
        // front side
        let displayNode = SCNNode()
        displayNode.geometry = tube
//        displayNode.eulerAngles.x = -3.142
        displayNode.scale.y = 0.01
        
        // for other side
        let mirrorNode = SCNNode()
        mirrorNode.geometry = ring3
        mirrorNode.position.y = -0.04
        mirrorNode.eulerAngles.x = -3.142
//        displayNode.addChildNode(mirrorNode)
//        scene.rootNode.addChildNode(displayNode)
        
        
        let ringParticles = SCNParticleSystem(named: "RingParticles", inDirectory: nil)!
        ringParticles.emitterShape = ring3
        let particleNode = SCNNode()
        particleNode.scale.y = 0.1
//        particleNode.eulerAngles.x = -1.5708
//        scene.rootNode.addChildNode(particleNode)
//        particleNode.addParticleSystem(ringParticles)
        
        // animate the 3d object
//        ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
//        ship.position = SCNVector3Make(0, 0, 30)
//
//        let testNode = SCNNode()
//        testNode.position = SCNVector3Make(10, 0, 0)
//        ship.addChildNode(testNode)
//
//        print("ship eu a - \(ship.eulerAngles)")
//        print("testnode eu a - \(testNode.eulerAngles)")
//        listener.constraints = [SCNLookAtConstraint(target: ship)]
//        let magnify = SCNAction.move(to: SCNVector3Make(5, 0, 15), duration: 2)
////        listener.runAction(magnify, completionHandler: {
//
////        })
//        listener.position = SCNVector3Make(5, 0, 15)
        
        //1. boxes
        let origin = SCNNode()
        let originBox = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        origin.geometry = originBox
        origin.position = SCNVector3Zero
        scene.rootNode.addChildNode(origin)
        
        let firstNode = SCNNode()
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        firstNode.geometry = box
        firstNode.geometry?.materials.first?.diffuse.contents = UIColor.red
        let secondNode = SCNNode()
        let box2 = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        secondNode.geometry = box2
        firstNode.position = SCNVector3Make(15, 15, -25)//SCNVector3Make(0, 5, -25)
        secondNode.position = SCNVector3Make(15, 15, -25)
        
        scene.rootNode.addChildNode(firstNode)
        scene.rootNode.addChildNode(secondNode)
        
        //2. camera
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3Make(0, 0, 0)
        let cnBox = SCNBox(width: 5, height: 5, length: 5, chamferRadius: 0)
        cameraNode.geometry = cnBox
        scene.rootNode.addChildNode(cameraNode)
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        scnView.pointOfView = cameraNode
//        cameraNode.position = SCNVector3Make(0, 0, -10)
                cameraNode.constraints = [SCNLookAtConstraint(target: firstNode)]
        //        cameraNode.constraints = [SCNLookAtConstraint(target: secondNode)]
        let x = firstNode.position.x * 0.55
        let y = firstNode.position.y * 0.55
        let z = firstNode.position.z * 0.55
        let xyz = SCNVector3Make(x, y, z)

        let magnify = SCNAction.move(to: xyz, duration: 2.0)
        cameraNode.runAction(magnify, completionHandler: {
            print("old cam pos - \(cameraNode.worldPosition)")
            let orbit = SCNNode()
            orbit.name = "orbit"
            orbit.position = firstNode.worldPosition
            
            orbit.constraints = [SCNLookAtConstraint(target: cameraNode)]
            
            let newCam = SCNNode()
            let camera = SCNCamera()
            newCam.camera = camera
//            print("xyz - \(xyz)")
//            newCam.constraints = [SCNLookAtConstraint(target: firstNode)]
            let x2 = cameraNode.position.x - firstNode.position.x
            let y2 = cameraNode.position.y - firstNode.position.y
            let z2 = cameraNode.position.z - firstNode.position.z
            let xyz2 = SCNVector3Make(x2, y2, z2)
            newCam.position.z = 8//scnView.scene!.rootNode.convertPosition(cameraNode.position, to: orbit) // xyz2
            orbit.constraints = []
            orbit.eulerAngles = SCNVector3Zero

            print("new cam pos - \(newCam.position)")
            orbit.addChildNode(newCam)
            scnView.scene?.rootNode.addChildNode(orbit)
            scnView.pointOfView = newCam
            
            DispatchQueue.main.async {
                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.bodyPan(_:)))
                panGesture.maximumNumberOfTouches = 1
                panGesture.minimumNumberOfTouches = 1
                scnView.addGestureRecognizer(panGesture)
            }
        })

        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = false
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        scnView.addGestureRecognizer(tapGesture)
    }
    
    @objc func bodyPan(_ gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: gesture.view)
        widthRatio = Float(translation.x) / Float(gesture.view!.frame.size.width) + lastWidthRatio
        heightRatio = Float(translation.y) / Float(gesture.view!.frame.size.height/2) + lastHeightRatio
        let scnView = self.view as! SCNView
        let testOrbit = scnView.scene!.rootNode.childNode(withName: "orbit", recursively: true)!
        testOrbit.eulerAngles.y = -2*Float.pi * widthRatio
        testOrbit.eulerAngles.x = -Float.pi * heightRatio
        if gesture.state == .ended{
            lastWidthRatio = widthRatio
            lastHeightRatio = heightRatio
        }
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    func drawHollowCircle(rect: CGRect, startAngle: CGFloat = 1, endAngle: CGFloat = 360, outerRingProportion: CGFloat = 1, innerRingProportion: CGFloat = 0.5) -> UIBezierPath {
        
        //// Variable Declarations
        let startAngleCalced: CGFloat = -startAngle + 270
        let endAngleCalced: CGFloat = -endAngle + 270
        let innerRingDiameter: CGFloat = rect.size.width * innerRingProportion
        let innerRingOffset: CGFloat = 0.5 * (rect.size.width - innerRingDiameter)
        let innerRingRect = CGRect(x: innerRingOffset, y: innerRingOffset, width: innerRingDiameter, height: innerRingDiameter)
        let outerRingDiameter: CGFloat = rect.size.width * outerRingProportion
        let outerRingOffset: CGFloat = 0.5 * (rect.size.width - outerRingDiameter)
        let outerRingRect = CGRect(x: outerRingOffset, y: outerRingOffset, width: outerRingDiameter, height: outerRingDiameter)

        //// Outer Circle Drawing
        let outerCircleRect = outerRingRect
        let outerCirclePath = UIBezierPath()
        outerCirclePath.addArc(withCenter: CGPoint(x: outerCircleRect.midX, y: outerCircleRect.midY), radius: outerCircleRect.width / 2, startAngle: -startAngleCalced * CGFloat(M_PI)/180, endAngle: -endAngleCalced * CGFloat(M_PI)/180, clockwise: true)
        outerCirclePath.addLine(to: CGPoint(x: outerCircleRect.midX, y: outerCircleRect.midY))
        outerCirclePath.close()
        
        
        //// InnerCircle Drawing
        let innerCircleRect = innerRingRect
        let innerCirclePath = UIBezierPath()
        innerCirclePath.addArc(withCenter: CGPoint(x: innerCircleRect.midX, y: innerCircleRect.midY), radius: innerCircleRect.width / 2, startAngle: -startAngleCalced * CGFloat(M_PI)/180, endAngle: -endAngleCalced * CGFloat(M_PI)/180, clockwise: true)
        innerCirclePath.addLine(to: CGPoint(x: innerCircleRect.midX, y: innerCircleRect.midY))
        innerCirclePath.close()
        
        // Clip out the innerCirclePath
        outerCirclePath.append(innerCirclePath)
        outerCirclePath.addClip()
        outerCirclePath.usesEvenOddFillRule = true;
        
        return outerCirclePath
    }

}
