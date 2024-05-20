
import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import hilog from '@ohos.hilog';

export default class EsplanadeAbility extends UIAbility {

  onCreate(want, launchParam) {
    // add empty card
    // read local card settings, and show
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    windowStage.loadContent("pages/Esplanade", (err, data) => {
      if(err.code) {
        hilog.error(0x0000, 'testTag', `广场页面加载失败...`)
        return;
      }

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