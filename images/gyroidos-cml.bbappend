INITRAMFS_IMAGE_BUNDLE = "0"

KERNEL_IMAGE_FILE = "cml-kernel/fitImage-gyroidos-cml-initramfs-${MACHINE}-${MACHINE}"
OS_CONFIG_IN := "${THISDIR}/${PN}/${OS_NAME}.conf"

do_sign_guestos:prepend () {
        mkdir -p "${UPDATE_OUT}"
        cp "${DEPLOY_DIR_IMAGE}/${MACHINE_WKS_BOOTSTREAM}" "${UPDATE_OUT}/bootloader.img"
        cp "${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGE_FILE}" "${UPDATE_OUT}/kernel.img"
        cp "${DEPLOY_DIR_IMAGE}/gyroidos-cml-firmware-${MACHINE}.squashfs" "${UPDATE_OUT}/firmware.img"
        cp "${DEPLOY_DIR_IMAGE}/gyroidos-cml-modules-${MACHINE}.squashfs" "${UPDATE_OUT}/modules.img"
        cp "${WORKDIR}/device.conf" "${UPDATE_OUT}/device.img"
}
