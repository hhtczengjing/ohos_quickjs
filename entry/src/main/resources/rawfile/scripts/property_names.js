// Property names iteration test
var obj = {};
obj.a = 1;
obj.b = 2;
obj.c = 3;
delete obj.b;
obj.d = 4;
Object.getOwnPropertyNames(obj);
