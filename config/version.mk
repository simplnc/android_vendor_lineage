PRODUCT_VERSION_MAJOR = 1.0
PRODUCT_VERSION_MINOR = 0

# Increase CR Version with each major release.
BM_VERSION := testing

# Internal version
LINEAGE_VERSION := Bashamobile-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date +%Y%m%d)

# Display version
LINEAGE_DISPLAY_VERSION := v$(BM_VERSION)-$(shell date +%Y%m%d)

# LineageOS version properties
PRODUCT_SYSTEM_PROPERTIES += \
    ro.Bashamobile.build.version=$(BM_VERSION) \
    ro.Bashamobile.display.version=$(LINEAGE_DISPLAY_VERSION) \
    ro.Bashamobile.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)
