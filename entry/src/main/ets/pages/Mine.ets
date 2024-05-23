@Preview({
  title: "Mine"
})
@Component
export struct Mine {
  tabIdx: number

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Text(this.tabIdx + '').fontColor(Color.Red).fontSize(88).margin('auto')
    }.height('100%').width('100%')
  }
}