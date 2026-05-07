import { router } from '@kit.ArkUI';

interface PageItem {
  title: string;
  page: string;
}

@Entry
@Component
struct Index {
  private pages: PageItem[] = [
    { title: 'Basic Script Test', page: 'pages/BasicScriptTest' },
    { title: 'Type Check Test', page: 'pages/TypeCheckTest' },
    { title: 'Object Test', page: 'pages/ObjectTest' },
    { title: 'Array Test', page: 'pages/ArrayTest' },
    { title: 'Function Test', page: 'pages/FunctionTest' },
    { title: 'Advanced Test', page: 'pages/AdvancedTest' },
    { title: 'Error / Exception Test', page: 'pages/ErrorTest' }
  ];

  build() {
    Column() {
      Text('QuickJS Demo')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 16 })

      List({ space: 8 }) {
        ForEach(this.pages, (item: PageItem) => {
          ListItem() {
            Button(item.title)
              .width('100%')
              .fontSize(16)
              .backgroundColor('#f5f5f5')
              .fontColor('#333')
              .borderRadius(8)
              .onClick(() => {
                router.pushUrl({ url: item.page });
              })
          }
          .padding({ left: 16, right: 16 })
        })
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding(16)
  }
}
