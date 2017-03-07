//
//  WebViewController.swift
//  AlexGoogleMaps
//
//  Created by Aditya Narayan on 3/6/17.
//  Copyright © 2017 Aditya Narayan. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView? = nil
    
    var selectedMarker: CoolMarker? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let theConfig = WKWebViewConfiguration()
        self.webView = WKWebView(frame: self.view.frame, configuration: theConfig)
        
        let url = self.selectedMarker?.url
        let request = URLRequest(url: url!)
        
        _ = self.webView?.load(request)
        self.view.addSubview(self.webView!)
        
        //add toolbar and back button
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/9)
        let backButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.buttonPressed))
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        let buttons = [backButton, fixedSpace]
        
        toolBar.setItems(buttons, animated: false)
        self.webView?.addSubview(toolBar)

        
    }

    func buttonPressed(){
        
        self.dismiss(animated: true) {}
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
