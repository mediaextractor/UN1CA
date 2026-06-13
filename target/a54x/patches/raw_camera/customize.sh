# Enable RAW Support
# Before: [
# mov w8,#0x1
# ]
# After: [
# b 0x0037ebcc
# ]
HEX_PATCH "$WORK_DIR/vendor/lib64/hw/camera.s5e8835.so" \
    "28008052291c0072" "13000014291c0072"
# Before: [
# sub sp,sp,#0x60
# stp x29,x30,[sp, #0x20]
# add x29,sp,#0x20
# stp x24,x23,[sp, #0x30]
# stp x22,x21,[sp, #0x40]
# stp x20,x19,[sp, #0x50]
# ]
# After: [
# stp xzr,xzr,[x8]
# str xzr,[x8, #0x10]
# ret
# mov w1,#0x3
# mov w8,#0x1
# b 0x0037eb84
HEX_PATCH "$WORK_DIR/vendor/lib64/hw/camera.s5e8835.so" \
    "ff8301d1fd7b02a9fd830091f85f03a9f65704a9f44f05a957d03bd5d6" \
		"1f7d00a91f0900f9c0035fd66100805228008052ecffff1757d03bd5d6"

LOG_STEP_IN "- Creating required permissions"
# https://android.googlesource.com/platform/frameworks/native/+/refs/tags/android-16.0.0_r1/data/etc/android.hardware.camera.raw.xml
{
    echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    echo "<!--"
    echo "    Copyright (c) 2014 The Android Open Source Project"
    echo "    SPDX-License-Identifier: Apache-2.0"
    echo "-->"
    echo "<permissions>"
    echo "    <feature name=\"android.hardware.camera.capability.raw\" />"
    echo "</permissions>"
} >> "$WORK_DIR/vendor/etc/permissions/android.hardware.camera.raw.xml"
SET_METADATA "vendor" "etc/permissions/android.hardware.camera.raw.xml" 0 0 644 "u:object_r:vendor_configs_file:s0"
LOG_STEP_OUT