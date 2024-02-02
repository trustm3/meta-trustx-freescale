MACHINE="tqma8mpxl-mba8mpxl"

PREFERRED_PROVIDER_virtual/kernel:tqma8mpxl = "linux-rolling-stable"

INITRAMFS_IMAGE = "trustx-cml-initramfs"
INITRAMFS_IMAGE_BUNDLE = "0"

TRUSTME_HARDWARE = "arm"
TRUSTME_LOGTTY = "ttyLP0"
TRUSTME_CONTAINER_ARCH = "qemuarm64"
TRUSTME_FSTYPES = "wic wic.bmap"

BBMULTICONFIG = "container"
KERNEL_CLASSES:append = " kernel-fitimage "
KERNEL_IMAGETYPE:tqma8mpxl = "fitImage"

IMAGE_BOOT_FILES:tqma8mpxl = "${KERNEL_DEPLOYSUBDIR}/fitImage-trustx-cml-initramfs-${MACHINE}-${MACHINE};fitImage-trustx-cml-initramfs"
WKS_FILE:tqma8mpxl = "tqma8mpxl.wks.in"

# keys name in keydir (eg. "dev.crt", "dev.key")
# no verified boot yet
#UBOOT_SIGN_KEYDIR = "${TOPDIR}/test_certificates/"
#UBOOT_SIGN_ENABLE = "1"
#UBOOT_SIGN_KEYNAME = "ssig_subca"
