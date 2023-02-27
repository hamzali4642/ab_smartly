import 'package:ab_smartly/helper/mutex/mutex.dart';

import 'package:ab_smartly/helper/mutex/read_write_mutex.dart';

class Concurrency {
  static Future<V> computeIfAbsentRW<K, V>(ReadWriteMutex lock, Map<K, V> map, K key, V computer(K key)) async {

    try {


      lock.acquireRead();
      final V value = map[key] as V;
      if (value != null) {
        return value;
      }
    } finally {
      lock.release();
    }
    try {
      lock.acquireWrite();
      final V value = map[key] as V; // double check
      if (value != null) {
        return value;
      }

      final V newValue = computer(key);
      map[key] = newValue;
      return newValue;
    } finally {
      lock.release();
    }
  }

  static V getRW<K, V>(ReadWriteMutex lock, Map<K, V> map, K key) {
    try {
      lock.acquireRead();

      return map[key] as V;
    } finally {
      lock.release();
    }
  }

  static V putRW<K, V>(ReadWriteMutex lock, Map<K, V> map, K key, V value) {
    try {
      lock.acquireWrite();

      return map[key] = value;
    } finally {
      lock.release();
    }
  }

  static void addRW<V>(ReadWriteMutex lock, List<V> list, V value) {
    try {
      lock.acquireWrite();
      list.add(value);
    } finally {
      lock.release();
    }
  }
}
