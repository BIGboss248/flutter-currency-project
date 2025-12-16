
/* 
Implement filter note to stream 
TODO Check extension and stream.where function
*/

extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}
