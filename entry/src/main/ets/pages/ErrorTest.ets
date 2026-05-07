import { JSContext, JSValue } from '@devzeng/quickjs';
import { router } from '@kit.ArkUI';
import { TestSectionWithExpected, TestCase } from '../components/TestSection';

@Entry
@Component
struct ErrorTest {
  @State sectionCreate: TestCase[] = [];
  @State sectionType: TestCase[] = [];
  @State sectionDetails: TestCase[] = [];
  @State sectionException: TestCase[] = [];
  @State sectionThrow: TestCase[] = [];
  @State sectionHandler: TestCase[] = [];

  aboutToAppear(): void {
    const ctx = new JSContext();

    // ========== 1. 创建不同类型的错误 ==========
    const err = JSValue.valueWithNewError('general error', ctx);
    const typeErr = JSValue.valueWithNewTypeError('type error msg', ctx);
    const rangeErr = JSValue.valueWithNewRangeError('range error msg', ctx);
    const syntaxErr = JSValue.valueWithNewSyntaxError('syntax error msg', ctx);
    const refErr = JSValue.valueWithNewReferenceError('ref error msg', ctx);

    this.sectionCreate = [
      { name: 'Error.name', expected: 'Error', actual: err.getProperty('name').toString() },
      { name: 'Error.message', expected: 'general error', actual: err.getProperty('message').toString() },
      { name: 'TypeError.name', expected: 'TypeError', actual: typeErr.getProperty('name').toString() },
      { name: 'TypeError.message', expected: 'type error msg', actual: typeErr.getProperty('message').toString() },
      { name: 'RangeError.name', expected: 'RangeError', actual: rangeErr.getProperty('name').toString() },
      { name: 'SyntaxError.name', expected: 'SyntaxError', actual: syntaxErr.getProperty('name').toString() },
      { name: 'ReferenceError.name', expected: 'ReferenceError', actual: refErr.getProperty('name').toString() }
    ];

    // ========== 2. isError 类型检查 ==========
    const obj = JSValue.valueWithNewObject(ctx);
    const str = JSValue.valueWithString('hello', ctx);
    const num = JSValue.valueWithNumber(42, ctx);
    const arr = JSValue.valueWithNewArray(ctx);
    const errObj = JSValue.valueWithNewError('test', ctx);
    const excResult = ctx.evaluateScript('throw new Error("exc test")');

    this.sectionType = [
      { name: 'Error isError', expected: 'true', actual: errObj.isError.toString() },
      { name: 'Object isError', expected: 'false', actual: obj.isError.toString() },
      { name: 'String isError', expected: 'false', actual: str.isError.toString() },
      { name: 'Number isError', expected: 'false', actual: num.isError.toString() },
      { name: 'Array isError', expected: 'false', actual: arr.isError.toString() },
      { name: 'throw result isException', expected: 'true', actual: excResult.isException.toString() }
    ];

    // ========== 3. 错误详情 accessor ==========
    const detailedErr = JSValue.valueWithNewError('detailed message', ctx);
    // set name explicitly for clarity
    detailedErr.setValue(JSValue.valueWithString('CustomError', ctx), 'name');

    this.sectionDetails = [
      { name: 'errorName', expected: 'CustomError', actual: detailedErr.errorName },
      { name: 'errorMessage', expected: 'detailed message', actual: detailedErr.errorMessage },
      { name: 'non-error errorName', expected: '', actual: obj.errorName },
      { name: 'non-error errorMessage', expected: '', actual: obj.errorMessage }
    ];

    // ========== 4. 获取 pending exception ==========
    ctx.evaluateScript('var x = 10'); // valid script
    const validRet = ctx.evaluateScript('42');

    ctx.evaluateScript('throw new Error("pending exc")');
    const pendingExc = ctx.exception;

    this.sectionException = [
      { name: 'valid script exception', expected: 'null', actual: (validRet.isException ? validRet.toString() : 'null') },
      { name: 'pending exception isException', expected: 'true', actual: pendingExc ? pendingExc.isException.toString() : 'false' },
      { name: 'pending exception isError', expected: 'true', actual: pendingExc ? pendingExc.isError.toString() : 'false' },
      { name: 'pending exception message', expected: 'pending exc', actual: pendingExc ? pendingExc.errorMessage : 'null' }
    ];

    // ========== 5. 主动抛出异常 ==========
    const myErr = JSValue.valueWithNewTypeError('my type error', ctx);
    ctx.exception = myErr;
    const afterThrow = ctx.exception;

    this.sectionThrow = [
      { name: 'set exception then get', expected: 'true', actual: (afterThrow ? afterThrow.isError.toString() : 'false') },
      { name: 're-thrown error message', expected: 'my type error', actual: afterThrow ? afterThrow.errorMessage : 'null' },
      { name: 're-thrown error name', expected: 'TypeError', actual: afterThrow ? afterThrow.errorName : 'null' }
    ];

    // ========== 6. exceptionHandler 回调 ==========
    let handlerCalled = false;
    let handlerMsg = '';
    let handlerName = '';
    ctx.exceptionHandler = (context, exception) => {
      handlerCalled = true;
      handlerMsg = exception.errorMessage;
      handlerName = exception.errorName;
    };

    ctx.evaluateScript('throw new Error("handler test")');

    this.sectionHandler = [
      { name: 'handler called', expected: 'true', actual: handlerCalled.toString() },
      { name: 'handler message', expected: 'handler test', actual: handlerMsg },
      { name: 'handler name', expected: 'Error', actual: handlerName }
    ];

    ctx.release();
  }

  build() {
    Column() {
      Row() {
        Button('\u2190 Back')
          .fontSize(16)
          .fontColor('#1a73e8')
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            router.back();
          })
        Text('Error / Exception Test')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, top: 12, bottom: 12 })

      Scroll() {
        Column({ space: 12 }) {
          TestSectionWithExpected('1. 创建不同类型的错误', this.sectionCreate)
          TestSectionWithExpected('2. isError / isException 类型检查', this.sectionType)
          TestSectionWithExpected('3. 错误详情 accessor (errorName/errorMessage)', this.sectionDetails)
          TestSectionWithExpected('4. 获取 pending exception', this.sectionException)
          TestSectionWithExpected('5. 主动抛出异常 (exception setter)', this.sectionThrow)
          TestSectionWithExpected('6. exceptionHandler 回调', this.sectionHandler)
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
