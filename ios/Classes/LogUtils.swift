

import Foundation

func logE(_ log:Any){
    #if DEBUG 
        print("\(log)")
    #else
    #endif
}
