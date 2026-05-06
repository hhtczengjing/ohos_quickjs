import { JSContext, JSValue } from '@devzeng/quickjs';
import { router } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { TestSectionWithExpected, TestCase } from '../components/TestSection';
import { loadScriptFromRawFile } from '../utils/ScriptLoader';

@Entry
@Component
struct FunctionTest {
  @State section5: TestCase[] = [];
  @State section6: TestCase[] = [];

  aboutToAppear(): void {
    const context = new JSContext();
    const abilityCtx = getContext(this) as common.UIAbilityContext;

    // Function call - load from script file
    const addScript = loadScriptFromRawFile(abilityCtx, 'scripts/function_add.js');
    context.evaluateScript(addScript);
    const addFn = context.getGlobalProperty('add');
    const fn10 = JSValue.valueWithNumber(10, context);
    const fn20 = JSValue.valueWithNumber(20, context);
    const callRet = addFn.callWithArguments([fn10, fn20]);
    this.section5 = [
      { name: 'add(10, 20)', expected: '30', actual: callRet.toString() },
      { name: 'isCallable(add)', expected: 'true', actual: addFn.isCallable.toString() }
    ];

    // Construct (new Date)
    const dateCtor = context.evaluateScript('Date');
    const ts = JSValue.valueWithNumber(1700000000000, context);
    const myDate = dateCtor.constructWithArguments([ts]);
    this.section6 = [
      { name: 'new Date(1700000000000)', expected: 'Wed Nov 15 2023 06:13:20 GMT+0000', actual: myDate.toString() }
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
        Text('Function Test')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, top: 12, bottom: 12 })

      Scroll() {
        Column({ space: 12 }) {
          TestSectionWithExpected('5. Function Call', this.section5)
          TestSectionWithExpected('6. Constructor (new Date)', this.section6)
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
