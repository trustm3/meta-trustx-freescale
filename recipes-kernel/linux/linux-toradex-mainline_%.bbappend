SRC_URI += "file://trustx.cfg \
            file://imx8x.cfg \
            "

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

do_preconfigure () {
        cat ${WORKDIR}/trustx.cfg >> ${WORKDIR}/defconfig
        cat ${WORKDIR}/imx8x.cfg >> ${WORKDIR}/defconfig
}

addtask do_preconfigure after do_patch before do_configure
