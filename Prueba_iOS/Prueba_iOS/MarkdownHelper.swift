//
//  MarkdownHelper.swift
//  Prueba_iOS
//
//  Created by Sergio Daniel L. García on 6/4/18.
//  Copyright © 2018 Humberto Cetina. All rights reserved.
//

import Foundation
import SwiftyMarkdown

protocol MarkdownHelperProtocol : class {
    
    func parseAsSummary(fromString str: String) -> NSAttributedString
    
    func parseFullScreen(fromString str: String) -> NSAttributedString
    
}

class MarkdownHelper {
    
    // MARK: Class members
    
    static let shared: MarkdownHelper = {
        return MarkdownHelper()
    }()
    
    // MARK: Operations
    
    func parseAsSummary(fromString str: String) -> NSAttributedString {
        let md = SwiftyMarkdown(string: str)
        
        md.body.fontName = "Avenir-Light"
        md.body.fontSize = 12
        md.h1.fontName = "Avenir-Medium"
        md.h1.fontSize = 14
        md.h2.fontName = "Avenir-Medium"
        md.h2.fontSize = 12
        
        return md.attributedString()
    }
    
    func parseFullScreen(fromString str: String) -> NSAttributedString {
        let md = SwiftyMarkdown(string: str)
        
        md.body.fontName = "Avenir-Medium"
        md.body.fontSize = 14
        md.h1.fontName = "Avenir-Bold"
        md.h1.fontSize = 16
        md.h2.fontName = "Avenir-Bold"
        md.h2.fontSize = 14
        md.h3.fontName = "Avenir-Bold"
        md.h3.fontSize = 14
        
        return md.attributedString()
    }
    
}
