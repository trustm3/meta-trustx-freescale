inherit trustmegeneric

#
# Create an partitioned trustme image that can be copied to an SD card
#

do_image_trustmefslc[depends] = " \
    u-boot-mkimage-native:do_populate_sysroot \
    virtual/bootloader:do_deploy \
    virtual/kernel:do_assemble_fitimage_initramfs \
    trustx-cml-initramfs:do_image_complete \
"


do_image_trustmefslc[depends] += " ${TRUSTME_GENERIC_DEPENDS} "

do_fslc_bootpart () {

	if [ -z "${DEPLOY_DIR_IMAGE}" ];then
		bbfatal "Cannot get bitbake variable \"DEPLOY_DIR_IMAGE\""
		exit 1
	fi

	if [ -z "${TRUSTME_BOOTPART_DIR}" ];then
		bbfatal "Cannot get bitbake variable \"TRUSTME_BOOTPART_DIR\""
		exit 1
	fi

	bbnote "Copying boot partition files to ${TRUSTME_BOOTPART_DIR}"
	
	machine=$(echo "${MACHINE}" | tr "_" "-")
	bbdebug 1 "Boot machine: $machine"

	rm -fr "${TRUSTME_BOOTPART_DIR}"
	install -d "${TRUSTME_BOOTPART_DIR}"
	
        cp --dereference "${DEPLOY_DIR_IMAGE}/cml-kernel/fitImage-trustx-cml-initramfs-${MACHINE}-${MACHINE}" "${TRUSTME_BOOTPART_DIR}/fitImage"
}


IMAGE_CMD:trustmefslc () {
	bbnote  "Using standard trustme partition"
	do_fslc_bootpart
	do_build_trustmeimage
}

