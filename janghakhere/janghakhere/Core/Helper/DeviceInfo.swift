//
//  DeviceInfo.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/17/24.
//

import SwiftUI

struct DeviceInfo {
    static func getDeviceScreenHeight() -> CGFloat {
        let screenSize = UIScreen.main.bounds
        return screenSize.height
    }
    
    static func getDeviceScreenWidth() -> CGFloat {
        let screenSize = UIScreen.main.bounds
        return screenSize.width
    }
}
