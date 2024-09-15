#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        vendor/etc/camera/zeus_enhance_motiontuning.xml|vendor/etc/camera/zeus_motiontuning.xml)
            [ "$2" = "" ] && return 0
            sed -i 's/xml=version/xml version/g' "${2}"
            ;;
        vendor/etc/camera/pureShot_parameter.xml|vendor/etc/camera/pureView_parameter.xml)
            [ "$2" = "" ] && return 0
            sed -i 's/=\([0-9]\+\)>/="\1">/g' "${2}"
            ;;
        vendor/lib64/hw/audio.primary.taro-zeus.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF_0_17_2}" --set-soname "audio.primary.taro-zeus.so" "${2}"
            ;;
        vendor/lib64/hw/fingerprint.goodix_fod.default.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF_0_17_2}" --set-soname "fingerprint.goodix_fod.default.so" "${2}"
            ;;
        vendor/lib64/hw/fingerprint.goodix_fod6.default.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF_0_17_2}" --set-soname "fingerprint.goodix_fod6.default.so" "${2}"
            ;;
        vendor/lib64/libcamximageformatutils.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF_0_17_2}" --replace-needed "vendor.qti.hardware.display.config-V2-ndk_platform.so" "vendor.qti.hardware.display.config-V2-ndk.so" "${2}"
            ;;
       vendor/bin/hw/vendor.dolby.hardware.dms@2.0-service)
            "${PATCHELF}" --add-needed "libstagefright_foundation-v33.so" "${2}"
            ;;
        vendor/lib64/libkaraokepal.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF_0_17_2}" --replace-needed "audio.primary.taro.so" "audio.primary.taro-zeus.so" "${2}"
            ;;
        vendor/lib64/libSnpeCpu.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF_0_17_2}" --set-soname "libSnpeCpu.so" "${2}"
            ;;
        vendor/lib64/libSnpeGpu.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF_0_17_2}" --set-soname "libSnpeGpu.so" "${2}"
            ;;
        vendor/lib64/libSnpeHtpV69Stub.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF_0_17_2}" --set-soname "libSnpeHtpV69Stub.so" "${2}"
            ;;
        vendor/lib64/hw/camera.qcom.so | vendor/lib64/libFaceDetectpp-0.5.2.so | vendor/lib64/libfacedet.so)
            [ "$2" = "" ] && return 0
            sed -i "s|libmegface.so|libfacedet.so|g" "${2}"
            sed -i "s|libMegviiFacepp-0.5.2.so|libFaceDetectpp-0.5.2.so|g" "${2}"
            sed -i "s|megviifacepp_0_5_2_model|facedetectpp_0_5_2_model|g" "${2}"
            ;;
        *)
            return 1
            ;;
    esac
}

function blob_fixup_dry() {
    blob_fixup "$1" ""
}

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

export DEVICE=dagda
export DEVICE_COMMON=sm8450-common
export VENDOR=xiaomi
export VENDOR_COMMON=${VENDOR}

"./../../${VENDOR_COMMON}/${DEVICE_COMMON}/extract-files.sh" "$@"