do_rootfs () {
	if [ -z "${TRUSTME_BOOTPART_DIR}" ];then
		bbfatal_log "Cannot get bitbake variable \"TRUSTME_BOOTPART_DIR\""
		exit 1
	fi

	if [ -z "${TOPDIR}" ];then
		bbfatal_log "Cannot get bitbake variable \"TOPDIR\""
		exit 1
	fi

	if [ -z "${DEPLOY_DIR_IMAGE}" ];then
		bbfatal_log "Cannot get bitbake variable \"DEPLOY_DIR_IMAGE\""
		exit 1
	fi

	if [ -z "${DEPLOY_DIR_IPK}" ];then
		bbfatal_log "Cannot get bitbake variable \"DEPLOY_DIR_IPK\""
		exit 1
	fi


	if [ -z "${MACHINE_ARCH}" ];then
		bbfatal_log "Cannot get bitbake variable \"MACHINE_ARCH\""
		exit 1
	fi

	if [ -z "${WORKDIR}" ];then
		bbfatal_log "Cannot get bitbake variable \"WORKDIR\""
		exit 1
	fi

	if [ -z "${S}" ];then
		bbfatal_log "Cannot get bitbake variable \"TRUSTME_HARDWARE\""
		exit 1
	fi

	if [ -z "${PREFERRED_PROVIDER_virtual/kernel}" ];then
		bbfatal_log "Cannot get bitbake variable \"PREFERRED_PROVIDER_virtual/kernel\""
		exit 1
	fi

	if [ -z "${MACHINE}" ];then
		bbfatal_log "Cannot get bitbake variable \"MACHINE\""
		exit 1
	fi

	if [ -z "${DISTRO}" ];then
		bbfatal_log "Cannot get bitbake variable \"DISTRO\""
		exit 1
	fi

	if [ -z "${TRUSTME_IMAGE_OUT}" ];then
		bbfatal_log "Cannot get bitbake variable \"TRUSTME_IMAGE_OUT\""
		exit 1
	fi

	if [ -z "${TRUSTME_IMAGE_TMP}" ];then
		bbfatal_log "Cannot get bitbake variable \"TRUSTME_IMAGE_TMP\""
		exit 1
	fi

	if [ -z "${TRUSTME_CONTAINER_ARCH}" ];then
		bbfatal_log "Cannot get bitbake variable \"TRUSTME_CONTAINER_ARCH\""
		exit 1
	fi



	rm -fr ${TRUSTME_IMAGE_TMP}
	rm -f "${TRUSTME_IMAGE}"

	machine=$(echo "${MACHINE}" | tr "-" "_")

	bbnote "Starting to create trustme image"
	# create temporary directories
	install -d "${TRUSTME_IMAGE_OUT}"
	install -d "${TRUSTME_BOOTPART_DIR}"
	tmp_modules="${TRUSTME_IMAGE_TMP}/tmp_modules"
	tmp_firmware="${TRUSTME_IMAGE_TMP}/tmp_firmware"
	rootfs="${IMAGE_ROOTFS}"
	rootfs_datadir="${rootfs}/userdata/"
	tmpdir="${TOPDIR}/tmp_container"
	trustme_fsdir="${TRUSTME_IMAGE_TMP}/filesystems"
	trustme_bootfs="$trustme_fsdir/trustme_bootfs"
	trustme_datafs="$trustme_fsdir/trustme_datafs"

	install -d "${TRUSTME_IMAGE_TMP}"
	rm -fr "${rootfs}/"
	install -d "${rootfs}/"
	rm -fr "${rootfs_datadir}"
	install -d "${rootfs_datadir}"
	rm -fr "${trustme_fsdir}"
	install -d "${trustme_fsdir}"
	rm -fr "${tmp_modules}/"
	install -d "${tmp_modules}/"
	rm -fr "${tmp_firmware}/"
	install -d "${tmp_firmware}/"

	rm -fr "${tmp_firmware}/"
	install -d "${tmp_firmware}/"

	install -d "${rootfs_datadir}/cml/tokens"
	install -d "${rootfs_datadir}/cml/containers_templates"

	# define file locations
	#deploy_dir_container = "${tmpdir}/deploy/images/qemu-x86-64"
	containerarch="${TRUSTME_CONTAINER_ARCH}"
	deploy_dir_container="${tmpdir}/deploy/images/$(echo $containerarch | tr "_" "-")"

	src="${TOPDIR}/../trustme/build/"
	config_creator_dir="${src}/config_creator"
	proto_file_dir="${WORKDIR}/cml/daemon"
	provisioning_dir="${src}/device_provisioning"
	enrollment_dir="${provisioning_dir}/oss_enrollment"
	test_cert_dir="${TOPDIR}/test_certificates"
	cfg_overlay_dir="${src}/config_overlay"
	device_cfg="${WORKDIR}/device.conf"

	if ! [ -d "${test_cert_dir}" ];then
		bbfatal_log "Test PKI not generated at ${test_cert_dir}\nIs trustx-cml-userdata built?"
		exit 1
	fi

	# copy files to temp data directory
	bbnote "Preparing files for data partition"

	cp -f "${test_cert_dir}/ssig_rootca.cert" "${rootfs_datadir}/cml/tokens/"
	mkdir -p "${rootfs_datadir}/cml/operatingsystems/"
	mkdir -p "${rootfs_datadir}/cml/containers/"

	if [ -d "${TOPDIR}/../custom_containers" ];then # custom container provided in ${TOPDIR}/../custom_container
		bbnote "Installing custom container and configs to image: ${TOPDIR}/../custom_containers"
		cp -far "${TOPDIR}/../custom_containers/00000000-0000-0000-0000-000000000000.conf" "${rootfs_datadir}/cml/containers_templates/"
		find "${TOPDIR}/../custom_containers/" -name '*os*' -exec cp -afr {} "${rootfs_datadir}/cml/operatingsystems" \;
		cp -f "${TOPDIR}/../custom_containers/device.conf" "${rootfs_datadir}/cml/"
	elif [ -d "${deploy_dir_container}/trustx-guests" ];then # container built in default location
		bbnote "Installing containers from default location ${deploy_dir_container}/trustx-guests"
		cp -far "${deploy_dir_container}/trustx-configs/container/." "${rootfs_datadir}/cml/containers_templates/"
		cp -afr "${deploy_dir_container}/trustx-guests/." "${rootfs_datadir}/cml/operatingsystems"
		cp -f "${device_cfg}" "${rootfs_datadir}/cml/"
	else # no container provided
		bbwarn "It seems that no containers were built in directory ${deploy_dir_container}. You will have to provide at least c0 manually!"
		cp ${cfg_overlay_dir}/${TRUSTME_HARDWARE}/device.conf "${rootfs_datadir}/cml/"
	fi

	# sign container configs
	find "${rootfs_datadir}/cml/containers_templates" -name '*.conf' -exec bash \
		${enrollment_dir}/config_creator/sign_config.sh {} \
		${TEST_CERT_DIR}/ssig_cml.key ${TEST_CERT_DIR}/ssig_cml.cert \;

	# copy modules to data partition directory
	bbnote "Copying linux-modules"
	cp -fL "${DEPLOY_DIR_IMAGE}/trustx-cml-modules-${MACHINE}.squashfs" "${rootfs}/modules.img"

	# copy firmware to data partition directory
	bbnote "Copying linux-firmware"
	cp -fL "${DEPLOY_DIR_IMAGE}/trustx-cml-firmware-${MACHINE}.squashfs" "${rootfs}/firmware.img"

	# copy kernel update files to data partition directory
	bbnote "Copying kernel update files"
	if ! [ -z "${UPDATE_FILES}" ];then
		for update_file in ${UPDATE_FILES}; do
			if [ -L $update_file ]; then
				real_update_file=$(readlink -f $update_file)
			else
				real_update_file=$update_file
			fi
			cp -fr "$real_update_file" "${rootfs_datadir}/cml/operatingsystems"
		done
	fi
}

ROOTFS_PREPROCESS_COMMAND = ""

deploy_trustmeimage:prepend() {
	ln -sf "../${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.wic" "${TRUSTME_IMAGE_OUT}/trustmeimage.img"
	ln -sf "../${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.wic.bmap" "${TRUSTME_IMAGE_OUT}/trustmeimage.img.bmap"
}

do_rootfs[depends] += " ${TRUSTME_GENERIC_DEPENDS} "
