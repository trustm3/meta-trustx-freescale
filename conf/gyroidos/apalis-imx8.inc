MACHINE="apalis-imx8"

MACHINEOVERRIDES =. "use-head-next:"

PREFERRED_PROVIDER_virtual/kernel:apalis-imx8 = "linux-toradex"
#COMPATIBLE_MACHINE = "apalis-imx8"

# see meta-freescale/conf/machine/include/imx-base.inc for
# MACHINE_SOCARCH_SUFFIX and fsl-dynamic-packagearch. We set
# these explicitly as it is not set correctly for container
# build (MACHINE==qemuarm64) automatically.
MACHINE_SOCARCH_SUFFIX = "-mx8"
INHERIT += "fsl-dynamic-packagearch"

INITRAMFS_IMAGE = "gyroidos-cml-initramfs"

GYROIDOS_HARDWARE = "arm"
GYROIDOS_LOGTTY = "ttyLP1"
GYROIDOS_CONTAINER_ARCH = "qemuarm64"
GYROIDOS_FSTYPES = "gyroidosfslc"

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
