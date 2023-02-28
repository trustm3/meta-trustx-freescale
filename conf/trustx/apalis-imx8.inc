MACHINE="apalis-imx8"

MACHINEOVERRIDES =. "use-head-next:"

PREFERRED_PROVIDER_virtual/kernel:apalis-imx8 = "linux-toradex"
#COMPATIBLE_MACHINE = "apalis-imx8"

INITRAMFS_IMAGE = "trustx-cml-initramfs"

TRUSTME_HARDWARE = "arm"
TRUSTME_LOGTTY = "ttyLP1"
TRUSTME_CONTAINER_ARCH = "qemuarm64"
TRUSTME_FSTYPES = "trustmefslc"

BBMULTICONFIG = "container"
PACKAGE_CLASSES = "package_ipk"
KERNEL_CLASSES:append = " kernel-fitimage "
KERNEL_IMAGETYPES:append = " fitImage"
KERNEL_DEVICETREE = " imx8qm-apalis-v1.1-ixora-v1.2.dtb "

IMAGE_FSTYPES:remove = " teziimg"
IMAGE_CLASSES:remove = " image_type_tezi"

# keys name in keydir (eg. "dev.crt", "dev.key")
UBOOT_SIGN_KEYDIR = "${TOPDIR}/test_certificates/"
UBOOT_SIGN_ENABLE = "1"
UBOOT_SIGN_KEYNAME = "ssig_subca"
