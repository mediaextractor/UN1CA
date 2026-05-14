if [[ -d "$TMP_DIR" ]]; then
    EVAL "rm -rf \"$TMP_DIR\""
fi
EVAL "mkdir -p \"$TMP_DIR\""

TEE="https://github.com/majaahh/proprietary_vendor_samsung_exynos-old/releases/download/A146BXXSCDZB2_INS_ODM/A146BXXSCDZB2_firmware_tee.zip"

DOWNLOAD_FILE "$TEE" "$TMP_DIR/$(basename "$TEE")"
EVAL "unzip \"$TMP_DIR/$(basename "$TEE")\" -d \"$TMP_DIR/vendor\""

LOG_STEP_IN "- Setting up firmware folder"
BLOBS_LIST="
calliope_sram.bin
mfc_fw.bin
os.checked.bin
pablo_icpufw.bin
"

for i in "SM-A146B" "SM-A146M"; do
    for f in $BLOBS_LIST; do
        DIR="$TMP_DIR"
        if [[ "$i" == "SM-A146M" ]]; then
            DIR="$WORK_DIR"
        fi

        EVAL "mv \"$DIR/vendor/firmware/$f\" \"$WORK_DIR/vendor/firmware/variants/$i/$f\""

        unset DIR
    done
done
LOG_STEP_OUT

LOG "- Settings up TEEgris firmware for SM-A146B"
EVAL "cp -a \"$TMP_DIR/vendor/tee/\"* \"$WORK_DIR/vendor/tee_SM-A146B\""
LOG_STEP_OUT

{
    echo "(allow init_33_0 tee_file (dir (mounton)))"
    echo "(allow priv_app_33_0 tee_file (dir (getattr)))"
    echo "(allow init_33_0 vendor_fw_file (file (mounton)))"
    echo "(allow priv_app_33_0 vendor_fw_file (file (getattr)))"
} >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil" || return 1

unset BLOBS_LIST TEE
