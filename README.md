How to build

Build within repo project
Build out of repo project
Build a buildroot of SoC project
Build kernel module:
cd driver
Modify PATH_TO_BUILDROOT in driver/build.mk
make -f build.mk CONFIG_VHA_THEAD_LIGHT=y
Description of each directories

driver/: Linux kernel module Driver.
The Vendor packages come from and extract target directories

From: https://partnerportal.imgtec.com/Component/Details/22970 (Publish Date: 12-Feb-2021)
NNA-REL_3.8-cl6140200-Linux-gpl_src.tar.gz: driver/
