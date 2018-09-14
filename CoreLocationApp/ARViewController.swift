//
//  ARViewController.swift
//  CoreLocationApp
//
//  Created by Neil Sood on 9/13/18.
//  Copyright © 2018 Neil Sood. All rights reserved.
//

import UIKit
import ARKit
import CoreLocation
import SceneKit

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var arViewOutlet: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arViewOutlet.delegate = self
        arViewOutlet.showsStatistics = false
        arViewOutlet.scene = SCNScene()
        let circleNode = createSphereNode(with: 0.2, color: .blue)
        circleNode.position = SCNVector3(0, 0, -1) // 1 meter in front of camera
        arViewOutlet.scene.rootNode.addChildNode(circleNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        arViewOutlet.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arViewOutlet.session.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createSphereNode(with radius: CGFloat, color: UIColor) -> SCNNode {
        let geometry = SCNSphere(radius: radius)
        geometry.firstMaterial?.diffuse.contents = color
        let sphereNode = SCNNode(geometry: geometry)
        return sphereNode
    }
}
