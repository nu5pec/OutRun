//
//  [FILENAME]
//
//  OutRun
//  Copyright (C) 2020 Tim Fraedrich <timfraedrich@icloud.com>
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

import Foundation

/**
 This function can be used to query a value through a closure which will be performed on a specific thread to ensure thread safety without needing to perform a the whole operation a said thread.
 
 Usage Example:
 ```
 var property: PropertyType? {
     threadSafeSyncReturn { () -> PropertyType? in
         // Note: this would be a property which can only be accessed on a specfic thread
         return self._property.value
     }
 }
 ```
 Note that you can return an object of any data type with this method, for using Optionals just extend the type you want to return with a question mark.
 
 - warning: Since this method is synchronous, running it can lead to performance issues.
 - parameter thread: the DispatchQueue the closure is supposed to be performed on, by standard the main queue
 - parameter closure: the closure being performed to return the value
 - returns: an object of the data type clarified by the return of the closure
 */
public func threadSafeSyncReturn<ReturnType>(thread: DispatchQueue = .main, _ closure: @escaping () -> ReturnType) -> ReturnType {
    
    var returnValue: ReturnType?
    
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    
    thread.async {
        returnValue = closure()
    }
    
    dispatchGroup.wait()
    
    return returnValue!
    
}
