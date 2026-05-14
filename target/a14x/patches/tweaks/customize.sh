LOG "- Adding \"dalvik.vm.dex2oat64.enabled\" prop with \"true\" in \"/vendor/build.prop\""
EVAL "sed -i \"/zygote=zygote64_32/a dalvik.vm.dex2oat64.enabled=true\" \"$WORK_DIR/vendor/build.prop\""
EVAL "sed -i \"/wfd_use_single_plane_in_drm/i dalvik.vm.dex2oat64.enabled=true\" \"$WORK_DIR/vendor/build.prop\""