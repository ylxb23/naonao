import { http } from "@kit.NetworkKit";
import { CardObject, CardRequest, CardResponse, NamedDateItemObject } from "../viewmodel/card/Card";
import { UID } from "./Constants";
import { copyToTempDir } from "./FileUtil";
import { Logger } from "./Logger";
import { Context } from "@kit.AbilityKit";
import { CommonHttpResponse } from "./Common";

const logger: Logger = new Logger('HttpUtil')

const REMOTE_HOST:string = "http://192.168.43.167:8080";

/**
 * 获取卡片列表并保存到当地存储
 * @param uid
 * @returns
 */
export function getCardList(uid: string) {
  let url:string = REMOTE_HOST + "/cards/" + uid
  let httpRequest = http.createHttp()
  let httpRequestOptions : http.HttpRequestOptions = {
    method: http.RequestMethod.GET,
    header: { 'Content-Type': 'application/json' },
    readTimeout: 50000,
    connectTimeout: 50000
  }
  httpRequest.request(url, httpRequestOptions, (err: Error, data: http.HttpResponse) => {
    if(err != null) {
      logger.error("请求卡片列表失败, %{public}s", err.message)
      httpRequest.destroy();
      return
    }
    if(data.responseCode == http.ResponseCode.OK) {
      logger.info("请求获取到卡片列表: %{public}s", data.result)
      AppStorage.setOrCreate(uid + "-cards", data.result)
    } else {
      logger.warn("请求卡片列表失败, code: %{public}s", data.responseCode)
    }
    httpRequest.destroy();
  })
}

/**
 * 上传文件，并返回上传后的地址
 * @param uri
 * @returns
 */
export async function uploadFileRequest(uri: string, context: Context) : Promise<CommonHttpResponse> {
  let commonRes: CommonHttpResponse = {status: 0}
  if(uri.startsWith("http")) {
    // 本身是网络图片，无需在拷贝和上传
    commonRes.status = 200
    commonRes.message = uri
    return commonRes
  }
  let tmp:string = copyToTempDir(uri, context)
  if(tmp == undefined || tmp == "") {
    logger.error("拷贝本地文件失败,src: %{public}s", uri)
    commonRes.message = "拷贝本地文件失败"
    return commonRes
  }
  // 拷贝文件暂存，并返回暂存后的路径
  let url: string = REMOTE_HOST + "/upload"
  let httpRequest = http.createHttp()
  let httpRequestOptions : http.HttpRequestOptions = {
    method: http.RequestMethod.POST,
    header: { 'Content-Type': 'multipart/form-data' },
    readTimeout: 50000,
    connectTimeout: 50000,
    multiFormDataList: [
      {
        name: "file",
        contentType: "image/*",
        filePath: tmp,
      }
    ]
  }
  let response: Promise<http.HttpResponse> = httpRequest.request(url, httpRequestOptions)
  await response.then((data: http.HttpResponse) => {
      let result = data.result as string
      let res: CardResponse = JSON.parse(result)
      if(res != undefined && res.success != undefined) {
        logger.info("上传文件[%{public}s]成功，下载地址: %{public}s", uri, res.success)
        commonRes.message = res.success
        commonRes.status = 200
      }
      httpRequest.destroy();
  }).catch(() => {
      logger.error("上传文件异常: %{public}s", uri)
      // 取消订阅HTTP响应头事件
      httpRequest.off('headersReceive');
      httpRequest.destroy();
      return
  })
  return commonRes
}

/**
 * 添加卡片，并返回是否成功
 * @param card
 * @returns
 */
export async function addCardRequest(card: CardObject): Promise<CommonHttpResponse> {
  let commonRes: CommonHttpResponse = {status: 0}
  let request: CardRequest = {
    openid: UID,
    operation: "add",
    card: card
  }
  let url: string = REMOTE_HOST + "/card"
  let httpRequest = http.createHttp()
  let httpRequestOptions : http.HttpRequestOptions = {
    method: http.RequestMethod.POST,
    header: { 'Content-Type': 'application/json' },
    readTimeout: 50000,
    connectTimeout: 50000,
    extraData: JSON.stringify(request)
  }
  let response: Promise<http.HttpResponse> = httpRequest.request(url, httpRequestOptions)
  await response.then((data: http.HttpResponse) => {
    logger.info("添加卡片[%{public}s]成功: %{public}s", JSON.stringify(card), data.result)
    commonRes.status = 200
    commonRes.message = data.result.toString()
    // 当该请求使用完毕时，调用destroy方法主动销毁
    httpRequest.destroy();
  }).catch( () => {
    logger.error("添加卡片异常: %{public}s", JSON.stringify(card))
    commonRes.message = "上传失败"
    // 取消订阅HTTP响应头事件
    httpRequest.off('headersReceive');
    // 当该请求使用完毕时，调用destroy方法主动销毁
    httpRequest.destroy();
    return
  })
  return commonRes
}

