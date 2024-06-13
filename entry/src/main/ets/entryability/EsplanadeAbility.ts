
import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import { Logger } from '../common/Logger';

const logger: Logger = new Logger('esplanade')

export default class EsplanadeAbility extends UIAbility {

  onCreate(want, launchParam) {
    // add empty card
    // read local card settings, and show
    logger.debug("onCreate, want: %s, launchParam: %s", JSON.stringify(want), JSON.stringify(launchParam))
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    windowStage.loadContent("pages/Esplanade", (err, data) => {
      if(err.code) {
        logger.error(`广场页面加载失败...`)
        return;
      }
      logger.debug("onWindowStageCreate, data: %s", JSON.stringify(data))
    });
  }

  onWindowStageRestore(windowStage: window.WindowStage) {

  }

  onForeground() {}

  onBackground() {}

  onDestroy() {
    // remove all cards
    //
  }

  onWindowStageDestroy() {}
}