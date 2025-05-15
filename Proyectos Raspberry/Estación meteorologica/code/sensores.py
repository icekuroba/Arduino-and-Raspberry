# sensores.py
import spidev
import time
import board
import adafruit_dht
from gpiozero import Button
from time import sleep

# --- Inicialización de sensores y variables ---
# Sensor DHT11 en GPIO 17
dhtDevice = adafruit_dht.DHT11(board.D17)

# SPI para sensores analógicos (MQ-135, UV, veleta)
spi = spidev.SpiDev()
spi.open(0, 0)
spi.max_speed_hz = 1350000

# Anemómetro (GPIO 6)
anemometro_pin = 6
anemometro_button = Button(anemometro_pin, pull_up=True)
contador_anemo = 0

# Pluviómetro (GPIO 12)
pluvio_pin = 12
pluvio_button = Button(pluvio_pin)
contador_lluvia = 0

# --- Funciones para sensores ---
def leer_dht11():
    try:
        temperature_c = dhtDevice.temperature
        humidity = dhtDevice.humidity
        return temperature_c, humidity
    except Exception:
        return None, None

def leer_analogico(channel):
    if channel < 0 or channel > 7:
        return -1
    adc = spi.xfer2([1, (8 + channel) << 4, 0])
    data = ((adc[1] & 3) << 8) + adc[2]
    return data

def leer_calidad_aire():
    valor_analogico = leer_analogico(0)
    if valor_analogico < 200:
        calidad = "Buena"
    elif valor_analogico < 600:
        calidad = "Regular"
    else:
        calidad = "Mala"
    porcentaje = (valor_analogico / 1023.0) * 100
    return calidad, porcentaje

def leer_uv():
    suma_data = 0
    for _ in range(10):
        adc = leer_analogico(0)
        suma_data += adc
        sleep(0.1)
    promedio = suma_data / 10
    voltaje = promedio * (3.3 / 1023)
    return voltaje

def leer_pluvimetro():
    global contador_lluvia
    lluvia = contador_lluvia * 0.2794  # mm
    contador_lluvia = 0
    return lluvia

def leer_anemometro():
    global contador_anemo
    contador_anemo = 0
    sleep(2)
    velocidad = contador_anemo / 2.0  # m/s
    return velocidad

def leer_veleta():
    valor = leer_analogico(2)
    return direccion_veleta(valor)

def direccion_veleta(valor):
    if valor < 150:
        return "Norte"
    elif valor < 300:
        return "Noreste"
    elif valor < 500:
        return "Este"
    elif valor < 700:
        return "Sureste"
    elif valor < 850:
        return "Sur"
    elif valor < 950:
        return "Suroeste"
    elif valor < 1023:
        return "Oeste"
    else:
        return "Noroeste"

# --- Interrupciones por pulsos ---
def contar_pulsos_anemometro():
    global contador_anemo
    contador_anemo += 1

def contar_pulsos_lluvia():
    global contador_lluvia
    contador_lluvia += 1

anemometro_button.when_pressed = contar_pulsos_anemometro
pluvio_button.when_pressed = contar_pulsos_lluvia
