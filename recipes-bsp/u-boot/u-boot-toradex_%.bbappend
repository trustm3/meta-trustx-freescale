FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://imx6ull-extra-config"

# do_configure_prepend() {
#	cat ${WORKDIR}/imx6ull-extra-config >> ${WORKDIR}/git/configs/${UBOOT_MACHINE}
# }

# do_concat_dtb_append (){
#        if [ "x${UBOOT_SIGN_ENABLE}" = "x1" ]; then
#                if [ "x${UBOOT_SUFFIX}" = "ximx" ] && [ -e "${DEPLOY_DIR_IMAGE}/${UBOOT_DTB_IMAGE}" ]; then
#                        cd ${B}
#                        oe_runmake EXT_DTB=${DEPLOY_DIR_IMAGE}/${UBOOT_DTB_IMAGE} ${UBOOT_MAKE_TARGET}
#                        bbwarn "Adding public key to u-boot binary was successfull. Verified boot will be available after all."
#                else
#                        bbwarn "Final failure while adding public key to u-boot binary. Verified boot certainly won't be available."
#                fi
#	fi
# }

