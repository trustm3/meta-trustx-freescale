INITRAMFS_IMAGE_BUNDLE = "0"

inherit trustmefslc

# execute prepare device conf at beginning of do_rootfs
IMAGE_PREPROCESS_COMMAND:remove = "prepare_device_conf;"

##### provide a tarball for cml update
include images/trustx-signing.inc
deltask do_sign_guestos
IMAGE_POSTPROCESS_COMMAND:remove = "do_sign_guestos;"

do_rootfs:prepend () {
	prepare_kernel_conf
	do_sign_guestos

	prepare_device_conf
}

GUESTS_OUT = "${B}/cml_updates"
CLEAN_GUEST_OUT = ""
OS_NAME = "kernel"
UPDATE_OUT_GENERIC="${GUESTS_OUT}/${OS_NAME}"
UPDATE_OUT="${UPDATE_OUT_GENERIC}-${TRUSTME_VERSION}"
UPDATE_FILES="${UPDATE_OUT_GENERIC} ${UPDATE_OUT_GENERIC}.conf ${UPDATE_OUT_GENERIC}.sig ${UPDATE_OUT_GENERIC}.cert"

do_sign_guestos:prepend () {
        mkdir -p "${UPDATE_OUT}"
        cp "${DEPLOY_DIR_IMAGE}/cml-kernel/${KERNEL_IMAGETYPE}-trustx-cml-initramfs-${MACHINE}-${MACHINE}" "${UPDATE_OUT}/kernel.img"
        cp "${DEPLOY_DIR_IMAGE}/trustx-cml-firmware-${MACHINE}.squashfs" "${UPDATE_OUT}/firmware.img"
        cp "${DEPLOY_DIR_IMAGE}/trustx-cml-modules-${MACHINE}.squashfs" "${UPDATE_OUT}/modules.img"
}

do_sign_guestos:append () {
        tar cf "${UPDATE_OUT}.tar" -C "${GUESTS_OUT}" \
                "${OS_NAME}-${TRUSTME_VERSION}" \
                "${OS_NAME}-${TRUSTME_VERSION}.conf" \
                "${OS_NAME}-${TRUSTME_VERSION}.sig" \
                "${OS_NAME}-${TRUSTME_VERSION}.cert"

        ln -sf "$(basename ${UPDATE_OUT})" "${UPDATE_OUT_GENERIC}"
        ln -sf "$(basename ${UPDATE_OUT}.conf)" "${UPDATE_OUT_GENERIC}.conf"
        ln -sf "$(basename ${UPDATE_OUT}.cert)" "${UPDATE_OUT_GENERIC}.cert"
        ln -sf "$(basename ${UPDATE_OUT}.sig)" "${UPDATE_OUT_GENERIC}.sig"
}

OS_CONFIG_IN := "${THISDIR}/${PN}/${OS_NAME}.conf"
OS_CONFIG = "${WORKDIR}/${OS_NAME}.conf"
prepare_kernel_conf () {
    cp "${OS_CONFIG_IN}" "${OS_CONFIG}"
}
