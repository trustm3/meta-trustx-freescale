INITRAMFS_IMAGE_BUNDLE = "0"

inherit trustmefslc

# execute prepare device conf at beginning of do_rootfs
IMAGE_PREPROCESS_COMMAND:remove = "prepare_device_conf;"
do_rootfs:prepend () {
	prepare_device_conf
}
