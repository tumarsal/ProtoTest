//
//  DocumentViewController.swift
//  TasksProto
//
//  Created by tumarsal on 23.07.2021.
//

import Foundation
import UIKit
import QuickLook
class DocumentViewController : UIViewController {
    internal var loadedDocument: DocumentModel?
    private var previewViewController = QLPreviewController()
    private var documentInteractionController = UIDocumentInteractionController()
    
}
extension DocumentViewController: QLPreviewControllerDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        showPreviewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewViewController.view.frame.size = view.frame.size
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Configuration
    
    private func configure() {
        title = loadedDocument?.name ?? "Документ"
    }
    
    // MARK: - State
    func add(child: UIViewController, superview: UIView) {
        child.view.frame = superview.bounds
        child.willMove(toParent: self)
        self.addChild(child)
        superview.addSubview(child.view)
        child.didMove(toParent: self)
    }
    private func showPreviewController() {
        add(child: previewViewController, superview: view)
        previewViewController.view.alpha = 1.0
        previewViewController.view.frame.size = view.frame.size
        previewViewController.dataSource = self
        previewViewController.reloadData()
    }
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        guard let _ = self.loadedDocument else {
            return 0
        }
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard let loadedIssueDocument = self.loadedDocument else {
            return NSURL()
        }
        let filename = loadedIssueDocument.filename
        print("URLs: \(listFilesFromDocumentsFolder())")
        guard let fileUrl = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
            guard let fileUrl2 = Bundle.main.url(forResource: "doc1.pdf", withExtension: nil)
                else {
                    fatalError("Couldn't find \(filename) in main bundle.")
            }
            return fileUrl2 as QLPreviewItem
        }
        return fileUrl as QLPreviewItem
    }
}
extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}
func listFilesFromDocumentsFolder() -> [String]?
{
    let fileMngr = FileManager.default;

    // Full path to documents directory
    let docs = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0].path

    // List all contents of directory and return as [String] OR nil if failed
    return try? fileMngr.contentsOfDirectory(atPath:docs)
}
