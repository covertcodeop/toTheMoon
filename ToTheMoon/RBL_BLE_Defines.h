/*
  RBL_BLE_Defines.h
  bleBasics

 Copyright (c) 2012 RedBearLab
 Altered by Zen&ko, LLC. on 2013-10-12. All rights reserved.

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

#ifndef bleBasics_RBL_BLE_Defines_h
#define bleBasics_RBL_BLE_Defines_h

#define BLE_DEVICE_SERVICE_UUID                         "713D0000-503E-4C75-BA94-3148F18D941E"

#define BLE_DEVICE_VENDOR_NAME_UUID                     "713D0001-503E-4C75-BA94-3148F18D941E"

#define RX_FROM_BLE_DEVICE_UUID                         "713D0002-503E-4C75-BA94-3148F18D941E"
#define RX_FROM_BLE_DEVICE_LEN                          20

#define TX_TO_BLE_DEVICE_UUID                           "713D0003-503E-4C75-BA94-3148F18D941E"
#define TX_TO_BLE_DEVICE_LEN                            20

#define BLE_DEVICE_RESET_RX_UUID                        "713D0004-503E-4C75-BA94-3148F18D941E"

#define BLE_DEVICE_LIB_VERSION_UUID                     "713D0005-503E-4C75-BA94-3148F18D941E"

#define BLE_FRAMEWORK_VERSION                           0x0102

#define BLE_NUMBER_OF_CONCURRENT_DEVICES               2

#endif
