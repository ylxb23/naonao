import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import { Logger } from '../common/Logger';
import relationalStore from '@ohos.data.relationalStore';
import { getCardList } from '../common/HttpUtil';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Want from '@ohos.app.ability.Want';
import { UID } from '../common/Constants';

const logger: Logger = new Logger('EntryAbility')
export var sqlite: relationalStore.RdbStore;

export default class EntryAbility extends UIAbility {


  onCreate(want, launchParam) {
    logger.debug("onCreate, want: %s, launchParam: %s", JSON.stringify(want), JSON.stringify(launchParam))
    // 加载卡片信息
    getCardList(UID)
  }

  onDestroy() {
    logger.info('%{public}s', '首页 Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    logger.info('%{public}s', '首页 Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        logger.error('首页 Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      logger.info('首页 Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
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
    getCardList(UID)
  }
}