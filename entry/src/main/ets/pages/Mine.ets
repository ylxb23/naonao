@Preview({
  title: "Mine"
})
@Component
export struct Mine {
  tabIdx: number = 0

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Text(this.tabIdx + '').fontColor(Color.Red).fontSize(88).margin('auto')

      List() {
        ListItem() {

        }
      }
    }.height('100%').width('100%')
  }
}