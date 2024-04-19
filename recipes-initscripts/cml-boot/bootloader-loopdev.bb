SUMMARY = "rc script to create a loopdev pointing to the u-boot bootloader"
LICENSE = "MIT"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = "\
        file://bootloader-loopdev.sh.in \
"

GYROIDOS_RAW_BOOT_END ?= "${RAW_BOOT_END_OFFSET_KB}"

do_compile() {
	if [ -z "${IMX_BOOT_SEEK}" ];then
		bbfatal_log "Cannot get bitbake variable \"TRUSTME_BOOTPART_DIR\""
	fi

	if [ -z "${GYROIDOS_RAW_BOOT_END}" ];then
		bbfatal_log "Cannot get bitbake variable \"GYROIDOS_RAW_BOOT_END\". Consider setting it in your device config."
	fi

	cp ${WORKDIR}/bootloader-loopdev.sh.in ${WORKDIR}/bootloader-loopdev.sh
	sed 's|##IMX_BOOT_SEEK##|${IMX_BOOT_SEEK}|g' -i ${WORKDIR}/bootloader-loopdev.sh
	sed 's|##GYROIDOS_RAW_BOOT_END##|${GYROIDOS_RAW_BOOT_END}|g' -i ${WORKDIR}/bootloader-loopdev.sh
}

do_install:append() {
	mkdir -p ${D}/etc/init.d
	install -m755 ${WORKDIR}/bootloader-loopdev.sh ${D}/etc/init.d
	mkdir -p ${D}/etc/rcS.d
	ln -s ../init.d/bootloader-loopdev.sh ${D}/etc/rcS.d/S50_bootloader-loopdev.sh
}

