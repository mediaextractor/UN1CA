# Copyright (c) 2023 Salvo Giangreco
# SPDX-License-Identifier: GPL-3.0-or-later

# Debloat list for Galaxy A54 5G (a54x)
# - Add entries inside the specific partition containing that file (<PARTITION>_DEBLOAT+="")
# - DO NOT add the partition name at the start of any entry (eg. "/system/dpolicy_system")
# - DO NOT add a slash at the start of any entry (eg. "/dpolicy_system")

# DevGPUDriver
SYSTEM_DEBLOAT+="
system/priv-app/DevGPUDriver-EX2200
"

# GameDriver
SYSTEM_DEBLOAT+="
system/priv-app/GameDriver-EX2200
"

# Heatmap
SYSTEM_DEBLOAT+="
system/bin/heatmap
system/etc/init/init.sec-heatmap.rc
system/lib64/libectcore.so
system/lib64/libparam_A55_250328.so
"

# mAFPC
SYSTEM_DEBLOAT+="
system/bin/mafpc_write
"

# Overlays
SYSTEM_DEBLOAT+="
system/app/WifiRROverlayAppLls
system/app/WifiRROverlayAppWifiLock
"
PRODUCT_DEBLOAT+="
overlay/SoftapOverlayQC
"
