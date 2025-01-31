
do_compile:append(){
	if [ ! -e "${TEST_CERT_DIR}/ssig_subca.crt" ]; then
		ln -s ${TEST_CERT_DIR}/ssig_subca.cert ${TEST_CERT_DIR}/ssig_subca.crt
	fi
}
