ifneq (iob_ram_t2p,$(filter $S, $(MODULES)))

# Sources
VSRC+=$(MEM_DIR)/hardware/ram/iob_ram_t2p/iob_ram_t2p.v

# Add to modules list
MODULES+=iob_ram_t2p

endif
