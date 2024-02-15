import tkinter as tk
from tkinter import ttk
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import matplotlib.pyplot as plt
import numpy as np
import serial
import time

def on_closing():
    # Cerrar la conexión serial antes de salir
    ser.close()
    ventana.quit() 
    ventana.destroy()

def radar():
    # Limpiar el gráfico existente
    ax.clear()
    # Comunicación serial (descomentar estas líneas cuando tengas la comunicación serial real)


    ser.flushInput()
    ser.write(b's')
    time.sleep(.1)
    muestras = 40
    posiciones = [int.from_bytes(ser.read(2), "big") for i in range(0, muestras, 1)]
    posicion_minima = round(int.from_bytes(ser.read(1), "big") * 180 / (muestras-1), 1)
    distancia_minima = int.from_bytes(ser.read(2), "big")
    # Actualizar el gráfico polar
    angulos = np.linspace(0, np.pi, muestras)
    ax.scatter(angulos, posiciones, color="#e74c3c", marker="o")  # Configurar color y estilo del marcador
    ax.set_title('SONAR', color="black")  # Configurar color del título

    # Configurar los límites del ángulo en el gráfico polar
    ax.set_thetamin(0)
    ax.set_thetamax(180)
    ax.set_rmax(4 * min(posiciones))

    # Actualizar el Canvas
    print(posiciones)
    print(posicion_minima)
    print(distancia_minima)

    canvas.draw()
    texto_minima_posicion.set(f"Posicion minima: {posicion_minima}°, {distancia_minima/10} cm")

# Simulación de comunicación serial
ser = serial.Serial('COM10', baudrate=9600, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE)

# Crear la ventana principal
ventana = tk.Tk()
ventana.title("TPI")

# Crear la grid
ventana.columnconfigure(0, weight=1)
ventana.columnconfigure(1, weight=1)
ventana.rowconfigure(0, weight=1)
ventana.rowconfigure(1, weight=1)

# Crear el bloque de arriba a la izquierda con un botón
bloque_superior_izquierdo = tk.Frame(ventana, bg="#F0F0F0")  # Fondo gris claro
bloque_superior_izquierdo.grid(row=0, column=0, sticky="nsew")

# Crear el bloque de abajo a la izquierda
bloque_inferior_izquierdo = tk.Frame(ventana, bg="#E0E0E0")  # Fondo gris ligeramente más oscuro
bloque_inferior_izquierdo.grid(row=1, column=0, sticky="nsew")

# Crear el bloque a la derecha con un Canvas para el gráfico
bloque_derecho = tk.Frame(ventana, bg="#F8F8F8")  # Fondo blanco roto
bloque_derecho.grid(row=0, column=1, rowspan=2, sticky="nsew")

# Iniciar el gráfico polar
fig, ax = plt.subplots(subplot_kw={'projection': 'polar'})
ax.set_title('SONAR')
ax.set_rmax(100)
ax.set_thetamin(0)
ax.set_thetamax(180)

# Iniciar el Canvas con el gráfico polar inicial
canvas = FigureCanvasTkAgg(fig, master=bloque_derecho)
canvas_widget = canvas.get_tk_widget()
canvas_widget.pack(fill=tk.BOTH, expand=True)

# Crear el botón en el bloque superior izquierdo
style = ttk.Style()
style.configure("TButton", padding=10, relief="flat", font=("Helvetica", 14))

# Crear el botón en el bloque superior izquierdo
boton = ttk.Button(
    bloque_superior_izquierdo,
    text="INICIAR MEDICION",
    command=radar,
    style="TButton",
    cursor="hand2",
    )
boton.place(relx=0.5, rely=0.5, anchor="center")

# Crear un StringVar para mantener la referencia al texto
texto_minima_posicion = tk.StringVar()
texto_minima_posicion.set("Posicion minima: ---")  # Inicializar el texto
label_minima_posicion = tk.Label(
    bloque_inferior_izquierdo,
    textvariable=texto_minima_posicion,
    font=("Helvetica", 12),
    bg="#E0E0E0",  # Fondo gris ligeramente más oscuro
)

label_minima_posicion.place(relx=0.5, rely=0.5, anchor="center")

ventana.protocol("WM_DELETE_WINDOW", on_closing)

# Configurar la geometría de la ventana
width = ventana.winfo_screenwidth()
height = ventana.winfo_screenheight()
ventana.geometry(f"{width}x{height}")

# Ejecutar la aplicación
ventana.mainloop()
