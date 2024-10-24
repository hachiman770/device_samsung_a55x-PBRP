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

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

# Inherit some common pb stuff.
$(call inherit-product, vendor/pb/config/common.mk)

# Inherit from a55x device
$(call inherit-product, device/samsung/a55x/device.mk)

# Check System uses Virtual AB system
EXYNOS_USE_VIRTUAL_AB := true

# Check Exynos Product support dedicated recovery image
# For Non-AB  -> Recovery Image is mandatory
# For AB      -> Recovery Image is optional
ifneq ($(EXYNOS_USE_VIRTUAL_AB), true)
EXYNOS_USE_DEDICATED_RECOVERY_IMAGE := true
endif

# If Target Support dedicated reocvery image, set property to build recovery image
ifeq ($(EXYNOS_USE_DEDICATED_RECOVERY_IMAGE), true)
PRODUCT_BUILD_RECOVERY_IMAGE := true
endif

# Device identifier. This must come after all inclusions
PRODUCT_DEVICE := a55x
PRODUCT_NAME := pb_a55x
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-A556E
PRODUCT_MANUFACTURER := samsung
PRODUCT_SHIPPING_API_LEVEL := 34

PRODUCT_GMS_CLIENTID_BASE := android-samsung-ss
