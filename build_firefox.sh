#!/bin/bash
./build.sh
cp -R shared/* firefox/
mv Angular/dist/email-alias/browser firefox/src
read -p "Now add the extension to Firefox and type your extension id: " extension_id
sed -i -e "s/<id>/$extension_id/g" ./firefox/com.opdehipt.email_alias.json
cp ./firefox/com.opdehipt.email_alias.json ~/Library/Application Support/Mozilla/NativeMessagingHosts/com.opdehipt.email_alias.json