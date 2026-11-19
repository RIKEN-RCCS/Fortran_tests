#include <pthread.h>
#include <unistd.h>

static int *g_buf;
static int g_n;
static int g_copy[16];
static pthread_t g_thread;

static void *fill(void *arg) {
  (void)arg;
  usleep(20000);
  for (int i = 0; i < g_n; i++) g_buf[i] = 10 * (i + 1);
  return NULL;
}

static void *copy(void *arg) {
  (void)arg;
  usleep(20000);
  for (int i = 0; i < g_n; i++) g_copy[i] = g_buf[i];
  return NULL;
}

void c_irecv(int *buf, int n) {
  g_buf = buf;
  g_n = n;
  pthread_create(&g_thread, NULL, fill, NULL);
}

void c_isend(int *buf, int n) {
  g_buf = buf;
  g_n = n;
  pthread_create(&g_thread, NULL, copy, NULL);
}

void c_wait(void) {
  pthread_join(g_thread, NULL);
}

void c_sent(int *out) {
  for (int i = 0; i < g_n; i++) out[i] = g_copy[i];
}
