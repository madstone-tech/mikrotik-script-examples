############### Update These Variables As Needed ######################
:global QoSDownload "50M"
:global QoSUpload "50M"
:global WAN "ether1"



/ip firewall mangle
add action=add-dst-to-address-list address-list=VoIP address-list-timeout=1d chain=forward comment="Add TCP SIP signaling Dst Addresses To VoIP List" dst-port=5196-5199 out-interface=$WAN protocol=tcp
add action=add-dst-to-address-list address-list=VoIP address-list-timeout=1d chain=forward comment="Add UDP SIP signaling Dst Addresses To VoIP List" dst-port=5196-5199 out-interface=$WAN protocol=udp
add action=add-dst-to-address-list address-list=VoIP address-list-timeout=1d chain=forward comment="Add TCP VOD aac Dst Addresses To VoIP List" dst-port=30000-30040 out-interface=$WAN protocol=tcp
add action=add-dst-to-address-list address-list=VoIP address-list-timeout=1d chain=forward comment="Add UDP VOD aac Dst Addresses To VoIP List" dst-port=30000-30040 out-interface=$WAN protocol=udp
add action=add-dst-to-address-list address-list=VoIP address-list-timeout=1d chain=forward comment="Add TCP STUN Dst Addresses To VoIP List" dst-port=3478-3480 out-interface=$WAN protocol=tcp
add action=add-dst-to-address-list address-list=VoIP address-list-timeout=1d chain=forward comment="Add UDP STUN Dst Addresses To VoIP List" dst-port=3478-3480 out-interface=$WAN protocol=udp
add action=add-dst-to-address-list address-list=VoIP address-list-timeout=1d chain=forward comment="Add TCP Polycom media Dst Addresses To VoIP List" dst-port=2222-2269 out-interface=$WAN protocol=tcp
add action=add-dst-to-address-list address-list=VoIP address-list-timeout=1d chain=forward comment="Add UDP Polycom media Dst Addresses To VoIP List" dst-port=2222-2269 out-interface=$WAN protocol=udp
add action=add-dst-to-address-list address-list=VoIP address-list-timeout=1d chain=forward comment="Add TCP Linksys media Dst Addresses To VoIP List" dst-port=16384-16404 out-interface=$WAN protocol=tcp
add action=add-dst-to-address-list address-list=VoIP address-list-timeout=1d chain=forward comment="Add UDP Linksys media Dst Addresses To VoIP List" dst-port=16384-16404 out-interface=$WAN protocol=udp
add action=mark-packet chain=forward comment="Mark Priority2 Up" connection-mark=Priority2_Up new-packet-mark=Priority2_Up passthrough=no
add action=mark-packet chain=forward comment="Mark Priority 2 Down" connection-mark=Priority2_Dwn new-packet-mark=Priority2_Dwn passthrough=no
add action=mark-connection chain=forward comment="Mark Voice Connections - Download" new-connection-mark=VoIP_Up src-address-list=VoIP
add action=mark-connection chain=forward comment="Mark Voice Connections - Upload" dst-address-list=VoIP new-connection-mark=VoIP_Dwn
add action=mark-packet chain=forward comment="Mark Voice Packets - Download" connection-mark=VoIP_Dwn new-packet-mark=VoIP_Dwn passthrough=no
add action=mark-packet chain=forward comment="Mark Voice Packets - Upload" connection-mark=VoIP_Up new-packet-mark=VoIP_Up passthrough=no
add action=mark-connection chain=forward comment="Mark Best Effort Connections - Download" in-interface=$WAN new-connection-mark=Best_Effort_Dwn
add action=mark-connection chain=forward comment="Mark Best Effort Connections - Upload" new-connection-mark=Best_Effort_Up out-interface=$WAN
add action=mark-packet chain=forward comment="Mark Best Effort Packets - Download" connection-mark=Best_Effort_Dwn new-packet-mark=Best_Effort_Dwn passthrough=no
add action=mark-packet chain=forward comment="Mark Best Effort Packets - Upload" connection-mark=Best_Effort_Up new-packet-mark=Best_Effort_Up passthrough=no

/queue tree
add max-limit=$QoSDownload name=INTERNET_Down parent=global queue=default
add max-limit=$QoSUpload name=INTERNET_Up parent=global queue=default
add limit-at=1M max-limit=$QoSDownload name=Voice_Dwn packet-mark=VoIP_Dwn parent=INTERNET_Down priority=1 queue=default
add limit-at=512k max-limit=$QoSUpload name=Voice_Up packet-mark=VoIP_Up parent=INTERNET_Up priority=1 queue=default
add name=Best_Effort_Dwn packet-mark=Best_Effort_Dwn parent=INTERNET_Down queue=default
add name=Best_Effort_Up packet-mark=Best_Effort_Up parent=INTERNET_Up queue=default
add limit-at=80k max-limit=$QoSUpload name=Priority2_Up packet-mark=Priority2_Up parent=INTERNET_Up priority=2 queue=default
add limit-at=5M max-limit=$QoSDownload name=Priority2_Down packet-mark=Priority2_Dwn parent=INTERNET_Down priority=2 queue=default
	
