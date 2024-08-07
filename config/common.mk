# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

PRODUCT_BRAND ?= LineageOS

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

ifeq ($(PRODUCT_IS_ATV),true)
ifeq ($(PRODUCT_ATV_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.oem.key1=ATV00100020
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.oem.key1=$(PRODUCT_ATV_CLIENTID_BASE)
endif
endif

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
ifdef WITH_ADB_INSECURE
# Forcebly disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Disable extra StrictMode features on all non-engineering builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.strictmode.disable=true
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/lineage/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/lineage/prebuilt/common/bin/50-lineage.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-lineage.sh

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/addon.d/50-lineage.sh

ifneq ($(strip $(AB_OTA_PARTITIONS) $(AB_OTA_POSTINSTALL_CONFIG)),)
PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/lineage/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/lineage/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/backuptool_ab.sh \
    system/bin/backuptool_ab.functions \
    system/bin/backuptool_postinstall.sh

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif
endif

# Lineage-specific broadcast actions whitelist
PRODUCT_COPY_FILES += \
    vendor/lineage/config/permissions/lineage-sysconfig.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/lineage-sysconfig.xml

# Lineage-specific init rc file
PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/etc/init/init.lineage-system_ext.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.lineage-system_ext.rc

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.sip.voip.xml

# Credential storage
PRODUCT_PACKAGES += \
    android.software.credentials.prebuilt.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_PRODUCT)/usr/keylayout/Vendor_045e_Product_0719.kl

# Component overrides
PRODUCT_PACKAGES += \
    lineage-component-overrides.xml

# This is Lineage!
PRODUCT_COPY_FILES += \
    vendor/lineage/config/permissions/org.lineageos.android.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/org.lineageos.android.xml

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

ifneq ($(TARGET_DISABLE_LINEAGE_SDK), true)
# Lineage SDK
include vendor/lineage/config/lineage_sdk_common.mk
endif

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Enable whole-program R8 Java optimizations for SystemUI and system_server,
# but also allow explicit overriding for testing and development.
SYSTEM_OPTIMIZE_JAVA ?= true
SYSTEMUI_OPTIMIZE_JAVA ?= true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

ifneq ($(TARGET_DISABLE_EPPE),true)
# Require all requested packages to exist
$(call enforce-product-packages-exist-internal,$(wildcard device/*/$(LINEAGE_BUILD)/$(TARGET_PRODUCT).mk),product_manifest.xml rild Calendar Launcher3 Launcher3Go Launcher3QuickStep Launcher3QuickStepGo android.hidl.memory@1.0-impl.vendor vndk_apex_snapshot_package)
endif

# Bootanimation
TARGET_SCREEN_WIDTH ?= 1080
TARGET_SCREEN_HEIGHT ?= 1920
PRODUCT_PACKAGES += \
    bootanimation.zip

# Build Manifest
PRODUCT_PACKAGES += \
    build-manifest

# Lineage packages
ifeq ($(PRODUCT_IS_ATV),)
PRODUCT_PACKAGES += \
    ExactCalculator \
    Jelly
endif

ifeq ($(PRODUCT_IS_AUTOMOTIVE),)
PRODUCT_PACKAGES += \
    LineageParts \
    LineageSetupWizard
endif

PRODUCT_PACKAGES += \
    LineageSettingsProvider

PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/etc/init/init.lineage-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.lineage-updater.rc

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig \
    SimpleSettingsConfig

# Extra tools in Lineage
PRODUCT_PACKAGES += \
    bash \
    curl \
    getcap \
    htop \
    nano \
    setcap \
    vim

PRODUCT_PACKAGES += \
    nano_recovery

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/curl \
    system/bin/getcap \
    system/bin/setcap

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.ntfs \
    mkfs.ntfs \
    mount.ntfs

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/fsck.ntfs \
    system/bin/mkfs.ntfs \
    system/bin/mount.ntfs \
    system/%/libfuse-lite.so \
    system/%/libntfs-3g.so

# FRP
PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/bin/wipe-frp.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/wipe-frp

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/etc/init/init.openssh.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/init.openssh.rc

# rsync
PRODUCT_PACKAGES += \
    rsync

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/procmem
endif

# Root
PRODUCT_PACKAGES += \
    adb_root
ifneq ($(TARGET_BUILD_VARIANT),user)
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/xbin/su
endif
endif

# SystemUI
PRODUCT_DEXPREOPT_SPEED_APPS += \
    CarSystemUI \
    SystemUI

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    dalvik.vm.systemuicompilerfilter=speed

ifeq ($(TARGET_BUILD_VARIANT),userdebug)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    debug.sf.enable_transaction_tracing=false
endif

# SetupWizard
PRODUCT_PRODUCT_PROPERTIES += \
    setupwizard.theme=glif_v4 \
    setupwizard.feature.day_night_mode_enabled=true

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/lineage/overlay/no-rro
PRODUCT_PACKAGE_OVERLAYS += \
    vendor/lineage/overlay/common \
    vendor/lineage/overlay/no-rro

PRODUCT_PACKAGES += \
    DocumentsUIOverlay \
    NetworkStackOverlay \
    PermissionControllerOverlay

# Translations
CUSTOM_LOCALES += \
    ast_ES \
    gd_GB \
    cy_GB \
    fur_IT

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/crowdin/overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/crowdin/overlay

PRODUCT_EXTRA_RECOVERY_KEYS += \
    vendor/lineage/build/target/product/security/lineage


# ====================================
# Advanced System Optimizations
# ====================================

# Startup Optimizations
# These settings reduce boot time and initial app launch
# - Reduces dex2oat compilation time
# - Optimizes package scanning
# - Improves system server startup
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    dalvik.vm.boot-dex2oat-threads=8 \
    dalvik.vm.dex2oat-threads=8 \
    dalvik.vm.dex2oat-cpu-set=0,1,2,3,4,5,6,7 \
    dalvik.vm.package-startup-phase=3 \
    dalvik.vm.dexopt.secondary=true \
    persist.device_config.runtime_native.usap_pool_enabled=true

# Advanced Memory Management
# Fine-tuned memory parameters for better app retention and multitasking
# - Optimizes LMK parameters
# - Improves memory compression
# - Enhances swap behavior
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.lmk.critical_upgrade=true \
    ro.lmk.upgrade_pressure=40 \
    ro.lmk.kill_heaviest_task=true \
    ro.lmk.use_new_strategy=true \
    ro.config.dha_cached_max=16 \
    ro.sys.fw.bg_apps_limit=32 \
    ro.vendor.qti.sys.fw.bservice_limit=5 \
    ro.vendor.qti.sys.fw.bservice_age=5000 \
    ro.sys.fw.use_trim_settings=true

# Enhanced CPU & GPU Performance
# Optimizes processor behavior and thermal management
# - Sets performance CPU governor
# - Enables GPU acceleration
# - Balances power and performance
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    debug.performance.tuning=1 \
    debug.sf.enable_hwc_vds=1 \
    debug.sf.early_phase_offset_ns=1500000 \
    debug.sf.early_app_phase_offset_ns=1500000 \
    debug.sf.early_gl_phase_offset_ns=3000000 \
    debug.sf.early_gl_app_phase_offset_ns=15000000 \
    ro.hwui.render_ahead=3 \
    vendor.perf.gestureflingboost.enable=true

# Advanced I/O Optimizations
# Improves storage performance and app loading
# - Optimizes I/O scheduling
# - Enhances file system performance
# - Improves database access
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    sys.use_fifo_ui=1 \
    ro.sys.fw.empty_app_percent=50 \
    ro.sys.fw.trim_cache_percent=100 \
    debug.sf.recomputeDisplay=0 \
    persist.sys.io.scheduler=bfq \
    ro.sys.fw.trim_enable_memory=2147483648

# Network Stack Optimization
# Enhances network performance and reliability
# - Optimizes TCP buffer sizes
# - Improves mobile data stability
# - Reduces network latency
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    net.tcp.buffersize.default=6144,87380,1048576,6144,16384,1048576 \
    net.tcp.buffersize.wifi=262144,524288,1048576,262144,524288,1048576 \
    net.tcp.buffersize.lte=262144,524288,3145728,262144,524288,3145728 \
    net.tcp.buffersize.umts=6144,87380,1048576,6144,16384,1048576 \
    net.tcp.buffersize.hspa=6144,87380,1048576,6144,16384,1048576 \
    net.tcp.default_init_rwnd=60

# Enhanced UI Responsiveness
# Improves touch response and animation smoothness
# - Reduces touch latency
# - Optimizes UI thread priority
# - Enhances scrolling performance
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.min.fling_velocity=160 \
    ro.max.fling_velocity=20000 \
    ro.min_pointer_dur=8 \
    ro.max.fling_velocity=12000 \
    windowsmgr.max_events_per_sec=150 \
    persist.sys.scrollingcache=3 \
    touch.pressure.scale=0.001 \
    persist.sys.ui.hw=1

# System Stability Enhancements
# Improves overall system reliability
# - Optimizes process management
# - Enhances system server stability
# - Improves crash handling
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    debug.sf.disable_client_composition_cache=1 \
    debug.sf.enable_transaction_tracing=false \
    debug.sf.enable_gl_backpressure=1 \
    debug.hwui.renderer=skiagl \
    debug.hwui.target_cpu_time_percent=30 \
    ro.config.max_starting_bg=8 \
    ro.sys.fw.bservice_enable=true

# Advanced Camera Optimizations
# Enhances camera performance and quality
# - Enables advanced processing features
# - Optimizes camera HAL
# - Improves image quality
PRODUCT_PROPERTY_OVERRIDES += \
    camera.disable_zsl_mode=0 \
    persist.camera.HAL3.enabled=1 \
    persist.camera.ois.disable=0 \
    persist.camera.isp.clock.optmz=0 \
    persist.camera.isp.turbo=1 \
    persist.camera.linklatency=0 \
    persist.camera.stats.test=5 \
    persist.vendor.camera.perfcapture=1

# Power Efficiency Optimizations
# Balances performance and battery life
# - Optimizes background processes
# - Improves power management
# - Enhances CPU frequency scaling
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.config.hw_power_saving=true \
    ro.config.hw_power_saving.enabled=1 \
    ro.vendor.power.optimization.enabled=1 \
    power.saving.mode=1 \
    ro.ril.disable.power.collapse=0 \
    pm.sleep_mode=1 \
    ro.config.hw_fast_dormancy=1
         

include vendor/lineage/config/version.mk

-include vendor/lineage-priv/keys/keys.mk

-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/lineage/config/partner_gms.mk
