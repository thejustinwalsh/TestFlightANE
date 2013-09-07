# TestFlight iOS Native Extension
Adobe Air Native Extension (ANE) for the TestFlight SDK on iOS

## About
This extension provides a wrapper around the TestFlight SDK. The goal is to keep the API as close to the Objective-C TestFlight API as possible.

## Building
The native extension is using ruby's rake for it's build system and therefore requires ruby 1.9.3, this is installed by default on OS X Lion.  Additionally, you must have Xcode and the iOS SDK's installed on your system.

To build simply type `rake build` into your terminal from within the root directory of the native extension.  If this is your first time building the build system will generate the file `config/build.yml` and prompt you to edit the file for your system.  The relevant changes are the path to your Adobe Air SDK and what version of the iOS SDK you are using.

After editing your `config/build.yml` file, simply type `rake build` again.  If all goes well you will see the `TestFlight.ane` file sitting in your `bin` directory. 

## Usage
The api is a single class called TestFlight in the `com.thejustinwalsh.ane` package. The class consists entirely of static methods that wrap the TestFlight SDK.

Call `TestFlight.takeOff("app_id")` with your application token to initialize TestFlight. You should ensure that you call the `takeOff` method after the `NativeApplication` signals the `ACTIVATE` event, calling `takeOff` too soon will result in a bad time. If this is a debug build you may want to call `TestFlight.setDeviceIdentifier()` before calling `TestFlight.takeOff` so that your sessions are bound to the proper user.

## Considerations
I am not certain if Apple will approve your ANE using this SDK with the included deprecated `[[UIDevice currentDevice] uniqueIdentifier]]` call. If you would like to use this TestFlight ANE in an App Store build, it is advised that you comment out the code in `TestFlight.m` that uses the deprecated function call.

## Donating
Support this project and [others by thejustinwalsh][gittip-thejustinwalsh] via [gittip][gittip-thejustinwalsh].

[![Support via Gittip][gittip-badge]][gittip-thejustinwalsh]

[gittip-badge]: https://rawgithub.com/twolfson/gittip-badge/master/dist/gittip.png
[gittip-thejustinwalsh]: https://www.gittip.com/thejustinwalsh/

## License
TestFlightANE is license under a permissive MIT source license. Fork well my friends.

	Copyright (c) 2012 Justin Walsh, http://thejustinwalsh.com/

	Permission is hereby granted, free of charge, to any person obtaining
	a copy of this software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be
	included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
	OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
	WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
