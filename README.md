# QuickJS for HarmonyOS

QuickJS 引擎的 ArkTS/JS 绑定封装，用于在 HarmonyOS (鸿蒙) 应用中嵌入和执行 JavaScript。

## 特性

- 基于 [QuickJS](https://bellard.org/quickjs/) 轻量级 JS 引擎
- 完整的 ArkTS API 封装：`JSContext` + `JSValue`
- 支持脚本执行、类型检查、属性操作、函数调用、构造函数等
- 提供 Demo 应用，覆盖 12 个测试场景，带有预期结果对比

## 项目结构

```
├── quickjs/                         # SDK 模块 (HAR)
│   ├── src/main/cpp/
│   │   ├── napi_init.cpp            # NAPI 原生绑定实现
│   │   └── handle_registry.h        # 句柄注册表 (JSValue ↔ int64 handle)
│   └── src/main/ets/
│       ├── JSContext.ets            # JS 执行上下文
│       └── JSValue.ets              # JS 值封装
├── entry/                           # Demo 应用 (HAP)
│   └── src/main/
│       ├── ets/
│       │   ├── pages/               # 测试页面
│       │   │   ├── Index.ets            # 功能列表导航页
│       │   │   ├── BasicScriptTest.ets    # 1. 基础脚本执行
│       │   │   ├── TypeCheckTest.ets      # 2. 类型检查
│       │   │   ├── ObjectTest.ets         # 3. 属性访问 + 10. 属性名遍历
│       │   │   ├── ArrayTest.ets          # 4. 数组操作 + 11. 字典/数组转换
│       │   │   ├── FunctionTest.ets       # 5. 函数调用 + 6. 构造函数
│       │   │   └── AdvancedTest.ets       # 7. 相等比较 + 8. 全局对象 + 9. 错误处理 + 12. 复杂表达式
│       │   ├── components/
│       │   │   └── TestSection.ets        # 公共测试组件 (含预期/实际对比)
│       │   └── utils/
│       │       └── ScriptLoader.ets       # rawfile 脚本加载工具
│       └── resources/rawfile/scripts/     # JS 测试脚本文件
└── oh-package.json5
```

## 快速开始

### 引入 SDK

在 `oh-package.json5` 中添加依赖：

```json5
{
  "dependencies": {
    "@devzeng/quickjs": "file:../quickjs"
  }
}
```

### 基本用法

```typescript
import { JSContext, JSValue } from '@devzeng/quickjs';

// 创建执行上下文
const context = new JSContext();

// 执行脚本
const result = context.evaluateScript("'Hello World'");
console.log(result.toString()); // 'Hello World'

// 创建值并进行类型检查
const num = JSValue.valueWithNumber(42, context);
console.log(num.isNumber); // true

// 对象操作
const obj = JSValue.valueWithNewObject(context);
obj.setValue(JSValue.valueWithString('test', context), 'name');
console.log(obj.getProperty('name').toString()); // 'test'

// 函数调用
const addFn = context.evaluateScript('(function(a, b) { return a + b; })');
const ret = addFn.callWithArguments([
  JSValue.valueWithNumber(10, context),
  JSValue.valueWithNumber(20, context)
]);
console.log(ret.toString()); // '30'

// 释放资源
context.release();
```

## API 参考

### JSContext

| 方法/属性 | 说明 |
|-----------|------|
| `constructor()` | 创建 JS 执行上下文 |
| `evaluateScript(script, sourceURL?)` | 执行 JS 脚本，返回 `JSValue` |
| `globalObject` | 获取全局对象 |
| `getGlobalProperty(name)` | 获取全局变量 |
| `setObject(object, name)` | 向全局对象注入值 |
| `release()` | 释放上下文资源 |

### JSValue

#### 工厂方法

| 方法 | 说明 |
|------|------|
| `valueWithUndefined(ctx)` | 创建 undefined 值 |
| `valueWithNull(ctx)` | 创建 null 值 |
| `valueWithBool(value, ctx)` | 创建布尔值 |
| `valueWithNumber(value, ctx)` | 创建数值 |
| `valueWithString(value, ctx)` | 创建字符串 |
| `valueWithNewObject(ctx)` | 创建空对象 |
| `valueWithNewArray(ctx, length?)` | 创建数组 |
| `valueWithNewError(message, ctx)` | 创建 Error 对象 |

#### 类型检查

| 属性 | 类型 | 说明 |
|------|------|------|
| `isUndefined` | `boolean` | 是否为 undefined |
| `isNull` | `boolean` | 是否为 null |
| `isBoolean` | `boolean` | 是否为布尔值 |
| `isNumber` | `boolean` | 是否为数值 |
| `isString` | `boolean` | 是否为字符串 |
| `isObject` | `boolean` | 是否为对象 |
| `isArray` | `boolean` | 是否为数组 |
| `isDate` | `boolean` | 是否为 Date |
| `isCallable` | `boolean` | 是否为可调用函数 |

#### 值转换

| 方法 | 返回类型 | 说明 |
|------|----------|------|
| `toString()` | `string` | 转换为字符串 |
| `toNumber()` | `number` | 转换为数值 |
| `toBoolean()` | `boolean` | 转换为布尔值 |
| `toDate()` | `Date \| null` | 转换为 Date 对象 |
| `toArray()` | `JSValue[] \| null` | 数组转为 JSValue 列表 |
| `toDictionary()` | `Record<string, JSValue> \| null` | 对象转为字典 |

#### 属性操作

| 方法 | 说明 |
|------|------|
| `getProperty(name)` | 获取属性值 |
| `setValue(value, name)` | 设置属性值 |
| `hasProperty(name)` | 检查属性是否存在 |
| `deleteProperty(name)` | 删除属性 |
| `getPropertyNames()` | 获取所有属性名列表 |
| `valueAtIndex(index)` | 获取数组索引位置的值 |
| `setValueAtIndex(value, index)` | 设置数组索引位置的值 |
| `arrayLength` | 获取数组长度 |

#### 函数调用

| 方法 | 说明 |
|------|------|
| `callWithArguments(args)` | 以参数数组调用函数 |
| `constructWithArguments(args)` | 作为构造函数调用 (`new`) |
| `invokeMethod(name, args)` | 调用对象的方法 |

#### 比较

| 方法 | 说明 |
|------|------|
| `isEqualTo(value)` | 严格相等 (`===`) |
| `isInstanceOf(constructor)` | instanceof 检查 |

## 构建

需要安装 [DevEco Studio](https://developer.huawei.com/consumer/cn/deveco-studio/)。

```bash
# 安装依赖
ohpm install

# 构建 HAR
hvigorw assembleHar --no-daemon

# 构建 Demo HAP
hvigorw assembleHap --no-daemon
```

## Demo

项目自带一个完整的 Demo 应用，包含 6 个独立测试页面，每个测试项都标明了**预期值**和**实际值**的对比：

- 预期值与实际值**一致**时显示绿色
- 预期值与实际值**不一致**时显示红色

在 DevEco Studio 中打开项目，运行 `entry` 模块即可查看。

## License

MIT License
