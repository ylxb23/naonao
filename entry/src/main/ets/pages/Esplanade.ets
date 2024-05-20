import router from '@ohos.router'
import hilog from '@ohos.hilog';

@Entry
@Component
struct Esplanade {
  @State message: number = (router.getParams() as Record<string, number>)["message"];

  onPageShow() {
  }

  build() {
    Row() {
      Column() {
        Text(`${this.message}`)
          .fontSize(50)
          .textAlign(TextAlign.Center)
          .width('100%')

        Button("Go back")
          .onClick(event => {
            router.showAlertBeforeBackPage({
              message: "Go back ???"
            })
            hilog.info(0x0000, 'testTag', `event: %s`, event)
            router.back();
          })
      }
    }
  }
}