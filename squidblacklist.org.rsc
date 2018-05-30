# pulling in http://www.squidblacklist.org/downloads/drop.malicious.rsc
# script should run every 30 mins (the interval which the blacklist is updated)

:local droplist "http://www.squidblacklist.org/downloads/drop.malicious.rsc"
:local filename "drop.malicious.rsc"

:do {
  :put "Updating Blocklists";

  /tool fetch mode=https url=$droplist keep-result=yes dst-path=$filename \
  http-method="get"
} on-error={ log warning "Failed to update Blocklists"}

:do {
  :put "Importing new Blocklists";

  /import $filename
} on-error={ log warning "Failed to import Blocklists"}

