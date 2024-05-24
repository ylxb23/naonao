import { Browser } from './Browser';
import { Home } from './Home';
import { Mine } from './Mine';

@Preview({
  title: "Index",
  deviceType: "phone",
  width: 1176,
  height: 2400,
  colorMode: 'light', //显示的亮/暗模式，取值为light或dark
  dpi: 480, //预览设备的屏幕DPI值
  locale: 'zh_CN', //预览设备的语言，如zh_CN、en_US等
})
@Entry
@Component
struct Index {
  @State currTabIdx: number = 0;

  @Builder TabBuilder(title: string | Resource, targetIndex: number, imgPath: Resource, onImgPath: Resource) {
    Column() {
      Image(this.currTabIdx === targetIndex ? onImgPath : imgPath)
        .fillColor(this.currTabIdx === targetIndex ? '#1296DB' : '#6B6B6B')
        .size({ width: this.currTabIdx === targetIndex ? 24 : 22,
          height: this.currTabIdx === targetIndex ? 24 : 22 })
      Text(title)
        .margin({ top: 6 })
        .fontSize(this.currTabIdx === targetIndex ? 16 : 14)
        .fontColor(this.currTabIdx === targetIndex ? '#1296DB' : '#6B6B6B')
        .fontWeight(FontWeight.Normal)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%').height('100%')
    .justifyContent(FlexAlign.Center)
    .border({ width: { top: 0.5 }, color: '#cccccc' })
  }

  build() {
    Row() {
      Column() {
        Tabs() {
          TabContent() {
            Home()
          }.tabBar(this.TabBuilder($r('app.string.Bar_main'), 0, $r('app.media.home'), $r('app.media.home2')))

          TabContent() {
            Browser()
          }.tabBar(this.TabBuilder($r('app.string.Bar_browser'), 1, $r('app.media.article'), $r('app.media.article2')))

          TabContent() {
            Mine({tabIdx: 2})
          }.tabBar(this.TabBuilder($r('app.string.Bar_mine'), 2, $r('app.media.user'), $r('app.media.user2')))
        }
        .barPosition(BarPosition.End)
        .vertical(false)
        .scrollable(false)
        .barMode(BarMode.Fixed)
        .onChange(idx => {
          this.currTabIdx = idx
        })

      }.width('100%')
    }.height('100%').width('100%')
  }
}