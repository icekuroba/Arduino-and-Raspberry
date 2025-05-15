# botones.py
from gpiozero import Button
from time import sleep

# --- Configuración de botones (usando gpiozero para configurar los pines) ---
BOTON_SUBIR = Button(27)      # GPIO 27 (Pin físico 13)
BOTON_BAJAR = Button(22)      # GPIO 22 (Pin físico 15)
BOTON_SELECCIONAR = Button(23)  # GPIO 23 (Pin físico 16)
BOTON_REGRESAR = Button(5)    # GPIO 5  (Pin físico 29)

def detectar_boton():
    """
    Devuelve: 'subir', 'bajar', 'seleccionar', 'regresar' o None
    """
    if BOTON_SUBIR.is_pressed:
        sleep(0.2)  # Antirrebote
        return "subir"
    elif BOTON_BAJAR.is_pressed:
        sleep(0.2)  # Antirrebote
        return "bajar"
    elif BOTON_SELECCIONAR.is_pressed:
        sleep(0.2)  # Antirrebote
        return "seleccionar"
    elif BOTON_REGRESAR.is_pressed:
        sleep(0.2)  # Antirrebote
        return "regresar"
    else:
        return None

