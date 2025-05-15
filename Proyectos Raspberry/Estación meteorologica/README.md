# Estación Meteorológica con Raspberry Pi 5

Esta estación meteorológica está diseñada para monitorear variables ambientales en tiempo real mediante una Raspberry Pi 5. Utiliza sensores conectados por GPIO, SPI e I2C, y proporciona una interfaz física simple basada en botones y una pantalla LCD.

## 🌎 Propósito

Frente al incremento de eventos climáticos extremos, se requiere una solución de monitoreo ambiental de bajo costo, confiable y expandible. Este sistema embebido permite visualizar en tiempo real variables como:

- Temperatura
- Humedad
- Precipitación
- Velocidad del viento
- Dirección del viento
- Radiación UV
- Calidad del aire

## 🧩 Componentes

- **Raspberry Pi 5**
- **Sensor DHT11** – Temperatura y humedad
- **MQ-135** – Calidad del aire
- **GUVA-S12SD** – Radiación UV
- **Pluviómetro** – Por pulsos
- **Anemómetro** – Por pulsos
- **Veleta** – Sensor analógico
- **Pantalla LCD 16x2 I2C**
- **4 botones físicos** – Subir, bajar, seleccionar y regresar
- **Ventilador** – Activación automática por temperatura

## 🛠️ Protocolos de comunicación

- **GPIO:** Botones, pluviómetro, anemómetro, ventilador, DHT11
- **I2C:** Pantalla LCD
- **SPI:** Lectura analógica mediante MCP3008 (UV, calidad del aire, veleta)

## 🎛️ Interfaz del usuario

El usuario navega por un menú en la pantalla LCD. Los botones permiten:

- Subir y bajar entre opciones
- Seleccionar una variable para visualizar
- Regresar al menú principal

El sistema también incluye una secuencia secreta que ejecuta Doom al reconocer un patrón de botones.

## ⚙️ Instalación

```bash
sudo apt update
sudo apt install python3-pip python3-dev build-essential git python3-rpi.gpio
sudo pip3 install --break-system-packages adafruit-circuitpython-charlcd
sudo pip3 install --break-system-packages adafruit-circuitpython-mcp3xxx
sudo apt install python3-gpiozero
```

**Para el sensor DHT11:**
```bash
git clone https://github.com/adafruit/Adafruit_Python_DHT.git
cd Adafruit_Python_DHT
sudo python3 setup.py install --force-pi
```

## 📂 Archivos principales

- `main.py`: Lógica del menú y visualización de sensores
- `sensores.py`: Funciones para cada sensor
- `botones.py`: Lectura de botones físicos
- `lcd_display.py`: Funciones para mostrar texto en el LCD
- `I2C_LCD_driver.py`: Driver I2C para la pantalla

## 🚀 Ejecución automática (opcional)

Agrega esta línea a `/etc/rc.local` antes de `exit 0`:

```bash
python3 /ruta/al/archivo/main.py &
```

---

Este proyecto puede utilizarse como base para el desarrollo de estaciones distribuidas, redes de monitoreo ambiental o aplicaciones educativas que integren electrónica y programación con impacto social.