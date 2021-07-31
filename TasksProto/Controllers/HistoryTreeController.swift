//
//  HistoryTreeController.swift
//  TasksProto
//
//  Created by tumarsal on 27.07.2021.
//

import Foundation
import UIKit
import SwiftyJSON

class CustomUITableViewCell: UITableViewCell
{
    override func layoutSubviews() {
        super.layoutSubviews();
        
        guard var imageFrame = imageView?.frame else { return }
        
        let offset = CGFloat(indentationLevel) * indentationWidth
        imageFrame.origin.x += offset
        imageView?.frame = imageFrame
    }
}



class HistoryTreeController: UIViewController {
    
    @IBOutlet weak var treeView: LNZTreeView!
   
    //var task:TaskModel!
    var root:[TaskAppointmentModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        treeView.register(CustomUITableViewCell.self, forCellReuseIdentifier: "cell")

        treeView.tableViewRowAnimation = .right
        treeView.keyboardDismissMode = .none
        //generateRandomNodes()
        treeView.delegate = self
        treeView.dataSource = self
        
        treeView.resetTree()
    }
    
    func generateRandomNodes() {
        let depth = 3
        let rootSize = 30
        
        var root: [TaskAppointmentModel]!
        
        var lastLevelNodes: [TaskAppointmentModel]?
        for i in 0..<depth {
            guard let lastNodes = lastLevelNodes else {
                root = generateNodes(rootSize, depthLevel: i)
                lastLevelNodes = root
                continue
            }
            
            var thisDepthLevelNodes = [TaskAppointmentModel]()
            for node in lastNodes {
                guard arc4random()%2 == 1 else { continue }
                let childrenNumber = Int(arc4random()%20 + 1)
                let children = generateNodes(childrenNumber, depthLevel: i)
                node.children = children
                thisDepthLevelNodes += children
            }
            lastLevelNodes = thisDepthLevelNodes
        }
        
        self.root = root
    }
     func generateNodes(_ numberOfNodes: Int, depthLevel: Int) -> [TaskAppointmentModel] {
         let nodes = Array(0..<numberOfNodes).map { i -> TaskAppointmentModel in
            
             return TaskAppointmentModel(withIdentifier: "\(arc4random()%UInt32.max)")
         }
         
         return nodes
     }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HistoryTreeController: LNZTreeViewDataSource {
    func numberOfSections(in treeView: LNZTreeView) -> Int {
        return 1
    }
    
    func treeView(_ treeView: LNZTreeView, numberOfRowsInSection section: Int, forParentNode parentNode: TreeNodeProtocol?) -> Int {
        guard let parent = parentNode as? TaskAppointmentModel else {
            return root.count
        }
        
        return parent.children?.count ?? 0
    }
    
    func treeView(_ treeView: LNZTreeView, nodeForRowAt indexPath: IndexPath, forParentNode parentNode: TreeNodeProtocol?) -> TreeNodeProtocol {
        guard let parent = parentNode as? TaskAppointmentModel else {
            return root[indexPath.row]
        }

        return parent.children![indexPath.row]
    }
    
    func treeView(_ treeView: LNZTreeView, cellForRowAt indexPath: IndexPath, forParentNode parentNode: TreeNodeProtocol?, isExpanded: Bool) -> UITableViewCell {
        
        let node: TaskAppointmentModel
        if let parent = parentNode as? TaskAppointmentModel {
            node = parent.children![indexPath.row]
        } else {
            node = root[indexPath.row]
        }
        
        let cell = treeView.dequeueReusableCell(withIdentifier: "cell", for: node, inSection: indexPath.section)

        if node.isExpandable {
            if isExpanded {
                cell.imageView?.image = #imageLiteral(resourceName: "index_folder_indicator_open")
            } else {
                cell.imageView?.image = #imageLiteral(resourceName: "index_folder_indicator")
            }
        } else {
            cell.imageView?.image = nil
        }
        
        cell.textLabel?.text = "\(node.text) - \(node.statusText())"
        cell.textLabel?.numberOfLines = 2;
        cell.textLabel?.sizeToFit()
       // cell.detailTextLabel?.text = node.date.format("dd.MM.YYYY")
        return cell
    }
}

extension HistoryTreeController: LNZTreeViewDelegate {
    func treeView(_ treeView: LNZTreeView, heightForNodeAt indexPath: IndexPath, forParentNode parentNode: TreeNodeProtocol?) -> CGFloat {
        return 60
    }
}
