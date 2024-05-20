import web_view from '@ohos.web.webview'

@Preview({
  title: "Browser"
})
@Component
export struct Browser {
  @State webViewController: web_view.WebviewController = new web_view.WebviewController();
  currUrl: ResourceStr = "";

  build() {
    Stack({ alignContent: Alignment.Top }) {
      // 地址栏 + 功能
      Stack({ alignContent: Alignment.Top }) {
        Row() {
          Image($r('app.media.search')).width(26).height(26)
          TextInput({ placeholder: $r('app.string.type_in_search_or_url'), text: this.currUrl }).focusable(true)
            .layoutWeight(1).backgroundColor(Color.Transparent)

          Button($r('app.string.search')).backgroundColor(Color.Gray).fontColor(Color.White)
            .borderRadius(20).onClick(event => {
            this.webViewController.loadUrl(this.currUrl)
          })
        }
        .width('100%')
        .height(50)
        .borderRadius(10)
        .backgroundColor("#eeeeee")
        .padding({ left: 20, right: 20 })
        .margin({ top: 10, bottom: 10 })
      }.height('60').width('95%')

      // 网页内容
      Web({ src: this.currUrl, controller: this.webViewController })
        .width('100%')
        .margin({top: 70})
        .backgroundColor(Color.Gray)
    }.height('100%').width('100%')
  }
}