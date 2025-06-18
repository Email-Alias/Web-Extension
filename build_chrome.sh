#!/bin/bash
./build.sh
cp -R shared/* chrome/
mv Angular/dist/email-alias/browser chrome/src
read -p "Now add the extension to Chrome and type your extension id: " extension_id
sed -i -e "s/<id>/$extension_id/g" ./chrome/com.opdehipt.email_alias.json
cp ./chrome/com.opdehipt.email_alias.json ~/Library/Application\ Support/Google/Chrome/NativeMessagingHosts/com.opdehipt.email_alias.json