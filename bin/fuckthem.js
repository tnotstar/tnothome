// Copyright (c) 2018 Antonio Alvarado Hernández - All rights reserved
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

forReading = 1
forWriting = 2
forAppending = 8

mbInfinite = 0
mbDelayed = 5
mbYes = 6
mbNo = 7
mbAskYesNo = 4 + 32 + 256
mbInformation = 64

vaHiddenYes = "/Silent"

Shell = new ActiveXObject("WScript.Shell")
FileSystem = new ActiveXObject("Scripting.FileSystemObject")
Application = new ActiveXObject("Shell.Application")


/**
 * Remove left and right white spaces from given string instance.
 */
String.prototype.trim || (String.prototype.trim = function() {
    return this.replace(/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g, "")
})

/**
 * Execute given callback function from given array instance.
 */
Array.prototype.forEach || (Array.prototype.forEach = function(callback, thisArg) {
    var self, length = this.length;
    if(arguments.length >= 2)
        self = thisArg
    for(var i = 0; i < length; i++)
        i in this && callback.call(self, this[i], i, this)
})

/**
 * Test if the current process is running with elevated privileges.
 */
isRunningElevated = function() {
    var sysDrive = Shell.Environment("Process")("SystemDrive")
    var testComand = "fsutil dirty query " + sysDrive
    if(0 === Shell.Run(testComand, 0, true))
        return true
    else
        return false
}

/**
 * Read the config file with given filename.
 */
loadConfig = function(filename) {
    var config = {}
    var input = FileSystem.OpenTextFile(filename, forReading, false)

    while(!input.atEndOfStream) {
        var buffer
        var begin, end
        buffer = input.readLine()

        // check for comments
        begin = buffer.indexOf(";")
        if(begin >= 0)
            buffer = buffer.slice(0, begin).trim()
        if(!buffer.length)
            continue

        // check for sections
        begin = buffer.indexOf("[")
        if(begin >= 0) {
            end = buffer.indexOf("]", begin)
            if(end >= 0)
                feature = buffer.slice(begin + 1, end).trim().toLowerCase()
        }

        // check for properties
        begin = buffer.indexOf("=")
        if(begin >= 0) {
            var key = buffer.slice(0, begin).trim().toLowerCase()
            var value = buffer.slice(begin + 1).trim()
            if(!config.hasOwnProperty(feature))
                config[feature] = {}
            config[feature][key] = value
        }
    }
    input.close()
    return config
}

/**
 * Write arguments to the output console.
 */
print = function() {
    if(!WScript.Interactive)
        return
    var asArray = Array.prototype.slice.call(arguments)
    WScript.Echo(asArray.join(" "))
}

/**
 * Write given config object to the output console.
 */
printConfig = function(config) {
    for(var feature in config) {
        print("> config['", feature, "']:")
        for(var key in config[feature]) {
            print(">>\t", key, " = '", config[feature][key], "'")
        }
    }
}

/**
 * Check if the feature config with given properties is currently wrong or right.
 */
verifyIt = function(properties) {
    var path, type, value, remove, current

    // check for mandatory properties
    if(!("path" in properties))
        throw "Invalid feature node"
    path = properties["path"]

    // check for optional properties
    if("type" in properties)
        type = properties["type"]
    if("value" in properties)
        value = properties["value"]
    if("delete" in properties)
        remove = properties["delete"]

    // read values from registry
    try {
        var current = Shell.RegRead(path)
        if(current != value)
            return false
    } catch(e) {
        if(!remove)
            return false
    }
    return true
}

/**
 * Overwrite values of the feature config with given properties.
 */
fuckIt = function(properties) {
    var path, type, value, remove, current

    // check for mandatory properties
    if(!("path" in properties))
        throw "Invalid feature node"
    path = properties["path"]

    // check for optional properties
    if("type" in properties)
        type = properties["type"]
    if("value" in properties)
        value = properties["value"]
    if("delete" in properties)
        remove = properties["delete"]

    // write or delete values from registry
    try {
        if(remove)
            Shell.RegDelete(path)
        else
            Shell.RegWrite(path, value, type)
        return true
    } catch(e) {
        return false
    }
}


// read the input configuration file
var filename = WScript.scriptFullName.replace(".js", ".ini")
var config = loadConfig(filename)

// check for changes in configuration
var todo = []
for(var feature in config) {
    if(!verifyIt(config[feature]))
        todo.push(feature)
}
var length = todo.length
if(!length)
    WScript.Quit()

// ask to apply changes or exit
var letsGo
if(WScript.Arguments.Count() > 0) {
    letsGo = (vaHiddenYes === WScript.Arguments(0))
} else {
    var message = "There are " + length + " wrong features. Could I fuck all them up?"
    var response = Shell.Popup(message, mbInfinite, "Fuck Them All!", mbAskYesNo)
    letsGo = (mbYes == response)
}

// apply changes to given feature configurations
if(letsGo) {
    if(!isRunningElevated()) {
        var cmdline = WScript.ScriptFullName + " " + vaHiddenYes
        Application.ShellExecute(WScript.Fullname, cmdline, null, "RunAs")
        WScript.Quit(0)
    }
    for(var i = 0; i < length; i++) {
        if(!fuckIt(config[todo[i]])) {
            var message = "Something's wrong. Process aborted."
            Shell.Popup(message, mbDelayed, "Fuck Them All!", mbInformation)
            WScript.Quit(-1)
        }
    }
    var message = "Bad features have been fucked them all!"
    Shell.Popup(message, mbDelayed, "Fuck Them All!", mbInformation)
    WScript.Quit(0)
}

// EOF