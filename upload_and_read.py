import serial
import os


def main():

    gen_hex = "avr-objcopy -O ihex -R .eeprom serial_stdio serial_stdio.hex"
    upload = "avrdude -c arduino -p atmega328p -P /dev/ttyACM0 -b 115200 -C /home/avj/arduino-1.6.9/hardware/tools/avr/etc/avrdude.conf  -U flash:w:serial_stdio.hex"

    os.system(gen_hex)
    os.system(upload)

    ser = serial.Serial(
        port='/dev/ttyACM0',
        baudrate=9600,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        bytesize=serial.EIGHTBITS,
        timeout=0)

    print("connected to: " + ser.portstr)
    count = 1

    str_line = []
    harness_end = False
    while not harness_end:
        for line in ser.read():
            if str(line) == "\n":
                full_line = "".join(str_line).lstrip().rstrip()
                print full_line
                if full_line == "STDIO Serial Hello. Line: [10]":
                    harness_end = True
                    break
                str_line = []
            else:
                str_line.append(str(line))

    ser.close()

if __name__ == "__main__":
    main()

# EOF
