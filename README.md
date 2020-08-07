# IOb-mem #

Memory modules used in IOb-SoC. For more information, please check: [IOb-SoC](https://github.com/IObundle/iob-soc)

### Compile all memory modules ###

Just type `make`.

### Compile specific memory module ###

Type `make <path-to-module>`.

If you need an external file, create a Makefile in your folder as such:

```
VSRC += ../folder/file.v

run:
	$(CMPLR) $(VSRC) 
	./a.out

clean:
	@rm -f ./a.out *.vcd

.PHONY: clean
```

### Generate Value change dump ###
Type `make VCD=1`