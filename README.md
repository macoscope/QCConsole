QCConsole
==========


QCConsole is a [Quartz Composer](http://en.wikipedia.org/wiki/Quartz_Composer) plugin which prints out all values received by its input port in the dedicated console window.
It aims to replace all the "Instructions"-based techniques used in composition development for value tracing.

Every logged message contains a received value (with a proper type detection), timestamp, and extra arguments captured during composition execution (e.g. mouse location, received event, etc). 


![Console Window](https://github.com/macoscope/QCConsole/raw/master/Assets/Screenshots/QuartzComposerWithQCConsole.png "Console Window")


## Motivation

Us computer geeks are fairly familiar with the concept of logging or tracing variables during the development process. 
This established technique also works well in composition development, unfortunately, Quartz Composer does not have a built-in patch for this particular purpose.

The most popular workaround is to use the "Instructions" patch to print out a traced value.
This trick is as simple as it is limited - it's easy to dump a number or a string, but the process gets far too complex when you want to use it to inspect a structure...

To address this problem I created this small plugin.


## Installation

Download and place the plugin file _QCConsole.plugin_ in the `"/Users/_[YOUR_USERNAME]_/Library/Graphics/Quartz Composer Patches/"` folder  (create the folder if it doesn't already exist).

[QCConsole v1.0.0](https://github.com/macoscope/QCConsole/raw/master/Builds/QCConsole.plugin-v1.0.0.zip)

**TIP:** From Mountain Lion onwards, the user's library folder (`~/Library/`) is hidden by default, since the majority of users simply won’t need to access it. To reveal it [use this hint.](http://mac.tutsplus.com/tutorials/productivity/how-to-reveal-your-library-folder-in-lion-or-mountain-lion/)


## Usage

Add a _”Print to Console"_ patch to your composition and connect its input port with an interesting value and voilà...
Run your composition, the plugin will open the console window displaying all of the received values in one table.
You can watch an example here https://vimeo.com/83716959

**TIP:** you can use as many patch instances as you need (it's useful in complicated macros) - all the data will land in the same console window.

**TIP:** if you're using a multi-monitor setup, it might be more convenient to move the console window to one screen while watching the composition on the other.


## Contact

Any suggestions or improvements are more than welcome. Feel free to contact me at daniel@macoscope.com or [@dannyow](http://twitter.com/dannyow)


## Credits

* Kineme.net team for [QCPatchXcodeTemplate](https://github.com/kineme/QCPatchXcodeTemplate) and Quartz Composer unofficial API, a.k.a. SkankySDK.
* Jerome Krinock for [the geometry category](https://github.com/jerrykrinock/CategoriesObjC/) for NSAttributedString  


## License

Copyright 2014 Macoscope, sp z o.o.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.