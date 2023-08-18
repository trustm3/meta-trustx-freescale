FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
FILESEXTRAPATHS:prepend := "${THISDIR}/linux-toradex:"

SRC_URI += "file://${MACHINE}.cfg"
SRC_URI += "file://0001-mwifiex-Set-WIPHY_FLAG_NETNS_OK.patch"

include recipes-kernel/linux/linux-gyroidos.inc
