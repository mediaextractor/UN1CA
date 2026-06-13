# TEEgris - Firmware
EVAL "mkdir -p \"$WORK_DIR/vendor/firmware/variants/SM-A146M\""
SET_METADATA "vendor" "firmware/variants/SM-A146M" 0 2000 755 "u:object_r:vendor_fw_file:s0"
for f in "calliope_sram.bin" "mfc_fw.bin" \
        "os.checked.bin" "pablo_icpufw.bin"; do
    LOG "- Moving /vendor/firmware/$f to /vendor/firmware/variants/SM-A146M/$f"
    EVAL "mv \"$WORK_DIR/vendor/firmware/$f\" \"$WORK_DIR/vendor/firmware/variants/SM-A146M/$f\""
    SET_METADATA "vendor" "firmware/variants/SM-A146M/$f" 0 0 644 "u:object_r:vendor_fw_file:s0"

    LOG "- Creating dummy /vendor/firmware/$f"
    EVAL "touch \"$WORK_DIR/vendor/firmware/$f\""
done

TEEGRIS_ZIPS=(
	# a14xxx 
	"A146BXXSDDZE1_INS_ODM/A146BXXSDDZE1_firmware_tee.zip"
)

if [ -d "$TMP_DIR" ]; then
    EVAL "rm -rf \"$TMP_DIR\""
fi
EVAL "mkdir -p \"$TMP_DIR\""

for f in "${TEEGRIS_ZIPS[@]}"; do
    FILE_NAME="$(basename "$f")"

    LOG "- Downloading $FILE_NAME"
    DOWNLOAD_FILE "https://github.com/majaahh/proprietary_vendor_samsung_exynos/releases/download/$f" "$TMP_DIR/$FILE_NAME"
	
    TEE_DIR="$WORK_DIR/vendor/firmware/variants/SM-A146B"
    SET_METADATA "vendor" "firmware/variants/SM-A146B/tee" 0 2000 755 "u:object_r:tee_file:s0"

    LOG "- Extracting ${TMP_DIR//$SRC_DIR\//}/$FILE_NAME to /${TEE_DIR//$WORK_DIR\//}"
    EVAL "unzip \"$TMP_DIR/$FILE_NAME\" -d \"$TEE_DIR\""
	EVAL "rm -rf \"$TEE_DIR/firmware\""

    while IFS= read -r t; do
        GROUP=0
        MODE="644"
        if [ -d "$TEE_DIR/tee/$t" ]; then
            GROUP="2000"
            MODE="755"
        fi

        SET_METADATA "vendor" "firmware/variants/SM-A146B/tee/$t" 0 "$GROUP" "$MODE" "u:object_r:tee_file:s0" > /dev/null

        unset GROUP MODE
    done < <(find "$TEE_DIR/tee" | sed "s|$TEE_DIR/tee||g" | sed "s/^\///g" | sed "/^\$/d")

    EVAL "rm -f \"$TMP_DIR/$FILE_NAME\""

    unset FILE_NAME TEE_DIR
done

DECODE_APK "vendor" "overlay/framework-res__auto_generated_rro_vendor.apk"
EVAL "sed -i \"/<resources>/a \\\ \\\ \\\ \\\ <integer name=\\\"config_num_physical_slots\\\">2</integer>\" \"$APKTOOL_DIR/vendor/overlay/framework-res__auto_generated_rro_vendor.apk/res/values/integers.xml\""

{
    echo "(allow init_33_0 tee_file (dir (mounton)))"
    echo "(allow priv_app_33_0 tee_file (dir (getattr)))"
    echo "(allow init_33_0 vendor_fw_file (file (mounton)))"
    echo "(allow priv_app_33_0 vendor_fw_file (file (getattr)))"
} >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil" || return 1