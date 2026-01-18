'use strict';

export class CommonUtils {
  public static async countDownLatch(count: number) {
    while (count > 0) {
      await this.sleep(40);
      count--;
    }
  }

  private static sleep(ms: number) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}