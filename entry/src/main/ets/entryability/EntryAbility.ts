import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import { Logger } from '../common/Logger';
import { getCardList } from '../common/HttpUtil';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@kit.BasicServicesKit';

const logger: Logger = new Logger('EntryAbility')

/**
 * 卡片首页入口
 */
export default class EntryAbility extends UIAbility {

  // UIAbility启动时:
  // onCreate() -> onWindowStageCreate() -> onForeground() -> SHOWN -> ACTIVE ->
  // 切换到后台时:
  // onNewWant() -> onFore

  onCreate(want, launchParam) {
    logger.debug("onCreate, want: %s, launchParam: %s", JSON.stringify(want), JSON.stringify(launchParam))
  }

  onDestroy() {
    logger.info('%{public}s', '首页 Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    logger.info('%{public}s', '首页 Ability onWindowStageCreate');
    windowStage.on("windowStageEvent", (data: window.WindowStageEventType) => {
      switch (data) {
        case window.WindowStageEventType.SHOWN: // 切到前台
          logger.info(`windowStage foreground.`);
          break;
        case window.WindowStageEventType.ACTIVE: // 获焦状态
          logger.info(`windowStage active.`);
          break;
        case window.WindowStageEventType.INACTIVE: // 失焦状态
          logger.info(`windowStage inactive.`);
          break;
        case window.WindowStageEventType.HIDDEN: // 切到后台
          logger.info(`windowStage background.`);
          break;
        case window.WindowStageEventType.RESUMED: // 前台可交互状态
          logger.info(`windowStage resumed.`);
          break;
        case window.WindowStageEventType.PAUSED: // 前台不可交互状态
          logger.info(`windowStage paused.`);
          break;
        default:
          break;
      }
    })
    getCardList()
    logger.info("getCardList in home.")

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        logger.error('首页 Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      logger.info('首页 Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageWillDestroy(windowStage: window.WindowStage): void {
    if(windowStage) {
      try {
        windowStage.off("windowStageEvent")
      } catch (err) {
        logger.error(`释放 windowStageEvent监听失败, ${(err as BusinessError).code} - ${(err as BusinessError).message}`)
      }
    }
  }

  onWindowStageDestroy() {
    // 用于释放UI资源
    // Main window is destroyed, release UI related resources
    logger.info('首页 %{public}s', 'Ability onWindowStageDestroy');

  }

  onForeground() {
    // Ability has brought to foreground
    logger.info('首页 %{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    logger.info('首页 %{public}s', 'Ability onBackground');
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    logger.info('首页 %{public}s', 'Ability onNewWant');
  }
}