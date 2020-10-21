#!/bin/sh

curl -v -d '{"id_porteiro": 5,"desc_porteiro": "Portao Social","status_chamada": 0}' --http2 --cert fullarm_voip_cert.pem:qrw0Pv8ujHDScRqB https://api.development.push.apple.com/3/device/172fa6c8f165c733d81b84c4763ad913970f45000b47a4f2855d019cb922d7e8