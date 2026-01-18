/**
 * Created on 2025/8/26
 */
package ohos_app_cangjie_entry.views

import std.time.DateTime
import std.time.Duration
import std.collection.ArrayList

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*

import ohos_app_cangjie_entry.services.*
import ohos_app_cangjie_entry.utils.appLog

@Entry
@Component
public class EntryView {
    @State var eventTitle: String = ""
    @State var eventDescription: String = ""
    @State var eventList: ObservedArrayList<EventInfo> = ObservedArrayList<EventInfo>()
    @State var isLoading: Bool = true

    @StorageProp['topRectHeight']
    let topRectHeight: Length = 0.vp

    let scroller: Scroller = Scroller()

    protected override func aboutToAppear() {
        loadEvents()
    }

    func loadEvents() {
        isLoading = true
        CalendarService.requestPermissions { granted: Bool =>
            if (granted) {
                CalendarService.getEvents() { events: ArrayList<EventInfo> =>
                    eventList.clear()
                    for (event in events) {
                        eventList.append(event)
                    }
                    isLoading = false
                }
            } else {
                appLog.warn("Permissions denied by user. Cannot load events.")
                eventList.clear()
                isLoading = false
            }
        }
    }

    func addEventToList() {
        var title: String = this.eventTitle
        if (title == "") {
            title = "默认事件"
        }
        let description: String = this.eventDescription

        this.eventTitle = ""
        this.eventDescription = ""

        CalendarService.addEvent(title, description) { id: Int64 =>
            if (id > 0) {
                appLog.info("Event added, refreshing list...")
                this.loadEvents()
            } else {
                appLog.error("Failed to add event from UI.")
            }
        }
    }

    func deleteEventFromList(eventId: Int64) {
        CalendarService.deleteEvent(eventId) { success: Bool =>
            if (success) {
                appLog.info("Event deleted, refreshing list...")
                this.loadEvents()
            } else {
                appLog.error("Failed to delete event from UI.")
            }
        }
    }

    func build() {
        Column {
            Text("日程管理演示")
                .fontSize(22)
                .width(100.percent)
                .textAlign(TextAlign.Center)
                .margin(top: 10, bottom: 20)
                .fontWeight(FontWeight.Medium)

            Column {
                Text("添加新日程")
                    .sectionTitle()

                Divider()
                    .standardDivider()

                TextInput(placeholder: "请输入日程标题", text: eventTitle)
                    .inputFieldStyle()
                    .onChange { value: String => this.eventTitle = value }

                TextInput(placeholder: "请输入日程描述", text: eventDescription)
                    .inputFieldStyle()
                    .onChange { value: String => this.eventDescription = value }

                Button("立即添加")
                    .actionButton()
                    .backgroundColor(0x007DFF)
                    .onClick { _ => addEventToList() }
            }
            .sectionCard()

            Column {
                Text("日程列表")
                    .sectionTitle()

                Divider()
                    .standardDivider()

                Column {
                    if (isLoading) {
                        Text("正在加载日程...")
                            .margin(20)
                            .height(100.percent)
                            .fontColor(Color.GRAY)
                    } else if (eventList.isEmpty()) {
                        Text("暂无日程")
                            .margin(20)
                            .height(100.percent)
                            .fontColor(Color.GRAY)
                    } else {
                        List(space: 10, scroller: scroller) {
                            ForEach(eventList, { item: EventInfo, _: Int64 =>
                                ListItem {
                                    EventListItem(item: item, onDelete: { => deleteEventFromList(item.id) })
                                }
                                .listItemStyle()
                            })
                        }
                        .width(100.percent)
                        .scrollBar(BarState.Off)
                    }
                }
                .height(49.percent)
                .width(100.percent)
            }
            .sectionCard()
        }
        .width(100.percent)
        .height(100.percent)
        .backgroundColor(0xF1F3F5)
        .padding(top: topRectHeight, bottom: 10.vp, left: 10.vp, right: 10.vp)
    }
}
