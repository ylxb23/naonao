
class Hobbits {
  name?: string
  age?: number
  hobbits?: string[]
  colors?: string[]
}

@Preview
@Component
export struct LinkListTest {
  @State man: Hobbits = {}

  @State idx: number = 0

  aboutToAppear(): void {
    this.man.hobbits = []
    this.man.hobbits.push("WAKAKA")
  }

  build() {
    Row() {
      Column() {
        Button("添加").width('100%').height(30).onClick((e) => {
          this.man.hobbits?.push((this.idx).toString())
          this.idx++
          this.man.age = this.idx
        })
        List() {
          ForEach(this.man.hobbits, (item: string) => {
            ListItem() {
              Row() {
                Text(item).width('60%').height(30).fontSize(20)
                Blank()
                Button("删除").width('30%').height(30).onClick((e) => {
                  this.man.hobbits = this.man.hobbits?.filter((curr) => {
                    return curr.toString() != item;
                  })
                })
              }.margin({top: 10})
            }
          })
        }.height('100%').width('100%').scrollBar(BarState.Auto)
        .alignListItem(ListItemAlign.Start).align(Alignment.TopStart)
      }.height('100%').width('100%')
    }.height('100%').width('100%')
  }
}