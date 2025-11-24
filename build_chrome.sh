#!/bin/bash
./build.sh
cp -R shared/* chrome/
rm -rf chrome/src
mv Angular/dist/email-alias/browser chrome/src
read -p "Now add the extension to Chrome and type your extension id: " extension_id

cp ./chrome/com.opdehipt.email_alias.json ./chrome/com.opdehipt.email_alias.json.bak

perl -0777 -pe "s/<id>/$extension_id/g" -i ./chrome/com.opdehipt.email_alias.json

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  CHROME_PATH="$HOME/.config/google-chrome/NativeMessagingHosts"
  CHROMIUM_PATH="$HOME/.config/chromium/NativeMessagingHosts"
  CLI_PATH="/opt/share/email-alias/cli/browser_cli"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  CHROME_PATH="$HOME/Library/Application Support/Google/Chrome/NativeMessagingHosts"
  CHROMIUM_PATH="$HOME/Library/Application Support/Chromium/NativeMessagingHosts"
  CLI_PATH="/Applications/Email Alias.app/Contents/MacOS/Browser-CLI"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  CHROME_PATH="$HOME/AppData/Local/Google/Chrome/User Data/NativeMessagingHosts"
  CHROMIUM_PATH="$HOME/AppData/Local/Chromium/User Data/NativeMessagingHosts"

  CLI_PATH="C:\\Program Files\\Email Alias\\cli\\browser_cli.exe"

  CHROME_REG_KEY="HKCU:\\Software\\Google\\Chrome\\NativeMessagingHosts\\com.opdehipt.email_alias"
  CHROMIUM_REG_KEY="HKCU:\\Software\\Chromium\\NativeMessagingHosts\\com.opdehipt.email_alias"

  WINDOWS_MANIFEST_PATH=$(cygpath -w "$CHROME_PATH/com.opdehipt.email_alias.json")

  powershell.exe -NoProfile -Command "
    New-Item -Path '$CHROME_REG_KEY' -Force | Out-Null;
    Set-ItemProperty -Path '$CHROME_REG_KEY' -Name '(default)' -Value '$WINDOWS_MANIFEST_PATH';

    New-Item -Path '$CHROMIUM_REG_KEY' -Force | Out-Null;
    Set-ItemProperty -Path '$CHROMIUM_REG_KEY' -Name '(default)' -Value '$WINDOWS_MANIFEST_PATH';
  "
else
  exit 1
fi

if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  CLI_PATH_ESCAPED=$(printf '%s\n' "$CLI_PATH" | sed 's/\\/\\\\\\\\/g')
  sed -i "s|<cli>|$CLI_PATH_ESCAPED|g" ./chrome/com.opdehipt.email_alias.json
else
  perl -0777 -pe "s|<cli>|$CLI_PATH|g" -i ./chrome/com.opdehipt.email_alias.json
fi

for FILE in "$CHROME_PATH" "$CHROMIUM_PATH"; do
  mkdir -p "$FILE"
  cp ./chrome/com.opdehipt.email_alias.json "$FILE/com.opdehipt.email_alias.json"
done

mv ./chrome/com.opdehipt.email_alias.json.bak ./chrome/com.opdehipt.email_alias.json
