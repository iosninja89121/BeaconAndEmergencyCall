


// This Area for Common definations and Delegate Mathods
import Foundation
import CoreBluetooth
import UIKit


let TRANSFER_SERVICE_UUID = "0AA243D0-A76F-5C88-BDCB-BAAE7698CAE9"
let TRANSFER_CHARACTERISTIC_UUID = "0AA243D0-A76F-5C88-BDCB-BAAE7698CAE9"
let NOTIFY_MTU = 20

let transferServiceUUID = CBUUID(string: TRANSFER_SERVICE_UUID)
let transferCharacteristicUUID = CBUUID(string: TRANSFER_CHARACTERISTIC_UUID)

//Default Alert Class, can be used any where in the app.
func alert(title: String, message: String)
{
let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
}
