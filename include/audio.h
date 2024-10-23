#ifndef AUDIO_H
#define AUDIO_H

void init_audio();             // Инициализация аудио
void play_sound(const char* path); // Воспроизведение звука
void cleanup_audio();          // Освобождение ресурсов аудио

#endif // AUDIO_H