SRC_URI += "file://trustx.cfg \
            file://imx6.cfg \
            "

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

do_preconfigure:prepend() {
	cat ${WORKDIR}/imx6.cfg >> ${WORKDIR}/defconfig
	cat ${WORKDIR}/trustx.cfg >> ${WORKDIR}/defconfig
}

