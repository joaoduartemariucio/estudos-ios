<?php

$header = base64_encode(json_encode(['alg' => 'ES256', 'kid' => "QTV66FWR67"]));
$claims = base64_encode(json_encode(['iss' => "G625UPV6D7", 'iat' => time()]));

$key = "-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgOpVjzQJxohSNXj+TSoL0av9Zr6FBXWdx2J8JPxqy5QGgCgYIKoZIzj0DAQehRANCAAT9phdj99+j+QzBG7eu+eXE+J3KmDX4dDR6VDHpcF0q3twLAyw9bE1jFXtD2BTmmnjkw7l8v7dvXhhxfr0ed9oY
-----END PRIVATE KEY-----";

openssl_sign("$header.$claims", $signature, $key, 'sha256');

$signed = base64_encode($signature);

echo $signature;
