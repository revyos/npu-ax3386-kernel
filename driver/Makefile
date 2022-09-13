ifeq ($(CONFIG_VHA_NEXEF), y)
  obj-$(CONFIG_VHA) += nexef_platform/
endif
obj-$(CONFIG_VHA) += vha/ img_mem/
#obj-$(CONFIG_DMA_SHARED_BUFFER) += dmabuf_exporter/
obj-$(CONFIG_LOKI) += fenrir_loki/

subdir-ccflags-y += -I$(src)/include
# if CONFIG_DYNAMIC_DEBUG is not defined kernel wide as in Android 11+, 
# we still can use the facility if CONFIG_DYNAMIC_DEBUG_CORE is defined
subdir-ccflags-$(CONFIG_DYNAMIC_DEBUG_CORE) += -DDYNAMIC_DEBUG_MODULE

# if building the kernel module in-tree, these config options
# should be put into a Kconfig file.
# if building out-of-tree, defining them here is as good as any.
# CONFIG_VHA: build the VHA driver

# hardware options:
# CONFIG_VHA_DUMMY:        driver runs without hardware
# CONFIG_VHA_DUMMY_HW_SIM: driver runs without hardware but simulates hw processing time
# CONFIG_VHA_PCI:          driver runs with generic PCI hardware
# CONFIG_VHA_EMU:          driver runs with hardware emulator using legacy ICE interface
# CONFIG_VHA_FROST:        driver runs with hardware emulator using ICE2 interface
# CONFIG_VHA_APOLLO:       driver runs with IMG Apollo TCF5/TCF6 fpga hardware
# CONFIG_VHA_ORION:        driver runs with IMG Orion/SFF hardware
# CONFIG_VHA_ODIN:         driver runs with IMG Odin TCF5/TCFVU fpga hardware
# CONFIG_VHA_NEXEF:        driver runs with the 3NX-F base platform driver
# CONFIG_VHA_DT_EXAMPLE:   driver example using a device tree

# CONFIG_VHA_SERIES : either AX2 or AX3
# CONFIG_HW_AX2:      driver runs AX2145 and AX2185 hardware
# CONFIG_HW_AX3:      driver runs AX31xx/AX33xx/AX35xx hardware
# CONFIG_HW_AX3_MC/CONFIG_HW_MULITCORE: driver runs AXAX3797 multicore hardware

# system configuration options
# CONFIG_VHA_SYS_MIRAGE:   driver runs with Mirage system configuration file. It is set by default when CONFIG_HW_AX2 is set. 
# CONFIG_VHA_SYS_AURA:     driver runs with Aura system configuration file. It is set by default when CONFIG_HW_AX3 is set. 
# CONFIG_VHA_SYS_VAGUS:    driver runs with Vagus system configuration file. Applicable when CONFIG_HW_AX3 is set.
# CONFIG_VHA_SYS_MAGNA:    driver runs with Magna system configuration file. It is set by default when CONFIG_HW_MULTICORE is set.

# misc options:
# CONFIG_TARGET_OSID:           driver is compiled for selected OS id. Default: 0 (OS0), Applicable for CONFIG_HW_AX3 only. 
# CONFIG_VHA_MMU_MIRRORED_CTX:  driver is compiled with mirrored MMU page tables regarding MODEL & IO. Default: enabled, Applicable for CONFIG_HW_AX3 only. 
# CONFIG_VHA_SCF:               driver is compiled with safety critical features. Default: enabled, Applicable for CONFIG_VHA_SYS_VAGUS & CONFIG_VHA_SYS_MAGNA.
# CONFIG_VHA_NCORES:            driver is compiled for specified number of cores. Default: 6, Applicable for CONFIG_HW_MULITCORE.
# CONFIG_VHA_ENHANCED_APM:      driver is compiled to support Enhanced Active Power Management. Default: enabled, Applicable for CONFIG_HW_MULITCORE.
# CONFIG_VHA_LO_PRI_SUBSEGS:    driver is compiled to support low priority subsegments. Default: disabled, Applicable for CONFIG_HW_AX3 only.
 

