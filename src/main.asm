section .data
    msg db '', 0
    input_condition db 0  ; Переменная для хранения состояния ввода

section .text
global _start

extern init_graphics
extern handle_input
extern play_audio
extern cleanup_resources

_start:
    ; Инициализация графики
    call init_graphics

    ; Главный цикл игры
.main_loop:
    ; Обработка ввода и обновление состояния
    call handle_input

    ; Проверка нажатия клавиши 'Esc'
    cmp byte [input_condition], 1
    je .exit_game

    call play_audio

    ; Продолжаем основной цикл
    jmp .main_loop  

.exit_game:
    ; Очистка ресурсов перед выходом
    call cleanup_resources

    ; Завершение программы
    mov eax, 60       ; syscall: exit
    xor edi, edi      ; статус выхода 0
    syscall