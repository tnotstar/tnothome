// Copyright 2013 - 2026, Antonio Alvarado <tnotstar+copyright@gmail.com>

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
    if (arguments.length >= 2)
        self = thisArg
    for (var i = 0; i < length; i++)
        i in this && callback.call(self, this[i], i, this)
})

/**
 * Test if the current process is running with elevated privileges.
 */
isRunningElevated = function() {
    var sysDrive = Shell.Environment("Process")("SystemDrive")
    var testComand = "fsutil dirty query " + sysDrive
    if (0 === Shell.Run(testComand, 0, true))
        return true
    else
        return false
}

/**
 * Read the config file with given filename.
 */
loadConfig = function(filename) {
    var sectionName

    var config = {}
    var input = FileSystem.OpenTextFile(filename, forReading, false)

    while (!input.atEndOfStream) {
        var buffer = input.readLine()
        var begin, end

        // check for comments
        begin = buffer.indexOf(";")
        if (begin >= 0)
            buffer = buffer.slice(0, begin).trim()
        if (!buffer.length)
            continue

        // check for sections
        begin = buffer.indexOf("[")
        if (begin >= 0) {
            end = buffer.indexOf("]", begin)
            if (end >= 0)
                sectionName = buffer.slice(begin + 1, end).trim().toLowerCase()
        }

        // check for properties
        begin = buffer.indexOf("=")
        if (begin >= 0) {
            var key = buffer.slice(0, begin).trim().toLowerCase()
            var value = buffer.slice(begin + 1).trim()
            if (!config.hasOwnProperty(sectionName))
                config[sectionName] = { name: sectionName }
            config[sectionName][key] = value
        }
    }
    input.close()
    return config
}

/**
 * Write arguments to the output console.
 */
print = function() {
    if (!WScript.Interactive)
        return
    var asArray = Array.prototype.slice.call(arguments)
    WScript.Echo(asArray.join(""))
}

/**
 * Write given config object to the output console.
 */
printConfig = function(config) {
    for (var feature in config) {
        print("> config['", feature, "']:")
        for (var key in config[feature]) {
            print(">>\t", key, " = '", config[feature][key], "'")
        }
    }
}

/**
 * Check if the feature config with given properties is currently wrong or right.
 */
verifyIt = function(properties) {
    var name, path, type, value, remove, current

    // check for mandatory properties
    if (!("name" in properties))
        throw "Invalid `name` for unknown feature"
    name = properties["name"]

    if (!("path" in properties))
        throw "Invalid `path` for feature: " + properties["name"]
    path = properties["path"]

    // check for optional properties
    if ("type" in properties)
        type = properties["type"]
    if ("value" in properties)
        value = properties["value"]
    if ("delete" in properties)
        remove = properties["delete"]

    // read values from the registry
    try {
        if(value != Shell.RegRead(path))
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
    var name, path, type, value, remove

    // retrieve properties
    name = properties["name"]
    path = properties["path"]
    if ("type" in properties)
        type = properties["type"]
    if ("value" in properties)
        value = properties["value"]
    if ("delete" in properties)
        remove = properties["delete"]

    // write or delete values to the registry
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
var issues = 0, todo = {}
for (var feature in config) {
    try {
        if (!verifyIt(config[feature])) {
            todo[feature] = config[feature]
            issues++
        }
    } catch (e) {
        var message = "Something's wrong with feature: '" + feature + ":" + e
        Shell.Popup(message, mbDelayed, "Fuck Them All!", mbInformation)
        WScript.Quit(-1)
    }
}
if (0 == issues)
    WScript.Quit(0)

// check command line arguments
var runSilent = (WScript.Arguments.Count() > 0) && (vaHiddenYes === WScript.Arguments(0))

// ask to apply changes or exit
var letsGo = runSilent
if (!runSilent) {
    var message = "There are " + issues + " wrong features. Could I fuck all them up?"
    var response = Shell.Popup(message, mbInfinite, "Fuck Them All!", mbAskYesNo)
    letsGo = (mbYes == response)
}
if (!letsGo)
    WScript.Quit(0)

// check if we are running as an elevated user
if (!isRunningElevated()) {
    var cmdline = WScript.ScriptFullName + " " + vaHiddenYes
    Application.ShellExecute(WScript.Fullname, cmdline, null, "RunAs")
    WScript.Quit(0)
}

// apply changes to given feature configurations
for (var feature in todo) {
    if (!fuckIt(todo[feature])) {
        var message = "Something's wrong with feature: '" + feature + "'. Aborted."
        Shell.Popup(message, mbDelayed, "Fuck Them All!", mbInformation)
        WScript.Quit(-1)
    }
}
var updateCmdline = "rundll32.exe user32.dll, UpdatePerUserSystemParameters"
if (0 !== Shell.Run(updateCmdline, 0, true)) {
    var message = "Something's wrong. Updating params aborted."
    Shell.Popup(message, mbDelayed, "Fuck Them All!", mbInformation)
    WScript.Quit(-1)
}
var restartShell = !runSilent
if (!runSilent) {
    var message = "Bad features have been fucked them all! Restart the shell?"
    if (mbYes === Shell.Popup(message, mbInfinite, "Fuck Them All!", mbAskYesNo))
        mbYes === response
    restartShell = (mbYes === response)
}
if (!restartShell) 
    WScript.Quit(0)

var restartCmdline = "taskkill.exe /F /IM explorer.exe"
if (0 !== Shell.Run(restartCmdline, 0, true)) {
    var message = "Something's wrong. Restarting shell aborted."
    Shell.Popup(message, mbDelayed, "Fuck Them All!", mbInformation)
    WScript.Quit(-1)
}
WScript.Quit(Shell.Run("explorer.exe", 0, true))

// EOF