section .data
    ; Параметры для инициализации экрана
    screen_width    equ 800
    screen_height   equ 600
    title           db 'My Game', 0

section .bss
    ; Объявляем переменные для хранения указателей на экран и рендерер
    sdl_window      resq 1
    sdl_renderer    resq 1
    sdl_surface     resq 1

section .text
extern SDL_Init
extern SDL_CreateWindow
extern SDL_CreateRenderer
extern SDL_SetRenderDrawColor
extern SDL_RenderClear
extern SDL_RenderPresent
extern SDL_DestroyRenderer
extern SDL_DestroyWindow
extern SDL_Quit
global init_graphics
global draw_pixel
global clear_screen

;==========================
; Инициализация графики
;==========================
init_graphics:
    ; Инициализация SDL
    mov rdi, 0            ; Указываем, что инициализируем все компоненты
    call SDL_Init
    
    ; Создание окна
    lea rdi, [title]      ; Заголовок окна
    mov rsi, 100          ; Установка флагов: 100 (свойства окна)
    mov rdx, 100          ; Установка флагов: 100 (свойства окна)
    mov rcx, screen_width
    mov r8, screen_height
    call SDL_CreateWindow
    mov [sdl_window], rax ; Сохраняем указатель на окно

    ; Создание рендерера
    mov rdi, [sdl_window]  ; Передаем указатель на окно
    mov rsi, -1            ; Указываем, что рендерер будет обновляться автоматически
    mov rdx, 0             ; Указываем флаги рендерера
    call SDL_CreateRenderer
    mov [sdl_renderer], rax ; Сохраняем указатель на рендерер
    
    ret

;==========================
; Рисование пикселя
; Входные параметры:
; rdi - координата x
; rsi - координата y
;==========================
draw_pixel:
    ; Устанавливаем цвет (например, красный)
    mov rdi, [sdl_renderer] ; Передаем указатель на рендерер
    mov rsi, 255            ; Устанавливаем красный (R)
    mov rdx, 0              ; Устанавливаем зеленый (G)
    mov rax, 0              ; Устанавливаем синий (B)
    call SDL_SetRenderDrawColor ; Устанавливаем цвет рисования

    ; Рисуем пиксель
    mov rdi, [sdl_renderer] ; Указываем рендерер
    ; Чтобы нарисовать пиксель, используем функцию рисования линии длиной 1
    mov rsi, [rdi]          ; Передаем координаты
    mov rdx, rsi            ; y
    mov rax, 1              ; длина линии
    call SDL_RenderDrawLine  ; Рисуем "линию" (пиксель) длиной 1

    ret

;==========================
; Очистка экрана
;==========================
clear_screen:
    mov rdi, [sdl_renderer] ; Передаем указатель на рендерер
    ; Устанавливаем цвет очистки (черный)
    mov rsi, 0              ; R
    mov rdx, 0              ; G
    mov rax, 0              ; B
    call SDL_SetRenderDrawColor ; Устанавливаем цвет очистки

    ; Очищаем экран
    call SDL_RenderClear
    ret

;==========================
; Завершение работы с графикой
;==========================
cleanup_graphics:
    ; Уничтожаем рендерер
    mov rdi, [sdl_renderer]
    call SDL_DestroyRenderer

    ; Уничтожаем окно
    mov rdi, [sdl_window]
    call SDL_DestroyWindow

    ; Завершаем работу SDL
    call SDL_Quit

    ret