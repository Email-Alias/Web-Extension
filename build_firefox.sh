#!/bin/bash
./build.sh
cp -R shared/* firefox/
rm -rf firefox/src
mv Angular/dist/email-alias/browser firefox/src
read -p "Now add the extension to Firefox and type your extension id: " extension_id

cp ./firefox/com.opdehipt.email_alias.json ./firefox/com.opdehipt.email_alias.json.bak

perl -0777 -pe "s/<id>/$extension_id/g" -i ./firefox/com.opdehipt.email_alias.json

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  FIREFOX_PATH="$HOME/.mozilla/native-messaging-hosts"
  CLI_PATH="/opt/share/email-alias/cli/browser_cli"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  FIREFOX_PATH ="$HOME/Library/Application Support/Mozilla/NativeMessagingHosts"
  CLI_PATH="/Applications/Email Alias.app/Contents/MacOS/Browser-CLI"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  FIREFOX_PATH="$HOME/AppData/Local/Mozilla/User Data/NativeMessagingHosts"

  CLI_PATH="C:\\Program Files\\Email Alias\\cli\\browser_cli.exe"

  FIREFOX_REG_KEY="HKCU:\\Software\\Mozilla\\NativeMessagingHosts\\com.opdehipt.email_alias"

  WINDOWS_MANIFEST_PATH=$(cygpath -w "$FIREFOX_PATH/com.opdehipt.email_alias.json")

  powershell.exe -NoProfile -Command "
    New-Item -Path '$FIREFOX_REG_KEY' -Force | Out-Null;
    Set-ItemProperty -Path '$FIREFOX_REG_KEY' -Name '(default)' -Value '$WINDOWS_MANIFEST_PATH';
  "
else
  exit 1
fi

if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  CLI_PATH_ESCAPED=$(printf '%s\n' "$CLI_PATH" | sed 's/\\/\\\\\\\\/g')
  sed -i "s|<cli>|$CLI_PATH_ESCAPED|g" ./firefox/com.opdehipt.email_alias.json
else
  perl -0777 -pe "s|<cli>|'$CLI_PATH'|g" -i ./firefox/com.opdehipt.email_alias.json
fi

mkdir -p "$FIREFOX_PATH"
cp ./firefox/com.opdehipt.email_alias.json "$FIREFOX_PATH/com.opdehipt.email_alias.json"

mv ./firefox/com.opdehipt.email_alias.json.bak ./firefox/com.opdehipt.email_alias.json
