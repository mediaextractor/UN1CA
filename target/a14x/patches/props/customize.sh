EVAL "uniq \"$WORK_DIR/system/system/build.prop\" \"$WORK_DIR/system/system/tmp\" && mv -f \"$WORK_DIR/system/system/tmp\" \"$WORK_DIR/system/system/build.prop\""
LOG_STEP_IN "- Adding stock props"
LOG "- Adding \"persist.audio.deepbuffer_delay\" prop with \"33\" in /system/system/build.prop"
EVAL "sed -i \"/spatializer_enabled=true/a persist.audio.deepbuffer_delay=33\" \"$WORK_DIR/system/system/build.prop\""

LOG "- Adding \"debug.codec2.stop_hal_before_surface\" prop with \"1\" in /system/system/build.prop"
EVAL "sed -i \"/deepbuffer_delay/a debug.codec2.stop_hal_before_surface=1\" \"$WORK_DIR/system/system/build.prop\""

LOG "- Disabling \"bluetooth.server.automatic_turn_on\" in /product/etc/build.prop"
EVAL "sed -i \"s/\(bluetooth.server.automatic_turn_on\)=true/#\1?=true/\" \"$WORK_DIR/product/etc/build.prop\""

LOG "- Deleting \"bluetooth.core.le.max_number_of_concurrent_connections\" in /product/etc/build.prop"
EVAL "sed -i \"/SS_BLE_FEATURE/d\" \"$WORK_DIR/product/etc/build.prop\""
EVAL "sed -i \"/max_number_of_concurrent_connections/d\" \"$WORK_DIR/product/etc/build.prop\""

LOG "- Deleting \"ro.frp.pst\" in /product/etc/build.prop"
EVAL "sed -i \"/ro.frp.pst/d\" \"$WORK_DIR/product/etc/build.prop\""

LOG "- Adding \"ro.netflix.bsp_rev\" prop with \"EXYNOS1330-36497-1\" in /vendor/build.prop"
EVAL "sed -i \"/maxfiles/a ro.netflix.bsp_rev=EXYNOS1330-36497-1\" \"$WORK_DIR/vendor/build.prop\""
LOG_STEP_OUT
EVAL "sed -i \"/deepbuffer_delay/i ro.audio.spatializer_enabled=true\" \"$WORK_DIR/system/system/build.prop\""
EVAL "sed -i \"/PRODUCT_SYSTEM_DEFAULT_PROPERTIES/a ####################################\" \"$WORK_DIR/system/system/build.prop\""