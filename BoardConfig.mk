#
# Copyright (C) 2023 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

DEVICE_PATH := device/samsung/a55x

# For building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true

# Build Hack
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# A/B
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    vendor_boot \
    dtbo \
    vbmeta \
    vbmeta_system \
    odm \
    product \
    system \
    system_ext \
    system_dlkm \
    vendor \
    vendor_dlkm

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := cortex-a76

# APEX
DEXPREOPT_GENERATE_APEX_IMAGE := true

# Extra mount point
BOARD_ROOT_EXTRA_SYMLINKS += /mnt/vendor/efs:/efs
BOARD_ROOT_EXTRA_SYMLINKS += /mnt/vendor/persist:/persist

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := s5e8845
TARGET_NO_BOOTLOADER := true
TARGET_BOARD_PLATFORM_GPU := sgpu

# Display
TARGET_SCREEN_DENSITY := 450

# Skia backend
TARGET_USES_VULKAN := true

# Kernel
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_BASE := 0x10000000
BOARD_KERNEL_CMDLINE := bootconfig
BOARD_BOOTCONFIG += buildtime_bootconfig="enable"
BOARD_BOOTCONFIG += androidboot.serialconsole=0 loop.max_part=7
BOARD_KERNEL_PAGESIZE := 2048
BOARD_RAMDISK_OFFSET := 0x00000000
BOARD_KERNEL_TAGS_OFFSET := 0x00000000
BOARD_DTB_OFFSET := 0x00000000
BOARD_RECOVERY_HEADER_VERSION := 2
BOARD_KERNEL_IMAGE_NAME := Image

BOARD_RAMDISK_USE_LZ4 := true
BOARD_USES_GENERIC_KERNEL_IMAGE := true
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT := true

# prebuilt
BOARD_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb.img
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/dtbo.img
INSTALLED_DTBIMAGE_TARGET := $(BOARD_PREBUILT_DTB)

BOARD_VENDOR_RAMDISK_FRAGMENTS := dlkm
BOARD_VENDOR_RAMDISK_FRAGMENT.dlkm.PREBUILT := $(DEVICE_PATH)/prebuilt/ramdisk.lz4
BOARD_VENDOR_RAMDISK_FRAGMENT.dlkm.MKBOOTIMG_ARGS := --board_id0 0x00000000 --ramdisk_type DLKM

# recovery mode
ifeq ($(EXYNOS_USE_DEDICATED_RECOVERY_IMAGE), true)
BOARD_INCLUDE_RECOVERY_DTBO := true
BOARD_RECOVERY_CMDLINE := $(BOARD_BOOTCONFIG)
BOARD_RECOVERY_CMDLINE += $(BOARD_KERNEL_CMDLINE)
BOARD_RECOVERY_MKBOOTIMG_ARGS := \
  --ramdisk_offset $(BOARD_RAMDISK_OFFSET) \
  --tags_offset $(BOARD_KERNEL_TAGS_OFFSET) \
  --header_version $(BOARD_RECOVERY_HEADER_VERSION) --board "SRPWK16A005" \
  --dtb $(INSTALLED_DTBIMAGE_TARGET) \
  --dtb_offset $(BOARD_DTB_OFFSET) \
  --pagesize $(BOARD_KERNEL_PAGESIZE) \
  --recovery_dtbo $(BOARD_PREBUILT_DTBOIMAGE) \
  --cmdline "$(BOARD_RECOVERY_CMDLINE)" \

endif

BOARD_MKBOOTIMG_ARGS := \
  --ramdisk_offset $(BOARD_RAMDISK_OFFSET) \
  --tags_offset $(BOARD_KERNEL_TAGS_OFFSET) \
  --header_version $(BOARD_BOOT_HEADER_VERSION) --board "SRPWK16A005" \
  --dtb $(INSTALLED_DTBIMAGE_TARGET) \
  --dtb_offset $(BOARD_DTB_OFFSET) \
  --pagesize $(BOARD_KERNEL_PAGESIZE)

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := $(BOARD_BOOTIMAGE_PARTITION_SIZE)
BOARD_DTBOIMG_PARTITION_SIZE := 8388608
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE := 16777216
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_SYSTEMIMAGE_PARTITION_TYPE := erofs
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SUPER_PARTITION_SIZE := 9848225792
BOARD_SUPER_PARTITION_GROUPS := samsung_dynamic_partitions
BOARD_SAMSUNG_DYNAMIC_PARTITIONS_PARTITION_LIST := system vendor vendor_dlkm system_dlkm
BOARD_SAMSUNG_DYNAMIC_PARTITIONS_SIZE := 4919918592

# Workaround for error copying vendor files to recovery ramdisk
TARGET_COPY_OUT_VENDOR := vendor

# Properties
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# Platform
TARGET_BOARD_PLATFORM := erd8845
TARGET_SOC := s5e8845

# Resolution
TARGET_SCREEN_HEIGHT := 2340
TARGET_SCREEN_WIDTH := 1080

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

TARGET_NO_RECOVERY := true
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE :=
BOARD_USES_FULL_RECOVERY_IMAGE :=

ifeq ($(AB_OTA_UPDATER), true)
# move recovery ramdisk to vendor_boot
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true

## remove /lib/modules in recovery ramdisk
BOARD_RECOVERY_KERNEL_MODULES :=
endif

# Use mke2fs to create ext4 images
TARGET_USES_MKE2FS := true

# Metadata encryption
BOARD_USES_METADATA_PARTITION := true

# AVB
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3

BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1

BOARD_AVB_VENDOR_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_VENDOR_BOOT_ALGORITHM := SHA256_RSA4096
BOARD_AVB_VENDOR_BOOT_ROLLBACK_INDEX := 0
BOARD_AVB_VENDOR_BOOT_ROLLBACK_INDEX_LOCATION := 2

# Hack: prevent anti rollback
PLATFORM_VERSION := 14
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2099-12-31
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# TWRP Configuration
TW_MAX_BRIGHTNESS := 200
TW_DEFAULT_BRIGHTNESS := 100
TW_NO_HAPTICS := true
TW_THEME := portrait_hdpi
TW_EXTRA_LANGUAGES := true
TW_SCREEN_BLANK_ON_BOOT := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_USE_TOOLBOX := true
TW_INCLUDE_REPACKTOOLS := true

# Debug
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true

# Samsung reboot menu
TW_NO_REBOOT_BOOTLOADER := true
TW_HAS_DOWNLOAD_MODE := true
