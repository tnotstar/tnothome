# Variables de configuración
RM = rm
RMFLAGS = -f
CC = tcc
CFLAGS = -DUNICODE -mwindows
TARGET = winwsl.exe
SRC = winwsl.c

# Regla por defecto: compila el ejecutable
all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET)

# Regla para limpiar los archivos generados
clean:
	$(RM) $(RMFLAGS) $(TARGET)

# Evita conflictos si existen carpetas con estos nombres
.PHONY: all clean
