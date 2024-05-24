import router from '@ohos.router'
import { Logger } from '../../common/Logger'
import { DISPLAY_BIG_HEIGHT, DISPLAY_BIG_WIDTH, EmptyCardItem } from '../../viewmodel/card/Card'

const logger: Logger = new Logger('Index')


@Preview({
  title: "Empty",
})
@Component
export struct EmptyCard {

  build() {
    Row() {
      Stack({ alignContent: Alignment.Center }) {
        Column() {
        }
        .width(180)
        .height(20)
        .backgroundColor('#fff')
        .margin({ top: 55, bottom: 55, left: 80, right: 80 })
        .borderRadius(10)

        Column() {
        }
        .width(20)
        .height(90)
        .backgroundColor('#fff')
        .margin({ top: 10, bottom: 10, left: 160, right: 160 })
        .borderRadius(10)
      }
      .width(DISPLAY_BIG_WIDTH - 20)
      .height(DISPLAY_BIG_HEIGHT - 20)
      .margin(10)
    }.width(DISPLAY_BIG_WIDTH).height(DISPLAY_BIG_HEIGHT)
    .borderRadius(10).backgroundColor('#ccc')
    .onClick(() => {
      logger.info("clicked....")
      router.pushUrl({url: "pages/card/CardAddSelection", params: new EmptyCardItem()}, () => {})
    })
  }
}