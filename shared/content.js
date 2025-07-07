function replaceAndType(text, delay = 10) {
  text.split('').forEach((char, idx) => {
    setTimeout(() => {
      document.execCommand('insertText', false, char);
    }, delay * idx);
  });
}

async function getEmails() {
    const isSafari = /^((?!chrome|android).)*safari/i.test(navigator.userAgent);
    if (isSafari) {
        return await browser.runtime.sendMessage({ type: "alias" });
    }
    return await chrome.runtime.sendMessage({ type: "alias" });
}

document.addEventListener('focus', async e => {
    if (e.target.matches("input[type='email']") && !e.target.value) {
        const currentDomain = document.URL.split('/')[2].split('.').reverse()[1];
        let emails = JSON.parse((await getEmails()).emails);
        let selectedEmails = []
        for (let email of emails) {
            if (email.privateComment.replace(' ', '').toLowerCase().includes(currentDomain)) {
                selectedEmails.push(email)
            }
        }
        if (selectedEmails.length == 1) {
            replaceAndType(selectedEmails[0].address);
        }
    }
}, true);
