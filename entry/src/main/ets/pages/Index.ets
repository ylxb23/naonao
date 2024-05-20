import { Browser } from './Browser';
import { Home } from './Home';


@Entry
@Component
struct Index {
  @State currTabIdx: number = 0;
  currTabImg: string | Resource;


  @Builder TabBuilder(title: string | Resource, targetIndex: number, imgPath: Resource, onImgPath: Resource) {
    Column() {
      Image(this.currTabIdx === targetIndex ? onImgPath: imgPath)
        .fillColor(this.currTabIdx === targetIndex ? '#1296DB' : '#6B6B6B')
        .size({ width: this.currTabIdx === targetIndex ? 24 : 22,
          height: this.currTabIdx === targetIndex ? 24 : 22 })
      Text(title)
        .margin({ top: 6 })
        .fontSize(this.currTabIdx === targetIndex ? 16 : 14)
        .fontColor(this.currTabIdx === targetIndex ? '#1296DB' : '#6B6B6B')
        .fontWeight(FontWeight.Bold)
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
            Text(this.currTabIdx + '').fontColor(Color.Red).fontSize(50)
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