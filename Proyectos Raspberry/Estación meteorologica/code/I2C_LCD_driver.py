import smbus2
from time import sleep
# Dirección del LCD
I2C_ADDR = 0x27
LCD_WIDTH = 16

# Constantes
LCD_CHR = 1
LCD_CMD = 0
LINE_1 = 0x80
LINE_2 = 0xC0

E_PULSE = 0.0005
E_DELAY = 0.0005

class lcd:
    def __init__(self):
        self.bus = smbus2.SMBus(1)
        self.lcd_init()

    def lcd_init(self):
        self.lcd_byte(0x33, LCD_CMD)
        self.lcd_byte(0x32, LCD_CMD)
        self.lcd_byte(0x06, LCD_CMD)
        self.lcd_byte(0x0C, LCD_CMD)
        self.lcd_byte(0x28, LCD_CMD)
        self.lcd_byte(0x01, LCD_CMD)
        sleep(E_DELAY)

    def lcd_byte(self, bits, mode):
        bits_high = mode | (bits & 0xF0) | 0x08
        bits_low = mode | ((bits << 4) & 0xF0) | 0x08
        self.bus.write_byte(I2C_ADDR, bits_high)
        self.lcd_toggle_enable(bits_high)
        self.bus.write_byte(I2C_ADDR, bits_low)
        self.lcd_toggle_enable(bits_low)

    def lcd_toggle_enable(self, bits):
        sleep(E_DELAY)
        self.bus.write_byte(I2C_ADDR, (bits | 0x04))
        sleep(E_PULSE)
        self.bus.write_byte(I2C_ADDR, (bits & ~0x04))
        sleep(E_DELAY)

    def lcd_clear(self):
        self.lcd_byte(0x01, LCD_CMD)

    def lcd_display_string(self, message, line):
        message = message.ljust(LCD_WIDTH, " ")
        self.lcd_byte(line, LCD_CMD)
        for i in range(LCD_WIDTH):
            self.lcd_byte(ord(message[i]), LCD_CHR)

