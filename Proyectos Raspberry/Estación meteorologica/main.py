# main.py
from I2C_LCD_driver import lcd
import time
import os
from sensores import leer_dht11, leer_pluvimetro, leer_anemometro, leer_calidad_aire, leer_uv, leer_veleta
from botones import detectar_boton
from lcd_display import mostrar_en_lcd

lcd = lcd()

menu = [
    "Temperatura",
    "Humedad",
    "Lluvia",
    "Veloc. Viento",
    "Calidad Aire",
    "Radiacion UV",
    "Direccion Viento"
]

indice = 0
boton_anterior = None
easter_egg_code = ["regresar", "regresar", "subir"]
input_sequence = []

def mostrar_menu():
    texto1 = f"Menu ({indice+1}/{len(menu)}):"
    texto2 = menu[indice]
    mostrar_en_lcd(texto1, texto2)

# --- Mostrar menú inicial ---
mostrar_menu()

try:
    while True:
        boton = detectar_boton()

        if boton:
            print(f"[DEBUG] Boton detectado: {boton}")
        
        if boton and boton != boton_anterior:
            input_sequence.append(boton)
            input_sequence = input_sequence[-len(easter_egg_code):]
            print(f"[DEBUG] Secuencia: {input_sequence}")

            if input_sequence == easter_egg_code:
                mostrar_en_lcd("Modo secreto!", "Iniciando juego")
                time.sleep(2)
                os.system("chocolate-doom -iwad /home/fi2020/Desktop/DOOM/DOOM2.WAD")
                input_sequence.clear()
                mostrar_menu()
                continue

            if boton == "subir":
                indice = (indice - 1) % len(menu)
                mostrar_menu()

            elif boton == "bajar":
                indice = (indice + 1) % len(menu)
                mostrar_menu()

            elif boton == "seleccionar":
                opcion = menu[indice]

            # --- Activación de sensores ---
                if opcion == "Temperatura":
                    t, _ = leer_dht11()
                    mostrar_en_lcd("Temperatura:", f"{t:.1f} C" if t is not None else "Error sensor")

                elif opcion == "Humedad":
                    _, h = leer_dht11()
                    mostrar_en_lcd("Humedad:", f"{h:.1f}%" if h is not None else "Error sensor")

                elif opcion == "Lluvia":
                    lluvia = leer_pluvimetro()
                    mostrar_en_lcd("Lluvia:", f"{lluvia:.1f} mm")

                elif opcion == "Veloc. Viento":
                    velocidad = leer_anemometro()
                    mostrar_en_lcd("Viento:", f"{velocidad:.1f} m/s")

                elif opcion == "Calidad Aire":
                    calidad, _ = leer_calidad_aire()
                    mostrar_en_lcd("Calidad Aire:", calidad)

                elif opcion == "Radiacion UV":
                    uv = leer_uv()
                    mostrar_en_lcd("Radiacion UV:", f"{uv:.2f} V")

                elif opcion == "Direccion Viento":
                    direccion = leer_veleta()
                    mostrar_en_lcd("Direccion:", direccion)

                # -- Esperar "regresar" o 3 segundos ---
                inicio = time.time()
                while time.time() - inicio < 3:
                    if detectar_boton() == "regresar":
                        break

                mostrar_menu()

        boton_anterior = boton
        time.sleep(0.1)

except KeyboardInterrupt:
    lcd.lcd_clear()
    print("Programa finalizado.")
