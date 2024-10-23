# Указываем компилятор ассемблера
ASM=nasm

# Опции компилятора
ASMFLAGS=-f win32

# Исходные файлы
SOURCES=main.asm graphics.asm input.asm audio.asm utils.asm

# Папка для исполняемого файла
BIN_DIR=bin

# Исполняемый файл
OUTPUT=$(BIN_DIR)/boyjack.exe

# Правило по умолчанию
all: $(OUTPUT)

# Правило для сборки исполняемого файла
$(OUTPUT): $(SOURCES)
    @mkdir -p $(BIN_DIR)  # Создание папки bin, если она не существует
    $(ASM) $(ASMFLAGS) $^ -o $@

# Чистка сгенерированных файлов
clean:
    @if [ -f $(OUTPUT) ]; then \
        echo "Removing $(OUTPUT)..."; \
        rm -f $(OUTPUT); \
    fi
    @if ls $(BIN_DIR)/*.o >/dev/null 2>&1; then \
        echo "Removing object files..."; \
        rm -f $(BIN_DIR)/*.o; \
    fi

# На Windows используется команда `del`
clean-windows:
    del $(OUTPUT)
    del $(BIN_DIR)\*.o

# Удаление временных файлов (для Windows)
clean: clean-windows

# Удаление временных файлов (для Unix)
clean-unix:
    rm -f $(OUTPUT) $(BIN_DIR)/*.o

# Условное определение цели очистки в зависимости от ОС
ifeq ($(OS),Windows_NT)
    CLEAN_TARGET = clean-windows
else
    CLEAN_TARGET = clean-unix
endif

clean: $(CLEAN_TARGET)