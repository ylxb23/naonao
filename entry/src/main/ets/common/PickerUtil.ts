import picker from '@ohos.file.picker';
import { Logger } from './Logger';

const logger: Logger = new Logger('PickerUtil')


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
    logger.debug("photoPickOne, pick result: %{public}s", JSON.stringify(result))
    picked = result.photoUris.length > 0 ? result.photoUris[0] : ''
  }).catch((err) => {
    logger.error("pick one photo err: %{public}s", err)
  })
  logger.info("pick one photo result: %{public}s", picked)
  return picked
}
