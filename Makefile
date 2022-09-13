##
 # Copyright (C) 2020 Alibaba Group Holding Limited
##
test = $(shell if [ -f "../.param" ]; then echo "exist"; else echo "noexist"; fi)
ifeq ("$(test)", "exist")
  include ../.param
endif

SDK_VER=v0.9

# Configurations options
CONFIG_DEBUG_MODE=0
ROOTFS_INSTALL=0
CONFIG_DUMMY_DRIVER=0

# Board
CONFIG_BOARD_LIGHT_FPGA_C910_ARRAY:=light_fpga_fm_c910 light-fm-fpga
CONFIG_BOARD_LIGHT_ARRAY:=light-fm light-%

ifneq ($(filter $(CONFIG_BOARD_LIGHT_FPGA_C910_ARRAY),$(BOARD_NAME)),)
  TARGET_NPU="IMG-AX3386"
  TARGE_CFG=CONFIG_VHA_THEAD_LIGHT_FPGA_C910=y
else
  ifneq ($(filter $(CONFIG_BOARD_LIGHT_ARRAY),$(BOARD_NAME)),)
    TARGET_NPU="IMG-AX3386"
    TARGE_CFG=CONFIG_VHA_THEAD_LIGHT=y
  else
    $(error "Undefined target board:$(BOARD_NAME)")
  endif
endif

ifeq ($(CONFIG_DUMMY_DRIVER),1)
  TARGE_CFG=CONFIG_VHA_DUMMY=y
endif


CONFIG_BUILD_DRV_EXTRA_PARAM:=""

ifeq ("$(BUILD_SYSTEM)","YOCTO_BUILD")
  export PATH_TO_SYSROOT=${SYSROOT_DIR}
  export TOOLSCHAIN_PATH=${TOOLCHAIN_DIR}
  export TOOLCHAIN_HOST=${CROSS_COMPILE}
else
  export PATH_TO_SYSROOT=${BUILDROOT_DIR}/output/host/riscv64-buildroot-linux-gnu/sysroot
  export TOOLSCHAIN_PATH=${BUILDROOT_DIR}/output/host
  export TOOLCHAIN_HOST=${TOOLSCHAIN_PATH}/bin/riscv64-unknown-linux-gnu-
endif
export PATH_TO_BUILDROOT=$(BUILDROOT_DIR)

DIR_TARGET_BASE=bsp/npu
DIR_TARGET_KO  =bsp/npu/ko

MODULE_NAME=NPU
BUILD_LOG_START="\033[47;30m>>> $(MODULE_NAME) $@ begin\033[0m"
BUILD_LOG_END  ="\033[47;30m<<< $(MODULE_NAME) $@ end\033[0m"

#
# Do a parallel build with multiple jobs, based on the number of CPUs online
# in this system: 'make -j8' on a 8-CPU system, etc.
#
# (To override it, run 'make JOBS=1' and similar.)
#
ifeq ($(JOBS),)
  JOBS := $(shell grep -c ^processor /proc/cpuinfo 2>/dev/null)
  ifeq ($(JOBS),)
    JOBS := 1
  endif
endif

all:    info driver install_local install_rootfs
.PHONY: info driver install_local install_rootfs \
        install_prepare clean_driver clean_local clean_rootfs clean

info:
	@echo $(BUILD_LOG_START)
	@echo "  ====== Build Info from repo project ======"
	@echo "    BUILD_SYSTEM="$(BUILD_SYSTEM)
	@echo "    BUILDROOT_DIR="$(BUILDROOT_DIR)
	@echo "    SYSROOT_DIR="$(SYSROOT_DIR)
	@echo "    CROSS_COMPILE="$(CROSS_COMPILE)
	@echo "    LINUX_DIR="$(LINUX_DIR)
	@echo "    ARCH="$(ARCH)
	@echo "    BOARD_NAME="$(BOARD_NAME)
	@echo "    KERNEL_ID="$(KERNELVERSION)
	@echo "    KERNEL_DIR="$(LINUX_DIR)
	@echo "    CC="$(CC)
	@echo "    CXX="$(CXX)
	@echo "    LD="$(LD)
	@echo "    LD_LIBRARY_PATH="$(LD_LIBRARY_PATH)
	@echo "    rpath="$(rpath)
	@echo "    rpath-link="$(rpath-link)
	@echo "    INSTALL_DIR_ROOTFS="$(INSTALL_DIR_ROOTFS)
	@echo "    INSTALL_DIR_SDK="$(INSTALL_DIR_SDK)
	@echo "  ====== Build config by current module ======"
	@echo "    TARGET_NPU="$(TARGET_NPU)
	@echo "    CONFIG_DEBUG_MODE="$(CONFIG_DEBUG_MODE)
	@echo "    TARGE_CFG="$(TARGE_CFG)
	@echo "    CONFIG_BUILD_DRV_EXTRA_PARAM="$(CONFIG_BUILD_DRV_EXTRA_PARAM)
	@echo "    SDK_VERSION="$(SDK_VER)
	@echo $(BUILD_LOG_END)

driver:
	@echo $(BUILD_LOG_START)
	make -C driver -f build.mk $(TARGE_CFG)
	@echo $(BUILD_LOG_END)

clean_driver:
	@echo $(BUILD_LOG_START)
	make -C driver -f build.mk $(TARGE_CFG) clean
	rm -rf ./output/rootfs/$(DIR_TARGET_KO)
	@echo $(BUILD_LOG_END)

install_prepare:
	mkdir -p ./output/rootfs/$(DIR_TARGET_KO)

install_local: driver install_prepare
	@echo $(BUILD_LOG_START)
	find ./driver -name "*.ko" | xargs -i cp -f {} ./output/rootfs/$(DIR_TARGET_KO)
	@if [ `command -v tree` != "" ]; then \
	    tree ./output/rootfs;             \
	fi
	@echo $(BUILD_LOG_END)

install_rootfs: install_local
	@echo $(BUILD_LOG_START)
	@if [ $(ROOTFS_INSTALL) -eq 1 ]; then \
	    mkdir -p $(INSTALL_DIR_ROOTFS)/$(DIR_TARGET_BASE); \
	    rm -rf $(INSTALL_DIR_ROOTFS)/$(DIR_TARGET_BASE)/*; \
	    cp -r output/rootfs/$(DIR_TARGET_BASE)/* $(INSTALL_DIR_ROOTFS)/$(DIR_TARGET_BASE); \
	fi
	@echo $(BUILD_LOG_END)

clean_local:
	rm -rf ./output

clean_rootfs:
	if [ -d "$(INSTALL_DIR_ROOTFS)/$(DIR_TARGET_BASE)" ]; then \
	    rm -rf $(INSTALL_DIR_ROOTFS)/$(DIR_TARGET_BASE); \
	fi

clean: clean_driver clean_local clean_rootfs 

