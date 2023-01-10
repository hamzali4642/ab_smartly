// import 'package:ab_smartly/helper/mutex/mutex.dart';
//
// import 'package:ab_smartly/helper/mutex/read_write_mutex.dart';
//
// class Concurrency {
//   static V computeIfAbsentRW<K, V>(ReadWriteMutex lock, Map<K, V> map, K key, V computer(K key)) {
//
//     final ReentrantReadWriteLock.ReadLock readLock = lock.readLock;
//     try {
//       readLock.lock();
//       final V value = map[key] as V;
//       if (value != null) {
//         return value;
//       }
//     } finally {
//       readLock.unlock();
//     }
//
//     final ReentrantReadWriteLock.WriteLock writeLock = lock.writeLock;
//     try {
//       writeLock.lock();
//       final V value = map[key] as V; // double check
//       if (value != null) {
//         return value;
//       }
//
//       final V newValue = computer(key);
//       map[key] = newValue;
//       return newValue;
//     } finally {
//       writeLock.unlock();
//     }
//   }
//
//   static V getRW<K, V>(ReentrantReadWriteLock lock, Map<K, V> map, K key) {
//     final ReentrantReadWriteLock.ReadLock readLock = lock.readLock;
//     try {
//       readLock.lock();
//       return map[key] as V;
//     } finally {
//       readLock.unlock();
//     }
//   }
//
//   static V putRW<K, V>(ReentrantReadWriteLock lock, Map<K, V> map, K key, V value) {
//     final ReentrantReadWriteLock.WriteLock writeLock = lock.writeLock;
//     try {
//       writeLock.lock();
//       return map[key] = value;
//     } finally {
//       writeLock.unlock();
//     }
//   }
//
//   static void addRW<V>(ReentrantReadWriteLock lock, List<V> list, V value) {
//     final ReentrantReadWriteLock.WriteLock writeLock = lock.writeLock;
//     try {
//       writeLock.lock();
//       list.add(value);
//     } finally {
//       writeLock.unlock();
//     }
//   }
// }
