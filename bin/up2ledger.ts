#!/bin/sh
':' //; exec `command -v deno` run -A "$0" "$@"

import { crypto } from 'https://deno.land/std@0.185.0/crypto/mod.ts';

const ledgerDownloadUrl = 'https://download.live.ledger.com/latest/linux';

const tempFilename = Deno.makeTempFileSync({ prefix: 'u2l', suffix: '.bin' });
const tempFile = Deno.openSync(tempFilename, { create: true, write: true });

const res = await fetch(ledgerDownloadUrl, { redirect: 'follow' });
if (!res.ok) {
    Deno.exit(1);
}

if (!res.body) {
    Deno.exit(2);
}

await res.body.pipeTo(tempFile.writable).finally(() => {
    tempFile.close();
});

const fileToCheck = Deno.openSync(tempFilename, { read: true });
crypto.subtle.digest('SHA-256', fileToCheck).then((hash) => {
    console.log(hash);
});

console.log('Ok!');

// EOF
