How to get the code

git clone git@gitlab.alibaba-inc.com:thead-linux/npu-ax3386-kernel.git
How to build

Build within repo project
Build out of repo project
Build a buildroot of SoC project
Build kernel module:
cd driver
Modify PATH_TO_BUILDROOT in driver/build.mk
make -f build.mk CONFIG_VHA_THEAD_LIGHT_FPGA_C910=y
Description of each directories

driver/: Linux kernel module Driver.
The Vendor packages come from and extract target directories

From: https://partnerportal.imgtec.com/Component/Details/22492 (Upload Date: 25-Aug-2020)
NNA-REL_2.6-cl5777119-Linux-gpl_src.tar.gz: driver/
