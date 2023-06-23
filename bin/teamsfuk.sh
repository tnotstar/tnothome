#!/bin/sh

# stolen from: https://www.reddit.com/r/MicrosoftTeams/comments/k5w349/script_for_keeping_available_status_perpetually/

cat <<EOT | xclip -i -selection clipboard
(function (secs) {
  function getAuthToken() {
    for(const i in localStorage) {
      if(i.startsWith("ts.") && i.endsWith("cache.token.https://presence.teams.microsoft.com/")) {
        return JSON.parse(localStorage[i]).token;
      }
    }
  }

  function makeActive() {
    const authToken = getAuthToken();
    console.log('fuk u teams', authToken);
    fetch("https://presence.teams.microsoft.com/v1/me/forceavailability/", {
      "headers": {
        "Content-Type": "application/json",
        "Authorization": \`Bearer \${authToken}\`,
      },
      "body": '{"availability":"Available"}',
      "method": "PUT"
    })
    .then(response => console.log('Got fuked!'))
  }

  setInterval(makeActive, 1000*secs);
  makeActive()
})(240);
EOT
