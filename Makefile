GO_EASY_ON_ME = 1
ARCHS = armv7 arm64

include theos/makefiles/common.mk
TWEAK_NAME = MBEPatch
MBEPatch_FILES = Tweak.xm
MBEPatch_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
