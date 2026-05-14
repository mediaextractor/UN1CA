ADD_TO_WORK_DIR "a17xxx" "vendor" "bin/secril_config_svc" 0 2000 755 "u:object_r:vendor_secril_config_svc_exec:s0"
DECODE_APK "vendor" "overlay/framework-res__auto_generated_rro_vendor.apk"
EVAL "sed -i \"/<resources>/a \\\ \\\ \\\ \\\ <integer name=\\\"config_num_physical_slots\\\">2</integer>\" \"$APKTOOL_DIR/vendor/overlay/framework-res__auto_generated_rro_vendor.apk/res/values/integers.xml\""