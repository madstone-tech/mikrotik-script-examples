et [ find default-name=wlan1 ] mac-address]
:local ver [/system resource get version]
:local name [/system identity get name]

# gather wireless info ---------------------------------------------------
:local wifi [/interface wireless get [ find default-name=wlan1 ] ssid]
:local pw [/interface wireless security-profiles get [ find name=default ] wpa2-pre-shared-key]

# put it all together ----------------------------------------------------
:set $str "rtrName=$name&rtrMac=$macadd&rtrUptime=$uptime&rtrVersion=$ver&ssidName=$wifi&ssidKey=$pw";


# send to server ---------------------------------------------------------

:do {
	:put "Checking in";
	
	/tool fetch mode=https    url="https://domain.com/checkin.php"  keep-result=yes  dst-path="result.txt" \
	user="routerdevice" password="garbledpassword"  http-method="post"   http-data=$str ;
 
} on-error={ log warning "Greeter: Send to server Failed!" }

