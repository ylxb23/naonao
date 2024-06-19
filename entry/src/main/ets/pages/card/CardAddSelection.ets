import router from '@ohos.router';
import fs from '@ohos.file.fs';
import hash from '@ohos.file.hash'
import { Logger } from '../../common/Logger';
import { AnniversaryCardEdit } from '../../view/card/AnniversaryCard';
import {
  AbsCard,
  AnniversaryCardItem,
  CardTypeEnum,
  CountdownCardItem,
  CountdownListCardItem,
} from '../../viewmodel/card/Card';
import { random, randomLower } from '../../common/Tool';
import { insertCardItem } from '../../common/DataUtil';


const logger: Logger = new Logger("CardAddSelection")

@Preview({
  title: "CardAdd"
})
@Entry
@Component
struct CardAddSelection {
  @State fromCard: AbsCard | null = (router.getParams() as AbsCard);
  @State selectedCardTypeName: string = '';

  constructor() {
    super()
    this.fromCard = (router.getParams() as AbsCard);
    logger.debug("fromCard get form router params is: %s", JSON.stringify(this.fromCard))
  }

  aboutToAppear() {
    if (this.fromCard.type == CardTypeEnum.Empty) {
      this.fromCard = new AnniversaryCardItem('', new Date())
    }
  }

  build() {
    Column() {
      // 功能选项
      Row() {
        Image($r('app.media.reject2')).height(30).width(30).margin({ left: 16 }).onClick(() => {
          router.back()
        })
        Blank()
        Image($r('app.media.accept2')).height(30).width(30).margin({ right: 16 }).onClick(() => {
          logger.debug("confirmed item info: %s", JSON.stringify(this.fromCard));

          // let realCardItem;
          // switch (this.fromCard.type) {
          //   case CardTypeEnum.Empty:
          //     realCardItem = this.fromCard as EmptyCardItem;
          //   case CardTypeEnum.Anniversary:
          //     realCardItem = this.fromCard as AnniversaryCardItem;
          //   case CardTypeEnum.AnniversaryList:
          //     realCardItem = this.fromCard as AnniversaryCardItem; // TODO
          //   case CardTypeEnum.Countdown:
          //     realCardItem = this.fromCard as CountdownCardItem;
          //   case CardTypeEnum.CountdownList:
          //     realCardItem = this.fromCard as CountdownListCardItem;
          //   default:
          //     break;
          // }
          let dstUri = getContext().filesDir + "/cards";
          fs.access(dstUri, (exists) => {
            if (!exists) {
              fs.mkdir(dstUri);
            }
            var realCardItem: AnniversaryCardItem = (this.fromCard as AnniversaryCardItem);

            dstUri += "/" + randomLower(32);
            logger.debug("目标文件路径将为: %s", dstUri);
            fs.open(realCardItem.backgroundImgUri, fs.OpenMode.READ_ONLY, (err, srcFile: fs.File) => {
              if (err) {
                logger.error("打开源文件失败, message: %s, code: %d", err.message, err.name);
              } else {
                logger.info("打开源文件: %s, fd: %d", realCardItem.backgroundImgUri, srcFile.fd);
                fs.open(dstUri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE, (err, dstFile: fs.File) => {
                  if (err) {
                    logger.error("创建本地文件失败, message: %s, name: %d", err.message, err.name);
                  } else {
                    logger.info("打开目标文件: %s, fd: %d", dstUri, dstFile.fd);
                    fs.copyFile(srcFile.fd, dstFile.fd, 0)
                      .then(() => {
                        logger.debug("文件复制成功, dstFile fd: %d", dstFile.fd);
                        realCardItem.backgroundImgUri = dstUri;
                        logger.info("文件复制成功, 目标文件路径: %s", realCardItem.backgroundImgUri);

                        fs.close(dstFile);
                        fs.close(srcFile);

                        logger.info("实际保存的卡片信息为from: %s", JSON.stringify(this.fromCard))
                        logger.info("实际保存的卡片信息为real: %s", JSON.stringify(realCardItem))
                        insertCardItem(getContext(this), this.fromCard);
                      }).catch((err) => {
                      logger.warn("图片复制失败, message: %s, name: %d", err.message, err.code);
                    });
                  }
                });
              }
            });
          });

          logger.info("保存的卡片信息为: %s", JSON.stringify(this.fromCard))
        })
      }.height(50).width('100%').margin({ top: 10 })

      // 卡片类型选择
      Text(this.selectedCardTypeName)
        .height(40)
        .lineHeight(40)
        .width('100%')
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.Grey)
        .textAlign(TextAlign.Center)
        .borderRadius(3)
        .backgroundColor('#eee')
        .onClick(() => {
          TextPickerDialog.show({
            range: [
              "空卡片", // 0
              "纪念日卡片", // 1
              "纪念日列表卡片", // 2
              "倒计时卡片", // 3
              "倒计时列表卡片", // 4
              "进度卡片", // 5
              "代办列表卡片", // 6
            ],
            value: this.selectedCardTypeName,
            onAccept: (v: TextPickerResult) => {
              this.selectedCardTypeName = v.value
              logger.debug("选择的卡片类型是: %s, idx: %d", this.selectedCardTypeName, v.index)
            }
          })
        })

      Flex({ justifyContent: FlexAlign.Center }) {
        if (this.fromCard instanceof AnniversaryCardItem) {
          AnniversaryCardEdit({ cardItem: $fromCard }).width(150).height(150)
            .margin(10)
        } else if (this.fromCard instanceof CountdownCardItem) {

        } else if (this.fromCard instanceof CountdownListCardItem) {

        } else {
          AnniversaryCardEdit({ cardItem: $fromCard }).width(150).height(150)
            .margin(10)
        }
      }.margin({ top: 30 })
    }.width('100%').height('100%')
  }
}