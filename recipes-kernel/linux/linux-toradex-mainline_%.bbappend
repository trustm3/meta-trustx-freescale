FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://${MACHINE}.cfg"

include recipes-kernel/linux/linux-gyroidos.inc
