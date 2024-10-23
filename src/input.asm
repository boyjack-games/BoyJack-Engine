section .data
    ; Определения для клавиш
    SDLK_ESCAPE      equ 27        ; Клавиша Escape
    SDLK_UP         equ 273       ; Клавиша вверх
    SDLK_DOWN       equ 274       ; Клавиша вниз
    SDLK_LEFT       equ 276       ; Клавиша влево
    SDLK_RIGHT      equ 275       ; Клавиша вправо
    SDLK_SPACE       equ 32       ; Клавиша пробела
    SDLK_A           equ 97       ; Буква A
    SDLK_B           equ 98       ; Буква B
    ; Добавьте другие необходимые клавиши здесь...

section .bss
    ; Переменная для хранения событий
    event            resb 32       ; Размер события (SDLEvent)

section .text
extern SDL_PollEvent
extern SDL_Quit
extern SDL_InitSubSystem
global init_input
global get_key

;==========================
; Инициализация ввода
;==========================
init_input:
    ; Инициализация подмодуля для ввода (например, клавиатуры)
    mov rdi, 0x00000001  ; SDL_INIT_EVENTS
    call SDL_InitSubSystem
    ret

;==========================
; Получение нажатой клавиши
; Возвращает символ нажатой клавиши в al
;==========================
get_key:
    ; Полнофункциональная проверка событий
    mov rdi, event        ; Указываем адрес события в rdi
    call SDL_PollEvent    ; Проверка наличия событий

    ; Проверяем, если событие - это событие нажатия клавиши
    movzx rsi, byte [rdi] ; Получаем тип события
    cmp rsi, 0x00000002   ; SDL_KEYDOWN
    jne .no_key           ; Если это не нажатие клавиши, выходим

    ; Получаем код нажатой клавиши из события
    movzx rsi, word [rdi + 8] ; Получаем код клавиши из структуры события

    ; Используем таблицу соответствий клавиш для возврата символа
    ; В данном примере обрабатываются только некоторые клавиши
    cmp rsi, SDLK_A       ; Проверка нажатой клавиши A
    je .return_a
    cmp rsi, SDLK_B
    je .return_b
    cmp rsi, SDLK_SPACE
    je .return_space

    ; Если клавиша не обрабатывается, возвращаем 0
    xor al, al
    ret

.return_a:
    mov al, 'A'          ; Возвращаем символ A
    ret

.return_b:
    mov al, 'B'          ; Возвращаем символ B
    ret

.return_space:
    mov al, ' '          ; Возвращаем пробел
    ret

.no_key:
    xor al, al           ; Если нет нажатой клавиши, возвращаем 0
    ret