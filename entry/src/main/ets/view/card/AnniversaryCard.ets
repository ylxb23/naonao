import picker from '@ohos.file.picker'
import image from '@ohos.multimedia.image'
import fs from '@ohos.file.fs'
import { CARD_FRONT_FONT_OPACITY } from '../../common/Constants'
import { Logger } from '../../common/Logger'
import { AnniversaryCardItem, DISPLAY_MIDDLE_HEIGHT, DISPLAY_MIDDLE_WIDTH } from '../../viewmodel/card/Card'
import { daysPassedOfDate, formatDate } from '../../viewmodel/card/Countdown'
import router from '@ohos.router'

const logger: Logger = new Logger("AnniversaryCard")

@Preview({
  title: "AnniversaryEdit"
})
@Component
export struct AnniversaryCardEdit {
  @Link cardItem: AnniversaryCardItem
  @State title: string = ''
  @State date: string = formatDate(new Date('2023-08-02T04:03:00'))
  @State imagePixMap: image.PixelMap | Resource = $r('app.media.camerax')

  constructor() {
    super()
    this.cardItem = (router.getParams() as AnniversaryCardItem);
  }

  aboutToAppear() {
    logger.debug("get from card item: %s", JSON.stringify(this.cardItem))
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceAround, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceEvenly }) {
      this.AnniversaryEdit()
    }
  }

  @Builder AnniversaryEdit() {
    Column() {
      Image(this.imagePixMap)
        .zIndex(-1)
        .position({ x: 0, y: 0 })
        .height('100%')
        .width('100%')
        .align(Alignment.Center)
        .borderRadius(10)
        .objectFit(ImageFit.Cover)

      TextInput({ text: this.title, placeholder: $r('app.string.Card_InputName') })
        .width('100%')
        .height(30)
        .textAlign(TextAlign.Center)
        .fontSize(13)
        .fontColor(Color.White)
        .placeholderColor('#eee')
        .backgroundColor('#ccc')
        .placeholderFont({ size: 13, weight: FontWeight.Bold })
        .fontWeight(FontWeight.Bold)
        .opacity(CARD_FRONT_FONT_OPACITY)
        .borderRadius({ topLeft: 10, topRight: 10, bottomLeft: 0, bottomRight: 0 })
        .onChange((v) => {
          this.title = v
          this.cardItem.title = this.title
        })
      Blank()
        .onClick(async (_e) => {
          logger.debug("打开图片选择器...");
          let options: picker.PhotoSelectOptions = new picker.PhotoSelectOptions()
          options.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE
          options.maxSelectNumber = 1
          let photoPicker = new picker.PhotoViewPicker()
          await photoPicker.select(options).then((result: picker.PhotoSelectResult) => {
            logger.debug("photoPickOne, pick result: %s", JSON.stringify(result));
            let selected = result.photoUris.length > 0 ? result.photoUris[0] : '';
            this.cardItem.backgroundImgUri = selected;
            fs.open(selected, fs.OpenMode.READ_ONLY, (err: Error, file: fs.File) => {
              if (err) {
                logger.error("打开选择的图片失败, err: %s, %s", err.name, err.message)
              } else {
                let imageSource: image.ImageSource = image.createImageSource(file.fd);
                logger.debug("create image source from url: %s", imageSource);
                let imagePix: Promise<PixelMap> = imageSource.createPixelMap()
                imagePix.then((value: image.PixelMap) => {
                  this.imagePixMap = value
                  logger.info("get image pixel map: ", this.imagePixMap.getPixelBytesNumber())
                });
                fs.close(file);
              }
            });
          }).catch((err) => {
            logger.error("pick one photo err: %s", err)
          })
        })

      Text(this.date)
        .width('100%')
        .height(30)
        .lineHeight(30)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .backgroundColor('#ccc')
        .opacity(CARD_FRONT_FONT_OPACITY)
        .borderRadius({ topLeft: 0, topRight: 0, bottomLeft: 10, bottomRight: 10 })
        .onClick(() => {
          DatePickerDialog.show({
            start: new Date('1970-1-1'),
            end: new Date('2100-1-1'),
            selected: new Date(this.date),
            onAccept: (value: DatePickerResult) => {
              let selected = new Date();
              selected.setFullYear(value.year, value.month, value.day)
              this.date = formatDate(selected);
              this.cardItem.date = selected
              console.info('select current date is: ' + JSON.stringify(value))
            }
          })
        })
    }
    .width(DISPLAY_MIDDLE_WIDTH)
    .height(DISPLAY_MIDDLE_HEIGHT)
    .alignItems(HorizontalAlign.Center)
    .borderRadius(10)
    .backgroundColor('#eee')
  }
}


@Preview({
  title: "Anniversary"
})
@Component
export struct AnniversaryCard {
  private info: AnniversaryCardItem

  aboutToAppear() {
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceAround, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceEvenly }) {
      this.Anniversary(this.info)
    }
  }

  @Builder
  Anniversary(info: AnniversaryCardItem) {
    Column() {
      Text(info.title)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')
        .height(30)
        .margin({ top: 5 })
        .textAlign(TextAlign.Center)
        .fontSize(20)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .opacity(CARD_FRONT_FONT_OPACITY)
      Row() {
        Text(daysPassedOfDate(info.date) + ' ')
          .textAlign(TextAlign.Center)
          .fontSize(45)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bolder)
          .opacity(CARD_FRONT_FONT_OPACITY)
        Text($r('app.string.DaysPassed'))
          .textAlign(TextAlign.Center)
          .fontSize(10)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .opacity(CARD_FRONT_FONT_OPACITY)
      }.width('100%').height(80).align(Alignment.Bottom).justifyContent(FlexAlign.Center)

      Text(formatDate(info.date))
        .width('100%')
        .height(30)
        .padding({ top: 5 })
        .textAlign(TextAlign.Center)
        .fontSize(20)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .opacity(CARD_FRONT_FONT_OPACITY)
    }
    .width(DISPLAY_MIDDLE_WIDTH)
    .height(DISPLAY_MIDDLE_HEIGHT)
    .alignItems(HorizontalAlign.Center)
    .borderRadius(10)
    .backgroundColor('#ccc')
    .backgroundImageSize({ height: DISPLAY_MIDDLE_HEIGHT, width: DISPLAY_MIDDLE_WIDTH })
    .backgroundImagePosition(Alignment.Center)
    .priorityGesture(LongPressGesture({ repeat: false }).onAction((_e) => {
      // 长按事件动作
      // TODO: 将当前显示对象替换成编辑模式
    }).onActionEnd((_e) => {
      // TODO: 更新当前卡片内容
    }), GestureMask.Normal)
  }
}
