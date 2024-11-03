import { http } from "@kit.NetworkKit";
import { CardObject, CardRequest, CardResponse } from "../viewmodel/card/Card";
import { UID } from "./Constants";
import { copyToTempDir } from "./FileUtil";
import { Logger } from "./Logger";
import { Context } from "@kit.AbilityKit";
import fs from '@ohos.file.fs';

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
      logger.error("请求卡片列表失败, %{public}v", err)
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
export async function uploadFileRequest(uri: string, context: Context) : Promise<string> {
  let tmp:string = copyToTempDir(uri, context)
  if(tmp == undefined || tmp == "") {
    logger.error("拷贝本地文件失败,src: %{public}s", uri)
    return ""
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
  let uploaded: string = ""
  let response: Promise<http.HttpResponse> = httpRequest.request(url, httpRequestOptions)
  await response.then((data: http.HttpResponse) => {
      let result = data.result as string
      let res: CardResponse = JSON.parse(result)
      if(res != undefined && res.success != undefined) {
        logger.info("上传文件[%{public}s]成功，下载地址: %{public}s", uri, res.success)
        uploaded = res.success
      }
      httpRequest.destroy();
  }).catch(() => {
      logger.error("上传文件异常: %{public}s", uri)
      // 取消订阅HTTP响应头事件
      httpRequest.off('headersReceive');
      httpRequest.destroy();
      return
  })
  return uploaded
}

/**
 * 添加卡片，并返回是否成功
 * @param card
 * @returns
 */
export async function addCardRequest(card: CardObject): Promise<boolean> {
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
  let result: boolean = false
  let response: Promise<http.HttpResponse> = httpRequest.request(url, httpRequestOptions)
  await response.then((data: http.HttpResponse) => {
    logger.info("添加卡片[%{public}s]成功: %{public}s", JSON.stringify(card), data.result)
    result = true
    // 当该请求使用完毕时，调用destroy方法主动销毁
    httpRequest.destroy();
  }).catch( () => {
      logger.error("添加卡片异常: %{public}s", JSON.stringify(card))
      // 取消订阅HTTP响应头事件
      httpRequest.off('headersReceive');
      // 当该请求使用完毕时，调用destroy方法主动销毁
      httpRequest.destroy();
      return
  })
  return result
}