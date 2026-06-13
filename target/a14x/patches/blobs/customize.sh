# rscmgr
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/init/rscmgr_a14x.rc" 0 0 644 "u:object_r:system_file:s0"

# Audio
DELETE_FROM_WORK_DIR "system" "system/lib/lib_SoundAlive_play_plus_ver800.so"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib/lib_SoundAlive_play_plus_ver500.so" 0 0 644 "u:object_r:system_lib_file:s0"
DELETE_FROM_WORK_DIR "system" "system/lib64/lib_SoundAlive_play_plus_ver800.so"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/lib_SoundAlive_play_plus_ver500.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib/libaudiosaplus_sec_legacy.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libaudiosaplus_sec_legacy.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libsamsungSoundbooster_plus_legacy.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libsamsungSoundbooster_plus_legacy.so" 0 0 644 "u:object_r:system_lib_file:s0"

LOG_STEP_IN "- Replacing HWUI"
ADD_TO_WORK_DIR "r9sxxx" "system" "system/lib/libhwui.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "r9sxxx" "system" "system/lib64/libhwui.so" 0 0 644 "u:object_r:system_lib_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Deleting OK Google Hotword Enrollment blobs"
DELETE_FROM_WORK_DIR "product" "priv-app/HotwordEnrollmentXGoogleEx4CORTEXM55"
DELETE_FROM_WORK_DIR "product" "priv-app/HotwordEnrollmentOKGoogleEx4CORTEXM55"
LOG_STEP_OUT
