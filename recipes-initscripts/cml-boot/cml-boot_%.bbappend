## Remove redirection of consolre output to enable automatic start of CML on NXP devices

do_install:prepend() {
	sed -i '/exec > \/dev\/$LOGTTY*/c\#exec > \/dev\/$LOGTTY' ${WORKDIR}/cml-boot-script.stub
	sed -i '/exec 2>&1*/c\#exec 2>&1' ${WORKDIR}/cml-boot-script.stub
        sed -i '/^exec \/sbin\/init*/i \exec \/sbin\/getty 115200 -H \x27trustx-cml\x27 $LOGTTY' ${WORKDIR}/cml-boot-script.stub
}
