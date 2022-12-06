//
//  DetailViewController.swift
//  project7
//
//  Created by Justine kenji Dela Cruz on 05/12/2022.
//

import UIKit
import WebKit
class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }
        let html = """
        <html>
        <head>
        <meta name = "viewport" content = "width=device-width, intial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        \(detailItem.body)
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }

}
