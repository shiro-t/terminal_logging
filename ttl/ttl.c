// Tiny Timestamp Log

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>

enum st { S_NORMAL, S_ESC, S_CSI, S_ESC_SKIP, S_OSC, S_OSC_ESC, S_STR, S_STR_ESC };

static char  *buf = NULL;
static size_t len = 0, cap = 0, cur = 0;

void put_ch(int c)               /* 表示文字をカーソル位置に上書き */
{
    if (cur >= cap) {
        cap = cap ? cap * 2 : 256;
        while (cap <= cur) cap *= 2;
        buf = realloc(buf, cap);
        if (!buf) exit(1);
    }
    while (len < cur) buf[len++] = ' '; /* 隙間は空白で埋める */
    if (cur < len) buf[cur] = c;
    else           buf[len++] = c;
    cur++;
}

static void flush_line(void)
{
    struct timeval t;
    struct tm *ts;

    while (len > 0 && buf[len - 1] == ' ') len--;   /* 行末の空白を落とす */

    gettimeofday( &t, NULL );
    ts = localtime(&t.tv_sec );
    
    printf("[%04d/%02d/%0d %02d:%02d:%02d.%03d] ", ts->tm_year +1900,
                                                   ts->tm_mon  +1,
                                                   ts->tm_mday, 
                                                   ts->tm_hour, 
                                                   ts->tm_min, 
                                                   ts->tm_sec, 
                                                   t.tv_usec/1000  );
    fwrite(buf, 1, len, stdout);
    putchar('\n');
    fflush(stdout);
    len = cur = 0;
}

int main(void)
{
    enum st s = S_NORMAL;
    char   params[64];
    int    plen = 0, c;

    while ((c = getc(stdin)) != EOF) {
        switch (s) {
        case S_NORMAL:
            switch (c) {
            case 0x1b: s = S_ESC; break;
            case '\r': cur = 0; break;
            case '\n': flush_line(); break;
            case '\b': if (cur > 0) cur--; break;
            case '\t': cur = (cur / 8 + 1) * 8; break;
            default:
                if (c >= 0x20 && c != 0x7f) put_ch(c);   /* 他の C0 は捨てる */
            }
            break;

        case S_ESC:
            if      (c == '[') { s = S_CSI; plen = 0; }
            else if (c == ']') s = S_OSC;
            else if (c == 'P' || c == 'X' || c == '^' || c == '_') s = S_STR;
            else if (c == '(' || c == ')' || c == '*' || c == '+' || c == '#')
                               s = S_ESC_SKIP;
            else               s = S_NORMAL;      /* ESC 7, ESC = など */
            break;

        case S_ESC_SKIP:
            s = S_NORMAL;
            break;

        case S_CSI:
            if (c >= 0x40 && c <= 0x7e) {          /* 最終バイト */
                params[plen] = '\0';
                int n = atoi(params);
                if (plen == 0 || n < 1) n = 1;
                switch (c) {
                case 'K':                          /* EL: カーソル以降を消去 */
                    if (params[0] == '\0' || params[0] == '0') {
                        if (len > cur) len = cur;
                    }
                    break;
                case 'C': cur += n; break;         /* CUF */
                case 'D': cur = (cur > (size_t)n) ? cur - n : 0; break;   /* CUB */
                case 'G': cur = n - 1; break;      /* CHA */
                }
                s = S_NORMAL;
            } else if (plen < (int)sizeof params - 1) {
                params[plen++] = c;
            }
            break;

        case S_OSC:
            if      (c == 0x07) s = S_NORMAL;
            else if (c == 0x1b) s = S_OSC_ESC;
            break;
        case S_OSC_ESC:
            s = (c == '\\') ? S_NORMAL : S_OSC;    /* ST で終了 */
            break;

        case S_STR:
            if (c == 0x1b) s = S_STR_ESC;
            break;
        case S_STR_ESC:
            s = (c == '\\') ? S_NORMAL : S_STR;
            break;
        }
    }
    if (len > 0) flush_line();
    return 0;
}
