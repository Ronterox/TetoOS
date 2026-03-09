void dummy_fake_main() {}

int main() {
  char *video_memory = (char *)0xb8000;
  *video_memory = 'X';
}
