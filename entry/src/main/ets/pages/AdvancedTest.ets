import { JSContext, JSValue } from '@devzeng/quickjs';
import { router } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { TestSectionWithExpected, TestCase } from '../components/TestSection';
import { loadScriptFromRawFile } from '../utils/ScriptLoader';

@Entry
@Component
struct AdvancedTest {
  @State section7: TestCase[] = [];
  @State section8: TestCase[] = [];
  @State section9: TestCase[] = [];
  @State section12: TestCase[] = [];

  aboutToAppear(): void {
    const context = new JSContext();
    const abilityCtx = getContext(this) as common.UIAbilityContext;

    // Strict equality
    const a1 = JSValue.valueWithNumber(42, context);
    const a2 = JSValue.valueWithNumber(42, context);
    const a3 = JSValue.valueWithNumber(43, context);
    const s1 = JSValue.valueWithString('hello', context);
    const s2 = JSValue.valueWithString('hello', context);
    const s3 = JSValue.valueWithString('world', context);
    this.section7 = [
      { name: '42 === 42', expected: 'true', actual: a1.isEqualTo(a2).toString() },
      { name: '42 === 43', expected: 'false', actual: a1.isEqualTo(a3).toString() },
      { name: "'hello' === 'hello'", expected: 'true', actual: s1.isEqualTo(s2).toString() },
      { name: "'hello' === 'world'", expected: 'false', actual: s1.isEqualTo(s3).toString() }
    ];

    // Global object - load from script file
    const globalScript = loadScriptFromRawFile(abilityCtx, 'scripts/global_vars.js');
    context.evaluateScript(globalScript);
    const gx = context.getGlobalProperty('globalX');
    const gy = context.getGlobalProperty('globalY');
    this.section8 = [
      { name: 'globalX', expected: '100', actual: gx.toString() },
      { name: 'globalY', expected: 'demo', actual: gy.toString().replace(/['"]/g, '') }
    ];

    // Error handling
    const badEval = context.evaluateScript('throw new Error("test error")');
    const err = context.evaluateScript('new Error("custom error")');
    const errMsg = err.getProperty('message');
    const errName = err.getProperty('name');
    this.section9 = [
      { name: 'throw error result', expected: 'test error', actual: badEval.toString() },
      { name: 'new Error.name', expected: 'Error', actual: errName.toString() },
      { name: 'new Error.message', expected: 'custom error', actual: errMsg.toString() }
    ];

    // Complex JS expressions - load from script file
    const fibScript = loadScriptFromRawFile(abilityCtx, 'scripts/fibonacci.js');
    context.evaluateScript(fibScript);
    const fibFn = context.getGlobalProperty('fibonacci');
    const fibArg = JSValue.valueWithNumber(10, context);
    const fib10 = fibFn.callWithArguments([fibArg]);
    const sumFn = context.getGlobalProperty('sum');
    const sumArrayScript = loadScriptFromRawFile(abilityCtx, 'scripts/sum_array.js');
    const arrArg = context.evaluateScript(sumArrayScript);
    const sumRet = sumFn.callWithArguments([arrArg]);
    this.section12 = [
      { name: 'fibonacci(10)', expected: '55', actual: fib10.toString() },
      { name: 'sum([1,2,3,4,5])', expected: '15', actual: sumRet.toString() }
    ];

    context.release();
  }

  build() {
    Column() {
      Row() {
        Button('← Back')
          .fontSize(16)
          .fontColor('#1a73e8')
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            router.back();
          })
        Text('Advanced Test')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, top: 12, bottom: 12 })

      Scroll() {
        Column({ space: 12 }) {
          TestSectionWithExpected('7. Strict Equality', this.section7)
          TestSectionWithExpected('8. Global Object', this.section8)
          TestSectionWithExpected('9. Error Handling', this.section9)
          TestSectionWithExpected('12. Complex Expressions (Fibonacci + Reduce)', this.section12)
        }
        .width('100%')
        .padding(16)
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}
