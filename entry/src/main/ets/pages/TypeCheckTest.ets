import { JSContext, JSValue } from '@devzeng/quickjs';
import { router } from '@kit.ArkUI';
import { TestSectionWithExpected, TestCase } from '../components/TestSection';

@Entry
@Component
struct TypeCheckTest {
  @State cases: TestCase[] = [];

  aboutToAppear(): void {
    const context = new JSContext();
    const num = JSValue.valueWithNumber(42, context);
    const str = JSValue.valueWithString('test', context);
    const obj = JSValue.valueWithNewObject(context);
    const undef = JSValue.valueWithUndefined(context);
    const nil = JSValue.valueWithNull(context);
    const bool = JSValue.valueWithBool(true, context);

    this.cases = [
      { name: 'isNumber(42)', expected: 'true', actual: num.isNumber.toString() },
      { name: 'isString(42)', expected: 'false', actual: num.isString.toString() },
      { name: "isString('test')", expected: 'true', actual: str.isString.toString() },
      { name: 'isObject(obj)', expected: 'true', actual: obj.isObject.toString() },
      { name: 'isUndefined', expected: 'true', actual: undef.isUndefined.toString() },
      { name: 'isNull', expected: 'true', actual: nil.isNull.toString() },
      { name: 'isBoolean(true)', expected: 'true', actual: bool.isBoolean.toString() },
      { name: 'isCallable(bool)', expected: 'false', actual: bool.isCallable.toString() }
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
        Text('Type Check Test')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, top: 12, bottom: 12 })

      Scroll() {
        Column({ space: 12 }) {
          TestSectionWithExpected('2. Type Checks', this.cases)
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
