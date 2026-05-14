LOG_STEP_IN "- Creating required permissions"
LOG "- Deleting \"<feature name=\"android.hardware.telephony.euicc\" />\" in /system/system/etc/permissions/privapp-permissions-com.samsung.euicc.xml"
EVAL "sed -i \"/android.hardware.telephony.euicc/d\" \
	\"$WORK_DIR/system/system/etc/permissions/privapp-permissions-com.samsung.euicc.xml\""
EVAL "sed -i \"/^$/d\" \
	\"$WORK_DIR/system/system/etc/permissions/privapp-permissions-com.samsung.euicc.xml\""

LOG "- Creating \"privapp-features-com.samsung.euicc.xml\" in /system/system/etc/permissions"
{
    echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
	echo "<!-- Feature for devices with an eUICC. -->"
    echo "<permissions>"
    echo "    <feature name=\"android.hardware.telephony.euicc\" />"
    echo "</permissions>"
} >> "$WORK_DIR/system/system/etc/permissions/privapp-features-com.samsung.euicc.xml"
SET_METADATA "system" "system/etc/permissions/privapp-features-com.samsung.euicc.xml" 0 0 644 "u:object_r:system_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Creating \"euicc_a54x.rc\" in /system/etc/init"
{
    echo "on early-init && property:ro.boot.em.model=SM-A546E"
	echo "    mount none /dev/null /system/etc/permissions/privapp-features-com.samsung.euicc.xml bind"
	echo ""
    echo "on early-init && property:ro.boot.em.model=SM-A5460"
	echo "    mount none /dev/null /system/etc/permissions/privapp-features-com.samsung.euicc.xml bind"
} >> "$WORK_DIR/system/system/etc/init/euicc_a54x.rc"
SET_METADATA "system" "system/etc/init/euicc_a54x.rc" 0 0 644 "u:object_r:system_file:s0"
LOG_STEP_OUT

echo "(allow init system_file (file (mounton)))" >> "$WORK_DIR/system/system/etc/selinux/plat_sepolicy.cil" || return 1