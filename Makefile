ARCHS=arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = app-settings
app-settings_FILES = Tweak.m
app-settings_LDFLAGS = -stdlib=libc++

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
