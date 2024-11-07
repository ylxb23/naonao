
class Hobbits {
  name?: string
  age?: number
  hobbits?: string[]
  colors?: string[]
}

@Preview
@Entry
@Component
export struct LinkListTest {
  @State man: Hobbits = {hobbits: []}
  @State hobbits: string[] = []

  aboutToAppear(): void {
    this.man.hobbits = this.hobbits
    this.hobbits.push("WAKAKA")
  }

  build() {
    Row() {
      TextArea({text: this.man.hobbits?.length + ""}).height(40).width('100%')
      CustomList({man: this.man, hobbits: this.hobbits}).height(100)
    }.height('100%').width('100%')
  }
}

@Component
struct CustomList {
  @Link man: Hobbits
  @Link hobbits: string[]
  @State idx: number = 0

  build() {
    Row() {
      Row() {
        Button("添加").width('100%').height(30).onClick((e) => {
          this.hobbits.push((this.idx).toString())
        })
        Scroll() {
          List() {
            ForEach(this.hobbits, (item: string) => {
              ListItem() {
                Row() {
                  Text(item).width('60%').height(30).fontSize(20)
                  Blank()
                  Button("删除").width('30%').height(30).onClick((e) => {
                    this.hobbits = this.hobbits.filter((curr) => {
                      return curr.toString() != item;
                    })
                  })
                }.margin({top: 10})
              }
            })
          }.height('100%').width('100%').scrollBar(BarState.Auto)
          .alignListItem(ListItemAlign.Start).align(Alignment.TopStart)
        }.height(300)
      }
    }
  }
}