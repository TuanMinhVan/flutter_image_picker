//
//  LogUtils.swift
//  flutter_image_picker
//
//  Created by 郑泰捐 on 2019/11/5.
//

import Foundation

func logE(_ log:Any){
    #if DEBUG // 判断是否在测试环境下
        print("\(log)")
    #else
    #endif
}
