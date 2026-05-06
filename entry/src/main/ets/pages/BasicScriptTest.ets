import { JSContext } from '@devzeng/quickjs';
import { router } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { TestSectionWithExpected, TestCase } from '../components/TestSection';
import { loadScriptFromRawFile } from '../utils/ScriptLoader';

@Entry
@Component
struct BasicScriptTest {
  @State cases: TestCase[] = [];

  aboutToAppear(): void {
    const context = new JSContext();
    const script = loadScriptFromRawFile(getContext(this) as common.UIAbilityContext, 'scripts/basic_script.js');
    const result = context.evaluateScript(script);

    this.cases = [
      { name: "evaluateScript('Hello World')", expected: 'Hello World', actual: result.toString() }
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
        Text('Basic Script Test')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, top: 12, bottom: 12 })

      Scroll() {
        Column({ space: 12 }) {
          TestSectionWithExpected('1. Basic Script', this.cases)
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
