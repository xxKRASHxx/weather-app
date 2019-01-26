func execute<T> (_ action: () -> T) -> T {
  return action()
}
