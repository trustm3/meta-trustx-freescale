SRC_URI += "file://trustx.cfg \
            file://${MACHINE}.cfg \
            "

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

do_preconfigure () {
        cat ${WORKDIR}/trustx.cfg >> ${WORKDIR}/defconfig
        cat ${WORKDIR}/${MACHINE}.cfg >> ${WORKDIR}/defconfig
}

addtask do_preconfigure after do_patch before do_configure
