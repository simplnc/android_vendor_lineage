config: Clean up and organize additional product configurations  

- Comment out unused Lawnchair inclusion (# include vendor/lawnchair/lawnchair.mk)  
- Use consistent $(call inherit-product-if-exists) for additional configs  
- Keep related configs grouped together  

Sample changes:  
```makefile
# include vendor/lawnchair/lawnchair.mk  # Disabled unused Lawnchair  
$(call inherit-product-if-exists, vendor/lineage/config/microg.mk)  
$(call inherit-product-if-exists, vendor/lineage/config/branding.mk)  
$(call inherit-product-if-exists, vendor/lineage/config/custom.mk)  