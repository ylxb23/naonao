
@Preview({
  title: "Mine"
})
@Component
export struct Mine {
  tabIdx: number = 0

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Text(this.tabIdx+"").width('100%')
    }.height('100%').width('100%')
  }
}