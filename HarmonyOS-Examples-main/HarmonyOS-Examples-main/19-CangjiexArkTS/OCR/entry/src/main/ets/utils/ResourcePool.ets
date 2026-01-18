import { hilog } from "@kit.PerformanceAnalysisKit";

export class ResourcePool<T> {
  private queue: T[] = [];
  private isProcessing = false;
  private processor: (element: T) => Promise<void>;

  log(message: string) {
    hilog.info(0, "ResourcePool", message);
  }

  constructor(processor: (element: T) => Promise<void>) {
    this.processor = processor;
  }

  addElement(element: T): void {
    this.queue.push(element);
    this.log(`after added, there are ${this.queue.length} tasks`)
    if (!this.isProcessing) {
      this.log("start to process tasks...");
      this.processQueue();
    }
  }

  private async processQueue(): Promise<void> {
    this.isProcessing = true;
    while (this.queue.length > 0) {
      this.log(`there are ${this.queue.length} tasks`)
      const element = this.queue.shift()!;
      try {
        await this.processor(element);
      } catch (error) {
        console.error(`Error processing element ${element}:`, error);
      }
    }
    this.log("finished all tasks, waiting...");
    this.isProcessing = false;
  }
}
