# Only enable on debug builds
if ! $DEBUG; then
    LOG "\033[0;33m! Non-debug build detected. Skipping\033[0m"
    return 0
fi

# No recovery with data decryption available
LOG_STEP_IN "- Disabling data encryption"
LINE=$(sed -n "/^\/dev\/block\/by-name\/userdata/=" "$WORK_DIR/vendor/etc/fstab.s5e8535")
sed -i "${LINE}s/,fileencryption=aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized+wrappedkey_v0//g" "$WORK_DIR/vendor/etc/fstab.s5e8535"
LOG_STEP_OUT
