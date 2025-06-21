chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
    if (request.type === "alias") {
        (async () => {
          await chrome.action.setPopup({
            popup: 'popover.html',
            tabId: sender.tab.id
          });
          await chrome.action.openPopup();
	  await chrome.action.setPopup({
            popup: 'src/index.html',
            tabId: sender.tab.id
          });
          const json = await chrome.runtime.sendNativeMessage('com.opdehipt.email_alias', {type: 'getAliases'});
          sendResponse(json);
        })()
        return true;
    }
    return false;
});
