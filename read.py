import serial

ser = serial.Serial(
    port='/dev/ttyACM0',\
    baudrate=9600,\
    parity=serial.PARITY_NONE,\
    stopbits=serial.STOPBITS_ONE,\
    bytesize=serial.EIGHTBITS,\
        timeout=0)

print("connected to: " + ser.portstr)
count=1

str_line = []
while True:
    for line in ser.read():
        if str(line) == "\n":
            print "".join(str_line)
            str_line = []
        else:
            str_line.append(str(line))

ser.close()

