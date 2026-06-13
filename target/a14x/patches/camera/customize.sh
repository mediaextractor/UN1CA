SKIPUNZIP=1
# Add camera libs
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libFood.camera.samsung.so" 0 0 644 "u:object_r:system_lib_file:s0"
EVAL "echo \"libFood.camera.samsung.so\" >> \"$WORK_DIR/system/system/etc/public.libraries-camera.samsung.txt\""
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libFoodDetector.camera.samsung.so" 0 0 644 "u:object_r:system_lib_file:s0"
EVAL "echo \"libFoodDetector.camera.samsung.so\" >> \"$WORK_DIR/system/system/etc/public.libraries-camera.samsung.txt\""
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libhigh_dynamic_range.arcsoft.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libhumantracking_util.camera.samsung.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/liblow_light_hdr.arcsoft.so" 0 0 644 "u:object_r:system_lib_file:s0"

# Upgrade midas blobs
ADD_TO_WORK_DIR "a73xqxx" "vendor" "etc/midas" 0 2000 755 "u:object_r:vendor_configs_file:s0"

# Fix Photo Remaster
EVAL "echo \"ro.midas.device u:object_r:build_prop:s0 exact string\"  >> \"$WORK_DIR/system/system/etc/selinux/plat_property_contexts\""
SET_PROP "system" "ro.midas.device" "a14x"
HEX_PATCH "$WORK_DIR/system/system/lib64/libmidas_core.camera.samsung.so" \
    "726f2e70726f647563742e646576696365" "726f2e6d696461732e6465766963650000"