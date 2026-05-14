SKIPUNZIP=1
DELETE_FROM_WORK_DIR "vendor" "tee"
EVAL "mkdir -p \"$WORK_DIR/vendor/tee\""
SET_METADATA "vendor" "tee" 0 2000 755 "u:object_r:tee_file:s0"
BLOBS_LIST="
etc
firmware
tee_SM-A546E
tee_SM-A5460
tee_SM-A546B
tee_SM-A546S
"
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "$MODPATH" "vendor" "$blob"
done

{
    echo "(allow init_33_0 tee_file (dir (mounton)))"
    echo "(allow priv_app_33_0 tee_file (dir (getattr)))"
    echo "(allow init_33_0 vendor_fw_file (file (mounton)))"
    echo "(allow priv_app_33_0 vendor_fw_file (file (getattr)))"
} >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil" || return 1