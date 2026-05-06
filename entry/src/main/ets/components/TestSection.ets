@Builder
export function TestSection(title: string, content: string) {
  Column() {
    Text(title)
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .fontColor('#1a73e8')
      .margin({ bottom: 4 })

    Text(content)
      .fontSize(14)
      .fontColor('#333')
      .lineHeight(22)
      .width('100%')
  }
  .width('100%')
  .padding({ left: 12, right: 12, top: 8, bottom: 8 })
  .backgroundColor('#f5f5f5')
  .borderRadius(8)
}

export interface TestCase {
  name: string;
  expected: string;
  actual: string;
}

@Builder
export function TestSectionWithExpected(title: string, cases: TestCase[]) {
  Column() {
    Text(title)
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .fontColor('#1a73e8')
      .margin({ bottom: 8 })

    ForEach(cases, (tc: TestCase) => {
      Column({ space: 4 }) {
        Text(tc.name)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#555')

        Column({ space: 2 }) {
          Row() {
            Text('Expected: ')
              .fontSize(13)
              .fontColor('#888')
            Text(tc.expected)
              .fontSize(13)
              .fontColor('#333')
              .fontWeight(FontWeight.Medium)
          }

          Row() {
            Text('Actual:   ')
              .fontSize(13)
              .fontColor('#888')
            Text(tc.actual)
              .fontSize(13)
              .fontColor(tc.expected === tc.actual ? '#2e7d32' : '#d32f2f')
              .fontWeight(FontWeight.Medium)
          }
        }
        .width('100%')
        .padding({ left: 8, top: 4, bottom: 4 })
        .backgroundColor(Color.White)
        .borderRadius(4)
      }
      .width('100%')
    })
  }
  .width('100%')
  .padding({ left: 12, right: 12, top: 8, bottom: 8 })
  .backgroundColor('#f5f5f5')
  .borderRadius(8)
}
