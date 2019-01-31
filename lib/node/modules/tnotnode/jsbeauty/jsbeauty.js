#!/usr/bin/env node

;(function () { // wrapper in case we're in module_context mode

process.title = "jsbeauty";

var validOptions = {
    'indent_size': true,
    'indent_char': true,
    'preserve_newlines': '',
    'max_preserve_newlines': '',
    'break_chained_methods': '',
    'jslint_happy': '',
    'brace_style': '',
    'keep_array_indentation': '',
    'space_before_conditional': '',
    'unescape_strings': '',
    'input_filename': '',
    'output_filename': '',
};

var options = {};
var args = process.argv.slice(2);
args.forEach(function (value, index, array) {
    if (value.indexOf("--") == 0) {
       value = value.slice(2);
       value = value.replace(/-/g, '_');
       console.log(">>> " + value);
    } else {
        console.log("> [" + index + "]: " + value + ", array = " + array);
    }
});

var beauty = require("./beautify.js");

var input = process.stdin;
input.setEncoding('utf-8');
input.resume();

var buffer = "";
input.on('data', function (chunk) {
    buffer += chunk;
});

var output = process.stdout;
input.on('end', function () {
    output.write(beauty.js_beautify(buffer, options));
});

})()

// EOF