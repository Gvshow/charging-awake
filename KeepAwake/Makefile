ARCHS = arm64
TARGET = iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KeepAwake
KeepAwake_FILES = Tweak.xm
KeepAwake_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
