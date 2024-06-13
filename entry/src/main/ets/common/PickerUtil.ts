import picker from '@ohos.file.picker';
import { AbsCard } from '../viewmodel/card/Card';
import { Logger } from './Logger';

const logger: Logger = new Logger('PickerUtil')

export async function pickupOneImageForCardItem(item: AbsCard) {
  let res: Promise<string> = photoPickOne()
}

/**
 * 从相册中获取一张图片，返回图片路径
 * @returns
 */
export async function photoPickOne(): Promise<string> {
  let options: picker.PhotoSelectOptions = new picker.PhotoSelectOptions()
  options.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE
  options.maxSelectNumber = 1
  let photoPicker = new picker.PhotoViewPicker()
  let picked: string
  await photoPicker.select(options).then((result: picker.PhotoSelectResult) => {
    logger.debug("photoPickOne, pick result: %s", JSON.stringify(result))
    picked = result.photoUris.length > 0 ? result.photoUris[0] : ''
  }).catch((err) => {
    logger.error("pick one photo err: %s", err)
  })
  logger.info("pick one photo result: %s", picked)
  return picked
}
