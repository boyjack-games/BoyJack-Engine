section .data
    SDL_INIT_AUDIO    equ 0x00000010  ; Инициализация аудио
    SDL_MIX_MAXVOLUME equ 128          ; Максимальная громкость

section .bss
    ; Переменные для хранения аудио
    audio_device      resq 1           ; Указатель на аудиоустройство
    audio_spec        resb 24           ; Спецификация аудио, 24 байта (к примеру)
    audio_chunk       resq 1           ; Указатель на загруженный звуковой файл
    audio_length      resq 1           ; Длина загруженного звукового файла в байтах

section .text
extern SDL_Init
extern SDL_Quit
extern SDL_OpenAudioDevice
extern SDL_LoadWAV
extern SDL_QueueAudio
extern SDL_PauseAudioDevice
extern SDL_FreeWAV
extern SDL_CloseAudioDevice
global init_audio
global play_sound
global free_audio_resources

;==========================
; Инициализация аудио
;==========================
init_audio:
    ; Инициализация SDL
    mov rdi, SDL_INIT_AUDIO
    call SDL_Init
    ret

;==========================
; Воспроизведение звука
; Входные параметры:
; rdi - указатель на строку с путем к аудиофайлу
;==========================
play_sound:
    push rdi                   ; Сохраняем указатель на строку с путем
    sub rsp, 32                ; Выделяем место для audio_spec

    ; Устанавливаем спецификации звука
    ; В данном примере установим частоту 44.1kHz, 16-бит, стерео
    mov dword [audio_spec], 44100 ; Частота
    mov word [audio_spec + 4], 2   ; Каналы (стерео)
    mov word [audio_spec + 6], 16   ; Битовая глубина

    ; Открываем аудиоустройство
    xor rdi, rdi               ; Dev для открытия
    mov rsi, audio_spec        ; Pass audio specifications
    mov rdx, 0                 ; Настройки для открытия
    call SDL_OpenAudioDevice
    mov [audio_device], rax    ; Сохраняем указатель на аудиоустройство

    ; Загружаем WAV-файл
    mov rdi, rsi               ; Путь к файлу (string)
    call SDL_LoadWAV
    mov [audio_chunk], rax     ; Сохраняем указатель на загруженный файл
    ; Предположим, что SDL_LoadWAV возвращает указатель на данные и устанавливает длину звука
    mov rsi, rax               ; Указатель на загруженные данные
    mov rdi, [audio_length]    ; Получаем длину загруженного аудио
    call SDL_QueueAudio
    xor rdi, rdi               ; Устанавливаем 0 для продолжения воспроизведения
    call SDL_PauseAudioDevice   ; Возобновляем воспроизведение
    add rsp, 32                ; Удаляем выделенную память
    pop rdi                    ; Восстанавливаем указатель
    ret

;==========================
; Освобождение ресурсов аудио
;==========================
free_audio_resources:
    ; Освобождаем загруженный WAV-файл
    mov rdi, [audio_chunk]      ; Указатель на загруженный файл
    call SDL_FreeWAV

    ; Закрываем аудиоустройство
    mov rdi, [audio_device]     ; Указатель на аудиоустройство
    call SDL_CloseAudioDevice

    ; Завершаем SDL
    call SDL_Quit
    ret