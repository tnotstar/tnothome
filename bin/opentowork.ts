#!/bin/sh
':' //; exec `command -v deno` run --allow-net "$0" "$@"

// Copyright (c) 2023, Antonio Alvarado Hernández <tnotstar@gmail.com>

const payload = [ 73, 39, 109, 32, 110, 111, 116, 32, 35, 111, 112, 101, 110, 84, 111, 87, 111, 114, 107, 33, 33 ]

const msg = await fetch('https://httpbin.org/post', {
    method: 'POST',
    body: JSON.stringify(payload),
}).then(res => res.json());

console.log(String.fromCharCode(...msg.json));

