# eSE
EVAL "sed -i \"/class hal/a \    disabled\" \
	\"$WORK_DIR/vendor/etc/init/android.hardware.secure_element@1.2-service.rc\""
{
	echo ""
	echo "on property:ro.boot.em.model=SM-A546B"
	echo "start vendor.secure_element_hal_service"
	echo ""
	echo "on property:ro.boot.em.model=SM-A5460"
	echo "start vendor.secure_element_hal_service"
} >> "$WORK_DIR/vendor/etc/init/android.hardware.secure_element@1.2-service.rc" || return 1

# TEEgris - Firmware
EVAL "mkdir -p \"$WORK_DIR/vendor/firmware/variants/SM-A546B\""
SET_METADATA "vendor" "firmware/variants/SM-A546B" 0 2000 755 "u:object_r:vendor_fw_file:s0"
for f in "AIE.bin" "calliope_sram.bin" \
        "mfc_fw.bin" "os.checked.bin" "pablo_icpufw.bin" "vts.bin"; do
    LOG "- Moving /vendor/firmware/$f to /vendor/firmware/variants/SM-A546B/$f"
    EVAL "mv \"$WORK_DIR/vendor/firmware/$f\" \"$WORK_DIR/vendor/firmware/variants/SM-A546B/$f\""
    SET_METADATA "vendor" "firmware/variants/SM-A546B/$f" 0 0 644 "u:object_r:vendor_fw_file:s0"

    LOG "- Creating dummy /vendor/firmware/$f"
    EVAL "touch \"$WORK_DIR/vendor/firmware/$f\""
done

TEEGRIS_ZIPS=(
	# a54xnsxx (sea_open)
	"A546EXXSFDYI1_EGY_OJM/A546EXXSFDYI1_firmware_tee.zip"
    # a54xzh (chn_hk)
    "A5460ZHSFDYI1_TGY_OZS/A5460ZHSFDYI1_firmware_tee.zip"
	# a54xzc (chn_open)
	"A5460ZCSFDYH1_CHC_CHC/A5460ZCSFDYH1_firmware_tee.zip"
)

if [ -d "$TMP_DIR" ]; then
    EVAL "rm -rf \"$TMP_DIR\""
fi
EVAL "mkdir -p \"$TMP_DIR\""

for f in "${TEEGRIS_ZIPS[@]}"; do
    FILE_NAME="$(basename "$f")"

    LOG "- Downloading $FILE_NAME"
    DOWNLOAD_FILE "https://github.com/majaahh/proprietary_vendor_samsung_exynos/releases/download/$f" "$TMP_DIR/$FILE_NAME"
	
    TEE_DIR="$WORK_DIR/vendor/firmware/variants/SM-$(cut -c1-5 <<< "$FILE_NAME")"
	TEE="tee"
    SET_METADATA "vendor" "firmware/variants/$(basename "$TEE_DIR")/tee" 0 2000 755 "u:object_r:tee_file:s0"

    LOG "- Extracting ${TMP_DIR//$SRC_DIR\//}/$FILE_NAME to /${TEE_DIR//$WORK_DIR\//}"
    EVAL "unzip \"$TMP_DIR/$FILE_NAME\" -d \"$TEE_DIR\""
	EVAL "rm -rf \"$TEE_DIR/firmware\""
	if [ "SM-$(cut -c1-7 <<< "$FILE_NAME")" == "SM-A5460ZC" ]; then
		TEE_DIR="$WORK_DIR/vendor/firmware/variants/SM-A5460"
		EVAL "mv \"$TEE_DIR/tee\" \"$TEE_DIR/tee_a54xzc\""
		SET_METADATA "vendor" "firmware/variants/SM-A5460/tee_a54xzc" 0 2000 755 "u:object_r:tee_file:s0"
		TEE="tee_a54xzc"
	elif [ "SM-$(cut -c1-7 <<< "$FILE_NAME")" == "SM-A5460ZH" ]; then
		TEE_DIR="$WORK_DIR/vendor/firmware/variants/SM-A5460"
		EVAL "mv \"$TEE_DIR/tee\" \"$TEE_DIR/tee_a54xzh\""
		SET_METADATA "vendor" "firmware/variants/SM-A5460/tee_a54xzh" 0 2000 755 "u:object_r:tee_file:s0"
		TEE="tee_a54xzh"
	fi

	while IFS= read -r t; do
		GROUP=0
		MODE="644"
		if [ -d "$TEE_DIR/$TEE/$t" ]; then
			GROUP="2000"
			MODE="755"
		fi

		SET_METADATA "vendor" "firmware/variants/$(basename "$TEE_DIR")/$TEE/$t" 0 "$GROUP" "$MODE" "u:object_r:tee_file:s0" > /dev/null

		unset GROUP MODE
	done < <(find "$TEE_DIR/$TEE" | sed "s|$TEE_DIR/$TEE||g" | sed "s/^\///g" | sed "/^\$/d")

    EVAL "rm -f \"$TMP_DIR/$FILE_NAME\""

    unset FILE_NAME TEE_DIR
done

{
    echo "(allow init_33_0 system_file (dir (mounton)))"
    echo "(allow init_33_0 system_file (file (mounton)))"
    echo "(allow init_33_0 tee_file (dir (mounton)))"
    echo "(allow priv_app_33_0 tee_file (dir (getattr)))"
    echo "(allow init_33_0 vendor_fw_file (file (mounton)))"
    echo "(allow priv_app_33_0 vendor_fw_file (file (getattr)))"
} >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil" || return 1