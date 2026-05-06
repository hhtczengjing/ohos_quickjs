import { JSContext, JSValue } from '@devzeng/quickjs';
import { router } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { TestSectionWithExpected, TestCase } from '../components/TestSection';
import { loadScriptFromRawFile } from '../utils/ScriptLoader';

@Entry
@Component
struct ArrayTest {
  @State section4: TestCase[] = [];
  @State section11: TestCase[] = [];

  aboutToAppear(): void {
    const context = new JSContext();
    const abilityCtx = getContext(this) as common.UIAbilityContext;

    // Array operations - load from script file
    const arrScript = loadScriptFromRawFile(abilityCtx, 'scripts/array_ops.js');
    context.evaluateScript(arrScript);
    const arr = context.getGlobalProperty('arr');
    this.section4 = [
      { name: 'arr.length', expected: '3', actual: arr.arrayLength.toString() },
      { name: 'arr[0]', expected: '10', actual: arr.valueAtIndex(0).toNumber().toString() },
      { name: 'arr[2]', expected: '30', actual: arr.valueAtIndex(2).toNumber().toString() }
    ];

    // Dictionary conversion - load from script file
    const dictScript = loadScriptFromRawFile(abilityCtx, 'scripts/dict_convert.js');
    context.evaluateScript(dictScript);
    const dictObj = context.getGlobalProperty('dictObj');
    const dict = dictObj.toDictionary();
    let dictName = '';
    let dictAge = '';
    let dictActive = '';
    if (dict) {
      dictName = dict['name']?.toString() ?? '';
      dictAge = dict['age']?.toString() ?? '';
      dictActive = dict['active']?.toString() ?? '';
    }

    // Array conversion - load from script file
    const arrConvertScript = loadScriptFromRawFile(abilityCtx, 'scripts/array_convert.js');
    context.evaluateScript(arrConvertScript);
    const numArr = context.getGlobalProperty('numArr');
    const arrVals = numArr.toArray();
    const arrStr = arrVals ? arrVals.map((v) => v.toNumber().toString()).join(', ') : 'null';
    this.section11 = [
      { name: 'toDictionary.name', expected: 'Alice', actual: dictName },
      { name: 'toDictionary.age', expected: '25', actual: dictAge },
      { name: 'toDictionary.active', expected: 'false', actual: dictActive },
      { name: 'toArray', expected: '100, 200, 300', actual: arrStr }
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
        Text('Array Test')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, top: 12, bottom: 12 })

      Scroll() {
        Column({ space: 12 }) {
          TestSectionWithExpected('4. Array Operations', this.section4)
          TestSectionWithExpected('11. Dictionary & Array Conversion', this.section11)
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
