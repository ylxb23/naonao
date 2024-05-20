import { AnniversaryPanel } from './cards/AnniversaryPanel'
import { BirthdayCountdownPanel } from './cards/BirthdayCountdownPanel'
import { CountdownPanel } from './cards/CountdownPanel'

@Preview({
  title: "Home"
})
@Component
export struct Home {
  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceEvenly }) {
      BirthdayCountdownPanel().width('100%').height(150)
        .margin({ top: 10, bottom: 10 })

      CountdownPanel().width('100%').height(150)
        .margin(10)

      AnniversaryPanel().width('100%').height('50%')
        .margin(10)

    }.width('100%').height('100%')
  }
}