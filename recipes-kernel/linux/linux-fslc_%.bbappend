SRC_URI += "file://trustx.cfg \
            file://imx6.cfg \
            file://imx6-caam.cfg \
            "

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_preconfigure_prepend() {
	cat ${WORKDIR}/imx6.cfg >> ${WORKDIR}/defconfig
	cat ${WORKDIR}/imx6-caam.cfg >> ${WORKDIR}/defconfig
	cat ${WORKDIR}/trustx.cfg >> ${WORKDIR}/defconfig
}

