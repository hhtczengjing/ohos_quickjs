// Fibonacci and sum functions
var fibonacci = function(n) {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
};

var sum = function(arr) {
  return arr.reduce(function(a, b) { return a + b; }, 0);
};
