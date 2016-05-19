TARGET=serial_stdio
SOURCES=main.c 

DEPS=
COBJ=$(SOURCES:.c=.o)
PCA_PREFIX=/home/avj/arduino/pca

CC=avr-gcc
OBJC=avr-objcopy
MCU=atmega328p
CFLAGS=-I. -I$(PCA_PREFIX)/include/ -Wall -Os -DF_CPU=16000000UL -std=c99
LDFLAGS=-lpca -L$(PCA_PREFIX)

ISPPORT=/dev/ttyACM0
ISPDIR=/home/avj/arduino-1.6.9/hardware/tools
ISP=$(ISPDIR)/avr/bin/avrdude
ISPFLAGS=-c arduino -p $(MCU) -P $(ISPPORT) -b 115200 -C $(ISPDIR)/avr/etc/avrdude.conf 

all: $(TARGET)

%.o: %.c $(DEPS)
	@echo -e "\tCC" $<
	echo @$(CC) -mmcu=$(MCU) -c -o $@ $< $(CFLAGS)
	@$(CC) -mmcu=$(MCU) -c -o $@ $< $(CFLAGS)

libpca.a:
	@echo -e "\tBUILDING PURE C ARDUINO LIB"
	$(MAKE) -C $(PCA_PREFIX)

$(TARGET): $(COBJ) libpca.a
	@echo -e "\tLINKING CC" $<
	@$(CC) -mmcu=$(MCU) -o $(TARGET) $(COBJ) $(LDFLAGS)
	$(OBJC) -O ihex -R .eeprom $(TARGET) $(TARGET).hex

clean:
	$(MAKE) -C $(PCA_PREFIX) clean
	@echo ========== cleanup ========== 
	rm -rf *.o *.hex $(TARGET)	

read:
	$(ISP) $(ISPFLAGS) -U flash:r:$(TARGET)_backup.hex:i

install: $(TARGET)
	$(ISP) $(ISPFLAGS) -U flash:w:$(TARGET).hex
