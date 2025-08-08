# Weather Station with Raspberry Pi 5

This weather station is designed to monitor environmental variables in real time using a Raspberry Pi 5.  
It uses sensors connected via GPIO, SPI, and I2C, and provides a simple physical interface based on buttons and an LCD display.

## 🌎 Purpose

In light of the increase in extreme weather events, a low-cost, reliable, and expandable environmental monitoring solution is required.  
This embedded system allows real-time visualization of variables such as:

- Temperature  
- Humidity  
- Precipitation  
- Wind speed  
- Wind direction  
- UV radiation  
- Air quality  

![Alt text](diagrama/estacion_dibujos.png)

## 🧩 Components

- **Raspberry Pi 5**  
- **DHT11 Sensor** – Temperature and humidity  
- **MQ-135** – Air quality  
- **GUVA-S12SD** – UV radiation  
- **Rain gauge** – Pulse-based  
- **Anemometer** – Pulse-based  
- **Wind vane** – Analog sensor  
- **16x2 I2C LCD display**  
- **4 physical buttons** – Up, down, select, and back  
- **Fan** – Automatic activation based on temperature  

## 🛠️ Communication Protocols

- **GPIO:** Buttons, rain gauge, anemometer, fan, DHT11  
- **I2C:** LCD display  
- **SPI:** Analog reading via MCP3008 (UV, air quality, wind vane)  

## 🎛️ User Interface

The user navigates through a menu on the LCD display. The buttons allow:

- Scrolling up and down between options  
- Selecting a variable to display  
- Returning to the main menu  

The system also includes a hidden sequence that runs Doom when a specific button pattern is detected.

## ⚙️ Installation

```bash
sudo apt update
sudo apt install python3-pip python3-dev build-essential git python3-rpi.gpio
sudo pip3 install --break-system-packages adafruit-circuitpython-charlcd
sudo pip3 install --break-system-packages adafruit-circuitpython-mcp3xxx
sudo apt install python3-gpiozero


**For the DHT11 sensor:**
```bash
git clone https://github.com/adafruit/Adafruit_Python_DHT.git
cd Adafruit_Python_DHT
sudo python3 setup.py install --force-pi
```

## 📂 Main files

- `main.py`: Lógica del menú y visualización de sensores
- `sensores.py`: Funciones para cada sensor
- `botones.py`: Lectura de botones físicos
- `lcd_display.py`: Funciones para mostrar texto en el LCD
- `I2C_LCD_driver.py`: Driver I2C para la pantalla

## 🚀 Automatic Execution (Optional)

Add this line to /etc/rc.local before exit 0:

```bash
python3 /ruta/al/archivo/main.py &
```

---

This project can be used as a base for developing distributed stations, environmental monitoring networks, or educational applications that integrate electronics and programming with social impact.
