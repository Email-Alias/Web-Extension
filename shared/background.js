chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
    if (request.type === "alias") {
        chrome.runtime.sendNativeMessage('com.opdehipt.email_alias', {type: 'getAliases'}).then((json) => {
          sendResponse(json);
        });
        return true;
    }
    return false;
});