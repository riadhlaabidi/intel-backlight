#include <errno.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ACTUAL_B_PATH "/sys/class/backlight/intel_backlight/actual_brightness"
#define MAX_B_PATH "/sys/class/backlight/intel_backlight/max_brightness"
#define B_PATH "/brightness"
#define HOME "HOME"

int main(int argc, char *argv[])
{
    int actual;

    FILE *ac_ptr;
    ac_ptr = fopen(ACTUAL_B_PATH, "r");

    if (!ac_ptr) {
        fprintf(stderr, "Failed to open file %s: %s", ACTUAL_B_PATH,
                strerror(errno));
        exit(EXIT_FAILURE);
    }

    fscanf(ac_ptr, "%d", &actual);
    fclose(ac_ptr);

    int max;

    FILE *m_ptr;
    m_ptr = fopen(MAX_B_PATH, "r");

    if (!m_ptr) {
        fprintf(stderr, "Failed to open file %s: %s", MAX_B_PATH,
                strerror(errno));
        exit(EXIT_FAILURE);
    }

    fscanf(m_ptr, "%d", &max);
    fclose(m_ptr);

    int percentage = (int)round(((double)actual * 100 / max));

    char *home = getenv(HOME);

    if (!home) {
        fprintf(stderr, "Environment variable %s not found", HOME);
        exit(EXIT_FAILURE);
    }

    int max_buff_size = strlen(home) + strlen(B_PATH) + 1;

    char *bp = (char *)malloc(max_buff_size * sizeof(char));

    if (!bp) {
        fprintf(stderr, "Failed to allocate memory for brightness file path");
        exit(EXIT_FAILURE);
    }

    int cx = snprintf(bp, max_buff_size, "%s%s", home, B_PATH);

    if (cx <= 0 || cx >= max_buff_size) {
        fprintf(stderr, "Failed to create brightness file path");
        free(bp);
        exit(EXIT_FAILURE);
    }

    FILE *b_ptr;
    b_ptr = fopen(bp, "w");

    if (!b_ptr) {
        fprintf(stderr, "Failed to open file %s", bp);
        free(bp);
        exit(EXIT_FAILURE);
    }

    fprintf(b_ptr, "%d", percentage);
    printf("%d%%", percentage);
    fclose(b_ptr);
    free(bp);

    return EXIT_SUCCESS;
}
