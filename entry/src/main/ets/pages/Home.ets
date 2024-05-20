import {BirthdayCountdownPanel} from './cards/BirthdayCountdownPanel'

@Preview({
  title: "Home"
})

@Component
export struct Home {

  build() {
    Stack({alignContent: Alignment.Bottom}) {
      Stack({alignContent: Alignment.TopStart}) {
        BirthdayCountdownPanel()
      }
    }.width('100%')
  }
}