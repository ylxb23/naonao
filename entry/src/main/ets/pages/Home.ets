import { AnniversaryCard } from '../view/card/AnniversaryCard'
import { CountdownListCard } from '../view/card/CountdownListCard'
import { CountdownCard } from '../view/card/CountdownCard'

@Preview({
  title: "Home"
})

@Component
export struct Home {
  build() {
    Scroll() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceEvenly }) {
        CountdownListCard().width('100%').height(150)
          .margin({ top: 10, bottom: 10 })

        CountdownCard().width('100%').height(150)

        AnniversaryCard().width('100%').height('50%')
          .margin(10)
      }
    }.width('100%')
  }
}