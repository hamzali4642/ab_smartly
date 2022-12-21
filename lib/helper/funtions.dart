int leftRotate(int n, int d) {
  return (n << d) | (n >> (64 - d));
}