/**
 * 删除卡片
 * @param card
 * @returns
 */
export async function deleteCardRequest(card: CardObject): Promise<boolean> {
  let request: CardRequest = {
    openid: UID,
    operation: "delete",
    card: card
  }
  let url: string = REMOTE_HOST + "/card"
  let httpRequest = http.createHttp()
  let httpRequestOptions : http.HttpRequestOptions = {
    method: http.RequestMethod.POST,
    header: { 'Content-Type': 'application/json' },
    readTimeout: 50000,
    connectTimeout: 50000,
    extraData: JSON.stringify(request)
  }
  let result: boolean = false
  let response: Promise<http.HttpResponse> = httpRequest.request(url, httpRequestOptions)
  await response.then((data: http.HttpResponse) => {
    logger.info("删除卡片[%{public}s]成功: %{public}s", JSON.stringify(card), data.result)
    result = true
    httpRequest.destroy();
  }).catch( () => {
    logger.error("删除卡片异常: %{public}s", JSON.stringify(card))
    httpRequest.off('headersReceive');
    httpRequest.destroy();
    return
  })
  return result
}

/**
 * 添加卡片
 * @param cardObject
 * @param context
 * @returns
 */
export async function doAddCardRequest(cardObject: CardObject, context: Context): Promise<CommonHttpResponse> {
  let commonRes: CommonHttpResponse = {status: 100} // 默认进行中
  // 上传图片并替换成上传成功的地址
  logger.debug("上传卡片本地内容: %{public}s", JSON.stringify(cardObject))
  // 上传根图片
  if(cardObject.background != undefined || cardObject.background != "") {
    let rootPicP: Promise<CommonHttpResponse> = uploadFileRequest(cardObject.background, context)
    await rootPicP.then((res) => {
      if(res.status == 200) {
        logger.debug("上传卡片根图片[%{public}s]成功, 上传结果: %{public}s", cardObject.background, res.message)
        cardObject.background = res.message
      } else {
        logger.warn("上传卡片根图片[%{public}s]失败: %{public}s", cardObject.background, res.message)
        commonRes.message = res.message
        commonRes.status = 0  // 已经失败了
      }
    })
  }
  if(commonRes.status == 0) {
    return commonRes
  }
  // 上传列表中的图片
  for(let i=0; i<cardObject.list?.length; i++) {
    let item:NamedDateItemObject = cardObject.list[i]
    let listPicP: Promise<CommonHttpResponse> = uploadFileRequest(item.avatar, context)
    await listPicP.then((res) => {
      if(res.status == 200) {
        logger.debug("上传卡片列表图片[%{public}s]成功, 上传结果: %{public}s", item.avatar, res.message)
        item.avatar = res.message
      } else {
        logger.warn("上传卡片列表图片[%{public}s]失败: %{public}s", item.avatar, res.message)
        commonRes.message = res.message
        commonRes.status = 0  // 已经失败了
      }
    })
    if(commonRes.status == 0) {
      logger.debug("上传卡片列表图片过程失败,卡片内容: %{public}s", JSON.stringify(cardObject))
      return commonRes
    }
  }
  logger.debug("上传卡片实际内容: %{public}s", JSON.stringify(cardObject))
  // 请求添加卡片
  let addP: Promise<CommonHttpResponse> = addCardRequest(cardObject)
  await addP.then((res) => {
    if(res.status == 200) {
      logger.info("上传卡片成功了, 实际内容: %{public}s", JSON.stringify(cardObject))
      commonRes.status = 200
      commonRes.message = res.message
    } else {
      logger.warn("上传卡片失败了, 实际内容: %{public}s", JSON.stringify(cardObject))
    }
  })
  return commonRes
}