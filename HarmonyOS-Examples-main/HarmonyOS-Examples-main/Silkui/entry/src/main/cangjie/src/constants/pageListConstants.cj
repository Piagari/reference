/**
 * Created on 2024/11/15
 */
package ohos_app_cangjie_entry.constants

public class PageListConstants {
    public static let items: Array<PageItem> = [
        PageItem("单元格", "CellPage"),
        PageItem("折叠面板", "CollapsePage"),
        PageItem("toast", "Toast"),
        PageItem("loading", "LoadingPage"),
        PageItem("Button", "ButtonPage"),
        PageItem("高亮文本", "HighLightPage"),
        PageItem("徽标", "BadgePage"),
        PageItem("Dialog", "DialogPage"),
        PageItem("Popup 弹出层", "PopupPage"),
        PageItem("Image 图片", "ImagePage"),
        PageItem("Rate 评分", "RatePage"),
        PageItem("Calendar 日历", "CalendarPage"),
        PageItem("ActionSheet 动作面板", "ActionSheetPage"),
        PageItem("Tabs 标签页", "TabsPage"),
        PageItem("Picker 选择器", "PickerPage")
        ]
}

public struct PageItem {
  public let title: String
  public let name: String

  public init (title: String, name: String){
        this.title = title
        this.name = name
  }
}