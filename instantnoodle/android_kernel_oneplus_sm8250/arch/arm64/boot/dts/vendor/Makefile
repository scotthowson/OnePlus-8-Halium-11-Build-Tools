ifeq ($(CONFIG_BUILD_ARM64_DT_OVERLAY_NOT_OEM),y)
        dtbo-$(CONFIG_ARCH_KONA) += \
                kona-mtp-overlay.dtbo \



kona-mtp-overlay.dtbo-base := kona.dtb kona-v2.dtb kona-v2.1.dtb

endif


always		:= $(dtb-y)
subdir-y	:= $(dts-dirs)
clean-files    := *.dtb *.dtbo
