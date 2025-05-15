# lcd_display.py
from I2C_LCD_driver import lcd, LINE_1, LINE_2
import time

lcd = lcd()

def mostrar_en_lcd(linea1, linea2=""):
    lcd.lcd_clear()
    lcd.lcd_display_string(linea1[:16], LINE_1)
    lcd.lcd_display_string(linea2[:16], LINE_2)