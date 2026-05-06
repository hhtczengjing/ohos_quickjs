import { JSContext, JSValue } from '@devzeng/quickjs';
import { router } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { TestSectionWithExpected, TestCase } from '../components/TestSection';
import { loadScriptFromRawFile } from '../utils/ScriptLoader';

@Entry
@Component
struct ObjectTest {
  @State section3: TestCase[] = [];
  @State section10: TestCase[] = [];

  aboutToAppear(): void {
    const context = new JSContext();
    const abilityCtx = getContext(this) as common.UIAbilityContext;

    // Property access - load from script file
    const personScript = loadScriptFromRawFile(abilityCtx, 'scripts/property_access.js');
    context.evaluateScript(personScript);
    const person = context.getGlobalProperty('person');
    this.section3 = [
      { name: "person.name", expected: 'Zhang San', actual: person.getProperty('name').toString() },
      { name: "person.age", expected: '30', actual: person.getProperty('age').toString() },
      { name: "person.city", expected: 'Beijing', actual: person.getProperty('city').toString() },
      { name: "hasProperty('name')", expected: 'true', actual: person.hasProperty('name').toString() },
      { name: "hasProperty('email')", expected: 'false', actual: person.hasProperty('email').toString() }
    ];

    // Property names iteration - load from script file
    const namesScript = loadScriptFromRawFile(abilityCtx, 'scripts/property_names.js');
    const names = context.evaluateScript(namesScript);
    const dict = names.toDictionary();
    const propNames = dict ? Object.keys(dict) : [];
    this.section10 = [
      { name: 'propertyNames', expected: 'a, c, d', actual: propNames.join(', ') }
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
        Text('Object Test')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, top: 12, bottom: 12 })

      Scroll() {
        Column({ space: 12 }) {
          TestSectionWithExpected('3. Property Access', this.section3)
          TestSectionWithExpected('10. Property Names', this.section10)
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
