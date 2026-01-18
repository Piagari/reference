/*
 * 决策树模板
 * */
export abstract class AbstractStrategyRouter<T, D, R> {

  public abstract get(requestParams: T, dynamicContext: D): AbstractStrategyRouter<T, D, R> | null;

  public abstract apply(requestParams: T, dynamicContext: D): Promise<R | null>;

  public async router(requestParam: T, dynamicContext: D): Promise<R | null> {
    let nextRouter: AbstractStrategyRouter<T, D, R> | null = this.get(requestParam, dynamicContext);
    if (nextRouter != null) {
      return await nextRouter.apply(requestParam, dynamicContext);
    }
    return null;
  }
}