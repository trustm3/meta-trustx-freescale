SRC_URI += "file://trustx.cfg \
            file://imx6.cfg \
            "

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

do_preconfigure_prepend() {
	cat ${WORKDIR}/imx6.cfg >> ${WORKDIR}/defconfig
	cat ${WORKDIR}/trustx.cfg >> ${WORKDIR}/defconfig
}

